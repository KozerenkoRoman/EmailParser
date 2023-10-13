unit DaModule;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, DebugWriter,
  Global.Types, Vcl.ComCtrls, System.Generics.Defaults, Translate.Lang, Global.Resources,
  Common.Types, System.RegularExpressions, System.IOUtils, ArrayHelper, Utils, XmlFiles,
  Publishers, Publishers.Interfaces, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Forms,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Thread.Emails,
  FireDAC.Phys.SQLiteIniFile, DaModule.Resources, Utils.Zip;
{$ENDREGION}

type
  TDaMod = class(TDataModule, IProgress)
    Connection         : TFDConnection;
    FDSQLiteDriverLink : TFDPhysSQLiteDriverLink;
    qAllEmails         : TFDQuery;
    qAttachments       : TFDQuery;
    qEmail             : TFDQuery;
    qEmailBodyAndText  : TFDQuery;
  private
    FThreadEmails: TThreadEmails;

    // IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachData: PAttachment);

    class function GetDecompressStr(const aSQLText, aHash: string): string;
    procedure FillAllEmailsRecord(const aWithAttachments: Boolean = False);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBodyAndText(const aHash: string): TArray<string>;
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
  FThreadEmails := TThreadEmails.Create;
end;

destructor TDaMod.Destroy;
begin
  TPublishers.ProgressPublisher.Unsubscribe(Self);
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
    FetchOptions.Mode := fmAll;
    TxOptions.DisconnectAction := xdNone;
    LoginPrompt := False;
    UpdateOptions.LockWait := True;
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
    if TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'LoadRecordsFromDB', True) then
      FillAllEmailsRecord(True);
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

procedure TDaMod.CompletedAttach(const aAttachData: PAttachment);
begin
  // nothing
end;

procedure TDaMod.StartProgress(const aMaxPosition: Integer);
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

procedure TDaMod.FillAllEmailsRecord(const aWithAttachments: Boolean = False);
var
  i: Integer;
  ResultData: PResultData;
  Attachment: PAttachment;
begin
  LogWriter.Write(ddEnterMethod, Self, 'FillAllEmailsRecord');
  qAllEmails.Open;
  try
    qAllEmails.FetchAll;
    TGeneral.EmailList.SetCapacity(qAllEmails.RecordCount);
    while not qAllEmails.Eof do
    begin
      New(ResultData);
      ResultData.Clear;
      ResultData.Hash        := qAllEmails.FieldByName('HASH').AsString;
      ResultData.FileName    := qAllEmails.FieldByName('FILE_NAME').AsString;
      ResultData.ShortName   := qAllEmails.FieldByName('SHORT_NAME').AsString;
      ResultData.MessageId   := qAllEmails.FieldByName('MESSAGE_ID').AsString;
      ResultData.Subject     := qAllEmails.FieldByName('SUBJECT').AsString;
      ResultData.From        := qAllEmails.FieldByName('ADDRESS_FROM').AsString;
      ResultData.ContentType := qAllEmails.FieldByName('CONTENT_TYPE').AsString;
      ResultData.TimeStamp   := qAllEmails.FieldByName('TIME_STAMP').AsDateTime;

      if aWithAttachments then
      begin
        qAttachments.ParamByName('PARENT_HASH').AsString := ResultData.Hash;
        try
          qAttachments.Open;
          qAttachments.FetchAll;
          ResultData.Attachments.Count := qAttachments.RecordCount;
          qAttachments.First;
          i := 0;
          while not qAttachments.Eof do
          begin
            New(Attachment);
//            Attachment.ParsedText    := TZipPack.DecompressStr(qAttachments.FieldByName('PARSED_TEXT').AsBytes);
            Attachment.ContentID     := qAttachments.FieldByName('CONTENT_ID').AsString;
            Attachment.ContentType   := qAttachments.FieldByName('CONTENT_TYPE').AsString;
            Attachment.FileName      := qAttachments.FieldByName('FILE_NAME').AsString;
            Attachment.ShortName     := qAttachments.FieldByName('SHORT_NAME').AsString;
            Attachment.FromZip       := qAttachments.FieldByName('FROM_ZIP').AsInteger.ToBoolean;
            Attachment.Hash          := qAttachments.FieldByName('HASH').AsString;
            Attachment.ImageIndex    := qAttachments.FieldByName('IMAGE_INDEX').AsInteger;
            Attachment.Matches.Count := ResultData.Matches.Count;
            Attachment.ParentHash    := ResultData.Hash;
            Attachment.ParentName    := ResultData.ShortName;
            Attachment.FromDB        := True;
            TGeneral.AttachmentList.Add(Attachment.Hash, Attachment);
            ResultData.Attachments[i] := Attachment.Hash;
            qAttachments.Next;
            Inc(i);
          end;
        finally
          qAttachments.Close;
        end;
      end;
      qAllEmails.Next;
      TGeneral.EmailList.Add(ResultData.Hash, ResultData);
    end;
  finally
    qAllEmails.Close;
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

end.
