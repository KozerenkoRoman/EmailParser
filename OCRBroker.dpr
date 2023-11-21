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
  MemoryFile: TMemoryMappedFile;
  Ocr: TTesseractOCR;
  OutText: TStringStream;

  Lang: string;
  Id: string;
  IsHelp: Boolean;
  ImageName: string;
  CmdParser: TCmdParser;

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
    Writeln('');
    Writeln('OCRBroker lang=eng [id=123456] [image=d:\pict.jpg]');
    Writeln('');
    Writeln('lang  - the language to use. If none is specified, eng (English) is assumed');
    Writeln('id    - the memory-mapped file name contains the contents of file in virtual memory');
    Writeln('image - the name of the input file. This can be an image file');
    Flush(Output);
    Exit;
  end
  else if Id.IsEmpty and ImageName.IsEmpty then
  begin
    Writeln('Parametr "FileId" or "FileName" not found');
    Flush(Output);
    Exit;
  end
  else if Lang.IsEmpty then
    Lang := 'eng';

  if not Id.IsEmpty then
  begin
    Writeln('id=' + Id);
    Flush(Output);
  end;

  Ocr := TTesseractOCR.Create(nil);
  try
    try
      Ocr.LanguageCode := Lang;
      if not ImageName.IsEmpty and TFile.Exists(ImageName) then
        Ocr.PictureFileName := ImageName
      else if not Id.IsEmpty then
      begin
        //ToDo
      end;

      Ocr.DataPath := ExtractFilePath(Application.ExeName) + 'tessdata';
      Ocr.Active := True;
      OutText := TStringStream.Create(Ocr.Text);
      try
        if not Id.IsEmpty then
        begin
          MemoryFile := TMemoryMappedFile.Create(ParamStr(1));
          try
            MemoryFile.Open(True);
            MemoryFile.Write(OutText.Bytes);
          finally
            FreeAndNil(MemoryFile);
          end;
        end
        else
          Writeln(OutText.DataString);
      finally
        FreeAndNil(OutText);
      end;

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
