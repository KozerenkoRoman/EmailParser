unit XLSX.Dialog;

interface

{$REGION 'Region uses'}
uses
  Windows, ActiveX, Buttons, Classes, ComCtrls, Controls, Dialogs, ExtCtrls, Forms, Graphics, Messages, SHDocVw,
  System.SysUtils, System.Variants, Vcl.ActnList, System.Actions, Vcl.OleCtrls, System.IOUtils, MessageDialog,
  DebugWriter, Html.Consts, Html.Lib, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} CommonForms, Vcl.ExtDlgs,
  Vcl.StdCtrls, DaImages, Common.Types, Translate.Lang, Vcl.Grids, Vcl.ValEdit, Generics.Collections,
  Generics.Defaults, Utils, ArrayHelper, Global.Utils;
{$ENDREGION}

type
  TXLSXDialog = class(TCommonForm)
    ActionList         : TActionList;
    aOk                : TAction;
    aSave              : TAction;
    btnOk              : TBitBtn;
    btnSave            : TBitBtn;
    pcXLSDialog        : TPageControl;
    pnlBottom          : TPanel;
    SaveTextFileDialog : TSaveTextFileDialog;
    StringGrid         : TStringGrid;
    tsMain             : TTabSheet;
    tsPlainText        : TTabSheet;
    wbMessage          : TWebBrowser;
    procedure aOkExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure wbMessageBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  private const
    C_IDENTITY_NAME = 'XLSXDialog';
  private
    FMessageText : string;
    FMatches: TArrayRecord<TStringArray>;
    procedure FillGrid;
  protected
    function GetIdentityName: string; override;
  public
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;

    property MessageText : string read FMessageText write FMessageText;
    class procedure ShowMessage(const aMessageText: string; const aMatches: TArrayRecord<TStringArray>);
  end;

implementation

{$R *.dfm}

class procedure TXLSXDialog.ShowMessage(const aMessageText: string; const aMatches: TArrayRecord<TStringArray>);
begin
  if aMessageText.IsEmpty then
    TMessageDialog.ShowWarning(TLang.Lang.Translate('NoDataToDisplay'))
  else
  begin
    with TXLSXDialog.Create(nil) do
    try
      MessageText := aMessageText;
      Caption     := Application.Title;
      FMatches    := aMatches;
      Initialize;
      ShowModal;
    finally
      Free;
    end;
  end;
end;

procedure TXLSXDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Deinitialize;
end;

function TXLSXDialog.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TXLSXDialog.Initialize;
var
  html: string;
begin
  inherited;
  Translate;
  FillGrid;
  html := Concat(C_HTML_OPEN,
                 C_HTML_HEAD_OPEN,
                 C_HTML_HEAD_CLOSE,
                 C_HTML_BODY_OPEN,
                 TGlobalUtils.GetHighlightText(FMessageText.Replace(#10, '<br>'), FMatches),
                 C_HTML_BODY_CLOSE,
                 C_HTML_CLOSE);

  THtmlLib.LoadStringToBrowser(wbMessage, html);
  if wbMessage.Showing and Assigned(wbMessage.Document) then
    with wbMessage.Application as IOleobject do
      DoVerb(OLEIVERB_UIACTIVATE, nil, wbMessage, 0, Handle, GetClientRect);
end;

procedure TXLSXDialog.Deinitialize;
begin

  inherited;
end;

procedure TXLSXDialog.Translate;
begin
  inherited;
  aOk.Caption         := TLang.Lang.Translate('Ok');
  aSave.Caption       := TLang.Lang.Translate('Save');
  tsMain.Caption      := TLang.Lang.Translate('Main');
  tsPlainText.Caption := TLang.Lang.Translate('PlainText');
end;

procedure TXLSXDialog.aOkExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TXLSXDialog.aSaveExecute(Sender: TObject);
begin
  SaveTextFileDialog.FileName := GetIdentityName + '.csv';
  if SaveTextFileDialog.Execute then
    TFile.WriteAllText(SaveTextFileDialog.FileName, MessageText);
end;

procedure TXLSXDialog.FillGrid;
var
  arrMessage: TArray<string>;
  arrCol: TArray<string>;
begin
  if FMessageText.IsEmpty then
    Exit;
  arrMessage := FMessageText.Split([sLineBreak]);
  StringGrid.RowCount := Length(arrMessage) + 1;
  if (StringGrid.RowCount = 1) then
    Exit;

  for var Row := Low(arrMessage) to High(arrMessage) do
  begin
    arrCol := arrMessage[Row].Split([';']);
    if (Row = 0) then  //Col header
    begin
      StringGrid.ColCount := Length(arrCol);
      for var Col := Low(arrCol) to High(arrCol) do
      begin
        StringGrid.Cells[Col + 1, 0] := string(IntToXlsCol(Col + 1));
        if (Col > 0) then
          StringGrid.ColWidths[Col] := 150;
      end;
    end
    else if (Row > 0) then //Row header
      StringGrid.Cells[0, Row] := Row.ToString;

    for var Col := Low(arrCol) to High(arrCol) do
      StringGrid.Cells[Col + 1, Row + 1] := arrCol[Col].DeQuotedString('"');
  end;
end;

procedure TXLSXDialog.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  SavedAlign: Cardinal;
begin
  inherited;
  if gdFixed in State then
  begin
    StringGrid.Canvas.Brush.Color := clBtnFace;
    StringGrid.Canvas.Font.Style  := [fsBold];
    StringGrid.Canvas.Font.Color  := clWindowText;
    SavedAlign := SetTextAlign(StringGrid.Canvas.Handle, TA_CENTER);
    StringGrid.Canvas.TextRect(Rect, Rect.Left + (Rect.Right - Rect.Left) div 2, Rect.Top + 2, StringGrid.Cells[ACol, ARow]);
    SetTextAlign(StringGrid.Canvas.Handle, SavedAlign);
  end
  else
  begin
    if gdSelected in State then
    begin
      StringGrid.Canvas.Brush.Color := clBtnFace;
      StringGrid.Canvas.Font.Style  := [];
      StringGrid.Canvas.Font.Color  := clWindowText;
    end
    else
    begin
      StringGrid.Canvas.Brush.Color := TGlobalUtils.GetHighlightColor(StringGrid.Cells[ACol, ARow], FMatches);
      StringGrid.Canvas.Font.Style  := [];
      StringGrid.Canvas.Font.Color  := clWindowText;
    end;
    StringGrid.Canvas.FillRect(Rect);
    StringGrid.Canvas.TextOut(Rect.Left + 3, Rect.Top + 5, StringGrid.Cells[ACol, ARow]);
  end;
end;

procedure TXLSXDialog.wbMessageBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  inherited;
  Cancel := URL <> C_HTML_BLANK;
end;

end.
