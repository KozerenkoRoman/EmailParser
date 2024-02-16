unit DaModule;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, DebugWriter,
  Global.Types, Vcl.ComCtrls, System.Generics.Defaults, Translate.Lang, Global.Resources,
  Common.Types, System.RegularExpressions, System.IOUtils, ArrayHelper, Utils, XmlFiles,
  Publishers, Publishers.Interfaces, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Forms,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Thread.Emails,
  DaModule.Resources, Utils.Zip, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.Phys.SQLiteWrapper.Stat;
{$ENDREGION}

type
  TDaMod = class(TDataModule, IProgress, IConfig)
    Connection         : TFDConnection;
    FDSQLiteDriverLink : TFDPhysSQLiteDriverLink;
    qAttachments       : TFDQuery;
    qEmail             : TFDQuery;
    qEmailBodyAndText  : TFDQuery;
    qEmails            : TFDQuery;
    qInsProject        : TFDQuery;
  private
    FThreadEmails: TThreadEmails;

    //IConfig
    procedure UpdateRegExp;
    procedure UpdateFilter(const aOperation: TFilterOperation);
    procedure UpdateLanguage;
    procedure UpdateProject;

    // IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachData: PAttachment);

    class function GetDecompressStr(const aSQLText, aHash: string): string;
//    procedure FillAllEmailsRecord(const aWithAttachments: Boolean); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBodyAndText(const aHash: string): TArray<string>;
    procedure FillAllEmailsRecord; overload;

    class function GetBodyAsRawText(const aHash: string): string;
    class function GetAttachmentAsRawText(const aHash: string): string;
    class function GetBodyAsParsedText(const aHash: string): string;

    procedure Initialize;
    procedure Deinitialize;
  end;

var
  DaMod: TDaMod;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

{ TDaMod }

constructor TDaMod.Create(AOwner: TComponent);
begin
  inherited;
  TPublishers.ProgressPublisher.Subscribe(Self);
  TPublishers.ConfigPublisher.Subscribe(Self);
  FThreadEmails := TThreadEmails.Create;
end;

destructor TDaMod.Destroy;
begin
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(Self);
  FreeAndNil(FThreadEmails);
  inherited;
end;

procedure TDaMod.Initialize;
var
  DBFile: TFileName;
begin
  if not FThreadEmails.Started then
    FThreadEmails.Start;

  DBFile := TPath.Combine(TDirectory.GetCurrentDirectory, C_SQLITE_DB_FILE);
  with Connection do
  begin
    FetchOptions.Mode          := fmAll;
    TxOptions.DisconnectAction := xdNone;
    UpdateOptions.LockWait     := True;
    LoginPrompt                := False;
    Params.Clear;
    Params.Add('Database=' + DBFile);
    Params.Add('DriverID=SQLite');
    Params.Add('LockingMode=Normal');
    Params.Add('OpenMode=omReadOnly');
    Params.Add('SharedCache=False');
    Params.Add('StringFormat=sfUnicode');
    Params.Add('SQLiteAdvanced=temp_store=MEMORY;page_size=4096;auto_vacuum=FULL');
  end;
  try
    Connection.Connected := True;
    qEmail.Prepare;
    qEmailBodyAndText.Prepare;
    qAttachments.Prepare;
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'Initialize', E.Message);
  end;
end;

procedure TDaMod.Deinitialize;
begin
  FThreadEmails.Terminate;
  qEmail.Unprepare;
  qEmailBodyAndText.Unprepare;
  Connection.Connected := False;
end;

class function TDaMod.GetDecompressStr(const aSQLText, aHash: string): string;
var
  Connection: TFDConnection;
  Query: TFDQuery;
  DBFile: TFileName;
begin
  DBFile := TPath.Combine(TPath.GetDirectoryName(Application.ExeName), C_SQLITE_DB_FILE);
  Connection := TFDConnection.Create(nil);
  try
    with Connection do
    begin
      FetchOptions.Mode          := fmAll;
      TxOptions.DisconnectAction := xdNone;
      UpdateOptions.LockWait     := True;
      LoginPrompt                := False;
      Params.Clear;
      Params.Add('Database=' + DBFile);
      Params.Add('DriverID=SQLite');
      Params.Add('LockingMode=Normal');
      Params.Add('OpenMode=omReadOnly');
      Params.Add('SharedCache=False');
      Params.Add('StringFormat=sfUnicode');
      Params.Add('SQLiteAdvanced=temp_store=MEMORY;page_size=4096;auto_vacuum=FULL');
    end;

    try
      Connection.Connected := True;
      Query := TFDQuery.Create(nil);
      try
        Query.Connection := Connection;
        Query.SQL.Add(aSQLText);
        Query.Params[0].AsString := aHash;
        Query.Prepare;
        Query.Open;
        if not Query.IsEmpty then
          try
            Result := TZipPack.DecompressStr(Query.Fields[0].AsBytes);
          except
            on Dec: Exception do
              LogWriter.Write(ddError, 'GetDecompressStr',
                                       Dec.Message + sLineBreak +
                                       'Hash - ' + aHash);
          end;
        Query.Close;
      finally
        Query.Unprepare;
        FreeAndNil(Query);
      end;
    except
      on E: Exception do
        LogWriter.Write(ddError, 'DaMod.GetQuery', E.Message);
    end;
  finally
    FreeAndNil(Connection);
  end;
end;

class function TDaMod.GetBodyAsRawText(const aHash: string): string;
begin
  Result := GetDecompressStr(rsSQLSelectBodyAsRawText, aHash);
end;

class function TDaMod.GetBodyAsParsedText(const aHash: string): string;
begin
  Result := GetDecompressStr(rsSQLSelectBodyAsParsedText, aHash);
end;

class function TDaMod.GetAttachmentAsRawText(const aHash: string): string;
begin
  Result := GetDecompressStr(rsSQLSelectAttachmentsAsParsedText, aHash);
end;

procedure TDaMod.CompletedItem(const aResultData: PResultData);
begin
  if FThreadEmails.Started then
    FThreadEmails.ResultDataQueue.PushItem(aResultData);
end;

procedure TDaMod.FillAllEmailsRecord;
var
  arrAttach  : TArray<string>;
  Attachment : PAttachment;
  ResultData : PResultData;
begin
  if TGeneral.CurrentProject.ProjectId.IsEmpty then
  begin
    LogWriter.Write(ddWarning, Self, 'FillAllEmailsRecord', 'Current project is empty');
    Exit;
  end;
  TGeneral.AttachmentList.ClearData;
  TGeneral.EmailList.ClearData;

  LogWriter.Write(ddEnterMethod, Self, 'FillAllEmailsRecord');
  try
    qEmails.ParamByName('PROJECT_ID').AsString := TGeneral.CurrentProject.ProjectId;
    qEmails.Open;
    qEmails.FetchAll;

    qAttachments.ParamByName('PROJECT_ID').AsString := TGeneral.CurrentProject.ProjectId;
    qAttachments.Open;
    qAttachments.FetchAll;
    TPublishers.ProgressPublisher.StartProgress(qEmails.RecordCount + qAttachments.RecordCount);

    try
      TGeneral.EmailList.SetCapacity(qEmails.RecordCount);
      while not qEmails.Eof do
      begin
        New(ResultData);
        ResultData.Clear;
        ResultData.Id          := qEmails.FieldByName('ID').AsString;
        ResultData.Hash        := qEmails.FieldByName('HASH').AsString;
        ResultData.FileName    := qEmails.FieldByName('FILE_NAME').AsString;
        ResultData.ShortName   := qEmails.FieldByName('SHORT_NAME').AsString;
        ResultData.MessageId   := qEmails.FieldByName('MESSAGE_ID').AsString;
        ResultData.Subject     := qEmails.FieldByName('SUBJECT').AsString;
        ResultData.From        := qEmails.FieldByName('ADDRESS_FROM').AsString;
        ResultData.ContentType := qEmails.FieldByName('CONTENT_TYPE').AsString;
        ResultData.TimeStamp   := qEmails.FieldByName('TIME_STAMP').AsDateTime;
        ResultData.Matches.Count := TGeneral.PatternList.Count;

        if not qEmails.FieldByName('ATTACH').AsString.IsEmpty then  //IsNull not work
        begin
          arrAttach := qEmails.FieldByName('ATTACH').AsString.Split([';']);
          ResultData.Attachments.AddRange(arrAttach);
        end;
        qEmails.Next;
        TGeneral.EmailList.Add(ResultData.Hash, ResultData);
        TPublishers.ProgressPublisher.CompletedItem(ResultData);
        TPublishers.ProgressPublisher.Progress;
      end;
    finally
      qEmails.Close;
    end;

    try
      TGeneral.AttachmentList.SetCapacity(qAttachments.RecordCount);
      while not qAttachments.Eof do
      begin
        New(Attachment);
        Attachment.ID            := qAttachments.FieldByName('ID').AsString;
        Attachment.ContentID     := qAttachments.FieldByName('CONTENT_ID').AsString;
        Attachment.ContentType   := qAttachments.FieldByName('CONTENT_TYPE').AsString;
        Attachment.FileName      := qAttachments.FieldByName('FILE_NAME').AsString;
        Attachment.ShortName     := qAttachments.FieldByName('SHORT_NAME').AsString;
        Attachment.FromZip       := qAttachments.FieldByName('FROM_ZIP').AsInteger.ToBoolean;
        Attachment.Hash          := qAttachments.FieldByName('HASH').AsString;
        Attachment.ImageIndex    := qAttachments.FieldByName('IMAGE_INDEX').AsInteger;
        Attachment.ParentHash    := qAttachments.FieldByName('PARENT_HASH').AsString;
        Attachment.ParentName    := qAttachments.FieldByName('PARENT_NAME').AsString;
        Attachment.FromDB        := True;
        Attachment.Matches.Count := TGeneral.PatternList.Count;
        TGeneral.AttachmentList.Add(Attachment.Hash, Attachment);
        TPublishers.ProgressPublisher.CompletedAttach(Attachment);
        TPublishers.ProgressPublisher.Progress;
        qAttachments.Next;
      end;
    finally
      qAttachments.Close;
    end;

  finally
    TPublishers.ProgressPublisher.EndProgress;
    LogWriter.Write(ddExitMethod, Self, 'FillAllEmailsRecord');
  end;
end;

function TDaMod.GetBodyAndText(const aHash: string): TArray<string>;
begin
  SetLength(Result, 2);
  qEmailBodyAndText.ParamByName('HASH').AsString := aHash;
  try
    qEmailBodyAndText.Open;
    try
      Result[0] := TZipPack.DecompressStr(qEmailBodyAndText.FieldByName('BODY').AsBytes);
      Result[1] := TZipPack.DecompressStr(qEmailBodyAndText.FieldByName('PARSED_TEXT').AsBytes);
    except
      on Dec: Exception do
        LogWriter.Write(ddError, Self, 'GetBodyAndText', Dec.Message + sLineBreak +
                                                         'Hash - ' + aHash);
    end;
  finally
    qEmailBodyAndText.Close;
  end;
end;

procedure TDaMod.CompletedAttach(const aAttachData: PAttachment);
begin
  // nothing
end;

procedure TDaMod.StartProgress(const aMaxPosition: Integer);
begin
  // nothing
end;

procedure TDaMod.UpdateFilter(const aOperation: TFilterOperation);
begin
  // nothing
end;

procedure TDaMod.UpdateLanguage;
begin
  // nothing
end;

procedure TDaMod.UpdateProject;
begin
  if not TGeneral.CurrentProject.ProjectId.IsEmpty then
    try
      qInsProject.ParamByName('ID').AsString   := TGeneral.CurrentProject.ProjectId;
      qInsProject.ParamByName('NAME').AsString := TGeneral.CurrentProject.Name;
      qInsProject.ParamByName('INFO').AsString := TGeneral.CurrentProject.Info;
      qInsProject.ExecSQL;
    except
      on E: Exception do
        LogWriter.Write(ddError, Self, 'UpdateProject', E.Message);
    end;
end;

procedure TDaMod.UpdateRegExp;
begin
  // nothing
end;

procedure TDaMod.ClearTree;
begin
  // nothing
end;

procedure TDaMod.Progress;
begin
  // nothing
end;

procedure TDaMod.EndProgress;
begin
  // nothing
end;

end.
