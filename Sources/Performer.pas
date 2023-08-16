unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog,
  clHtmlParser, clMailMessage, MailMessage.Helper, Utils, ExecConsoleProgram, PdfiumCore, PdfiumCtrl,
  Winapi.GDIPAPI, Winapi.GDIPOBJ, Files.Utils, Performer.Interfaces, System.SyncObjs;
{$ENDREGION}

type
  TCompletedItem = procedure(const aResultData: TResultData) of object;

  TPerformer = class
  private
    FAttachmentsDir    : TAttachmentsDir;
    FDeleteAttachments : Boolean;
    FPathList          : TArray<TParamPath>;
    FRegExpList        : TArray<TRegExpData>;
    FUserDefinedDir    : string;
    FCriticalSection   : TCriticalSection;
    function GetAttchmentPath(const aFileName: TFileName): string;
    function GetTextFromPDFFile(const aFileName: TFileName): string;
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure ParseAttachmentFiles(aData: PResultData);
    procedure ParseEmail(const aFileName: TFileName);
    procedure ParseFile(const aFileName: TFileName);
  public
    OnStartProgressEvent : TStartProgressEvent;
    OnProgressEvent      : TProgressEvent;
    OnEndEvent           : TEndEvent;
    OnCompletedItem      : TCompletedItem;
    procedure Start;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPerformer }

constructor TPerformer.Create;
begin
  FCriticalSection := TCriticalSection.Create;
end;

destructor TPerformer.Destroy;
begin
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TPerformer.Start;
var
  FileList: TStringDynArray;
  FileExt: string;
begin
  LogWriter.Write(ddEnterMethod, 'TPerformer.Start');
  if not Assigned(OnCompletedItem) then
    Exit;

  FRegExpList        := TGeneral.GetRegExpParametersList;
  FPathList          := TGeneral.GetPathList;
  FileList           := [];
  FileExt            := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
  FUserDefinedDir    := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachments', C_ATTACHMENTS_SUB_DIR);
  FAttachmentsDir    := FAttachmentsDir.FromString(FUserDefinedDir);
  FDeleteAttachments := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);

  for var Dir in FPathList do
    if Dir.WithSubdir then
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FileExt, TSearchOption.soAllDirectories))
    else
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FileExt, TSearchOption.soTopDirectoryOnly));

  if Assigned(OnStartProgressEvent) then
    OnStartProgressEvent(Length(FileList));

  LogWriter.Write(ddText, 'Length FileList - ' + Length(FileList).ToString);
  try
    for var FileName in FileList do
      ParseFile(FileName);
  except
    on E: Exception do
    begin
      LogWriter.Write(ddError, E.Message);
      if Assigned(OnEndEvent) then
        OnEndEvent;
    end;
  end;

  if Assigned(OnEndEvent) then
    TThread.Queue(nil,
      procedure
      begin
        LogWriter.Write(ddExitMethod, 'TPerformer.Start');
        OnEndEvent;
      end);
end;

procedure TPerformer.ParseFile(const aFileName: TFileName);
begin
  if (not Assigned(OnCompletedItem)) or (Length(FRegExpList) = 0) then
    Exit;

  ParseEmail(aFileName);
  if Assigned(OnProgressEvent) then
    TThread.Queue(nil,
      procedure
      begin
        OnProgressEvent;
      end);
end;

function TPerformer.GetAttchmentPath(const aFileName: TFileName): string;
var
  Path: string;
begin
  case FAttachmentsDir of
    adAttachments:
      begin
        Path := TDirectory.GetParent(TPath.GetDirectoryName(aFileName));
        Result := TPath.Combine(Path, C_ATTACHMENTS_DIR);
      end;
    adSubAttachments:
      begin
        Path := TPath.GetDirectoryName(aFileName);
        Result := TPath.Combine(Path, C_ATTACHMENTS_DIR);
      end;
    adUserDefined:
      Result := FUserDefinedDir;
  end;

  if not TDirectory.Exists(Result) then
    try
      TDirectory.CreateDirectory(Result)
    except
      on E: Exception do
        LogWriter.Write(ddError, E.Message + sLineBreak + 'Directory - ' + Result);
    end;
end;

procedure TPerformer.ParseEmail(const aFileName: TFileName);
var
  MailMessage: TclMailMessage;
  Data: PResultData;
begin
  New(Data);
  Data.ShortName := TPath.GetFileNameWithoutExtension(aFileName);
  Data.FileName  := aFileName;

  MailMessage := TclMailMessage.Create(nil);
  MailMessage.OnSaveAttachment := DoSaveAttachment;
  try
    try
      MailMessage.ResultData := Data;
      MailMessage.LoadMessage(aFileName);
      Data.MessageId   := MailMessage.MessageId;
      Data.Subject     := MailMessage.Subject;
      Data.TimeStamp   := MailMessage.Date;
      Data.From        := MailMessage.From.FullAddress;
      Data.ContentType := MailMessage.ContentType;

      if (MailMessage.ContentType = 'text/calendar') then
      begin
        if Assigned(MailMessage.Calendar) then
          Data.Body := MailMessage.Calendar.Strings.Text
        else
          Data.Body := 'Empty'
      end
      else
      begin
        if Assigned(MailMessage.MessageText) then
          Data.Body := MailMessage.MessageText.Text
        else if Assigned(MailMessage.Html) then
          Data.Body := MailMessage.Html.Strings.Text
        else
          Data.Body := 'Empty';
      end
    except
      on E: Exception do
        LogWriter.Write(ddError, E.Message + sLineBreak + Data.FileName);
    end;

    TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TPerformer.ParseEmail');
        ParseAttachmentFiles(Data);
        TThread.Queue(nil,
          procedure
          begin
            OnCompletedItem(Data^);
          end);
      end).Start;

  finally
    FreeAndNil(MailMessage);
  end;
end;

procedure TPerformer.ParseAttachmentFiles(aData: PResultData);
begin
  for var i := Low(aData.Attachments) to High(aData.Attachments) do
    if TFile.Exists(aData.Attachments[i].FileName) then
      try
        try
          case TFileUtils.GetSignature(aData.Attachments[i].FileName) of
            fsPDF:
              begin
                aData.Attachments[i].ParsedText  := GetTextFromPDFFile(aData^.Attachments[i].FileName);
                aData.Attachments[i].ContentType := 'application/pdf';
              end;
            fsPng:
              begin
                aData.Attachments[i].ParsedText  := 'png';
                aData.Attachments[i].ContentType := 'image/png';
              end;
            fsGif:
              begin
                aData.Attachments[i].ParsedText  := 'gif';
                aData.Attachments[i].ContentType := 'image/gif';
              end;
            fsIco:
              begin
                aData.Attachments[i].ParsedText  := 'ico';
                aData.Attachments[i].ContentType := 'image/icon';
              end;
            fsJpg, fsJp2:
              begin
                aData.Attachments[i].ParsedText  := 'jpg';
                aData.Attachments[i].ContentType := 'image/jpeg';
              end;
            fsZip:
              begin
                aData.Attachments[i].ParsedText  := 'zip';
                aData.Attachments[i].ContentType := 'image/png';
              end;
            fsRar:
              begin
                aData.Attachments[i].ParsedText  := 'rar';
                aData.Attachments[i].ContentType := 'application/rar';
              end;
            fsOffice:
              begin
                aData.Attachments[i].ParsedText  := 'office';
                aData.Attachments[i].ContentType := 'application/office';
              end;
            fsCrt:
              begin
                aData.Attachments[i].ParsedText  := 'crt';
                aData.Attachments[i].ContentType := 'application/crt';
              end;
            fsKey:
              begin
                aData.Attachments[i].ParsedText  := 'key';
                aData.Attachments[i].ContentType := 'application/key';
              end;

            fsUnknown:
              aData.Attachments[i].ParsedText := '';
          end;
        finally
          if FDeleteAttachments then
            TFile.Delete(aData.Attachments[i].FileName);
        end;
      except
        on E: Exception do
          LogWriter.Write(ddError, E.Message + sLineBreak +
                                   'Email name - ' + aData.FileName + sLineBreak +
                                   'File name - '  + aData.Attachments[i].FileName);
      end;
end;

procedure TPerformer.DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
var
  Data: PResultData;
  Path: string;
begin
  if not(aBody is TclAttachmentBody) then
    Exit;

  Data := TclMailMessage(Sender).ResultData;
  SetLength(Data.Attachments, Length(Data.Attachments) + 1);
  Path := GetAttchmentPath(Data.FileName);

  if not TPath.HasValidFileNameChars(aFileName, False) then
  begin
    aFileName := Concat('[', Data.ShortName, '] ', TFileUtils.GetCorrectFileName(aFileName));
    LogWriter.Write(ddText, 'DoSaveAttachment',
                            'Email file name - '      + Data.FileName  + sLineBreak +
                            'Email short name - '     + Data.ShortName + sLineBreak +
                            'Attachment file name - ' + aFileName      + sLineBreak +
                            'Attachment index - '     + aBody.Index.ToString);

    if not TPath.HasValidFileNameChars(aFileName, False) then
    begin
      var NewName := Concat('[', Data.ShortName, '] (', aBody.Index.ToString, ')');
      LogWriter.Write(ddError, 'DoSaveAttachment',
                               'Bad file name - ' + aFileName  + sLineBreak +
                               'New file name - ' + NewName);
      aFileName := NewName;
    end;
  end;
  aBody.FileName := aFileName;
  Data.Attachments[High(Data.Attachments)].ShortName   := aFileName;
  Data.Attachments[High(Data.Attachments)].FileName    := TPath.Combine(Path, aFileName);
  Data.Attachments[High(Data.Attachments)].ContentID   := aBody.ContentID;
  Data.Attachments[High(Data.Attachments)].ContentType := aBody.ContentType;
  {$WARN SYMBOL_PLATFORM OFF}
  aStreamData := TFileStream.Create(Data.Attachments[High(Data.Attachments)].FileName, fmCreate or fmOpenReadWrite {$IFDEF MSWINDOWS}or fmShareDenyRead{$ENDIF});
  {$WARN SYMBOL_PLATFORM ON}
  Handled := True;
end;

function TPerformer.GetTextFromPDFFile(const aFileName: TFileName): string;
var
  PDFCtrl: TPdfControl;
begin
  Result := '';
  FCriticalSection.Enter;
  PDFCtrl := TPdfControl.Create(nil);
  try
    PDFCtrl.Visible := False;
    try
      PDFCtrl.LoadFromFile(aFileName);
      for var i := 0 to PDFCtrl.Document.PageCount - 1 do
      begin
        PDFCtrl.PageIndex := i;
        Result := Result + PDFCtrl.Document.Pages[i].ReadText(0, 10000);
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, 'GetTextFromPDFFile', 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(PDFCtrl);
    FCriticalSection.Leave;
  end;
end;

end.
