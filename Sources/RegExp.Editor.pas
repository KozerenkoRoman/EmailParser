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
  Vcl.Samples.Spin, Performer, Vcl.ActnMan, Vcl.ActnColorMaps, Html.Consts;
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
    cbUseRawText          : TCheckBox;
    cbWebColor            : TColorBox;
    edRegEx               : TMemo;
    edSample              : TMemo;
    edtGroupIndex         : TNumberBox;
    edtResult             : TEdit;
    edtTemplateName       : TEdit;
    gbOptions             : TGroupBox;
    gbRegularExpression   : TGroupBox;
    gbResults             : TGroupBox;
    gbSampleText          : TGroupBox;
    lblColor              : TLabel;
    lblExamples           : TLabel;
    lblGroupIndex         : TLabel;
    lblTemplateName       : TLabel;
    lblUseRawText         : TLabel;
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
    procedure tvResultsCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private const
    C_IDENTITY_NAME = 'RegExpEditor';
  private
    function GetGroupIndex: Integer;
    function GetPattern_: string;
    function GetSelectedColor: TColor;
    function GetTemplateName: string;
    function GetUseRawText: Boolean;
    procedure LoadFromXML;
    procedure SaveToXML;
    procedure SetGroupIndex(const Value: Integer);
    procedure SetPattern(const Value: string);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetTemplateName(const Value: string);
    procedure SetUseRawText(const Value: Boolean);

    property GroupIndex    : Integer read GetGroupIndex    write SetGroupIndex;
    property Pattern       : string  read GetPattern_      write SetPattern;
    property SelectedColor : TColor  read GetSelectedColor write SetSelectedColor;
    property TemplateName  : string  read GetTemplateName  write SetTemplateName;
    property UseRawText    : Boolean read GetUseRawText    write SetUseRawText;
  protected
    function GetIdentityName: string; override;
    procedure AddMatchToTree(aMatch: TMatch);
  public
    class function GetPattern(var aData: TRegExpData): TModalResult;

    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

implementation

{$R *.dfm}

class function TfrmRegExpEditor.GetPattern(var aData: TRegExpData): TModalResult;
begin
  Result := mrCancel;
  with TfrmRegExpEditor.Create(nil) do
    try
      Initialize;
      Pattern       := aData.RegExpTemplate;
      TemplateName  := aData.ParameterName;
      GroupIndex    := aData.GroupIndex;
      SelectedColor := aData.Color;
      UseRawText    := aData.UseRawText;
      if (ShowModal = mrOk) then
      begin
        aData.RegExpTemplate := Pattern;
        aData.ParameterName  := TemplateName;
        aData.GroupIndex     := GroupIndex;
        aData.Color          := SelectedColor;
        aData.UseRawText     := UseRawText;
        Result := mrOk;
      end;
      Deinitialize;
    finally
      Free;
    end;
end;

procedure TfrmRegExpEditor.Initialize;
begin
  inherited;
  edtGroupIndex.CurrencyString := '';
  tbPattern.ButtonHeight := C_ICON_SIZE;
  tbPattern.ButtonWidth  := C_ICON_SIZE;
  tbPattern.Height       := C_ICON_SIZE + 2;

  LoadFromXML;
  Translate;
  cbSetOfTemplates.Clear;
  for var i := Low(ArrayPatterns) to High(ArrayPatterns) do
    cbSetOfTemplates.Items.AddObject(ArrayPatterns[i].Name, TStringObject.Create(ArrayPatterns[i].Pattern));

  cbWebColor.Items.Clear;
  for var item in arrWebColors do
    cbWebColor.Items.AddObject(item.Name, TObject(item.Color));
end;

procedure TfrmRegExpEditor.Deinitialize;
begin
  inherited;
  SaveToXML;
end;

procedure TfrmRegExpEditor.LoadFromXML;
begin
  edSample.Text  := TGeneral.XMLFile.ReadString(C_SECTION_MAIN, 'SampleText', '').Replace(#10, #13#10);
  pnlRight.Width := TGeneral.XMLFile.ReadInteger(C_SECTION_MAIN, 'pnlRight.Width', 350);
end;

procedure TfrmRegExpEditor.SaveToXML;
begin
  TGeneral.XMLFile.WriteString(C_SECTION_MAIN, 'SampleText', edSample.Text);
  TGeneral.XMLFile.WriteInteger(C_SECTION_MAIN, 'pnlRight.Width', pnlRight.Width);
end;

procedure TfrmRegExpEditor.Translate;
begin
  inherited;
  aCopy.Caption               := TLang.Lang.Translate('Copy');
  aPaste.Caption              := TLang.Lang.Translate('Paste');
  aSelectAll.Caption          := TLang.Lang.Translate('SelectAll');
  btnCancel.Caption           := TLang.Lang.Translate('Cancel');
  btnOk.Caption               := TLang.Lang.Translate('Ok');
  gbOptions.Caption           := TLang.Lang.Translate('Options');
  gbRegularExpression.Caption := TLang.Lang.Translate('RegExpTemplate');
  gbResults.Caption           := TLang.Lang.Translate('Results');
  gbSampleText.Caption        := TLang.Lang.Translate('SampleText');
  lblColor.Caption            := TLang.Lang.Translate('Color');
  lblExamples.Caption         := TLang.Lang.Translate('Examples');
  lblGroupIndex.Caption       := TLang.Lang.Translate('GroupIndex');
  lblTemplateName.Caption     := TLang.Lang.Translate('TemplateName');
  lblUseRawText.Caption       := TLang.Lang.Translate('UseRawText');
end;

procedure TfrmRegExpEditor.tvResultsCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  inherited;
  if (Node.Level >= 1) then
    Sender.Canvas.Brush.Color := cbWebColor.Selected
  else
    DefaultDraw := True;
end;

procedure TfrmRegExpEditor.aTestExecute(Sender: TObject);
var
  Match   : TMatch;
  Options : TRegExOptions;
  RegExp  : TRegEx;
begin
  inherited;
  tvResults.Items.Clear;
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
    on E: Exception do
    begin
      LogWriter.Write(ddError, 'TfrmRegExpEditor.TestExecute', E.Message);
      TMessageDialog.ShowError(E.Message);
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
  if (cbSetOfTemplates.ItemIndex > -1) then
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

function TfrmRegExpEditor.GetUseRawText: Boolean;
begin
  Result := cbUseRawText.Checked;
end;

procedure TfrmRegExpEditor.SetTemplateName(const Value: string);
begin
  edtTemplateName.Text := Value;
end;

procedure TfrmRegExpEditor.SetSelectedColor(const Value: TColor);
begin
  cbWebColor.Selected := Value;
end;

procedure TfrmRegExpEditor.SetUseRawText(const Value: Boolean);
begin
  cbUseRawText.Checked := Value;
end;

procedure TfrmRegExpEditor.SetGroupIndex(const Value: Integer);
begin
  edtGroupIndex.ValueInt := Value;
end;

function TfrmRegExpEditor.GetSelectedColor: TColor;
begin
  Result := cbWebColor.Selected;
end;

function TfrmRegExpEditor.GetGroupIndex: Integer;
begin
  Result := edtGroupIndex.ValueInt
end;

procedure TfrmRegExpEditor.SetPattern(const Value: string);
begin
  edRegEx.Text := Value;
end;

end.
