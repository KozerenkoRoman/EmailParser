unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Common.Types, Translate.Lang, System.IniFiles, Global.Types,
  System.Generics.Defaults, System.Types, System.RegularExpressions, System.Threading, MessageDialog;
{$ENDREGION}

type
  TAbortEvent = function: Boolean of object;
  TEndEvent = procedure of object;
  TProgressEvent = procedure of object;
  TStartProgressEvent = procedure(const aMaxPosition: Integer) of object;
  TCompletedItem = procedure(const aResultData: TResultData) of object;

  TPerformer = class
  private
    FRegExpList : TArray<TRegExpData>;
    FPathList   : TArray<TParamPath>;
    procedure ParseFile(const aFileName: TFileName);
  public
    OnStartProgressEvent : TStartProgressEvent;
    OnProgressEvent      : TProgressEvent;
    OnEndEvent           : TEndEvent;
    OnCompletedItem      : TCompletedItem;
    procedure Start;
  end;

implementation

{ TPerformer }

procedure TPerformer.Start;
var
  FileList: TStringDynArray;
  FileExt: string;
begin
  LogWriter.Write(ddEnterMethod, 'TPerformer.Start');
  if not Assigned(OnCompletedItem) then
    Exit;

  FRegExpList := TGeneral.GetRegExpParametersList;
  FPathList   := TGeneral.GetPathList;
  FileList    := [];
  FileExt     := TGeneral.XMLFile.ReadString('Extensions', C_SECTION_MAIN, '*.eml');
  for var Dir in FPathList do
    if Dir.WithSubdir then
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FileExt, TSearchOption.soAllDirectories))
    else
      FileList := Concat(FileList, TDirectory.GetFiles(Dir.Path, FileExt, TSearchOption.soTopDirectoryOnly));

  if Assigned(OnStartProgressEvent) then
    OnStartProgressEvent(Length(FileList));

  LogWriter.Write(ddText, 'Length FileList - ' + Length(FileList).ToString);
  try
    for var FileName in FileList do
      ParseFile(FileName);

  except
    on E: Exception do
    begin
      LogWriter.Write(ddError, E.Message);
      if Assigned(OnEndEvent) then
        OnEndEvent;
    end;
  end;

  if Assigned(OnEndEvent) then
    TThread.Queue(nil,
      procedure
      begin
        LogWriter.Write(ddExitMethod, 'TPerformer.Start');
      end);
end;

procedure TPerformer.ParseFile(const aFileName: TFileName);
var
  Data: TResultData;
begin
  if (not Assigned(OnCompletedItem)) or (Length(FRegExpList) = 0) then
    Exit;

  Data.ShortName := TPath.GetFileNameWithoutExtension(aFileName);
  Data.FileName  := aFileName;

  Data.MessageId := aFileName;
  Data.Subject   := aFileName;
  Data.Attach    := 0;
  Data.TimeStamp := Now;

  if Assigned(OnProgressEvent) then
    TThread.Queue(nil,
      procedure
      begin
        OnProgressEvent;
      end);

  TThread.Queue(nil,
    procedure
    begin
      OnCompletedItem(Data);
    end);
end;

end.
