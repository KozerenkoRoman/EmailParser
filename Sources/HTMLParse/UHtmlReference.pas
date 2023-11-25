unit UhtmlReference;

// License: GNU General Public License version 3.0 (GPLv3)
// Author : Tom de Neef, tomdeneef@gmail.com
// 10 november 2019
// part of HTML parser project

interface

uses
  System.SysUtils, System.Classes, Generics.Collections;

type
  TTagReference = (trA, trABBR, trACRONYM, trADDRESS, trAPPLET, trAREA, trARTICLE, trASIDE, trAUDIO, trB, trBASE,
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

  TtagReferenceSet = set of TTagReference;

function GetTagReference(const aTag: string): TTagReference;
function BodylessTag(tag: TTagReference): Boolean;
function ImplicitCloseTag(currentTag, nextTag: TTagReference): Boolean;

implementation

{
  // function GetTagReference has two implementations. The one commented out here
  // uses a Tdictionary of (tagname,tagReference) pairs. If you want to use that,
  // then remove the comment marks around the initialization / finalization sections
  // as well.

  type
  TtagReferenceTable = Tdictionary<string,TTagReference>;

  var tagReferenceTable: TtagReferenceTable;


  function GetTagReference(var tag : string) : TTagReference;
  // assign tagReference for speedy tag selection later
  begin
  if (tag='') OR NOT tagReferenceTable.TryGetValue(tag,Result)
  then Result:=trUNKNOWN
  end;
}

function GetTagReference(const aTag: string): TTagReference;
// assign tagReference for speedy tag selection later
var
  tag: string;
begin
  Result := trUNKNOWN;
  if aTag = '' then
    Exit;
  tag := UpperCase(aTag);

  case tag[1] of
    'A':
      if tag = 'A' then
        Result := trA
      else
        case tag[2] of
          'B':
            if tag = 'ABBR' then
              Result := trABBR;
          'C':
            if tag = 'ACRONYM' then
              Result := trACRONYM;
          'D':
            if tag = 'ADDRESS' then
              Result := trADDRESS;
          'P':
            if tag = 'APPLET' then
              Result := trAPPLET;
          'R':
            if tag = 'AREA' then
              Result := trAREA
            else if tag = 'ARTICLE' then
              Result := trARTICLE;
          'S':
            if tag = 'ASIDE' then
              Result := trASIDE;
          'U':
            if tag = 'AUDIO' then
              Result := trAUDIO;
        end;
    'B':
      if tag = 'B' then
        Result := trB
      else
        case tag[2] of
          'A':
            if tag = 'BASE' then
              Result := trBASE
            else if tag = 'BASEFONT' then
              Result := trBASEFONT;
          'D':
            if tag = 'BDI' then
              Result := trBDI
            else if tag = 'BDO' then
              Result := trBDO;
          'I':
            if tag = 'BIG' then
              Result := trBIG;
          'L':
            if tag = 'BLOCKQUOTE' then
              Result := trBLOCKQUOTE;
          'O':
            if tag = 'BODY' then
              Result := trBODY;
          'R':
            if tag = 'BR' then
              Result := trBR;
          'U':
            if tag = 'BUTTON' then
              Result := trBUTTON;
        end;
    'C':
      if Length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'CANVAS' then
              Result := trCANVAS
            else if tag = 'CAPTION' then
              Result := trCAPTION;
          'E':
            if tag = 'CENTER' then
              Result := trCENTER;
          'I':
            if tag = 'CITE' then
              Result := trCITE;
          'O':
            if tag = 'CODE' then
              Result := trCODE
            else if tag = 'COL' then
              Result := trCOL
            else if tag = 'COLGROUP' then
              Result := trCOLGROUP;
        end;
    'D':
      if Length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'DATA' then
              Result := trDATA
            else if tag = 'DATALIST' then
              Result := trDATALIST;
          'D':
            if tag = 'DD' then
              Result := trDD;
          'E':
            if tag = 'DEL' then
              Result := trDEL
            else if tag = 'DETAILS' then
              Result := trDETAILS;
          'F':
            if tag = 'DFN' then
              Result := trDFN;
          'I':
            if tag = 'DIALOG' then
              Result := trDIALOG
            else if tag = 'DIR' then
              Result := trDIR
            else if tag = 'DIV' then
              Result := trDIV;
          'L':
            if tag = 'DL' then
              Result := trDL;
          'T':
            if tag = 'DT' then
              Result := trDT;
        end;
    'E':
      if tag = 'EM' then
        Result := trEM
      else if tag = 'EMBED' then
        Result := trEMBED
      else
        Result := trUNKNOWN;
    'F':
      if Length(tag) > 1 then
        case tag[2] of
          'I':
            if tag = 'FIELDSET' then
              Result := trFIELDSET
            else if tag = 'FIGCAPTION' then
              Result := trFIGCAPTION
            else if tag = 'FIGURE' then
              Result := trFIGURE;
          'O':
            if tag = 'FONT' then
              Result := trFONT
            else if tag = 'FOOTER' then
              Result := trFOOTER
            else if tag = 'FORM' then
              Result := trFORM;
          'R':
            if tag = 'FRAME' then
              Result := trFRAME
            else if tag = 'FRAMESET' then
              Result := trFRAMESET;
        end;
    'H':
      if (Length(tag) > 1) then
        case tag[2] of
          '1':
            Result := trH1;
          '2':
            Result := trH2;
          '3':
            Result := trH3;
          '4':
            Result := trH4;
          '5':
            Result := trH5;
          '6':
            Result := trH6;
          'E':
            if tag = 'HEAD' then
              Result := trHEAD
            else if tag = 'HEADER' then
              Result := trHEADER;
          'R':
            if tag = 'HR' then
              Result := trHR;
          'T':
            if tag = 'HTML' then
              Result := trHTML;
        end;
    'I':
      if tag = 'I' then
        Result := trI
      else
        case tag[2] of
          'F':
            if tag = 'IFRAME' then
              Result := trIFRAME;
          'M':
            if tag = 'IMG' then
              Result := trIMG;
          'N':
            if tag = 'INPUT' then
              Result := trINPUT
            else if tag = 'INS' then
              Result := trINS;
        end;
    'K':
      if tag = 'KBD' then
        Result := trKBD;
    'L':
      if tag = 'LABEL' then
        Result := trLABEL
      else if tag = 'LEGEND' then
        Result := trLEGEND
      else if tag = 'LI' then
        Result := trLI
      else if tag = 'LINK' then
        Result := trLINK
      else
        Result := trUNKNOWN;
    'M':
      if Length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'MAIN' then
              Result := trMAIN
            else if tag = 'MAP' then
              Result := trMAP
            else if tag = 'MARK' then
              Result := trMARK;
          'E':
            if tag = 'META' then
              Result := trMETA
            else if tag = 'METER' then
              Result := trMETER;
        end;
    'N':
      if tag = 'NAV' then
        Result := trNAV
      else if tag = 'NOFRAMES' then
        Result := trNOFRAMES
      else if tag = 'NOSCRIPT' then
        Result := trNOSCRIPT;
    'O':
      if tag = 'OBJECT' then
        Result := trOBJECT
      else if tag = 'OL' then
        Result := trOL
      else if tag = 'OPTGROUP' then
        Result := trOPTGROUP
      else if tag = 'OPTION' then
        Result := trOPTION
      else if tag = 'OUTPUT' then
        Result := trOUTPUT;
    'P':
      if tag = 'P' then
        Result := trP
      else
        case tag[2] of
          'A':
            if tag = 'PARAM' then
              Result := trPARAM;
          'I':
            if tag = 'PICTURE' then
              Result := trPICTURE;
          'R':
            if tag = 'PRE' then
              Result := trPRE
            else if tag = 'PROGRESS' then
              Result := trPROGRESS;
        end;
    'Q':
      if tag = 'Q' then
        Result := trQ;
    'R':
      if tag = 'RP' then
        Result := trRP
      else if tag = 'RT' then
        Result := trRT
      else if tag = 'RUBY' then
        Result := trRUBY
      else
        Result := trUNKNOWN;
    'S':
      if tag = 'S' then
        Result := trS
      else
        case tag[2] of
          'A':
            if tag = 'SAMP' then
              Result := trSAMP;
          'C':
            if tag = 'SCRIPT' then
              Result := trSCRIPT;
          'E':
            if tag = 'SECTION' then
              Result := trSECTION
            else if tag = 'SELECT' then
              Result := trSELECT;
          'M':
            if tag = 'SMALL' then
              Result := trSMALL;
          'O':
            if tag = 'SOURCE' then
              Result := trSOURCE;
          'P':
            if tag = 'SPAN' then
              Result := trSPAN;
          'T':
            if tag = 'STRIKE' then
              Result := trSTRIKE
            else if tag = 'STRONG' then
              Result := trSTRONG
            else if tag = 'STYLE' then
              Result := trSTYLE;
          'U':
            if tag = 'SUB' then
              Result := trSUB
            else if tag = 'SUMMARY' then
              Result := trSUMMARY
            else if tag = 'SUP' then
              Result := trSUP;
          'V':
            if tag = 'SVG' then
              Result := trSVG;
        end;
    'T':
      if Length(tag) > 1 then
        case tag[2] of
          'A':
            if tag = 'TABLE' then
              Result := trTABLE;
          'B':
            if tag = 'TBODY' then
              Result := trTBODY;
          'D':
            if tag = 'TD' then
              Result := trTD;
          'E':
            if tag = 'TEMPLATE' then
              Result := trTEMPLATE
            else if tag = 'TEXT' then
              Result := trTEXT
            else if tag = 'TEXTAREA' then
              Result := trTEXTAREA;
          'F':
            if tag = 'TFOOT' then
              Result := trTFOOT;
          'H':
            if tag = 'TH' then
              Result := trTH
            else if tag = 'THEAD' then
              Result := trTHEAD;
          'I':
            if tag = 'TIME' then
              Result := trTIME
            else if tag = 'TITLE' then
              Result := trTITLE;
          'R':
            if tag = 'TR' then
              Result := trTR
            else if tag = 'TRACK' then
              Result := trTRACK;
          'T':
            if tag = 'TT' then
              Result := trTT;
        end;
    'U':
      if tag = 'U' then
        Result := trU
      else if tag = 'UL' then
        Result := trUL;
    'V':
      if tag = 'VAR' then
        Result := trVAR
      else if tag = 'VIDEO' then
        Result := trVIDEO;
    'W':
      if tag = 'WBR' then
        Result := trWBR;
    '!':
      if tag = '!DOCTYPE' then
        Result := trDOCTYPE
      else if (Length(tag) >= 3) AND (tag[2] = '-') AND (tag[3] = '-') then
        Result := trCOMMENT;
  end;
end;

function BodylessTag(tag: TTagReference): Boolean;
// these are the tags that do not have a closing tag
begin
  Result := tag IN [trDOCTYPE, trBASE, trBASEFONT, trBR, trCOL, trDT, trFRAME, trHR, trIMG, trINPUT, trLINK, trMETA, trPARAM, trWBR]
end;

function ImplicitCloseTag(currentTag, nextTag: TTagReference): Boolean;
// When parsing an element with currentTag, is the next element with nextTag a child or a sibling?
// Examples:
// <IMG><B> : <B> is a sibling. <IMG> is implicitly closed
// <TR><TD><TD> : the second <TD> is a sibling
// <TR><TD><TR> : both <TD> and <TR> are closed
begin
  Result := False;
  if currentTag = trUNPARSED then
    Exit(False);

  // all elements that do not have a closing tag (like <IMG>) are implicitly closed by any following element
  if BodylessTag(currentTag) then
    Exit(True);

  // <TR>,  <THEAD>, <TFOOT> closes <TR>, <TD>, <THEAD>, <TFOOT>
  if nextTag IN [trTR, trTHEAD, trTFOOT] then
    Exit(currentTag IN [trTR, trTD, trTHEAD, trTFOOT]);
  // <TD> closes <TD>
  if (nextTag = trTD) AND (currentTag = trTD) then
    Exit(True);

  // <LI> closes <LI>
  if nextTag = trLI then
    Exit(currentTag = trLI);

  // <DD> and <DT> close <DD>, <DT>
  if (nextTag IN [trDD, trDT]) then
    Exit(currentTag IN [trDD, trDT]);

  // <HEAD>, <BODY> close each other
  if nextTag IN [trHEAD, trBODY] then
    Exit(currentTag IN [trHEAD, trBODY]);

  if nextTag = trDOCTYPE then
    Exit(True);
end;

end.
