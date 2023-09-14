﻿unit MainForm;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IniFiles, System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading,
  Html.Lib, Vcl.WinXCtrls, Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage,
  Vcl.CategoryButtons, Frame.Custom, Frame.RegExp, Frame.ResultView, Frame.Pathes, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Vcl.ToolWin, Vcl.AppEvnts, SplashScreen, Frame.Settings, Global.Types, Vcl.Samples.Gauges,
  Publishers.Interfaces, Publishers, CommonForms, Frame.Source, DaModule, Frame.Sorter, Frame.DuplicateFiles,
  Files.Utils;
{$ENDREGION}

type
  TfrmMain = class(TCommonForm, IProgress, ITranslate)
    aEditCommonParameters   : TAction;
    aEditRegExpParameters   : TAction;
    alSettings              : TActionList;
    aPathsFindFiles         : TAction;
    ApplicationEvents       : TApplicationEvents;
    aSearch                 : TAction;
    aSearchDuplicateFiles   : TAction;
    aToggleSplitPanel       : TAction;
    catMenuItems            : TCategoryButtons;
    crdCommonParams         : TCard;
    crdPathsToFindScripts   : TCard;
    crdRegExpParameters     : TCard;
    crdResultView           : TCard;
    crdSearchDuplicateFiles : TCard;
    frameDuplicateFiles     : TframeDuplicateFiles;
    framePathes             : TframePathes;
    frameRegExp             : TframeRegExp;
    frameResultView         : TframeResultView;
    frameSettings           : TframeSettings;
    frameSorter             : TframeSorter;
    gbPathes                : TGroupBox;
    gbSorter                : TGroupBox;
    imgMenu                 : TImage;
    lblTitle                : TLabel;
    pnlCard                 : TCardPanel;
    pnlLeft                 : TPanel;
    pnlSrchBox              : TPanel;
    pnlTop                  : TPanel;
    sbMain                  : TStatusBar;
    splPath                 : TSplitter;
    splView                 : TSplitView;
    srchBox                 : TSearchBox;
    aOpenLogFile: TAction;
    procedure aEditCommonParametersExecute(Sender: TObject);
    procedure aEditRegExpParametersExecute(Sender: TObject);
    procedure aPathsFindFilesExecute(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure aSearchDuplicateFilesExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aToggleSplitPanelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure srchBoxInvokeSearch(Sender: TObject);
    procedure aOpenLogFileExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'MainForm';
  private
    FProgressBar: TGauge;
    procedure CreateProgressBar;

    //ITranslate
    procedure ITranslate.LanguageChange = Translate;

    //IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachment: PAttachment);
  protected
    function GetIdentityName: string; override;
  public
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  inherited;
  CreateProgressBar;
  TPublishers.ProgressPublisher.Subscribe(Self);
  TPublishers.TranslatePublisher.Subscribe(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FProgressBar);
  Deinitialize;
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.TranslatePublisher.Unsubscribe(Self);
end;

procedure TfrmMain.Initialize;
begin
  inherited;
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  DaMod.Initialize;
  frameRegExp.Initialize;
  framePathes.Initialize;
  frameResultView.Initialize;
  frameSorter.Initialize;
  frameSettings.Initialize;
  frameDuplicateFiles.Initialize;

  pnlTop.Color                := C_TOP_COLOR;
  catMenuItems.HotButtonColor := C_TOP_COLOR;
  catMenuItems.Height         := 20;
  Translate;
end;

procedure TfrmMain.Deinitialize;
begin
  inherited;
  frameRegExp.Deinitialize;
  framePathes.Deinitialize;
  frameSorter.Deinitialize;
  frameResultView.Deinitialize;
  frameSettings.Deinitialize;
  frameDuplicateFiles.Deinitialize;
  DaMod.Deinitialize;
  LogWriter.Active := False;
end;

procedure TfrmMain.Translate;
begin
  inherited;
  aEditCommonParameters.Caption := TLang.Lang.Translate('EditCommonParameters');
  aEditRegExpParameters.Caption := TLang.Lang.Translate('EditRegExpParameters');
  aOpenLogFile.Caption          := TLang.Lang.Translate('OpenLogFile');
  aPathsFindFiles.Caption       := TLang.Lang.Translate('PathsToFindSaveFiles');
  aSearch.Caption               := TLang.Lang.Translate('Search');
  aSearchDuplicateFiles.Caption := TLang.Lang.Translate('SearchDuplicateFiles');

  crdCommonParams.Caption         := TLang.Lang.Translate('EditCommonParameters');
  crdPathsToFindScripts.Caption   := TLang.Lang.Translate('PathsToFindFiles');
  crdRegExpParameters.Caption     := TLang.Lang.Translate('EditRegExpParameters');
  crdResultView.Caption           := TLang.Lang.Translate('Search');
  crdSearchDuplicateFiles.Caption := TLang.Lang.Translate('SearchDuplicateFiles');
  gbPathes.Caption                := TLang.Lang.Translate('PathsToFindFiles');
  gbSorter.Caption                := TLang.Lang.Translate('PathsToSaveFiles');

  catMenuItems.Categories[0].Caption := TLang.Lang.Translate('Main');
  catMenuItems.Categories[1].Caption := TLang.Lang.Translate('Utilities');

  lblTitle.Caption := pnlCard.ActiveCard.Caption;
end;

function TfrmMain.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  inherited;
  if not Application.Terminated then
    if Assigned(FProgressBar) then
      FProgressBar.Width := sbMain.Width - 20;
end;

procedure TfrmMain.aToggleSplitPanelExecute(Sender: TObject);
begin
  inherited;
  if splView.Opened then
    splView.Close
  else
    splView.Open;
end;

procedure TfrmMain.CreateProgressBar;
begin
  FProgressBar := TGauge.Create(nil);
  FProgressBar.Parent := sbMain;
  FProgressBar.ForeColor   := C_TOP_COLOR;
  FProgressBar.BackColor   := clBtnFace;
  FProgressBar.BorderStyle := bsNone;
  FProgressBar.Progress    := 100;
  FProgressBar.Align       := alLeft;
  FProgressBar.ShowText    := False;
  FProgressBar.Width       := sbMain.Width - 10;
  FProgressBar.MinValue    := 0;
  FProgressBar.Visible     := False;
end;

procedure TfrmMain.aEditCommonParametersExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdCommonParams;
end;

procedure TfrmMain.aEditRegExpParametersExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdRegExpParameters;
end;

procedure TfrmMain.aOpenLogFileExecute(Sender: TObject);
begin
  inherited;
  if FileExists(LogWriter.LogFileName) then
    TFileUtils.ShellOpen(LogWriter.LogFileName);
end;

procedure TfrmMain.aPathsFindFilesExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdPathsToFindScripts;
end;

procedure TfrmMain.aSearchDuplicateFilesExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdSearchDuplicateFiles;
end;

procedure TfrmMain.ApplicationEventsException(Sender: TObject; E: Exception);
var
  StackTrace: string;
begin
  TfrmSplashScreen.HideSplash;
  StackTrace := E.StackTrace;
  LogWriter.Write(ddError, E.Message + sLineBreak + StackTrace);
  if not Application.Terminated then
    TMessageDialog.ShowError(E.Message, StackTrace);
end;

procedure TfrmMain.aSearchExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdResultView;
end;

procedure TfrmMain.srchBoxInvokeSearch(Sender: TObject);
begin
  inherited;
//  if pnlCard.ActiveCard = crdPathsToFindScripts then
//    framePathes.SearchText(srchBox.Text)
//  else
//    frameRegExpParameters.SearchText(srchBox.Text);
end;

procedure TfrmMain.ClearTree;
begin
  //nothing
end;

procedure TfrmMain.CompletedAttach(const aAttachment: PAttachment);
begin
  //nothing
end;

procedure TfrmMain.CompletedItem(const aResultData: PResultData);
begin
  //nothing
end;

procedure TfrmMain.EndProgress;
begin
  FProgressBar.Progress := 0;
  FProgressBar.Visible := False;
end;

procedure TfrmMain.Progress;
begin
  if (FProgressBar.Progress >= FProgressBar.MaxValue) then
    FProgressBar.MaxValue := FProgressBar.MaxValue + 1;
  FProgressBar.Progress := FProgressBar.Progress + 1;
  FProgressBar.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmMain.StartProgress(const aMaxPosition: Integer);
begin
  FProgressBar.MaxValue := aMaxPosition;
  FProgressBar.Progress := 0;
  FProgressBar.Visible := True;
end;

end.