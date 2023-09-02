unit Html.Utils;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.ActiveX, System.Classes, Vcl.Graphics, System.SysUtils, System.Variants,
  System.StrUtils, Html.Consts, Html.Lib, ArrayHelper;
{$ENDREGION}

type
  THtmlUtils = class(TObject)
    class function GetHighlightText(const aText: string; const aMatches: TArrayRecord<TStringArray>): string;
  end;

implementation

{ THtmlUtils }

class function THtmlUtils.GetHighlightText(const aText: string; const aMatches: TArrayRecord<TStringArray>): string;
var
  refRGB   : TColorRef;
  subArray : TStringArray;
  WebColor : string;
begin
  if aText.IsEmpty then
    Exit;
  Result := aText;
  for var i := Low(aMatches.Items) to High(aMatches.Items) do
  begin
    subArray := aMatches[i];
    refRGB   := ColorToRGB(arrWebColors[i]);
    WebColor := Format('#%.2x%.2x%.2x', [GetRValue(refRGB), GetGValue(refRGB), GetBValue(refRGB)]);
    for var str in subArray do
      if not str.Trim.IsEmpty then
        Result := Result.Replace(str, THtmlLib.GetBackgroundColor(str, WebColor));
  end;
end;

end.
