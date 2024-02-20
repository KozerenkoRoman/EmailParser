unit UhtmlChars;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

interface

function ASCIIChar(aHTMLCode: string): string;
function SanitizeHTMLText(var aText: string): string;
function PosOfSubstring(const aSubStr, aStr: string; aFromPos: Integer; aCheckCase: Boolean = False): Integer;

implementation

uses
  System.Classes, System.SysUtils, StrUtils, Generics.Collections;

type
  ThtmlToASCII = TDictionary<string, Integer>;

var
  HTMLtoASCII: ThtmlToASCII;

function ASCIIChar(aHTMLCode: string): string;
// return ASCII Char for HTML specials, such as &eacute;
// if unknown return the input string
var
  k, n: Integer;
begin
  // check the table of special coding
  if HTMLtoASCII.TryGetValue(aHTMLCode, n) then
    Exit(Char(n));

  if aHTMLCode = '' then
    Exit('');

  if Length(aHTMLCode) < 3 then
    Exit(aHTMLCode);

  // check numeric codes, such as &#
  if (aHTMLCode[1] = '&') AND (aHTMLCode[2] = '#') AND CharInSet(aHTMLCode[3], ['1' .. '9']) then
  begin
    n := 0;
    k := 3;
    while (k < Length(aHTMLCode)) AND (n <= 65535) AND CharInSet(aHTMLCode[k], ['0' .. '9']) do
    begin
      n := n * 10 + Ord(aHTMLCode[k]) - Ord('0');
      Inc(k)
    end;
    if n <= 255 then
      Exit(Char(n))
  end;

  Exit(aHTMLCode);
end;

function SanitizeHTMLText(var aText: string): string;
// remove double blanks, translate chars codes
var
  kSource, kDestin, sourceLength, k: Integer;
  ch: Char;
  blank: Boolean;
  s: string;
begin
  Result := aText;
  sourceLength := Length(aText);
  if sourceLength < 2 then
    Exit;

  // Result is never larger than aText. overwrite Result.
  kSource := 1;
  kDestin := 0;
  blank := True;
  while kSource <= sourceLength do
  begin
    ch := aText[kSource];
    case ch of
      #9, #10, #13:
        if NOT blank then
        begin
          blank := True;
          Inc(kDestin);
          Result[kDestin] := ' ';
        end;
      ' ':
        if NOT blank then
        begin
          blank := True;
          Inc(kDestin);
          Result[kDestin] := ' ';
        end;
      '&':
        begin
          blank := False;
          s := '';
          repeat
            ch := aText[kSource];
            s := s + ch;
            Inc(kSource)
          until (ch = ';') OR (kSource > sourceLength);
          s := ASCIIChar(s);
          for k := 1 to Length(s) do
          begin
            Inc(kDestin);
            Result[kDestin] := s[k];
          end;
          continue
        end;
    else
      blank := False;
      Inc(kDestin);
      Result[kDestin] := ch;
    end;
    Inc(kSource);
  end;

  // remove trailing blank
  if (kDestin > 0) AND (Result[kDestin] = ' ') then
    Dec(kDestin);
  SetLength(Result, kDestin);
end;

function PosOfSubstring(const aSubStr, aStr: string; aFromPos: Integer; aCheckCase: Boolean = False): Integer;
// when aCheckCase=True, do a case-sensitive search = - which is fast
// when aCheckCase=FALSE, 'this' will be found in 'This'
// searching starts at position aFromPos in aStr
var
  subStr1UC: Char;
  p, subStrLength, strLength: Integer;
  found: Boolean;
begin
  strLength := Length(aStr);
  if strLength = 0 then
    Exit(0);
  subStrLength := Length(aSubStr);
  if subStrLength = 0 then
    Exit(0);

  if aCheckCase then
    Exit(posEx(aSubStr, aStr, aFromPos));

  // case-insensitive search: match first Char and then check rest of string
  subStr1UC := upCase(aSubStr[1]);

  for Result := aFromPos to strLength - subStrLength + 1 do
  begin
    if upCase(aStr[Result]) = subStr1UC then
    begin // first Char matches
      found := True;
      for p := 2 to subStrLength do
        if upCase(aStr[Result + p - 1]) <> upCase(aSubStr[p]) then
        begin
          found := False;
          Break
        end;
      if found then
        Exit;
    end;
  end;
  Result := 0;
end;

initialization
  HTMLtoASCII := ThtmlToASCII.Create(500);
  HTMLtoASCII.Add('&quot;', 34);
  HTMLtoASCII.Add('&amp;', 38);
  HTMLtoASCII.Add('&lt;', 60);
  HTMLtoASCII.Add('&gt;', 62);
  HTMLtoASCII.Add('&nbsp;', 160);
  HTMLtoASCII.Add('&iexcl;', 161);
  HTMLtoASCII.Add('&cent;', 162);
  HTMLtoASCII.Add('&pound;', 163);
  HTMLtoASCII.Add('&curren;', 164);
  HTMLtoASCII.Add('&yen;', 165);
  HTMLtoASCII.Add('&brvbar;', 166);
  HTMLtoASCII.Add('&sect;', 167);
  HTMLtoASCII.Add('&uml;', 168);
  HTMLtoASCII.Add('&copy;', 169);
  HTMLtoASCII.Add('&ordf;', 170);
  HTMLtoASCII.Add('&laquo;', 171);
  HTMLtoASCII.Add('&not;', 172);
  HTMLtoASCII.Add('&shy;', 173);
  HTMLtoASCII.Add('&reg;', 174);
  HTMLtoASCII.Add('&macr;', 175);
  HTMLtoASCII.Add('&deg;', 176);
  HTMLtoASCII.Add('&plusmn;', 177);
  HTMLtoASCII.Add('&sup2;', 178);
  HTMLtoASCII.Add('&sup3;', 179);
  HTMLtoASCII.Add('&acute;', 180);
  HTMLtoASCII.Add('&micro;', 181);
  HTMLtoASCII.Add('&para;', 182);
  HTMLtoASCII.Add('&middot;', 183);
  HTMLtoASCII.Add('&cedil;', 184);
  HTMLtoASCII.Add('&sup1;', 185);
  HTMLtoASCII.Add('&ordm;', 186);
  HTMLtoASCII.Add('&raquo;', 187);
  HTMLtoASCII.Add('&frac14;', 188);
  HTMLtoASCII.Add('&frac12;', 189);
  HTMLtoASCII.Add('&frac34;', 190);
  HTMLtoASCII.Add('&iquest;', 191);
  HTMLtoASCII.Add('&Agrave;', 192);
  HTMLtoASCII.Add('&Aacute;', 193);
  HTMLtoASCII.Add('&Acirc;', 194);
  HTMLtoASCII.Add('&Atilde;', 195);
  HTMLtoASCII.Add('&Auml;', 196);
  HTMLtoASCII.Add('&Aring;', 197);
  HTMLtoASCII.Add('&AElig;', 198);
  HTMLtoASCII.Add('&Ccedil;', 199);
  HTMLtoASCII.Add('&Egrave;', 200);
  HTMLtoASCII.Add('&Eacute;', 201);
  HTMLtoASCII.Add('&Ecirc;', 202);
  HTMLtoASCII.Add('&Euml;', 203);
  HTMLtoASCII.Add('&Igrave;', 204);
  HTMLtoASCII.Add('&Iacute;', 205);
  HTMLtoASCII.Add('&Icirc;', 206);
  HTMLtoASCII.Add('&Iuml;', 207);
  HTMLtoASCII.Add('&ETH;', 208);
  HTMLtoASCII.Add('&Ntilde;', 209);
  HTMLtoASCII.Add('&Ograve;', 210);
  HTMLtoASCII.Add('&Oacute;', 211);
  HTMLtoASCII.Add('&Ocirc;', 212);
  HTMLtoASCII.Add('&Otilde;', 213);
  HTMLtoASCII.Add('&Ouml;', 214);
  HTMLtoASCII.Add('&times;', 215);
  HTMLtoASCII.Add('&Oslash;', 216);
  HTMLtoASCII.Add('&Ugrave;', 217);
  HTMLtoASCII.Add('&Uacute;', 218);
  HTMLtoASCII.Add('&Ucirc;', 219);
  HTMLtoASCII.Add('&Uuml;', 220);
  HTMLtoASCII.Add('&Yacute;', 221);
  HTMLtoASCII.Add('&THORN;', 222);
  HTMLtoASCII.Add('&szlig;', 223);
  HTMLtoASCII.Add('&agrave;', 224);
  HTMLtoASCII.Add('&aacute;', 225);
  HTMLtoASCII.Add('&acirc;', 226);
  HTMLtoASCII.Add('&atilde;', 227);
  HTMLtoASCII.Add('&auml;', 228);
  HTMLtoASCII.Add('&aring;', 229);
  HTMLtoASCII.Add('&aelig;', 230);
  HTMLtoASCII.Add('&ccedil;', 231);
  HTMLtoASCII.Add('&egrave;', 232);
  HTMLtoASCII.Add('&eacute;', 233);
  HTMLtoASCII.Add('&ecirc;', 234);
  HTMLtoASCII.Add('&euml;', 235);
  HTMLtoASCII.Add('&igrave;', 236);
  HTMLtoASCII.Add('&iacute;', 237);
  HTMLtoASCII.Add('&icirc;', 238);
  HTMLtoASCII.Add('&iuml;', 239);
  HTMLtoASCII.Add('&eth;', 240);
  HTMLtoASCII.Add('&ntilde;', 241);
  HTMLtoASCII.Add('&ograve;', 242);
  HTMLtoASCII.Add('&oacute;', 243);
  HTMLtoASCII.Add('&ocirc;', 244);
  HTMLtoASCII.Add('&otilde;', 245);
  HTMLtoASCII.Add('&ouml;', 246);
  HTMLtoASCII.Add('&divide;', 247);
  HTMLtoASCII.Add('&oslash;', 248);
  HTMLtoASCII.Add('&ugrave;', 249);
  HTMLtoASCII.Add('&uacute;', 250);
  HTMLtoASCII.Add('&ucirc;', 251);
  HTMLtoASCII.Add('&uuml;', 252);
  HTMLtoASCII.Add('&yacute;', 253);
  HTMLtoASCII.Add('&thorn;', 254);
  HTMLtoASCII.Add('&yuml;', 255);

finalization
  HTMLtoASCII.Free;

end.
