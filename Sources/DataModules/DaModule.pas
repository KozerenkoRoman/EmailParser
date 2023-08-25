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
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Entity.Emails,
  FireDAC.Phys.SQLiteIniFile;
{$ENDREGION}

type
  TDaMod = class(TDataModule, IProgress)
    FDConnection1: TFDConnection;
    FDTransaction1: TFDTransaction;
  private
    FThreadEmails: TThreadEmails;

    // IProgress
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: TResultData);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

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
begin
  if not FThreadEmails.Started then
    FThreadEmails.Start;
end;

procedure TDaMod.Deinitialize;
begin
  LogWriter.Write(ddWarning, Self, 'Deinitialize', 'QueueSize - ' + FThreadEmails.ResultDataQueue.QueueSize.ToString);
  FThreadEmails.Terminate;
end;

procedure TDaMod.Translate;
begin

end;

procedure TDaMod.StartProgress(const aMaxPosition: Integer);
begin
  // nothing
end;

procedure TDaMod.CompletedItem(const aResultData: TResultData);
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

end.
