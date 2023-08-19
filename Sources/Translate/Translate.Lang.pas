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
    LanguageString: array [TLanguage] of string = ('Українська', 'English');
  public
    function ToString: string;
  end;

  TLang = class(TObject)
  private
    FLanguage: TLanguage;
    FList: TDictionary<string, TMessageItem>;
    class var FLang: TLang;
  public
    class function Lang: TLang;
    function Translate(const AKey: string): string;

    constructor Create;
    destructor Destroy; override;
    property Language: TLanguage read FLanguage write FLanguage;
  end;

implementation

{ TLang }

class function TLang.Lang: TLang;
begin
  if not Assigned(FLang) then
    FLang := TLang.Create;
  Result := FLang;
end;

constructor TLang.Create;
begin
  FLanguage := lgUk;
  FList := TDictionary<string, TMessageItem>.Create;
  for var item in ArrayMessages do
    FList.Add(item.Key.Trim.ToLower, item);
end;

destructor TLang.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TLang.Translate(const AKey: string): string;
var
  Item: TMessageItem;
begin
  Result := AKey.Trim;
  if FList.TryGetValue(Result.ToLower, item) then
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
