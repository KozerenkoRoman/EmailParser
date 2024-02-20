unit Process.Utils;

interface

{$REGION 'Region uses'}
uses
  System.Classes, Winapi.Windows, System.SysUtils, DebugWriter;
{$ENDREGION}

type
  TProcessRedirector = class(TObject)
  strict private
    FCancel: Boolean;
    FSecurityAttributes: TSecurityAttributes;
    FErrStream: TStream;
    FOutStream: TStream;
    hErrReadPipe: THandle;
    hErrWritePipe: THandle;
    hOutReadPipe: THandle;
    hOutWritePipe: THandle;
    procedure CreateErrPipe;
    procedure CreateOutPipe;
    procedure DoneErrPipe;
    procedure DoneOutPipe;
    procedure InitSecurityAttributes;
    procedure InitStartupInfo(var aStartupInfo: TStartupInfo);
    procedure ReadPipe(const hPipeRead: THandle; const aTargetStream: TStream; const aTimeOut: Cardinal); overload;
    procedure ReadPipe(const hPipeRead: THandle; const aTargetStream: TStream); overload;
    procedure ReadErrPipe;
    procedure ReadOutPipe;
  public
    constructor Create(const aOutStream, aErrStream: TStream);
    destructor Destroy; override;
    function Execute(const aPath, aParameters: string): Cardinal;
    procedure Cancel;

    class function RunWaitCode(const aPath, aParameters: string): Cardinal; overload;
    class function RunWaitCode(const aPath, aParameters: string; const aOutStream, aErrStream: TStream): Cardinal; overload;
    class procedure RunAssync(const aPath, aParameters: string; const aOutStream, aErrStream: TStream; aStartEvent: TProc<TProcessRedirector>; aDoneEvent: TProc<Cardinal, TStream, TStream>);
  end;

implementation

{ TProcessRedirector }

constructor TProcessRedirector.Create(const aOutStream, aErrStream: TStream);
begin
  hOutReadPipe := INVALID_HANDLE_VALUE;
  hOutWritePipe := INVALID_HANDLE_VALUE;
  hErrReadPipe := INVALID_HANDLE_VALUE;
  hErrWritePipe := INVALID_HANDLE_VALUE;
  InitSecurityAttributes;
  FOutStream := aOutStream;
  FErrStream := aErrStream;
  if (FOutStream <> nil) then
    CreateOutPipe;
  if (FErrStream <> nil) then
    CreateErrPipe;
end;

destructor TProcessRedirector.Destroy;
begin
  DoneOutPipe;
  DoneErrPipe;
  inherited;
end;

procedure TProcessRedirector.Cancel;
begin
  FCancel := True;
end;

procedure TProcessRedirector.CreateErrPipe;
var
  hTemp: THandle;
begin
  if not CreatePipe(hErrReadPipe, hErrWritePipe, @FSecurityAttributes, 0) then
    RaiseLastOSError;
  if not DuplicateHandle(GetCurrentProcess(), hErrReadPipe, GetCurrentProcess(), @hTemp, 0, False, DUPLICATE_SAME_ACCESS) Then
    RaiseLastOSError;
  CloseHandle(hErrReadPipe);
  hErrReadPipe := hTemp;
end;

procedure TProcessRedirector.CreateOutPipe;
var
  hTemp: THandle;
begin
  if not CreatePipe(hOutReadPipe, hOutWritePipe, @FSecurityAttributes, 0) then
    RaiseLastOSError;
  if not DuplicateHandle(GetCurrentProcess(), hOutReadPipe, GetCurrentProcess(), @hTemp, 0, False, DUPLICATE_SAME_ACCESS) Then
    RaiseLastOSError;
  CloseHandle(hOutReadPipe);
  hOutReadPipe := hTemp;
end;

procedure TProcessRedirector.DoneErrPipe;
begin
  if hErrReadPipe <> INVALID_HANDLE_VALUE then
    CloseHandle(hErrReadPipe);
  if hErrWritePipe <> INVALID_HANDLE_VALUE then
    CloseHandle(hErrWritePipe);
end;

procedure TProcessRedirector.DoneOutPipe;
begin
  if (hOutReadPipe <> INVALID_HANDLE_VALUE) then
    CloseHandle(hOutReadPipe);
  if (hOutWritePipe <> INVALID_HANDLE_VALUE) then
    CloseHandle(hOutWritePipe);
end;

function TProcessRedirector.Execute(const aPath, aParameters: string): Cardinal;
var
  hProcess: THandle;
  lCmdLine: string;
  PI: TProcessInformation;
  ProcessExitCode: Cardinal;
  SI: TStartupInfo;
  WaitResult: Cardinal;
begin
  lCmdLine := aPath;
  if (Length(aParameters) > 0) then
    lCmdLine := aPath + ' ' + aParameters;
  InitStartupInfo(SI);
  if not CreateProcess(nil, PChar(lCmdLine), nil, nil, True, Normal_Priority_Class, nil, nil, SI, PI) then
    RaiseLastOSError;
  hProcess := PI.hProcess;
  try
    ProcessExitCode := STILL_ACTIVE;
    repeat
      ReadOutPipe;
      ReadErrPipe;
      if not GetExitCodeProcess(hProcess, ProcessExitCode) then
        RaiseLastOSError;
    until (ProcessExitCode <> STILL_ACTIVE) or FCancel;
    if not FCancel then
      WaitResult := WaitForSingleObject(hProcess, INFINITE)
    else
    begin
      WaitResult := 0;
      TerminateProcess(hProcess, 0);
    end;
    if (WaitResult = WAIT_FAILED) then
      RaiseLastOSError;
    Result := ProcessExitCode;
  finally
    CloseHandle(hProcess);
  end;
end;

procedure TProcessRedirector.InitSecurityAttributes;
begin
  FSecurityAttributes.nLength := SizeOf(FSecurityAttributes);
  FSecurityAttributes.bInheritHandle := True;
  FSecurityAttributes.lpSecurityDescriptor := nil;
end;

procedure TProcessRedirector.InitStartupInfo(var aStartupInfo: TStartupInfo);
begin
  FillChar(aStartupInfo, SizeOf(aStartupInfo), 0);
  aStartupInfo.cb := SizeOf(aStartupInfo);
  aStartupInfo.dwFlags := aStartupInfo.dwFlags or STARTF_USESTDHANDLES or STARTF_FORCEOFFFEEDBACK or STARTF_USESHOWWINDOW;
  aStartupInfo.wShowWindow := SW_HIDE;
  if (hOutWritePipe <> INVALID_HANDLE_VALUE) then
    aStartupInfo.hStdOutput := hOutWritePipe;
  if (hErrWritePipe <> INVALID_HANDLE_VALUE) then
    aStartupInfo.hStdError := hErrWritePipe;
end;

procedure TProcessRedirector.ReadPipe(const hPipeRead: THandle; const aTargetStream: TStream; const aTimeOut: Cardinal);
var
  BufferSize: Cardinal;
  BytesAvailable: Cardinal;
  BytesRead: Cardinal;
  lStart: Cardinal;
  pBuffer: Pointer;
  ReadResult: Boolean;
begin
  Assert(hPipeRead <> INVALID_HANDLE_VALUE);
  Assert(aTargetStream <> nil);
  Sleep(50); // Wait for the process to complete
  lStart := GetTickCount;
  repeat
    ReadResult := PeekNamedPipe(hPipeRead, nil, 0, nil, @BytesAvailable, nil);
    if ReadResult and (BytesAvailable > 0) then
    begin
      BufferSize := BytesAvailable;
      GetMem(pBuffer, BufferSize);
      try
        FillChar(pBuffer^, BufferSize, 0);
        ReadResult := ReadFile(hPipeRead, pBuffer^, BufferSize, BytesRead, nil);
        aTargetStream.Write(pBuffer^, BytesRead);
      finally
        FreeMem(pBuffer);
      end;
    end;
    Sleep(Round(aTimeOut / 10));
  until (not ReadResult) or (GetTickCount > (lStart + aTimeOut));
end;

procedure TProcessRedirector.ReadPipe(const hPipeRead: THandle; const aTargetStream: TStream);
var
  ReadResult: Boolean;
  pBuffer: Pointer;
  BufferSize, BytesRead, BytesAvailable: Cardinal;
begin
  Assert(hPipeRead <> INVALID_HANDLE_VALUE);
  Assert(aTargetStream <> nil);
  repeat
    ReadResult := PeekNamedPipe(hPipeRead, nil, 0, nil, @BytesAvailable, nil);
    if ReadResult and (BytesAvailable > 0) then
    begin
      BufferSize := BytesAvailable;
      GetMem(pBuffer, BufferSize);
      try
        FillChar(pBuffer^, BufferSize, 0);
        ReadResult := ReadFile(hPipeRead, pBuffer^, BufferSize, BytesRead, nil);
        aTargetStream.Write(pBuffer^, BytesRead);
      finally
        FreeMem(pBuffer);
      end;
    end;
  until (not ReadResult);
end;

procedure TProcessRedirector.ReadOutPipe;
begin
  if Assigned(FOutStream) and (hOutReadPipe <> INVALID_HANDLE_VALUE) then
    ReadPipe(hOutReadPipe, FOutStream, 1000);
end;

procedure TProcessRedirector.ReadErrPipe;
begin
  if Assigned(FErrStream) and (hErrReadPipe <> INVALID_HANDLE_VALUE) then
    ReadPipe(hErrReadPipe, FErrStream, 1000);
end;

class function TProcessRedirector.RunWaitCode(const aPath, aParameters: string; const aOutStream, aErrStream: TStream): Cardinal;
var
  lProcessStdRedirector: TProcessRedirector;
begin
  lProcessStdRedirector := TProcessRedirector.Create(aOutStream, aErrStream);
  try
    Result := lProcessStdRedirector.Execute(aPath, aParameters);
  finally
    lProcessStdRedirector.Free;
  end;
end;

class function TProcessRedirector.RunWaitCode(const aPath, aParameters: string): Cardinal;
begin
  Result := RunWaitCode(aPath, aParameters, nil, nil);
end;

class procedure TProcessRedirector.RunAssync(const aPath, aParameters: string; const aOutStream, aErrStream: TStream; aStartEvent: TProc<TProcessRedirector>; aDoneEvent: TProc<Cardinal, TStream, TStream>);
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      ProcessRedirector: TProcessRedirector;
      Res: Cardinal;
    begin
      ProcessRedirector := TProcessRedirector.Create(aOutStream, aErrStream);
      if Assigned(aStartEvent) then
        TThread.Synchronize(nil,
          procedure
          begin
            aStartEvent(ProcessRedirector);
          end);
      try
        Res := ProcessRedirector.Execute(aPath, aParameters);
      finally
        if Assigned(aDoneEvent) then
          TThread.Synchronize(nil,
            procedure
            begin
              aDoneEvent(Res, aOutStream, aErrStream);
            end);
        ProcessRedirector.Free;
      end;
    end).Start;
end;

end.
