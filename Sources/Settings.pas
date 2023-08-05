unit Settings;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IniFiles, System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading,
  HtmlLib, CustomForms, Vcl.WinXCtrls, Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage,
  Vcl.CategoryButtons, Frame.Custom, Frame.RegExpParameters, Frame.Pathes, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Vcl.ToolWin, Performer, Vcl.AppEvnts, SplashScreen;
{$ENDREGION}

type
  TfrmSettings = class(TCustomForm)
    aEditRegExpParameters: TAction;
    alSettings: TActionList;
    aPathsFindFiles: TAction;
    aToggleSplitPanel: TAction;
    catMenuItems: TCategoryButtons;
    crdPathsToFindScripts: TCard;
    crdRegExpParameters: TCard;
    framePathes: TframePathes;
    frameRegExpParameters: TframeRegExpParameters;
    imgMenu: TImage;
    lblTitle: TLabel;
    pnlCard: TCardPanel;
    pnlTop: TPanel;
    splView: TSplitView;
    btnSearch: TSpeedButton;
    aSearch: TAction;
    crdCommonParams: TCard;
    aEditCommonParameters: TAction;
    srchBox: TSearchBox;
    ApplicationEvents: TApplicationEvents;
    procedure aEditRegExpParametersExecute(Sender: TObject);
    procedure aPathsFindFilesExecute(Sender: TObject);
    procedure aToggleSplitPanelExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aEditCommonParametersExecute(Sender: TObject);
    procedure srchBoxInvokeSearch(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  public
    procedure Initialize;
    procedure Deinitialize;
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
  frameRegExpParameters.Initialize;
  framePathes.Initialize;
  pnlTop.Color                := C_TOP_COLOR;
  catMenuItems.HotButtonColor := C_TOP_COLOR;

  aPathsFindFiles.Caption       := TLang.Lang.Translate('PathsToFindFiles');
  aEditRegExpParameters.Caption := TLang.Lang.Translate('EditRegExpParameters');
  lblTitle.Caption              := TLang.Lang.Translate('PathsToFindFiles');
  aEditCommonParameters.Caption := TLang.Lang.Translate('EditCommonParameters');
end;

procedure TfrmSettings.Deinitialize;
begin
  frameRegExpParameters.Deinitialize;
  framePathes.Deinitialize;
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
  TMessageDialog.ShowError(E.Message, StackTrace);
end;

procedure TfrmSettings.aSearchExecute(Sender: TObject);
begin
  inherited;
  TfrmPerformer.ShowDocument;
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
