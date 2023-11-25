unit UsourceParser;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

// TTokenizer will split the Source into HTML tags and text in between

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, Generics.Collections,
  UhtmlReference;

type
  TTokenType = (ttEmpty, ttOpenTag, ttCloseTag, ttCommentTag, ttText);

  RToken = record
    EndPos: Integer; // last position before >
    StartPos: Integer; // first position after <
    Tag: string;
    TagReference: TtagReference;
    TokenType: TTokenType;
    procedure DetermineTag(var Source: string);
  end;

  TTokenizer = class
    CurrentPos: Integer;
    DoNotAdvance: Boolean; // because the current Token will be reused
    Source: string;
    SourceLength: Integer;
    Token: RToken;
    function Locate(aCh: Char): Integer;
    function TagString: string;
    procedure Advance;
    procedure Assign(const aSource: string);
    procedure Initialize;
    procedure LoadFromFile(aFileName: string);
  private
    procedure SetEOF;
    function ThereIsText(pStart, pEnd: Integer): Boolean;
  end;

implementation

{ TTokenizer }

function TTokenizer.ThereIsText(pStart, pEnd: Integer): Boolean;
// is there a non-blank character in the range ?
var
  p: Integer;
begin
  for p := pStart to pEnd do
    if Source[p] > ' ' then
      Exit(true);
  Result := False
end;

procedure TTokenizer.Advance;
var
  PosOpenBracket, p: Integer;
begin
  Token.TagReference := trUNPARSED;
  Token.Tag := '';
  DoNotAdvance := False;

  // find the next <
  PosOpenBracket := Locate('<');
  if PosOpenBracket = 0 then
  begin // EOF
    if ThereIsText(CurrentPos, SourceLength) then
    begin // trailing text
      Token.TokenType := ttText;
      Token.StartPos := CurrentPos;
      Token.EndPos := SourceLength;
      CurrentPos := Token.EndPos + 1;
    end
    else
      SetEOF;
    Exit;
  end;

  // if there is text between CurrentPos and PosOpenBracket then return a ttText
  if ThereIsText(CurrentPos, PosOpenBracket - 1) then
  begin
    Token.TokenType := ttText;
    Token.Tag := 'TEXT';
    Token.TagReference := trTEXT;
    Token.StartPos := CurrentPos;
    Token.EndPos := PosOpenBracket - 1;
    CurrentPos := PosOpenBracket;
    Exit
  end;

  if PosOpenBracket + 3 > SourceLength then
  begin
    SetEOF;
    Exit
  end;

  // if the Tag starts with <!, it may be a comment, DOCTYPE or propriority (like Microsofts's <![endif]--> )
  if (Source[PosOpenBracket + 1] = '!') then
  begin // if the Tag signals a comment '<!--' then return start and end of text between open/close comment tags
    if (Source[PosOpenBracket + 2] = '-') AND (Source[PosOpenBracket + 3] = '-') then
    begin
      Token.TokenType := ttCommentTag;
      Token.Tag := 'COMMENT';
      Token.StartPos := PosOpenBracket + 4;
      p := posEx('-->', Source, Token.StartPos);
      if p = 0 then
        Token.EndPos := SourceLength
      else
        Token.EndPos := p - 1;
      CurrentPos := Token.EndPos + 4;
      Exit
    end
    else if (UpperCase(Source[PosOpenBracket + 2]) <> 'D') // DOCTYPE, treated below as opentag
    then
    begin // step over it
      CurrentPos := Locate('>') + 1;
      Advance;
      Exit;
    end
  end;

  // is it an end Tag? starting with '</'
  if (Source[PosOpenBracket + 1] = '/') then
  begin
    Token.TokenType := ttCloseTag;
    Token.StartPos := PosOpenBracket + 2; // first Char after '</'
    CurrentPos := Token.StartPos;
    p := Locate('>');
    if p = 0 then
      Token.EndPos := SourceLength
    else
      Token.EndPos := p - 1; // last Char before '>'
    CurrentPos := Token.EndPos + 2;
    Token.DetermineTag(Source);
    Exit
  end;

  // it is an open Tag
  Token.TokenType := ttOpenTag;
  Token.StartPos := PosOpenBracket + 1; // first Char after '<'
  CurrentPos := Token.StartPos;
  p := Locate('>');
  if p = 0 then
    Token.EndPos := SourceLength
  else
    Token.EndPos := p - 1; // last Char before '>'
  CurrentPos := Token.EndPos + 2;
  Token.DetermineTag(Source);
end;

procedure TTokenizer.Assign(const aSource: string);
begin
  Source := aSource;
end;

procedure TTokenizer.Initialize;
begin
  CurrentPos := 1;
  SourceLength := Length(Source);
end;

procedure TTokenizer.LoadFromFile(aFileName: string);
var
  sList: TStringList;
begin
  sList := TStringList.Create;
  try
    sList.LoadFromFile(aFileName);
    Source := sList.Text;
  except
    Source := '<-- ERROR READING FILE ' + aFileName + ' -->';
  end;
  sList.Free;
end;

function TTokenizer.Locate(aCh: Char): Integer;
// same as utilities.pos but simpler
begin
  Result := CurrentPos;
  while (Result <= SourceLength) AND (Source[Result] <> aCh) do
    Inc(Result);
  if Result > SourceLength then
    Result := 0;
end;

procedure TTokenizer.SetEOF;
begin
  Token.TokenType := ttEmpty;
  Token.StartPos := SourceLength + 1;
  Token.EndPos := Token.StartPos;
  CurrentPos := Token.StartPos;
end;

function TTokenizer.TagString: string;
// return the string from Token.StartPos to Token.EndPos, trimmed
begin
  Result := Copy(Source, Token.StartPos, Token.EndPos - Token.StartPos + 1);
  Result := Trim(Result)
end;

{ RToken }

procedure RToken.DetermineTag(var Source: string);
var
  p: Integer;
begin
  p := StartPos;
  // skip blanks
  while (p < EndPos) AND (Source[p] <= ' ') do
    Inc(p);
  // the Tag is next string up to blank
  Tag := '';
  while (p <= EndPos) AND (Source[p] > ' ') do
  begin
    Tag := Tag + UpperCase(Source[p]);
    Inc(p)
  end;

  TagReference := getTagReference(Tag);
end;

end.
