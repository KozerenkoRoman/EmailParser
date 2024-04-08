unit Thread.HTTPClient;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, DebugWriter, Global.Types,
  Vcl.ComCtrls, System.Generics.Defaults, Translate.Lang, Global.Resources, Common.Types, System.IOUtils,
  ArrayHelper, Utils, XmlFiles, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Vcl.Forms,
  System.Generics.Collections, System.Threading, System.Types, Utils.Files, System.Net.URLClient,
  System.Net.HTTPClient, System.Net.HttpClientComponent, System.JSON, System.NetConsts;
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
    procedure Post(const aJSON: string);
    procedure PostDictionaryTag(const aJSONObject: TJSONObject);
  const
    C_LOG_TYPE: array [Boolean] of TLogDetailType = (ddError, ddText);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    property Host      : string                read FHost     write FHost;
    property Login     : string                read FLogin    write FLogin;
    property Password  : string                read FPassword write FPassword;
    property JSONQueue : TThreadedQueue<string> read FQueue;
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
  Response: IHTTPResponse;
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
    LogWriter.Write(C_LOG_TYPE[Response.StatusCode = 200], Self,
                                   'Connected',
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
  JSONObject : TJSONObject;
  JSONValue  : TJSONValue;
  Params     : TStringStream;
  Response   : IHTTPResponse;
begin
  FHTTP.ContentType    := 'application/json';
  FHTTP.AcceptEncoding := 'UTF-8';
  FHTTP.AllowCookies   := True;

  Params := TStringStream.Create(aJSON, TEncoding.UTF8);
  try
    Response := FHTTP.Post(FHost + 'barns', Params);
//    LogWriter.Write(C_LOG_TYPE[Response.StatusCode = 200], Self,
//                                   'Post',
//                                   'StatusCode: ' + Response.StatusCode.ToString +
//                                   ', StatusText: ' + Response.StatusText);

    JSONObject := TJSONObject.Create;
    try
      JSONValue := JSONObject.ParseJSONValue(aJSON);
      if (not Assigned(JSONValue)) or (not(JSONValue is TJSONObject)) then
        Exit;
      JSONValue := JSONValue.FindValue('tags');

      if Assigned(JSONValue) and (JSONValue is TJSONArray) then
        for var i := 0 to TJSONObject(JSONValue).Count - 1 do
          PostDictionaryTag((JSONValue as TJSONArray).Items[i] as TJSONObject);
    finally
      FreeAndNil(JSONObject);
    end;

  finally
    FreeAndNil(Params);
  end;
end;

procedure TThreadHTTPClient.PostDictionaryTag(const aJSONObject: TJSONObject);
var
  Params   : TStringStream;
  Response : IHTTPResponse;
  Headers  : TNetHeaders;
begin
  SetLength(Headers, 2);
  Headers[0].Name  := sContentType;
  Headers[0].Value := 'application/json';
  Headers[1].Name  := sAcceptEncoding;
  Headers[1].Value := 'UTF-8';

  FHTTP.AllowCookies := True;
  Params := TStringStream.Create(aJSONObject.ToJSON);
  try
    Response := FHTTP.Post(FHost + 'projects/' + TGeneral.CurrentProject.ProjectId + '/tags', Params, nil, Headers);
//    LogWriter.Write(C_LOG_TYPE[Response.StatusCode = 200], Self,
//                                   'PostDictionaryTag',
//                                   'StatusCode: ' + Response.StatusCode.ToString +
//                                   ', StatusText: ' + Response.StatusText);
  finally
    FreeAndNil(Params);
  end;
end;


end.
