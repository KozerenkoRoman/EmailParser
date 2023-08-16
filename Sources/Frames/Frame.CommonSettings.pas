unit Frame.CommonSettings;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Custom, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ComCtrls,
  Vcl.ToolWin, VirtualTrees, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Defaults,Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles, Global.Types, Vcl.FileCtrl,
  Global.Resources;
{$ENDREGION}

type
  TframeCommonSettings = class(TframeCustom)
    aAttachmentsMain      : TAction;
    aAttachmentsSub       : TAction;
    aPathForAttachments   : TAction;
    cbDeleteAttachments   : TCheckBox;
    cbLanguage            : TComboBox;
    dlgAttachmments       : TFileOpenDialog;
    edtExtensions         : TEdit;
    edtPathForAttachments : TButtonedEdit;
    grdCommonParams       : TGridPanel;
    lblDeleteAttachments  : TLabel;
    lblExtensions         : TLabel;
    lblLanguage           : TLabel;
    lblPathForAttachments : TLabel;
    miAttachmentsMain     : TMenuItem;
    miAttachmentsSub      : TMenuItem;
    miPathForAttachments  : TMenuItem;
    procedure aAttachmentsMainExecute(Sender: TObject);
    procedure aAttachmentsSubExecute(Sender: TObject);
    procedure aPathForAttachmentsExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'frameCommonSettings';
  protected
    function GetIdentityName: string; override;
    procedure LoadFromXML; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
    procedure SaveToXML; override;
  end;

implementation

{$R *.dfm}

{ TframeSettings }

constructor TframeCommonSettings.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TframeCommonSettings.Destroy;
begin

  inherited;
end;

procedure TframeCommonSettings.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  Translate;
  dlgAttachmments.Title := Application.Title;
end;

procedure TframeCommonSettings.Translate;
begin
  inherited;
  lblDeleteAttachments.Caption  := TLang.Lang.Translate('DeleteAttachments');
  lblExtensions.Caption         := TLang.Lang.Translate('FileExtensions');
  lblLanguage.Caption           := TLang.Lang.Translate('Language');
  lblPathForAttachments.Caption := TLang.Lang.Translate('PathForAttachments');
end;

procedure TframeCommonSettings.Deinitialize;
begin
  inherited Deinitialize;
end;

function TframeCommonSettings.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeCommonSettings.LoadFromXML;
begin
  inherited;
  cbLanguage.Items.Clear;
  for var lang := Low(TLanguage) to High(TLanguage) do
    cbLanguage.Items.Add(lang.ToString);
  cbDeleteAttachments.Checked := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);
  cbLanguage.ItemIndex        := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0);
  edtExtensions.Text          := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
  edtPathForAttachments.Text  := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachments', C_ATTACHMENTS_SUB_DIR);
end;

procedure TframeCommonSettings.SaveToXML;
begin
  inherited;
  TGeneral.XMLParams.WriteBool(C_SECTION_MAIN, 'DeleteAttachments', cbDeleteAttachments.Checked, lblDeleteAttachments.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'Language', cbLanguage.ItemIndex, cbLanguage.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Extensions', edtExtensions.Text, lblExtensions.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'PathForAttachments', edtPathForAttachments.Text, lblPathForAttachments.Caption);
  TGeneral.XMLParams.Save;
end;

procedure TframeCommonSettings.aAttachmentsMainExecute(Sender: TObject);
begin
  inherited;
  edtPathForAttachments.Text := C_ATTACHMENTS_DIR;
end;

procedure TframeCommonSettings.aAttachmentsSubExecute(Sender: TObject);
begin
  inherited;
  edtPathForAttachments.Text := C_ATTACHMENTS_SUB_DIR;
end;

procedure TframeCommonSettings.aPathForAttachmentsExecute(Sender: TObject);
begin
  inherited;
  if dlgAttachmments.Execute then
    edtPathForAttachments.Text := dlgAttachmments.FileName;
end;

procedure TframeCommonSettings.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

end.
