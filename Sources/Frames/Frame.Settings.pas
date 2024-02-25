unit Frame.Settings;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Source, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ComCtrls,
  Vcl.ToolWin, VirtualTrees, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Defaults,Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Common.Types, DaImages, System.RegularExpressions,
  System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Global.Types, Vcl.FileCtrl,
  Global.Resources, Vcl.WinXPanels, Frame.Custom, Publishers, Vcl.NumberBox, Vcl.Themes;
{$ENDREGION}

type
  TframeSettings = class(TFrameCustom)
    cbHTTPClientActive  : TCheckBox;
    cbLanguage          : TComboBox;
    cbLogWriteActive    : TCheckBox;
    cbStyle             : TComboBox;
    edtExtensions       : TEdit;
    edtHost             : TEdit;
    edtMaxSize          : TNumberBox;
    edtNumberOfDays     : TNumberBox;
    edtPassword         : TEdit;
    edtUser             : TEdit;
    grdCommonParams     : TGridPanel;
    lblExtensions       : TLabel;
    lblHost             : TLabel;
    lblHTTPClientActive : TLabel;
    lblLanguage         : TLabel;
    lblLogWriteActive   : TLabel;
    lblMaxSize          : TLabel;
    lblNumberOfDays     : TLabel;
    lblPassword         : TLabel;
    lblStyle            : TLabel;
    lblUser             : TLabel;
    ShapeDividingLine01 : TShape;
    ShapeDividingLine02 : TShape;
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'frameSettings';
  protected
    function GetIdentityName: string; override;
    procedure LoadFromXML; override;
  public
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
    procedure SaveToXML; override;
  end;

implementation

{$R *.dfm}

{ TframeSettings }

procedure TframeSettings.Initialize;
begin
  inherited Initialize;

  cbStyle.Items.Clear;
  cbLanguage.Items.Clear;
  for var StyleName in TStyleManager.StyleNames do
    cbStyle.Items.Add(StyleName);
  cbStyle.Sorted := True;
  for var lang := Low(TLanguage) to High(TLanguage) do
    cbLanguage.Items.Add(lang.ToString);

  LoadFromXML;
  Translate;
  edtMaxSize.CurrencyString      := '';
  edtNumberOfDays.CurrencyString := '';
end;

procedure TframeSettings.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeSettings.Translate;
begin
  inherited;
  lblExtensions.Caption     := TLang.Lang.Translate('FileExtensions');
  lblLanguage.Caption       := TLang.Lang.Translate('Language');
  lblLogWriteActive.Caption := TLang.Lang.Translate('IsLogginActive');
  lblMaxSize.Caption        := TLang.Lang.Translate('MaxSizeLogFile');
  lblNumberOfDays.Caption   := TLang.Lang.Translate('NumberOfDays');
  lblStyle.Caption          := TLang.Lang.Translate('Style');
  lblHTTPClientActive.Caption := TLang.Lang.Translate('IsHTTPClientActive');
end;

function TframeSettings.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeSettings.LoadFromXML;
begin
  inherited;

  cbLanguage.ItemIndex       := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0);
  cbLogWriteActive.Checked   := TGeneral.XMLParams.ReadBool(C_SECTION_DEBUG, C_KEY_IS_ACTIVE, True);
  cbStyle.ItemIndex          := cbStyle.Items.IndexOf(TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Style', TStyleManager.cSystemStyleName));
  edtExtensions.Text         := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
  edtMaxSize.ValueInt        := TGeneral.XMLParams.ReadInteger(C_SECTION_DEBUG, C_KEY_MAX_SIZE, 1);
  edtNumberOfDays.ValueInt   := TGeneral.XMLParams.ReadInteger(C_SECTION_DEBUG, C_KEY_COUNT_OF_DAYS, 30);

  cbHTTPClientActive.Checked := TGeneral.XMLParams.ReadBool(C_SECTION_HTTP, C_KEY_IS_ACTIVE, False);
  edtHost.Text               := TGeneral.XMLParams.ReadString(C_SECTION_HTTP, C_KEY_HOST, 'http://127.0.0.1:8080/api/');
  edtUser.Text               := TGeneral.XMLParams.ReadString(C_SECTION_HTTP, C_KEY_USER, '');
  edtPassword.Text           := TGeneral.XMLParams.ReadString(C_SECTION_HTTP, C_KEY_PASSWORD, '');
end;

procedure TframeSettings.SaveToXML;
begin
  inherited;
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'Language', cbLanguage.ItemIndex, cbLanguage.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Extensions', edtExtensions.Text, lblExtensions.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Style', cbStyle.Text, lblStyle.Caption);

  TGeneral.XMLParams.WriteBool(C_SECTION_DEBUG, C_KEY_IS_ACTIVE, cbLogWriteActive.Checked, lblLogWriteActive.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_DEBUG, C_KEY_MAX_SIZE, edtMaxSize.ValueInt, lblMaxSize.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_DEBUG, C_KEY_COUNT_OF_DAYS, edtNumberOfDays.ValueInt, lblNumberOfDays.Caption);

  TGeneral.XMLParams.WriteBool(C_SECTION_HTTP, C_KEY_IS_ACTIVE, cbHTTPClientActive.Checked, lblHTTPClientActive.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_HTTP, C_KEY_HOST,  edtHost.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_HTTP, C_KEY_USER, edtUser.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_HTTP, C_KEY_PASSWORD, edtPassword.Text);

  TGeneral.XMLParams.Save;
end;

procedure TframeSettings.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  TStyleManager.TrySetStyle(cbStyle.Text);
  TPublishers.ConfigPublisher.UpdateSettings;
end;

procedure TframeSettings.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

end.
