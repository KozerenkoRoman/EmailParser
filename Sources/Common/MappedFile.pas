unit MappedFile;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows;
{$ENDREGION}

type
  TCustomMappedFile = class abstract
  private const
    BUFFER_SIZE_DEFAULT = 1024 * 1024;
    BUFFER_SIZE_MINIMAL = 1024;
  strict protected
    FBufferSize        : UInt32;
    FBufferSizeDefault : UInt32;
    FDeviceHandle      : THandle;
    FIsClientMode      : Boolean;
    FName              : string;
    function CloseDevice: Boolean;
    function GetIsOpen: Boolean; virtual;
    procedure SetBufferSize(aValue: UInt32); virtual;
    procedure SetName(const aValue: string); virtual;
  public
    constructor Create(const aName: string; aBufferSizeDefault: UInt32);
    destructor Destroy; override;

    function Open(aOpenExisting: Boolean): Boolean; overload; virtual; abstract;
    function Close: Boolean; virtual;

    property BufferSize   : UInt32  read FBufferSize write SetBufferSize;
    property IsClientMode : Boolean read FIsClientMode;
    property IsOpen       : Boolean read GetIsOpen;
    property Name         : string  read FName       write SetName;
  end;


implementation

constructor TCustomMappedFile.Create(const aName: string; aBufferSizeDefault: UInt32);
begin
  FName := aName;
  if (aBufferSizeDefault = 0) then
    aBufferSizeDefault := BUFFER_SIZE_DEFAULT
  else if (aBufferSizeDefault < BUFFER_SIZE_MINIMAL) then
    aBufferSizeDefault := BUFFER_SIZE_MINIMAL;
  FBufferSizeDefault := aBufferSizeDefault;
  FBufferSize := FBufferSizeDefault;
end;

destructor TCustomMappedFile.Destroy;
begin
//  Close;
  inherited
end;

function TCustomMappedFile.CloseDevice: Boolean;
begin
  if (FDeviceHandle <> 0) and (FDeviceHandle <> INVALID_HANDLE_VALUE) then
    Result := CloseHandle(FDeviceHandle)
  else
    Result := True;
  FDeviceHandle := 0;
end;

function TCustomMappedFile.Close: Boolean;
begin
  Result := CloseDevice;
  FIsClientMode := False;
end;

procedure TCustomMappedFile.SetName(const aValue: string);
begin
  if not GetIsOpen then
    FName := aValue;
end;

function TCustomMappedFile.GetIsOpen: Boolean;
begin
  Result := (FDeviceHandle <> 0) and (FDeviceHandle <> INVALID_HANDLE_VALUE);
end;

procedure TCustomMappedFile.SetBufferSize(aValue: UInt32);
begin
  if not GetIsOpen then
  begin
    if (aValue = 0) then
      aValue := FBufferSizeDefault;
    FBufferSize := aValue;
  end;
end;

end.
