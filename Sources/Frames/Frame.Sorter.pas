unit Frame.Sorter;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Common.Types, DaImages, System.RegularExpressions, Frame.Source,
  System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Files.Utils, Frame.Custom;
{$ENDREGION}

type
  TframeSorter = class(TframeSource)
    OpenDialog: TFileOpenDialog;
    procedure aAddExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aEditExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstTreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
  private const
    COL_MASK        = 0;
    COL_PATH        = 1;
    COL_OPEN_DIALOG = 2;
    COL_INFO        = 3;

    C_IDENTITY_NAME = 'frameSorter';
  protected
    function GetIdentityName: string; override;
    procedure SaveToXML; override;
    procedure LoadFromXML; override;
    procedure UpdateProject; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Translate; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
  end;

implementation

{$R *.dfm}

{ TframeSorter }

constructor TframeSorter.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TSorterPath);
end;

destructor TframeSorter.Destroy;
begin

  inherited;
end;

procedure TframeSorter.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  vstTree.FullExpand;
  Translate;
end;

procedure TframeSorter.Deinitialize;
begin
  inherited;

end;

procedure TframeSorter.Translate;
begin
  inherited;
  vstTree.Header.Columns[COL_MASK].Text := TLang.Lang.Translate('Mask');
  vstTree.Header.Columns[COL_PATH].Text := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_INFO].Text := TLang.Lang.Translate('Info');
end;

procedure TframeSorter.UpdateProject;
begin
  inherited;
  LoadFromXML;
end;

function TframeSorter.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeSorter.LoadFromXML;

 procedure LoadNode;
  var
    arrData: TSorterPath;
    Data: PSorterPath;
    NewNode: PVirtualNode;
    arrPath: TSorterPathArray;
  begin
    inherited;
    arrPath := TGeneral.GetSorterPathList;
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

procedure TframeSorter.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PSorterPath;
  begin
    Data := aNode^.GetData;
    TGeneral.XMLParams.Attributes.AddNode;
    TGeneral.XMLParams.Attributes.SetAttributeValue('Path', Data.Path);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Mask', Data.Mask);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Info', Data.Info);
    TGeneral.XMLParams.WriteAttributes;
  end;

var
  Node: PVirtualNode;
  Section: string;
begin
  inherited;
  if not TGeneral.CurrentProject.Hash.IsEmpty then
    Section := 'Sorter.' + TGeneral.CurrentProject.Hash
  else
    Section := 'Sorter';
  TGeneral.XMLParams.EraseSection(Section);
  TGeneral.XMLParams.CurrentSection := Section;
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

procedure TframeSorter.aAddExecute(Sender: TObject);
var
  NewNode: PVirtualNode;
begin
  inherited;
  vstTree.ClearSelection;
  NewNode := vstTree.AddChild(nil);
  vstTree.Selected[NewNode] := True;
end;

procedure TframeSorter.aDeleteExecute(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    vstTree.DeleteNode(vstTree.FocusedNode);
end;

procedure TframeSorter.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframeSorter.aEditExecute(Sender: TObject);
var
  Data: PSorterPath;
begin
  inherited;
   if Assigned(vstTree.FocusedNode) then
   begin
     Data := vstTree.FocusedNode.GetData;
     TFileUtils.ShellOpen(Data.Path);
   end;
end;

procedure TframeSorter.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframeSorter.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
end;

procedure TframeSorter.vstTreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
var
  Data: PSorterPath;
begin
  inherited;
  if Assigned(HitInfo.HitNode) and (HitInfo.HitColumn = COL_OPEN_DIALOG) then
  begin
    Data := HitInfo.HitNode.GetData;
    if TDirectory.Exists(Data^.Path) then
      OpenDialog.DefaultFolder := Data^.Path
    else
      OpenDialog.DefaultFolder := TDirectory.GetCurrentDirectory;
    if OpenDialog.Execute then
      Data^.Path := OpenDialog.FileName;
  end;
end;

procedure TframeSorter.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PSorterPath;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_MASK:
      Result := CompareText(Data1^.Mask, Data2^.Mask);
    COL_INFO:
      Result := CompareText(Data1^.Info, Data2^.Info);
    COL_PATH:
      Result := CompareText(Data1^.Path, Data2^.Path);
  end;
end;

procedure TframeSorter.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeSorter.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PATH, COL_INFO, COL_MASK]);
end;

procedure TframeSorter.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PSorterPath;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeSorter.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
begin
  inherited;
  if (Column = COL_OPEN_DIALOG) and (Kind in [ikNormal, ikSelected]) then
    ImageIndex := 5;
end;

procedure TframeSorter.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PSorterPath;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PATH:
      CellText := Data^.Path;
    COL_INFO:
      CellText := Data^.Info;
    COL_MASK:
      CellText := Data^.Mask;
  end
end;

procedure TframeSorter.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;NewText: string);
var
  Data: PSorterPath;
begin
  inherited;
  Data := Node^.GetData;
  case Column of
    COL_PATH:
      Data^.Path := NewText;
    COL_INFO:
      Data^.Info := NewText;
    COL_MASK:
      Data^.Mask := NewText;
  end;
end;

end.
