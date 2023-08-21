﻿unit Files.Utils;

interface

{$REGION 'Region uses'}

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Defaults, System.Generics.Collections,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Winapi.Windows, System.DateUtils, System.IniFiles,
  Vcl.Controls, Winapi.ShellAPI, System.IOUtils, Vcl.Forms;
{$ENDREGION}

type
  TFileSignature = (fsPDF, fsGif, fsPng, fsJpg, fsZip, fsRar, fsOffice, fsCrt, fsKey, fsJp2, fsIco, fsUnknown);
  TSignatureItem = record
    TypeSignature: TFileSignature;
    Signature: TBytes;
  end;

  TFileUtils = class
  public
    class function CheckSignature(const aFilename: string; const aSignature: TFileSignature): Boolean;
    class function GetSignature(const aFilename: string): TFileSignature;
    class function GetCorrectFileName(const aFileName: string): string; inline;
    class function ShellExecuteAndWait(const aFileName, aParams: string): Boolean; inline;
    class procedure ShellOpen(const aUrl: string; const aParams: string = '');
  end;

const
  //See https://en.wikipedia.org/wiki/List_of_file_signatures
  ArraySignatures: array [1 .. 12] of TSignatureItem = (
    (TypeSignature: fsPDF;     Signature: [$25, $50, $44, $46, $2D]),
    (TypeSignature: fsGif;     Signature: [$47, $49, $46, $38]),
    (TypeSignature: fsPng;     Signature: [$89, $50, $4E, $47, $0D, $0A, $1A, $0A]),
    (TypeSignature: fsJpg;     Signature: [$FF, $D8, $FF]),
    (TypeSignature: fsJp2;     Signature: [$00, $00, $00, $0C, $6A, $50, $20, $20, $0D, $0A, $87, $0A]), //LENGTH_SIGNATURE - max length of TBytes
    (TypeSignature: fsZip;     Signature: [$50, $4B]),
    (TypeSignature: fsRar;     Signature: [$52, $61, $72, $21, $1A, $07]),
    (TypeSignature: fsIco;     Signature: [$00, $00, $01, $00]),
    (TypeSignature: fsOffice;  Signature: [$D0, $CF, $11, $E0, $A1, $B1, $1A, $E1]),
    (TypeSignature: fsCrt;     Signature: [$2D, $2D, $2D, $2D, $2D, $42, $45, $47, $49, $4E, $20, $43]),
    (TypeSignature: fsKey;     Signature: [$2D, $2D, $2D, $2D, $2D, $42, $45, $47, $49, $4E, $20, $50]),
    (TypeSignature: fsUnknown; Signature: [])
    );
  LENGTH_SIGNATURE = 12;

implementation

{ TFileUtils }

class function TFileUtils.ShellExecuteAndWait(const aFileName, aParams: string): Boolean;
var
  seInfo: TShellExecuteInfo;
  Ph: DWORD;
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

class function TFileUtils.GetCorrectFileName(const aFileName: string): string;
begin
  Result := aFileName;
  for var i := Low(TPath.GetInvalidFileNameChars) to High(TPath.GetInvalidFileNameChars) do
    Result := Result.Replace(TPath.GetInvalidFileNameChars[i], '');
end;

class procedure TFileUtils.ShellOpen(const aUrl: string; const aParams: string = '');
begin
  Winapi.ShellAPI.ShellExecute(0, 'Open', PChar(aUrl), PChar(aParams), nil, SW_SHOWNORMAL);
end;

class function TFileUtils.GetSignature(const aFilename: string): TFileSignature;
var
  FileSignature: TBytes;
  FileStream: TFileStream;
begin
  Result := fsUnknown;
  FileStream := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
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

class function TFileUtils.CheckSignature(const aFileName: string; const aSignature: TFileSignature): Boolean;
var
  FileSignature : TBytes;
  FileStream    : TFileStream;
begin
  Result := False;
  FileStream := TFileStream.Create(aFilename, fmOpenRead or fmShareDenyWrite);
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

end.
