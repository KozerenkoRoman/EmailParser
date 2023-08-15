unit Settings;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IniFiles, System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading,
  HtmlLib, CustomForms, Vcl.WinXCtrls, Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage,
  Vcl.CategoryButtons, Frame.Custom, Frame.RegExpParameters,Frame.ResultView, Frame.Pathes, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Vcl.ToolWin, Vcl.AppEvnts, SplashScreen, Frame.CommonSettings, Global.Types;
{$ENDREGION}

type
  TfrmSettings = class(TCustomForm)
    aEditCommonParameters : TAction;
    aEditRegExpParameters : TAction;
    alSettings            : TActionList;
    aPathsFindFiles       : TAction;
    ApplicationEvents     : TApplicationEvents;
    aSaveCommonSettings   : TAction;
    aSearch               : TAction;
    aToggleSplitPanel     : TAction;
    catMenuItems          : TCategoryButtons;
    crdCommonParams       : TCard;
    crdPathsToFindScripts : TCard;
    crdRegExpParameters   : TCard;
    crdSearch             : TCard;
    frameCommonSettings   : TframeCommonSettings;
    framePathes           : TframePathes;
    frameRegExpParameters : TframeRegExpParameters;
    frameResultView       : TframeResultView;
    imgMenu               : TImage;
    lblTitle              : TLabel;
    pnlCard               : TCardPanel;
    pnlTop                : TPanel;
    sbMain                : TStatusBar;
    splView               : TSplitView;
    srchBox               : TSearchBox;
    procedure aEditCommonParametersExecute(Sender: TObject);
    procedure aEditRegExpParametersExecute(Sender: TObject);
    procedure aPathsFindFilesExecute(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure aSaveCommonSettingsExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aToggleSplitPanelExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure srchBoxInvokeSearch(Sender: TObject);
  public
    procedure Initialize;
    procedure Deinitialize;
    procedure Translate;
    class function ShowDocument: Boolean;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

{ TfrmSettings }

class function TfrmSettings.ShowDocument: Boolean;
begin
  with TfrmSettings.Create(nil) do
    try
      Result := False;
      Initialize;
      ShowModal;
      if (ModalResult = mrOk) then
      begin
        Result := True;
      end;
    finally
      Deinitialize;
      Free;
    end;
end;

procedure TfrmSettings.Initialize;
begin
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  frameRegExpParameters.Initialize;
  framePathes.Initialize;
  frameResultView.Initialize;
  frameCommonSettings.Initialize;
  pnlTop.Color                := C_TOP_COLOR;
  catMenuItems.HotButtonColor := C_TOP_COLOR;
  Translate;
end;

procedure TfrmSettings.Translate;
begin
  aEditCommonParameters.Caption := TLang.Lang.Translate('EditCommonParameters');
  aEditRegExpParameters.Caption := TLang.Lang.Translate('EditRegExpParameters');
  aPathsFindFiles.Caption       := TLang.Lang.Translate('PathsToFindFiles');
  aSearch.Caption               := TLang.Lang.Translate('StartSearch');

  crdCommonParams.Caption       := TLang.Lang.Translate('EditCommonParameters');
  crdPathsToFindScripts.Caption := TLang.Lang.Translate('PathsToFindFiles');
  crdRegExpParameters.Caption   := TLang.Lang.Translate('EditRegExpParameters');
  crdSearch.Caption             := TLang.Lang.Translate('StartSearch');

  lblTitle.Caption := pnlCard.ActiveCard.Caption;
end;

procedure TfrmSettings.Deinitialize;
begin
  frameRegExpParameters.Deinitialize;
  framePathes.Deinitialize;
  frameResultView.Deinitialize;
  frameCommonSettings.Deinitialize;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Deinitialize;
end;

procedure TfrmSettings.aToggleSplitPanelExecute(Sender: TObject);
begin
  inherited;
  if splView.Opened then
    splView.Close
  else
    splView.Open;
end;

procedure TfrmSettings.aEditCommonParametersExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdCommonParams;
end;

procedure TfrmSettings.aEditRegExpParametersExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdRegExpParameters;
end;

procedure TfrmSettings.aPathsFindFilesExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdPathsToFindScripts;
end;

procedure TfrmSettings.ApplicationEventsException(Sender: TObject; E: Exception);
var
  StackTrace: string;
begin
  TfrmSplashScreen.HideSplash;
  StackTrace := E.StackTrace;
  LogWriter.Write(ddError, E.Message + sLineBreak + StackTrace);
  if not Application.Terminated then
    TMessageDialog.ShowError(E.Message, StackTrace);
end;

procedure TfrmSettings.aSaveCommonSettingsExecute(Sender: TObject);
begin
  inherited;
  frameCommonSettings.SaveToXML;
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));

  Translate;
  frameRegExpParameters.Translate;
  framePathes.Translate;
  frameResultView.Translate;
  frameCommonSettings.Translate;
end;

procedure TfrmSettings.aSearchExecute(Sender: TObject);
begin
  inherited;
  lblTitle.Caption := TAction(Sender).Caption;
  pnlCard.ActiveCard := crdSearch;
end;

procedure TfrmSettings.srchBoxInvokeSearch(Sender: TObject);
begin
  inherited;
  if pnlCard.ActiveCard = crdPathsToFindScripts then
    framePathes.SearchText(srchBox.Text)
  else
    frameRegExpParameters.SearchText(srchBox.Text);
end;

end.
