unit MainForm;

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
  Files.Utils, Vcl.CheckLst, ArrayHelper, System.Types, Frame.MatchesFilter, Frame.BruteForce;
{$ENDREGION}

type
  TfrmMain = class(TCommonForm, IProgress, IConfig)
    alSettings              : TActionList;
    ApplicationEvents       : TApplicationEvents;
    aToggleSplitPanel       : TAction;
    catMenuItems            : TCategoryButtons;
    crdBruteForce           : TCard;
    crdCommonParams         : TCard;
    crdPathsToFindScripts   : TCard;
    crdRegExpParameters     : TCard;
    crdResultView           : TCard;
    crdSearchDuplicateFiles : TCard;
    frameBruteForce         : TframeBruteForce;
    frameDuplicateFiles     : TframeDuplicateFiles;
    frameMatchesFilter      : TframeMatchesFilter;
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
    pnlExtendedFilter       : TGroupBox;
    pnlLeft                 : TPanel;
    pnlSrchBox              : TPanel;
    pnlTop                  : TPanel;
    sbMain                  : TStatusBar;
    splExtendedFilter       : TSplitter;
    splPath                 : TSplitter;
    splView                 : TSplitView;
    srchBox                 : TSearchBox;
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure aToggleSplitPanelExecute(Sender: TObject);
    procedure catMenuItemsSelectedItemChange(Sender: TObject; const Button: TButtonItem);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure splViewClosed(Sender: TObject);
    procedure splViewOpened(Sender: TObject);
    procedure srchBoxInvokeSearch(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'MainForm';
  private
    FProgressBar: TGauge;
    procedure CreateProgressBar;

    //IConfig
    procedure IConfig.UpdateLanguage = Translate;
    procedure UpdateRegExp;
    procedure UpdateFilter(const aOperation: TFilterOperation);

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
  TPublishers.ConfigPublisher.Subscribe(Self);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FProgressBar);
  Deinitialize;
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(Self);
end;

procedure TfrmMain.Initialize;
begin
  inherited;
  Randomize;
  TLang.Lang.Language      := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  pnlExtendedFilter.Height := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'ExtendedFilterHeight', 250);
  DaMod.Initialize;
  frameRegExp.Initialize;
  framePathes.Initialize;
  frameResultView.Initialize;
  frameSorter.Initialize;
  frameSettings.Initialize;
  frameDuplicateFiles.Initialize;
  frameMatchesFilter.Initialize;
  frameBruteForce.Initialize;

  pnlTop.Color                := C_TOP_COLOR;
  catMenuItems.HotButtonColor := C_TOP_COLOR;
  catMenuItems.Height         := 20;
  Translate;
end;

procedure TfrmMain.Deinitialize;
begin
  frameRegExp.Deinitialize;
  framePathes.Deinitialize;
  frameSorter.Deinitialize;
  frameResultView.Deinitialize;
  frameSettings.Deinitialize;
  frameDuplicateFiles.Deinitialize;
  frameMatchesFilter.Deinitialize;
  frameBruteForce.Deinitialize;
  DaMod.Deinitialize;
  LogWriter.Active := False;
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'ExtendedFilterHeight', pnlExtendedFilter.Height);
  TGeneral.XMLParams.Save;
  inherited;
end;

procedure TfrmMain.Translate;
begin
  inherited;
  catMenuItems.Categories[0].Caption := TLang.Lang.Translate('Main');
  catMenuItems.Categories[1].Caption := TLang.Lang.Translate('Utilities');
  catMenuItems.Categories[0].Items[0].Caption := TLang.Lang.Translate('PathsToFindSaveFiles');
  catMenuItems.Categories[0].Items[1].Caption := TLang.Lang.Translate('EditRegExpParameters');
  catMenuItems.Categories[0].Items[2].Caption := TLang.Lang.Translate('EditCommonParameters');
  catMenuItems.Categories[0].Items[3].Caption := TLang.Lang.Translate('Search');
  catMenuItems.Categories[1].Items[0].Caption := TLang.Lang.Translate('SearchDuplicateFiles');
  catMenuItems.Categories[1].Items[1].Caption := TLang.Lang.Translate('BruteForce');
  catMenuItems.Categories[1].Items[2].Caption := TLang.Lang.Translate('OpenLogFile');

  crdBruteForce.Caption           := TLang.Lang.Translate('BruteForce');
  crdCommonParams.Caption         := TLang.Lang.Translate('EditCommonParameters');
  crdPathsToFindScripts.Caption   := TLang.Lang.Translate('PathsToFindFiles');
  crdRegExpParameters.Caption     := TLang.Lang.Translate('EditRegExpParameters');
  crdResultView.Caption           := TLang.Lang.Translate('Search');
  crdSearchDuplicateFiles.Caption := TLang.Lang.Translate('SearchDuplicateFiles');
  gbPathes.Caption                := TLang.Lang.Translate('PathsToFindFiles');
  gbSorter.Caption                := TLang.Lang.Translate('PathsToSaveFiles');
  pnlExtendedFilter.Caption       := TLang.Lang.Translate('ExtendedFilter');
  lblTitle.Caption                := pnlCard.ActiveCard.Caption;
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

procedure TfrmMain.CreateProgressBar;
begin
  FProgressBar := TGauge.Create(nil);
  FProgressBar.Parent      := sbMain;
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

procedure TfrmMain.catMenuItemsSelectedItemChange(Sender: TObject; const Button: TButtonItem);
begin
  inherited;
  if (Button.Category.Id = 0) then
    case Button.Id of
      0: pnlCard.ActiveCard := crdPathsToFindScripts;
      1: pnlCard.ActiveCard := crdRegExpParameters;
      2: pnlCard.ActiveCard := crdCommonParams;
      3: pnlCard.ActiveCard := crdResultView;
    end
  else if (Button.Category.Id = 1) then
    case Button.Id of
      0: pnlCard.ActiveCard := crdSearchDuplicateFiles;
      1: pnlCard.ActiveCard := crdBruteForce;
      2: if FileExists(LogWriter.LogFileName) then
          TFileUtils.ShellOpen(LogWriter.LogFileName);
    end;
  lblTitle.Caption := Button.Caption;

  pnlExtendedFilter.Visible := (pnlCard.ActiveCard = crdResultView);
  splExtendedFilter.Visible := (pnlCard.ActiveCard = crdResultView);
end;

procedure TfrmMain.aToggleSplitPanelExecute(Sender: TObject);
begin
  inherited;
  if splView.Opened then
    splView.Close
  else
    splView.Open;
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

procedure TfrmMain.splViewClosed(Sender: TObject);
begin
  inherited;
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions - [boShowCaptions];
  catMenuItems.Width         := splView.CompactWidth;
end;

procedure TfrmMain.splViewOpened(Sender: TObject);
begin
  inherited;
  catMenuItems.ButtonOptions := catMenuItems.ButtonOptions + [boShowCaptions];
  catMenuItems.Width         := splView.OpenedWidth;
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
  // nothing
end;

procedure TfrmMain.CompletedAttach(const aAttachment: PAttachment);
begin
  // nothing
end;

procedure TfrmMain.CompletedItem(const aResultData: PResultData);
begin
  // nothing
end;

procedure TfrmMain.UpdateFilter(const aOperation: TFilterOperation);
begin
  // nothing
end;

procedure TfrmMain.UpdateRegExp;
begin
  // nothing
end;

procedure TfrmMain.EndProgress;
begin
  FProgressBar.Progress := 0;
  FProgressBar.Visible := False;
end;

procedure TfrmMain.Progress;
begin
  if (FProgressBar.Progress >= FProgressBar.MaxValue) then
    FProgressBar.MaxValue := FProgressBar.MaxValue + C_PROGRESS_STEP;
  FProgressBar.Progress := FProgressBar.Progress + C_PROGRESS_STEP;
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
