unit Thread.Emails;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, DebugWriter, Global.Types,
  Vcl.ComCtrls, System.Generics.Defaults, Translate.Lang, Global.Resources, Common.Types, System.RegularExpressions,
  System.IOUtils, ArrayHelper, Utils, XmlFiles, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Forms,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Generics.Collections,
  System.Threading, System.Types, FireDAC.Stan.Param, FireDAC.Phys.SQLiteWrapper, DaModule.Resources, FireDAC.Phys.SQLite,
  Utils.Zip;
{$ENDREGION}

type
  TThreadEmails = class(TThread)
  private
    FConnection      : TFDConnection;
    FQueryAttachment : TFDQuery;
    FQueryEmail      : TFDQuery;
    FQueue           : TThreadedQueue<PResultData>;
    function GetSQLiteDatabase: TSQLiteDatabase;
    procedure CreateConnection;
    procedure ExecSQL(const aSQL: string);
    procedure InsertAttachment(const aAttachment: PAttachment; const aParentHash: string);
    procedure InsertData(const aResultData: PResultData);
  protected
    procedure Commit;
    procedure RollBack;
    function StartTransaction: Boolean;

    procedure Execute; override;
    property SQLiteDatabase: TSQLiteDatabase read GetSQLiteDatabase;
  public
    constructor Create;
    destructor Destroy; override;
    property ResultDataQueue: TThreadedQueue<PResultData> read FQueue;
  end;

implementation

{ TThreadEmails }

constructor TThreadEmails.Create;
begin
  inherited Create(True);
  Priority := tpLowest;
  FQueue := TThreadedQueue<PResultData>.Create(100000);
  CreateConnection;
end;

destructor TThreadEmails.Destroy;
begin
  FQueue.DoShutDown;
  FQueryEmail.Unprepare;
  FQueryAttachment.Unprepare;
  FreeAndNil(FQueryEmail);
  FreeAndNil(FQueryAttachment);
  FreeAndNil(FConnection);
  FreeAndNil(FQueue);
  inherited;
end;

procedure TThreadEmails.Execute;
var
  ResultData: PResultData;
  WaitResult: TWaitResult;
begin
  inherited;
  TThread.NameThreadForDebugging('Entity.Emails.TThreadEmails');
  try
    if not FConnection.Connected then
      FConnection.Connected := True;

    while not Terminated do
    begin
      WaitResult := FQueue.PopItem(ResultData);
      if (WaitResult = TWaitResult.wrSignaled) then
        if (not Terminated) and (not ResultData.MessageId.IsEmpty) then
          InsertData(ResultData);
    end;
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'Execute', E.Message);
  end;
end;

procedure TThreadEmails.CreateConnection;
var
  IsStartTransaction: Boolean;
  DBFile: TFileName;
begin
  DBFile := TPath.Combine(TDirectory.GetCurrentDirectory, C_SQLITE_DB_FILE);
  FConnection := TFDConnection.Create(nil);
  with FConnection do
  begin
    FetchOptions.Mode          := fmAll;
    TxOptions.DisconnectAction := xdNone;
    LoginPrompt                := False;
    UpdateOptions.LockWait := True;
    Params.Clear;
    Params.Add('Database=' + DBFile);
    Params.Add('DriverID=SQLite');
    Params.Add('LockingMode=Normal');
    Params.Add('OpenMode=omReadWrite');
    Params.Add('SharedCache=False');
    Params.Add('StringFormat=sfUnicode');
    Params.Add('SQLiteAdvanced=temp_store=MEMORY;page_size=4096;auto_vacuum=FULL');
  end;
  FConnection.Connected := True;

  IsStartTransaction := StartTransaction;
  try
    ExecSQL(rsSQLCreateTables);
    if IsStartTransaction then
      Commit;
  except
    if IsStartTransaction then
      RollBack;
  end;
  FQueryEmail := TFDQuery.Create(nil);
  FQueryEmail.Connection := FConnection;
  FQueryEmail.SQL.Add(rsSQLInsertEmail);

  FQueryAttachment := TFDQuery.Create(nil);
  FQueryAttachment.Connection := FConnection;
  FQueryAttachment.SQL.Add(rsSQLInsertAttachment);
end;

function TThreadEmails.GetSQLiteDatabase: TSQLiteDatabase;
begin
  Result := TSQLiteDatabase(FConnection.ConnectionIntf.CliObj);
end;

procedure TThreadEmails.Commit;
begin
  if SQLiteDatabase.InTransaction then
    ExecSQL('commit');
end;

procedure TThreadEmails.RollBack;
begin
  if SQLiteDatabase.InTransaction then
    ExecSQL('rollback');
end;

function TThreadEmails.StartTransaction: Boolean;
begin
  Result := not SQLiteDatabase.InTransaction;
  if Result then
    ExecSQL('begin transaction');
end;

procedure TThreadEmails.ExecSQL(const aSQL: string);
begin
  with TSQLiteStatement.Create(SQLiteDatabase) do
    try
      Prepare(aSQL);
      Execute;
      while PrepareNextCommand do
        Execute;
    finally
      Free;
    end;
end;

procedure TThreadEmails.InsertData(const aResultData: PResultData);
var
  IsStartTransaction: Boolean;
  Attachment: PAttachment;
begin
  if Terminated or not FConnection.Connected then
    Exit;

  IsStartTransaction := StartTransaction;
  try
    FQueryEmail.ParamByName('BODY').DataType := ftBlob;
    FQueryEmail.ParamByName('BODY').AsStream := TZipPack.GetCompressStr(aResultData^.Body);

    FQueryEmail.ParamByName('PARSED_TEXT').DataType := ftBlob;
    FQueryEmail.ParamByName('PARSED_TEXT').AsStream := TZipPack.GetCompressStr(aResultData^.ParsedText);

    FQueryEmail.ParamByName('PROJECT_ID').AsString   := 'ffd122fc6850fa960843d000d3700f94';
    FQueryEmail.ParamByName('HASH').AsString         := aResultData^.Hash;
    FQueryEmail.ParamByName('MESSAGE_ID').AsString   := aResultData^.MessageId;
    FQueryEmail.ParamByName('FILE_NAME').AsString    := aResultData^.FileName;
    FQueryEmail.ParamByName('SHORT_NAME').AsString   := aResultData^.ShortName;
    FQueryEmail.ParamByName('SUBJECT').AsString      := aResultData^.Subject;
    FQueryEmail.ParamByName('ADDRESS_FROM').AsString := aResultData^.From;
    FQueryEmail.ParamByName('CONTENT_TYPE').AsString := aResultData^.ContentType;
    FQueryEmail.ParamByName('TIME_STAMP').AsDateTime := aResultData^.TimeStamp;
    FQueryEmail.ExecSQL;
    if IsStartTransaction then
      Commit;
    aResultData^.ParsedText := '';
    aResultData^.Body       := '';

    for var attHash in aResultData^.Attachments do
      if TGeneral.AttachmentList.TryGetValue(attHash, Attachment) then
      begin
        InsertAttachment(Attachment, aResultData^.Hash);
        Attachment^.ParsedText := '';
      end;
  except
    on E: Exception do
    begin
      LogWriter.Write(ddError, Self, 'InsertData', E.Message);
      if IsStartTransaction then
        RollBack;
    end;
  end;
end;

procedure TThreadEmails.InsertAttachment(const aAttachment: PAttachment; const aParentHash: string);
var
  IsStartTransaction: Boolean;
begin
  if (not Terminated) and FConnection.Connected then
  begin
    IsStartTransaction := StartTransaction;
    try
      FQueryAttachment.ParamByName('PARSED_TEXT').DataType := ftBlob;
      FQueryAttachment.ParamByName('PARSED_TEXT').AsStream := TZipPack.GetCompressStr(aAttachment^.ParsedText);

      FQueryAttachment.ParamByName('PROJECT_ID').AsString   := 'ffd122fc6850fa960843d000d3700f94';
      FQueryAttachment.ParamByName('HASH').AsString         := aAttachment^.Hash;
      FQueryAttachment.ParamByName('PARENT_HASH').AsString  := aParentHash;
      FQueryAttachment.ParamByName('CONTENT_ID').AsString   := aAttachment^.ContentID;
      FQueryAttachment.ParamByName('FILE_NAME').AsString    := aAttachment^.FileName;
      FQueryAttachment.ParamByName('SHORT_NAME').AsString   := aAttachment^.ShortName;
      FQueryAttachment.ParamByName('CONTENT_TYPE').AsString := aAttachment^.ContentType;
      FQueryAttachment.ParamByName('FROM_ZIP').AsInteger    := aAttachment^.FromZip.ToInteger;
      FQueryAttachment.ParamByName('IMAGE_INDEX').AsInteger := aAttachment^.ImageIndex;
      FQueryAttachment.ExecSQL;
      if IsStartTransaction then
        Commit;
    except
      on E: Exception do
      begin
        LogWriter.Write(ddError, Self, 'InsertAttachment', E.Message);
        if IsStartTransaction then
          RollBack;
      end;
    end;
  end;
end;

end.
