﻿unit DebugWriter;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.Classes, Vcl.Forms, System.SysUtils, System.Variants, System.IOUtils, Vcl.Graphics,
  System.DateUtils, System.Threading, Utils.VerInfo, Utils.LocalInformation, Html.Lib, Html.Consts, XmlFiles,
  System.Types, System.Generics.Collections, Global.Resources;
{$ENDREGION}

type
  TLogDetailType = (ddEnterMethod, ddExitMethod, ddError, ddText, ddWarning);
  TLogDetailTypeHelper = record helper for TLogDetailType
  private
    const LogDetailTypesString: array[TLogDetailType] of string = ('Enter Method', 'Exit Method', 'Error', 'Text', 'Warning');
  public
    function ToString: string;
  end;

  TFileWriter = class(TThread)
  private const
    C_FOLDER_LOG : string = 'log\';
    C_TAG_LINK   : string = '<br><a href="%s">Next log file</a>';
  private
    FCountFiles   : Integer;
    FBaseFileName : string;
    FFileName     : TFileName;
    FMaxSize      : Integer;
    FQueue        : TThreadedQueue<string>;
    function GetSize: Int64;
    function GetOpenHtmlText: string;
    function GetCloseHtmlText(const aOlfFileName: string): string;
    procedure SetCountFiles(const Value: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create;
    destructor Destroy; override;
    class function GetLogFolder: string;

    property Size       : Int64                  read GetSize;
    property LogQueue   : TThreadedQueue<string> read FQueue;
    property MaxSize    : Integer                read FMaxSize    write FMaxSize;
    property FileName   : TFileName              read FFileName   write FFileName;
    property CountFiles : Integer                read FCountFiles write SetCountFiles;
  end;

  TLogWriter = class
  private const
    C_CHAR_ENTER     : Char = #13;
    C_CHAR_LINE_FEED : Char = #10;
  private
    FCountOfDays     : Integer;
    FFileWriter      : TFileWriter;
    FIsExistHtmlOpen : Boolean;
    FLineCount       : Integer;
    FMaxSize         : Integer;
    function GetActive: Boolean;
    function GetLineCount: Integer;
    function GetLogFileName: TFileName;
    procedure DeleteOldFiles;
    procedure Finish;
    procedure RestoreStartParams;
    procedure SetActive(const aValue: Boolean);
    procedure Start;
    procedure WriteFileInfo;
    procedure WriteHtm(const aDetailType: TLogDetailType; aUnit, aClassName, aMethod, aInfo: string); inline;
    procedure WriteText(const aInfo: string);

    property LineCount: Integer read GetLineCount write FLineCount;
  private const
    C_TABLE_TD_TAG     = '<TD class="%s"></TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD><TD>%s</TD></TR>';
    C_TABLE_ERROR_TAG  = '<TR class="err">' + C_TABLE_TD_TAG;
    C_TABLE_METHOD_TAG = '<TR class="met">' + C_TABLE_TD_TAG;
    C_TABLE_OBJECT_TAG = '<TR class="obj">' + C_TABLE_TD_TAG;
    C_TABLE_TEXT_TAG   = '<TR class="txt">' + C_TABLE_TD_TAG;
    C_TABLE_WARN_TAG   = '<TR class="warn">' + C_TABLE_TD_TAG;
  public const
    C_IMG_ENTER_HTM = 'img-enter';
    C_IMG_ERROR_HTM = 'img-err';
    C_IMG_EXIT_HTM  = 'img-exit';
    C_DATE_FORMAT   = 'DD.MM.YYYY hh:mm:ss.zzz';

    C_CFG_COUNT_OF_DAYS = 'CountOfDays';
    C_CFG_KEY_IS_START  = 'IsStartDebug';
    C_CFG_KEY_MAX_SIZE  = 'MaxSizeOfLogFile';
    C_CFG_SECTION_DEBUG = 'Debug';
  public
    constructor Create;
    destructor Destroy; override;

    procedure Write(const aDetailType: TLogDetailType; const aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aMethod, aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aMethod, aUnit, aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aObject: TObject; const aInfo: string); overload;
    procedure Write(const aDetailType: TLogDetailType; const aObject: TObject; const aMethod, aInfo: string); overload;

    property LogFileName : TFileName read GetLogFileName;
    property Active      : Boolean   read GetActive    write SetActive;
    property CountOfDays : Integer   read FCountOfDays write FCountOfDays default 30;    //Number of days during which logs are stored
    property MaxSize     : Integer   read FMaxSize     write FMaxSize     default 2;     //Maximum log file size(MB). When <0 do not control
  end;

var
  LogWriter : TLogWriter;

implementation

{ TLogWriter }

constructor TLogWriter.Create;
begin
  inherited;
  FIsExistHtmlOpen  := False;
  FCountOfDays      := 30;
  RestoreStartParams;
  Start;
  if Active then
  begin
    WriteFileInfo;
    DeleteOldFiles;
  end;
end;

destructor TLogWriter.Destroy;
begin
  FFileWriter.Terminate;
  if Assigned(FFileWriter) then
    FreeAndNil(FFileWriter);
  inherited;
end;

procedure TLogWriter.DeleteOldFiles;
begin
  TTask.Create(
    procedure()
    begin
      TThread.NameThreadForDebugging('TLogWriter.DeleteOldFiles');
      for var ItemName in TDirectory.GetFiles(TFileWriter.GetLogFolder, '*.html', TSearchOption.soAllDirectories) do
      begin
        if (DaysBetween(Now, TFile.GetCreationTime(ItemName)) >= CountOfDays) then
          try
            TFile.Delete(ItemName);
          except
          end;
      end;
    end).Start;
end;

procedure TLogWriter.WriteFileInfo;
var
  loVersionInfo : TVersionInfo;
  sHostName     : string;
  sIP           : string;
  sText         : string;
  sModuleName   : string;
begin
  sText       := '';
  sModuleName := Application.ExeName;
  TLocalInformationDialog.GetLocalIPAddressName(sIP, sHostName);
  loVersionInfo := TVersionInfo.Create(sModuleName);
  try
    sText := Concat(C_HTML_LINE + '<pre>',
                    THtmlLib.GetBoldText('Module              : '), sModuleName,                                                C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module version      : '), loVersionInfo.FileVersion, '.', loVersionInfo.FileBuild,    C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module architecture : '), loVersionInfo.Architecture,                                 C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module date         : '), DateToStr(loVersionInfo.ModuleDate),                        C_HTML_BREAK,
                    THtmlLib.GetBoldText('Module size         : '), FormatFloat('### ### ### bytes', loVersionInfo.ModuleSize), C_HTML_BREAK,
                    THtmlLib.GetBoldText('Local IP-address    : '), sIP, ' (', sHostName, ')',                                  C_HTML_BREAK,
                    THtmlLib.GetBoldText('Windows version     : '), TLocalInformationDialog.GetWindowsVersion,                  C_HTML_BREAK,
                    THtmlLib.GetBoldText('Windows user        : '), TLocalInformationDialog.GetUserFromWindows,                 C_HTML_BREAK,
                    THtmlLib.GetBoldText('Compiler version    : '), CompilerVersion.ToString,                                   C_HTML_BREAK,
                    '</pre>' + C_HTML_LINE);
    WriteHtm(ddText, C_HTML_NBSP, C_HTML_NBSP, C_HTML_NBSP, sText);
  finally
    FreeAndNil(loVersionInfo);
  end;
end;

procedure TLogWriter.RestoreStartParams;
var
  loXmlFile : TXmlFile;
begin
  loXmlFile := TXmlFile.Create(GetEnvironmentVariable('USERPROFILE') + '\' + C_XML_PARAMS_FILE);
  try
    loXmlFile.UsedAttributes := [uaCodeType, uaValue, uaComment];
    FMaxSize     := loXmlFile.ReadInteger(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE, 2) * 1024 * 1024;
    FCountOfDays := loXmlFile.ReadInteger(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS, 30);
    if not loXmlFile.ValueExists(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE) then
      loXmlFile.WriteInt64(C_CFG_SECTION_DEBUG, C_CFG_KEY_MAX_SIZE, FMaxSize, 'Max Size Of Log File (Mb)');
    if not loXmlFile.ValueExists(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS) then
      loXmlFile.WriteInteger(C_CFG_SECTION_DEBUG, C_CFG_COUNT_OF_DAYS, FCountOfDays, 'Number of days during which logs are stored');
  finally
    FreeAndNil(loXmlFile);
  end;
end;

function TLogWriter.GetActive: Boolean;
begin
  if Assigned(FFileWriter) then
    Result := FFileWriter.Started
  else
    Result := False;
end;

procedure TLogWriter.WriteText(const aInfo: string);
begin
  if Active then
    FFileWriter.LogQueue.PushItem(aInfo);
end;

procedure TLogWriter.Start;
begin
  if not Assigned(FFileWriter) then
  begin
    FFileWriter := TFileWriter.Create;
    FFileWriter.MaxSize := MaxSize;
    FFileWriter.Start;
    Sleep(10);
  end;
end;

procedure TLogWriter.Finish;
var
  sText : string;
begin
  if Assigned(FFileWriter) and FFileWriter.Started then
  begin
    sText := Concat(C_HTML_TABLE_CLOSE,
                    THtmlLib.GetColorTag(THtmlLib.GetBoldText('Log session finished'), clNavy),
                    C_HTML_CLOSE);
    WriteText(sText);
  end;
end;

procedure TLogWriter.SetActive(const aValue: Boolean);
begin
  if aValue then
    Start
  else
    Finish;
end;

function TLogWriter.GetLineCount: Integer;
begin
  Inc(FLineCount);
  if (FLineCount >= 1000000) then
   FLineCount := 1;
  Result := FLineCount;
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, C_HTML_NBSP, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aMethod, aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aMethod, aUnit, aInfo: string);
begin
  WriteHtm(aDetailType, C_HTML_NBSP, C_HTML_NBSP, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aObject: TObject; const aMethod, aInfo: string);
var
  ClassName: string;
begin
  if Assigned(aObject) then
    ClassName := aObject.ClassName
  else
    ClassName := C_HTML_NBSP;
  WriteHtm(aDetailType, C_HTML_NBSP, ClassName, aMethod, aInfo);
end;

procedure TLogWriter.Write(const aDetailType: TLogDetailType; const aObject: TObject; const aInfo: string);
var
  ClassName: string;
begin
  if Assigned(aObject) then
    ClassName := aObject.ClassName
  else
    ClassName := C_HTML_NBSP;
  WriteHtm(aDetailType, C_HTML_NBSP, ClassName, C_HTML_NBSP, aInfo);
end;

procedure TLogWriter.WriteHtm(const aDetailType: TLogDetailType; aUnit, aClassName, aMethod, aInfo: string);
begin
  if Active then
  begin
    if aUnit.IsEmpty then
      aUnit := C_HTML_NBSP;
    if aClassName.IsEmpty then
      aClassName := C_HTML_NBSP;
    if aMethod.IsEmpty then
      aMethod := C_HTML_NBSP;
    if aInfo.IsEmpty then
      aInfo := C_HTML_NBSP;

    if (aDetailType = ddError) then
      aInfo := aInfo.Replace('\n', C_HTML_BREAK);

    aInfo := aInfo.Replace(sLineBreak, C_HTML_BREAK).Replace(C_CHAR_ENTER, C_HTML_BREAK).Replace(C_CHAR_LINE_FEED, C_HTML_BREAK);
    case aDetailType of
      ddEnterMethod:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_METHOD_TAG, [C_IMG_ENTER_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddExitMethod:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_METHOD_TAG, [C_IMG_EXIT_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddError:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_ERROR_TAG, [C_IMG_ERROR_HTM, Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddText:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_TEXT_TAG, ['', Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
      ddWarning:
        FFileWriter.LogQueue.PushItem(Format(C_TABLE_WARN_TAG, ['', Format('%.6u', [LineCount]), FormatDateTime(C_DATE_FORMAT, Now), aUnit, aClassName, aMethod, aInfo]));
    end;
  end;
end;

function TLogWriter.GetLogFileName: TFileName;
begin
  if Assigned(FFileWriter) then
    Result := FFileWriter.FileName;
end;

{ TFileWriter }

constructor TFileWriter.Create;
begin
  inherited Create(True);
  Priority      := tpLowest;
  FQueue        := TThreadedQueue<string>.Create(10000);
  FBaseFileName := TPath.Combine(GetLogFolder,
                                 (TPath.GetFileNameWithoutExtension(Application.ExeName) +
                                 FormatDateTime('_yyyy.mm.dd hh.nn.ss', Now) +
                                 '_part_%d.html').ToLower);
  CountFiles    := 1;
end;

destructor TFileWriter.Destroy;
begin
  FQueue.DoShutDown;
  Sleep(10);
  FreeAndNil(FQueue);
  inherited;
end;

procedure TFileWriter.Execute;
var
  LogText    : string;
  WaitResult : TWaitResult;
begin
  inherited;
  TThread.NameThreadForDebugging('TFileWriter');
  TFile.WriteAllBytes(FileName, TEncoding.UTF8.GetPreamble);
  TFile.AppendAllText(FileName, GetOpenHtmlText);
  try
    while not Terminated do
    begin
      WaitResult := FQueue.PopItem(LogText);
      if (WaitResult = TWaitResult.wrSignaled) then
        if not(LogText.IsEmpty) then
        begin
          TFile.AppendAllText(FileName, LogText);
          if (MaxSize > 0) and (Size >= MaxSize) then
          begin
            TFile.AppendAllText(FileName, GetCloseHtmlText(Format(FBaseFileName, [CountFiles + 1])));
            CountFiles := CountFiles + 1;
            TFile.AppendAllText(FileName, GetOpenHtmlText);
          end;
      end;
    end;
  except

  end;
end;

class function TFileWriter.GetLogFolder: string;
begin
  Result := TPath.Combine(TPath.GetDirectoryName(Application.ExeName), C_FOLDER_LOG);
  if (ExtractFileDrive(Result) <> '') and (not TDirectory.Exists(Result)) then
    try
      ForceDirectories(Result);
    except
      raise Exception.Create(Format('Do not create folder [%s].', [Result]));
    end;
end;

function TFileWriter.GetOpenHtmlText: string;
begin
  Result := Concat(C_HTML_OPEN,
                   C_HTML_HEAD_OPEN,
                   C_STYLE,
                   C_HTML_HEAD_CLOSE,
                   THtmlLib.GetTableTag(VarArrayOf([C_HTML_NBSP,
                                                     'Line &#8470;',
                                                     'Time',
                                                     'Unit name',
                                                     'Class name',
                                                     'Method name',
                                                     'Description'])));
end;

function TFileWriter.GetCloseHtmlText(const aOlfFileName: string): string;
begin
  Result := Concat(C_HTML_TABLE_CLOSE, Format(C_TAG_LINK, [aOlfFileName]), C_HTML_CLOSE);
end;

function TFileWriter.GetSize: Int64;
begin
  Result := TFile.GetSize(FileName);
end;

procedure TFileWriter.SetCountFiles(const Value: Integer);
begin
  FCountFiles := Value;
  FFileName := Format(FBaseFileName, [FCountFiles]);
end;

{ TLogDetailTypeHelper }

function TLogDetailTypeHelper.ToString: string;
begin
  Result := LogDetailTypesString[Self];
end;


initialization
  if not Assigned(LogWriter) and not System.IsLibrary then
    LogWriter := TLogWriter.Create;

finalization
//  if Assigned(LogWriter) then
//    FreeAndNil(LogWriter);

end.