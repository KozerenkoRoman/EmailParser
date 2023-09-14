unit Common.Types;

interface

{$REGION 'Region uses'}
uses
  Winapi.Messages, System.SysUtils, System.Variants, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Graphics;
{$ENDREGION}

type
  TStringObject = class(TObject)
    Id          : Integer;
    StringValue : string;
    constructor Create(const aId: Integer; const aStringValue: string); overload;
    constructor Create(const aStringValue: string); overload;
  end;

implementation

{ TStringObject }

constructor TStringObject.Create(const aId: Integer; const aStringValue: string);
begin
  Self.Id := aId;
  Self.StringValue := aStringValue;
end;

constructor TStringObject.Create(const aStringValue: string);
begin
  Self.Id := -1;
  Self.StringValue := aStringValue;
end;

end.
