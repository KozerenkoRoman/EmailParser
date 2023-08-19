unit RegExpEditor;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IniFiles, System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading,
  HtmlLib, Vcl.WinXCtrls, Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage,
  Vcl.CategoryButtons, Vcl.ComCtrls, Vcl.Menus, Vcl.Buttons, Vcl.ToolWin, Vcl.AppEvnts, Global.Types,
  Publishers.Interfaces, Publishers, CommonForms, System.RegularExpressions;
{$ENDREGION}

type
  TfrmRegExpEditor = class(TCommonForm)
    aDeletePattern: TAction;
    alPattern: TActionList;
    aSavePattern: TAction;
    aSavePatternAs: TAction;
    aTest: TAction;
    btnCancel: TBitBtn;
    btnDeleteSet: TToolButton;
    btnOk: TBitBtn;
    btnSaveSet: TToolButton;
    btnTest: TToolButton;
    miSaveSet: TMenuItem;
    miSaveSetAs: TMenuItem;
    pmPattern: TPopupMenu;
    pnlBottom: TPanel;
    pnlMain: TPanel;
    tbPattern: TToolBar;
    pnlSettings: TPanel;
    cbSetOfTemplates: TComboBox;
    lblPatterns: TLabel;
    pnlRight: TPanel;
    gbOptions: TGroupBox;
    chkSingleLine: TCheckBox;
    chkIgnorePatternSpace: TCheckBox;
    chkExplicitCapture: TCheckBox;
    chkMultiLine: TCheckBox;
    chkIgnoreCase: TCheckBox;
    gbRegularExpression: TGroupBox;
    edRegEx: TMemo;
    gbSampleText: TGroupBox;
    edSample: TMemo;
    gbResults: TGroupBox;
    tvResults: TTreeView;
    pmMemo: TPopupMenu;
    aSelectAll: TAction;
    aCopy: TAction;
    aPaste: TAction;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miSelectAll: TMenuItem;
    procedure aTestExecute(Sender: TObject);
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'RegExpEditor';
  private
//    FPattern: string;
    function GetPattern_: string;
    procedure SetPattern(const Value: string);
    property Pattern: string read GetPattern_ write SetPattern;
  protected
    function GetIdentityName: string; override;
    procedure AddMatchToTree(match: TMatch);
  public
    class function GetPattern(const aPattern: string): string;

    procedure Initialize;
    procedure Deinitialize;
    procedure Translate;
  end;

implementation

{$R *.dfm}

class function TfrmRegExpEditor.GetPattern(const aPattern: string): string;
begin
  with TfrmRegExpEditor.Create(nil) do
    try
      Initialize;
      Pattern := aPattern;
      if (ShowModal = mrOk) then
        Result := Pattern;
      Deinitialize;
    finally
      Free;
    end;
end;

procedure TfrmRegExpEditor.Initialize;
begin
  tbPattern.ButtonHeight := C_ICON_SIZE;
  tbPattern.ButtonWidth  := C_ICON_SIZE;
  tbPattern.Height       := C_ICON_SIZE + 2;

  LoadFormPosition;
  Translate;
end;

procedure TfrmRegExpEditor.Deinitialize;
begin
  SaveFormPosition;
end;

function TfrmRegExpEditor.GetPattern_: string;
begin
  Result := edRegEx.Text;
end;

procedure TfrmRegExpEditor.SetPattern(const Value: string);
begin
  edRegEx.Text := Value;
end;

procedure TfrmRegExpEditor.Translate;
begin
  aCopy.Caption               := TLang.Lang.Translate('Copy');
  aPaste.Caption              := TLang.Lang.Translate('Paste');
  aSavePattern.Caption        := TLang.Lang.Translate('SaveAs');
  aSavePatternAs.Caption      := TLang.Lang.Translate('Save');
  aSelectAll.Caption          := TLang.Lang.Translate('SelectAll');
  btnCancel.Caption           := TLang.Lang.Translate('Cancel');
  btnOk.Caption               := TLang.Lang.Translate('Ok');
  gbOptions.Caption           := TLang.Lang.Translate('Options');
  gbRegularExpression.Caption := TLang.Lang.Translate('RegExpTemplate');
  gbResults.Caption           := TLang.Lang.Translate('Results');
  gbSampleText.Caption        := TLang.Lang.Translate('SampleText');
  lblPatterns.Caption         := TLang.Lang.Translate('SetOfTemplates');
end;

function TfrmRegExpEditor.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TfrmRegExpEditor.AddMatchToTree(match: TMatch);
var
  matchNode: TTreeNode;
  group: TGroup;
  groupNode: TTreeNode;
  i: Integer;
begin
  matchNode := tvResults.Items.AddChild(nil, 'Match[' + match.Value + ']');

  if match.Groups.Count > 1 then
  begin
    // group 0 is the entire match, so the first real group is 1
    for i := 1 to match.Groups.Count - 1 do
    begin
      group := match.Groups.Item[i];
      groupNode := tvResults.Items.AddChild(matchNode, 'Group[' + IntToStr(i) + '] [' + group.Value + ']');
    end;
  end;
  match := match.NextMatch;
  if match.Success then
    AddMatchToTree(match);
end;

procedure TfrmRegExpEditor.aTestExecute(Sender: TObject);
var
  RegExp: TRegEx;
  Options: TRegExOptions;
  Match: TMatch;
begin
  inherited;
  tvResults.Items.Clear;

  if chkIgnoreCase.Checked then
    Include(Options, TRegExOption.roIgnoreCase);
  if chkMultiLine.Checked then
    Include(Options, TRegExOption.roMultiLine);
  if chkSingleLine.Checked then
    Include(Options, TRegExOption.roSingleLine);
  if chkExplicitCapture.Checked then
    Include(Options, TRegExOption.roIgnoreCase);
  if chkIgnorePatternSpace.Checked then
    Include(Options, TRegExOption.roIgnoreCase);

  try
    RegExp := TRegEx.Create(edRegEx.Text, Options);
    Match := RegExp.Match(edSample.Text);
    if Match.Success then
      AddMatchToTree(Match)
    else
      ShowMessage('No match found');
   tvResults.FullExpand;
  except
    on e: Exception do
    begin
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TfrmRegExpEditor.aCopyExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).CopyToClipboard;
end;

procedure TfrmRegExpEditor.aPasteExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).PasteFromClipboard;
end;

procedure TfrmRegExpEditor.aSelectAllExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).SelectAll;
end;

end.
