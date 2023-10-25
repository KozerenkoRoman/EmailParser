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
    aAttachmentsMain       : TAction;
    aAttachmentsSub        : TAction;
    aPathForAttachments    : TAction;
    cbDeleteAttachments    : TCheckBox;
    cbLanguage             : TComboBox;
    cbLogWriteActive       : TCheckBox;
    cbStyle                : TComboBox;
    dlgAttachmments        : TFileOpenDialog;
    edtExtensions          : TEdit;
    edtMaxSize             : TNumberBox;
    edtNumberOfDays        : TNumberBox;
    edtPathForAttachments  : TButtonedEdit;
    grdCommonParams        : TGridPanel;
    lblDeleteAttachments   : TLabel;
    lblExtensions          : TLabel;
    lblLanguage            : TLabel;
    lblLogWriteActive      : TLabel;
    lblMaxSize             : TLabel;
    lblNumberOfDays        : TLabel;
    lblPathForAttachments  : TLabel;
    lblStyle               : TLabel;
    miAttachmentsMain      : TMenuItem;
    miAttachmentsSub       : TMenuItem;
    miPathForAttachments   : TMenuItem;
    ShapeDividingLine      : TShape;
    procedure aAttachmentsMainExecute(Sender: TObject);
    procedure aAttachmentsSubExecute(Sender: TObject);
    procedure aPathForAttachmentsExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure FrameCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
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
  dlgAttachmments.Title := Application.Title;
  edtPathForAttachments.Width    := Self.Width - Trunc(grdCommonParams.ColumnCollection.Items[0].Value) - 30;
  edtMaxSize.CurrencyString      := '';
  edtNumberOfDays.CurrencyString := '';
end;

procedure TframeSettings.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeSettings.FrameCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  inherited;
  edtPathForAttachments.Width := NewWidth - Trunc(grdCommonParams.ColumnCollection.Items[0].Value) - 30;
end;

procedure TframeSettings.Translate;
begin
  inherited;
  lblDeleteAttachments.Caption  := TLang.Lang.Translate('DeleteAttachments');
  lblExtensions.Caption         := TLang.Lang.Translate('FileExtensions');
  lblLanguage.Caption           := TLang.Lang.Translate('Language');
  lblLogWriteActive.Caption     := TLang.Lang.Translate('IsLogginActive');
  lblMaxSize.Caption            := TLang.Lang.Translate('MaxSizeLogFile');
  lblNumberOfDays.Caption       := TLang.Lang.Translate('NumberOfDays');
  lblPathForAttachments.Caption := TLang.Lang.Translate('PathForAttachments');
  lblStyle.Caption              := TLang.Lang.Translate('Style');
end;

function TframeSettings.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeSettings.LoadFromXML;
begin
  inherited;
  cbDeleteAttachments.Checked := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);
  cbLanguage.ItemIndex        := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0);
  cbLogWriteActive.Checked    := TGeneral.XMLParams.ReadBool(C_SECTION_DEBUG, C_KEY_IS_ACTIVE, True);
  edtExtensions.Text          := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
  edtMaxSize.ValueInt         := TGeneral.XMLParams.ReadInteger(C_SECTION_DEBUG, C_KEY_MAX_SIZE, 1);
  edtNumberOfDays.ValueInt    := TGeneral.XMLParams.ReadInteger(C_SECTION_DEBUG, C_KEY_COUNT_OF_DAYS, 30);
  edtPathForAttachments.Text  := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachments', C_ATTACHMENTS_SUB_DIR);
  cbStyle.ItemIndex           := cbStyle.Items.IndexOf(TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Style', TStyleManager.cSystemStyleName));
end;

procedure TframeSettings.SaveToXML;
begin
  inherited;
  TGeneral.XMLParams.WriteBool(C_SECTION_DEBUG, C_KEY_IS_ACTIVE, cbLogWriteActive.Checked, lblLogWriteActive.Caption);
  TGeneral.XMLParams.WriteBool(C_SECTION_MAIN, 'DeleteAttachments', cbDeleteAttachments.Checked, lblDeleteAttachments.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_DEBUG, C_KEY_MAX_SIZE, edtMaxSize.ValueInt, lblMaxSize.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_DEBUG, C_KEY_COUNT_OF_DAYS, edtNumberOfDays.ValueInt, lblNumberOfDays.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'Language', cbLanguage.ItemIndex, cbLanguage.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Extensions', edtExtensions.Text, lblExtensions.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'PathForAttachments', edtPathForAttachments.Text, lblPathForAttachments.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Style', cbStyle.Text, lblStyle.Caption);
  TGeneral.XMLParams.Save;
end;

procedure TframeSettings.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  TStyleManager.TrySetStyle(cbStyle.Text);
  TPublishers.ConfigPublisher.UpdateLanguage;
end;

procedure TframeSettings.aAttachmentsMainExecute(Sender: TObject);
begin
  inherited;
  edtPathForAttachments.Text := C_ATTACHMENTS_DIR;
end;

procedure TframeSettings.aAttachmentsSubExecute(Sender: TObject);
begin
  inherited;
  edtPathForAttachments.Text := C_ATTACHMENTS_SUB_DIR;
end;

procedure TframeSettings.aPathForAttachmentsExecute(Sender: TObject);
begin
  inherited;
  if dlgAttachmments.Execute then
    edtPathForAttachments.Text := dlgAttachmments.FileName;
end;

procedure TframeSettings.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

end.
