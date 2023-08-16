unit Frame.RegExpParameters;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Custom, System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles;
{$ENDREGION}

type
  TframeRegExpParameters = class(TframeCustom)
    procedure aAddExecute(Sender: TObject);
    procedure aAddUpdate(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aEditUpdate(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
  private const
    COL_PARAM_NAME      = 0;
    COL_REGEXP_TEMPLATE = 1;

    C_IDENTITY_NAME = 'frameRegExpParameters';
  private
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

  inherited;
end;

function TframeRegExpParameters.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeRegExpParameters.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  vstTree.FullExpand;
  Translate;
end;

procedure TframeRegExpParameters.Translate;
begin
  inherited;
  vstTree.Header.Columns[COL_PARAM_NAME].Text      := TLang.Lang.Translate('ParameterName');
  vstTree.Header.Columns[COL_REGEXP_TEMPLATE].Text := TLang.Lang.Translate('RegExpTemplate');
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

procedure TframeRegExpParameters.aEditUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframeRegExpParameters.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframeRegExpParameters.LoadFromXML;

  procedure LoadNode;
  var
    arrData: TRegExpData;
    Data: PRegExpData;
    NewNode: PVirtualNode;
    arrPath: TArray<TRegExpData>;
  begin
    inherited;
    arrPath := TGeneral.GetRegExpParametersList;
    for arrData in arrPath do
    begin
      NewNode := vstTree.AddChild(nil);
      Data := NewNode.GetData;
      Data^ := arrData;
    end;
  end;

begin
  inherited;
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
  end;
end;

procedure TframeRegExpParameters.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PARAM_NAME, COL_REGEXP_TEMPLATE]);
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

end.
