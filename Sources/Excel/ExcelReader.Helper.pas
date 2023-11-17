unit ExcelReader.Helper;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, ArrayHelper,
  Common.Types, System.Generics.Defaults, System.Types, Vcl.ComCtrls,
  {$IFDEF EXTENDED_COMPONENTS}
    //https://www.axolot.com/xls.htm
    //XLSSpreadSheet and XLSReadWriteII components
    XLSReadWriteII5, Xc12Utils5;
  {$ELSE}
    Excel4Delphi, Excel4Delphi.Stream;
  {$ENDIF EXTENDED_COMPONENTS}
{$ENDREGION}

type
  TSheet = record
    Title: string;
    Text : string;
  end;

function GetXlsSheetList(const aFileName: TFileName): TArrayRecord<TSheet>; overload;
function GetXlsSheetList(const aFileName: TFileName; const aSeparatorChar, aQuoteChar: Char): TArrayRecord<TSheet>; overload;

implementation

function GetXlsSheetList(const aFileName: TFileName): TArrayRecord<TSheet>;
begin
  Result := GetXlsSheetList(aFileName, ';', '"');
end;

{$IFDEF EXTENDED_COMPONENTS}
function GetXlsSheetList(const aFileName: TFileName; const aSeparatorChar, aQuoteChar: Char): TArrayRecord<TSheet>;
var
  ParsedText : string;
  RowIsEmpty : Boolean;
  RowText    : string;
  Sheet      : TSheet;
  WorkBook   : TXLSReadWriteII5;
begin
  WorkBook := TXLSReadWriteII5.Create(nil);
  try
    WorkBook.DirectRead := False;
    WorkBook.DirectWrite := False;
    try
      WorkBook.LoadFromFile(aFileName);
      Result := TArrayRecord<TSheet>.Create(WorkBook.Count);
      for var i := 0 to WorkBook.Count - 1 do
      begin
        WorkBook[i].CalcDimensions;
        if (WorkBook[i].LastCol > 0) and (WorkBook[i].LastRow > 0) then
        begin
          ParsedText := '';
          for var row := 0 to WorkBook[i].LastRow - 1 do
          begin
            RowText := '';
            RowIsEmpty := True;
            for var col := 0 to WorkBook[i].LastCol - 1 do
            begin
              RowIsEmpty := RowIsEmpty and WorkBook[i].AsEmpty[col, row];
              RowText := Concat(RowText, aQuoteChar, WorkBook[i].AsString[col, row].Replace(aQuoteChar, aQuoteChar + aQuoteChar), aQuoteChar, aSeparatorChar);
            end;
            if not RowIsEmpty then
              ParsedText := Concat(ParsedText, RowText, sLineBreak);
          end;
          Sheet.Text  := ParsedText;
          Sheet.Title := WorkBook.Sheets[i].Name;
          Result[i]   := Sheet;
        end;
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, 'GetXlsxSheetList', E.Message + sLineBreak + aFileName);
    end;
  finally
    FreeAndNil(WorkBook);
  end;
end;
{$ELSE}
function GetXlsSheetList(const aFileName: TFileName; const aSeparatorChar, aQuoteChar: Char): TArrayRecord<TSheet>;
var
  ParsedText : string;
  RowIsEmpty : Boolean;
  RowText    : string;
  Sheet      : TSheet;
  WorkBook   : TZWorkBook;
begin
  WorkBook := TZWorkBook.Create(nil);
  try
    try
      WorkBook.LoadFromFile(aFileName);
      Result := TArrayRecord<TSheet>.Create(WorkBook.Sheets.Count);
      for var i := 0 to WorkBook.Sheets.Count - 1 do
      begin
        ParsedText := '';
        if (WorkBook.Sheets[i].ColCount > 0) and (WorkBook.Sheets[i].RowCount > 0) then
        begin
          for var row := 0 to WorkBook.Sheets[i].RowCount - 1 do
          begin
            RowText := '';
            RowIsEmpty := True;
            for var col := 0 to WorkBook.Sheets[i].ColCount - 1 do
            begin
              RowIsEmpty := RowIsEmpty and WorkBook.Sheets[i].Cell[col, row].AsString.IsEmpty;
              RowText := Concat(RowText, aQuoteChar, WorkBook.Sheets[i].Cell[col, row].AsString.Replace(aQuoteChar, aQuoteChar + aQuoteChar), aQuoteChar, aSeparatorChar);
            end;
            if not RowIsEmpty then
              ParsedText := Concat(ParsedText, RowText, sLineBreak);
          end;
        end;
        Sheet.Text  := ParsedText;
        Sheet.Title := WorkBook.Sheets[i].Title;
        Result[i]   := Sheet;
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, 'GetXlsxSheetList', E.Message + sLineBreak + aFileName);
    end;
  finally
    FreeAndNil(WorkBook);
  end;
end;
{$ENDIF EXTENDED_COMPONENTS}

end.
