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
    Connection             : TFDConnection;
    FDPhysSQLiteDriverLink : TFDPhysSQLiteDriverLink;
    qAllEmails             : TFDQuery;
    qAttachments           : TFDQuery;
    qEmail                 : TFDQuery;
    qEmailBodyAndText      : TFDQuery;
    qEmailByHash           : TFDQuery;
  private
    FThreadEmails: TThreadEmails;

    // IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);

    class function GetDecompressStr(const aSQLText, aHash: string): string;
    function IsEmailExistsByHash(const aHash: string): Boolean;
    procedure FillEmailRecord(const aResultData: PResultData);
    procedure FillAllEmailsRecord(const aWithAttachments: Boolean = False);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetBodyAndText(const aHash: string): TArray<string>;
    class function GetBodyAsRawText(const aHash: string): string;
    class function GetBodyAsParsedText(const aHash: string): string;

    procedure Initialize;
    procedure Deinitialize;
    procedure Translate;
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

  DBFile := TPath.Combine(TPath.GetDirectoryName(Application.ExeName), C_SQLITE_DB_FILE);
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
    qEmailByHash.Prepare;
    qAttachments.Prepare;
    if TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'LoadRecordsFromDB', True) then
      FillAllEmailsRecord(True);
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'Initialize', E.Message);
  end;
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
      FetchOptions.Mode := fmAll;
      TxOptions.DisconnectAction := xdNone;
      UpdateOptions.LockWait := True;
      LoginPrompt := False;
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
  Result := TDaMod.GetDecompressStr(rsSQLSelectBodyAsHtml, aHash);
end;

class function TDaMod.GetBodyAsParsedText(const aHash: string): string;
begin
  Result := TDaMod.GetDecompressStr(rsSQLSelectBodyAsParsedText, aHash);
end;

procedure TDaMod.Deinitialize;
begin
  FThreadEmails.Terminate;
  qEmail.Unprepare;
  qEmailBodyAndText.Unprepare;
  qEmailByHash.Unprepare;
  Connection.Connected := False;
end;

procedure TDaMod.Translate;
begin

end;

procedure TDaMod.StartProgress(const aMaxPosition: Integer);
begin
  // nothing
end;

procedure TDaMod.ClearTree;
begin
  // nothing
end;

procedure TDaMod.CompletedItem(const aResultData: PResultData);
begin
  if FThreadEmails.Started then
    FThreadEmails.ResultDataQueue.PushItem(aResultData);
end;

procedure TDaMod.Progress;
begin
  // nothing
end;

procedure TDaMod.EndProgress;
begin
  // nothing
end;

procedure TDaMod.FillEmailRecord(const aResultData: PResultData);
var
  i : Integer;
begin
  qEmail.ParamByName('HASH').AsString := aResultData.Hash;
  try
    qEmail.Open;
    aResultData.FileName    := qEmail.FieldByName('FILE_NAME').AsString;
    aResultData.ShortName   := qEmail.FieldByName('SHORT_NAME').AsString;
    aResultData.MessageId   := qEmail.FieldByName('MESSAGE_ID').AsString;
    aResultData.Subject     := qEmail.FieldByName('SUBJECT').AsString;
    aResultData.From        := qEmail.FieldByName('ADDRESS_FROM').AsString;
    aResultData.ContentType := qEmail.FieldByName('CONTENT_TYPE').AsString;
    aResultData.TimeStamp   := qEmail.FieldByName('TIME_STAMP').AsDateTime;
  finally
    qEmail.Close;
  end;

  qAttachments.ParamByName('PARENT_HASH').AsString := aResultData.Hash;
  try
    qAttachments.Open;
    qAttachments.FetchAll;
    SetLength(aResultData.Attachments, qAttachments.RecordCount);
    qAttachments.First;
    i := 0;
    while not qAttachments.Eof do
    begin
      aResultData.Attachments[i].Hash          := qAttachments.FieldByName('HASH').AsString;
      aResultData.Attachments[i].ParentHash    := aResultData.Hash;
      aResultData.Attachments[i].ParentName    := aResultData.ShortName;
      aResultData.Attachments[i].Position      := i;
      aResultData.Attachments[i].ShortName     := qAttachments.FieldByName('SHORT_NAME').AsString;
      aResultData.Attachments[i].FileName      := qAttachments.FieldByName('FILE_NAME').AsString;
      aResultData.Attachments[i].ContentID     := qAttachments.FieldByName('CONTENT_ID').AsString;
      aResultData.Attachments[i].ContentType   := qAttachments.FieldByName('CONTENT_TYPE').AsString;
      aResultData.Attachments[i].ParsedText    := TZipPack.DecompressStr(qAttachments.FieldByName('PARSED_TEXT').AsBytes);
      aResultData.Attachments[i].ImageIndex    := qAttachments.FieldByName('IMAGE_INDEX').AsInteger;
      aResultData.Attachments[i].Matches.Count := aResultData.Matches.Count;
      aResultData.Attachments[i].FromDB        := True;
      aResultData.Attachments[i].FromZip       := qAttachments.FieldByName('FROM_ZIP').AsInteger.ToBoolean;
      qAttachments.Next;
      Inc(i);
    end;
  finally
    qAttachments.Close;
  end;
end;

procedure TDaMod.FillAllEmailsRecord(const aWithAttachments: Boolean = False);
var
  i: Integer;
  ResultData: PResultData;
begin
  LogWriter.Write(ddEnterMethod, Self, 'FillAllEmailsRecord');
  try
    qAllEmails.Open;
    qAllEmails.First;
    while not qAllEmails.Eof do
    begin
      New(ResultData);
      ResultData.Clear;
      ResultData.Hash        := qAllEmails.FieldByName('HASH').AsString;
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
          SetLength(ResultData.Attachments, qAttachments.RecordCount);
          qAttachments.First;
          i := 0;
          while not qAttachments.Eof do
          begin
            ResultData.Attachments[i].Hash          := qAttachments.FieldByName('HASH').AsString;
            ResultData.Attachments[i].ParentHash    := ResultData.Hash;
            ResultData.Attachments[i].ParentName    := ResultData.ShortName;
            ResultData.Attachments[i].Position      := i;
            ResultData.Attachments[i].ShortName     := qAttachments.FieldByName('SHORT_NAME').AsString;
            ResultData.Attachments[i].FileName      := qAttachments.FieldByName('FILE_NAME').AsString;
            ResultData.Attachments[i].ContentID     := qAttachments.FieldByName('CONTENT_ID').AsString;
            ResultData.Attachments[i].ContentType   := qAttachments.FieldByName('CONTENT_TYPE').AsString;
  //          ResultData.Attachments[i].ParsedText    := TZipPack.DecompressStr(qAttachments.FieldByName('PARSED_TEXT').AsBytes);
            ResultData.Attachments[i].ImageIndex    := qAttachments.FieldByName('IMAGE_INDEX').AsInteger;
            ResultData.Attachments[i].Matches.Count := ResultData.Matches.Count;
            ResultData.Attachments[i].FromDB        := True;
            ResultData.Attachments[i].FromZip       := qAttachments.FieldByName('FROM_ZIP').AsInteger.ToBoolean;
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

function TDaMod.IsEmailExistsByHash(const aHash: string): Boolean;
begin
  qEmailByHash.ParamByName('HASH').AsString := aHash;
  try
    qEmailByHash.Open;
    Result := qEmailByHash.FieldByName('cnt').AsInteger > 0;
  finally
    qEmailByHash.Close;
  end;
end;

end.
