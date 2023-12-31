﻿unit Frame.RegExp;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Publishers,
  VCLTee.TeCanvas, Global.Resources, Winapi.msxml, RegExp.Editor, Vcl.WinXPanels, Frame.Custom, RegExp.Import,
  RegExp.Utils;
{$ENDREGION}

type
  TframeRegExp = class(TframeSource)
    aDeleteSet        : TAction;
    aDown             : TAction;
    aImportFromXML    : TAction;
    aSaveAs           : TAction;
    aUp               : TAction;
    btnDeleteSet      : TToolButton;
    btnDown           : TToolButton;
    btnImportFromXML  : TToolButton;
    btnSave02         : TToolButton;
    btnSaveSetAs      : TToolButton;
    btnSep04          : TToolButton;
    btnSep05          : TToolButton;
    btnUp             : TToolButton;
    cbSetOfTemplates  : TComboBox;
    lblSetOfTemplates : TLabel;
    pnlSettings       : TPanel;
    tbSettings        : TToolBar;
    procedure aAddExecute(Sender: TObject);
    procedure aAddUpdate(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteSetExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aDownExecute(Sender: TObject);
    procedure aDownUpdate(Sender: TObject);
    procedure aEditExecute(Sender: TObject);
    procedure aImportFromXMLExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveAsExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSaveUpdate(Sender: TObject);
    procedure aUpExecute(Sender: TObject);
    procedure aUpUpdate(Sender: TObject);
    procedure cbSetOfTemplatesChange(Sender: TObject);
    procedure vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
  private const
    COL_PARAM_NAME      = 0;
    COL_REGEXP_TEMPLATE = 1;
    COL_GROUP_INDEX     = 2;
    COL_USE_RAW_TEXT    = 3;
    COL_TYPE_PATTERN    = 4;

    C_IDENTITY_NAME = 'frameRegExp';
  protected
    function GetIdentityName: string; override;
    procedure SaveToXML; override;
    procedure LoadFromXML; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

implementation

{$R *.dfm}

{ TframeRegExp }

constructor TframeRegExp.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TPatternData);
end;

destructor TframeRegExp.Destroy;
begin
  for var i := 0 to cbSetOfTemplates.Items.Count - 1 do
    cbSetOfTemplates.Items.Objects[i].Free;
  cbSetOfTemplates.Items.Clear;
  inherited;
end;

function TframeRegExp.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeRegExp.Initialize;
begin
  inherited Initialize;
  tbSettings.ButtonHeight := C_ICON_SIZE;
  tbSettings.ButtonWidth  := C_ICON_SIZE;
  tbSettings.Height       := C_ICON_SIZE + 2;

  LoadFromXML;
  Translate;
  TPublishers.ConfigPublisher.UpdateRegExp;
end;

procedure TframeRegExp.Deinitialize;
begin
  TGeneral.XMLParams.WriteInteger(C_SECTION_MAIN, 'TemplateIndex', cbSetOfTemplates.ItemIndex, lblSetOfTemplates.Caption);
  inherited Deinitialize;
end;

procedure TframeRegExp.Translate;
begin
  inherited;
  aDeleteSet.Hint           := TLang.Lang.Translate('Delete');
  aDown.Hint                := TLang.Lang.Translate('Down');
  aImportFromXML.Hint       := TLang.Lang.Translate('Import');
  aSave.Hint                := TLang.Lang.Translate('Save');
  aSaveAs.Hint              := TLang.Lang.Translate('SaveAs');
  aUp.Hint                  := TLang.Lang.Translate('Up');
  lblSetOfTemplates.Caption := TLang.Lang.Translate('SetOfTemplates');
  vstTree.Header.Columns[COL_PARAM_NAME].Text      := TLang.Lang.Translate('TemplateName');
  vstTree.Header.Columns[COL_REGEXP_TEMPLATE].Text := TLang.Lang.Translate('RegExpTemplate');
  vstTree.Header.Columns[COL_GROUP_INDEX].Text     := TLang.Lang.Translate('GroupIndex');
  vstTree.Header.Columns[COL_USE_RAW_TEXT].Text    := TLang.Lang.Translate('UseRawText');
  vstTree.Header.Columns[COL_TYPE_PATTERN].Text    := TLang.Lang.Translate('TypePattern');
end;

procedure TframeRegExp.LoadFromXML;

  procedure LoadNode;
  var
    Node: PVirtualNode;
    Data: PPatternData;
  begin
    for var Item in TGeneral.PatternList do
    begin
      Node := vstTree.AddChild(nil);
      Data := Node^.GetData;
      Data^.Assign(Item^);
      vstTree.CheckType[Node] := ctCheckBox;
      if Item^.UseRawText then
        Node.CheckState := csCheckedNormal
      else
        Node.CheckState := csUnCheckedNormal;
    end;
  end;

  procedure LoadSetsOfTemplate;
  var
    arrSections: TArray<string>;
    Name: string;
  begin
    for var i := 0 to cbSetOfTemplates.Items.Count - 1 do
      cbSetOfTemplates.Items.Objects[i].Free;
    cbSetOfTemplates.Items.Clear;
    arrSections := TGeneral.XMLParams.ReadSection(C_SECTION_TEMPLATE_SETS);
    for var Section in arrSections do
    begin
      if TGeneral.XMLParams.ReadAttributes(C_SECTION_TEMPLATE_SETS, Section) then
        Name := TGeneral.XMLParams.Attributes.GetAttributeValue('Name', Section);
      cbSetOfTemplates.Items.AddObject(Name, TStringObject.Create(Section));
    end;
  end;

begin
  inherited;
  LoadSetsOfTemplate;
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    LoadNode;
  finally
    vstTree.EndUpdate;
  end;
  cbSetOfTemplates.ItemIndex := TGeneral.XMLParams.ReadInteger(C_SECTION_MAIN, 'TemplateIndex', -1);
  if (cbSetOfTemplates.ItemIndex > -1) then
    cbSetOfTemplatesChange(nil);
end;

procedure TframeRegExp.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PPatternData;
  begin
    Data := aNode^.GetData;
    TGeneral.XMLParams.Attributes.AddNode;
    TGeneral.XMLParams.Attributes.SetAttributeValue('TypePattern', Data^.TypePattern);
    TGeneral.XMLParams.Attributes.SetAttributeValue('ParameterName', Data^.ParameterName);
    TGeneral.XMLParams.Attributes.SetAttributeValue('RegExpTemplate', Data^.Pattern);
    TGeneral.XMLParams.Attributes.SetAttributeValue('GroupIndex', Data^.GroupIndex);
    TGeneral.XMLParams.Attributes.SetAttributeValue('UseRawText', Data^.UseRawText);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Color', Data^.Color);
    TGeneral.XMLParams.WriteAttributes;
  end;

var
  Node: PVirtualNode;
begin
  inherited;
  TGeneral.XMLParams.EraseSection(C_SECTION_REGEXP);
  TGeneral.XMLParams.CurrentSection := C_SECTION_REGEXP;
  try
    Node := vstTree.GetFirst;
    while Assigned(Node) do
    begin
      SaveNode(Node);
      Node := Node.NextSibling;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
    TGeneral.XMLParams.Save;
  end;
end;

procedure TframeRegExp.aAddExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PPatternData;
begin
  inherited;
  vstTree.ClearSelection;
  Node := vstTree.AddChild(nil);
  vstTree.CheckType[Node] := ctCheckBox;
  vstTree.Selected[Node]  := True;
  Data := Node^.GetData;
  Data^.Color := arrWebColors[Random(High(arrWebColors))].Color;
end;

procedure TframeRegExp.aAddUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := True;
end;

procedure TframeRegExp.aDeleteExecute(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    vstTree.DeleteNode(vstTree.FocusedNode);
end;

procedure TframeRegExp.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeRegExp.aEditExecute(Sender: TObject);
var
  Data: PPatternData;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if (TfrmRegExpEditor.ShowDocument(Data) = mrOk) then
    begin
      if Data^.UseRawText then
        vstTree.FocusedNode.CheckState := csCheckedNormal
      else
        vstTree.FocusedNode.CheckState := csUnCheckedNormal;
    end;
  end;
end;

procedure TframeRegExp.aImportFromXMLExecute(Sender: TObject);
begin
  inherited;
  TfrmImportFromXML.ShowDocument;
  LoadFromXML;
end;

procedure TframeRegExp.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframeRegExp.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PPatternData;
begin
  Data := Node^.GetData;
  if (Column = COL_REGEXP_TEMPLATE) then
  begin
    TargetCanvas.Brush.Color := Data^.Color;
    TargetCanvas.FillRect(CellRect);
  end;
end;

procedure TframeRegExp.vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PPatternData;
begin
  inherited;
  Data := Node.GetData;
  Data^.UseRawText := Node.CheckState = csCheckedNormal;
end;

procedure TframeRegExp.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PPatternData;
begin
  inherited;
  Exit;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_PARAM_NAME:
      Result := CompareText(Data1^.ParameterName, Data2^.ParameterName);
    COL_REGEXP_TEMPLATE:
      Result := CompareText(Data1^.Pattern, Data2^.Pattern);
    COL_GROUP_INDEX:
      Result := CompareValue(Data1^.GroupIndex, Data2^.GroupIndex);
    COL_TYPE_PATTERN:
      Result := CompareText(TLang.Lang.Translate(Data1^.TypePattern.ToString), TLang.Lang.Translate(Data2^.TypePattern.ToString));
  end;
end;

procedure TframeRegExp.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeRegExp.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PPatternData;
begin
  inherited;
  Data := Node^.GetData;
  case Column of
    COL_PARAM_NAME:
      Data^.ParameterName := NewText;
    COL_REGEXP_TEMPLATE:
      Data^.Pattern := NewText;
    COL_GROUP_INDEX:
      Data^.GroupIndex := StrToIntDef(NewText, 0);
  end;
end;

procedure TframeRegExp.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PARAM_NAME, COL_REGEXP_TEMPLATE, COL_GROUP_INDEX]);
end;

procedure TframeRegExp.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PPatternData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeRegExp.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PPatternData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PARAM_NAME:
      CellText := Data^.ParameterName;
    COL_REGEXP_TEMPLATE:
      CellText := Data^.Pattern;
    COL_GROUP_INDEX:
      CellText := Data^.GroupIndex.ToString;
    COL_TYPE_PATTERN:
      CellText := TLang.Lang.Translate(Data^.TypePattern.ToString);
  end;
end;

procedure TframeRegExp.aSaveExecute(Sender: TObject);
var
  str: TStringObject;
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    if (cbSetOfTemplates.ItemIndex > -1) then
    begin
      str := TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]);
      TRegExpUtils.SaveSetOfTemplate(vstTree, str.StringValue, cbSetOfTemplates.Text);
    end;
    SaveToXML;
    TGeneral.PatternList.LoadData;
    TPublishers.ConfigPublisher.UpdateRegExp;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TframeRegExp.aSaveAsExecute(Sender: TObject);
var
  NewName: string;
  Section: string;
begin
  inherited;
  if (cbSetOfTemplates.ItemIndex > -1) then
    NewName := cbSetOfTemplates.Text
  else
    NewName := TLang.Lang.Translate('NewNameSet');
  NewName := InputBox(Application.Title, TLang.Lang.Translate('NewNamePrompt'), NewName);
  if not NewName.IsEmpty then
  begin
    Section := TRegExpUtils.SaveSetOfTemplate(vstTree, string.Empty, NewName);
    cbSetOfTemplates.Items.AddObject(NewName, TStringObject.Create(Section));
    cbSetOfTemplates.ItemIndex := cbSetOfTemplates.Items.Count - 1;
  end;
end;

procedure TframeRegExp.aSaveUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := (cbSetOfTemplates.ItemIndex > -1);
end;

procedure TframeRegExp.aUpExecute(Sender: TObject);
var
  Node: PVirtualNode;
  PrevNode: PVirtualNode;
begin
  inherited;
  Node := vstTree.FocusedNode;
  if Assigned(Node) then
  begin
    PrevNode := Node.PrevSibling;
    if Assigned(PrevNode) then
      vstTree.MoveTo(Node, PrevNode, amInsertBefore, False);
  end;
end;

procedure TframeRegExp.aDownExecute(Sender: TObject);
var
  Node: PVirtualNode;
  NextNode: PVirtualNode;
begin
  inherited;
  Node := vstTree.FocusedNode;
  if Assigned(Node) then
  begin
    NextNode := Node.NextSibling;
    if Assigned(NextNode) then
      vstTree.MoveTo(Node, NextNode, amInsertAfter, False);
  end;
end;

procedure TframeRegExp.aUpUpdate(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    TAction(Sender).Enabled := vstTree.FocusedNode <> vstTree.RootNode.FirstChild
  else
    TAction(Sender).Enabled := False;
end;

procedure TframeRegExp.aDownUpdate(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    TAction(Sender).Enabled := vstTree.FocusedNode <> vstTree.RootNode.LastChild
  else
    TAction(Sender).Enabled := False;
end;

procedure TframeRegExp.cbSetOfTemplatesChange(Sender: TObject);
begin
  inherited;
  if Showing and (cbSetOfTemplates.ItemIndex > -1) then
    TRegExpUtils.RestoreSetOfTemplate(TGeneral.XMLParams, vstTree, TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]).StringValue);
end;

procedure TframeRegExp.aDeleteSetExecute(Sender: TObject);
var
  str: TStringObject;
  xPath: string;
begin
  inherited;
  if (cbSetOfTemplates.ItemIndex > -1) and
    (TMessageDialog.ShowQuestion(Format(TLang.Lang.Translate('DeletePrompt'), [cbSetOfTemplates.Text])) = mrYes) then
  begin
    str := TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]);
    xPath := Concat(C_XPATH_SEPARATOR, TGeneral.XMLParams.RootNode, C_XPATH_SEPARATOR, C_SECTION_TEMPLATE_SETS, C_XPATH_SEPARATOR, str.StringValue);
    TGeneral.XMLParams.DeleteKey(xPath);
    TGeneral.XMLParams.Save;
    cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex].Free;
    cbSetOfTemplates.Items.Delete(cbSetOfTemplates.ItemIndex);
    cbSetOfTemplates.ItemIndex := -1;
  end;
end;

end.
