﻿unit Utils.Files;

interface

{$REGION 'Region uses'}

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Defaults, System.Generics.Collections,
  {$IFDEF EXTENDED_COMPONENTS}DCPrc4, DCPsha1,{$ENDIF} Winapi.Windows, System.DateUtils, System.IniFiles,
  Vcl.Controls, Winapi.ShellAPI, System.IOUtils, Vcl.Forms, System.Hash, System.Math;
{$ENDREGION}

type
  TFileSignature = (fsPDF, fsGif, fsPng, fsJpg, fsZip, fsRar, fsOffice, fsCrt, fsKey, fsJp2, fsIco,
                    fsTiff, fsTif, fsUTF8, fsUTF7, fsUTF1, fsUTF16be, fsUTF16le, fsUTF32be, fsUTF32le,
                    fsUnknown);
  TSignatureItem = record
    TypeSignature: TFileSignature;
    Signature: TBytes;
  end;

  TFileUtils = class
  const
    EXTENDED_PREFIX : string = '\\?\';
    FORBIDDEN_EXT   : string = '.exe.com.cmd.bat.eml';
  public
    class function CheckLength(const aFileName: string): string;
    class function CheckSignature(const aFileName: string; const aSignature: TFileSignature): Boolean;
    class function GetCmdLineValue(aCmdLine, aArg: string; aSwitch, aSeparator: Char): string;
    class function GetCorrectFileName(const aPath, aFileName: string): string;
    class function GetGuid: string; inline;
    class function GetHash(const aFileName: string): string;
    class function GetHashString(const aParsedText: string): string;
    class function GetShortPath(const aFileName: string): string; inline;
    class function GetSignature(const aFileName: string): TFileSignature;
    class function IsForbidden(const aFileName: TFileName): Boolean; inline;
    class function MakePath(const aParts: TArray<string>; const aCreate: Boolean): string; overload;
    class function MakePath(const aParts: TArray<string>; const aFileName: string; const aCreatePath: Boolean): string; overload;
    class function ShellExecuteAndWait(const aFileName, aParams: string): Boolean; inline;
    class function EncryptStr(const aText, aKey: string): string;
    class function DecryptStr(const aText, aKey: string): string;
    class procedure ShellOpen(const aUrl: string; const aParams: string = '');
  end;

implementation

const
  //See https://en.wikipedia.org/wiki/List_of_file_signatures
  //    https://en.wikipedia.org/wiki/Byte_order_mark
  ArraySignatures: array [1 .. 21] of TSignatureItem = (
    (TypeSignature: fsPDF;     Signature: [$25, $50, $44, $46, $2D]),
    (TypeSignature: fsGif;     Signature: [$47, $49, $46, $38]),
    (TypeSignature: fsPng;     Signature: [$89, $50, $4E, $47, $0D, $0A, $1A, $0A]),
    (TypeSignature: fsJpg;     Signature: [$FF, $D8, $FF]),
    (TypeSignature: fsJp2;     Signature: [$00, $00, $00, $0C, $6A, $50, $20, $20, $0D, $0A, $87, $0A]), //LENGTH_SIGNATURE - max length of TBytes
    (TypeSignature: fsZip;     Signature: [$50, $4B]),
    (TypeSignature: fsRar;     Signature: [$52, $61, $72, $21, $1A, $07]),
    (TypeSignature: fsIco;     Signature: [$00, $00, $01, $00]),
    (TypeSignature: fsTif;     Signature: [$49, $49, $2A, $00]),
    (TypeSignature: fsTiff;    Signature: [$4D, $4D, $00, $2A]),
    (TypeSignature: fsOffice;  Signature: [$D0, $CF, $11, $E0, $A1, $B1, $1A, $E1]),
    (TypeSignature: fsCrt;     Signature: [$2D, $2D, $2D, $2D, $2D, $42, $45, $47, $49, $4E, $20, $43]),
    (TypeSignature: fsKey;     Signature: [$2D, $2D, $2D, $2D, $2D, $42, $45, $47, $49, $4E, $20, $50]),
    (TypeSignature: fsUTF8;    Signature: [$EF, $BB, $BF]),
    (TypeSignature: fsUTF7;    Signature: [$2B, $2F, $76]),
    (TypeSignature: fsUTF1;    Signature: [$F7, $64, $4C]),
    (TypeSignature: fsUTF16be; Signature: [$FE, $FF]),
    (TypeSignature: fsUTF16le; Signature: [$FF, $FE]),
    (TypeSignature: fsUTF32be; Signature: [$00, $00, $FE, $FF]),
    (TypeSignature: fsUTF32le; Signature: [$FF, $FE, $00, $00]),
    (TypeSignature: fsUnknown; Signature: [])
    );
  LENGTH_SIGNATURE = 12;


{ TFileUtils }

class function TFileUtils.ShellExecuteAndWait(const aFileName, aParams: string): Boolean;
var
  seInfo : TShellExecuteInfo;
  Ph     : DWORD;
begin
  FillChar(seInfo, SizeOf(seInfo), 0);
  with seInfo do
  begin
    cbSize := SizeOf(seInfo);
    fMask  := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd    := GetActiveWindow();
    lpFile := PChar(aFileName);
    nShow  := SW_SHOWMINNOACTIVE;
    seInfo.lpVerb       := 'open';
    seInfo.lpParameters := PChar(aParams);
  end;
  if ShellExecuteEx(@seInfo) then
    Ph := seInfo.hProcess
  else
    Exit(False);
  while WaitForSingleObject(seInfo.hProcess, 50) <> WAIT_OBJECT_0 do
    Application.ProcessMessages;
  CloseHandle(Ph);
  Result := True;
end;

class function TFileUtils.GetCorrectFileName(const aPath, aFileName: string): string;
const
  LENGTH_PATH = MAX_PATH - 10;
var
  Len: Integer;
  Ext: string;
begin
  Result := aFileName;
  for var i := Low(TPath.GetInvalidFileNameChars) to High(TPath.GetInvalidFileNameChars) do
    Result := Result.Replace(TPath.GetInvalidFileNameChars[i], '');

  if ((aPath.Length + Result.Length) >= LENGTH_PATH) then
  begin
    Ext    := TPath.GetExtension(Result);
    Result := TPath.GetFileNameWithoutExtension(Result);
    Len    := LENGTH_PATH - aPath.Length - Ext.Length;
    SetLength(Result, Min(Length(Result), Len));
    Result := Result + Ext;
  end;
end;

class function TFileUtils.GetGuid: string;
begin
  Result := TGUID.NewGuid.ToString().Replace('{', '').Replace('}', '').ToLower;
end;

class function TFileUtils.GetHash(const aFileName: string): string;
begin
  Result := THashSHA2.Create(SHA256).GetHashStringFromFile(aFileName);
end;

class function TFileUtils.GetHashString(const aParsedText: string): string;
begin
  Result := THashSHA2.Create(SHA256).GetHashString(aParsedText);
end;

class procedure TFileUtils.ShellOpen(const aUrl: string; const aParams: string = '');
begin
  Winapi.ShellAPI.ShellExecute(0, 'Open', PChar(aUrl), PChar(aParams), nil, SW_SHOWNORMAL);
end;

class function TFileUtils.GetShortPath(const aFileName: string): string;
begin
  Result := '';
  SetLength(Result, MAX_PATH + 1);
  if GetShortPathName(PWideChar(aFileName), PWideChar(Result), MAX_PATH) = 0 then
    Result := aFileName
  else
    SetLength(Result, StrLen(PWideChar(Result)));
end;

class function TFileUtils.GetSignature(const aFileName: string): TFileSignature;
var
  FileSignature : TBytes;
  FileStream    : TFileStream;
begin
  Result := fsUnknown;
  if TFile.Exists(aFileName) then
  begin
    FileStream := TFile.OpenRead(aFileName);
    try
      SetLength(FileSignature, LENGTH_SIGNATURE);
      if (FileStream.Read(FileSignature, SizeOf(FileSignature)) > 0) then
        for var item in ArraySignatures do
          if (item.TypeSignature <> fsUnknown) then
          begin
            var Signature := Copy(FileSignature, 0, Length(item.Signature));
            if CompareMem(Signature, item.Signature, Length(item.Signature)) then
              Exit(item.TypeSignature);
          end;
    finally
      FreeAndNil(FileStream);
    end;
  end;
end;

class function TFileUtils.IsForbidden(const aFileName: TFileName): Boolean;
begin
  Result := FORBIDDEN_EXT.Contains(TPath.GetExtension(aFileName));
end;

class function TFileUtils.CheckLength(const aFileName: string): string;
begin
  Result := aFileName;
  if (aFileName.Length >= MAX_PATH) then
    if not aFileName.StartsWith(EXTENDED_PREFIX) then
      Result := Concat(EXTENDED_PREFIX, aFileName);
end;

class function TFileUtils.CheckSignature(const aFileName: string; const aSignature: TFileSignature): Boolean;
var
  FileSignature : TBytes;
  FileStream    : TFileStream;
begin
  Result := False;
  FileStream := TFile.OpenRead(aFileName);
  try
    SetLength(FileSignature, LENGTH_SIGNATURE);
    if (FileStream.Read(FileSignature, SizeOf(FileSignature)) > 0) then
      for var item in ArraySignatures do
        if (aSignature = item.TypeSignature) and (item.TypeSignature <> fsUnknown) then
        begin
          SetLength(FileSignature, Length(item.Signature));
          Exit(CompareMem(FileSignature, item.Signature, Length(item.Signature)));
        end;
  finally
    FreeAndNil(FileStream);
  end;
end;

class function TFileUtils.GetCmdLineValue(aCmdLine, aArg: string; aSwitch, aSeparator: Char): string;
var
  ArgIndex        : Integer;
  LenghtValue     : Integer;
  NextSwitchIndex : Integer;
  SepIndex        : Integer;
begin
  ArgIndex := aCmdLine.IndexOf(aArg);
  SepIndex := aCmdLine.IndexOf(aSeparator, ArgIndex);
  NextSwitchIndex := aCmdLine.IndexOf(aSwitch, ArgIndex + 1);

  if (SepIndex = -1) or (SepIndex > NextSwitchIndex) and (NextSwitchIndex > -1) then
    Exit('');

  if (NextSwitchIndex = -1) then
    LenghtValue := aCmdLine.Length - SepIndex + 2
  else
    LenghtValue := NextSwitchIndex - SepIndex - 1;
  Result := Copy(aCmdLine, SepIndex + 2, LenghtValue).Trim;
end;

class function TFileUtils.MakePath(const aParts: TArray<string>; const aCreate: Boolean): string;
const
  APPEND_STRATEGY: array [False .. True, False .. True] of Integer = ((0, 1), (1, 2));
var
  i: Integer;
begin
  case Length(aParts) of
    0:
      Result := '';
    1:
      Result := aParts[0];
  else
    i := 0;
    while (aParts[i] = '') do
      Inc(i);
    Result := aParts[i];
    for i := Succ(i) to Pred(Length(aParts)) do
    begin
      if (aParts[i] = '') then
        Continue;

      case APPEND_STRATEGY[Result[Length(Result)] = '\', aParts[i][1] = '\'] of
        0:
          Result := Result + '\' + aParts[i];
        2:
          Result := Result + Copy(aParts[i], 2, Length(aParts[i]));
        1:
          Result := Result + aParts[i];
      end
    end;

    if Result[Length(Result)] = '\' then
      SetLength(Result, Length(Result) - 1);
  end;

  if (Result <> '') then
  begin
    if Result[Length(Result)] = '\' then
      SetLength(Result, Length(Result) - 1);

    if aCreate and not DirectoryExists(Result) then
      ForceDirectories(Result);
  end;
end;

class function TFileUtils.MakePath(const aParts: TArray<string>; const aFileName: string; const aCreatePath: Boolean): string;
begin
  Result := MakePath(aParts, aCreatePath) + '\' + aFileName;
end;

{$IFDEF EXTENDED_COMPONENTS}

class function TFileUtils.EncryptStr(const aText, aKey: string): string;
var
  Cipher: TDCP_rc4;
begin
  Cipher := TDCP_rc4.Create(nil);
  try
    Cipher.InitUnicodeStr(aKey, TDCP_sha1);
    Result := Cipher.EncryptUnicodeString(aText);
    Cipher.Burn;
  finally
    FreeAndNil(Cipher)
  end;
end;

class function TFileUtils.DecryptStr(const aText, aKey: string): string;
var
  Cipher: TDCP_rc4;
begin
  Cipher := TDCP_rc4.Create(nil);
  try
    Cipher.InitUnicodeStr(aKey, TDCP_sha1);
    Result := Cipher.DecryptUnicodeString(aText);
    Cipher.Burn;
  finally
    FreeAndNil(Cipher)
  end;
end;

{$ELSE}

class function TFileUtils.EncryptStr(const aText, aKey: string): string;
begin
  Result := aText;
end;

class function TFileUtils.DecryptStr(const aText, aKey: string): string;
begin
  Result := aText;
end;

{$ENDIF}

end.
