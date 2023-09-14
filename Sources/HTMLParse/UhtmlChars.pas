unit UhtmlChars;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

interface

function ASCIIchar(HTMLcode: string): string;
function sanitizeHTMLtext(var txt: string): string;
function posOfSubstring(const subStr, str: string; fromPos: integer; checkCase: boolean = False): integer;

implementation

uses classes, sysUtils, strUtils, Generics.collections;

type
  ThtmlToASCII = Tdictionary<string, integer>;

var
  HTMLtoASCII: ThtmlToASCII;

function ASCIIchar(HTMLcode: string): string;
// return ASCII char for HTML specials, such as &eacute;
// if unknown return the input string
var
  k, n: integer;
begin
  // check the table of special coding
  if HTMLtoASCII.TryGetValue(HTMLcode, n) then
    exit(char(n));

  if HTMLcode = '' then
    exit('');

  if length(HTMLcode) < 3 then
    exit(HTMLcode);

  // check numeric codes, such as &#
  if (HTMLcode[1] = '&') AND (HTMLcode[2] = '#') AND CharInSet(HTMLcode[3], ['1' .. '9']) then
  begin
    n := 0;
    k := 3;
    while (k < length(HTMLcode)) AND (n <= 65535) AND CharInSet(HTMLcode[k], ['0' .. '9']) do
    begin
      n := n * 10 + ord(HTMLcode[k]) - ord('0');
      inc(k)
    end;
    if n <= 255 then
      exit(char(n))
  end;

  exit(HTMLcode);
end;

function sanitizeHTMLtext(var txt: string): string;
// remove double blanks, translate chars codes
var
  kSource, kDestin, sourceLength, k: integer;
  ch: char;
  blank: boolean;
  s: string;
begin
  result := txt;
  sourceLength := length(txt);
  if sourceLength < 2 then
    exit;

  // result is never larger than txt. overwrite result.
  kSource := 1;
  kDestin := 0;
  blank := true;
  while kSource <= sourceLength do
  begin
    ch := txt[kSource];
    case ch of
      #9, #10, #13:
        if NOT blank then
        begin
          blank := true;
          inc(kDestin);
          result[kDestin] := ' ';
        end;
      ' ':
        if NOT blank then
        begin
          blank := true;
          inc(kDestin);
          result[kDestin] := ' ';
        end;
      '&':
        begin
          blank := False;
          s := '';
          repeat
            ch := txt[kSource];
            s := s + ch;
            inc(kSource)
          until (ch = ';') OR (kSource > sourceLength);
          s := ASCIIchar(s);
          for k := 1 to length(s) do
          begin
            inc(kDestin);
            result[kDestin] := s[k];
          end;
          continue
        end;
    else
      blank := False;
      inc(kDestin);
      result[kDestin] := ch;
    end;
    inc(kSource);
  end;

  // remove trailing blank
  if (kDestin > 0) AND (result[kDestin] = ' ') then
    dec(kDestin);
  setLength(result, kDestin);
end;

function posOfSubstring(const subStr, str: string; fromPos: integer; checkCase: boolean = False): integer;
// when checkCase=TRUE, do a case-sensitive search = - which is fast
// when checkCase=FALSE, 'this' will be found in 'This'
// searching starts at position fromPos in str
var
  subStr1UC: char;
  p, subStrLength, strLength: integer;
  found: boolean;
begin
  strLength := length(str);
  if strLength = 0 then
    exit(0);
  subStrLength := length(subStr);
  if subStrLength = 0 then
    exit(0);

  if checkCase then
    exit(posEx(subStr, str, fromPos));

  // case-insensitive search: match first char and then check rest of string
  subStr1UC := upCase(subStr[1]);

  for result := fromPos to strLength - subStrLength + 1 do
  begin
    if upCase(str[result]) = subStr1UC then
    begin // first char matches
      found := true;
      for p := 2 to subStrLength do
        if upCase(str[result + p - 1]) <> upCase(subStr[p]) then
        begin
          found := False;
          break
        end;
      if found then
        exit;
    end;
  end;
  result := 0;
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
