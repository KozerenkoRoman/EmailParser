unit Frame.RegExpParameters;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Publishers,
  VCLTee.TeCanvas, Global.Resources, Winapi.msxml, RegExp.Editor, Vcl.WinXPanels, Frame.Custom;
{$ENDREGION}

type
  TframeRegExpParameters = class(TFrameSource)
    aDeleteSet        : TAction;
    aSaveSet          : TAction;
    aSaveSetAs        : TAction;
    btnDeleteSet      : TToolButton;
    btnSaveSet        : TToolButton;
    cbSetOfTemplates  : TComboBox;
    lblSetOfTemplates : TLabel;
    miSaveSet         : TMenuItem;
    miSaveSetAs       : TMenuItem;
    pnlSettings       : TPanel;
    tbSettings        : TToolBar;
    procedure aAddExecute(Sender: TObject);
    procedure aAddUpdate(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteSetExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aEditExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSaveSetAsExecute(Sender: TObject);
    procedure aSaveSetExecute(Sender: TObject);
    procedure aSaveSetUpdate(Sender: TObject);
    procedure cbSetOfTemplatesChange(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
  private const
    COL_PARAM_NAME      = 0;
    COL_REGEXP_TEMPLATE = 1;
    COL_GROUP_INDEX     = 2;

    C_IDENTITY_NAME = 'frameRegExpParameters';
  private
    function SaveSetOfTemplate(const aSection, aName: string): string;
    procedure RestoreSetOfTemplate(const aSection: string);
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
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
    procedure SearchText(const aText: string); override;
  end;

implementation

{$R *.dfm}

{ TframeRegExpParameters }

constructor TframeRegExpParameters.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TRegExpData);
end;

destructor TframeRegExpParameters.Destroy;
begin
  for var i := 0 to cbSetOfTemplates.Items.Count - 1 do
    cbSetOfTemplates.Items.Objects[i].Free;
  cbSetOfTemplates.Items.Clear;
  inherited;
end;

function TframeRegExpParameters.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeRegExpParameters.Initialize;
begin
  inherited Initialize;
  tbSettings.ButtonHeight := C_ICON_SIZE;
  tbSettings.ButtonWidth  := C_ICON_SIZE;
  tbSettings.Height       := C_ICON_SIZE + 2;

  LoadFromXML;
  vstTree.FullExpand;
  Translate;
end;

procedure TframeRegExpParameters.Translate;
begin
  inherited;
  aSaveSet.Caption                                 := TLang.Lang.Translate('Save');
  aSaveSetAs.Caption                               := TLang.Lang.Translate('SaveAs');
  aDeleteSet.Hint                                  := TLang.Lang.Translate('Delete');
  lblSetOfTemplates.Caption                        := TLang.Lang.Translate('SetOfTemplates');
  vstTree.Header.Columns[COL_PARAM_NAME].Text      := TLang.Lang.Translate('TemplateName');
  vstTree.Header.Columns[COL_REGEXP_TEMPLATE].Text := TLang.Lang.Translate('RegExpTemplate');
  vstTree.Header.Columns[COL_GROUP_INDEX].Text     := TLang.Lang.Translate('GroupIndex');
end;

procedure TframeRegExpParameters.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PRegExpData;
  begin
    Data := aNode^.GetData;
    TGeneral.XMLParams.Attributes.AddNode;
    TGeneral.XMLParams.Attributes.SetAttributeValue('ParameterName', Data.ParameterName);
    TGeneral.XMLParams.Attributes.SetAttributeValue('RegExpTemplate', Data.RegExpTemplate);
    TGeneral.XMLParams.Attributes.SetAttributeValue('GroupIndex', Data.GroupIndex);
    TGeneral.XMLParams.WriteAttributes;
  end;

var
  Node: PVirtualNode;
begin
  inherited;
  TGeneral.XMLParams.Open;
  try
    TGeneral.XMLParams.EraseSection('RegExpParameters');
    TGeneral.XMLParams.CurrentSection := 'RegExpParameters';
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

procedure TframeRegExpParameters.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeRegExpParameters.aAddExecute(Sender: TObject);
var
  NewNode: PVirtualNode;
begin
  inherited;
  vstTree.ClearSelection;
  NewNode := vstTree.AddChild(nil);
  vstTree.Selected[NewNode] := True;
end;

procedure TframeRegExpParameters.aAddUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := True;
end;

procedure TframeRegExpParameters.aDeleteExecute(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    vstTree.DeleteNode(vstTree.FocusedNode);
end;

procedure TframeRegExpParameters.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeRegExpParameters.aEditExecute(Sender: TObject);
var
  Data: PRegExpData;
  PatternResult: TArray<string>;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    PatternResult := TfrmRegExpEditor.GetPattern(Data^.RegExpTemplate, Data^.ParameterName, Data^.GroupIndex);
    if (Length(PatternResult) >= 3) then
    begin
      Data^.RegExpTemplate := PatternResult[0];
      Data^.ParameterName  := PatternResult[1];
      Data^.GroupIndex     := String.ToInteger(PatternResult[2]);
    end;
  end;
end;

procedure TframeRegExpParameters.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframeRegExpParameters.LoadFromXML;

  procedure LoadNode;
  var
    arrParams : TArrayRecord<TRegExpData>;
    Data      : PRegExpData;
    NewNode   : PVirtualNode;
  begin
    inherited;
    arrParams := TGeneral.GetRegExpParametersList;
    for var Param in arrParams do
    begin
      NewNode := vstTree.AddChild(nil);
      Data    := NewNode.GetData;
      Data^   := Param;
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
end;

procedure TframeRegExpParameters.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
  TPublishers.UpdateXMLPublisher.UpdateXML;
end;

procedure TframeRegExpParameters.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PRegExpData;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_PARAM_NAME:
      Result := CompareText(Data1^.ParameterName, Data2^.ParameterName);
    COL_REGEXP_TEMPLATE:
      Result := CompareText(Data1^.RegExpTemplate, Data2^.RegExpTemplate);
    COL_GROUP_INDEX:
      Result := CompareValue(Data1^.GroupIndex, Data2^.GroupIndex);
  end;
end;

procedure TframeRegExpParameters.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeRegExpParameters.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node^.GetData;
  case Column of
    COL_PARAM_NAME:
      Data^.ParameterName := NewText;
    COL_REGEXP_TEMPLATE:
      Data^.RegExpTemplate := NewText;
    COL_GROUP_INDEX:
      Data^.GroupIndex := StrToIntDef(NewText, 0);
  end;
end;

procedure TframeRegExpParameters.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PARAM_NAME, COL_REGEXP_TEMPLATE, COL_GROUP_INDEX]);
end;

procedure TframeRegExpParameters.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeRegExpParameters.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PRegExpData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PARAM_NAME:
      CellText := Data^.ParameterName;
    COL_REGEXP_TEMPLATE:
      CellText := Data^.RegExpTemplate;
    COL_GROUP_INDEX:
      CellText := Data^.GroupIndex.ToString;
  end;
end;

procedure TframeRegExpParameters.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeRegExpParameters.SearchText(const aText: string);
var
  Node: PVirtualNode;
begin
  inherited;
  vstTree.BeginUpdate;
  vstTree.FullExpand(nil);
  try
    Node := vstTree.IterateSubtree(nil, SearchForText, Pointer(aText));
    if Assigned(Node) then
    begin
      vstTree.FocusedNode := Node;
      vstTree.Selected[Node] := True;
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeRegExpParameters.aSaveSetExecute(Sender: TObject);
var
  str: TStringObject;
begin
  inherited;
  if (cbSetOfTemplates.ItemIndex > -1) then
  begin
    str := TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]);
    SaveSetOfTemplate(str.StringValue, cbSetOfTemplates.Text);
  end;
end;

procedure TframeRegExpParameters.aSaveSetAsExecute(Sender: TObject);
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
    Section := SaveSetOfTemplate(string.Empty, NewName);
    cbSetOfTemplates.Items.AddObject(NewName, TStringObject.Create(Section));
    cbSetOfTemplates.ItemIndex := cbSetOfTemplates.Items.Count - 1;
  end;
end;

procedure TframeRegExpParameters.aSaveSetUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := (cbSetOfTemplates.ItemIndex > -1);
end;

procedure TframeRegExpParameters.cbSetOfTemplatesChange(Sender: TObject);
begin
  inherited;
  if (cbSetOfTemplates.ItemIndex > -1) then
    RestoreSetOfTemplate(TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]).StringValue);
end;

procedure TframeRegExpParameters.aDeleteSetExecute(Sender: TObject);
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

procedure TframeRegExpParameters.RestoreSetOfTemplate(const aSection: string);
var
  Data: PRegExpData;
  Node: PVirtualNode;
begin
  TGeneral.XMLParams.CurrentSection := TGeneral.XMLParams.GetXPath(C_SECTION_TEMPLATE_SETS, aSection);
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    while not TGeneral.XMLParams.IsLastKey do
    begin
      if TGeneral.XMLParams.ReadAttributes then
      begin
        Node := vstTree.AddChild(nil);
        Data := Node.GetData;
        Data^.ParameterName  := TGeneral.XMLParams.Attributes.GetAttributeValue('ParameterName', '');
        Data^.RegExpTemplate := TGeneral.XMLParams.Attributes.GetAttributeValue('RegExpTemplate', '');
        Data^.GroupIndex     := TGeneral.XMLParams.Attributes.GetAttributeValue('GroupIndex', 0);
      end;
      TGeneral.XMLParams.NextKey;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
    vstTree.EndUpdate;
  end;
end;

function TframeRegExpParameters.SaveSetOfTemplate(const aSection, aName: string): string;

 procedure SaveNode(const aXmlNode: IXMLDOMNode; const aTreeNode: PVirtualNode);
  var
    Data: PRegExpData;
  begin
    if Assigned(aXmlNode) and Assigned(aTreeNode) then
    begin
      Data := aTreeNode^.GetData;
      with TGeneral.XMLParams do
      begin
        Attributes.Node := aXmlNode;
        Attributes.SetAttributeValue('ParameterName', Data^.ParameterName);
        Attributes.SetAttributeValue('RegExpTemplate', Data^.RegExpTemplate);
        Attributes.SetAttributeValue('GroupIndex', Data^.GroupIndex);
        WriteAttributes;
      end;
    end;
  end;

var
  iItemNode : IXMLDOMNode;
  iSetNode  : IXMLDOMNode;
  NewSet    : string;
  TreeNode  : PVirtualNode;
begin
  inherited;
  if aSection.IsEmpty then
    NewSet := 'Set.' + TGeneral.GetCounterValue.ToString
  else
    NewSet := aSection;
  Result := NewSet;

  TGeneral.XMLParams.Open;
  try
    iSetNode := TGeneral.XMLParams.GetNode(TGeneral.XMLParams.GetXPath(C_SECTION_TEMPLATE_SETS, NewSet));
    if aSection.IsEmpty then
      with TGeneral.XMLParams do
      begin
        Attributes.Node := iSetNode;
        Attributes.SetAttributeValue('Name', aName);
        WriteAttributes;
      end
    else
      TGeneral.XMLParams.EraseSection(TGeneral.XMLParams.GetXPath(C_SECTION_TEMPLATE_SETS, NewSet));

    TreeNode := vstTree.GetFirst;
    while Assigned(TreeNode) do
    begin
      iItemNode := TGeneral.XMLParams.XMLDomDocument.createNode(varNull, 'Item', '');
      iSetNode.appendChild(iItemNode);
      SaveNode(iItemNode, TreeNode);
      TreeNode := TreeNode.NextSibling;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
    TGeneral.XMLParams.Save;
  end;
end;

end.
