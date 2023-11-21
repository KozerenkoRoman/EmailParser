unit Process.Pool;

interface

{$REGION 'Region uses'}
uses
  System.Classes, Winapi.Windows, System.SysUtils, System.Threading, Vcl.Forms, System.Math,
  System.Generics.Collections, Process.Utils, DebugWriter;
{$ENDREGION}

type
  TProcessPool = class(TObject)
  private type
    TProcessItem = record
      Instance    : Pointer;
      CommandLine : string;
    end;
  strict private
    FPool: TThreadPool;
    FCallBack: TProc<Pointer, string>;
    procedure DoExecute(const aItem: TProcessItem);
  public
    constructor Create(const aCapacity: Integer = 0; const aCallBack: TProc<Pointer, string> = nil);
    destructor Destroy; override;

    procedure Execute(const aInstance: Pointer; const aCommandLine: string);
  end;

implementation

{ TProcessPool }

constructor TProcessPool.Create(const aCapacity: Integer = 0; const aCallBack: TProc<Pointer, string> = nil);
begin
  FCallBack := aCallBack;
  FPool := TThreadPool.Create;
  if (aCapacity > 0) then
    FPool.SetMinWorkerThreads(Max(aCapacity, TThread.ProcessorCount))
  else
    FPool.SetMinWorkerThreads(TThread.ProcessorCount);
end;

destructor TProcessPool.Destroy;
begin
  FreeAndNil(FPool);
  inherited;
end;

procedure TProcessPool.Execute(const aInstance: Pointer; const aCommandLine: string);
var
  Item: TProcessItem;
begin
  if not Application.Terminated then
  begin
    Item.Instance    := aInstance;
    Item.CommandLine := aCommandLine;
    TTask.Create(
      procedure
      begin
        TThread.NameThreadForDebugging('TProcessPool: ' + aCommandLine);
        DoExecute(Item);
      end, FPool).Start;
  end;
end;

procedure TProcessPool.DoExecute(const aItem: TProcessItem);
begin
  try
    TProcessRedirector.RunAssync(
      aItem.CommandLine,
      '',                                                                 //Parameters
      TStringStream.Create,                                               //Out stream
      TStringStream.Create,                                               //Error stream
      procedure(aProcessRedirector: TProcessRedirector)                   //Start Event
      begin
        //FProcessStdRedirector := aProcessStdRedirector;
      end,
      procedure(aRes: Cardinal; aOutStream: TStream; aErrStream: TStream) //Done Event
      begin
        if (aRes <> 0) then
        begin
          LogWriter.Write(ddError, Self, ClassName +'.DoExecute Fail' + sLineBreak +
                                         'CommandLine: ' + aItem.CommandLine + sLineBreak +
                                         'Error Message: ' + TStringStream(aErrStream).DataString);
        end
        else
        begin
          LogWriter.Write(ddError, Self, ClassName +'.DoExecute Done' + sLineBreak +
                                         'CommandLine: ' + aItem.CommandLine + sLineBreak +
                                         'Message: ' + TStringStream(aOutStream).DataString);
          if Assigned(FCallBack) then
            FCallBack(aItem.Instance, TStringStream(aOutStream).DataString);
        end;
        aOutStream.Free;
        aErrStream.Free;
      end);
  except
    on E: Exception do
    begin
      LogWriter.Write(ddError, Self, ClassName + '.DoExecute Exception' + sLineBreak +
                                     'CommandLine: ' + aItem.CommandLine + sLineBreak +
                                     'Error Message: ' + E.Message);
      raise;
    end;
  end;

end;

end.
