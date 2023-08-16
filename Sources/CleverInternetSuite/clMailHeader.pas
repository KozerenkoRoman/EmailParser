{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMailHeader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clWUtils, clUtils, clHeaderFieldList, clEmailAddress, clEncoder, clPercentEncoder;

type
  TclMailHeaderFieldList = class(TclHeaderFieldList)
  private
    FCharSet: string;
    FEncoding: TclEncodeMethod;
    FIsRfc2231: Boolean;

    class function DecodeEncodedWord(const AFieldPart, ACharSet: string; AEncoding: TclEncodeMethod; ADecodedStream: TStream): string;
    class function TranslateDecodedWord(ADecodedStream: TStream; const ACharSet: string; AEncoding: TclEncodeMethod): string;
    class function EncodingNameToType(const AEncodingName: string): TclEncodeMethod;
    class procedure GetEncodedWord(const AText, ACharSet: string; var AEncodedWord: string; var AEncoding: TclEncodeMethod);
    class procedure GetStringsToEncode(const AText: string; AEncodedLength, ACharsPerLine: Integer; AStrings: TStrings);

    function GetMailFieldValue(AIndex: Integer): string;
    function Rfc2231EncodeField(const AItemName, AFieldValue, ACharSet: string; ACharsPerLine: Integer): string;
  protected
    function CheckIsRfc2231(const AItemName: string): Boolean;
    function GetQuoteSymbols: TCharSet; override;
  public
    constructor Create(const ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer);

    function GetFieldValue(AIndex: Integer): string; overload; override;

    function GetDecodedFieldValue(const AName: string): string; overload;
    function GetDecodedFieldValue(AIndex: Integer): string; overload;

    function GetDecodedEmail(const AName: string): string; overload;
    function GetDecodedEmail(AIndex: Integer): string; overload;

    procedure GetDecodedEmailList(const AName: string; AList: TclEmailAddressList); overload;
    procedure GetDecodedEmailList(AIndex: Integer; AList: TclEmailAddressList); overload;

    function GetDecodedFieldValueItem(const ASource, AItemName: string): string;

    procedure AddEncodedField(const AName, AValue: string);
    procedure AddEncodedFieldItem(const AFieldName, AItemName, AValue: string); overload;
    procedure AddEncodedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string); overload;

    procedure AddEncodedEmail(const AName, AValue: string);

    procedure AddEncodedEmailList(const AName: string; AList: TclEmailAddressList);

    class function DecodeEmail(const ACompleteEmail, ACharSet: string): string;
    class function DecodeField(const AFieldValue, ACharSet: string): string;
    class function EncodeEmail(const ACompleteEmail, ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
    class function EncodeField(const AFieldValue, ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;

    property CharSet: string read FCharSet write FCharSet;
    property Encoding: TclEncodeMethod read FEncoding write FEncoding;
  end;

  TclRfc2231HeaderEncoder = class(TclPercentEncoder)
  private
    FLanguage: string;
    FCharSet: string;
  protected
    function IsUnsafeChar(ACharCode: Byte): Boolean; override;
    function Parse(const AInput: string; var ACharSet, ALanguage, AOutPut: string): Boolean; virtual;
    function Build(const AValue, ACharSet, ALanguage: string): string; virtual;
  public
    function Encode(const AValue, ACharSet, ALanguage: string): string;
    function Decode(const AValue: string): string;

    property CharSet: string read FCharSet;
    property Language: string read FLanguage;
  end;

implementation

uses
  clTranslator;

{ TclMailHeaderFieldList }

procedure TclMailHeaderFieldList.AddEncodedEmail(const AName, AValue: string);
var
  src: TStrings;
begin
  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      src.Text := GetNameValuePair(AName, EncodeEmail(AValue, CharSet, Encoding,
        CharsPerLine - Length(AName) - Length(': ')));
      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedEmailList(const AName: string; AList: TclEmailAddressList);
var
  i: Integer;
  src: TStrings;
  email: string;
begin
  Assert(Source <> nil);

  if (AList.Count > 0) then
  begin
    src := TStringList.Create();
    try
      email := EncodeEmail(AList[0].FullAddress, CharSet, Encoding, CharsPerLine - Length(AName) - Length(': '));
      if (AList.Count > 1) then
      begin
        email := email + ',';
      end;

      AddTextStr(src, GetNameValuePair(AName, email));

      for i := 1 to AList.Count - 1 do
      begin
        email := EncodeEmail(AList[i].FullAddress, CharSet, Encoding, CharsPerLine - Length(#9));
        if (i < AList.Count - 1) then
        begin
          email := email + ',';
        end;

        AddTextStr(src, email);
      end;

      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedField(const AName, AValue: string);
var
  src: TStrings;
begin
  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      src.Text := GetNameValuePair(AName, EncodeField(AValue, CharSet, Encoding,
        CharsPerLine - Length(AName) - Length(': ')));
      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

function TclMailHeaderFieldList.Rfc2231EncodeField(const AItemName, AFieldValue, ACharSet: string;
  ACharsPerLine: Integer): string;
var
  list: TStrings;
  encoder: TclRfc2231HeaderEncoder;
  i: Integer;
  s: string;
begin
  list := nil;
  encoder := nil;
  try
    list := TStringList.Create();
    encoder := TclRfc2231HeaderEncoder.Create();

    Result := encoder.Encode(AFieldValue, ACharSet, '');

    GetStringsToEncode(AFieldValue, Length(Result), ACharsPerLine, list);

    if (list.Count > 1) then
    begin
      s := encoder.Encode(list[0], ACharSet, '');
      Result := GetItemNameValuePair(AItemName + IntToStr(0) + '*', s) + ';'#13#10;

      for i := 1 to list.Count - 1 do
      begin
        s := encoder.EncodeString(list[i], ACharSet);
        Result := Result + GetItemNameValuePair(AItemName + IntToStr(i) + '*', s);

        if (i < list.Count - 1) then
        begin
          Result := Result + ';'#13#10;
        end;
      end;

      Result := Trim(Result);
    end else
    begin
      Result := GetItemNameValuePair(AItemName, Result);
    end;
  finally
    encoder.Free();
    list.Free();
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string);
var
  src: TStrings;
  line, newline, trimmedLine: string;
  fieldEnd: Integer;
begin
  if ((AFieldIndex < 0) or (AFieldIndex >= FieldList.Count)) then Exit;

  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      if CheckIsRfc2231(AItemName) then
      begin
        newline := Rfc2231EncodeField(AItemName, AValue, CharSet, CharsPerLine - Length(#9)
          - Length(AItemName) - Length('*0*') - Length('=""') - Length(';'));
      end else
      begin
        newline := GetQuotedString(EncodeField(AValue, CharSet, Encoding,
          CharsPerLine - Length(#9) - Length(AItemName) - Length('=""')));

        newline := GetItemNameValuePair(AItemName, newline);
      end;

      fieldEnd := GetFieldEnd(AFieldIndex);

      line := Source[fieldEnd];
      trimmedLine := Trim(line);

      if (trimmedLine <> '') and (not CharInSet(trimmedLine[Length(trimmedLine)], [';', ':'])) then
      begin
        line := line + ';';
      end;

      Source[fieldEnd] := line;

      src.Text := newline;
      InsertFoldedStrings(fieldEnd + 1, src, #9, #9);
    finally
      src.Free();
    end;
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedFieldItem(const AFieldName, AItemName, AValue: string);
begin
  AddEncodedFieldItem(GetFieldIndex(AFieldName), AItemName, AValue);
end;

function TclMailHeaderFieldList.CheckIsRfc2231(const AItemName: string): Boolean;
begin
  Result := (Length(AItemName) > 0) and (AItemName[Length(AItemName)] = '*');
end;

constructor TclMailHeaderFieldList.Create(const ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer);
begin
  inherited Create();

  FCharSet := ACharSet;
  FEncoding := AEncoding;
  CharsPerLine := ACharsPerLine;
  FIsRfc2231 := False;
end;

class function TclMailHeaderFieldList.DecodeEmail(const ACompleteEmail, ACharSet: string): string;
var
  name, email: string;
begin
  Result := ACompleteEmail;
  if GetEmailAddressParts(Result, name, email) and (email <> '') then
  begin
    name := DecodeField(name, ACharSet);
    Result := GetCompleteEmailAddress(name, email);
  end;
end;

class function TclMailHeaderFieldList.DecodeEncodedWord(const AFieldPart,
  ACharSet: string; AEncoding: TclEncodeMethod; ADecodedStream: TStream): string;
var
  encoder: TclEncoder;
  oldPos: Int64;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.SuppressCrlf := False;
    encoder.EncodeMethod := AEncoding;

    oldPos := ADecodedStream.Position;
    encoder.Decode(AFieldPart, ADecodedStream);
    ADecodedStream.Position := oldPos;

    Result := TranslateDecodedWord(ADecodedStream, ACharSet, AEncoding);
  finally
    encoder.Free();
  end;
end;

class function TclMailHeaderFieldList.DecodeField(const AFieldValue, ACharSet: string): string;
var
  Formatted: Boolean;
  EncodedBegin, FirstDelim,
  SecondDelim, EncodedEnd, TextBegin: Integer;
  CurLine, s, EncodingName, CharsetName: String;
  decodedStream: TStream;
  isUtf8: Boolean;
begin
  Result := '';

  decodedStream := TMemoryStream.Create();
  try
    Formatted := False;
    TextBegin := 1;
    CurLine := AFieldValue;
    EncodedBegin := Pos('=?', CurLine);
    isUtf8 := True;

    while (EncodedBegin <> 0) do
    begin
      Result := Result + Copy(CurLine, TextBegin, EncodedBegin - TextBegin);
      TextBegin := EncodedBegin;

      FirstDelim := TextPos('?', CurLine, EncodedBegin + 2);
      if (FirstDelim <> 0) then
      begin
        SecondDelim := TextPos('?', CurLine, FirstDelim + 1);
        if ((SecondDelim - FirstDelim) = 2) then
        begin
          EncodedEnd := TextPos('?=', CurLine, SecondDelim + 1);
          if (EncodedEnd <> 0) then
          begin
            try
              CharsetName := Copy(CurLine, EncodedBegin + 2, FirstDelim - 2 - EncodedBegin);
              EncodingName := CurLine[FirstDelim + 1];

              isUtf8 := isUtf8 and SameText(CharsetName, 'utf-8');

              s := Copy(CurLine, SecondDelim + 1, EncodedEnd - SecondDelim - 1);

              Result := Result + DecodeEncodedWord(s, CharsetName, EncodingNameToType(EncodingName), decodedStream);

              TextBegin := EncodedEnd + 2;
              Formatted := True;
            except
              TextBegin := EncodedBegin + 2;
              Result := Result + '=?';
            end;

            CurLine := Copy(CurLine, TextBegin, Length(CurLine));
            s := TrimLeft(CurLine);
            if (Pos('=?', s) <> 1) then
            begin
              s := GetUnfoldedLine(CurLine);
            end;
            CurLine := s;

            EncodedBegin := Pos('=?', CurLine);
            TextBegin := 1;
            Continue;
          end;
        end;
      end;

      EncodedBegin := 0;
    end;

    if (CurLine <> '') then
    begin
      Result := Result + Copy(CurLine, TextBegin, Length(CurLine));
    end;

    if Formatted and isUtf8 then
    begin
      decodedStream.Position := 0;
      Result := TranslateDecodedWord(decodedStream, 'utf-8', EncodingNameToType(EncodingName));
    end else
    if (not Formatted) then
    begin
      Result := DecodeEncodedWord(AFieldValue, ACharSet, cmNone, decodedStream);
    end;
  finally
    decodedStream.Free();
  end;
end;

class function TclMailHeaderFieldList.EncodeEmail(const ACompleteEmail, ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
var
  encodedName, encodedEmail: string;
  len, ind, chrsPerLine, encodedNameLen: Integer;
  addr: TclEmailAddressItem;
begin
  Result := ACompleteEmail;

  addr := TclEmailAddressItem.Create();
  try
    addr.FullAddress := Result;
    if (addr.Name = '') then Exit;

    chrsPerLine := ACharsPerLine - Length(' <');
    encodedName := EncodeField(addr.Name, ACharSet, AEncoding, chrsPerLine);

    addr.Name := encodedName;

    Result := addr.FullAddress;

    encodedNameLen := Length(Result) - Length(addr.Email) - Length(' <>');
    len := RTextPos(#13#10, Result);

    if (len > 0) then
    begin
      len := chrsPerLine - (encodedNameLen - (len - 1) - Length(#13#10)) - Length(#9);
    end else
    begin
      len := chrsPerLine - encodedNameLen;
    end;

    if (len < Length(addr.Email)) then
    begin
      len := ACharsPerLine - Length(#9) - Length('<>');
      addr.Delimiter := #13#10;
    end;

    if (len + 1 >= Length(addr.Email)) then
    begin
      len := Length(addr.Email);
    end;

    ind := 1;
    encodedEmail := encodedEmail + System.Copy(addr.Email, ind, len);
    Inc(ind, len);

    len := ACharsPerLine - Length(#9) - Length('>');
    while (ind < Length(addr.Email)) do
    begin
      encodedEmail := encodedEmail + #13#10 + System.Copy(addr.Email, ind, len);
      Inc(ind, len);
    end;

    addr.Name := encodedName;
    addr.Email := encodedEmail;

    Result := addr.FullAddress;
  finally
    addr.Free();
  end;
end;

class function TclMailHeaderFieldList.EncodeField(const AFieldValue, ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
var
  i: Integer;
  s: string;
  enc: TclEncodeMethod;
  list: TStrings;
begin
  Assert(ACharsPerLine > 0);

  Result := AFieldValue;
  if (Result = '') or (AEncoding = cmUUEncode) then Exit;

  list := TStringList.Create();
  try
    s := '';
    enc := AEncoding;
    GetEncodedWord(AFieldValue, ACharSet, s, enc);

    GetStringsToEncode(AFieldValue, Length(s), ACharsPerLine, list);

    if (enc = cmNone) and (list.Count > 1) then
    begin
      s := '';
      enc := cmQuotedPrintable;
      GetEncodedWord(AFieldValue, ACharSet, s, enc);

      GetStringsToEncode(AFieldValue, Length(s), ACharsPerLine, list);
    end;

    Result := '';

    for i := 0 to list.Count - 1 do
    begin
      s := '';
      GetEncodedWord(list[i], ACharSet, s, enc);
      Result := Result + s + #13#10;
    end;

    Result := Trim(Result);

    if (Result = '') then
    begin
      Result := AFieldValue;
    end;
  finally
    list.Free();
  end;
end;

class function TclMailHeaderFieldList.EncodingNameToType(const AEncodingName: string): TclEncodeMethod;
begin
  Result := cmNone;
  if (AEncodingName = '') then Exit;
  case UpperCase(AEncodingName)[1] of
    'Q': Result := cmQuotedPrintable;
    'B': Result := cmBase64;
  end;
end;

function TclMailHeaderFieldList.GetDecodedFieldValue(const AName: string): string;
begin
  Result := GetDecodedFieldValue(GetFieldIndex(AName));
end;

function TclMailHeaderFieldList.GetDecodedEmail(const AName: string): string;
begin
  Result := GetDecodedEmail(GetFieldIndex(AName));
end;

function TclMailHeaderFieldList.GetDecodedEmail(AIndex: Integer): string;
begin
  Result := DecodeEmail(GetFieldValue(AIndex), CharSet);
end;

procedure TclMailHeaderFieldList.GetDecodedEmailList(const AName: string; AList: TclEmailAddressList);
begin
  GetDecodedEmailList(GetFieldIndex(AName), AList);
end;

procedure TclMailHeaderFieldList.GetDecodedEmailList(AIndex: Integer; AList: TclEmailAddressList);
var
  i: Integer;
  list: TStrings;
begin
  AList.Clear();

  if ((AIndex < 0) or (AIndex >= FieldList.Count)) then Exit;

  list := TStringList.Create();
  try
    ExtractQuotedWords(GetFieldValue(AIndex), list, ',', ['"', '('], ['"', ')'], True);
    for i := 0 to list.Count - 1 do
    begin
      AList.Add(DecodeEmail(Trim(list[i]), CharSet));
    end;
  finally
    list.Free();
  end;
end;

function TclMailHeaderFieldList.GetDecodedFieldValue(AIndex: Integer): string;
begin
  Result := DecodeField(GetFieldValue(AIndex), CharSet);
end;

function TclMailHeaderFieldList.GetDecodedFieldValueItem(const ASource, AItemName: string): string;
var
  encoder: TclRfc2231HeaderEncoder;
  ind: Integer;
  s: string;
begin
  encoder := TclRfc2231HeaderEncoder.Create();
  try
    FIsRfc2231 := CheckIsRfc2231(AItemName);

    Result := GetFieldValueItem(ASource, AItemName);

    if FIsRfc2231 then
    begin
      if (Result = '') then
      begin
        ind := 0;
        s := '';
        repeat
          s := GetFieldValueItem(ASource, AItemName + IntToStr(ind));
          if (s <> '') then
          begin
            s := DecodeField(s, CharSet);
          end else
          begin
            s := GetFieldValueItem(ASource, AItemName + IntToStr(ind) + '*');
            if (s <> '') then
            begin
              if (ind > 0) and (encoder.CharSet <> '') then
              begin
                s := encoder.DecodeString(s, encoder.CharSet);
              end else
              begin
                s := encoder.Decode(s);
              end;
            end;
          end;

          Result := Result + s;
          Inc(ind);
        until (s = '');
      end else
      begin
        Result := encoder.Decode(Result);
      end;
    end else
    begin
      Result := DecodeField(Result, CharSet);
    end;
  finally
    FIsRfc2231 := False;
    encoder.Free();
  end;
end;

class procedure TclMailHeaderFieldList.GetEncodedWord(const AText, ACharSet: string;
  var AEncodedWord: string; var AEncoding: TclEncodeMethod);
const
  EncodingToName: array[TclEncodeMethod] of string = ('', 'Q', 'B', '', '');
var
  cnt: Integer;
  src: TStream;
  buf: TclByteArray;
  encoder: TclEncoder;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  src := nil;
  encoder := nil;
  try
    src := TMemoryStream.Create();

    cnt := TclTranslator.GetByteCount(AText, ACharSet);
    if (cnt > 0) then
    begin
      SetLength(buf, cnt);
      buf := TclTranslator.GetBytes(AText, ACharSet);
      src.Write(buf[0], cnt);
    end;

    encoder := TclEncoder.Create(nil);
    encoder.SuppressCrlf := True;
    encoder.EncodeMethod := AEncoding;

    if (encoder.EncodeMethod = cmNone) then
    begin
      src.Position := 0;
      encoder.EncodeMethod := encoder.GetPreferredEncoding(src);
    end;

    AEncoding := encoder.EncodeMethod;

    src.Position := 0;
    AEncodedWord := encoder.Encode(src);

    if (encoder.EncodeMethod = cmQuotedPrintable) then
    begin
      AEncodedWord := StringReplace(AEncodedWord, #32, '_', [rfReplaceAll]);
      AEncodedWord := StringReplace(AEncodedWord, '='#13#10, #13#10, [rfReplaceAll]);
      AEncodedWord := StringReplace(AEncodedWord, '?', '=3F', [rfReplaceAll]);
    end;

    if (EncodingToName[encoder.EncodeMethod] <> '') then
    begin
      AEncodedWord := Format('=?%s?%s?%s?=', [ACharSet, EncodingToName[encoder.EncodeMethod], AEncodedWord]);
    end;
  finally
    encoder.Free();
    src.Free();
  end;
end;

function TclMailHeaderFieldList.GetMailFieldValue(AIndex: Integer): string;
var
  Ind, i: Integer;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    Ind := GetFieldStart(AIndex);
    Result := System.Copy(Source[Ind], Length(FieldList[AIndex] + ':') + 1, MaxInt);
    Result := TrimFirstWhiteSpace(Result);
    for i := Ind + 1 to Source.Count - 1 do
    begin
      if not ((Source[i] <> '') and CharInSet(Source[i][1], [#9, #32])) then
      begin
        Break;
      end;
      if (Result <> '') and (Result[Length(Result)] = '>') then
      begin
        Result := Result + ',';
      end;
      Result := Result + GetUnfoldedLine(Source[i]);
    end;
  end else
  begin
    Result := '';
  end;
end;

function TclMailHeaderFieldList.GetQuoteSymbols: TCharSet;
begin
  if (FIsRfc2231) then
  begin
    Result := ['"'];
  end else
  begin
    Result := inherited GetQuoteSymbols();
  end;
end;

class procedure TclMailHeaderFieldList.GetStringsToEncode(const AText: string; AEncodedLength, ACharsPerLine: Integer; AStrings: TStrings);
var
  ind, len, wordCnt, wordLen: Integer;
begin
  AStrings.Clear();

  wordCnt := AEncodedLength div ACharsPerLine;

  if (AEncodedLength mod ACharsPerLine) > 0 then
  begin
    Inc(wordCnt);
  end;

  len := Length(AText);
  wordLen := Trunc(len / wordCnt);

  ind := 1;
  while (ind <= len) do
  begin
    AStrings.Add(system.Copy(AText, ind, wordLen));
    Inc(ind, wordLen);
  end;
end;

function TclMailHeaderFieldList.GetFieldValue(AIndex: Integer): string;
begin
  Result := '';

  if ((AIndex < 0) or (AIndex >= FieldList.Count)) then Exit;

  if ('subject' = FieldList[AIndex]) then
  begin
    Result := InternalGetFieldValue(AIndex);
  end else
  begin
    Result := Trim(GetMailFieldValue(AIndex));
  end;
end;

class function TclMailHeaderFieldList.TranslateDecodedWord(ADecodedStream: TStream;
  const ACharSet: string; AEncoding: TclEncodeMethod): string;
var
  i: Integer;
  buf: TclByteArray;
  size: Int64;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := '';

  size := ADecodedStream.Size - ADecodedStream.Position;

  if (size > 0) then
  begin
    SetLength(buf, size);
    ADecodedStream.Read(buf[0], size);

    if (AEncoding = cmQuotedPrintable) then
    begin
      for i := 0 to size - 1 do
      begin
        if (buf[i] = 95) then //'_'
          buf[i] := 32; //' '
      end;
    end;

    Result := TclTranslator.GetString(buf, 0, size, ACharSet);
  end;
end;

{ TclRfc2231HeaderEncoder }

function TclRfc2231HeaderEncoder.Build(const AValue, ACharSet, ALanguage: string): string;
begin
  Result := ACharSet + '''' + ALanguage + '''' + AValue;
end;

function TclRfc2231HeaderEncoder.Decode(const AValue: string): string;
begin
  if Parse(AValue, FCharSet, FLanguage, Result) then
  begin
    Result := DecodeString(Result, CharSet);
  end;
end;

function TclRfc2231HeaderEncoder.Encode(const AValue, ACharSet, ALanguage: string): string;
begin
  FCharSet := ACharSet;
  FLanguage := ALanguage;

  if (FCharSet <> '') then
  begin
    Result := Build(EncodeString(AValue, FCharSet), ACharSet, ALanguage);
  end else
  begin
    FLanguage := '';
    Result := AValue;
  end;
end;

function TclRfc2231HeaderEncoder.IsUnsafeChar(ACharCode: Byte): Boolean;
begin
  Result := not ((ACharCode in [$21..$3A]) or (ACharCode = $3C) or (ACharCode in [$3E..$7E]));
end;

function TclRfc2231HeaderEncoder.Parse(const AInput: string; var ACharSet, ALanguage, AOutPut: string): Boolean;
var
  i, start, cnt: Integer;
begin
  Result := False;

  cnt := 0;
  start := 1;
  for i := 1 to Length(AInput) do
  begin
    if (AInput[i] = '''') then
    begin
      Inc(cnt);

      if (cnt = 1) then
      begin
        ACharSet := System.Copy(AInput, start, i - start);
        start := i + 1;
      end else
      if (cnt = 2) then
      begin
        ALanguage := System.Copy(AInput, start, i - start);
        start := i + 1;
        Result := True;
        Break;
      end;
    end;
  end;

  if (Result) then
  begin
    AOutPut := System.Copy(AInput, start, Length(AInput));
  end else
  begin
    ACharSet := '';
    ALanguage := '';
    AOutPut := AInput;
  end;
end;

end.


