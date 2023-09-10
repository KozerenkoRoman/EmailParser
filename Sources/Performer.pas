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
  System.Math, System.ZLib, System.Zip, System.Masks, System.StrUtils;
{$ENDREGION}

type
  TPerformer = class
  private
    FAttachmentDir    : TAttachmentDir;
    FCriticalSection  : TCriticalSection;
    FDeleteAttachment : Boolean;
    FFromDBCount      : Integer;
    FCount            : Integer;
    FFileExt          : string;
    FIsBreak          : Boolean;
    FPathList         : TParamPathArray;
    FRegExpList       : TRegExpArray;
    FSorterPathList   : TSorterPathArray;
    FUserDefinedDir   : string;
    function GetAttchmentPath(const aFileName: TFileName): string;
    function GetEXIFInfo(const aFileName: TFileName): string;
    function GetRegExpCollection(const aText, aPattern: string; const aGroupIndex: Integer = 0): TStringArray;
    function GetTextFromPDFFile(const aFileName: TFileName): string;
    function GetZipFileList(const aFileName: TFileName; const aData: PResultData): string;
    procedure DoCopyAttachmentFiles(const aData: PResultData);
    procedure DoDeleteAttachmentFiles(const aData: PResultData);
    procedure DoFillAttachments(const aData: PResultData; const aMailMessage: TclMailMessage);
    procedure DoParseAttachmentFiles(const aData: PResultData);
    procedure DoParseResultData(const aData: PResultData);
    procedure DoSaveAttachment(Sender: TObject; aBody: TclAttachmentBody; var aFileName: string; var aStreamData: TStream; var Handled: Boolean);
    procedure FillStartParameters;
    procedure ParseFile(const aFileName: TFileName);
  public
    procedure Start;
    procedure Stop;
    procedure Clear;
    procedure RefreshEmails;
    procedure RefreshAttachment;

    constructor Create;
    destructor Destroy; override;
    property FromDBCount: Integer read FFromDBCount;
    property Count      : Integer read FCount write FCount;
  end;

function GetStringFromMatches(const aText, aPattern: string; const aGroupIndex: Integer): string; inline;

implementation

{ TPerformer }

procedure TPerformer.Clear;
begin
  FCount       := 0;
  FFromDBCount := 0;
  FIsBreak     := False;
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
  FSorterPathList   := TGeneral.GetSorterPathList;
  FUserDefinedDir   := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachment', C_ATTACHMENTS_SUB_DIR);
  FAttachmentDir    := FAttachmentDir.FromString(FUserDefinedDir);
  FDeleteAttachment := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);
  FFileExt          := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
end;

procedure TPerformer.Start;
var
  FileList : TStringDynArray;
  DirList  : string;
begin
  LogWriter.Write(ddEnterMethod, Self, 'Start');
  FillStartParameters;
  FIsBreak     := False;
  FileList     := [];
  FFromDBCount := 0;
  try
    DirList := '';
    for var Dir in FPathList do
    begin
      DirList := DirList + sLineBreak + Dir.Path + IfThen(Dir.WithSubdir, ' with subdir');
      if Dir.WithSubdir then
        FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soAllDirectories))
      else
        FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FFileExt, TSearchOption.soTopDirectoryOnly));
    end;
    LogWriter.Write(ddText, Self, '<b>Paths to find files:</b>' + DirList);

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
        ParseFile(FileName);
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
  FIsBreak := True;
end;

procedure TPerformer.RefreshAttachment;
begin
  {TODO: RefreshAttachment}
end;

procedure TPerformer.RefreshEmails;
var
  arrKeys : TArray<string>;
  Data     : PResultData;
begin
  if (TGeneral.EmailList.Count = 0) then
    Exit;
  LogWriter.Write(ddText, Self, 'Emails List Count - ' + TGeneral.EmailList.Count.ToString);
  TPublishers.ProgressPublisher.StartProgress(FCount);
  try
    LogWriter.Write(ddEnterMethod, Self, 'Refresh');
    FIsBreak := False;
    FillStartParameters;

    try
      arrKeys := TGeneral.EmailList.Keys.ToArray;
      FCount := Length(arrKeys);
      for var i := Low(arrKeys) to High(arrKeys) do
      begin
        System.TMonitor.Enter(Self);
        try
          if FIsBreak then
            Break;
        finally
          System.TMonitor.Exit(Self);
        end;

        Data := TGeneral.EmailList.Items[arrKeys[i]];
        if Assigned(Data) and Assigned(Data^.ParentNode) then
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
  Result := '';
  ImgData := TEXIFDump.Create(aFileName);
  try
    try
      Result := ImgData.GetText;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'GetEXIFInfo', E.Message + sLineBreak + 'File name - ' + aFileName);
    end;
  finally
    FreeAndNil(ImgData)
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
    Path := TPath.Combine(GetAttchmentPath(aData.FileName), TPath.GetFileNameWithoutExtension(aData.FileName));
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
          FileName := Concat('[', aData^.ShortName, '] ', TFileUtils.GetCorrectFileName(ZipFile.FileNames[i]));
          SetLength(FileName, Min(Length(FileName), 255));
          if not RenameFile(TPath.Combine(Path, ZipFile.FileNames[i]), TPath.Combine(Path, FileName)) then
            DeleteFile(TPath.Combine(Path, ZipFile.FileNames[i]));

          New(Attachment);
          Attachment^.FileName      := TPath.Combine(Path, FileName);
          Attachment^.Hash          := TFileUtils.GetHash(Attachment^.FileName);
          Attachment^.ShortName     := FileName;
          Attachment^.ParentHash    := aData^.Hash;
          Attachment^.ParentName    := aData^.ShortName;
          Attachment^.Matches.Count := FRegExpList.Count;
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

procedure TPerformer.DoCopyAttachmentFiles(const aData: PResultData);
var
  Attachment  : PAttachment;
  NewFileName : TFileName;
begin
  for var item in FSorterPathList do
    for var attHash in aData^.Attachments do
      if TGeneral.AttachmentList.TryGetValue(attHash, Attachment) and
         TFile.Exists(Attachment.FileName) and
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
    Data^.Matches.Count := FRegExpList.Count;
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

      TTask.Create(
        procedure()
        var
          Tasks: array of ITask;
        begin
          SetLength(Tasks, 2);
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
              TThread.NameThreadForDebugging('TPerformer.DoParseAttachmentFiles');
              DoParseAttachmentFiles(Data);
            end).Start;

          TTask.WaitForAll(Tasks);
          for var i := 0 to FRegExpList.Count - 1 do
            if FRegExpList[i].UseRawText then
              Data^.Matches[i] := GetRegExpCollection(Data^.Subject + sLineBreak + Data^.Body, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex)
            else
              Data^.Matches[i] := GetRegExpCollection(Data^.Subject + sLineBreak + Data^.ParsedText, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex);

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
    aData^.IsMatch := False;
    aData^.Matches.Count := FRegExpList.Count;
    for var i := 0 to FRegExpList.Count - 1 do
      if FRegExpList[i].UseRawText then
      begin
        TextRaw := aData^.Subject + sLineBreak + TDaMod.GetBodyAsRawText(aData^.Hash);
        Break;
      end;
    for var i := 0 to FRegExpList.Count - 1 do
      if not FRegExpList[i].UseRawText then
      begin
        TextPlan := aData^.Subject + sLineBreak + TDaMod.GetBodyAsParsedText(aData^.Hash);
        Break;
      end;

    SetLength(Tasks, 2);
    Tasks[0] := TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TPerformer.DoParseResultData');
        for var i := 0 to FRegExpList.Count - 1 do
          if FRegExpList[i].UseRawText then
            aData^.Matches[i] := GetRegExpCollection(TextRaw, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex)
          else
            aData^.Matches[i] := GetRegExpCollection(TextPlan, FRegExpList[i].RegExpTemplate, FRegExpList[i].GroupIndex);
      end).Start;

    Tasks[1] := TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TPerformer.DoParseResultData');
        for var i := 0 to aData^.Attachments.Count - 1 do
          if TGeneral.AttachmentList.TryGetValue(aData^.Attachments[i], Attachment) then
          begin
            Attachment.Matches.Count := FRegExpList.Count;
            if Attachment^.ParsedText.IsEmpty then
              Attachment^.ParsedText := TDaMod.GetAttachmentAsRawText(Attachment^.Hash);
            for var j := 0 to FRegExpList.Count - 1 do
              Attachment.Matches[j] := GetRegExpCollection(Attachment^.ParsedText, FRegExpList[j].RegExpTemplate, FRegExpList[j].GroupIndex);
            Attachment.LengthAlignment;
          end;
      end).Start;
    TTask.WaitForAll(Tasks);
    TPublishers.ProgressPublisher.CompletedItem(aData);
  end;
end;

procedure TPerformer.DoParseAttachmentFiles(const aData: PResultData);
var
  Attachment : PAttachment;
  Ext        : string;
  i          : Integer;
begin
  i := 0;
  while (i <= High(aData.Attachments.Items)) do
  begin
    if TGeneral.AttachmentList.TryGetValue(aData.Attachments[i], Attachment) and
       TFile.Exists(Attachment.FileName) then
      try
        Attachment.Matches.Count := FRegExpList.Count;
        Ext := TPath.GetExtension(Attachment.FileName).ToLower;
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
          fsZip:
            begin
              if Ext.Contains('.xlsx') then
              begin
                Attachment.ContentType := 'application/excel';
                Attachment.ImageIndex  := TExtIcon.eiXls.ToByte;
                Attachment.ParsedText  := '';
              end
              else if Ext.Contains('.docx') then
              begin
                Attachment.ContentType := 'application/word';
                Attachment.ImageIndex  := TExtIcon.eiDoc.ToByte;
                Attachment.ParsedText  := '';
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
              Attachment.ParsedText  := '';
            end;
          fsOffice:
            begin
              if Ext.Contains('.xls') then
              begin
                Attachment.ContentType := 'application/excel';
                Attachment.ImageIndex  := TExtIcon.eiXls.ToByte;
                Attachment.ParsedText  := '';
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
          fsUnknown:
            begin
              if Ext.Contains('.txt') then
              begin
                Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
                Attachment.ContentType := 'text/plain';
                Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
              end
              else if Ext.Contains('.xml') then
              begin
                Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
                Attachment.ContentType := 'text/xml';
                Attachment.ImageIndex  := TExtIcon.eiTxt.ToByte;
              end
              else if Ext.Contains('.htm') then
              begin
                Attachment.ParsedText  := TFile.ReadAllText(Attachment.FileName);
                Attachment.ContentType := 'text/html';
                Attachment.ImageIndex  := TExtIcon.eiHtml.ToByte;
              end
              else
                Attachment.ParsedText := '';
            end;
        end;
        if not Attachment.ParsedText.IsEmpty then
          for var j := 0 to FRegExpList.Count - 1 do
            Attachment.Matches[j] := GetRegExpCollection(Attachment.ParsedText, FRegExpList[j].RegExpTemplate, FRegExpList[j].GroupIndex);
        Attachment.LengthAlignment;
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
      Attachment^.Matches.Count := FRegExpList.Count;
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

function TPerformer.GetRegExpCollection(const aText, aPattern: string; const aGroupIndex: Integer): TStringArray;
var
  GroupIndex : Integer;
  Matches    : TMatchCollection;
  RegExpr    : TRegEx;
begin
  Result := TStringArray.Create(0);
  if aText.IsEmpty then
    Exit;
  if aPattern.IsEmpty then
    Exit;

  RegExpr := TRegEx.Create(aPattern);
  if RegExpr.IsMatch(aText) then
  begin
    Matches := RegExpr.Matches(aText, aPattern);
    Result.Count := Matches.Count;
    for var i := 0 to Matches.Count - 1 do
    begin
      if (aGroupIndex <= 0) then
        GroupIndex := 0
      else if (aGroupIndex > Matches.Item[i].Groups.Count - 1) then
        GroupIndex := Matches.Item[i].Groups.Count - 1
      else
        GroupIndex := aGroupIndex;
      Result[i] := Matches.Item[i].Groups[GroupIndex].Value;
    end;
  end;
end;

function GetStringFromMatches(const aText, aPattern: string; const aGroupIndex: Integer): string;
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
