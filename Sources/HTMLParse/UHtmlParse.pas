unit UhtmlParse;

// HTML parser project
// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  UHtmlReference, USourceParser, UhtmlChars;

type
  TTagType = (ttOpen, ttClose, ttNone);

  THTMLElement = class;

  THTMLelementList = class(Tlist)
  private
    function GetItem(Indx: Integer): THTMLElement;
  public
    procedure Free(aPlusItems: Boolean = False);
    property Items[Indx: Integer]: THTMLElement read GetItem; default;
  end;

  THTMLElement = class
  private
    Attributes: TStringList; // part of Source:   <Tag class=C>zzzz Text Y</Tag>
    BodyFirstPos: Integer; // position of 'z' in Source      or -1 for bodyless aElements
    BodyLastPos: Integer; // position of 'Y' in Source      only for Text and comment aElements
    Children: THTMLelementList;
    Parent: THTMLElement;
    Tag: string;
    TagFirstPos: Integer; // position of 'T' in Source
    TagReference: TtagReference;
    WhereInSource: PChar; // points to 1st char of Element's text in source

    function GetOwnText: string;
    function ProcessCloseTag(Tokenizer: TTokenizer): Boolean;
    function ProcessOpenTag(Tokenizer: TTokenizer): Boolean;
    procedure AnalyseTagAttributes(var Source: string);
  public
    constructor Create(aParent: THTMLElement);
    destructor Destroy; override;

    function FirstElementWithText(aTextPart: string; aCheckCase: Boolean = False): THTMLElement;
    function ShowStructure(aOffset: string): string;
    procedure AsText(aTagReferences: TTagReferenceSet; AList: TStringList);
    procedure Delete;
    procedure ParseHTMLString(Tokenizer: TTokenizer);
    procedure SelectElements(aAttributeName, aAttributeValue: string; aSearchInValue: Boolean; var aElements: THTMLelementList; aUnique: Boolean = False);
    procedure SelectElementsByTagReference(aTagReference: TtagReference; var aElements: THTMLelementList);
    procedure SelectElementsByText(aTextPart: string; var aElements: THTMLelementList; aCheckCase: Boolean);
    property OwnText: string read GetOwnText;
  end;

  THtmlDom = class(THTMLElement)
  private
    Tokenizer: TTokenizer;
    AttrCollected: Boolean;
    function GetElementCount: Integer;
    function GetFileSize: Integer;
  public
    constructor Create(const aHtmlText: string);
    destructor Destroy; override;

    function GetElementById(anID: string): THTMLElement;
    function ShowStructure: string;
    function Text(aExcludeTags: array of string): string;
    class function GetText(const aHtmlText: string): string;

    procedure CollectTagAttributes;
    procedure GetEelementsByClassName(aClassName: string; var aElements: THTMLelementList);
    procedure GetEelementsByTagName(aTagName: string; var aElements: THTMLelementList);
    procedure GetElementsByText(aTextPart: string; var aElements: THTMLelementList; aCheckCase: Boolean = False);
    procedure ParseHTMLString;
    procedure SelectElements(aAttributeName, aAttributeValue: string; aSearchInValue: Boolean; var aElements: THTMLelementList; aUnique: Boolean = False);

    property ElementCount: Integer read GetElementCount;
    property FileSize: Integer read GetFileSize;
  end;

const
  C_ANY_VALUE = '*'; // non-empty attribute value

implementation

var
  CountElements: Integer = 0;

{ THTMLelementList }

procedure THTMLelementList.Free(aPlusItems: Boolean = False);
var
  k: Integer;
begin
  if aPlusItems then
    for k := Count - 1 downto 0 do
      Items[k].Free;
  inherited Free;
end;

function THTMLelementList.GetItem(Indx: Integer): THTMLElement;
begin
  Result := THTMLElement(inherited Items[Indx])
end;

{ THTMLElement }

constructor THTMLElement.Create(aParent: THTMLElement);
begin
  inherited Create;
  Parent := aParent;
  Children := THTMLelementList.Create;
  Tag := '';
  TagReference := trUNPARSED;
  Attributes := TStringList.Create;
  WhereInSource := nil;
  Inc(CountElements);
end;

procedure THTMLElement.Delete;
// proper deletion from the tree: remove it from its Parent's children list
var
  Indx: Integer;
begin
  if Parent <> nil then
  begin
    Indx := Parent.Children.IndexOf(Self);
    if Indx >= 0 then
      Parent.Children.Delete(Indx);
  end;
  Free;
end;

destructor THTMLElement.Destroy;
begin
  Attributes.Free;
  Children.Free(True);
  inherited;
end;


function THTMLElement.ProcessOpenTag(Tokenizer: TTokenizer): Boolean;
// an Open Tag  may cause an implicit close of Self
// like <TD><TR>: the open Tag <TR> implies that <TD> will be closed
// rather than introducing a child to <TD>
// The Result will be False when the Tag is not yet processed.
var
  Element: THTMLElement;
begin
  if ImplicitCloseTag(Self.TagReference, Tokenizer.Token.TagReference) then
  begin
    Tokenizer.DoNotAdvance := True;
    Exit(False); // step out of current Element and progress with Parent
  end;
  // add a new Element
  Element := THTMLElement.Create(Self);
  Element.TagReference := Tokenizer.Token.TagReference;
  Element.Tag := Tokenizer.Token.Tag;
  Element.TagFirstPos := Tokenizer.Token.StartPos; // first char after '<'
  Element.BodyFirstPos := Tokenizer.Token.EndPos + 2; // first char after '>'
  Element.BodyLastPos := -1; // no meaning
  Children.Add(Element);

  Result := True;
  // if this is a new Element without closing Tag then it can not have Children
  // otherwise parse for this new Element
  if Element.TagReference = trUNKNOWN then
  begin // when the Tag is not HTML (TagReference = trUNKNOWN) we may
    // assume that there will be a corresponding closing Tag or
    // that the Tag is bodyless. That situation would be indicated
    // by a closing backslash, as in <special today=monday\>
    if Tokenizer.Source[Element.BodyFirstPos - 2] <> '\' then
      Element.ParseHTMLString(Tokenizer);
  end
  else if NOT BodyLessTag(Element.TagReference) then
    Element.ParseHTMLString(Tokenizer);
end;

procedure THTMLElement.SelectElements(aAttributeName, aAttributeValue: string; aSearchInValue: Boolean;
  var aElements: THTMLelementList; aUnique: Boolean = False);

// Note that the match is case sensitive !
// When aAttributeValue = '*' (C_ANY_VALUE) all aElements will be returned that have
// an attribute with the specified name, whatever its value.
// Special care should be taken for situations where the value can be a list
// like ' class="cHighlight, cSmall" '
// selecting 'cHigh' should not return the Element in that case.
// if aUnique is specified (as True) then the search will stop as soon as an
// match Element is found. This can be used when locating an Element with a
// aUnique attribute (like ID).
  function ProperDelimiter(ch: char): Boolean;
  begin
    Result := CharInSet(ch, [' ', ',', ';']);
  end;

var
  k, p: Integer;
  s: string;
  select: Boolean;
begin
  s := Attributes.Values[aAttributeName];
  if aAttributeValue = C_ANY_VALUE then
    select := s <> ''
  else if aSearchInValue then
  begin
    p := Pos(aAttributeValue, s);
    if p > 0 then // check that the value is a 'complete' value
    // i.e. it must be surrounded by blanks or comma's
    begin
      select := (p = 1) OR ProperDelimiter(s[p - 1]);
      if select then
      begin
        p := p + Length(aAttributeValue);
        select := (p > Length(s)) OR ProperDelimiter(s[p]);
      end
    end
    else
      select := False;
  end
  else
    select := aAttributeValue = s;

  if select then
    aElements.Add(Self);

  if NOT aUnique OR NOT select then
    for k := 0 to Children.Count - 1 do
      Children[k].SelectElements(aAttributeName, aAttributeValue, aSearchInValue, aElements, aUnique)
end;

procedure THTMLElement.SelectElementsByTagReference(aTagReference: TtagReference; var aElements: THTMLelementList);
var
  k: Integer;
begin
  if TagReference = aTagReference then
    aElements.Add(Self);

  for k := 0 to Children.Count - 1 do
    Children[k].SelectElementsByTagReference(aTagReference, aElements);
end;

procedure THTMLElement.SelectElementsByText(aTextPart: string; var aElements: THTMLelementList; aCheckCase: Boolean);
var
  k: Integer;
begin
  if PosOfSubstring(aTextPart, OwnText, 1, aCheckCase) > 0 then
    aElements.Add(Self);

  for k := 0 to Children.Count - 1 do
    Children[k].SelectElementsByText(aTextPart, aElements, aCheckCase)
end;

function THTMLElement.ShowStructure(aOffset: string): string;
var
  k: Integer;
begin
  Result := aOffset + '<' + Tag;
  // show the Attributes
  for k := 0 to Attributes.Count - 1 do
    Result := Result + ' ' + Attributes[k];
  Result := Result + '>';
  if TagReference = trTEXT then
  begin
    k := BodyLastPos - BodyFirstPos + 1;
    Result := Result + ' ' + IntToStr(k) + ' char';
    if k > 1 then
      Result := Result + 's';
  end;
  Result := Result + sLineBreak;
  for k := 0 to Children.Count - 1 do
    Result := Result + Children[k].ShowStructure(aOffset + '    ');
end;

function THTMLElement.FirstElementWithText(aTextPart: string; aCheckCase: Boolean = False): THTMLElement;
// find the first Element containing aTextPart in its Text
var
  k: Integer;
begin
  if PosOfSubstring(aTextPart, OwnText, 1, aCheckCase) > 0 then
    Exit(Self);

  for k := 0 to Children.Count - 1 do
  begin
    Result := Children[k].FirstElementWithText(aTextPart, aCheckCase);
    if Result <> nil then
      Exit
  end;
  Result := nil
end;

function THTMLElement.GetOwnText: string;
// only trTEXT aElements have document Text. We add trBR and trHR for convenience.
// return only the Text of this Element itself, not of its Children
var
  n: Integer;
  s: string;
begin
  case TagReference of
    trBR:
      Result := sLineBreak;
    trHR:
      Result := '--------------';
    trTEXT:
      begin // Copy the Text from the HTML Source
        n := BodyLastPos - BodyFirstPos + 1;
        setLength(s, n);
        move(WhereInSource^, s[1], n * SizeOf(char));
        Result := SanitizeHTMLText(s);
      end;
  else
    Result := ''
  end;
end;

procedure THTMLElement.AsText(aTagReferences: TTagReferenceSet; AList: TStringList);
// collect the Text aElements in the stringlist
// if the Tag is excluded, no Text will be collected from it and its Children
  procedure textOfChildren(aTagReferences: TTagReferenceSet; AList: TStringList);
  var
    k: Integer;
  begin
    for k := 0 to Children.Count - 1 do
      Children[k].AsText(aTagReferences, AList);
  end;

var
  s: string;
  n: Integer;
begin
  if TagReference in aTagReferences then
    Exit;

  s := OwnText;
  if s <> '' then
    AList.AddObject(s, Self);
  if TagReference in [trLI, trDD, trDT, trP] then
  begin
    n := AList.Count; // these aElements require closing sLineBreak (if there is any Text)
    textOfChildren(aTagReferences, AList);
    if AList.Count > n then
      AList.AddObject(sLineBreak, Self);
  end
  else
    textOfChildren(aTagReferences, AList);
end;

function THTMLElement.ProcessCloseTag(Tokenizer: TTokenizer): Boolean;
// this closing Tag may be ours or it may be of a Parent
// Result is True unless the closing Tag is spurious
var
  Element: THTMLElement;
begin
  Result := True;
  // if this is not the closing Tag of Self, check if it belongs to a Parent
  if Tokenizer.Token.TagReference = Self.TagReference then
    Exit; // close current Element

  // check parents
  Element := Self.Parent;
  while (Element <> nil) AND (Element.TagReference <> Tokenizer.Token.TagReference) do
    Element := Element.Parent;
  if Element = nil then
  begin // closing Tag is spurious: skip
    Tokenizer.Advance;
    Result := False;
  end;
  // closing Tag belongs to a Parent Element: close all, recursively (i.e. without progressing)
  // Tokenizer.Token indicates an end Tag and the TagReference has been calculated
  Tokenizer.DoNOTadvance := True;
end;

procedure THTMLElement.ParseHTMLString(Tokenizer: TTokenizer);
var
  Element: THTMLElement;
begin
  repeat
    // if the current Token is a close Tag that didn't belong to the last child, it is still actual
    if Tokenizer.DoNOTadvance then
      Tokenizer.DoNOTadvance := False
    else
      Tokenizer.Advance;

    case Tokenizer.Token.tokenType of
      ttOpenTag:
        if NOT ProcessOpenTag(Tokenizer) // implicit close, progress with Parent
        then
          Exit
        else if BodyLessTag(TagReference) then
          Exit;
      ttCloseTag:
        begin
          ProcessCloseTag(Tokenizer);
          Exit;
        end;
      ttText:
        begin // introduce a textNode
          Element := THTMLElement.Create(Self);
          Element.TagReference := trTEXT;
          Element.Tag := 'TEXT';
          Element.TagFirstPos := Tokenizer.Token.StartPos;
          Element.BodyFirstPos := Tokenizer.Token.StartPos;
          Element.BodyLastPos := Tokenizer.Token.EndPos;
          Element.WhereInSource := @Tokenizer.Source[Element.BodyFirstPos];
          Children.Add(Element);
        end;
      ttCommentTag:
        begin // add a comment Tag; special because the end Tag is special
          Element := THTMLElement.Create(Self);
          Element.TagReference := trCOMMENT;
          Element.Tag := 'COMMENT';
          Element.TagFirstPos := Tokenizer.Token.StartPos; // incorrect
          Element.BodyFirstPos := Tokenizer.Token.StartPos;
          Element.BodyLastPos := Tokenizer.Token.EndPos;
          Children.Add(Element);
        end;
    else
    end;
  until Tokenizer.Token.tokenType = ttEMPTY;
end;

procedure THTMLElement.AnalyseTagAttributes(var Source: string);
// collect name=value pairs, quotes removed
var
  attName, attValue: string;
  p, pmax, pstart, k: Integer;
  q: char;
begin
  if TagReference = trDOCTYPE then
    Exit;

  p := TagFirstPos + Length(Tag) + 1; // there must be a blank anyway
  pmax := BodyFirstPos - 2;

  // the Attributes are listed as 'name=value' separated by blanks.
  // NB 'name = value' will be recognized as welll

  while p < pmax do
  begin // find first non-blank (name part)
    while (p < pmax) AND (Source[p] <= ' ') do
      Inc(p);
    pstart := p;
    // find '='
    while (p < pmax) AND (Source[p] <> '=') do
      Inc(p);
    attName := Copy(Source, pstart, p - pstart);
    attName := trimRight(attName);
    if attName = '' then
      break;

    Inc(p);
    // find first non-blank (value part)
    while (p < pmax) AND (Source[p] <= ' ') do
      Inc(p);
    // quote ?
    q := Source[p];
    if CharInSet(q, ['''', '"']) then
      Inc(p)
    else
      q := ' ';
    pstart := p;

    // find q (quote or blank) or end
    while (p <= pmax) AND (Source[p] <> q) do
      Inc(p);
    attValue := Copy(Source, pstart, p - pstart);
    // remove double blanks and LineBreak
    // accept the search for '&' codes...
    attValue := SanitizeHTMLText(attValue);

    Attributes.Add(attName + '=' + attValue);
    Inc(p)
  end;

  for k := 0 to Children.Count - 1 do
    Children[k].AnalyseTagAttributes(Source);
end;

{ THtmlDom }

procedure THtmlDom.CollectTagAttributes;
begin
  AnalyseTagAttributes(Tokenizer.Source);
  AttrCollected := True;
end;

constructor THtmlDom.Create(const aHtmlText: string);
begin
  inherited Create(nil);
  Tokenizer := TTokenizer.Create;
  Tokenizer.assign(aHtmlText);
  Tokenizer.initialize;

  CountElements := 0;
  AttrCollected := False;
end;

destructor THtmlDom.Destroy;
begin
  Tokenizer.Free;
  inherited;
end;

procedure THtmlDom.GetEelementsByClassName(aClassName: string; var aElements: THTMLelementList);
// the resulting list must have been created. It will be cleared.
begin
  SelectElements('class', aClassName, True, aElements)
end;

procedure THtmlDom.GetEelementsByTagName(aTagName: string; var aElements: THTMLelementList);
// the resulting list must have been created. It will be cleared.
begin
  SelectElementsByTagReference(GetTagReference(aTagName), aElements)
end;

function THtmlDom.GetElementById(anID: string): THTMLElement;
var
  helpList: THTMLelementList;
begin
  helpList := THTMLelementList.Create;
  inherited SelectElements('ID', anID, False, helpList, True);
  if helpList.Count > 0 then
    Result := helpList[0]
  else
    Result := nil;
  helpList.Free;
end;

function THtmlDom.GetElementCount: Integer;
// pass the global CountElements
begin
  Result := CountElements;
end;

procedure THtmlDom.GetElementsByText(aTextPart: string; var aElements: THTMLelementList; aCheckCase: Boolean = False);
// find all aElements with aTextPart in their OwnText.
begin
  aElements.Clear;
  SelectElementsByText(aTextPart, aElements, aCheckCase)
end;

function THtmlDom.GetFileSize: Integer;
begin
  Result := Length(Tokenizer.Source);
end;

procedure THtmlDom.ParseHTMLString;
begin
  inherited ParseHTMLString(Tokenizer)
end;

procedure THtmlDom.SelectElements(aAttributeName, aAttributeValue: string; aSearchInValue: Boolean;
  var aElements: THTMLelementList; aUnique: Boolean);
// return all aElements that have the idecated attribute value
// for some Attributes the value may be a list of values, such as 'class=basic, underlined'
// to select the aElements with class=basic, specify aSearchInValue=True.
// to select aElements by tagname, use 'tagname' as if it is an attribute, like 'tagname=TABLE' to collect all
// <TABLE> aElements (with their Children).
begin
  aElements.Clear;
  if SameText(aAttributeName, 'tagname') then
    SelectElementsByTagReference(GetTagReference(aAttributeValue), aElements)
  else
  begin
    if NOT AttrCollected then
      CollectTagAttributes;
    inherited SelectElements(aAttributeName, aAttributeValue, aSearchInValue, aElements, aUnique)
  end;
end;

function THtmlDom.ShowStructure: string;
begin
  Result := inherited ShowStructure('');
end;

function THtmlDom.Text(aExcludeTags: array of string): string;
// collect all Text in the document apart from excluded tags.
  procedure getReferences(tags: array of string; var refs: TTagReferenceSet);
  var
    k: Integer;
  begin
    refs := [];
    for k := 0 to High(tags) do
      refs := refs + [GetTagReference(tags[k])];
  end;

var
  AList: TStringList;
  aTagReferences: TTagReferenceSet;
begin
  getReferences(aExcludeTags, aTagReferences);

  AList := TStringList.Create;
  AList.Delimiter := ' ';
  AList.QuoteChar := ' ';
  AsText(aTagReferences, AList);
  Result := AList.DelimitedText;

  AList.Free
end;

class function THtmlDom.GetText(const aHtmlText: string): string;
var
  HtmlDOM: THtmlDom;
  aElements: THTMLelementList;
begin
  HtmlDOM := THtmlDom.Create(aHtmlText);
  try
    HtmlDOM.ParseHTMLString;
    aElements := THTMLelementList.Create;
    try
      HtmlDOM.SelectElements('tagname', 'TEXT', True, aElements);
      Result := HtmlDOM.Text(['head', 'script', 'style']);
    finally
      FreeAndNil(aElements)
    end;
  finally
    FreeAndNil(HtmlDOM)
  end;
end;

end.
