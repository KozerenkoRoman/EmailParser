unit Global.Utils;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.ActiveX, System.Classes, Vcl.Graphics, System.SysUtils, System.Variants,
  System.StrUtils, Global.Types, Html.Lib, ArrayHelper;
{$ENDREGION}

type
  TGlobalUtils = class(TObject)
    class function GetHighlightText(const aText: string; const aMatches: TArrayRecord<TStringArray>): string;
    class function GetHighlightColor(const aText: string; const aMatches: TArrayRecord<TStringArray>): TColor;
  end;

implementation

{ TGlobalUtils }

class function TGlobalUtils.GetHighlightColor(const aText: string; const aMatches: TArrayRecord<TStringArray>): TColor;
var
  subArray: TStringArray;
begin
  Result := clWindow;
  if aText.IsEmpty then
    Exit
  else if (aMatches.Count = 0) then
    Exit;

  for var i := Low(aMatches.Items) to High(aMatches.Items) do
  begin
    subArray := aMatches[i];
    if (subArray.Count > 0) then
      if aText.ToLower.Contains(subArray[0].ToLower) then
        Exit(TGeneral.PatternList[i].Color);
  end;
end;

class function TGlobalUtils.GetHighlightText(const aText: string; const aMatches: TArrayRecord<TStringArray>): string;
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
    refRGB   := ColorToRGB(TGeneral.PatternList[i].Color);
    WebColor := Format('#%.2x%.2x%.2x', [GetRValue(refRGB), GetGValue(refRGB), GetBValue(refRGB)]);
    for var str in subArray do
      if not str.Trim.IsEmpty then
        Result := Result.Replace(str, THtmlLib.GetBackgroundColor(str, WebColor));
  end;
end;

end.
