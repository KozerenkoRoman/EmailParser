unit MappedFile.Memory;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.Classes, System.SysUtils,
  MappedFile;
{$ENDREGION}

type
  TMemoryMappedFile = class(TCustomMappedFile)
  strict private
    FBuffer          : PByte;
    FCloseFileHandle : Boolean;
    FFileHandle      : THandle;
    FPosition        : UInt32;
    FReadOnly        : Boolean;
    FUnicodeMode     : Boolean;
    function GetIsGlobal: Boolean;
    function GetIsLocal: Boolean;
    function GetIsShared: Boolean;
    function OpenMappedFile(aOpenExisting: Boolean; aReadOnly: Boolean; aFileHandle: THandle; aCloseFileHandle: Boolean): Boolean;
    procedure SetIsGlobal(aValue: Boolean);
    procedure SetIsLocal(aValue: Boolean);
  const
    UNICODE_BOM: Word  = $FEFF;
    NAME_GLOBAL_PREFIX = 'Global\';
    NAME_LOCAL_PREFIX  = 'Local\';
  strict protected
    function GetIsOpen: Boolean; override;
  public
    constructor Create(const aName: string = ''; aBufferSizeDefault: UInt32 = 0);

    function Close: Boolean; override;
    function CreateUnicodeTextFile: Boolean;
    function Open(aFileHandle: THandle; aReadOnly: Boolean = False; aCloseFileHandle: Boolean = False): Boolean; overload;
    function Open(aOpenExisting: Boolean): Boolean; overload; override;
    function Open(aOpenExisting: Boolean; aReadOnly: Boolean): Boolean; overload;
    function Open(const aFileName: string; aReadOnly: Boolean = False; aResize: Boolean = False): Boolean; overload;

    function AppendUnicodeString(const aStr: string; aLength: UInt32 = 0): UInt32;
    function Read(const aBuffer: TBytes; aOffset: UInt32 = 0): UInt32; overload;
    function Read(const aStream: TMemoryStream; aSize: UInt32 = 0; aOffset: UInt32 = 0): UInt32; overload;
    function Read(var aBuffer; aSize: UInt32; aOffset: UInt32 = 0): UInt32; overload;
    function ReadMemory(aMemory: PByte; aSize: UInt32; aOffset: UInt32 = 0): UInt32;
    function TruncateAndClose(aSize: UInt32 = 0): UInt32;
    function Write(const aBuffer: TBytes; aOffset: UInt32 = 0): UInt32; overload;
    function Write(const aBuffer; aSize: UInt32; aOffset: UInt32 = 0): UInt32; overload;
    function Write(const aStream: TMemoryStream; aSize: UInt32 = 0; aOffset: UInt32 = 0): UInt32; overload;
    function WriteMemory(aMemory: PByte; aSize: UInt32; aOffset: UInt32 = 0): UInt32;

    property Buffer      : PByte   read FBuffer;
    property IsGlobal    : Boolean read GetIsGlobal write SetIsGlobal;
    property IsLocal     : Boolean read GetIsLocal  write SetIsLocal;
    property IsReadOnly  : Boolean read FReadOnly;
    property IsShared    : Boolean read GetIsShared;
    property Position    : UInt32  read FPosition;
    property UnicodeMode : Boolean read FUnicodeMode;
  end;

implementation

constructor TMemoryMappedFile.Create(const aName: string; aBufferSizeDefault: UInt32);
begin
  inherited Create(aName, aBufferSizeDefault);

end;

function TMemoryMappedFile.OpenMappedFile(aOpenExisting: Boolean; aReadOnly: Boolean; aFileHandle: THandle; aCloseFileHandle: Boolean): Boolean;
var
  aCreateAccess: UInt32;
  aLInt: TLargeInteger;
  aMapAccess: UInt32;
  aMapName: PChar;
  aSize: UInt32;
begin
  Close;
  FReadOnly := aReadOnly;
  if FReadOnly then
  begin
    aMapAccess    := FILE_MAP_READ;
    aCreateAccess := PAGE_READONLY;
  end
  else
  begin
    aMapAccess    := FILE_MAP_ALL_ACCESS;
    aCreateAccess := PAGE_READWRITE;
  end;
  aMapName := nil;
  if (FName.Length > 0) then
    aMapName := PChar(FName);
  if aOpenExisting then
  begin
    if aCloseFileHandle then
      CloseHandle(aFileHandle);
    if (aMapName <> nil) then
      FDeviceHandle := OpenFileMapping(aMapAccess, False, aMapName);
  end
  else
  begin
    if (aFileHandle = 0) then
      aFileHandle := INVALID_HANDLE_VALUE;
    if (aFileHandle = INVALID_HANDLE_VALUE) then
      aSize := FBufferSize
    else
    begin
      FCloseFileHandle := aCloseFileHandle;
      FFileHandle := aFileHandle;
      aSize := 0;
      if GetFileSizeEx(aFileHandle, aLInt) then
        FBufferSize := aLInt
      else
      begin
        Close;
        Result := False;
        Exit;
      end
    end;
    FDeviceHandle := CreateFileMapping(aFileHandle, nil, aCreateAccess, 0, aSize, aMapName);
  end;
  if (FDeviceHandle <> 0) then
  begin
    FIsClientMode := aOpenExisting or (GetLastError = ERROR_ALREADY_EXISTS);
    FBuffer := MapViewOfFile(FDeviceHandle, aMapAccess, 0, 0, 0);
    if (FBuffer = nil) then
      Close;
  end;
  Result := GetIsOpen;
  if not Result then
    Close;
end;

function TMemoryMappedFile.Open(aOpenExisting: Boolean): Boolean;
begin
  Result := OpenMappedFile(aOpenExisting, False, 0, False);
end;

function TMemoryMappedFile.Open(aOpenExisting: Boolean; aReadOnly: Boolean): Boolean;
begin
  Result := OpenMappedFile(aOpenExisting, aReadOnly, 0, False);
end;

function TMemoryMappedFile.Open(aFileHandle: THandle; aReadOnly: Boolean; aCloseFileHandle: Boolean): Boolean;
begin
  Result := OpenMappedFile(False, aReadOnly, aFileHandle, aCloseFileHandle);
end;

function TMemoryMappedFile.Open(const aFileName: string; aReadOnly, aResize: Boolean): Boolean;
var
  aFileHandle: THandle;
  aCreateAccess: UInt32;
  aFileExists: Boolean;
begin
  Result := False;
  aFileExists := FileExists(aFileName);
  aReadOnly := aReadOnly and aFileExists;
  aCreateAccess := GENERIC_READ;
  if not aReadOnly then
    aCreateAccess := aCreateAccess or GENERIC_WRITE;
  aFileHandle := CreateFile(PChar(aFileName), aCreateAccess, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (aFileHandle <> INVALID_HANDLE_VALUE) then
  begin
    aFileExists := GetLastError = ERROR_ALREADY_EXISTS;
    aResize := not aReadOnly and (aResize or not aFileExists);
    if aResize and SetFilePointerEx(aFileHandle, FBufferSize, nil, FILE_BEGIN) then
      SetEndOfFile(aFileHandle);
    Result := OpenMappedFile(False, aReadOnly, aFileHandle, True);
  end;
end;

function TMemoryMappedFile.Close: Boolean;
begin
  if (FBuffer <> nil) then
  begin
    UnmapViewOfFile(FBuffer);
    FBuffer := nil;
  end;
  Result := inherited Close;
  if FCloseFileHandle and (FFileHandle <> 0) and (FFileHandle <> INVALID_HANDLE_VALUE) then
  begin
    if FUnicodeMode and SetFilePointerEx(FFileHandle, FPosition, nil, FILE_BEGIN) then
      SetEndOfFile(FFileHandle);
    CloseHandle(FFileHandle);
  end;
  FFileHandle      := 0;
  FCloseFileHandle := False;
  FReadOnly        := False;
  FBufferSize      := FBufferSizeDefault;
  FUnicodeMode     := False;
  FPosition        := 0;
end;

function TMemoryMappedFile.CreateUnicodeTextFile: Boolean;
begin
  Result := not FUnicodeMode and not FReadOnly and GetIsOpen;
  if Result then
    FUnicodeMode := True;
end;

function TMemoryMappedFile.GetIsGlobal: Boolean;
begin
  Result := FName.StartsWith(NAME_GLOBAL_PREFIX, True);
end;

procedure TMemoryMappedFile.SetIsGlobal(aValue: Boolean);
var
  aCur: Boolean;
begin
  if (FName.Length > 0) then
  begin
    aCur := GetIsGlobal;
    if aCur xor aValue then
    begin
      if aValue then
      begin
        if GetIsLocal then
          Delete(FName, 1, Length(NAME_LOCAL_PREFIX));
        FName := NAME_GLOBAL_PREFIX + FName
      end
      else
        Delete(FName, 1, Length(NAME_GLOBAL_PREFIX))
    end
  end;
end;

function TMemoryMappedFile.GetIsLocal: Boolean;
begin
  Result := FName.StartsWith(NAME_LOCAL_PREFIX, True);
end;

procedure TMemoryMappedFile.SetIsLocal(aValue: Boolean);
var
  aCur: Boolean;
begin
  if FName.Length > 0 then
  begin
    aCur := GetIsLocal;
    if aCur xor aValue then
    begin
      if aValue then
      begin
        if GetIsGlobal then
          Delete(FName, 1, Length(NAME_GLOBAL_PREFIX));
        FName := NAME_LOCAL_PREFIX + FName
      end
      else
        Delete(FName, 1, Length(NAME_LOCAL_PREFIX))
    end
  end;
end;

function TMemoryMappedFile.GetIsOpen: Boolean;
begin
  Result := inherited GetIsOpen and (FBuffer <> nil);
end;

function TMemoryMappedFile.GetIsShared: Boolean;
begin
  Result := GetIsOpen and FIsClientMode;
end;

function TMemoryMappedFile.WriteMemory(aMemory: PByte; aSize: UInt32; aOffset: UInt32): UInt32;
var
  aDest: PByte;
begin
  Result := 0;
  if not FReadOnly and GetIsOpen and Assigned(aMemory) and (aSize > 0) and (aOffset < FBufferSize) then
  begin
    if aSize + aOffset > FBufferSize then
      aSize := FBufferSize - aOffset;
    aDest := FBuffer;
    Inc(aDest, aOffset);
    CopyMemory(aDest, aMemory, aSize);
    Result := aSize;
  end;
end;

function TMemoryMappedFile.ReadMemory(aMemory: PByte; aSize: UInt32; aOffset: UInt32): UInt32;
var
  aDest: PByte;
begin
  Result := 0;
  if GetIsOpen and Assigned(aMemory) and {(aSize > 0) and} (aOffset < FBufferSize) then
  begin
    if (aSize + aOffset > FBufferSize) then
      aSize := FBufferSize - aOffset;
    aDest := FBuffer;
    Inc(aDest, aOffset);
    CopyMemory(aMemory, aDest, aSize);
    Result := aSize;
  end;
end;

function TMemoryMappedFile.Write(const aBuffer; aSize: UInt32; aOffset: UInt32): UInt32;
var
  aDest: PByte;
begin
  Result := 0;
  if not FReadOnly and GetIsOpen and (aSize > 0) and (aOffset < FBufferSize) then
  begin
    if aSize + aOffset > FBufferSize then
      aSize := FBufferSize - aOffset;
    aDest := FBuffer;
    Inc(aDest, aOffset);
    Move(aBuffer, aDest^, aSize);
    Result := aSize;
  end;
end;

function TMemoryMappedFile.Read(var aBuffer; aSize: UInt32; aOffset: UInt32): UInt32;
var
  aDest: PByte;
begin
  Result := 0;
  if GetIsOpen and (aSize > 0) and (aOffset < FBufferSize) then
  begin
    if aSize + aOffset > FBufferSize then
      aSize := FBufferSize - aOffset;
    aDest := FBuffer;
    Inc(aDest, aOffset);
    Move(aDest^, aBuffer, aSize);
    Result := aSize;
  end;
end;

function TMemoryMappedFile.Write(const aBuffer: TBytes; aOffset: UInt32): UInt32;
var
  aSize: UInt32;
begin
  Result := 0;
  aSize := Length(aBuffer);
  if aSize > 0 then
    Result := Write(aBuffer[0], aSize, aOffset);
end;

function TMemoryMappedFile.Read(const aBuffer: TBytes; aOffset: UInt32): UInt32;
var
  aSize: UInt32;
begin
  Result := 0;
  aSize := Length(aBuffer);
  if (aSize > 0) then
//  Result := ReadMemory(@aBuffer, aSize, aOffset);
    Result := Read(aBuffer[0], aSize, aOffset);
end;

function TMemoryMappedFile.Write(const aStream: TMemoryStream; aSize: UInt32; aOffset: UInt32): UInt32;
begin
  Result := 0;
  if not FReadOnly and Assigned(aStream) then
  begin
    if (aSize = 0) or (aSize > aStream.Size) then
      aSize := aStream.Size;
    Result := WriteMemory(aStream.Memory, aSize, aOffset);
  end;
end;

function TMemoryMappedFile.Read(const aStream: TMemoryStream; aSize: UInt32; aOffset: UInt32): UInt32;
begin
  Result := 0;
  if Assigned(aStream) then
  begin
    if (aSize = 0) or (aSize > aStream.Size) then
      aSize := aStream.Size;
    Result := ReadMemory(aStream.Memory, aSize, aOffset);
  end;
end;

function TMemoryMappedFile.AppendUnicodeString(const aStr: string; aLength: UInt32): UInt32;
var
  aLen, aWritten: UInt32;
begin
  Result := 0;
  aLen := Length(aStr);
  if FUnicodeMode and (aLen > 0) then
  begin
    if (aLength = 0) or (aLength > aLen) then
      aLength := aLen;
    if FPosition = 0 then
    begin
      aWritten := Write(UNICODE_BOM, SizeOf(UNICODE_BOM), FPosition);
      Inc(Result, aWritten);
      Inc(FPosition, aWritten);
    end;
    aWritten := Write(aStr[1], aLength * SizeOf(Char), FPosition);
    Inc(Result, aWritten);
    Inc(FPosition, aWritten);
  end;
end;

function TMemoryMappedFile.TruncateAndClose(aSize: UInt32): UInt32;
var
  aNewSize: TLargeInteger;
begin
  Result := 0;
  if (FFileHandle <> 0) and (FFileHandle <> INVALID_HANDLE_VALUE) then
  begin
    if (aSize = 0) and FUnicodeMode then
      aSize := FPosition
    else if (aSize = 0) or (aSize > FBufferSize) then
      aSize := FBufferSize;
    aNewSize := 0;
    if SetFilePointerEx(FFileHandle, aSize, @aNewSize, FILE_BEGIN) and SetEndOfFile(FFileHandle) then
    begin
      FBufferSize := aNewSize;
      Result := FBufferSize;
      FUnicodeMode := False;
      Close;
    end;
  end;
end;

end.
