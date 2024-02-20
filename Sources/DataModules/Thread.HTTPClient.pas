unit Thread.HTTPClient;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, DebugWriter, Global.Types,
  Vcl.ComCtrls, System.Generics.Defaults, Translate.Lang, Global.Resources, Common.Types, System.IOUtils,
  ArrayHelper, Utils, XmlFiles, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Forms,
  System.Generics.Collections, System.Threading, System.Types, Files.Utils, System.Net.URLClient,
  System.Net.HTTPClient, System.Net.HttpClientComponent, System.JSON;
{$ENDREGION}

type
  TThreadHTTPClient = class(TThread)
  private
    FHost: string;
    FHTTP: TNetHTTPClient;
    FIsConnected: Boolean;
    FLogin: string;
    FPassword: string;
    FQueue: TThreadedQueue<string>;
    function Connected: Boolean;
  protected
    procedure Execute; override;
    procedure Post(const aJSON: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Host      : string                read FHost     write FHost;
    property Login     : string                read FLogin    write FLogin;
    property Password  : string                read FPassword write FPassword;
    property Queue : TThreadedQueue<string> read FQueue;
  end;

implementation

{ TThreadHTTPClient }

constructor TThreadHTTPClient.Create;
begin
  inherited Create(True);
  Priority := tpLowest;
  FQueue := TThreadedQueue<string>.Create(100000);
  FHTTP := TNetHTTPClient.Create(nil);
  FIsConnected := False;
end;

destructor TThreadHTTPClient.Destroy;
begin
  FQueue.DoShutDown;
  FreeAndNil(FHTTP);
  FreeAndNil(FQueue);
  inherited;
end;

procedure TThreadHTTPClient.Execute;
var
  Barn: string;
  WaitResult: TWaitResult;
begin
  inherited;
  TThread.NameThreadForDebugging('HTTPClient');
  try
    while not Terminated do
    begin
      WaitResult := FQueue.PopItem(Barn);
      if (WaitResult = TWaitResult.wrSignaled) then
        if (not Terminated) and Connected then
          Post(Barn);
    end;
  except
    on E: Exception do
      LogWriter.Write(ddError, Self, 'Execute', E.Message);
  end;
end;

function TThreadHTTPClient.Connected: Boolean;
var
  Params: TStringList;
  Response:  IHTTPResponse;
begin
  if FIsConnected then
    Exit(True);
  FHTTP.ContentType := 'application/x-www-form-urlencoded';
  FHTTP.AllowCookies := True;
  Params := TStringList.Create;
  try
    Params.AddPair('login', FLogin);
    Params.AddPair('password', FPassword);
    Response :=  FHTTP.Post(FHost + 'session', Params);
    if (Response.StatusCode <> 200) then
      LogWriter.Write(ddError, Self, 'Connected',
                                     'StatusCode: ' + Response.StatusCode.ToString +
                                     ', StatusText: ' + Response.StatusText);
    FIsConnected := Response.StatusCode = 200;
  finally
    FreeAndNil(Params);
  end;
  Result := FIsConnected;
end;

procedure TThreadHTTPClient.Post(const aJSON: string);
var
  Response: IHTTPResponse;
  Params: TStringStream;
begin
  FHTTP.ContentType := 'application/json';
  FHTTP.AcceptEncoding := 'UTF-8';
  FHTTP.AllowCookies := True;

  Params := TStringStream.Create(aJSON, TEncoding.UTF8);
  try
    Response := FHTTP.Post(FHost + 'barns', Params);
    if (Response.StatusCode <> 200) then
      LogWriter.Write(ddError, Self, 'Send',
                                     'StatusCode: ' + Response.StatusCode.ToString +
                                     ', StatusText: ' + Response.StatusText);
  finally
    FreeAndNil(Params);
  end;
end;


end.
