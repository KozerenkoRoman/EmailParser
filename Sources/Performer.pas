unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog,
  clHtmlParser, clMailMessage, MailMessage.Helper, Utils, ExecConsoleProgram, PdfiumCore, PdfiumCtrl,
  Files.Utils, System.SyncObjs, UHTMLParse, Publishers.Interfaces, Publishers, dEXIF.Helper, DaModule,
  System.Math;
{$ENDREGION}

type
  TPerformer = class
  private
    FAttachmentDir    : TAttachmentDir;
    FCriticalSection  : TCriticalSection;
    FDeleteAttachment : Boolean;
    FFileExt          : string;
    FIsBreak          : Boolean;
    FParseBodyAsHTML  : Boolean;
    FPathList         : TArrayRecord<TParamPath>;
    FRegExpList       : TArrayRecord<TRegExpData>;
    FUserDefinedDir   : string;
    FDuplicates       : Integer;
    function GetAttchmentPath(const aFileName: TFileName): string;
    function GetEXIFInfo(const aFileName: TFileName): string;
    function GetTextFromPDFFile(const aFileName: TFileName): string;
    procedure DeleteAttachmentFiles(const aData: PResultData);
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure FillStartParameters;
    procedure ParseAttachmentFiles(aData: PResultData);
    procedure ParseFile(const aFileName: TFileName);
  public
    procedure Start;
    procedure Clear;
    procedure RefreshEmails;
    procedure RefreshAttachment;
    procedure Break;

    constructor Create;
    destructor Destroy; override;
    property DuplicateCount: Integer read FDuplicates;
  end;


function GetRegExpCollection(const aText, aPattern: string; const aGroupIndex: Integer = 0): string; inline;

implementation

{ TPerformer }

procedure TPerformer.Clear;
begin
  FIsBreak := False;
  FDuplicates := 0;
end;

constructor TPerformer.Create;
begin
  FCriticalSection := TCriticalSection.Create;
end;

destructor TPerformer.Destroy;
begin
  FreeAndNil(FCriticalSection);
  inherited;
end;

procedure TPerformer.FillStartParameters;
begin
  FRegExpList       := TGeneral.GetRegExpParametersList;
  FPathList         := TGeneral.GetPathList;
  FParseBodyAsHTML  := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'ParseBodyAsHTML', False);
  FUserDefinedDir   := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachment', C_ATTACHMENTS_SUB_DIR);
  FAttachmentDir    := FAttachmentDir.FromString(FUserDefinedDir);
  FDeleteAttachment := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachment', True);
  FFileExt          := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
end;

procedure TPerformer.Start;
var
  FileList: TStringDynArray;
begin
  LogWriter.Write(ddEnterMethod, Self, 'Start');
  FillStartParameters;
  FIsBreak := False;
  FileList := [];
  FDuplicates := 0;

  for var Dir in FPathList do
    if Dir.WithSubdir then
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soAllDirectories))
    else
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soTopDirectoryOnly));

  TPublishers.ProgressPublisher.ClearTree;
  TPublishers.ProgressPublisher.StartProgress(Length(FileList));

  LogWriter.Write(ddText, Self, 'Length FileList - ' + Length(FileList).ToString);
  try
    try
      for var FileName in FileList do
      begin
        if FIsBreak then
          Exit;
        ParseFile(FileName);
      end;
    finally
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddExitMethod, Self, 'Start');
    end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, Self, 'Start', E.Message);
    end;
  end;
end;

procedure TPerformer.Break;
begin
  FIsBreak := True;
end;

procedure TPerformer.RefreshAttachment;
begin
  {TODO: RefreshAttachment}
end;

procedure TPerformer.RefreshEmails;
var
  arrKeys : TArray<string>;
  Pool    : TThreadPool;
begin
  if (TGeneral.EmailList.Count = 0) then
    Exit;

  LogWriter.Write(ddEnterMethod, Self, 'Refresh');
  FIsBreak := False;
  FillStartParameters;
  TPublishers.ProgressPublisher.StartProgress(TGeneral.EmailList.Count);

  LogWriter.Write(ddText, Self, 'Emails List Count - ' + TGeneral.EmailList.Count.ToString);
  try
    Pool := TThreadPool.Create;
    Pool.SetMaxWorkerThreads(TThread.ProcessorCount);
    try
      arrKeys := TGeneral.EmailList.Keys.ToArray;

      TParallel.For(Low(arrKeys), High(arrKeys),
        procedure(i: Int64; LoopState: TParallel.TLoopState)
        var
          Data: PResultData;
          Text: string;
        begin
          System.TMonitor.Enter(Self);
          try
            if FIsBreak then
              LoopState.Break;
          finally
            System.TMonitor.Exit(Self);
          end;

          Data := TGeneral.EmailList.Items[arrKeys[i]];
          if Assigned(Data) then
          begin
            Data^.Matches.Count := FRegExpList.Count;

            if FParseBodyAsHTML then
              Text := TDaMod.GetBodyAsHTML(Data^.Hash)
            else
              Text := TDaMod.GetBodyAsParsedText(Data^.Hash);
            if not Text.IsEmpty then
              for var j := 0 to FRegExpList.Count - 1 do
                if not Text.IsEmpty then
                  Data^.Matches[j] := GetRegExpCollection(Text, FRegExpList[j].RegExpTemplate, FRegExpList[j].GroupIndex)
                else
                  Data^.Matches[j] := string.Empty;
          end;
          TPublishers.ProgressPublisher.Progress;
          if (i = High(arrKeys)) then
            TPublishers.ProgressPublisher.EndProgress;
        end, Pool);

    finally
      FreeAndNil(Pool);
      LogWriter.Write(ddExitMethod, Self, 'Refresh');
    end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, Self, 'Refresh', E.Message);
    end;
  end;
end;

function TPerformer.GetAttchmentPath(const aFileName: TFileName): string;
var
  Path: string;
begin
  case FAttachmentDir of
    adAttachment:
      begin
        Path := TDirectory.GetParent(TPath.GetDirectoryName(aFileName));
        Result := TPath.Combine(Path, C_ATTACHMENTS_DIR);
      end;
    adSubAttachment:
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
        LogWriter.Write(ddError, Self, 'GetAttchmentPath', E.Message + sLineBreak + 'Directory - ' + Result);
    end;
end;

function TPerformer.GetEXIFInfo(const aFileName: TFileName): string;
var
  ImgData: TEXIFDump;
begin
  ImgData := TEXIFDump.Create(aFileName);
  try
    Result := ImgData.GetText;
  finally
    FreeAndNil(ImgData)
  end;
end;

procedure TPerformer.DeleteAttachmentFiles(const aData: PResultData);
begin
  if FDeleteAttachment then
  begin
    for var i := Low(aData.Attachments) to High(aData.Attachments) do
      if TFile.Exists(aData.Attachments[i].FileName) then
      try
        TFile.Delete(aData.Attachments[i].FileName);
      except
        on E: Exception do
          LogWriter.Write(ddError, Self,
                                   'TPerformer.DeleteAttachmentFiles',
                                   E.Message + sLineBreak +
                                   'Email name - ' + aData.FileName + sLineBreak +
                                   'File name - ' + aData.Attachments[i].FileName);
      end;
  end;
end;

procedure TPerformer.ParseFile(const aFileName: TFileName);
var
  Data        : PResultData;
  MailMessage : TclMailMessage;
  Text        : string;
begin
  New(Data);
  Data^.Clear;
  Data^.Hash          := TFileUtils.GetHash(aFileName);
  Data^.ShortName     := TPath.GetFileNameWithoutExtension(aFileName);
  Data^.FileName      := aFileName;
  Data^.Matches.Count := FRegExpList.Count;

  TGeneral.EmailList.AddItem(Data);

  if DaMod.IsEmailExistsByHash(Data^.Hash) then
  begin
    Inc(FDuplicates);
    DaMod.FillEmailRecord(Data);
    LogWriter.Write(ddWarning, Self, 'ParserHTML', 'Parameters of file "' + Data^.ShortName + '" loaded from DB');

    if FParseBodyAsHTML then
      Text := TDaMod.GetBodyAsHTML(Data^.Hash)
    else
      Text := TDaMod.GetBodyAsParsedText(Data^.Hash);

    TTask.Create(
      procedure()
      begin
        for var i := 0 to FRegExpList.Count - 1 do
        begin
          if FParseBodyAsHTML then
            Data^.Matches[i] := GetRegExpCollection(Text, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex)
          else
            Data^.Matches[i] := GetRegExpCollection(Text, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex);

          for var j := Low(Data^.Attachments) to High(Data^.Attachments) do
          begin
            Data^.Attachments[j].Matches.Count := FRegExpList.Count;
            if not Data^.Attachments[j].ParsedText.IsEmpty then
              Data^.Attachments[j].Matches[i] := GetRegExpCollection(Data^.Attachments[j].ParsedText, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex);
          end;
        end;
        TPublishers.ProgressPublisher.CompletedItem(Data);
      end).Start;
    Exit;
  end;

  MailMessage := TclMailMessage.Create(nil);
  MailMessage.OnSaveAttachment := DoSaveAttachment;
  try
    try
      MailMessage.ResultData := Data;
      MailMessage.LoadMessage(aFileName);

      Data^.MessageId   := MailMessage.MessageId;
      Data^.Subject     := MailMessage.Subject;
      Data^.TimeStamp   := MailMessage.Date;
      Data^.From        := MailMessage.From.FullAddress;
      Data^.ContentType := MailMessage.ContentType;

      if (MailMessage.ContentType = 'text/calendar') then
      begin
        if Assigned(MailMessage.Calendar) then
          Data^.Body := Concat(Data^.Body, MailMessage.Calendar.Strings.Text);
      end
      else
      begin
        if Assigned(MailMessage.MessageText) then
          Data^.Body := Concat(Data^.Body, MailMessage.MessageText.Text)
        else if Assigned(MailMessage.Html) then
          Data^.Body := Concat(Data^.Body, MailMessage.Html.Strings.Text);
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'ParserHTML', E.Message + sLineBreak + Data^.FileName);
    end;

    TTask.Create(
      procedure()
      var
        Tasks: array of ITask;
      begin
        Setlength(Tasks, 2);
        Tasks[0] := TTask.Create(
          procedure()
          begin
            TThread.NameThreadForDebugging('TPerformer.ParserHTML');
            if not Data^.Body.IsEmpty then
              try
                Data^.ParsedText := THtmlDom.GetText(Data^.Body);
              except
                on E: Exception do
                  LogWriter.Write(ddError, Self,
                                           'TPerformer.ParserHTML',
                                           E.Message + sLineBreak +
                                           'Email name - ' + Data^.FileName);
              end;
          end).Start;

        Tasks[1] := TTask.Create(
          procedure()
          begin
            TThread.NameThreadForDebugging('TPerformer.ParseEmail');
            ParseAttachmentFiles(Data);
          end).Start;

        TTask.WaitForAll(Tasks);
        for var i := 0 to FRegExpList.Count - 1 do
          if FParseBodyAsHTML then
            Data^.Matches[i] := GetRegExpCollection(Data^.Body, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex)
          else
            Data^.Matches[i] := GetRegExpCollection(Data^.ParsedText, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex);

        DeleteAttachmentFiles(Data);
        TPublishers.ProgressPublisher.CompletedItem(Data);
      end).Start;
  finally
    TPublishers.ProgressPublisher.Progress;
    FreeAndNil(MailMessage);
  end;
end;

procedure TPerformer.ParseAttachmentFiles(aData: PResultData);
var
  Ext: string;
  i: Integer;
begin
  i := 0;
  while i < High(aData.Attachments) do
  begin
    aData.Attachments[i].Hash          := TFileUtils.GetHash(aData.Attachments[i].FileName);
    aData.Attachments[i].Matches.Count := FRegExpList.Count;
    if TFile.Exists(aData.Attachments[i].FileName) then
      try
        Ext := TPath.GetExtension(aData.Attachments[i].FileName).ToLower;
        case TFileUtils.GetSignature(aData.Attachments[i].FileName) of
          fsPDF:
            begin
              aData.Attachments[i].ParsedText  := GetTextFromPDFFile(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'application/pdf';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiPdf.ToByte;
            end;
          fsPng:
            begin
              aData.Attachments[i].ParsedText  := GetEXIFInfo(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'image/png';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiPng.ToByte;
            end;
          fsGif:
            begin
              aData.Attachments[i].ParsedText  := GetEXIFInfo(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'image/gif';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiGif.ToByte;
            end;
          fsIco:
            begin
              aData.Attachments[i].ParsedText  := GetEXIFInfo(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'image/icon';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiIco.ToByte;
            end;
          fsJpg, fsJp2:
            begin
              aData.Attachments[i].ParsedText  := GetEXIFInfo(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'image/jpeg';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiJpg.ToByte;
            end;
          fsZip:
            begin
              if Ext.Contains('.xlsx') then
              begin
                aData.Attachments[i].ParsedText  := 'xlsx';
                aData.Attachments[i].ContentType := 'application/excel';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiXls.ToByte;
              end
              else if Ext.Contains('.docx') then
              begin
                aData.Attachments[i].ParsedText  := 'docx';
                aData.Attachments[i].ContentType := 'application/word';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiDoc.ToByte;
              end
              else if Ext.Contains('.zip') then
              begin
                aData.Attachments[i].ParsedText  := 'zip';
                aData.Attachments[i].ContentType := 'application/zip';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiZip.ToByte;
              end
            end;
          fsRar:
            begin
              aData.Attachments[i].ParsedText  := 'rar';
              aData.Attachments[i].ContentType := 'application/rar';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiRar.ToByte;
            end;
          fsOffice:
            begin
              if Ext.Contains('.xls') then
              begin
                aData.Attachments[i].ParsedText  := 'xls';
                aData.Attachments[i].ContentType := 'application/excel';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiXls.ToByte;
              end
              else if Ext.Contains('.doc') then
              begin
                aData.Attachments[i].ParsedText  := 'doc';
                aData.Attachments[i].ContentType := 'application/word';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiDoc.ToByte;
              end
              else
              begin
                aData.Attachments[i].ParsedText  := 'office';
                aData.Attachments[i].ContentType := 'application/office';
              end;
            end;
          fsCrt:
            begin
              aData.Attachments[i].ParsedText  := TFile.ReadAllText(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'application/crt';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiTxt.ToByte;
            end;
          fsKey:
            begin
              aData.Attachments[i].ParsedText  := TFile.ReadAllText(aData^.Attachments[i].FileName);
              aData.Attachments[i].ContentType := 'application/key';
              aData.Attachments[i].ImageIndex  := TExtIcon.eiTxt.ToByte;
            end;
          fsUnknown:
            begin
              if Ext.Contains('.txt') then
              begin
                aData.Attachments[i].ParsedText  := TFile.ReadAllText(aData^.Attachments[i].FileName);
                aData.Attachments[i].ContentType := 'text/plain';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiTxt.ToByte;
              end
              else if Ext.Contains('.htm') then
              begin
                aData.Attachments[i].ParsedText  := TFile.ReadAllText(aData^.Attachments[i].FileName);
                aData.Attachments[i].ContentType := 'text/html';
                aData.Attachments[i].ImageIndex  := TExtIcon.eiHtml.ToByte;
              end
              else
                aData.Attachments[i].ParsedText := '';
            end;
        end;
        if not aData.Attachments[i].ParsedText.IsEmpty then
          for var j := 0 to FRegExpList.Count - 1 do
            aData.Attachments[i].Matches[j] := GetRegExpCollection(aData.Attachments[i].ParsedText, FRegExpList[j].RegExpTemplate, FRegExpList[j].GroupIndex);
      except
        on E: Exception do
          LogWriter.Write(ddError, Self,
                                   'ParseAttachmentFiles',
                                   E.Message + sLineBreak +
                                   'Email name - ' + aData.FileName + sLineBreak +
                                   'File name - '  + aData.Attachments[i].FileName);
      end;
    Inc(i);
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
  SetLength(Data^.Attachments, Length(Data^.Attachments) + 1);
  Path := GetAttchmentPath(Data^.FileName);
  aFileName := Concat('[', Data^.ShortName, '] ', TFileUtils.GetCorrectFileName(aFileName));
  SetLength(aFileName, Min(Length(aFileName), 255));

  if not TPath.HasValidFileNameChars(aFileName, False) then
  begin
    aFileName := Format('[%s] (%d)', [Data^.ShortName, aBody.Index]);
    LogWriter.Write(ddText, Self,
                            'DoSaveAttachment',
                            'Email file name - '      + Data^.FileName  + sLineBreak +
                            'Email short name - '     + Data^.ShortName + sLineBreak +
                            'Attachment file name - ' + aFileName      + sLineBreak +
                            'Attachment index - '     + aBody.Index.ToString);
  end;

  if aFileName.Trim.IsEmpty or (not TPath.HasValidFileNameChars(aFileName, False)) then
  begin
    var NewName := Concat('[', Data^.ShortName, '] (', aBody.Index.ToString, ')');
    LogWriter.Write(ddWarning, Self,
                               'DoSaveAttachment',
                               'Bad file name - ' + aFileName  + sLineBreak +
                               'New file name - ' + NewName);
    aFileName := NewName;
  end;
  aBody.FileName := aFileName;

  Data^.Attachments[High(Data^.Attachments)].ShortName   := aFileName;
  Data^.Attachments[High(Data^.Attachments)].FileName    := TPath.Combine(Path, aFileName);
  Data^.Attachments[High(Data^.Attachments)].ParentHash  := Data^.Hash;
  Data^.Attachments[High(Data^.Attachments)].ParentName  := Data^.ShortName;
  Data^.Attachments[High(Data^.Attachments)].ContentID   := aBody.ContentID;
  Data^.Attachments[High(Data^.Attachments)].ContentType := aBody.ContentType;
  Data^.Attachments[High(Data^.Attachments)].Matches.Count := FRegExpList.Count;

  try
  {$WARN SYMBOL_PLATFORM OFF}
    aStreamData := TFileStream.Create(Data^.Attachments[High(Data^.Attachments)].FileName, fmCreate or fmOpenReadWrite {$IFDEF MSWINDOWS}or fmShareDenyRead{$ENDIF});
  {$WARN SYMBOL_PLATFORM ON}
  except
    on E:Exception do
      LogWriter.Write(ddError, Self,
                               'DoSaveAttachment',
                               E.Message + sLineBreak +
                               'Bad file name - ' + aFileName  + sLineBreak +
                               'New file name - ' + Data^.Attachments[High(Data^.Attachments)].FileName);
  end;
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
        LogWriter.Write(ddError, Self, 'GetTextFromPDFFile', 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(PDFCtrl);
    FCriticalSection.Leave;
  end;
end;

function GetRegExpCollection(const aText, aPattern: string; const aGroupIndex: Integer): string;
var
  GroupIndex : Integer;
  Matches    : TMatchCollection;
  RegExpr    : TRegEx;
begin
  Result := '';
  RegExpr := TRegEx.Create(aPattern);
  if RegExpr.IsMatch(aText) then
  begin
    Matches := RegExpr.Matches(aText, aPattern);
    for var i := 0 to Matches.Count - 1 do
    begin
      if (aGroupIndex <= 0) then
        GroupIndex := 0
      else if (aGroupIndex > Matches.Item[i].Groups.Count - 1) then
        GroupIndex := Matches.Item[i].Groups.Count - 1
      else
        GroupIndex := aGroupIndex;
      Result := Concat(Result, Matches.Item[i].Groups[GroupIndex].Value, '; ');
    end;
  end;
end;

end.
