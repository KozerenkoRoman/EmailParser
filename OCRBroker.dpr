program OCRBroker;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  System.IOUtils,
  MappedFile in 'Sources\Common\MappedFile.pas',
  MappedFile.Memory in 'Sources\Common\MappedFile.Memory.pas',
  TesseractOCR in 'Sources\TesseractOCR\TesseractOCR.pas',
  TesseractOCR.Types in 'Sources\TesseractOCR\TesseractOCR.Types.pas',
  Utils.CmdParser in 'Sources\Common\Utils.CmdParser.pas';

var
  Bytes      : TBytes;
  CmdParser  : TCmdParser;
  Id         : string;
  ImageName  : string;
  IsHelp     : Boolean;
  Lang       : string;
  MemoryFile : TMemoryMappedFile;
  Ocr        : TTesseractOCR;
  OutText    : string;

  procedure WriteHelp;
  begin
    Writeln('');
    Writeln('OCRBroker -lang=eng -image="d:\pict.jpg" [-id=123ABC]');
    Writeln('or');
    Writeln('OCRBroker -help');
    Writeln('');
    Writeln('lang  - the language to use. If none is specified, eng (English) is assumed');
    Writeln('id    - the memory-mapped file name contains the out contents of file in virtual memory');
    Writeln('image - the name of the input file. This can be an image file');
    Flush(Output);
  end;

begin
  CmdParser := TCmdParser.Create;
  try
    Id        := CmdParser.AsString('id');
    Lang      := CmdParser.AsString('lang');
    ImageName := CmdParser.AsString('image');
    IsHelp    := CmdParser.Exists('?') or CmdParser.Exists('help') or CmdParser.Exists('h');
  finally
    FreeAndNil(CmdParser);
  end;

  if IsHelp then
  begin
    WriteHelp;
    Halt(0);
  end
  else if ImageName.IsEmpty then
  begin
    Writeln('Parametr "image" not found!');
    Flush(Output);
    WriteHelp;
    Halt(0);
  end
  else if not TFile.Exists(ImageName) then
  begin
    Writeln('File "' + ImageName + '" not found!');
    Flush(Output);
    WriteHelp;
    Halt(0);
  end;

  if Lang.IsEmpty then
  begin
    Lang := 'eng';
    Writeln('The "lang" parameter is set to eng (English)');
  end;

  Ocr := TTesseractOCR.Create(nil);
  try
    try
      Ocr.LanguageCode := Lang;
      Ocr.PictureFileName := ImageName;
      Ocr.DataPath := ExtractFilePath(Application.ExeName) + 'tessdata';
      Ocr.Active := True;
      OutText := Ocr.Text;
      if not Id.IsEmpty then
      begin
        MemoryFile := TMemoryMappedFile.Create(Id);
        try
          if MemoryFile.Open(True) then
          begin
            Bytes := TEncoding.UTF8.GetBytes(OutText);
            MemoryFile.Write(Bytes);
          end;
        finally
          FreeAndNil(MemoryFile);
        end;
      end
      else
        Writeln(OutText);
    except
      on E: Exception do
      begin
        Writeln('An error occurred:');
        Writeln(E.Message);
      end;
    end;
  finally
    FreeAndNil(Ocr);
  end;
end.
