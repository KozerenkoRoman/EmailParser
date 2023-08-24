unit UhtmlReference;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

interface

uses SysUtils, classes, Generics.collections;

type
  TtagReference = (trA, trABBR, trACRONYM, trADDRESS, trAPPLET, trAREA, trARTICLE, trASIDE, trAUDIO, trB, trBASE,
    trBASEFONT, trBDI, trBDO, trBIG, trBLOCKQUOTE, trBODY, trBR, trBUTTON, trCANVAS, trCAPTION, trCENTER, trCITE,
    trCODE, trCOL, trCOLGROUP, trCOMMENT, trDATA, trDATALIST, trDD, trDEL, trDETAILS, trDFN, trDIALOG, trDIR, trDIV,
    trDL, trDOCTYPE, trDT, trEM, trEMBED, trFIELDSET, trFIGCAPTION, trFIGURE, trFONT, trFOOTER, trFORM, trFRAME,
    trFRAMESET, trH1, trH2, trH3, trH4, trH5, trH6, trHEAD, trHEADER, trHR, trHTML, trI, trIFRAME, trIMG, trINPUT,
    trINS, trKBD, trLABEL, trLEGEND, trLI, trLINK, trMAIN, trMAP, trMARK, trMETA, trMETER, trNAV, trNOFRAMES,
    trNOSCRIPT, trOBJECT, trOL, trOPTGROUP, trOPTION, trOUTPUT, trP, trPARAM, trPICTURE, trPRE, trPROGRESS, trQ, trRP,
    trRT, trRUBY, trS, trSAMP, trSCRIPT, trSECTION, trSELECT, trSMALL, trSOURCE, trSPAN, trSTRIKE, trSTRONG, trSTYLE,
    trSUB, trSUMMARY, trSUP, trSVG, trTABLE, trTBODY, trTD, trTEMPLATE, trTEXT, // for storing text
    trTEXTAREA, trTFOOT, trTH, trTHEAD, trTIME, trTITLE, trTR, trTRACK, trTT, trU, trUNKNOWN, // just in case
    trUNPARSED, // reference not set
    trUL, trVAR, trVIDEO, trWBR);

  TtagReferenceSet = set of TtagReference;

function getTagReference(const aTag: string): TtagReference;
function BodylessTag(tag: TtagReference): boolean;
function ImplicitCloseTag(currentTag, nextTag: TtagReference): boolean;

const
  nlcr = #13#10;

implementation

{
  // function getTagReference has two implementations. The one commented out here
  // uses a Tdictionary of (tagname,tagReference) pairs. If you want to use that,
  // then remove the comment marks around the initialization / finalization sections
  // as well.

  type
  TtagReferenceTable = Tdictionary<string,TtagReference>;

  var tagReferenceTable: TtagReferenceTable;


  function getTagReference(var tag : string) : TtagReference;
  // assign tagReference for speedy tag selection later
  begin
  if (tag='') OR NOT tagReferenceTable.TryGetValue(tag,result)
  then result:=trUNKNOWN
  end;
}

function getTagReference(const aTag: string): TtagReference;
// assign tagReference for speedy tag selection later
var
  tag: string;
begin
  result := trUNKNOWN;
  if aTag = '' then
    exit;
  tag := UpperCase(aTag);

  case tag[1] of
    'A':
      if tag = 'A' then
        result := trA
      else
        case tag[2] of
          'B':
            if tag = 'ABBR' then
              result := trABBR;
          'C':
            if tag = 'ACRONYM' then
              result := trACRONYM;
          'D':
            if tag = 'ADDRESS' then
              result := trADDRESS;
          'P':
            if tag = 'APPLET' then
              result := trAPPLET;
          'R':
            if tag = 'AREA' then
              result := trAREA
            else if tag = 'ARTICLE' then
              result := trARTICLE;
          'S':
            if tag = 'ASIDE' then
              result := trASIDE;
          'U':
            if tag = 'AUDIO' then
              result := trAUDIO;
        end;
    'B':
      if tag = 'B' then
        result := trB
      else
        case tag[2] of
          'A':
            if tag = 'BASE' then
              result := trBASE
            else if tag = 'BASEFONT' then
              result := trBASEFONT;
          'D':
            if tag = 'BDI' then
              result := trBDI
            else if tag = 'BDO' then
              result := trBDO;
          'I':
            if tag = 'BIG' then
              result := trBIG;
          'L':
            if tag = 'BLOCKQUOTE' then
              result := trBLOCKQUOTE;
          'O':
            if tag = 'BODY' then
              result := trBODY;
          'R':
            if tag = 'BR' then
              result := trBR;
          'U':
            if tag = 'BUTTON' then
              result := trBUTTON;
        end;
    'C':
      if length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'CANVAS' then
              result := trCANVAS
            else if tag = 'CAPTION' then
              result := trCAPTION;
          'E':
            if tag = 'CENTER' then
              result := trCENTER;
          'I':
            if tag = 'CITE' then
              result := trCITE;
          'O':
            if tag = 'CODE' then
              result := trCODE
            else if tag = 'COL' then
              result := trCOL
            else if tag = 'COLGROUP' then
              result := trCOLGROUP;
        end;
    'D':
      if length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'DATA' then
              result := trDATA
            else if tag = 'DATALIST' then
              result := trDATALIST;
          'D':
            if tag = 'DD' then
              result := trDD;
          'E':
            if tag = 'DEL' then
              result := trDEL
            else if tag = 'DETAILS' then
              result := trDETAILS;
          'F':
            if tag = 'DFN' then
              result := trDFN;
          'I':
            if tag = 'DIALOG' then
              result := trDIALOG
            else if tag = 'DIR' then
              result := trDIR
            else if tag = 'DIV' then
              result := trDIV;
          'L':
            if tag = 'DL' then
              result := trDL;
          'T':
            if tag = 'DT' then
              result := trDT;
        end;
    'E':
      if tag = 'EM' then
        result := trEM
      else if tag = 'EMBED' then
        result := trEMBED
      else
        result := trUNKNOWN;
    'F':
      if length(tag) > 1 then
        case tag[2] of
          'I':
            if tag = 'FIELDSET' then
              result := trFIELDSET
            else if tag = 'FIGCAPTION' then
              result := trFIGCAPTION
            else if tag = 'FIGURE' then
              result := trFIGURE;
          'O':
            if tag = 'FONT' then
              result := trFONT
            else if tag = 'FOOTER' then
              result := trFOOTER
            else if tag = 'FORM' then
              result := trFORM;
          'R':
            if tag = 'FRAME' then
              result := trFRAME
            else if tag = 'FRAMESET' then
              result := trFRAMESET;
        end;
    'H':
      if (length(tag) > 1) then
        case tag[2] of
          '1':
            result := trH1;
          '2':
            result := trH2;
          '3':
            result := trH3;
          '4':
            result := trH4;
          '5':
            result := trH5;
          '6':
            result := trH6;
          'E':
            if tag = 'HEAD' then
              result := trHEAD
            else if tag = 'HEADER' then
              result := trHEADER;
          'R':
            if tag = 'HR' then
              result := trHR;
          'T':
            if tag = 'HTML' then
              result := trHTML;
        end;
    'I':
      if tag = 'I' then
        result := trI
      else
        case tag[2] of
          'F':
            if tag = 'IFRAME' then
              result := trIFRAME;
          'M':
            if tag = 'IMG' then
              result := trIMG;
          'N':
            if tag = 'INPUT' then
              result := trINPUT
            else if tag = 'INS' then
              result := trINS;
        end;
    'K':
      if tag = 'KBD' then
        result := trKBD;
    'L':
      if tag = 'LABEL' then
        result := trLABEL
      else if tag = 'LEGEND' then
        result := trLEGEND
      else if tag = 'LI' then
        result := trLI
      else if tag = 'LINK' then
        result := trLINK
      else
        result := trUNKNOWN;
    'M':
      if length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'MAIN' then
              result := trMAIN
            else if tag = 'MAP' then
              result := trMAP
            else if tag = 'MARK' then
              result := trMARK;
          'E':
            if tag = 'META' then
              result := trMETA
            else if tag = 'METER' then
              result := trMETER;
        end;
    'N':
      if tag = 'NAV' then
        result := trNAV
      else if tag = 'NOFRAMES' then
        result := trNOFRAMES
      else if tag = 'NOSCRIPT' then
        result := trNOSCRIPT;
    'O':
      if tag = 'OBJECT' then
        result := trOBJECT
      else if tag = 'OL' then
        result := trOL
      else if tag = 'OPTGROUP' then
        result := trOPTGROUP
      else if tag = 'OPTION' then
        result := trOPTION
      else if tag = 'OUTPUT' then
        result := trOUTPUT;
    'P':
      if tag = 'P' then
        result := trP
      else
        case tag[2] of
          'A':
            if tag = 'PARAM' then
              result := trPARAM;
          'I':
            if tag = 'PICTURE' then
              result := trPICTURE;
          'R':
            if tag = 'PRE' then
              result := trPRE
            else if tag = 'PROGRESS' then
              result := trPROGRESS;
        end;
    'Q':
      if tag = 'Q' then
        result := trQ;
    'R':
      if tag = 'RP' then
        result := trRP
      else if tag = 'RT' then
        result := trRT
      else if tag = 'RUBY' then
        result := trRUBY
      else
        result := trUNKNOWN;
    'S':
      if tag = 'S' then
        result := trS
      else
        case tag[2] of
          'A':
            if tag = 'SAMP' then
              result := trSAMP;
          'C':
            if tag = 'SCRIPT' then
              result := trSCRIPT;
          'E':
            if tag = 'SECTION' then
              result := trSECTION
            else if tag = 'SELECT' then
              result := trSELECT;
          'M':
            if tag = 'SMALL' then
              result := trSMALL;
          'O':
            if tag = 'SOURCE' then
              result := trSOURCE;
          'P':
            if tag = 'SPAN' then
              result := trSPAN;
          'T':
            if tag = 'STRIKE' then
              result := trSTRIKE
            else if tag = 'STRONG' then
              result := trSTRONG
            else if tag = 'STYLE' then
              result := trSTYLE;
          'U':
            if tag = 'SUB' then
              result := trSUB
            else if tag = 'SUMMARY' then
              result := trSUMMARY
            else if tag = 'SUP' then
              result := trSUP;
          'V':
            if tag = 'SVG' then
              result := trSVG;
        end;
    'T':
      if length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'TABLE' then
              result := trTABLE;
          'B':
            if tag = 'TBODY' then
              result := trTBODY;
          'D':
            if tag = 'TD' then
              result := trTD;
          'E':
            if tag = 'TEMPLATE' then
              result := trTEMPLATE
            else if tag = 'TEXT' then
              result := trTEXT
            else if tag = 'TEXTAREA' then
              result := trTEXTAREA;
          'F':
            if tag = 'TFOOT' then
              result := trTFOOT;
          'H':
            if tag = 'TH' then
              result := trTH
            else if tag = 'THEAD' then
              result := trTHEAD;
          'I':
            if tag = 'TIME' then
              result := trTIME
            else if tag = 'TITLE' then
              result := trTITLE;
          'R':
            if tag = 'TR' then
              result := trTR
            else if tag = 'TRACK' then
              result := trTRACK;
          'T':
            if tag = 'TT' then
              result := trTT;
        end;
    'U':
      if tag = 'U' then
        result := trU
      else if tag = 'UL' then
        result := trUL;
    'V':
      if tag = 'VAR' then
        result := trVAR
      else if tag = 'VIDEO' then
        result := trVIDEO;
    'W':
      if tag = 'WBR' then
        result := trWBR;
    '!':
      if tag = '!DOCTYPE' then
        result := trDOCTYPE
      else if (length(tag) >= 3) AND (tag[2] = '-') AND (tag[3] = '-') then
        result := trCOMMENT;
  end;
end;

function BodylessTag(tag: TtagReference): boolean;
// these are the tags that do not have a closing tag
begin
  result := tag IN [trDOCTYPE, trBASE, trBASEFONT, trBR, trCOL, trDT, trFRAME, trHR, trIMG, trINPUT, trLINK, trMETA,
    trPARAM, trWBR]
end;

function ImplicitCloseTag(currentTag, nextTag: TtagReference): boolean;
// When parsing an element with currentTag, is the next element with nextTag a child or a sibling?
// Examples:
// <IMG><B> : <B> is a sibling. <IMG> is implicitly closed
// <TR><TD><TD> : the second <TD> is a sibling
// <TR><TD><TR> : both <TD> and <TR> are closed
begin
  result := false;
  if currentTag = trUNPARSED then
    exit(false);

  // all elements that do not have a closing tag (like <IMG>) are implicitly closed by any following element
  if BodylessTag(currentTag) then
    exit(true);

  // <TR>,  <THEAD>, <TFOOT> closes <TR>, <TD>, <THEAD>, <TFOOT>
  if nextTag IN [trTR, trTHEAD, trTFOOT] then
    exit(currentTag IN [trTR, trTD, trTHEAD, trTFOOT]);
  // <TD> closes <TD>
  if (nextTag = trTD) AND (currentTag = trTD) then
    exit(true);

  // <LI> closes <LI>
  if nextTag = trLI then
    exit(currentTag = trLI);

  // <DD> and <DT> close <DD>, <DT>
  if (nextTag IN [trDD, trDT]) then
    exit(currentTag IN [trDD, trDT]);

  // <HEAD>, <BODY> close each other
  if nextTag IN [trHEAD, trBODY] then
    exit(currentTag IN [trHEAD, trBODY]);

  if nextTag = trDOCTYPE then
    exit(true);
end;

{
  // needed only when activating the function getTagReference that is based on
  // a Tdictionary of (tagname,tagReference) pairs.
  initialization
  tagReferenceTable:=TtagReferenceTable.Create(500);

  tagReferenceTable.add('ABBR',trABBR);
  tagReferenceTable.add('ACRONYM',trACRONYM);
  tagReferenceTable.add('ADDRESS',trADDRESS);
  tagReferenceTable.add('APPLET',trAPPLET);
  tagReferenceTable.add('AREA',trAREA);
  tagReferenceTable.add('ARTICLE',trARTICLE);
  tagReferenceTable.add('ASIDE',trASIDE);
  tagReferenceTable.add('AUDIO',trAUDIO);
  tagReferenceTable.add('B',trB);
  tagReferenceTable.add('BASE',trBASE);
  tagReferenceTable.add('BASEFONT',trBASEFONT);
  tagReferenceTable.add('BDI',trBDI);
  tagReferenceTable.add('BDO',trBDO);
  tagReferenceTable.add('BIG',trBIG);
  tagReferenceTable.add('BLOCKQUOTE',trBLOCKQUOTE);
  tagReferenceTable.add('BODY',trBODY);
  tagReferenceTable.add('BR',trBR);
  tagReferenceTable.add('BUTTON',trBUTTON);
  tagReferenceTable.add('CANVAS',trCANVAS);
  tagReferenceTable.add('CAPTION',trCAPTION);
  tagReferenceTable.add('CENTER',trCENTER);
  tagReferenceTable.add('CITE',trCITE);
  tagReferenceTable.add('CODE',trCODE);
  tagReferenceTable.add('COL',trCOL);
  tagReferenceTable.add('COLGROUP',trCOLGROUP);
  tagReferenceTable.add('COMMENT',trCOMMENT);
  tagReferenceTable.add('DATA',trDATA);
  tagReferenceTable.add('DATALIST',trDATALIST);
  tagReferenceTable.add('DD',trDD);
  tagReferenceTable.add('DEL',trDEL);
  tagReferenceTable.add('DETAILS',trDETAILS);
  tagReferenceTable.add('DFN',trDFN);
  tagReferenceTable.add('DIALOG',trDIALOG);
  tagReferenceTable.add('DIR',trDIR);
  tagReferenceTable.add('DIV',trDIV);
  tagReferenceTable.add('DL',trDL);
  tagReferenceTable.add('DOCTYPE',trDOCTYPE);
  tagReferenceTable.add('DT',trDT);
  tagReferenceTable.add('EM',trEM);
  tagReferenceTable.add('EMBED',trEMBED);
  tagReferenceTable.add('FIELDSET',trFIELDSET);
  tagReferenceTable.add('FIGCAPTION',trFIGCAPTION);
  tagReferenceTable.add('FIGURE',trFIGURE);
  tagReferenceTable.add('FONT',trFONT);
  tagReferenceTable.add('FOOTER',trFOOTER);
  tagReferenceTable.add('FORM',trFORM);
  tagReferenceTable.add('FRAME',trFRAME);
  tagReferenceTable.add('FRAMESET',trFRAMESET);
  tagReferenceTable.add('H1',trH1);
  tagReferenceTable.add('H2',trH2);
  tagReferenceTable.add('H3',trH3);
  tagReferenceTable.add('H4',trH4);
  tagReferenceTable.add('H5',trH5);
  tagReferenceTable.add('H6',trH6);
  tagReferenceTable.add('HEAD',trHEAD);
  tagReferenceTable.add('HEADER',trHEADER);
  tagReferenceTable.add('HR',trHR);
  tagReferenceTable.add('HTML',trHTML);
  tagReferenceTable.add('I',trI);
  tagReferenceTable.add('IFRAME',trIFRAME);
  tagReferenceTable.add('IMG',trIMG);
  tagReferenceTable.add('INPUT',trINPUT);
  tagReferenceTable.add('INS',trINS);
  tagReferenceTable.add('KBD',trKBD);
  tagReferenceTable.add('LABEL',trLABEL);
  tagReferenceTable.add('LEGEND',trLEGEND);
  tagReferenceTable.add('LI',trLI);
  tagReferenceTable.add('LINK',trLINK);
  tagReferenceTable.add('MAIN',trMAIN);
  tagReferenceTable.add('MAP',trMAP);
  tagReferenceTable.add('MARK',trMARK);
  tagReferenceTable.add('META',trMETA);
  tagReferenceTable.add('METER',trMETER);
  tagReferenceTable.add('NAV',trNAV);
  tagReferenceTable.add('NOFRAMES',trNOFRAMES);
  tagReferenceTable.add('NOSCRIPT',trNOSCRIPT);
  tagReferenceTable.add('OBJECT',trOBJECT);
  tagReferenceTable.add('OL',trOL);
  tagReferenceTable.add('OPTGROUP',trOPTGROUP);
  tagReferenceTable.add('OPTION',trOPTION);
  tagReferenceTable.add('OUTPUT',trOUTPUT);
  tagReferenceTable.add('P',trP);
  tagReferenceTable.add('PARAM',trPARAM);
  tagReferenceTable.add('PICTURE',trPICTURE);
  tagReferenceTable.add('PRE',trPRE);
  tagReferenceTable.add('PROGRESS',trPROGRESS);
  tagReferenceTable.add('Q',trQ);
  tagReferenceTable.add('RP',trRP);
  tagReferenceTable.add('RT',trRT);
  tagReferenceTable.add('RUBY',trRUBY);
  tagReferenceTable.add('S',trS);
  tagReferenceTable.add('SAMP',trSAMP);
  tagReferenceTable.add('SCRIPT',trSCRIPT);
  tagReferenceTable.add('SECTION',trSECTION);
  tagReferenceTable.add('SELECT',trSELECT);
  tagReferenceTable.add('SMALL',trSMALL);
  tagReferenceTable.add('SOURCE',trSOURCE);
  tagReferenceTable.add('SPAN',trSPAN);
  tagReferenceTable.add('STRIKE',trSTRIKE);
  tagReferenceTable.add('STRONG',trSTRONG);
  tagReferenceTable.add('STYLE',trSTYLE);
  tagReferenceTable.add('SUB',trSUB);
  tagReferenceTable.add('SUMMARY',trSUMMARY);
  tagReferenceTable.add('SUP',trSUP);
  tagReferenceTable.add('SVG',trSVG);
  tagReferenceTable.add('TABLE',trTABLE);
  tagReferenceTable.add('TBODY',trTBODY);
  tagReferenceTable.add('TD',trTD);
  tagReferenceTable.add('TEMPLATE',trTEMPLATE);
  tagReferenceTable.add('TEXTAREA',trTEXTAREA);
  tagReferenceTable.add('TFOOT',trTFOOT);
  tagReferenceTable.add('TH',trTH);
  tagReferenceTable.add('THEAD',trTHEAD);
  tagReferenceTable.add('TIME',trTIME);
  tagReferenceTable.add('TITLE',trTITLE);
  tagReferenceTable.add('TR',trTR);
  tagReferenceTable.add('TRACK',trTRACK);
  tagReferenceTable.add('TT',trTT);
  tagReferenceTable.add('U',trU);
  tagReferenceTable.add('UL',trUL);
  tagReferenceTable.add('VAR',trVAR);
  tagReferenceTable.add('VIDEO',trVIDEO);
  tagReferenceTable.add('WBR',trWBR);


  finalization
  tagReferenceTable.Free;
}
end.
