unit Project.Editor;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IOUtils, Global.Resources, Utils, MessageDialog, Global.Types,
  CommonForms, Vcl.ActnMan, ArrayHelper, Vcl.Menus, Vcl.Buttons, System.Actions, Vcl.ActnList,
  TesseractOCR.Types;
{$ENDREGION}

type
  TfrmProjectEditor = class(TCommonForm)
    aAttachmentsMain      : TAction;
    aAttachmentsSub       : TAction;
    alProject             : TActionList;
    aPathForAttachments   : TAction;
    btnCancel             : TBitBtn;
    btnOk                 : TBitBtn;
    cbDeleteAttachments   : TCheckBox;
    cbLanguageOCR         : TComboBox;
    cbUseOCR              : TCheckBox;
    dlgAttachmments       : TFileOpenDialog;
    edtHash               : TEdit;
    edtInfo               : TEdit;
    edtName               : TEdit;
    edtPath               : TButtonedEdit;
    grdCommonParams       : TGridPanel;
    lblDeleteAttachments  : TLabel;
    lblHash               : TLabel;
    lblInfo               : TLabel;
    lblLanguageOCR        : TLabel;
    lblName               : TLabel;
    lblPathForAttachments : TLabel;
    lblUseOCR             : TLabel;
    miAttachmentsMain     : TMenuItem;
    miAttachmentsSub      : TMenuItem;
    miPathForAttachments  : TMenuItem;
    pmAttachmments        : TPopupMenu;
    pnlBottom             : TPanel;
    procedure aAttachmentsMainExecute(Sender: TObject);
    procedure aAttachmentsSubExecute(Sender: TObject);
    procedure aPathForAttachmentsExecute(Sender: TObject);
    procedure edtPathRightButtonClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'ProjectEditor';
  private
    procedure LoadFromXML;
    procedure SaveToXML;

    function GetDeleteAttachments: Boolean;
    function GetHash: string;
    function GetInfo: string;
    function GetLanguageOCR: TOCRLanguage;
    function GetName: string;
    function GetPathForAttachments: string;
    function GetUseOCR: Boolean;
    procedure SetDeleteAttachments(const Value: Boolean);
    procedure SetHash(const Value: string);
    procedure SetInfo(const Value: string);
    procedure SetLanguageOCR(const Value: TOCRLanguage);
    procedure SetName_(const Value: string);
    procedure SetPathForAttachments(const Value: string);
    procedure SetUseOCR(const Value: Boolean);
  protected
    function GetIdentityName: string; override;
  public
    class function ShowDocument(const aData: PProject): TModalResult;

    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;

    property DeleteAttachments  : Boolean      read GetDeleteAttachments  write SetDeleteAttachments;
    property Hash               : string       read GetHash               write SetHash;
    property Info               : string       read GetInfo               write SetInfo;
    property LanguageOCR        : TOCRLanguage read GetLanguageOCR        write SetLanguageOCR;
    property Name               : string       read GetName               write SetName_;
    property PathForAttachments : string       read GetPathForAttachments write SetPathForAttachments;
    property UseOCR             : Boolean      read GetUseOCR             write SetUseOCR;
  end;

implementation

{$R *.dfm}

class function TfrmProjectEditor.ShowDocument(const aData: PProject): TModalResult;
begin
  Result := mrCancel;
  with TfrmProjectEditor.Create(nil) do
    try
      Initialize;
      DeleteAttachments  := aData^.DeleteAttachments;
      Hash               := aData^.Hash;
      Info               := aData^.Info;
      LanguageOCR        := aData^.LanguageOCR;
      Name               := aData^.Name;
      PathForAttachments := aData^.PathForAttachments;
      UseOCR             := aData^.UseOCR;
      if (ShowModal = mrOk) then
      begin
        aData^.DeleteAttachments  := DeleteAttachments;
        aData^.Hash               := Hash;
        aData^.Info               := Info;
        aData^.LanguageOCR        := LanguageOCR;
        aData^.Name               := Name;
        aData^.PathForAttachments := PathForAttachments;
        aData^.UseOCR             := UseOCR;
        Result := mrOk;
      end;
      Deinitialize;
    finally
      Free;
    end;
end;

procedure TfrmProjectEditor.FormDestroy(Sender: TObject);
begin
  for var i := 0 to cbLanguageOCR.Items.Count - 1 do
    if Assigned(cbLanguageOCR.Items.Objects[i]) then
      cbLanguageOCR.Items.Objects[i].Free;
end;

procedure TfrmProjectEditor.Initialize;
var
  FileList    : TArray<string>;
  FileName    : string;
  OCRLanguage : TOCRLanguage;
  so          : TStringObject;
begin
  inherited;
  LoadFromXML;
  Translate;

  if TDirectory.Exists('./tessdata/') then
    FileList := TDirectory.GetFiles('./tessdata/', '*.traineddata');
  for var Item in FileList do
  begin
    FileName := TPath.GetFileNameWithoutExtension(Item);
    if not FileName.Equals('osd') then
    begin
      OCRLanguage := OCRLanguage.FromString(FileName);
      if (OCRLanguage <> TOCRLanguage.lgDefault) then
      begin
        so := TStringObject.Create;
        so.Id := Integer(OCRLanguage);
        so.StringValue := OCRLanguage.ToString;
        cbLanguageOCR.AddItem(OCRLanguage.ToLanguageName, so);
      end;
    end;
  end;
end;

procedure TfrmProjectEditor.Deinitialize;
begin
  inherited;
  SaveToXML;
end;

procedure TfrmProjectEditor.LoadFromXML;
begin

end;

procedure TfrmProjectEditor.SaveToXML;
begin

end;

procedure TfrmProjectEditor.Translate;
begin
  inherited;
  lblDeleteAttachments.Caption  := TLang.Lang.Translate('DeleteAttachments');
  lblHash.Caption               := TLang.Lang.Translate('Hash');
  lblInfo.Caption               := TLang.Lang.Translate('Info');
  lblLanguageOCR.Caption        := TLang.Lang.Translate('LanguageOCR');
  lblName.Caption               := TLang.Lang.Translate('Name');
  lblPathForAttachments.Caption := TLang.Lang.Translate('PathForAttachments');
  lblUseOCR.Caption             := TLang.Lang.Translate('UseOCR');
end;

function TfrmProjectEditor.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TfrmProjectEditor.edtPathRightButtonClick(Sender: TObject);
var
  Point: TPoint;
begin
  inherited;
  Point := TPoint.Create(edtPath.ClientRect.BottomRight.X - edtPath.Images.Width, edtPath.ClientRect.BottomRight.Y + 2);
  Point := edtPath.ClientToScreen(Point);
  pmAttachmments.Popup(Point.X, Point.Y);
end;

procedure TfrmProjectEditor.aAttachmentsMainExecute(Sender: TObject);
begin
  inherited;
  edtPath.Text := C_ATTACHMENTS_DIR;
end;

procedure TfrmProjectEditor.aAttachmentsSubExecute(Sender: TObject);
begin
  inherited;
  edtPath.Text := C_ATTACHMENTS_SUB_DIR;
end;

procedure TfrmProjectEditor.aPathForAttachmentsExecute(Sender: TObject);
begin
  inherited;
  if dlgAttachmments.Execute then
    edtPath.Text := dlgAttachmments.FileName;
end;

procedure TfrmProjectEditor.SetName_(const Value: string);
begin
  edtName.Text := Value;
end;

procedure TfrmProjectEditor.SetDeleteAttachments(const Value: Boolean);
begin
  cbDeleteAttachments.Checked := Value;
end;

procedure TfrmProjectEditor.SetHash(const Value: string);
begin
  edtHash.Text := Value;
end;

procedure TfrmProjectEditor.SetInfo(const Value: string);
begin
  edtInfo.Text := Value;
end;

procedure TfrmProjectEditor.SetLanguageOCR(const Value: TOCRLanguage);
begin
  cbLanguageOCR.ItemIndex := cbLanguageOCR.Items.IndexOf(Value.ToLanguageName);
end;

procedure TfrmProjectEditor.SetPathForAttachments(const Value: string);
begin
  edtPath.Text := Value;
end;

procedure TfrmProjectEditor.SetUseOCR(const Value: Boolean);
begin
  cbUseOCR.Checked := Value;
end;

function TfrmProjectEditor.GetDeleteAttachments: Boolean;
begin
  Result := cbDeleteAttachments.Checked;
end;

function TfrmProjectEditor.GetHash: string;
begin
  Result := edtHash.Text;
end;

function TfrmProjectEditor.GetInfo: string;
begin
  Result := edtInfo.Text;
end;

function TfrmProjectEditor.GetLanguageOCR: TOCRLanguage;
begin
  if (cbLanguageOCR.ItemIndex > -1) then
    Result := TOCRLanguage(TStringObject(cbLanguageOCR.Items.Objects[cbLanguageOCR.ItemIndex]).Id)
  else
    Result := lgDefault;
end;

function TfrmProjectEditor.GetName: string;
begin
  Result := edtName.Text;
end;

function TfrmProjectEditor.GetPathForAttachments: string;
begin
  Result := edtPath.Text;
end;

function TfrmProjectEditor.GetUseOCR: Boolean;
begin
  Result := cbUseOCR.Checked;
end;

end.
