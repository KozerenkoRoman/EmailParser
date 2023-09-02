unit RegExp.Editor;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter,
  Common.Types, System.IniFiles, System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading,
  Html.Lib, Vcl.WinXCtrls, Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage,
  Vcl.CategoryButtons, Vcl.ComCtrls, Vcl.Menus, Vcl.Buttons, Vcl.ToolWin, Vcl.AppEvnts, Global.Types,
  Publishers.Interfaces, Publishers, CommonForms, System.RegularExpressions, RegExp.Types, Vcl.NumberBox,
  Vcl.Samples.Spin, Performer;
{$ENDREGION}

type
  TfrmRegExpEditor = class(TCommonForm)
    aCopy                 : TAction;
    alPattern             : TActionList;
    aPaste                : TAction;
    aSelectAll            : TAction;
    aTest                 : TAction;
    btnCancel             : TBitBtn;
    btnOk                 : TBitBtn;
    btnTest               : TToolButton;
    cbSetOfTemplates      : TComboBox;
    chkExplicitCapture    : TCheckBox;
    chkIgnoreCase         : TCheckBox;
    chkIgnorePatternSpace : TCheckBox;
    chkMultiLine          : TCheckBox;
    chkSingleLine         : TCheckBox;
    edRegEx               : TMemo;
    edSample              : TMemo;
    edtGroupIndex         : TNumberBox;
    edtResult             : TEdit;
    edtTemplateName       : TEdit;
    gbOptions             : TGroupBox;
    gbRegularExpression   : TGroupBox;
    gbResults             : TGroupBox;
    gbSampleText          : TGroupBox;
    lblExamples           : TLabel;
    lblGroupIndex         : TLabel;
    lblTemplateName       : TLabel;
    miCopy                : TMenuItem;
    miPaste               : TMenuItem;
    miSelectAll           : TMenuItem;
    pmMemo                : TPopupMenu;
    pnlBottom             : TPanel;
    pnlMain               : TPanel;
    pnlRight              : TPanel;
    pnlSettings           : TPanel;
    pnlTemplateName       : TPanel;
    splPattern            : TSplitter;
    tbPattern             : TToolBar;
    tvResults             : TTreeView;
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
    procedure aTestExecute(Sender: TObject);
    procedure cbSetOfTemplatesCloseUp(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'RegExpEditor';
  private
    function GetGroupIndex: Integer;
    function GetPattern_: string;
    function GetTemplateName: string;
    procedure LoadFromXML;
    procedure SaveToXML;
    procedure SetGroupIndex(const Value: Integer);
    procedure SetPattern(const Value: string);
    procedure SetTemplateName(const Value: string);

    property Pattern      : string  read GetPattern_     write SetPattern;
    property TemplateName : string  read GetTemplateName write SetTemplateName;
    property GroupIndex   : Integer read GetGroupIndex   write SetGroupIndex;
  protected
    function GetIdentityName: string; override;
    procedure AddMatchToTree(aMatch: TMatch);
  public
    class function GetPattern(const aPattern, aTemplateName: string; const aGroupIndex: Integer): TArray<string>;

    procedure Initialize;
    procedure Deinitialize;
    procedure Translate;
  end;

implementation

{$R *.dfm}

class function TfrmRegExpEditor.GetPattern(const aPattern, aTemplateName: string; const aGroupIndex: Integer): TArray<string>;
begin
  with TfrmRegExpEditor.Create(nil) do
    try
      Initialize;
      Pattern      := aPattern;
      TemplateName := aTemplateName;
      GroupIndex := aGroupIndex;
      if (ShowModal = mrOk) then
      begin
        SetLength(Result, 3);
        Result[0] := Pattern;
        Result[1] := TemplateName;
        Result[2] := GroupIndex.ToString;
      end;
      Deinitialize;
    finally
      Free;
    end;
end;

procedure TfrmRegExpEditor.Initialize;
begin
  edtGroupIndex.CurrencyString := '';
  tbPattern.ButtonHeight := C_ICON_SIZE;
  tbPattern.ButtonWidth  := C_ICON_SIZE;
  tbPattern.Height       := C_ICON_SIZE + 2;

  LoadFormPosition;
  LoadFromXML;
  Translate;
  for var i := Low(ArrayPatterns) to High(ArrayPatterns) do
    cbSetOfTemplates.Items.AddObject(ArrayPatterns[i].Name, TStringObject.Create(ArrayPatterns[i].Pattern));
end;

procedure TfrmRegExpEditor.Deinitialize;
begin
  SaveFormPosition;
  SaveToXML;
end;

procedure TfrmRegExpEditor.LoadFromXML;
begin
  edSample.Text  := TGeneral.XMLFile.ReadString(C_SECTION_MAIN, 'SampleText', '');
  pnlRight.Width := TGeneral.XMLFile.ReadInteger(C_SECTION_MAIN, 'pnlRight.Width', 350);
end;

procedure TfrmRegExpEditor.SaveToXML;
begin
  TGeneral.XMLFile.WriteString(C_SECTION_MAIN, 'SampleText', edSample.Text);
  TGeneral.XMLFile.WriteInteger(C_SECTION_MAIN, 'pnlRight.Width', pnlRight.Width);
end;

procedure TfrmRegExpEditor.Translate;
begin
  aCopy.Caption               := TLang.Lang.Translate('Copy');
  aPaste.Caption              := TLang.Lang.Translate('Paste');
  aSelectAll.Caption          := TLang.Lang.Translate('SelectAll');
  btnCancel.Caption           := TLang.Lang.Translate('Cancel');
  btnOk.Caption               := TLang.Lang.Translate('Ok');
  gbOptions.Caption           := TLang.Lang.Translate('Options');
  gbRegularExpression.Caption := TLang.Lang.Translate('RegExpTemplate');
  gbResults.Caption           := TLang.Lang.Translate('Results');
  gbSampleText.Caption        := TLang.Lang.Translate('SampleText');
  lblExamples.Caption         := TLang.Lang.Translate('Examples');
  lblTemplateName.Caption     := TLang.Lang.Translate('TemplateName');
  lblGroupIndex.Caption       := TLang.Lang.Translate('GroupIndex');
end;

function TfrmRegExpEditor.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

function TfrmRegExpEditor.GetPattern_: string;
begin
  Result := edRegEx.Text;
end;

function TfrmRegExpEditor.GetTemplateName: string;
begin
  Result := edtTemplateName.Text;
end;

procedure TfrmRegExpEditor.SetTemplateName(const Value: string);
begin
  edtTemplateName.Text := Value;
end;

procedure TfrmRegExpEditor.SetGroupIndex(const Value: Integer);
begin
  edtGroupIndex.ValueInt := Value;
end;

function TfrmRegExpEditor.GetGroupIndex: Integer;
begin
  Result := edtGroupIndex.ValueInt
end;

procedure TfrmRegExpEditor.SetPattern(const Value: string);
begin
  edRegEx.Text := Value;
end;

procedure TfrmRegExpEditor.aTestExecute(Sender: TObject);
var
  Match   : TMatch;
  Options : TRegExOptions;
  RegExp  : TRegEx;
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
    RegExp := TRegEx.Create(Pattern, Options);
    Match  := RegExp.Match(edSample.Text);
    if Match.Success then
    begin
      AddMatchToTree(Match);
      edtResult.Text := GetStringFromMatches(edSample.Text, Pattern, edtGroupIndex.ValueInt);
    end
    else
      TMessageDialog.ShowInfo(TLang.Lang.Translate('NoMatchFound'));
   tvResults.FullExpand;
  except
    on e: Exception do
    begin
      LogWriter.Write(ddError, 'TfrmRegExpEditor.TestExecute', e.Message);
      TMessageDialog.ShowError(e.Message);
    end;
  end;
end;

procedure TfrmRegExpEditor.AddMatchToTree(aMatch: TMatch);
var
  Group     : TGroup;
  MatchNode : TTreeNode;
  NodeText  : string;
begin
  NodeText  := aMatch.Value.Replace(#10, ' ').Replace(#13, '').Replace(#9, ' ');
  MatchNode := tvResults.Items.AddChild(nil, 'Group 0: ' + NodeText);
  if (aMatch.Groups.Count > 1) then
  begin
    for var i := 1 to aMatch.Groups.Count - 1 do
    begin
      Group := aMatch.Groups.Item[i];
      tvResults.Items.AddChild(MatchNode, 'Group ' + i.ToString + ': ' + Group.Value);
    end;
  end;
  aMatch := aMatch.NextMatch;
  if aMatch.Success then
    AddMatchToTree(aMatch);
end;

procedure TfrmRegExpEditor.cbSetOfTemplatesCloseUp(Sender: TObject);
begin
  inherited;
  if cbSetOfTemplates.ItemIndex > -1 then
    Pattern := TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]).StringValue;
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
