{
  Clever Internet Suite
  Copyright (C) 2019 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clPercentEncoder;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils;

type
  TclPercentEncoder = class
  private
    FSkipEncoded: Boolean;
    FUnsafeCharBytes: TclByteArray;
    FUnsafeChars: string;

    function GetUnsafeCharBytes: TclByteArray;
    procedure SetUnsafeChars(const Value: string);
  protected
    function IsHexDigit(ACharCode: Byte): Boolean;
    function IsUnsafeChar(ACharCode: Byte): Boolean; virtual;
    function DecodeByte(AChar: Char): Byte; virtual;
    function EncodeByte(AByte: Byte): Char; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    function DecodeToBytes(const AValue: string): TclByteArray; virtual;
    function EncodeBytes(const AValue: TclByteArray): string; virtual;

    function EncodeString(const AValue, ACharSet: string): string; virtual;
    function DecodeString(const AValue, ACharSet: string): string; virtual;

    property UnsafeChars: string read FUnsafeChars write SetUnsafeChars;
    property SkipEncoded: Boolean read FSkipEncoded write FSkipEncoded;
  end;

implementation

uses
  clTranslator;

{ TclPercentEncoder }

constructor TclPercentEncoder.Create;
begin
  inherited Create();

  FUnsafeChars := '';
  FSkipEncoded := False;
  FUnsafeCharBytes := nil;
end;

function TclPercentEncoder.DecodeByte(AChar: Char): Byte;
begin
  Result := Ord(AChar) and $FF;
end;

function TclPercentEncoder.DecodeString(const AValue, ACharSet: string): string;
var
  bytes: TclByteArray;
begin
  bytes := DecodeToBytes(AValue);
  if (bytes <> nil) then
  begin
    Result := TclTranslator.GetString(bytes, ACharSet);
  end else
  begin
    Result := '';
  end;
end;

function TclPercentEncoder.DecodeToBytes(const AValue: string): TclByteArray;
var
  next: PChar;
  len, index, hexNumber: Integer;
  isDelimiter, isCodePresent: Boolean;
begin
  len := Length(AValue);
  if (len = 0) then
  begin
    Result := nil;
    Exit;
  end;

  SetLength(Result, len * 2);
  index := 0;

  isDelimiter := False;
  isCodePresent := False;
  hexNumber := 0;
  next := @AValue[1];
  while (next^ <> #0) do
  begin
    if (isDelimiter) then
    begin
      case (next^) of
      'A'..'F':
        begin
          hexNumber := hexNumber + (Ord(next^) - 55);
        end;
      'a'..'f':
        begin
          hexNumber := hexNumber + (Ord(next^) - 87);
        end;
      '0'..'9':
        begin
          hexNumber := hexNumber + (Ord(next^) - 48);
        end;
      else
        begin
          isCodePresent := False;
          isDelimiter := False;
          hexNumber := 0;

          Result[index] := Ord('%') and $FF;
          Inc(index);

          Result[index] := Ord(next^) and $FF;
          Inc(index);
        end;
      end;

      if (not isCodePresent) then
      begin
        hexNumber := hexNumber * 16;
        isCodePresent := True;
      end else
      begin
        Result[index] := hexNumber and $FF;
        Inc(index);

        isCodePresent := False;
        isDelimiter := False;
        hexNumber := 0;
      end;
    end else
    if (next^ = '%') then
    begin
      isDelimiter := True;
    end else
    begin
      Result[index] := DecodeByte(next^);
      Inc(index);
    end;

    Inc(next);
  end;

  SetLength(Result, index);
end;

destructor TclPercentEncoder.Destroy;
begin
  FUnsafeCharBytes := nil;

  inherited Destroy();
end;

function TclPercentEncoder.EncodeByte(AByte: Byte): Char;
begin
  Result := Chr(AByte);
end;

function TclPercentEncoder.EncodeBytes(const AValue: TclByteArray): string;
var
  i, size: Integer;
begin
  Result := '';
  if (AValue = nil) then Exit;

  size := Length(AValue);
  i := 0;
  while (i < size) do
  begin
    if SkipEncoded and (AValue[i] = $25) and (i + 2 < size)//%
      and IsHexDigit(AValue[i + 1]) and IsHexDigit(AValue[i + 2]) then
    begin
      Result := Result + '%' + Chr(AValue[i + 1]) + Chr(AValue[i + 2]);
      Inc(i, 2);
    end else
    if IsUnsafeChar(AValue[i]) then
    begin
      Result := Result + '%' + Format('%2.2X', [AValue[i]]);
    end else
    begin
      Result := Result + EncodeByte(AValue[i]);
    end;
    Inc(i);
  end;
end;

function TclPercentEncoder.EncodeString(const AValue, ACharSet: string): string;
var
  bytes: TclByteArray;
begin
  bytes := TclTranslator.GetBytes(AValue, ACharSet);
  if (bytes <> nil) then
  begin
    Result := EncodeBytes(bytes);
  end else
  begin
    Result := '';
  end;
end;

function TclPercentEncoder.GetUnsafeCharBytes: TclByteArray;
begin
  if (FUnsafeCharBytes = nil) then
  begin
    FUnsafeCharBytes := TclTranslator.GetBytes(UnsafeChars, 'us-ascii');
  end;
  Result := FUnsafeCharBytes;
end;

function TclPercentEncoder.IsHexDigit(ACharCode: Byte): Boolean;
begin
  Result := (ACharCode in [$30..$39]) or (ACharCode in [$41..$46]) or (ACharCode in [$61..$66]); //0..9, A..F, a..f
end;

function TclPercentEncoder.IsUnsafeChar(ACharCode: Byte): Boolean;
var
  i: Integer;
  unsafeBytes: TclByteArray;
begin
  Result := False;

  unsafeBytes := GetUnsafeCharBytes();
  if (unsafeBytes = nil) then Exit;

  for i := 0 to Length(unsafeBytes) - 1 do
  begin
    if (unsafeBytes[i] = ACharCode) then
    begin
      Result := True;
      Exit;
    end;
  end;

  Result := (ACharCode >= $7F) or (ACharCode < $20);
end;

procedure TclPercentEncoder.SetUnsafeChars(const Value: string);
begin
  if (FUnsafeChars <> Value) then
  begin
    FUnsafeChars := Value;
    FUnsafeCharBytes := nil;
  end;
end;

end.

