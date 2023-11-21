unit Performer;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog,
  clHtmlParser, clMailMessage, MailMessage.Helper, Utils, Files.Utils, System.SyncObjs, UHTMLParse,
  Publishers.Interfaces, Publishers, dEXIF.Helper, DaModule, Global.Utils, System.Math, System.ZLib,
  System.Zip, System.Masks, System.StrUtils, InformationDialog, Html.Lib, Vcl.Graphics, UnRAR.Helper,
  System.Hash, AhoCorasick, Vcl.ComCtrls, ExcelReader.Helper, Vcl.Imaging.jpeg, Process.Utils,
  {$IFDEF EXTENDED_COMPONENTS}
    TesseractOCR, gtPDFClasses, gtExProPDFDoc, gtCstPDFDoc
  {$ELSE}
    PdfiumCore
  {$ENDIF EXTENDED_COMPONENTS};
{$ENDREGION}

type
  TPerformer = class
  strict private
    FAttachmentDir    : TAttachmentDir;
    FCount            : Integer;
    FCriticalSection  : TCriticalSection;
    FDeleteAttachment : Boolean;
    FFileExt          : string;
    FFromDBCount      : Integer;
    FIsBreak          : Boolean;
    FIsQuiet          : Boolean;
    FPathList         : TParamPathArray;
    FSorterPathList   : TSorterPathArray;
    FUserDefinedDir   : string;
{$IFDEF EXTENDED_COMPONENTS}
    FTesseract : TTesseractOCR;
{$ENDIF EXTENDED_COMPONENTS}
    function GetAttchmentPath(const aFileName: TFileName): string;
    function GetEXIFInfo(const aFileName: TFileName): string;
    function GetMatchCollection(const aText: string; const aPatternData: PPatternData): TStringArray;
    function GetRarFileList(const aFileName: TFileName; const aData: PResultData): string;
    function GetRtfText(const aFileName: TFileName): string;
    function GetTextFromPDFFile(const aFileName: TFileName): string;
    function GetWordText(const aFileName: TFileName): string;
    function GetXlsSheetList(const aFileName: TFileName; const aData: PResultData): string;
    function GetZipFileList(const aFileName: TFileName; const aData: PResultData): string;
    function IsSuccessfulCheck: Boolean;
    procedure DoCopyAttachmentFiles(const aData: PResultData);
    procedure DoDeleteAttachmentFiles(const aData: PResultData);
    procedure DoFillAttachments(const aData: PResultData; const aMailMessage: TclMailMessage);
    procedure DoParseAttachmentFiles(const aData: PResultData; const aProgressProc: TProc = nil);
    procedure DoParseResultData(const aData: PResultData);
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure FillStartParameters;
    procedure ParseFile(const aFileName: TFileName);
  private
    class var FPerformer: TPerformer;
  public
    procedure Start;
    procedure Stop;
    procedure Clear;
    procedure RefreshEmails;
    procedure RefreshAttachment;
    procedure FileSearch(const aPath, aFileMask: string);

    constructor Create;
    destructor Destroy; override;

    property Count       : Integer read FCount       write FCount;
    property FromDBCount : Integer read FFromDBCount write FFromDBCount;
    property IsQuiet     : Boolean read FIsQuiet     write FIsQuiet;

    class function GetInstance: TPerformer;
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
{$IFDEF EXTENDED_COMPONENTS}
  if Assigned(FTesseract) then
    FreeAndNil(FTesseract);
{$ENDIF EXTENDED_COMPONENTS}
  inherited;
end;

class function TPerformer.GetInstance: TPerformer;
begin
  if not Assigned(FPerformer) then
    FPerformer := TPerformer.Create;
  Result := FPerformer;
end;

procedure TPerformer.Clear;
begin
  FCount       := 0;
  FFromDBCount := 0;
  FIsBreak     := False;
end;

procedure TPerformer.FillStartParameters;
begin
  FPathList         := TGeneral.GetPathList;
  FSorterPathList   := TGeneral.GetSorterPathList;
  FUserDefinedDir   := TGeneral.CurrentProject.PathForAttachments;
  FDeleteAttachment := TGeneral.CurrentProject.DeleteAttachments;
  if FUserDefinedDir.IsEmpty then
    FUserDefinedDir := C_ATTACHMENTS_DIR;
  FAttachmentDir    := FAttachmentDir.FromString(FUserDefinedDir);
  FFileExt          := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
end;

function TPerformer.IsSuccessfulCheck: Boolean;
var
  sb: TStringBuilder;
  FailedText: string;
begin
  Result := True;
  FailedText := '';
  sb := TStringBuilder.Create;
  try
    sb.AppendLine('<b>RegExp list</b>');
    for var item in TGeneral.PatternList do
      sb.AppendFormat('%s [%d]: %s', [item.ParameterName, item.GroupIndex, item.Pattern]).AppendLine;
    if (TGeneral.PatternList.Count = 0) then
    begin
      Result := False;
      FailedText := TLang.Lang.Translate('RegExpIsEmpty') + sLineBreak;
    end;

    sb.AppendLine;
    sb.AppendLine('<b>Path list</b>');
    for var item in FPathList.Items do
    begin
      sb.Append(item.Path).AppendLine;
      if not TDirectory.Exists(item.Path) then
      begin
        Result := False;
        FailedText := Concat(FailedText, Format(TLang.Lang.Translate('PathNotExists'), [item.Path]), sLineBreak);
      end;
    end;
    if (FPathList.Count = 0) then
    begin
      Result := False;
      FailedText := TLang.Lang.Translate('PathsToFindNotExists') + sLineBreak;
    end;

    sb.AppendLine;
    sb.AppendLine('<b>Sorter list</b>');
    for var item in FSorterPathList.Items do
    begin
      sb.Append(item.Mask).Append(': ').Append(item.Path).AppendLine;
      if not TDirectory.Exists(item.Path) then
      begin
        Result := False;
        FailedText := Concat(FailedText, Format(TLang.Lang.Translate('PathNotExists'), [item.Path]), sLineBreak);
      end;
    end;
    LogWriter.Write(ddText, Self, sb.ToString);
  finally
    FreeAndNil(sb);
  end;

  if not Result then
  begin
    LogWriter.Write(ddError, Self, 'Start', FailedText);
    TMessageDialog.ShowError(FailedText);
  end;
end;

procedure TPerformer.Start;
var
  FileList : TStringDynArray;
begin
  LogWriter.Write(ddEnterMethod, Self, 'Start');
  FillStartParameters;
  if not IsSuccessfulCheck then
    Exit;

  FIsBreak     := False;
  FileList     := [];
  FFromDBCount := 0;
{$IFDEF EXTENDED_COMPONENTS}
  if TGeneral.CurrentProject.UseOCR and not TGeneral.CurrentProject.LanguageOCR.ToString.IsEmpty then
  begin
    if not Assigned(FTesseract) then
      FTesseract := TTesseractOCR.Create(nil);
    if Assigned(FTesseract) then
    begin
      FTesseract.Language := TGeneral.CurrentProject.LanguageOCR;
      FTesseract.Active := True;
    end;
  end;
{$ENDIF EXTENDED_COMPONENTS}

  try
    for var Dir in FPathList do
      if Dir.WithSubdir then
        FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soAllDirectories))
      else
        FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soTopDirectoryOnly));

    FCount := Length(FileList);
    TPublishers.ProgressPublisher.ClearTree;
    TPublishers.ProgressPublisher.StartProgress(Length(FileList));
    FCount := 0;

    LogWriter.Write(ddText, Self, 'Length FileList - ' + Length(FileList).ToString);
    try
      for var FileName in FileList do
      begin
        if FIsBreak then
        begin
          LogWriter.Write(ddWarning, Self, 'Click Break button');
          Exit;
        end;
        ParseFile(TFileUtils.CheckLength(FileName));
        Inc(FCount);
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

procedure TPerformer.Stop;
begin
  FCriticalSection.Enter;
  try
    FIsBreak := True;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPerformer.RefreshEmails;
var
  arrKeys : TArray<string>;
  Data     : PResultData;
begin
  if (TGeneral.EmailList.Count = 0) then
    Exit;
  FillStartParameters;
  if not IsSuccessfulCheck then
    Exit;

  LogWriter.Write(ddText, Self, 'Emails List Count - ' + TGeneral.EmailList.Count.ToString);
  TPublishers.ProgressPublisher.StartProgress(FCount);
  try
    LogWriter.Write(ddEnterMethod, Self, 'Refresh');
    FIsBreak := False;

    try
      arrKeys := TGeneral.EmailList.Keys.ToArray;
      FCount := Length(arrKeys);
      for var i := Low(arrKeys) to High(arrKeys) do
      begin
        FCriticalSection.Enter;
        try
          if FIsBreak then
            Exit;
        finally
          FCriticalSection.Leave;
        end;

        Data := TGeneral.EmailList.Items[arrKeys[i]];
        if Assigned(Data) and Assigned(Data^.OwnerNode) then
        begin
          DoParseResultData(Data);
          TPublishers.ProgressPublisher.Progress;
        end;
      end;
    finally
      TPublishers.ProgressPublisher.EndProgress;
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

procedure TPerformer.FileSearch(const aPath, aFileMask: string);
var
  Attachment : PAttachment;
  FileList   : TStringDynArray;
  Hash       : string;
  ResultData : TResultData;
begin
  LogWriter.Write(ddEnterMethod, Self, 'FileSearch');
  LogWriter.Write(ddText, Self, '<b>Paths to find files:</b>' + aPath + '\' + aFileMask);
  FileList := Concat(FileList, TDirectory.GetFiles(aPath, aFileMask, TSearchOption.soAllDirectories));
  FCount   := Length(FileList);

  TPublishers.ProgressPublisher.StartProgress(FCount);
  try
    if (FCount > 0) then
      try
        FillStartParameters;
        FIsBreak := False;

{$IFDEF EXTENDED_COMPONENTS}
        if TGeneral.CurrentProject.UseOCR and not TGeneral.CurrentProject.LanguageOCR.ToString.IsEmpty then
        begin
          if not Assigned(FTesseract) then
            FTesseract := TTesseractOCR.Create(nil);
          if Assigned(FTesseract) then
          begin
            FTesseract.Language := TGeneral.CurrentProject.LanguageOCR;
            FTesseract.Active := True;
          end;
        end;
{$ENDIF EXTENDED_COMPONENTS}

        TThread.NameThreadForDebugging('TPerformer.RefreshAttachment');
        FCount       := 0;
        FFromDBCount := 0;
        for var i := Low(FileList) to High(FileList) do
        begin
          FCriticalSection.Enter;
          try
            if FIsBreak then
              Exit;
          finally
            FCriticalSection.Leave;
          end;

          Hash := TFileUtils.GetHash(FileList[i]);
          Attachment := TGeneral.AttachmentList.GetItem(Hash);
          if not Assigned(Attachment) then
          begin
            New(Attachment);
            Attachment^.FileName  := FileList[i];
            Attachment^.ShortName := TPath.GetFileName(FileList[i]);
            Attachment^.FromZip   := False;
            Attachment^.FromDB    := False;
            LogWriter.Write(ddText, Self, 'FileSearch', 'Found file - ' + Attachment^.ShortName);
          end
          else
          begin
            Attachment^.FromDB := True;
            LogWriter.Write(ddWarning, Self, 'FileSearch', 'Duplicate file - ' + Attachment^.ShortName);
            Inc(FFromDBCount);
          end;
          Attachment^.Matches.Count := TGeneral.PatternList.Count;
          Attachment^.Hash       := Hash;
          Attachment^.ParentHash := '';
          Attachment^.ParentName := '';
          Attachment^.OwnerNode  := nil;
          TGeneral.AttachmentList.AddOrSetValue(Hash, Attachment);
          ResultData.Attachments.Add(Hash);
          DoParseAttachmentFiles(@ResultData,
            procedure()
            begin
              TPublishers.ProgressPublisher.Progress;
            end);
          Inc(FCount);
        end;
      finally
        TPublishers.ProgressPublisher.EndProgress;
        LogWriter.Write(ddExitMethod, Self, 'FileSearch');
      end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, Self, 'FileSearch', E.Message);
    end;
  end;
end;

procedure TPerformer.RefreshAttachment;
var
  arrKeys    : TArray<string>;
  Attachment : PAttachment;
begin
  if (TGeneral.EmailList.Count = 0) then
    Exit;
  FillStartParameters;
  if not IsSuccessfulCheck then
    Exit;
  TPublishers.ProgressPublisher.StartProgress(FCount);
  try
    LogWriter.Write(ddEnterMethod, Self, 'RefreshAttachment');
    FIsBreak := False;
    try
      arrKeys := TGeneral.AttachmentList.Keys.ToArray;
      FCount := 0;
      for var i := Low(arrKeys) to High(arrKeys) do
      begin
        FCriticalSection.Enter;
        try
          if FIsBreak then
            Exit;
        finally
          FCriticalSection.Leave;
        end;

        Attachment := TGeneral.AttachmentList.Items[arrKeys[i]];
        if Assigned(Attachment) and Assigned(Attachment^.OwnerNode) then
        begin
          LogWriter.Write(ddText, Self, 'RefreshAttachment', 'Attachment name - ' + Attachment^.ShortName);
          Inc(FCount);
          Attachment^.Matches.Count := TGeneral.PatternList.Count;
          if Attachment^.ParsedText.IsEmpty then
            Attachment^.ParsedText := TDaMod.GetAttachmentAsRawText(Attachment^.Hash);
{$IFDEF DETAILED_LOG}
          LogWriter.Write(ddText, Self, 'RefreshAttachment', 'Attachment file name - ' + Attachment^.FileName);
{$ENDIF DETAILED_LOG}
          for var j := 0 to Attachment^.Matches.Count - 1 do
            Attachment^.Matches[j] := GetMatchCollection(Attachment^.ParsedText, TGeneral.PatternList[j]);
          Attachment^.LengthAlignment;
          TPublishers.ProgressPublisher.CompletedAttach(Attachment);
          TPublishers.ProgressPublisher.Progress;
        end;
      end;
    finally
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddExitMethod, Self, 'RefreshAttachment');
    end;
  except
    on E: Exception do
    begin
      TPublishers.ProgressPublisher.EndProgress;
      LogWriter.Write(ddError, Self, 'RefreshAttachment', E.Message);
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

procedure TPerformer.DoCopyAttachmentFiles(const aData: PResultData);
var
  Attachment  : PAttachment;
  NewFileName : TFileName;
begin
  for var item in FSorterPathList do
    for var attHash in aData^.Attachments do
      if TGeneral.AttachmentList.TryGetValue(attHash, Attachment) then
        if TFile.Exists(Attachment.FileName) and
           MatchesMask(Attachment.FileName, item.Mask) then
          try
            NewFileName := TPath.Combine(item.Path, TPath.GetFileName(Attachment.FileName));
            if not TFile.Exists(NewFileName) then
            begin
              TFile.Copy(Attachment.FileName, NewFileName);
              LogWriter.Write(ddText, Self, 'DoCopyAttachmentFiles',
                                            'File - ' + Attachment.FileName + sLineBreak +
                                            'has been copied to - ' + NewFileName);
            end;
          except
            on E: Exception do
            LogWriter.Write(ddError, Self,
                                     'DoCopyAttachmentFiles',
                                     E.Message + sLineBreak +
                                     'Email name - ' + aData^.FileName + sLineBreak +
                                     'File name - ' + Attachment.FileName);
          end;
end;

procedure TPerformer.DoDeleteAttachmentFiles(const aData: PResultData);
var
  Attachment: PAttachment;
begin
  if FDeleteAttachment then
    for var attHash in aData.Attachments do
      if TGeneral.AttachmentList.TryGetValue(attHash, Attachment) and
         TFile.Exists(Attachment.FileName) then
        try
          TFile.Delete(Attachment.FileName);
        except
          on E: Exception do
            LogWriter.Write(ddError, Self,
                                     'DoDeleteAttachmentFiles',
                                     E.Message + sLineBreak +
                                     'Email name - ' + aData.FileName + sLineBreak +
                                     'File name - ' + Attachment.FileName);
        end;
end;

procedure TPerformer.ParseFile(const aFileName: TFileName);
var
  Data        : PResultData;
  Hash        : string;
  MailMessage : TclMailMessage;
  Tasks       : array of ITask;
begin
  Hash := TFileUtils.GetHash(aFileName);
  if not TGeneral.EmailList.ContainsKey(Hash) then
  begin
    LogWriter.Write(ddText, Self, 'ParseFile', 'File from disk - ' + aFileName);
    New(Data);
    Data^.Clear;
    Data^.Hash          := Hash;
    Data^.ShortName     := TPath.GetFileNameWithoutExtension(aFileName);
    Data^.FileName      := aFileName;
    Data^.Matches.Count := TGeneral.PatternList.Count;
    TGeneral.EmailList.AddOrSetValue(Hash, Data);

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
        DoFillAttachments(Data, MailMessage);

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
          LogWriter.Write(ddError, Self, 'ParseFile', E.Message + sLineBreak + Data^.FileName);
      end;

      SetLength(Tasks, 1);
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

      DoParseAttachmentFiles(Data);
      TTask.WaitForAll(Tasks);
{$IFDEF DETAILED_LOG}
      LogWriter.Write(ddText, Self, 'ParseFile', 'Email file name - ' + Data^.FileName);
{$ENDIF DETAILED_LOG}
      TTask.Create(
        procedure()
        begin
          for var i := 0 to TGeneral.PatternList.Count - 1 do
            if TGeneral.PatternList[i].UseRawText then
              Data^.Matches[i] := GetMatchCollection(Data^.Subject + sLineBreak + Data^.Body, TGeneral.PatternList[i])
            else
              Data^.Matches[i] := GetMatchCollection(Data^.Subject + sLineBreak + Data^.ParsedText, TGeneral.PatternList[i]);

          DoCopyAttachmentFiles(Data);
          DoDeleteAttachmentFiles(Data);
          TPublishers.ProgressPublisher.CompletedItem(Data);
        end).Start;
    finally
      TPublishers.ProgressPublisher.Progress;
      FreeAndNil(MailMessage);
    end;
  end
  else
  begin
    Data := TGeneral.EmailList.Items[Hash];
    DoParseResultData(Data);
    TPublishers.ProgressPublisher.Progress;
  end;
end;

procedure TPerformer.DoParseResultData(const aData: PResultData);
var
  Attachment : PAttachment;
  TextPlan   : string;
  TextRaw    : string;
  Tasks: array of ITask;
begin
  if Assigned(aData) then
  begin
    LogWriter.Write(ddText, Self, 'DoParseResultData', aData^.ShortName);
    aData^.Matches.Count := TGeneral.PatternList.Count;
    for var i := 0 to TGeneral.PatternList.Count - 1 do
      if TGeneral.PatternList[i].UseRawText then
      begin
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseResultData', 'GetBodyAsRawText Before');
{$ENDIF DETAILED_LOG}
        TextRaw := aData^.Subject + sLineBreak + TDaMod.GetBodyAsRawText(aData^.Hash);
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseResultData', 'GetBodyAsRawText After');
{$ENDIF DETAILED_LOG}
        Break;
      end;
    for var i := 0 to TGeneral.PatternList.Count - 1 do
      if not TGeneral.PatternList[i].UseRawText then
      begin
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseResultData', 'GetBodyAsParsedText Before');
{$ENDIF DETAILED_LOG}
        TextPlan := aData^.Subject + sLineBreak + TDaMod.GetBodyAsParsedText(aData^.Hash);
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseResultData', 'GetBodyAsParsedText After');
{$ENDIF DETAILED_LOG}
        Break;
      end;

    SetLength(Tasks, 2);
    Tasks[0] := TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TPerformer.DoParseResultData');
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseResultData', 'TTask0 Email file name - ' + aData^.ShortName);
{$ENDIF DETAILED_LOG}
        for var i := 0 to TGeneral.PatternList.Count - 1 do
          if TGeneral.PatternList[i].UseRawText then
            aData^.Matches[i] := GetMatchCollection(TextRaw, TGeneral.PatternList[i])
          else
            aData^.Matches[i] := GetMatchCollection(TextPlan, TGeneral.PatternList[i]);
      end);

    Tasks[1] := TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TPerformer.DoParseResultData');
        for var i := 0 to aData^.Attachments.Count - 1 do
          if TGeneral.AttachmentList.TryGetValue(aData^.Attachments[i], Attachment) then
          begin
            Attachment^.Matches.Count := TGeneral.PatternList.Count;
            if Attachment^.ParsedText.IsEmpty then
              Attachment^.ParsedText := TDaMod.GetAttachmentAsRawText(Attachment^.Hash);
{$IFDEF DETAILED_LOG}
            LogWriter.Write(ddText, Self, 'DoParseResultData', 'TTask1 Attachment file name - ' + Attachment^.ShortName);
{$ENDIF DETAILED_LOG}
            for var j := 0 to Attachment^.Matches.Count - 1 do
              Attachment^.Matches[j] := GetMatchCollection(Attachment^.ParsedText, TGeneral.PatternList[j]);
            Attachment^.LengthAlignment;
            TPublishers.ProgressPublisher.CompletedAttach(Attachment);
          end;
      end);

     for var Task in Tasks do
       Task.ExecuteWork;
    TTask.WaitForAll(Tasks);
    TPublishers.ProgressPublisher.CompletedItem(aData);
  end;
end;

procedure TPerformer.DoParseAttachmentFiles(const aData: PResultData; const aProgressProc: TProc = nil);
var
  Attachment : PAttachment;
  Ext        : string;
  i          : Integer;

  function ClearUrlData(AValue: string): string;
  var
    RegEx: TRegEx;
  begin
    RegEx := TRegEx.Create('(\(@"|url\(data)(.*?)\)', [roIgnoreCase, roSingleLine]);
    Result := RegEx.Replace(AValue, 'url()');
  end;

begin
{$IFDEF DETAILED_LOG}
  LogWriter.Write(ddEnterMethod, Self, 'DoParseAttachmentFiles');
{$ENDIF DETAILED_LOG}
  i := 0;
  while (i <= High(aData.Attachments.Items)) do
  begin
    if TGeneral.AttachmentList.TryGetValue(aData.Attachments[i], Attachment) then
      try
        Attachment.Matches.Count := TGeneral.PatternList.Count;
        Ext := TPath.GetExtension(Attachment.FileName).ToLower;
        //https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
        case TFileUtils.GetSignature(Attachment.FileName) of
          fsPDF:
            begin
              Attachment.ContentType := 'application/pdf';
              Attachment.ImageIndex  := TExtIcon.eiPdf.ToByte;
              Attachment.ParsedText  := GetTextFromPDFFile(Attachment.FileName);
            end;
          fsPng:
            begin
              Attachment.ContentType := 'image/png';
              Attachment.ImageIndex  := TExtIcon.eiPng.ToByte;
              Attachment.ParsedText  := GetEXIFInfo(Attachment.FileName);
            end;
          fsGif:
            begin
              Attachment.ContentType := 'image/gif';
              Attachment.ImageIndex  := TExtIcon.eiGif.ToByte;
              Attachment.ParsedText  := GetEXIFInfo(Attachment.FileName);
            end;
          fsIco:
            begin
              Attachment.ContentType := 'image/icon';
              Attachment.ImageIndex  := TExtIcon.eiIco.ToByte;
              Attachment.ParsedText  := GetEXIFInfo(Attachment.FileName);
            end;
          fsJpg, fsJp2:
            begin
              Attachment.ContentType := 'image/jpeg';
              Attachment.ImageIndex  := TExtIcon.eiJpg.ToByte;
              Attachment.ParsedText  := GetEXIFInfo(Attachment.FileName);
            end;
          fsTiff, fsTif:
            begin
              Attachment.ContentType := 'image/tiff';
              Attachment.ImageIndex  := TExtIcon.eiTiff.ToByte;
              Attachment.ParsedText  := GetEXIFInfo(Attachment.FileName);
            end;
          fsZip:
            begin
              if Ext.Contains('.xlsx') or Ext.Contains('.xlsm') then
              begin
                Attachment.ContentType := 'application/excel';
                Attachment.ImageIndex  := TExtIcon.eiXls.ToByte;
                Attachment.ParsedText  := GetXlsSheetList(Attachment.FileName, aData);
              end
              else if Ext.Contains('.docx') then
              begin
                Attachment.ContentType := 'application/word';
                Attachment.ImageIndex  := TExtIcon.eiDoc.ToByte;
                Attachment.ParsedText  := GetWordText(Attachment.FileName);
              end
              else if Ext.Contains('.zip') or Ext.Contains('.7z') then
              begin
                Attachment.ContentType := 'application/zip';
                Attachment.ImageIndex  := TExtIcon.eiZip.ToByte;
                Attachment.ParsedText  := GetZipFileList(Attachment.FileName, aData);
              end
            end;
          fsRar:
            begin
              Attachment.ContentType := 'application/rar';
              Attachment.ImageIndex  := TExtIcon.eiRar.ToByte;
              Attachment.ParsedText  := GetRarFileList(Attachment.FileName, aData);
            end;
          fsOffice:
            begin
              if Ext.Contains('.xls') then
              begin
                Attachment.ContentType := 'application/excel';
                Attachment.ImageIndex  := TExtIcon.eiXls.ToByte;
                Attachment.ParsedText  := GetXlsSheetList(Attachment.FileName, aData);
              end
              else if Ext.Contains('.doc') then
              begin
                Attachment.ContentType := 'application/word';
                Attachment.ImageIndex  := TExtIcon.eiDoc.ToByte;
                Attachment.ParsedText  := '';
              end
              else
              begin
                Attachment.ContentType := 'application/office';
                Attachment.ParsedText  := '';
              end;
            end;
          fsCrt:
            begin
              Attachment.ContentType := 'application/crt';
              Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
              Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
            end;
          fsKey:
            begin
              Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
              Attachment.ContentType := 'application/key';
              Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
            end;
          fsUTF8, fsUTF7, fsUTF1, fsUTF16be, fsUTF16le, fsUTF32be, fsUTF32le:
            begin
              Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
              Attachment.ContentType := 'text/plain';
              Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
            end;
          fsUnknown:
            begin
              if Ext.Contains('.txt') or
                 Ext.Contains('.opt') or
                 Ext.Contains('.ini') or
                 Ext.Contains('.csv') or
                 Ext.Contains('.cfg') then
              begin
                Attachment.ParsedText  := ClearUrlData(TFile.ReadAllText(Attachment.FileName));
                Attachment.ContentType := 'text/plain';
                Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
              end
              else if Ext.Contains('.xml') then
              begin
                Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
                Attachment.ContentType := 'text/xml';
                Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
              end
              else if Ext.Contains('.rtf') then
              begin
                Attachment.ParsedText  := GetRtfText(Attachment.FileName);
                Attachment.ContentType := 'text/rtf';
                Attachment.ImageIndex  := TExtIcon.eiHtml.ToByte;
              end
              else if Ext.Contains('.htm') then
              begin
                Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
                Attachment.ContentType := 'text/html';
                Attachment.ImageIndex  := TExtIcon.eiHtml.ToByte;
              end;
            end;
        end;
{$IFDEF DETAILED_LOG}
        LogWriter.Write(ddText, Self, 'DoParseAttachmentFiles', 'Attachment file name - ' + Attachment^.FileName);
{$ENDIF DETAILED_LOG}
        if not Attachment.ParsedText.IsEmpty then
          for var j := 0 to TGeneral.PatternList.Count - 1 do
            Attachment.Matches[j] := GetMatchCollection(Attachment.ParsedText, TGeneral.PatternList[j]);
        Attachment.LengthAlignment;
        TPublishers.ProgressPublisher.CompletedAttach(Attachment);
        if Assigned(aProgressProc) then
          aProgressProc();
      except
        on E: Exception do
          LogWriter.Write(ddError, Self,
                                   'DoParseAttachmentFiles',
                                   E.Message + sLineBreak +
                                   'Email name - ' + aData.FileName + sLineBreak +
                                   'File name - '  + Attachment.FileName);
      end;
    Inc(i);
  end;
{$IFDEF DETAILED_LOG}
  LogWriter.Write(ddExitMethod, Self, 'DoParseAttachmentFiles');
{$ENDIF DETAILED_LOG}
end;

procedure TPerformer.DoFillAttachments(const aData: PResultData; const aMailMessage: TclMailMessage);
var
  Attachment : PAttachment;
  Body       : TclAttachmentBody;
begin
  for var i := 0 to aMailMessage.Attachments.Count - 1 do
  begin
    if not(aMailMessage.Attachments[i] is TclAttachmentBody) then
      Break;
    Body := TclAttachmentBody(aMailMessage.Attachments[i]);
    if TFile.Exists(Body.FileName) then
    begin
      New(Attachment);
      Attachment^.Hash        := TFileUtils.GetHash(Body.FileName);
      Attachment^.ShortName   := TPath.GetFileName(Body.FileName);
      Attachment^.FileName    := Body.FileName;
      Attachment^.ParentHash  := aData^.Hash;
      Attachment^.ParentName  := aData^.ShortName;
      Attachment^.ContentID   := Body.ContentID;
      Attachment^.ContentType := Body.ContentType;
      Attachment^.Matches.Count := TGeneral.PatternList.Count;
      TGeneral.AttachmentList.AddOrSetValue(Attachment^.Hash, Attachment);
      aData^.Attachments.AddUnique(Attachment^.Hash);
    end;
  end;
end;

procedure TPerformer.DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
var
  Data : PResultData;
  Path : string;
begin
  if not(aBody is TclAttachmentBody) then
    Exit;

  Data      := TclMailMessage(Sender).ResultData;
  Path      := GetAttchmentPath(Data^.FileName);
  aFileName := TFileUtils.GetCorrectFileName(Path, Concat('[', Data^.ShortName, '] ', aFileName));
  if aFileName.Trim.IsEmpty then
  begin
    var NewName := Concat('[', Data^.ShortName, '] (', aBody.Index.ToString, ')');
    LogWriter.Write(ddWarning, Self,
                               'DoSaveAttachment',
                               'Bad file name - ' + aFileName  + sLineBreak +
                               'New file name - ' + NewName);
    aFileName := NewName;
  end;

  aFileName := TPath.Combine(Path, aFileName);
  Handled := not TFileUtils.IsForbidden(aFileName);
  if Handled then
  try
  {$WARN SYMBOL_PLATFORM OFF}
    aStreamData := TFileStream.Create(aFileName, fmCreate or fmOpenReadWrite{$IFDEF MSWINDOWS} or fmShareDenyRead{$ENDIF});
  {$WARN SYMBOL_PLATFORM ON}
  except
    on E:Exception do
      LogWriter.Write(ddError, Self,
                               'DoSaveAttachment',
                               E.Message + sLineBreak +
                               'File name - ' + aFileName);
  end;
end;

{$IFDEF EXTENDED_COMPONENTS}
function TPerformer.GetTextFromPDFFile(const aFileName: TFileName): string;
var
  Document : TgtExProPDFDocument;
  PageList : TgtPDFPageElementList;
  PageText : string;
begin
  Result := '';
  FCriticalSection.Enter;
  Document := TgtExProPDFDocument.Create(nil);
  try
    try
      Document.LoadFromFile(aFileName);
      for var i := 1 to Document.PageCount do
      try
        PageText := '';
        try
          PageList := Document.GetPageElements(i, [etImage], muPixels);
        except
          on Err: Exception do
            LogWriter.Write(ddError, Self, 'GetTextFromPDFFile', Err.Message + sLineBreak + 'PageList not assigned');
        end;
        if Assigned(PageList) then
          for var j := 0 to PageList.Count - 1 do
            if (PageList.Items[j] is TgtPDFImageElement) and TgtPDFImageElement(PageList.Items[j]).isJPEG then
            begin
              if TGeneral.CurrentProject.UseOCR and
                 not TGeneral.CurrentProject.LanguageOCR.ToString.IsEmpty and
                 Assigned(FTesseract) then
              begin
                TgtPDFImageElement(PageList.Items[j]).Image.Seek(0, TSeekOrigin.soBeginning);
                FTesseract.Picture.LoadFromStream(TgtPDFImageElement(PageList.Items[j]).Image);
                LogWriter.Write(ddText, Self, 'Begin OCR recognize', Format('Page %d, image %d, file name - %s', [i, j, aFileName]));
//                  Application.ProcessMessages;
                PageText := PageText + FTesseract.Text.Trim;
                LogWriter.Write(ddText, Self, 'End OCR recognize', Format('Page %d, image %d, file name - %s', [i, j, aFileName]));
              end;
            end
            else if (PageList.Items[j] is TgtPDFTextElement) then
              PageText := PageText + TgtPDFTextElement(PageList.Items[j]).Text.Trim;
            if not PageText.IsEmpty then
              Result := Result + PageText + sLineBreak;
      finally
        if Assigned(PageList) then
          FreeAndNil(PageList);
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetTextFromPDFFile', 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(Document);
    FCriticalSection.Leave;
  end;
end;

{$ELSE}
function TPerformer.GetTextFromPDFFile(const aFileName: TFileName): string;
var
  Document: TPdfDocument;
  PageText: string;
begin
  Result := '';
  FCriticalSection.Enter;
  Document := TPdfDocument.Create;
  try
    try
      Document.LoadFromFile(aFileName);
      for var i := 0 to Document.PageCount - 1 do
      begin
        PageText := Document.Pages[i].ReadText(0, 10000);
        if not PageText.IsEmpty then
          Result := Result + PageText + sLineBreak
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetTextFromPDFFile', 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(Document);
    FCriticalSection.Leave;
  end;
end;
{$ENDIF EXTENDED_COMPONENTS}

function TPerformer.GetEXIFInfo(const aFileName: TFileName): string;

  function GetTextFromImage: string;
  begin
    Result := '';
{$IFDEF EXTENDED_COMPONENTS}
    var pict := TPicture.Create;
    try
      pict.LoadFromFile(aFileName);
      if (pict.Width < 400) or (pict.Height < 600) then
        Exit;
    finally
      FreeAndNil(pict);
    end;

    if TGeneral.CurrentProject.UseOCR and
       not TGeneral.CurrentProject.LanguageOCR.ToString.IsEmpty and
       Assigned(FTesseract) then
    begin
      FCriticalSection.Enter;
      try
        FTesseract.Picture.LoadFromFile(aFileName);
        Application.ProcessMessages;
        try
          Result := C_OCR_SEPARATOR + sLineBreak + FTesseract.Text.Trim;
        except
          on E: Exception do
            LogWriter.Write(ddError, Self, 'GetEXIFInfo.GetTextFromImage', 'File name - ' + aFileName);
        end;
      finally
        FCriticalSection.Leave;
      end;
    end;
    LogWriter.Write(ddText, Self, 'GetEXIFInfo.GetTextFromImage', 'File name - ' + aFileName);
{$ENDIF EXTENDED_COMPONENTS}
  end;

var
  ImgData: TEXIFDump;
begin
  Result := '';
  ImgData := TEXIFDump.Create(aFileName);
  try
    try
      Result := ImgData.GetText + GetTextFromImage;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetEXIFInfo', E.Message + sLineBreak + 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(ImgData)
  end;
end;

function TPerformer.GetWordText(const aFileName: TFileName): string;
const
  C_PATTERN = '(?im)w:p(?=\s+.*?>)|(?<=<w:t).*?>(.*?)</w:t>';
var
  Path     : string;
  resArray : TStringArray;
  XmlText  : string;
  ZipFile  : TZipFile;
begin
  Result := '';
  Path := TPath.Combine(TPath.GetDirectoryName(aFileName), TPath.GetFileNameWithoutExtension(aFileName)).Trim;
  if not TDirectory.Exists(Path) then
    try
      TDirectory.CreateDirectory(Path);
    except
      on E: Exception do
      begin
        LogWriter.Write(ddError, Self, 'GetWordText', E.Message + sLineBreak + 'Directory - ' + Path);
        Exit;
      end;
    end;

  ZipFile := TZipFile.Create;
  try
    try
      ZipFile.Open(aFileName, zmRead);
      ZipFile.Extract('word/document.xml', Path, False);
      ZipFile.Close;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetWordText', E.Message + sLineBreak + aFileName);
    end;
  finally
    FreeAndNil(ZipFile);
  end;

  if TFile.Exists(TPath.Combine(Path, 'document.xml')) then
  begin
    XmlText := TFile.ReadAllText(TPath.Combine(Path, 'document.xml'), TEncoding.UTF8);
    var PatternData: TPatternData;
    PatternData.Pattern     := C_PATTERN;
    PatternData.GroupIndex  := 1;
    PatternData.TypePattern := TTypePattern.tpRegularExpression;
    resArray := GetMatchCollection(XmlText, @PatternData);
    for var item in resArray do
      if item.Trim.Equals('w:p') then
        Result := Concat(Result, sLineBreak)
      else
        Result := Concat(Result, item);
  end;

  try
    TDirectory.Delete(Path, True);
  except
    on E: Exception do
    begin
      LogWriter.Write(ddError, Self, 'GetWordText', E.Message + sLineBreak + 'Directory - ' + Path);
      Exit;
    end;
  end;
end;

function TPerformer.GetRtfText(const aFileName: TFileName): string;
var
  RTFConverter: TRichEdit;
begin
  if not TFile.Exists(aFileName) then
    Exit;
  RTFConverter := TRichEdit.CreateParented(HWND_MESSAGE);
  try
    try
      RTFConverter.Lines.LoadFromFile(aFileName);
      RTFConverter.PlainText             := True;
      RTFConverter.Lines.StrictDelimiter := True;
      RTFConverter.Lines.Delimiter       := #13;
      Result := RTFConverter.Lines.DelimitedText;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetRtfText', E.Message + sLineBreak + 'FileName - ' + aFileName);
    end;
  finally
    FreeAndNil(RTFConverter);
  end;
end;

function TPerformer.GetXlsSheetList(const aFileName: TFileName; const aData: PResultData): string;
var
  Attachment : PAttachment;
  FileName   : string;
  Sheets     : TArrayRecord<TSheet>;
begin
  Result := '';
  try
    Sheets := ExcelReader.Helper.GetXlsSheetList(aFileName);
    for var i := 0 to Sheets.Count - 1 do
      if not Sheets[i].Text.IsEmpty then
      begin
        FileName := Concat(TPath.GetFileNameWithoutExtension(aFileName), '\', Sheets[i].Title);
        New(Attachment);
        Attachment^.ParsedText    := Sheets[i].Text;
        Attachment^.FileName      := FileName;
        Attachment^.ShortName     := FileName;
        Attachment^.Hash          := TFileUtils.GetHashString(Sheets[i].Text);
        Attachment^.ParentHash    := aData^.Hash;
        Attachment^.ParentName    := aData^.ShortName;
        Attachment^.Matches.Count := TGeneral.PatternList.Count;
        Attachment^.FromZip       := True;
        Attachment^.ContentType   := 'text/sheet';
        Attachment^.ImageIndex    := TExtIcon.eiXls.ToByte;
        TGeneral.AttachmentList.AddOrSetValue(Attachment^.Hash, Attachment);
        aData^.Attachments.AddUnique(Attachment^.Hash);
        Result := Concat(Result, (i + 1).ToString, '. ', Sheets[i].Title, '<br>');
      end;
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'GetXlsSheetList', E.Message + sLineBreak + aFileName);
  end;
end;

function TPerformer.GetZipFileList(const aFileName: TFileName; const aData: PResultData): string;
var
  Attachment : PAttachment;
  FileName   : string;
  Path       : string;
  ZipFile    : TZipFile;
begin
  ZipFile := TZipFile.Create;
  try
    Path := TPath.Combine(GetAttchmentPath(aData.FileName), TPath.GetFileNameWithoutExtension(aFileName));
    if not TDirectory.Exists(Path) then
      try
        TDirectory.CreateDirectory(Path);
      except
        on E: Exception do
        begin
          LogWriter.Write(ddError, Self, 'GetZipFileList', E.Message + sLineBreak + 'Directory - ' + Path);
          Exit;
        end;
      end;

    try
      ZipFile.Open(aFileName, zmRead);
      for var i := Low(ZipFile.FileNames) to High(ZipFile.FileNames) do
        if not TFileUtils.IsForbidden(ZipFile.FileNames[i]) then
        begin
          ZipFile.Extract(ZipFile.FileNames[i], Path, True);
          FileName := TFileUtils.GetCorrectFileName(Path, Concat('[', aData^.ShortName, '] ', ZipFile.FileNames[i]));
          if not RenameFile(TPath.Combine(Path, ZipFile.FileNames[i]), TPath.Combine(Path, FileName)) then
            DeleteFile(TPath.Combine(Path, ZipFile.FileNames[i]));

          New(Attachment);
          Attachment^.FileName      := TPath.Combine(Path, FileName);
          Attachment^.Hash          := TFileUtils.GetHash(Attachment^.FileName);
          Attachment^.ShortName     := FileName;
          Attachment^.ParentHash    := aData^.Hash;
          Attachment^.ParentName    := aData^.ShortName;
          Attachment^.Matches.Count := TGeneral.PatternList.Count;
          Attachment^.FromZip       := True;
          TGeneral.AttachmentList.AddOrSetValue(Attachment^.Hash, Attachment);
          aData^.Attachments.AddUnique(Attachment^.Hash);

          Result := Concat(Result, (i + 1).ToString, '. ', FileName, '<br>');
        end;
      ZipFile.Close;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetZipFileList', E.Message + sLineBreak + aFileName);
    end;
  finally
    FreeAndNil(ZipFile);
  end;
end;

function TPerformer.GetRarFileList(const aFileName: TFileName; const aData: PResultData): string;
var
  Attachment     : PAttachment;
  FileList       : TArray<string>;
  FileName       : string;
  IsNeedPassword : Boolean;
  Path           : string;
  RarFile        : TUnRAR;
  Pwd            : string;
begin
  RarFile := TUnRAR.Create(aFileName);
  try
    Path := TPath.Combine(GetAttchmentPath(aData.FileName), TPath.GetFileNameWithoutExtension(aFileName));
    if not TDirectory.Exists(Path) then
      try
        TDirectory.CreateDirectory(Path);
      except
        on E: Exception do
        begin
          LogWriter.Write(ddError, Self, 'GetRarFileList', E.Message + sLineBreak + 'Directory - ' + Path);
          Exit;
        end;
      end;
    FileList := RarFile.GetFileList;
    IsNeedPassword := RarFile.ArcInfo.IsNeedPassword;
    if IsNeedPassword then
    begin
      if TGeneral.PasswordList.ContainsKey(aData^.Hash) then
        Pwd := TGeneral.PasswordList.Items[aData^.Hash].Password
      else
      begin
        var Password: PPassword;
        New(Password);
        Password.FileName  := aFileName;
        Password.Hash      := aData^.Hash;
        Password.IsDeleted := False;
        TThread.Queue(nil,
          procedure
          begin
            TGeneral.PasswordList.Add(aData^.Hash, Password);
          end);
        Pwd := '';
      end;
    end;

    if (RarFile.LastError <> 0) then
    begin
      LogWriter.Write(ddError, Self, 'GetRarFileList', RarFile.GetErrorText(RarFile.LastError));
      Exit;
    end;
  finally
    FreeAndNil(RarFile);
  end;

  try
    for var i := Low(FileList) to High(FileList) do
      if not TFileUtils.IsForbidden(FileList[i]) then
      begin
        RarFile := TUnRAR.Create(aFileName);
        try
          RarFile.DestPath := Path;
          if IsNeedPassword then
            RarFile.Password := Pwd;
          RarFile.Extract(FileList[i]);
          if (RarFile.LastError = 0) then
          begin
            FileName := TFileUtils.GetCorrectFileName(Path, Concat('[', aData^.ShortName, '] ', FileList[i]));
            if not RenameFile(TPath.Combine(Path, FileList[i]), TPath.Combine(Path, FileName)) then
              DeleteFile(TPath.Combine(Path, FileList[i]));

            New(Attachment);
            Attachment^.FileName      := TPath.Combine(Path, FileName);
            Attachment^.Hash          := TFileUtils.GetHash(Attachment^.FileName);
            Attachment^.ShortName     := FileName;
            Attachment^.ParentHash    := aData^.Hash;
            Attachment^.ParentName    := aData^.ShortName;
            Attachment^.Matches.Count := TGeneral.PatternList.Count;
            Attachment^.FromZip       := True;
            TGeneral.AttachmentList.TryAdd(Attachment^.Hash, Attachment);
            aData^.Attachments.AddUnique(Attachment^.Hash);
            Result := Concat(Result, (i + 1).ToString, '. ', FileName, '<br>');
          end;
        finally
          FreeAndNil(RarFile);
        end;
      end;
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'GetRarFileList', E.Message + sLineBreak + aFileName);
  end;
end;

function TPerformer.GetMatchCollection(const aText: string; const aPatternData: PPatternData): TStringArray;

  function GetRegExpCollection: TStringArray;
  var
    GroupIndex: Integer;
    Matches: TMatchCollection;
    RegExpr: TRegEx;
  begin
    RegExpr := TRegEx.Create(aPatternData^.Pattern);
    Matches := RegExpr.Matches(aText, aPatternData^.Pattern);
    Result.Count := Matches.Count;
    for var i := 0 to Matches.Count - 1 do
    begin
      if (aPatternData^.GroupIndex <= 0) then
        GroupIndex := 0
      else if (aPatternData^.GroupIndex > Matches.item[i].Groups.Count - 1) then
        GroupIndex := Matches.item[i].Groups.Count - 1
      else
        GroupIndex := aPatternData^.GroupIndex;
      Result[i] := Matches.item[i].Groups[GroupIndex].Value;
    end;
  end;

  function GetAhoCorasickCollection: TStringArray;
  var
    AhoCorasickObj: TAhoCorasick;
  begin
    AhoCorasickObj := TAhoCorasick.Create;
    try
      var arrPattern := aPatternData^.Pattern.Split([#10]);
      for var i := Low(arrPattern) to High(arrPattern) do
        if not arrPattern[i].Trim.IsEmpty then
          AhoCorasickObj.AddPattern(arrPattern[i].Trim);
      AhoCorasickObj.Build;
      Result.AddRange(AhoCorasickObj.Search(aText));
    finally
      FreeAndNil(AhoCorasickObj);
    end;
  end;

begin
{$IFDEF DETAILED_LOG}
  LogWriter.Write(ddEnterMethod, Self, 'GetRegExpCollection', aPatternData^.Pattern);
{$ENDIF DETAILED_LOG}
  Result := TStringArray.Create(0);
  if aText.IsEmpty then
    Exit;
  if aPatternData^.Pattern.IsEmpty then
    Exit;

  case aPatternData^.TypePattern of
    tpRegularExpression:
      Result := GetRegExpCollection;
    tpAhoCorasick:
      Result := GetAhoCorasickCollection;
  end;

{$IFDEF DETAILED_LOG}
  LogWriter.Write(ddExitMethod, Self, 'GetRegExpCollection');
{$ENDIF DETAILED_LOG}
end;

initialization

finalization
  if Assigned(TPerformer.FPerformer) then
    FreeAndNil(TPerformer.FPerformer)

end.
