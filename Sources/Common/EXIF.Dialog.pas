unit EXIF.Dialog;

interface

{$REGION 'Region uses'}
uses
  Windows, ActiveX, Buttons, Classes, ComCtrls, Controls, Dialogs, ExtCtrls, Forms, Graphics, Messages, SHDocVw,
  System.SysUtils, System.Variants, Vcl.ActnList, System.Actions, Vcl.OleCtrls, System.IOUtils, MessageDialog,
  DebugWriter, Html.Consts, Html.Lib, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} CommonForms, Vcl.ExtDlgs,
  Vcl.StdCtrls, DaImages, Common.Types, Translate.Lang, Vcl.Grids, Vcl.ValEdit, Generics.Collections,
  Generics.Defaults, Vcl.VirtualImage, VCLTee.TeeFilters, Vcl.Imaging.jpeg;
{$ENDREGION}

type
  TEXIFDialog = class(TCommonForm)
    ActionList         : TActionList;
    aOk                : TAction;
    aSave              : TAction;
    btnOk              : TBitBtn;
    btnSave            : TBitBtn;
    Image              : TImage;
    PageControl1       : TPageControl;
    pnlBottom          : TPanel;
    SaveTextFileDialog : TSaveTextFileDialog;
    tsMain             : TTabSheet;
    tsPhoto            : TTabSheet;
    tsPlainText        : TTabSheet;
    ValueListEditor    : TValueListEditor;
    wbMessage          : TWebBrowser;
    procedure aOkExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure wbMessageBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private const
    C_IDENTITY_NAME = 'EXIFDialog';
  private
    FMessageText : string;
    FImageFile: TFileName;
  protected
    function GetIdentityName: string; override;
  public
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;

    property MessageText : string    read FMessageText write FMessageText;
    property ImageFile   : TFileName read FImageFile   write FImageFile;

    class procedure ShowMessage(const aMessageText: string; const aImageFile: TFileName);
  end;

implementation

{$R *.dfm}

class procedure TEXIFDialog.ShowMessage(const aMessageText: string; const aImageFile: TFileName);
begin
  if aMessageText.IsEmpty and not TFile.Exists(aImageFile) then
    TMessageDialog.ShowWarning(TLang.Lang.Translate('NoDataToDisplay'))
  else
  begin
    with TEXIFDialog.Create(nil) do
    try
      MessageText := aMessageText;
      ImageFile   := aImageFile;
      Caption     := Application.Title;
      Initialize;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

function TEXIFDialog.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TEXIFDialog.Initialize;
var
  html: string;
  arrMessage: TArray<string>;
begin
  inherited;
  Translate;
  html := Concat(C_HTML_OPEN,
                 C_HTML_HEAD_OPEN,
                 C_HTML_HEAD_CLOSE,
                 C_HTML_BODY_OPEN,
                 FMessageText,
                 C_HTML_BODY_CLOSE,
                 C_HTML_CLOSE);

  THtmlLib.LoadStringToBrowser(wbMessage, html.Replace(#10, '<br>'));
  if wbMessage.Showing and Assigned(wbMessage.Document) then
    with wbMessage.Application as IOleobject do
      DoVerb(OLEIVERB_UIACTIVATE, nil, wbMessage, 0, Handle, GetClientRect);

  arrMessage := FMessageText.Split([sLineBreak]);
  TArray.Sort<string>(arrMessage, TStringComparer.Ordinal);
  ValueListEditor.Strings.Add('File name=' + FImageFile);
  for var item in arrMessage do
    if item.Contains('=') then
      ValueListEditor.Strings.Add(item);

  if TFile.Exists(FImageFile) then
  begin
    tsPhoto.TabVisible := True;
    try
      Image.Picture.LoadFromFile(FImageFile);
    except
    end;
  end
  else
    tsPhoto.TabVisible := False;
end;

procedure TEXIFDialog.Deinitialize;
begin

  inherited;
end;

procedure TEXIFDialog.Translate;
begin
  inherited;
  aOk.Caption         := TLang.Lang.Translate('Ok');
  aSave.Caption       := TLang.Lang.Translate('Save');
  tsMain.Caption      := TLang.Lang.Translate('Main');
  tsPlainText.Caption := TLang.Lang.Translate('PlainText');

  ValueListEditor.TitleCaptions.Clear;
  ValueListEditor.TitleCaptions.Add(TLang.Lang.Translate('Parameter'));
  ValueListEditor.TitleCaptions.Add(TLang.Lang.Translate('Value'));
end;

procedure TEXIFDialog.aOkExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TEXIFDialog.aSaveExecute(Sender: TObject);
begin
  SaveTextFileDialog.FileName := GetIdentityName + '.html';
  if SaveTextFileDialog.Execute then
    TFile.WriteAllText(SaveTextFileDialog.FileName, MessageText);
end;

procedure TEXIFDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Deinitialize;
end;

procedure TEXIFDialog.wbMessageBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  inherited;
  Cancel := URL <> C_HTML_BLANK;
end;

end.
