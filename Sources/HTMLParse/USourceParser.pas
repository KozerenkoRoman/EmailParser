unit UsourceParser;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

// Ttokenizer will split the source into HTML tags and text in between

interface

uses classes, sysUtils, strUtils, Generics.collections,
  UhtmlReference;

type
  TtokenType = (ttEmpty, ttOpenTag, ttCloseTag, ttCommentTag, ttText);

  Rtoken = record
    tokenType: TtokenType;
    startPos: integer; // first position after <
    endPos: integer; // last position before >
    tagReference: TtagReference;
    tag: string;
    procedure determineTag(var source: string);
  end;

  Ttokenizer = class
    token: Rtoken;
    source: string;
    currentPos: integer;
    sourceLength: integer;
    doNOTadvance: boolean; // because the current token will be reused
    function locate(ch: char): integer;
    function tagString: string;
    procedure advance;
    procedure assign(const aSource: string);
    procedure initialize;
    procedure LoadFromFile(filename: string);
  private
    procedure setEOF;
    function ThereIsText(pStart, pEnd: integer): boolean;
  end;

implementation

{ Ttokenizer }

function Ttokenizer.ThereIsText(pStart, pEnd: integer): boolean;
// is there a non-blank character in the range ?
var
  p: integer;
begin
  for p := pStart to pEnd do
    if source[p] > ' ' then
      exit(true);
  result := false
end;

procedure Ttokenizer.advance;
var
  PosOpenBracket, p: integer;
begin
  token.tagReference := trUNPARSED;
  token.tag := '';
  doNOTadvance := false;

  // find the next <
  PosOpenBracket := locate('<');
  if PosOpenBracket = 0 then
  begin // EOF
    if ThereIsText(currentPos, sourceLength) then
    begin // trailing text
      token.tokenType := ttText;
      token.startPos := currentPos;
      token.endPos := sourceLength;
      currentPos := token.endPos + 1;
    end
    else
      setEOF;
    exit;
  end;

  // if there is text between currentPos and PosOpenBracket then return a ttText
  if ThereIsText(currentPos, PosOpenBracket - 1) then
  begin
    token.tokenType := ttText;
    token.tag := 'TEXT';
    token.tagReference := trTEXT;
    token.startPos := currentPos;
    token.endPos := PosOpenBracket - 1;
    currentPos := PosOpenBracket;
    exit
  end;

  if PosOpenBracket + 3 > sourceLength then
  begin
    setEOF;
    exit
  end;

  // if the tag starts with <!, it may be a comment, DOCTYPE or propriority (like Microsofts's <![endif]--> )
  if (source[PosOpenBracket + 1] = '!') then
  begin // if the tag signals a comment '<!--' then return start and end of text between open/close comment tags
    if (source[PosOpenBracket + 2] = '-') AND (source[PosOpenBracket + 3] = '-') then
    begin
      token.tokenType := ttCommentTag;
      token.tag := 'COMMENT';
      token.startPos := PosOpenBracket + 4;
      p := posEx('-->', source, token.startPos);
      if p = 0 then
        token.endPos := sourceLength
      else
        token.endPos := p - 1;
      currentPos := token.endPos + 4;
      exit
    end
    else if (UpperCase(source[PosOpenBracket + 2]) <> 'D') // DOCTYPE, treated below as opentag
    then
    begin // step over it
      currentPos := locate('>') + 1;
      advance;
      exit;
    end
  end;

  // is it an end tag? starting with '</'
  if (source[PosOpenBracket + 1] = '/') then
  begin
    token.tokenType := ttCloseTag;
    token.startPos := PosOpenBracket + 2; // first char after '</'
    currentPos := token.startPos;
    p := locate('>');
    if p = 0 then
      token.endPos := sourceLength
    else
      token.endPos := p - 1; // last char before '>'
    currentPos := token.endPos + 2;
    token.determineTag(source);
    exit
  end;

  // it is an open tag
  token.tokenType := ttOpenTag;
  token.startPos := PosOpenBracket + 1; // first char after '<'
  currentPos := token.startPos;
  p := locate('>');
  if p = 0 then
    token.endPos := sourceLength
  else
    token.endPos := p - 1; // last char before '>'
  currentPos := token.endPos + 2;
  token.determineTag(source);
end;

procedure Ttokenizer.assign(const aSource: string);
begin
  source := aSource;
end;

procedure Ttokenizer.initialize;
begin
  currentPos := 1;
  sourceLength := length(source);
end;

procedure Ttokenizer.loadFromFile(filename: string);
var
  sList: Tstringlist;
begin
  sList := Tstringlist.Create;
  try
    sList.loadFromFile(filename);
    source := sList.Text;
  except
    source := '<-- ERROR READING FILE ' + filename + ' -->';
  end;
  sList.Free;
end;

function Ttokenizer.locate(ch: char): integer;
// same as utilities.pos but simpler
begin
  result := currentPos;
  while (result <= sourceLength) AND (source[result] <> ch) do
    inc(result);
  if result > sourceLength then
    result := 0;
end;

procedure Ttokenizer.setEOF;
begin
  token.tokenType := ttEmpty;
  token.startPos := sourceLength + 1;
  token.endPos := token.startPos;
  currentPos := token.startPos;
end;

function Ttokenizer.tagString: string;
// return the string from token.startPos to token.endPos, trimmed
begin
  result := copy(source, token.startPos, token.endPos - token.startPos + 1);
  result := trim(result)
end;

{ Rtoken }

procedure Rtoken.determineTag(var source: string);
var
  p: integer;
begin
  p := startPos;
  // skip blanks
  while (p < endPos) AND (source[p] <= ' ') do
    inc(p);
  // the tag is next string up to blank
  tag := '';
  while (p <= endPos) AND (source[p] > ' ') do
  begin
    tag := tag + UpperCase(source[p]);
    inc(p)
  end;

  tagReference := getTagReference(tag);
end;

end.
