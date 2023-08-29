unit Utils.Zip;

interface

{$REGION 'Region uses'}
uses
  System.SysUtils, System.Classes, System.IOUtils, System.ZLib, System.Zip;
{$ENDREGION}

type
  TZipPack = class
  private
  public
    class function DecompressStr(const aText: TBytes): string;
    class function CompressStr(const aText: string): TBytes;
    class function GetCompressStr(const aText: string): TStringStream;
    class function ExtractFiles(const aFileName: TFileName): TArray<TFileName>;
  end;

implementation

{ TZipPack }

class function TZipPack.CompressStr(const aText: string): TBytes;
var
  StringStream: TStringStream;
  MemoryStream: TMemoryStream;
begin
  if aText.IsEmpty then
    Exit;

  StringStream := TStringStream.Create(aText);
  MemoryStream := TMemoryStream.Create;
  try
    StringStream.Position := 0;
    ZCompressStream(StringStream, MemoryStream);
    MemoryStream.Position := 0;
    StringStream.LoadFromStream(MemoryStream);
    Result := StringStream.Bytes;
  finally
    FreeAndNil(MemoryStream);
    FreeAndNil(StringStream);
  end;
end;

class function TZipPack.GetCompressStr(const aText: string): TStringStream;
var
  MemoryStream: TMemoryStream;
begin
  Result := TStringStream.Create(aText);
  MemoryStream := TMemoryStream.Create;
  try
    Result.Position := 0;
    ZCompressStream(Result, MemoryStream);
    MemoryStream.Position := 0;
    Result.LoadFromStream(MemoryStream);
  finally
    FreeAndNil(MemoryStream);
  end;
end;

class function TZipPack.DecompressStr(const aText: TBytes): string;
var
  BytesStream: TBytesStream;
  MemoryStream: TMemoryStream;
begin
  BytesStream := TBytesStream.Create(aText);
  MemoryStream := TMemoryStream.Create;
  try
    BytesStream.Position := 0;
    ZDecompressStream(BytesStream, MemoryStream);
    MemoryStream.Position := 0;
    BytesStream.LoadFromStream(MemoryStream);
    Result := TEncoding.Default.GetString(BytesStream.Bytes);
  finally
    FreeAndNil(MemoryStream);
    FreeAndNil(BytesStream);
  end;
end;

class function TZipPack.ExtractFiles(const aFileName: TFileName): TArray<TFileName>;
var
  myZipFile: TZipFile;
begin
  myZipFile := TZipFile.Create;
  try
    myZipFile.Open(aFileName, zmRead);
    for var i := 0 to  myZipFile.FileCount - 1 do
    begin

    end;

    myZipFile.Close;
  finally
    FreeAndNil(myZipFile);
  end;
end;

end.
