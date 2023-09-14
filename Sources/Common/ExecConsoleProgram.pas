unit ExecConsoleProgram;

interface

{$REGION 'Region uses'}

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Defaults, System.Generics.Collections,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Winapi.Windows, System.DateUtils, System.IniFiles,
  Vcl.Controls, Winapi.ShellAPI, System.IOUtils, Vcl.Forms, System.AnsiStrings;
{$ENDREGION}

type
  TAnoPipe = record
    Input: THandle;
    Output: THandle;
  end;

  function ShellExecuteAndWait(const ACmdLine: string): Integer;

implementation

function ShellExecuteAndWait(const ACmdLine: string): Integer;
const
  cBufferSize = 2048;
var
  vBuffer: Pointer;
  vStartupInfo: TStartUpInfo;
  vSecurityAttributes: TSecurityAttributes;
  vProcessInfo: TProcessInformation;
  vStdInPipe: TAnoPipe;
  vStdOutPipe: TAnoPipe;
begin
  Result := 0;

  with vSecurityAttributes do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := True;
    lpsecuritydescriptor := nil;
  end;

  // Create anonymous pipe for standard input
  if not CreatePipe(vStdInPipe.Output, vStdInPipe.Input, @vSecurityAttributes, 0) then
    raise Exception.Create('Failed to create pipe for standard input. System error message: ' +
      SysErrorMessage(GetLastError));

  try
    // Create anonymous pipe for standard output (and also for standard error)
    if not CreatePipe(vStdOutPipe.Output, vStdOutPipe.Input, @vSecurityAttributes, 0) then
      raise Exception.Create('Failed to create pipe for standard output. System error message: ' +
        SysErrorMessage(GetLastError));

    try
      GetMem(vBuffer, cBufferSize);
      try
        // initialize the startup info to match our purpose
        FillChar(vStartupInfo, SizeOf(TStartUpInfo), #0);
        vStartupInfo.cb := SizeOf(TStartUpInfo);
        vStartupInfo.wShowWindow := SW_HIDE; // we don't want to show the process
        // assign our pipe for the process' standard input
        vStartupInfo.hStdInput := vStdInPipe.Output;
        // assign our pipe for the process' standard output
        vStartupInfo.hStdOutput := vStdOutPipe.Input;
        vStartupInfo.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;

        if not CreateProcess(nil, PChar(ACmdLine), @vSecurityAttributes, @vSecurityAttributes, True,
          NORMAL_PRIORITY_CLASS, nil, nil, vStartupInfo, vProcessInfo) then
          raise Exception.Create('Failed creating the console process. System error msg: ' +
            SysErrorMessage(GetLastError));

        try
          // wait until the console program terminated
          while WaitForSingleObject(vProcessInfo.hProcess, 50) = WAIT_TIMEOUT do
            Application.ProcessMessages;
        finally
          CloseHandle(vProcessInfo.hProcess);
          CloseHandle(vProcessInfo.hThread);
        end;
      finally
        FreeMem(vBuffer);
      end;
    finally
      CloseHandle(vStdOutPipe.Input);
      CloseHandle(vStdOutPipe.Output);
    end;
  finally
    CloseHandle(vStdInPipe.Input);
    CloseHandle(vStdInPipe.Output);
  end;
end;

end.
