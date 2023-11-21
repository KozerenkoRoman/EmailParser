unit Utils.CmdParser;

interface

{$REGION 'Region uses'}
uses
  System.SysUtils, System.Variants, System.Classes, Winapi.Windows;
{$ENDREGION}

type
  TCmdParser = class
  strict private
    FString: TStringList;
    procedure Parse;
  const
    Chars: TSysCharSet = ['/', '.', '-'];
  public
    constructor Create;
    destructor Destroy; override;
    function AsString(const aName: string): string;
    function Exists(const aName: string): Boolean;
  end;

implementation

{ TCmdParser }

constructor TCmdParser.Create;
begin
  FString := TStringList.Create;
  Parse;
end;

destructor TCmdParser.Destroy;
begin
  FreeAndNil(FString);
  inherited;
end;

procedure TCmdParser.Parse;
var
  Param: string;
  arr: TArray<string>;
begin
  for var i := 1 to ParamCount do
  begin
    Param := ParamStr(i);
    if CharInSet(Param.Chars[0], Chars) then
      Param := Param.SubString(1).ToLower
    else
      Param := Param.ToLower;
    if Param.Contains('=') then
    begin
      arr := Param.Split(['=']);
      FString.AddPair(arr[0], arr[1]);
    end
    else
      FString.AddPair(Param, '');
  end;
end;

function TCmdParser.AsString(const aName: string): string;
var
  Index: Integer;
begin
  Index := FString.IndexOfName(aName.ToLower);
  if (Index > -1) then
    Result := FString.ValueFromIndex[Index]
  else
    Result := '';
end;

function TCmdParser.Exists(const aName: string): Boolean;
begin
  Result := FString.IndexOfName(aName.ToLower) > -1;
end;

end.
