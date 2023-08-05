unit Common.Types;

interface

{$REGION 'Region uses'}
uses
  Winapi.Messages, System.SysUtils, System.Variants, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Graphics;
{$ENDREGION}

type
  TLogDetailType = (ddEnterMethod, ddExitMethod, ddError, ddText, ddWarning);
  TLogDetailTypes = set of TLogDetailType;
  TLogDetailTypeHelper = record helper for TLogDetailType
  private
    const LogDetailTypesString: array[TLogDetailType] of string = ('Enter Method', 'Exit Method', 'Error', 'Text', 'Warning');
  public
    function ToString: string;
  end;

  TStringObject = class(TObject)
    Id: Integer;
    StringValue: string;
    constructor Create(const aId: Integer; const aStringValue: string); overload;
    constructor Create(const aStringValue: string); overload;
  end;

const
  C_TOP_COLOR = $001E4DFF;

implementation

{ TLogDetailTypeHelper }

function TLogDetailTypeHelper.ToString: string;
begin
  Result := LogDetailTypesString[Self];
end;

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
