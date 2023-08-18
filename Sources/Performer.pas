﻿unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog,
  clHtmlParser, clMailMessage, MailMessage.Helper, Utils, ExecConsoleProgram, PdfiumCore, PdfiumCtrl,
  Winapi.GDIPAPI, Winapi.GDIPOBJ, Files.Utils, System.SyncObjs, HtmlParserEx, Publishers.Interfaces,
  Publishers;
{$ENDREGION}

type
  TPerformer = class
  private
    FAttachmentsDir    : TAttachmentsDir;
    FCriticalSection   : TCriticalSection;
    FDeleteAttachments : Boolean;
    FFileExt           : string;
    FIsBreak           : Boolean;
    FParseBodyAsHTML   : Boolean;
    FPathList          : TArrayRecord<TParamPath>;
    FRegExpList        : TArrayRecord<TRegExpData>;
    FUseLastGroup      : Boolean;
    FUserDefinedDir    : string;
    function GetAttchmentPath(const aFileName: TFileName): string;
    function GetTextFromPDFFile(const aFileName: TFileName): string;
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure ParseAttachmentFiles(aData: PResultData);
    procedure ParseEmail(const aFileName: TFileName);
    procedure ParseFile(const aFileName: TFileName);
    procedure FillStartParameters;
  public
    class function GetRegExpCollection(const aText, aPattern: string; const aUseLastGroup: Boolean = True): string;
    procedure Start;
    procedure Refresh(const aResultDataArray: PResultDataArray);
    procedure Break;

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

procedure TPerformer.FillStartParameters;
begin
  FRegExpList        := TGeneral.GetRegExpParametersList;
  FPathList          := TGeneral.GetPathList;
  FParseBodyAsHTML   := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'ParseBodyAsHTML', False);
  FUseLastGroup      := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'UseLastGroup', True);
  FUserDefinedDir    := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachments', C_ATTACHMENTS_SUB_DIR);
  FAttachmentsDir    := FAttachmentsDir.FromString(FUserDefinedDir);
  FDeleteAttachments := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);
  FFileExt           := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
end;

procedure TPerformer.Start;
var
  FileList: TStringDynArray;
begin
  LogWriter.Write(ddEnterMethod, 'TPerformer.Start');
  FillStartParameters;
  FIsBreak := False;
  FileList := [];

  for var Dir in FPathList do
    if Dir.WithSubdir then
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soAllDirectories))
    else
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soTopDirectoryOnly));

  TPublishers.ProgressPublisher.StartProgress(Length(FileList));

  LogWriter.Write(ddText, 'Length FileList - ' + Length(FileList).ToString);
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
      LogWriter.Write(ddExitMethod, 'TPerformer.Start');
    end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, 'TPerformer.Start', E.Message);
    end;
  end;
end;

procedure TPerformer.Break;
begin
  FIsBreak := True;
end;

procedure TPerformer.Refresh(const aResultDataArray: PResultDataArray);
begin
  if aResultDataArray.Count = 0 then
    Exit;

  LogWriter.Write(ddEnterMethod, 'TPerformer.Refresh');
  FIsBreak := False;
  FillStartParameters;
  TPublishers.ProgressPublisher.StartProgress(aResultDataArray^.Count);

  LogWriter.Write(ddText, 'Length of ResultDataArray - ' + aResultDataArray^.Count.ToString);
  try
    try
      for var Data in aResultDataArray^ do
      begin
        if FIsBreak then
          Exit;

        Data.Matches.Count := FRegExpList.Count;
        for var i := 0 to FRegExpList.Count - 1 do
          if FParseBodyAsHTML then
            Data.Matches[i] := GetRegExpCollection(Data.Body, FRegExpList[i].RegExpTemplate, FUseLastGroup)
          else
            Data.Matches[i] := GetRegExpCollection(Data.ParsedText, FRegExpList[i].RegExpTemplate, FUseLastGroup);

//         Data^.From := 'aaa' + Data^.From ;
//        TPublishers.ProgressPublisher.CompletedItem(Data);
        TPublishers.ProgressPublisher.Progress;
      end;
    finally
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddExitMethod, 'TPerformer.Refresh');
    end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, 'TPerformer.Refresh', E.Message);
    end;
  end;
end;

procedure TPerformer.ParseFile(const aFileName: TFileName);
begin
  ParseEmail(aFileName);
  TPublishers.ProgressPublisher.Progress;
end;

class function TPerformer.GetRegExpCollection(const aText, aPattern: string; const aUseLastGroup: Boolean): string;
var
  RegExpr: TRegEx;
  Match: TMatch;
begin
  Result := '';
  RegExpr := TRegEx.Create(aPattern);
  Match := RegExpr.Match(aText);
  if Match.Success then
  begin
    if aUseLastGroup then
      Result := Match.Groups[Match.Groups.Count - 1].Value
    else
    Result := '6654654';
//      for var i := 0 to Match.Groups.Count - 1 do
//        Result := Concat(Result, Match.Groups[i].Value, '; ');
  end;
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
  Data        : PResultData;
  MailMessage : TclMailMessage;
begin
  New(Data);
  Data^.ShortName := TPath.GetFileNameWithoutExtension(aFileName);
  Data^.FileName  := aFileName;

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
        LogWriter.Write(ddError, E.Message + sLineBreak + Data^.FileName);
    end;

    TTask.Create(
      procedure()
      var
        Tasks: array of ITask;
      begin
        Setlength(Tasks, 2);
        Tasks[0] := TTask.Create(
          procedure()
          var
            HtmlElement: IHtmlElement;
          begin
            TThread.NameThreadForDebugging('TPerformer.ParserHTML');
            if not Data^.Body.IsEmpty then
            begin
              HtmlElement := ParserHTML(Data^.Body);
              if Assigned(HtmlElement) then
                Data^.ParsedText := ConvertWhiteSpace(DecodeHtmlEntities(HtmlElement.Text));
            end;
          end).Start;

        Tasks[1] := TTask.Create(
          procedure()
          begin
            TThread.NameThreadForDebugging('TPerformer.ParseEmail');
            ParseAttachmentFiles(Data);
          end).Start;
        TTask.WaitForAll(Tasks);

        Data.Matches.Count := FRegExpList.Count;
        for var i := 0 to FRegExpList.Count - 1 do
          if FParseBodyAsHTML then
            Data.Matches[i] := GetRegExpCollection(Data.Body, FRegExpList[i].RegExpTemplate, FUseLastGroup)
          else
            Data.Matches[i] := GetRegExpCollection(Data.ParsedText, FRegExpList[i].RegExpTemplate, FUseLastGroup);

        TPublishers.ProgressPublisher.CompletedItem(Data^);
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
