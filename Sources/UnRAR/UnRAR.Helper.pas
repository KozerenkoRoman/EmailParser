unit UnRAR.Helper;

interface

{$REGION 'Region uses'}
uses
  System.AnsiStrings, Winapi.Windows, System.SysUtils, System.IOUtils, UnRAR;
{$ENDREGION}

type
  TRarErrorEvent = procedure(Sender: TObject; const aMessage: string; const aMessageID: Integer) of object;
  TRarPromptPassEvent = procedure(Sender: TObject; var aPassword: string) of object;

  TUnRAR = class
  private type
    TCyrillicString = type AnsiString(21866); // ISO-8859-5
  private const
    MODE_EXTRACT : Byte = 0;
    MODE_TEST    : Byte = 1;
    MODE_PRINT   : Byte = 2;

    UCM_CHANGEVOLUME = 0;
    UCM_PROCESSDATA  = 1;
    UCM_NEEDPASSWORD = 2;
    UCM_BADDATA      = 3;
  class var
    FSelf: Pointer;
  private
    FArcInfo        : RARInfoData;
    FArcName        : string;
    FDestPath       : string;
    FLastError      : Integer;
    FOnError        : TRarErrorEvent;
    FOnPassword     : TRarPromptPassEvent;
    FPassword       : string;
    FStopProcessing : Boolean;
    function DoUnRarCallBack(msg: UINT; UserData, P1, P2: LPARAM): LPARAM; stdcall;
    function GetArcInfo(const aOpenArchiveData : RAROpenArchiveDataEx): RARInfoData;
    function GetHandle(const aMode: Byte): THandle;
    procedure DoError(const aMessageID: Integer);
  public
    constructor Create(const aArcName: string);
    destructor Destroy; override;

    function ExtractAll: TArray<string>;
    function GetErrorText(const aError: Integer): string;
    function GetFileList: TArray<string>;
    procedure Extract(const aFileName: string);

    class function IsUnRARExists: Boolean;
    property ArcInfo        : RARInfoData         read FArcInfo;
    property DestPath       : string              read FDestPath       write FDestPath;
    property LastError      : Integer             read FLastError;
    property OnError        : TRarErrorEvent      read FOnError        write FOnError;
    property OnPassword     : TRarPromptPassEvent read FOnPassword     write FOnPassword;
    property Password       : string              read FPassword       write FPassword;
    property StopProcessing : Boolean             read FStopProcessing write FStopProcessing;
  end;

implementation

function CallbackProc(msg: UINT; UserData, P1, P2: LPARAM): LPARAM; stdcall;
begin
  Result := TUnRAR(TUnRAR.FSelf).DoUnRarCallBack(msg, UserData, P1, P2);
end;

function TUnRAR.DoUnRarCallBack(msg: UINT; UserData, P1, P2: LPARAM): LPARAM; stdcall;
var
  PwdString : string;
  UnRarRef  : TUnRAR;
begin
  // >= 0 => Weiter, -1 => Stop
  Result := 0;
  UnRarRef := TUnRAR.FSelf;
  case msg of
    UCM_BADDATA:
      Result := -1;
    UCM_CHANGEVOLUME:
      Result := 0;
    UCM_NEEDPASSWORD:
      begin
        PwdString := UnRarRef.Password;
        if Assigned(UnRarRef.OnPassword) then
          UnRarRef.OnPassword(UnRarRef, PwdString);
        if not PwdString.IsEmpty then
        begin
          var Buf := TEncoding.ASCII.GetBytes(PwdString);
          Move(Pointer(Buf)^, Pointer(P1)^, Length(Buf) + 1);
          Result := 1;
        end;
      end;
    UCM_PROCESSDATA:
      begin
        if UnRarRef.StopProcessing then
          Result := -1
        else
          Result := 0;
      end;
  end;
end;

constructor TUnRAR.Create(const aArcName: string);
begin
  FSelf := Self;
  FStopProcessing := False;
  FArcName := aArcName;
  UniqueString(FArcName);
end;

destructor TUnRAR.Destroy;
begin

  inherited;
end;

function TUnRAR.GetHandle(const aMode: Byte): THandle;
var
  CmtBuf: array [0 .. Pred(16384)] of AnsiChar;
  OpenArchiveData : RAROpenArchiveDataEx;
begin
  ZeroMemory(@OpenArchiveData, SizeOf(OpenArchiveData));
  OpenArchiveData.ArcNameW   := PWideChar(FArcName);
  OpenArchiveData.CmtBuf     := @CmtBuf;
  OpenArchiveData.CmtBufSize := SizeOf(CmtBuf);
  OpenArchiveData.OpenMode   := aMode;
  Result := RAROpenArchiveEx(OpenArchiveData);
  FArcInfo := GetArcInfo(OpenArchiveData);
  FArcInfo.IsNeedPassword := False;

  if (OpenArchiveData.OpenResult <> ERAR_SUCCESS) then
  begin
    Result := 0;
    DoError(OpenArchiveData.OpenResult);
  end;
end;

function TUnRAR.GetFileList: TArray<string>;
var
  CmtBuf: array [0 .. Pred(16384)] of AnsiChar;
  HeaderData     : RARHeaderDataEx;
  hHandle        : THandle;
  hProcessHeader : Integer;
  hReadHeader    : Integer;
begin
  hHandle := GetHandle(RAR_OM_LIST);
  if (hHandle <> 0) then
    try
      RARSetCallback(hHandle, CallbackProc, 0);
      HeaderData.CmtBuf := @CmtBuf;
      HeaderData.CmtBufSize := SizeOf(CmtBuf);
      hProcessHeader := 0;

      if not FPassword.IsEmpty then
      begin
        var Buf := TEncoding.Default.GetBytes(FPassword);
        RARSetPassword(hHandle, Pointer(Buf));
      end;

      repeat
        hReadHeader := RARReadHeaderEx(hHandle, HeaderData);
        if (hReadHeader = ERAR_END_ARCHIVE) then
          Break
        else if (hReadHeader = ERAR_BAD_DATA) then
        begin
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader in [ERAR_INCORRECT_PWD, ERAR_NEED_PASSWORD]) then
        begin
          FArcInfo.IsNeedPassword := True;
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader = ERAR_SUCCESS) then
        begin
          FArcInfo.IsNeedPassword := FArcInfo.IsNeedPassword or ((HeaderData.Flags and $00000004) = $00000004);
          if ((HeaderData.FileAttr and $20) = $20) and (hProcessHeader = ERAR_SUCCESS) then
          begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)] := HeaderData.FileNameW;
          end;
          hProcessHeader := RARProcessFile(hHandle, RAR_SKIP, nil, nil);
        end;
      until (hProcessHeader <> ERAR_SUCCESS);

      if (hProcessHeader <> ERAR_SUCCESS) then
        DoError(hProcessHeader);
    finally
      RARCloseArchive(hHandle);
    end;
end;

function TUnRAR.ExtractAll: TArray<string>;
var
  CmtBuf: array [0 .. Pred(16384)] of AnsiChar;
  DestAnsi       : TCyrillicString;
  HeaderData     : RARHeaderDataEx;
  hHandle        : THandle;
  hProcessHeader : Integer;
  hReadHeader    : Integer;
begin
  hHandle := GetHandle(RAR_OM_EXTRACT);
  if (hHandle <> 0) then
    try
      RARSetCallback(hHandle, CallbackProc, 0);
      SetLength(DestAnsi, Length(FDestPath));
      CharToOemBuff(PWideChar(FDestPath), PAnsiChar(DestAnsi), Length(FDestPath));

      if not FPassword.IsEmpty then
      begin
        var Buf := TEncoding.Default.GetBytes(FPassword);
        RARSetPassword(hHandle, Pointer(Buf));
      end;

      HeaderData.CmtBuf := @CmtBuf;
      HeaderData.CmtBufSize := SizeOf(CmtBuf);
      hProcessHeader := 0;
      repeat
        hReadHeader := RARReadHeaderEx(hHandle, HeaderData);
        if (hReadHeader = ERAR_END_ARCHIVE) then
          Break
        else if (hReadHeader = ERAR_BAD_DATA) then
        begin
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader in [ERAR_INCORRECT_PWD, ERAR_NEED_PASSWORD]) then
        begin
          FArcInfo.IsNeedPassword := True;
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader = ERAR_SUCCESS) then
        begin
          hProcessHeader := RARProcessFile(hHandle, RAR_EXTRACT, PAnsiChar(DestAnsi), nil);
          FArcInfo.IsNeedPassword := FArcInfo.IsNeedPassword or ((HeaderData.Flags and $00000004) = $00000004);
          if ((HeaderData.FileAttr and $20) = $20) and (hProcessHeader = ERAR_SUCCESS) then
          begin
            SetLength(Result, Length(Result) + 1);
            Result[High(Result)] := TPath.Combine(FDestPath, HeaderData.FileNameW);
          end;
        end;
      until (hProcessHeader <> ERAR_SUCCESS);

      if (hProcessHeader <> ERAR_SUCCESS) then
        DoError(hProcessHeader);
    finally
      RARCloseArchive(hHandle);
    end;
end;

procedure TUnRAR.Extract(const aFileName: string);
var
  CmtBuf: array [0 .. Pred(16384)] of AnsiChar;
  DestAnsi       : TCyrillicString;
  HeaderData     : RARHeaderDataEx;
  hHandle        : THandle;
  hProcessHeader : Integer;
  hReadHeader    : Integer;
begin
  hHandle := GetHandle(RAR_OM_EXTRACT);
  if (hHandle <> 0) then
    try
      RARSetCallback(hHandle, CallbackProc, 0);
      SetLength(DestAnsi, Length(FDestPath));
      CharToOemBuff(PWideChar(FDestPath), PAnsiChar(DestAnsi), Length(FDestPath));

      if not FPassword.IsEmpty then
      begin
        var Buf := TEncoding.Default.GetBytes(FPassword);
        RARSetPassword(hHandle, Pointer(Buf));
      end;

      HeaderData.CmtBuf := @CmtBuf;
      HeaderData.CmtBufSize := SizeOf(CmtBuf);
      hProcessHeader := 0;
      repeat
        hReadHeader := RARReadHeaderEx(hHandle, HeaderData);
        if (hReadHeader = ERAR_END_ARCHIVE) then
          Break
        else if (hReadHeader = ERAR_BAD_DATA) then
        begin
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader in [ERAR_INCORRECT_PWD, ERAR_NEED_PASSWORD]) then
        begin
          FArcInfo.IsNeedPassword := True;
          DoError(hReadHeader);
          Exit;
        end
        else if (hReadHeader = ERAR_SUCCESS) then
        begin
          FArcInfo.IsNeedPassword := FArcInfo.IsNeedPassword or ((HeaderData.Flags and $00000004) = $00000004);
          if aFileName.Equals(HeaderData.FileNameW) then
          begin
            hProcessHeader := RARProcessFile(hHandle, RAR_EXTRACT, PAnsiChar(DestAnsi), nil);
            Break;
          end
          else
            hProcessHeader := RARProcessFile(hHandle, RAR_TEST, PAnsiChar(DestAnsi), nil);
        end;
      until (hProcessHeader <> ERAR_SUCCESS);

      if (hProcessHeader <> ERAR_SUCCESS) then
        DoError(hProcessHeader);
    finally
      RARCloseArchive(hHandle);
    end;
end;

function TUnRAR.GetArcInfo(const aOpenArchiveData : RAROpenArchiveDataEx): RARInfoData;
begin
  Result := Default (RARInfoData);
  Result.ArchiveName       := aOpenArchiveData.ArcNameW;
  Result.DictionarySize    := ((aOpenArchiveData.Flags and $00000070) shr 4) * 64 * 1024;
  Result.IsContinueNextVol := (aOpenArchiveData.Flags and $00000002) = $00000002;
  Result.IsContinuePrevVol := (aOpenArchiveData.Flags and $00000001) = $00000001;
  Result.IsCryptHeader     := (aOpenArchiveData.Flags and $00000004) = $00000004;
  Result.IsSolid           := (aOpenArchiveData.Flags and $00000010) = $00000010;
end;


function TUnRAR.GetErrorText(const aError: Integer): string;
begin
  case aError of
    ERAR_NO_MEMORY:
      Result := 'Not enough memory';
    ERAR_UNKNOWN_FORMAT:
      Result := 'Unknown archive format';
    ERAR_BAD_ARCHIVE:
      Result := FArcName + ' is not RAR archive';
    ERAR_SMALL_BUF:
      Result := 'Small buffer';
    ERAR_ECREATE:
      Result := 'File create error';
    ERAR_EOPEN:
      Result := 'Cannot open ' + FArcName;
    ERAR_ECLOSE:
      Result := 'File close error';
    ERAR_EREAD:
      Result := 'Read error';
    ERAR_EWRITE:
      Result := 'Write error';
    ERAR_BAD_DATA:
      Result := FArcName + ': archive header broken, CRC error';
    ERAR_NO_PASSWORD, ERAR_NEED_PASSWORD:
      Result := 'No password!';
    ERAR_INCORRECT_PWD:
      Result := 'Incorrect password!';
    ERAR_UNKNOWN:
      Result := 'Unknown error';
  else
    Result := string.Empty;
  end;
end;

procedure TUnRAR.DoError(const aMessageID: Integer);
begin
  FLastError := aMessageID;
  if Assigned(FOnError) then
    FOnError(Self, GetErrorText(aMessageID), aMessageID);
end;

class function TUnRAR.IsUnRARExists: Boolean;
begin
  Result := RARGetDllVersion > 0
end;

end.
