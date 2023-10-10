unit Utils;

interface

{$REGION 'Region uses'}
uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Defaults, System.Generics.Collections,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Winapi.Windows, System.DateUtils, System.IniFiles,
  Vcl.Controls, Winapi.ShellAPI, System.IOUtils, Vcl.Forms;
{$ENDREGION}

type
  TColNum    = 1..256;  // Excel columns only go up to IV
  TColString = string[2];

  function BoolToChar(const aValue: Boolean): string; inline;
  function FloatToStrEx(Value: Double): string;
  function GetLeftPadString(aText: string; aLength: Integer): string;
  function GetRightPadString(aText: string; aLength: Integer): string;
  function GetUniqueList(List: string; Delimiter: Char = ','): string; inline;
  function IntToStrEx(Value: Integer): string;
  function IsFloat(str: string): Boolean;
  function IsNumber(str: string): Boolean;
  function LeftStr(const aText: string; aLength: Word): string;
  function NullIf(Value, Value1: Integer): Variant; overload;
  function NullIf(Value, Value1: Real): Variant; overload;
  function NullIf(Value, Value1: String): Variant; overload;
  function RightStr(const aText: string; aLength: Word): string;
  function RoundToNearest(aTime: TDateTime; aRoundInterval: Word): TDateTime;
  function SafeStrToFloat(S: String; const ADefault: Single = 0): Extended; inline;
  function StrToFloatEx(const str: string): Double;
  function StrToIntEx(const str: string): Integer;
  function VarToBool(const Value: Variant): Boolean; inline;
  function VarToFloat(const V: Variant): Extended; inline;
  function VarToInt64Def(const Value: Variant; DefValue: Int64 = 0): Int64; inline;
  function VarToIntDef(const Value: Variant; DefValue: Integer = 0): Integer; inline;
  procedure SetFocusSafely(const aControl: TWinControl); inline;

  function XlsColToInt(const aCol: TColString): TColNum;
  function IntToXlsCol(const aColNum: TColNum): TColString;

const
  C_ROUND_SEC = 2;

var
  NoDecimalSeparator: string;

implementation

function NullIf(Value, Value1: Integer): Variant;
begin
  if Value = Value1 then
    Result := Null
  else
    Result := Value;
end;

function NullIf(Value, Value1: Real): Variant;
begin
  if Value = Value1 then
    Result := Null
  else
    Result := Value;
end;

function NullIf(Value, Value1: String): Variant;
begin
  if Value = Value1 then
    Result := Null
  else
    Result := Value;
end;

function RoundToNearest(aTime: TDateTime; aRoundInterval: Word): TDateTime;
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(aTime, Hour, Min, Sec, MSec);
  Sec := (Sec div aRoundInterval) * aRoundInterval;
  Result := Trunc(aTime) + EncodeTime(Hour, Min, Sec, 0);
end;

function StrToIntEx(const str : string) : Integer;
begin
  if str = '' then
    Result := MaxInt
  else
    Result := StrToIntDef(str, 0)
end;

function IntToStrEx(value : Integer) : string;
begin
  if value = Integer.MaxValue then
    Result := ''
  else
    Result := IntToStr(value)
end;

function StrToFloatEx(const str : string): Double;
begin
  if str = '' then
    Result := 0
  else
    Result := StrToFloatDef(StringReplace(str, '.', FormatSettings.DecimalSeparator, [rfReplaceAll]), 0);
end;

{$HINTS OFF}
function IsNumber(str: string): Boolean;
var
  iValue, iCode: Integer;
begin
  str := str.Replace('.', FormatSettings.DecimalSeparator).Replace(',', FormatSettings.DecimalSeparator);
  iCode := 0;
  Val(str, iValue, iCode); //Hint H2077 Value assigned to 'iValue' never used
  Result := iCode = 0;
end;
{$HINTS ON}

function IsFloat(str: string): Boolean;
var
  Value: Double;
begin
  Result := TryStrToFloat(str.Replace('.', FormatSettings.DecimalSeparator).Replace(',', FormatSettings.DecimalSeparator), Value);
end;

function FloatToStrEx(value : Double): string;
begin
  if value >= Double.MaxValue then
    Result := ''
  else
    Result := FloatToStr(value).Replace('.', FormatSettings.DecimalSeparator).Replace(',', FormatSettings.DecimalSeparator);
end;

function VarToFloat(const V: Variant): Extended;
begin
  if VarIsOrdinal(V) or VarIsFloat(V) then
    Result := V
  else
    Result := SafeStrToFloat(VarToStr(V));
end;

function SafeStrToFloat(S: String; const ADefault: Single = 0): Extended;
begin
  S := S.Replace(',', FormatSettings.DecimalSeparator).Replace('.', FormatSettings.DecimalSeparator);
  Result := StrToFloatDef(S, 0);
end;

function GetUniqueList(List: string; Delimiter: Char = ','): string;
var
  stList: THashedStringList;
begin
  Result := List;
  if not List.IsEmpty then
  begin
    stList := THashedStringList.Create;
    try
      stList.Sorted := True;
      stList.Duplicates := dupIgnore;
      stList.Delimiter := Delimiter;
      stList.DelimitedText := List;
      Result := stList.DelimitedText;
    finally
      FreeAndNil(stList);
    end;
  end;
end;

function VarToIntDef(const Value: variant; DefValue: Integer=0): Integer;
begin
  if VarIsOrdinal(Value) or VarIsNumeric(Value) then
    Result := Value
  else
    Result := StrToIntDef(varToStr(Value), DefValue);
end;

function VarToInt64Def(const Value: variant; DefValue: Int64=0): Int64;
begin
  if VarIsOrdinal(Value) or VarIsNumeric(Value) then
    Result := Value
  else
    Result := StrToInt64Def(varToStr(Value), DefValue);
end;

function VarToBool(const Value: Variant): Boolean;
var
  S: string;
begin
  if VarIsType(Value, varBoolean) then
    Result := Value
  else
  begin
    S := VarToStr(Value);
    Result := not(S.IsEmpty or SameText(S, 'false') or SameText(S, '0'));
  end;
end;

function BoolToChar(const aValue: Boolean): string;
begin
  if aValue then
    Result := 'Y'
  else
    Result := 'N';
end;

function GetRightPadString(aText: string; aLength: Integer): string;
begin
  if (aLength > aText.Length) then
    Result := aText + StringOfChar(' ', aLength - aText.Length)
  else
    Result := aText;
end;

function GetLeftPadString(aText: string; aLength: Integer): string;
begin
  if (aLength > aText.Length) then
    Result := StringOfChar(' ', aLength - aText.Length) + aText
  else
    Result := aText;
end;

function RightStr(const aText: string; aLength: Word): string;
var
  len: Byte absolute aText;
begin
  if aLength > len then
    aLength := len;
  RightStr := Copy(aText, len - aLength + 1, aLength)
end;

function LeftStr(const aText: string; aLength: Word): string;
begin
  LeftStr := Copy(aText, 1, aLength)
end;

procedure SetFocusSafely(const aControl: TWinControl);
begin
  if Assigned(aControl) then
    if aControl.CanFocus and aControl.Enabled then
      aControl.SetFocus;
end;

const
  MaxLetters = 26;

function IntToXlsCol(const aColNum: TColNum): TColString;
{ Turns a column number into the corresponding column letter }
const
  Letters: array [0 .. MaxLetters] of AnsiChar = 'ZABCDEFGHIJKLMNOPQRSTUVWXYZ';
var
  nQuot, nMod: Integer;
Begin
  if (aColNum <= MaxLetters) then
  begin
    Result[0] := Chr(1);
    Result[1] := Letters[aColNum];
  end
  else
  begin
    nQuot := ((aColNum - 1) * 10083) shr 18;
    nMod := aColNum - (nQuot * MaxLetters);
    Result[0] := Chr(2);
    Result[1] := Letters[nQuot];
    Result[2] := Letters[nMod];
  end;
end;

function XlsColToInt(const aCol: TColString): TColNum;
{ Turns a column identifier into the corresponding integer, A=1, ..., AA = 27, ..., IV = 256 }
const
  ASCIIOffset = Ord('A') - 1;
var
  Len: cardinal;
begin
  Len := Length(aCol);
  Result := Ord(UpCase(aCol[Len])) - ASCIIOffset;
  if (Len > 1) then
    Inc(Result, (Ord(UpCase(aCol[1])) - ASCIIOffset) * MaxLetters);
end;

end.
