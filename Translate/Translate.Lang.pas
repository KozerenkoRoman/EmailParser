unit Translate.Lang;

interface

{$REGION 'Region uses'}

uses
  System.SysUtils, System.Variants, System.Classes, Translate.Resources, System.Generics.Collections,
  System.Generics.Defaults;
{$ENDREGION}

type
  TLanguage = (lgUk, lgEn);
  TLanguageHelper = record helper for TLanguage
  private const
    LanguageString: array [TLanguage] of string = ('Ukrainian', 'English');
  public
    function ToString: string;
  end;

  TLang = class(TObject)
  private
    FLanguage: TLanguage;
    FList: TDictionary<string, TMessageItem>;
    class var FLang: TLang;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Initialize;
    function Translate(const AKey: string): string;
    property Language: TLanguage read FLanguage write FLanguage;
    class function Lang: TLang;
  end;

implementation

{ TLang }

class function TLang.Lang: TLang;
begin
  if not Assigned(FLang) then
  begin
    FLang := TLang.Create;
    FLang.Initialize;
  end;
  Result := FLang;
end;

constructor TLang.Create;
begin
  FLanguage := lgUk;
  FList := TDictionary<string, TMessageItem>.Create;
end;

destructor TLang.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TLang.Initialize;
begin
  FList.Clear;
  for var item in ArrayMessages do
    FList.Add(item.Key.ToLower, item);
end;

function TLang.Translate(const AKey: string): string;
var
  Item: TMessageItem;
begin
  Result := AKey;
  if FList.TryGetValue(AKey.ToLower, item) then
    case FLanguage of
      lgUk:
        Result := item.Uk;
      lgEn:
        Result := item.En;
    end;
end;

{ TLanguageHelper }

function TLanguageHelper.ToString: string;
begin
  Result := LanguageString[Self];
end;

initialization

finalization
  if Assigned(TLang.FLang) then
    FreeAndNil(TLang.FLang);

end.
