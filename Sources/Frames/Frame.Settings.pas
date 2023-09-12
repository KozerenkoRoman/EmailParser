unit Frame.Settings;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Source, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ComCtrls,
  Vcl.ToolWin, VirtualTrees, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Defaults,Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Global.Types, Vcl.FileCtrl,
  Global.Resources, Vcl.WinXPanels, Frame.Custom, Publishers;
{$ENDREGION}

type
  TframeSettings = class(TFrameCustom)
    aAttachmentsMain       : TAction;
    aAttachmentsSub        : TAction;
    aPathForAttachments    : TAction;
    cbDeleteAttachments    : TCheckBox;
    cbLanguage             : TComboBox;
    cbLoadRecordsFromDB    : TCheckBox;
    dlgAttachmments        : TFileOpenDialog;
    edtExtensions          : TEdit;
    edtPathForAttachments  : TButtonedEdit;
    grdCommonParams        : TGridPanel;
    lblDeleteAttachments   : TLabel;
    lblExtensions          : TLabel;
    lblLanguage            : TLabel;
    lblLoadRecordsFromDB   : TLabel;
    lblPathForAttachments  : TLabel;
    miAttachmentsMain      : TMenuItem;
    miAttachmentsSub       : TMenuItem;
    miPathForAttachments   : TMenuItem;
    procedure aAttachmentsMainExecute(Sender: TObject);
    procedure aAttachmentsSubExecute(Sender: TObject);
    procedure aPathForAttachmentsExecute(Sender: TObject);
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
  LoadFromXML;
  Translate;
  dlgAttachmments.Title := Application.Title;
  edtPathForAttachments.Width := Self.Width - Trunc(grdCommonParams.ColumnCollection.Items[0].Value) - 30;
end;

procedure TframeSettings.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeSettings.Translate;
begin
  inherited;
  lblDeleteAttachments.Caption  := TLang.Lang.Translate('DeleteAttachments');
  lblExtensions.Caption         := TLang.Lang.Translate('FileExtensions');
  lblLanguage.Caption           := TLang.Lang.Translate('Language');
  lblLoadRecordsFromDB.Caption  := TLang.Lang.Translate('LoadRecordsFromDB');
  lblPathForAttachments.Caption := TLang.Lang.Translate('PathForAttachments');
end;

function TframeSettings.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeSettings.LoadFromXML;
begin
  inherited;
  cbLanguage.Items.Clear;
  for var lang := Low(TLanguage) to High(TLanguage) do
    cbLanguage.Items.Add(lang.ToString);
  cbDeleteAttachments.Checked   := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'DeleteAttachments', True);
  cbLoadRecordsFromDB.Checked   := TGeneral.XMLParams.ReadBool(C_SECTION_MAIN, 'LoadRecordsFromDB', True);
  cbLanguage.ItemIndex          := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0);
  edtExtensions.Text            := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'Extensions', '*.eml');
  edtPathForAttachments.Text    := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PathForAttachments', C_ATTACHMENTS_SUB_DIR);
end;

procedure TframeSettings.SaveToXML;
begin
  inherited;
  TGeneral.XMLParams.WriteBool(C_SECTION_MAIN, 'DeleteAttachments', cbDeleteAttachments.Checked, lblDeleteAttachments.Caption);
  TGeneral.XMLParams.WriteBool(C_SECTION_MAIN, 'LoadRecordsFromDB', cbLoadRecordsFromDB.Checked, lblLoadRecordsFromDB.Caption);
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'Language', cbLanguage.ItemIndex, cbLanguage.Text);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'Extensions', edtExtensions.Text, lblExtensions.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'PathForAttachments', edtPathForAttachments.Text, lblPathForAttachments.Caption);
  TGeneral.XMLParams.Save;
end;

procedure TframeSettings.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
  TLang.Lang.Language := TLanguage(TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'Language', 0));
  TPublishers.TranslatePublisher.LanguageChange;
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
