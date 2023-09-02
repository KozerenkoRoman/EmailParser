unit DebugWriter;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.Classes, Vcl.Forms, System.SysUtils, System.Variants, System.IOUtils, Vcl.Graphics,
  System.DateUtils, System.Threading, Utils.VerInfo, Utils.LocalInformation, Html.Lib, Html.Consts, XmlFiles,
  System.Types, Common.Types, System.Generics.Collections, Global.Resources;
{$ENDREGION}

type
  TFileWriter = class(TThread)
  private
    FQueue: TThreadedQueue<string>;
    FFileName: TFileName;
    function GetSize: Int64;
    procedure SetFileName(const Value: TFileName);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Size     : Int64   read GetSize;
    property LogQueue : TThreadedQueue<string> read FQueue;
    property FileName : TFileName read FFileName write SetFileName;
  end;

  TLogWriter = class
  private const
    C_FOLDER_LOG     : string = 'log\';
    C_CHAR_ENTER     : Char = #13;
    C_CHAR_LINE_FEED : Char = #10;
  private
    FBaseFileName     : string;
    FCountFiles       : Integer;
    FCountOfDays      : Integer;
    FFileWriter       : TFileWriter;
    FIsExistHtmlOpen  : Boolean;
    FLineCount        : Integer;
    FMaxSize          : Int64;
    function GetActive: Boolean;
    function GetDebugFileName: string;
    function GetLineCount: Integer;
    function GetLog(const aFileName: string = ''): string;
    function GetLogFileName: TFileName;
    procedure CheckSize;
    procedure DeleteOldFiles;
    procedure Finish;
    procedure RestoreStartParams;
    procedure SetActive(const aValue: Boolean);
    procedure Start;
    procedure WriteFileInfo;
    procedure WriteHtm(const aDetailType: TLogDetailType; aUnit, aClassName, aMethod, aInfo: string); inline;
    procedure WriteText(const aInfo: string);

    property LineCount: Integer read GetLineCount write FLineCount;
  private const
    C_TABLE_TD_TAG     = '<TD class="%s"></TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
    C_TABLE_ERROR_TAG  = '<TR class="err">' + C_TABLE_TD_TAG;
    C_TABLE_METHOD_TAG = '<TR class="met">' + C_TABLE_TD_TAG;
    C_TABLE_OBJECT_TAG = '<TR class="obj">' + C_TABLE_TD_TAG;
    C_TABLE_TEXT_TAG   = '<TR class="txt">' + C_TABLE_TD_TAG;
    C_TABLE_WARN_TAG   = '<TR class="warn">' + C_TABLE_TD_TAG;
  public const
    C_IMG_ENTER_HTM = 'img-enter';
    C_IMG_ERROR_HTM = 'img-err';
    C_IMG_EXIT_HTM  = 'img-exit';
    C_DATE_FORMAT   = 'DD.MM.YYYY hh:mm:ss.zzz';

    C_CFG_COUNT_OF_DAYS = 'CountOfDays';
    C_CFG_KEY_IS_START  = 'IsStartDebug';
    C_CFG_KEY_MAX_SIZE  = 'MaxSizeOFFileWriter';
    C_CFG_SECTION_DEBUG = 'Debug';
  public
    constructor Create;
    destructor Destroy; override;

    procedure Write(const aDetailType: TLogDetailType; const aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aMethod, aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aMethod, aUnit, aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aObject: TObject; const aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aObject: TObject; const aMethod, aInfo: string); overload;

    property LogFileName : TFileName read GetLogFileName;
    property Active      : Boolean   read GetActive    write SetActive;
    property CountOfDays : Integer   read FCountOfDays write FCountOfDays default 30;    //Number of days during which logs are stored
    property MaxSize     : Int64     read FMaxSize     write FMaxSize     default 2;     //Maximum log file size(MB). When <0 do not control
  end;

var
  LogWriter : TLogWriter;

implementation

{ TLogWriter }

constructor TLogWriter.Create;
begin
  inherited;
  FCountFiles       := 1;
  FIsExistHtmlOpen  := False;
  FCountOfDays      := 30;
  FBaseFileName     := GetLog(TPath.GetFileNameWithoutExtension(Application.ExeName) +
                              FormatDateTime('_yyyy.mm.dd hh.nn.ss', Now) +
                              '_part_%d.html').ToLower;
  RestoreStartParams;
  Start;
  if Active then
  begin
    WriteFileInfo;
    DeleteOldFiles;
  end;
end;

destructor TLogWriter.Destroy;
begin
  FFileWriter.Terminate;
  if Assigned(FFileWriter) then
    FreeAndNil(FFileWriter);
  inherited;
end;

procedure TLogWriter.DeleteOldFiles;
begin
  TTask.Create(
    procedure()
    begin
      TThread.NameThreadForDebugging('TLogWriter.DeleteOldFiles');
      for var ItemName in TDirectory.GetFiles(GetLog, '*.html', TSearchOption.soAllDirectories) do
      begin
        if (DaysBetween(Now, TFile.GetCreationTime(ItemName)) >= CountOfDays) then
          try
            TFile.Delete(ItemName);
          except
          end;
      end;
    end).Start;
end;

procedure TLogWriter.WriteFileInfo;
var
  loVersionInfo : TVersionInfo;
  sHostName     : string;
  sIP           : string;
  sText         : string;
  sModuleName   : string;
begin
  sText       := '';
  sModuleName := Application.ExeName;
  TLocalInformationDialog.GetLocalIPAddressName(sIP, sHostName);
  loVersionInfo := TVersionInfo.Create(sModuleName);
  try
    sText := Concat(C_HTML_LINE + '<pre>',
                    THtmlLib.GetBoldText('Module              : '), sModuleName,                                                C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module version      : '), loVersionInfo.FileVersion, '.', loVersionInfo.FileBuild,    C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module architecture : '), loVersionInfo.Architecture,                                 C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module date         : '), DateToStr(loVersionInfo.ModuleDate),                        C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module size         : '), FormatFloat('### ### ### bytes', loVersionInfo.ModuleSize), C_HTML_BREAK,
                    THtmlLib.GetBoldText('Local IP-address    : '), sIP, ' (', sHostName, ')',                                  C_HTML_BREAK,
                    THtmlLib.GetBoldText('Windows version     : '), TLocalInformationDialog.GetWindowsVersion,                  C_HTML_BREAK,
                    THtmlLib.GetBoldText('Windows user        : '), TLocalInformationDialog.GetUserFromWindows,                 C_HTML_BREAK,
                    THtmlLib.GetBoldText('Compiler version    : '), CompilerVersion.ToString,                                   C_HTML_BREAK,
                    '</pre>' + C_HTML_LINE);
    WriteHtm(ddText, C_HTML_NBSP, C_HTML_NBSP, C_HTML_NBSP, sText);
  finally
    FreeAndNil(loVersionInfo);
  end;
end;

procedure TLogWriter.RestoreStartParams;
var
  loXmlFile : TXmlFile;
begin
  loXmlFile := TXmlFile.Create(GetEnvironmentVariable('USERPROFILE') + '\' + C_XML_PARAMS_FILE);
  try
    loXmlFile.UsedAttributes := [uaCodeType, uaValue, uaComment];
    FMaxSize     := loXmlFile.ReadInt64(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE, 2) * 1024 * 1024;
    FCountOfDays := loXmlFile.ReadInteger(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS, 30);
    if not loXmlFile.ValueExists(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE) then
      loXmlFile.WriteInt64(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE, FMaxSize, 'Max Size Of Log File (Mb)');
    if not loXmlFile.ValueExists(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS) then
      loXmlFile.WriteInteger(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS, FCountOfDays, 'Number of days during which logs are stored');
  finally
    FreeAndNil(loXmlFile);
  end;
end;

function TLogWriter.GetActive: Boolean;
begin
  if Assigned(FFileWriter) then
    Result := FFileWriter.Started
  else
    Result := False;
end;

procedure TLogWriter.WriteText(const aInfo: string);
begin
  if Active then
  begin
    CheckSize;
    FFileWriter.LogQueue.PushItem(aInfo);
  end;
end;

procedure TLogWriter.Start;
var
  sText : string;
begin
  if not Assigned(FFileWriter) then
  begin
    FFileWriter := TFileWriter.Create;
    FFileWriter.FileName := GetDebugFileName;
    FFileWriter.Start;
    Sleep(10);
  end;
  if not FIsExistHtmlOpen then
  begin
    FIsExistHtmlOpen := True;
    sText := Concat(C_HTML_OPEN,
                    C_HTML_HEAD_OPEN,
                    C_STYLE,
                    C_HTML_HEAD_CLOSE,
                    THtmlLib.GetTableTag(VarArrayOf([C_HTML_NBSP,
                                                      'Line &#8470;',
                                                      'Time',
                                                      'Unit name',
                                                      'Class name',
                                                      'Method name',
                                                      'Description'])));
    WriteText(sText);
  end
  else
    WriteText(THtmlLib.GetColorTag(THtmlLib.GetBoldText('Log session already started'), clNavy));
end;

procedure TLogWriter.Finish;
var
  sText : string;
begin
  if Assigned(FFileWriter) and FFileWriter.Started then
  begin
    sText := Concat(C_HTML_TABLE_CLOSE,
                    THtmlLib.GetColorTag(THtmlLib.GetBoldText('Log session finished'), clNavy),
                    C_HTML_CLOSE);
    WriteText(sText);
  end;
end;

procedure TLogWriter.SetActive(const aValue: Boolean);
begin
  if aValue then
    Start
  else
    Finish;
end;

function TLogWriter.GetDebugFileName: string;
begin
  Result := Format(FBaseFileName, [FCountFiles]);
end;

function TLogWriter.GetLineCount: Integer;
begin
  Inc(FLineCount);
  if (FLineCount >= 1000000) then
   FLineCount := 1;
  Result := FLineCount;
end;

function TLogWriter.GetLog(const aFileName: string): string;
var
  Path: string;
begin
  Path := TPath.Combine(TPath.GetDirectoryName(Application.ExeName), C_FOLDER_LOG);
  if (ExtractFileDrive(Path) <> '') and (not TDirectory.Exists(Path)) then
    try
      ForceDirectories(Path);
    except
      raise Exception.Create(Format('Do not create folder [%s].', [Path]));
    end;
  Result := TPath.Combine(Path, aFileName);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, C_HTML_NBSP, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aMethod, aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aMethod, aUnit, aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aObject: TObject; const aMethod, aInfo: string);
var
  ClassName: string;
begin
  if Assigned(aObject) then
    ClassName := aObject.ClassName
  else
    ClassName := C_HTML_NBSP;
  WriteHtm(aDetailType, C_HTML_NBSP, ClassName, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aObject: TObject; const aInfo: string);
var
  ClassName: string;
begin
  if Assigned(aObject) then
    ClassName := aObject.ClassName
  else
    ClassName := C_HTML_NBSP;
  WriteHtm(aDetailType, C_HTML_NBSP, ClassName, C_HTML_NBSP, aInfo);
end;

procedure TLogWriter.WriteHtm(const aDetailType: TLogDetailType; aUnit, aClassName, aMethod, aInfo: string);
begin
  if Active then
  begin
    CheckSize;
    if aUnit.IsEmpty then
      aUnit := C_HTML_NBSP;
    if aClassName.IsEmpty then
      aClassName := C_HTML_NBSP;
    if aMethod.IsEmpty then
      aMethod := C_HTML_NBSP;
    if aInfo.IsEmpty then
      aInfo := C_HTML_NBSP;

    if (aDetailType = ddError) then
      aInfo := aInfo.Replace('\n', C_HTML_BREAK);

    aInfo := aInfo.Replace(sLineBreak, C_HTML_BREAK).Replace(C_CHAR_ENTER, C_HTML_BREAK).Replace(C_CHAR_LINE_FEED, C_HTML_BREAK);
    case aDetailType of
      ddEnterMethod:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_METHOD_TAG, [C_IMG_ENTER_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddExitMethod:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_METHOD_TAG, [C_IMG_EXIT_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddError:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_ERROR_TAG, [C_IMG_ERROR_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddText:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_TEXT_TAG, ['', Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddWarning:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_WARN_TAG, ['', Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
    end;
  end;
end;

procedure TLogWriter.CheckSize;
const
  C_TAG_LINK = '<br><a href="%s">Next log file</a>';
var
  sNewFileName: string;
begin
  if (MaxSize > 0) and (FFileWriter.Size >= MaxSize) then
  begin
    FIsExistHtmlOpen := False;
    Inc(FCountFiles);
    sNewFileName := GetDebugFileName;
    FFileWriter.LogQueue.PushItem(Concat(C_HTML_TABLE_CLOSE, Format(C_TAG_LINK, [sNewFileName]), C_HTML_CLOSE));
    FFileWriter.FileName := sNewFileName;
    Self.Start;
  end;
end;

function TLogWriter.GetLogFileName: TFileName;
begin
  if Assigned(FFileWriter) then
    Result := FFileWriter.FileName;
end;

{ TFileWriter }

constructor TFileWriter.Create;
begin
  inherited Create(True);
  Priority := tpLowest;
  FQueue := TThreadedQueue<string>.Create(1000);
end;

destructor TFileWriter.Destroy;
begin
  FQueue.DoShutDown;
  FreeAndNil(FQueue);
  inherited;
end;

procedure TFileWriter.Execute;
var
  WaitResult: TWaitResult;
  LogText: string;
begin
  inherited;
  TThread.NameThreadForDebugging('TFileWriter');
  TFile.WriteAllBytes(FFileName, TEncoding.UTF8.GetPreamble);
  try
    while not Terminated do
    begin
      WaitResult := FQueue.PopItem(LogText);
      if (WaitResult = TWaitResult.wrSignaled) then
        if not(LogText.IsEmpty) then
          TFile.AppendAllText(FFileName, LogText);
    end;
  except

  end;
end;

function TFileWriter.GetSize: Int64;
begin
  Result := TFile.GetSize(FileName);
end;

procedure TFileWriter.SetFileName(const Value: TFileName);
begin
  FFileName := Value;
end;

initialization
  if not Assigned(LogWriter) and not System.IsLibrary then
    LogWriter := TLogWriter.Create;

finalization
//  if Assigned(LogWriter) then
//    FreeAndNil(LogWriter);

end.
