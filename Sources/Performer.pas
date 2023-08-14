unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog,
  clHtmlParser, clMailMessage, MailMessage.Helper, Utils,
  Winapi.GDIPAPI, Winapi.GDIPOBJ;
{$ENDREGION}

type
  TAbortEvent = function: Boolean of object;
  TEndEvent = procedure of object;
  TProgressEvent = procedure of object;
  TStartProgressEvent = procedure(const aMaxPosition: Integer) of object;
  TCompletedItem = procedure(const aResultData: TResultData) of object;

  TPerformer = class
  private
    FAttachmentsDir    : TAttachmentsDir;
    FDeleteAttachments : Boolean;
    FPathList          : TArray<TParamPath>;
    FRegExpList        : TArray<TRegExpData>;
    FUserDefinedDir    : string;
    function GetAttchmentPath(const aFileName: TFileName): string;
    procedure DeleteAttachmentFiles(const aData: PResultData);
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure ParseEmail(const aFileName: TFileName; out aData: PResultData);
    procedure ParseFile(const aFileName: TFileName);
  public
    OnStartProgressEvent : TStartProgressEvent;
    OnProgressEvent      : TProgressEvent;
    OnEndEvent           : TEndEvent;
    OnCompletedItem      : TCompletedItem;
    procedure Start;
  end;

implementation

{ TPerformer }

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
var
  Data: PResultData;
begin
  if (not Assigned(OnCompletedItem)) or (Length(FRegExpList) = 0) then
    Exit;

  ParseEmail(aFileName, Data);
  if Assigned(OnProgressEvent) then
    TThread.Queue(nil,
      procedure
      begin
        OnProgressEvent;
      end);

  TThread.Queue(nil,
    procedure
    begin
      OnCompletedItem(Data^);
    end);
  if Assigned(Data) then
    FreeMem(Data);
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

procedure TPerformer.ParseEmail(const aFileName: TFileName; out aData: PResultData);
var
  MailMessage: TclMailMessage;
begin
  New(aData);
  aData.ShortName := TPath.GetFileNameWithoutExtension(aFileName);
  aData.FileName  := aFileName;

  MailMessage := TclMailMessage.Create(nil);
  MailMessage.OnSaveAttachment := DoSaveAttachment;
  try
    try
      MailMessage.ResultData := aData;
      MailMessage.LoadMessage(aFileName);
      aData.MessageId   := MailMessage.MessageId;
      aData.Subject     := MailMessage.Subject;
      aData.TimeStamp   := MailMessage.Date;
      aData.From        := MailMessage.From.FullAddress;
      aData.ContentType := MailMessage.ContentType;

      if (MailMessage.ContentType = 'text/calendar') then
      begin
        if Assigned(MailMessage.Calendar) then
          aData.Body := MailMessage.Calendar.Strings.Text
        else
          aData.Body := 'Empty'
      end
      else
      begin
        if Assigned(MailMessage.MessageText) then
          aData.Body := MailMessage.MessageText.Text
        else if Assigned(MailMessage.Html) then
          aData.Body := MailMessage.Html.Strings.Text
        else
          aData.Body := 'Empty';
      end
    except
      on E: Exception do
        LogWriter.Write(ddError, E.Message + sLineBreak + aData.FileName);
    end;

    DeleteAttachmentFiles(aData);
  finally
    FreeAndNil(MailMessage);
  end;
end;

procedure TPerformer.DeleteAttachmentFiles(const aData: PResultData);
begin
  if FDeleteAttachments then
    for var i := Low(aData.Attachments) to High(aData.Attachments) do
      if TFile.Exists(aData.Attachments[i].FileName) then
        try
          TFile.Delete(aData.Attachments[i].FileName);
        except
          on E: EInOutError do
            LogWriter.Write(ddError, E.Message + sLineBreak + aData.Attachments[i].FileName);
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
    aFileName := Concat('[', Data.ShortName, '] ', GetCorrectFileName(aFileName));
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
  aStreamData := TFileStream.Create(Data.Attachments[High(Data.Attachments)].FileName, fmCreate or fmOpenReadWrite);
  Handled := True;
end;

end.
