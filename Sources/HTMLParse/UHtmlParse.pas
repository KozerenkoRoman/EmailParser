unit UhtmlParse;

// HTML parser project
// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019

interface

uses System.Classes, System.SysUtils, System.Generics.Collections,
  UhtmlReference, UsourceParser, UhtmlChars;

type
  TtagType = (ttOpen, ttClose, ttNone);

  THTMLelement = class;

  THTMLelementList = class(Tlist)
  private
    function getItem(indx: integer): THTMLelement;
  public
    procedure free(plusItems: boolean = false);
    property items[indx: integer]: THTMLelement read getItem; default;
  end;

  THTMLelement = class
  private
    procedure analyseTagAttributes(var source: string);
    function processOpenTag(tokenizer: Ttokenizer): boolean;
    function processCloseTag(tokenizer: Ttokenizer): boolean;
    function getOwnText: string;
  public
    attributes: Tstringlist; // part of source:   <TAG class=C>zzzz text Y</TAG>
    bodyFirstPos: integer; // position of 'z' in source      or -1 for bodyless elements
    bodyLastPos: integer; // position of 'Y' in source      only for text and comment elements
    children: THTMLelementList;
    parent: THTMLelement;
    tag: string;
    tagFirstPos: integer; // position of 'T' in source
    tagReference: TtagReference;
    whereInSource: Pchar; // points to 1st char of element's text in source
    constructor Create(aParent: THTMLelement);
    destructor Destroy; override;

    function firstElementWithText(textpart: string; checkCase: boolean = false): THTMLelement;
    function showStructure(offset: string): string;
    procedure asText(exclTagReferences: TtagReferenceSet; sList: Tstringlist);
    procedure delete;
    procedure ParseHTMLstring(tokenizer: Ttokenizer);
    procedure selectElements(attributeName, attributeValue: string; searchInValue: boolean; var elements: THTMLelementList; unique: boolean = false);
    procedure selectElementsByTagReference(aTagReference: TtagReference; var elements: THTMLelementList);
    procedure selectElementsByText(textpart: string; var elements: THTMLelementList; checkCase: boolean);
    property ownText: string read getOwnText;
  end;

  THtmlDom = class(THTMLelement)
  private
    tokenizer: Ttokenizer;
    attrCollected: boolean;
    function getElementCount: integer;
    function getFilesize: integer;
  public
    constructor Create(const aHtmlText: string);
    destructor Destroy; override;

    function getElementById(anID: string): THTMLelement;
    function showStructure: string;
    function text(excludeTags: array of string): string;
    class function GetText(const aHtmlText: string): string;

    procedure assignReportList(aStrings: Tstrings);
    procedure collectTagAttributes;
    procedure getEelementsByClassName(aClassName: string; var elements: THTMLelementList);
    procedure getEelementsByTagName(aTagName: string; var elements: THTMLelementList);
    procedure getElementsByText(textpart: string; var elements: THTMLelementList; checkCase: boolean = false);
    procedure ParseHTMLstring;
    procedure selectElements(attributeName, attributeValue: string; searchInValue: boolean; var elements: THTMLelementList; unique: boolean = false);

    property elementCount: integer read getElementCount;
    property filesize: integer read getFilesize;
  end;

const
  avAnyValue = '*'; // non-empty attribute value

implementation

var
  CountElements: integer = 0;
  reportList: Tstrings = NIL;

const
  debug = false;

procedure report(txt: string);
begin
  if reportList <> NIL then
    reportList.Add(txt);
end;

{ THTMLelementList }

procedure THTMLelementList.free(plusItems: boolean = false);
var
  k: integer;
begin
  if plusItems then
    for k := count - 1 downto 0 do
      items[k].free;
  inherited free;
end;

function THTMLelementList.getItem(indx: integer): THTMLelement;
begin
  result := THTMLelement(inherited items[indx])
end;

{ THTMLelement }

constructor THTMLelement.Create(aParent: THTMLelement);
begin
  inherited create;
  parent := aParent;
  children := THTMLelementList.create;
  tag := '';
  tagReference := trUNPARSED;
  attributes := Tstringlist.create;
  whereInSource := NIL;
  inc(CountElements);
end;

procedure THTMLelement.delete;
// proper deletion from the tree: remove it from its parent's children list
var
  indx: integer;
begin
  if parent <> NIL then
  begin
    indx := parent.children.indexOf(self);
    if indx >= 0 then
      parent.children.delete(indx);
  end;
  free;
end;

destructor THTMLelement.Destroy;
begin
  attributes.free;
  children.free(true);
  inherited;
end;


function THTMLelement.processOpenTag(tokenizer: Ttokenizer): boolean;
// an Open tag  may cause an implicit close of self
// like <TD><TR>: the open tag <TR> implies that <TD> will be closed
// rather than introducing a child to <TD>
// The result will be FALSE when the tag is not yet processed.
var
  element: THTMLelement;
begin
  if debug then
    report('open : ' + tokenizer.token.tag);
  if ImplicitCloseTag(self.tagReference, tokenizer.token.tagReference) then
  begin
    tokenizer.doNOTadvance := true;
    if debug then
      report('implicit close');
    exit(false); // step out of current element and progress with parent
  end;
  // add a new element
  element := THTMLelement.create(self);
  element.tagReference := tokenizer.token.tagReference;
  element.tag := tokenizer.token.tag;
  element.tagFirstPos := tokenizer.token.startPos; // first char after '<'
  element.bodyFirstPos := tokenizer.token.endPos + 2; // first char after '>'
  element.bodyLastPos := -1; // no meaning
  children.Add(element);

  result := true;
  // if this is a new element without closing tag then it can not have children
  // otherwise parse for this new element
  if element.tagReference = trUNKNOWN then
  begin // when the tag is not HTML (tagReference = trUNKNOWN) we may
    // assume that there will be a corresponding closing tag or
    // that the tag is bodyless. That situation would be indicated
    // by a closing backslash, as in <special today=monday\>
    if tokenizer.source[element.bodyFirstPos - 2] <> '\' then
      element.ParseHTMLstring(tokenizer);
  end
  else if NOT bodylessTag(element.tagReference) then
    element.ParseHTMLstring(tokenizer);
end;

procedure THTMLelement.selectElements(attributeName, attributeValue: string; searchInValue: boolean;
  var elements: THTMLelementList; unique: boolean = false);
// Note that the match is case sensitive !
// When attributeValue = '*' (avAnyValue) all elements will be returned that have
// an attribute with the specified name, whatever its value.
// Special care should be taken for situations where the value can be a list
// like ' class="cHighlight, cSmall" '
// selecting 'cHigh' should not return the element in that case.
// if unique is specified (as TRUE) then the search will stop as soon as an
// match element is found. This can be used when locating an element with a
// unique attribute (like ID).
  function properDelimiter(ch: char): boolean;
  begin
    result := CharInSet(ch, [' ', ',', ';']);
  end;

var
  k, p: integer;
  s: string;
  select: boolean;
begin
  s := attributes.Values[attributeName];
  if attributeValue = avAnyValue then
    select := s <> ''
  else if searchInValue then
  begin
    p := pos(attributeValue, s);
    if p > 0 then // check that the value is a 'complete' value
    // i.e. it must be surrounded by blanks or comma's
    begin
      select := (p = 1) OR properDelimiter(s[p - 1]);
      if select then
      begin
        p := p + length(attributeValue);
        select := (p > length(s)) OR properDelimiter(s[p]);
      end
    end
    else
      select := false;
  end
  else
    select := attributeValue = s;

  if select then
    elements.Add(self);

  if NOT unique OR NOT select then
    for k := 0 to children.count - 1 do
      children[k].selectElements(attributeName, attributeValue, searchInValue, elements, unique)
end;

procedure THTMLelement.selectElementsByTagReference(aTagReference: TtagReference; var elements: THTMLelementList);
var
  k: integer;
begin
  if tagReference = aTagReference then
    elements.Add(self);

  for k := 0 to children.count - 1 do
    children[k].selectElementsByTagReference(aTagReference, elements);
end;

procedure THTMLelement.selectElementsByText(textpart: string; var elements: THTMLelementList; checkCase: boolean);
var
  k: integer;
begin
  if posOfSubstring(textpart, ownText, 1, checkCase) > 0 then
    elements.Add(self);

  for k := 0 to children.count - 1 do
    children[k].selectElementsByText(textpart, elements, checkCase)
end;

function THTMLelement.showStructure(offset: string): string;
var
  k: integer;
begin
  result := offset + '<' + tag;
  // show the attributes
  for k := 0 to attributes.count - 1 do
    result := result + ' ' + attributes[k];
  result := result + '>';
  if tagReference = trTEXT then
  begin
    k := bodyLastPos - bodyFirstPos + 1;
    result := result + ' ' + IntToStr(k) + ' char';
    if k > 1 then
      result := result + 's';
  end;
  result := result + nlcr;
  for k := 0 to children.count - 1 do
    result := result + children[k].showStructure(offset + '    ');
end;

function THTMLelement.firstElementWithText(textpart: string; checkCase: boolean = false): THTMLelement;
// find the first element containing textpart in its text
var
  k: integer;
begin
  if posOfSubstring(textpart, ownText, 1, checkCase) > 0 then
    exit(self);

  for k := 0 to children.count - 1 do
  begin
    result := children[k].firstElementWithText(textpart, checkCase);
    if result <> NIL then
      exit
  end;
  result := NIL
end;

function THTMLelement.getOwnText: string;
// only trTEXT elements have document text. We add trBR and trHR for convenience.
// return only the text of this element itself, not of its children
var
  n: integer;
  s: string;
begin
  case tagReference of
    trBR:
      result := nlcr;
    trHR:
      result := '--------------';
    trTEXT:
      begin // copy the text from the HTML source
        n := bodyLastPos - bodyFirstPos + 1;
        setLength(s, n);
        move(whereInSource^, s[1], n * sizeOf(char));
        result := sanitizeHTMLtext(s);
      end;
  else
    result := ''
  end;
end;

procedure THTMLelement.asText(exclTagReferences: TtagReferenceSet; sList: TStringlist);
// collect the text elements in the stringlist
// if the tag is excluded, no text will be collected from it and its children
  procedure textOfChildren(exclTagReferences: TtagReferenceSet; sList: Tstringlist);
  var
    k: integer;
  begin
    for k := 0 to children.count - 1 do
      children[k].asText(exclTagReferences, sList);
  end;

var
  s: string;
  n: integer;
begin
  if tagReference IN exclTagReferences then
    exit;

  s := ownText;
  if s <> '' then
    sList.AddObject(s, self);
  if tagReference IN [trLI, trDD, trDT, trP] then
  begin
    n := sList.count; // these elements require closing NLCR (if there is any text)
    textOfChildren(exclTagReferences, sList);
    if sList.count > n then
      sList.AddObject(nlcr, self);
  end
  else
    textOfChildren(exclTagReferences, sList);
end;

function THTMLelement.processCloseTag(tokenizer: Ttokenizer): boolean;
// this closing tag may be ours or it may be of a parent
// result is TRUE unless the closing tag is spurious
var
  element: THTMLelement;
begin
  if debug then
    report('close: ' + tokenizer.token.tag + '; self = ' + tag);
  result := true;
  // if this is not the closing tag of self, check if it belongs to a parent
  if tokenizer.token.tagReference = self.tagReference then
    exit; // close current element

  // check parents
  element := self.parent;
  while (element <> NIL) AND (element.tagReference <> tokenizer.token.tagReference) do
    element := element.parent;
  if element = NIL then
  begin // closing tag is spurious: skip
    if debug then
      report('unexpected close');
    tokenizer.advance;
    result := false;
  end;
  // closing tag belongs to a parent element: close all, recursively (i.e. without progressing)
  // tokenizer.token indicates an end tag and the tagReference has been calculated
  tokenizer.doNOTadvance := true;
end;

procedure THTMLelement.ParseHTMLstring(tokenizer: Ttokenizer);
var
  element: THTMLelement;
begin
  repeat
    // if the current token is a close tag that didn't belong to the last child, it is still actual
    if tokenizer.doNOTadvance then
      tokenizer.doNOTadvance := false
    else
      tokenizer.advance;

    case tokenizer.token.tokenType of
      ttOpenTag:
        if NOT processOpenTag(tokenizer) // implicit close, progress with parent
        then
          exit
        else if bodylessTag(tagReference) then
          exit;
      ttCloseTag:
        begin
          processCloseTag(tokenizer);
          exit;
        end;
      ttText:
        begin // introduce a textNode
          element := THTMLelement.create(self);
          element.tagReference := trTEXT;
          element.tag := 'TEXT';
          element.tagFirstPos := tokenizer.token.startPos;
          element.bodyFirstPos := tokenizer.token.startPos;
          element.bodyLastPos := tokenizer.token.endPos;
          element.whereInSource := @tokenizer.source[element.bodyFirstPos];
          children.Add(element);
        end;
      ttCommentTag:
        begin // add a comment tag; special because the end tag is special
          element := THTMLelement.create(self);
          element.tagReference := trCOMMENT;
          element.tag := 'COMMENT';
          element.tagFirstPos := tokenizer.token.startPos; // incorrect
          element.bodyFirstPos := tokenizer.token.startPos;
          element.bodyLastPos := tokenizer.token.endPos;
          children.Add(element);
        end;
    else
    end;
  until tokenizer.token.tokenType = ttEMPTY;
end;

procedure THTMLelement.analyseTagAttributes(var source: string);
// collect name=value pairs, quotes removed
var
  attName, attValue: string;
  p, pmax, pstart, k: integer;
  q: char;
begin
  if tagReference = trDOCTYPE then
    exit;

  p := tagFirstPos + length(tag) + 1; // there must be a blank anyway
  pmax := bodyFirstPos - 2;

  // the attributes are listed as 'name=value' separated by blanks.
  // NB 'name = value' will be recognized as welll

  while p < pmax do
  begin // find first non-blank (name part)
    while (p < pmax) AND (source[p] <= ' ') do
      inc(p);
    pstart := p;
    // find '='
    while (p < pmax) AND (source[p] <> '=') do
      inc(p);
    attName := copy(source, pstart, p - pstart);
    attName := trimRight(attName);
    if attName = '' then
      break;

    inc(p);
    // find first non-blank (value part)
    while (p < pmax) AND (source[p] <= ' ') do
      inc(p);
    // quote ?
    q := source[p];
    if CharInSet(q, ['''', '"']) then
      inc(p)
    else
      q := ' ';
    pstart := p;

    // find q (quote or blank) or end
    while (p <= pmax) AND (source[p] <> q) do
      inc(p);
    attValue := copy(source, pstart, p - pstart);
    // remove double blanks and nlcr
    // accept the search for '&' codes...
    attValue := sanitizeHTMLtext(attValue);

    attributes.Add(attName + '=' + attValue);
    inc(p)
  end;

  for k := 0 to children.count - 1 do
    children[k].analyseTagAttributes(source);
end;

{ THtmlDom }

procedure THtmlDom.assignReportList(aStrings: Tstrings);
begin
  reportList := aStrings;
end;

procedure THtmlDom.collectTagAttributes;
begin
  analyseTagAttributes(tokenizer.source);
  attrCollected := true;
end;

constructor THtmlDom.Create(const aHtmlText: string);
begin
  inherited create(NIL);
  tokenizer := Ttokenizer.create;
  tokenizer.assign(aHtmlText);
  tokenizer.initialize;

  CountElements := 0;
  attrCollected := false;

  reportList := NIL; // global to pass debug strings; see assignReportList
end;

destructor THtmlDom.Destroy;
begin
  tokenizer.free;
  inherited;
end;

procedure THtmlDom.getEelementsByClassName(aClassName: string; var elements: THTMLelementList);
// the resulting list must have been created. It will be cleared.
begin
  selectElements('class', aClassName, true, elements)
end;

procedure THtmlDom.getEelementsByTagName(aTagName: string; var elements: THTMLelementList);
// the resulting list must have been created. It will be cleared.
begin
  selectElementsByTagReference(getTagReference(aTagName), elements)
end;

function THtmlDom.getElementById(anID: string): THTMLelement;
var
  helpList: THTMLelementList;
begin
  helpList := THTMLelementList.create;
  inherited selectElements('ID', anID, false, helpList, true);
  if helpList.count > 0 then
    result := helpList[0]
  else
    result := NIL;
  helpList.free;
end;

function THtmlDom.getElementCount: integer;
// pass the global CountElements
begin
  result := CountElements;
end;

procedure THtmlDom.getElementsByText(textpart: string; var elements: THTMLelementList; checkCase: boolean = false);
// find all elements with textpart in their ownText.
begin
  elements.clear;
  selectElementsByText(textpart, elements, checkCase)
end;

function THtmlDom.getFilesize: integer;
begin
  result := length(tokenizer.source);
end;

procedure THtmlDom.ParseHTMLstring;
begin
  inherited ParseHTMLstring(tokenizer)
end;

procedure THtmlDom.selectElements(attributeName, attributeValue: string; searchInValue: boolean;
  var elements: THTMLelementList; unique: boolean);
// return all elements that have the idecated attribute value
// for some attributes the value may be a list of values, such as 'class=basic, underlined'
// to select the elements with class=basic, specify searchInValue=TRUE.
// to select elements by tagname, use 'tagname' as if it is an attribute, like 'tagname=TABLE' to collect all
// <TABLE> elements (with their children).
begin
  elements.clear;
  if sameText(attributeName, 'tagname') then
    selectElementsByTagReference(getTagReference(attributeValue), elements)
  else
  begin
    if NOT attrCollected then
      collectTagAttributes;
    inherited selectElements(attributeName, attributeValue, searchInValue, elements, unique)
  end;
end;

function THtmlDom.showStructure: string;
begin
  result := inherited showStructure('');
end;

function THtmlDom.text(excludeTags: array of string): string;
// collect all text in the document apart from excluded tags.
  procedure getReferences(tags: array of string; var refs: TtagReferenceSet);
  var
    k: integer;
  begin
    refs := [];
    for k := 0 to high(tags) do
      refs := refs + [getTagReference(tags[k])];
  end;

var
  sList: Tstringlist;
  exclTagReferences: TtagReferenceSet;
begin
  getReferences(excludeTags, exclTagReferences);

  sList := Tstringlist.create;
  sList.Delimiter := ' ';
  sList.QuoteChar := ' ';
  asText(exclTagReferences, sList);
  result := sList.delimitedText;

  sList.free
end;

class function THtmlDom.GetText(const aHtmlText: string): string;
var
  HtmlDOM: THtmlDom;
  Elements: THTMLelementList;
begin
  HtmlDOM := THtmlDom.Create(aHtmlText);
  try
    HtmlDOM.ParseHTMLstring;
    Elements := THTMLelementList.Create;
    try
      HtmlDOM.selectElements('tagname', 'TEXT', true, Elements);
      Result := HtmlDOM.text(['head', 'script', 'style']);
    finally
      FreeAndNil(Elements)
    end;
  finally
    FreeAndNil(HtmlDOM)
  end;
end;

end.
