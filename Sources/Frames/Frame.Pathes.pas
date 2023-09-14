unit Frame.Pathes;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Files.Utils,
  Vcl.WinXPanels, Frame.Custom;
{$ENDREGION}

type
  TframePathes = class(TframeSource)
    OpenDialog: TFileOpenDialog;
    procedure aAddExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aEditExecute(Sender: TObject);
    procedure aEditUpdate(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeClick(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
  private const
    COL_PATH        = 0;
    COL_OPEN_DIALOG = 1;
    COL_INFO        = 2;
    COL_WITH_SUBDIR = 3;

    C_IDENTITY_NAME = 'framePathes';
  private
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  protected
    function GetIdentityName: string; override;
    procedure SaveToXML; override;
    procedure LoadFromXML; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Translate; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure SearchText(const aText: string); override;
  end;

implementation

{$R *.dfm}

{ TframeActiveOrders }

constructor TframePathes.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TParamPath);
end;

destructor TframePathes.Destroy;
begin

  inherited;
end;

function TframePathes.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframePathes.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  vstTree.FullExpand;
  Translate;
end;

procedure TframePathes.Translate;
begin
  inherited;
  vstTree.Header.Columns[COL_INFO].Text        := TLang.Lang.Translate('Info');
  vstTree.Header.Columns[COL_PATH].Text        := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_WITH_SUBDIR].Text := TLang.Lang.Translate('WithSubdir');
end;

procedure TframePathes.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframePathes.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PParamPath;
  begin
    Data := aNode^.GetData;
    TGeneral.XMLParams.Attributes.AddNode;
    TGeneral.XMLParams.Attributes.SetAttributeValue('Path', Data.Path);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Info', Data.Info);
    TGeneral.XMLParams.Attributes.SetAttributeValue('WithSubdir', Data.WithSubdir);
    TGeneral.XMLParams.WriteAttributes;
  end;

var
  Node: PVirtualNode;
begin
  inherited;
  TGeneral.XMLParams.Open;
  try
    TGeneral.XMLParams.EraseSection('Path');
    TGeneral.XMLParams.CurrentSection := 'Path';
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

procedure TframePathes.LoadFromXML;

  procedure LoadNode;
  var
    arrData: TParamPath;
    Data: PParamPath;
    NewNode: PVirtualNode;
    arrPath: TArrayRecord<TParamPath>;
  begin
    inherited;
    arrPath := TGeneral.GetPathList;
    for arrData in arrPath do
    begin
      NewNode := vstTree.AddChild(nil);
      Data := NewNode.GetData;
      Data^ := arrData;
      vstTree.CheckType[NewNode] := ctCheckBox;
      if arrData.WithSubdir then
        NewNode.CheckState := csCheckedNormal
      else
        NewNode.CheckState := csUnCheckedNormal;
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

procedure TframePathes.aAddExecute(Sender: TObject);
var
  NewNode: PVirtualNode;
begin
  inherited;
  vstTree.ClearSelection;
  NewNode := vstTree.AddChild(nil);
  vstTree.CheckType[NewNode] := ctCheckBox;
  vstTree.Selected[NewNode] := True;
end;

procedure TframePathes.aDeleteExecute(Sender: TObject);
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    vstTree.DeleteNode(vstTree.FocusedNode);
end;

procedure TframePathes.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframePathes.aEditExecute(Sender: TObject);
var
  Data: PParamPath;
begin
  inherited;
   if Assigned(vstTree.FocusedNode) then
   begin
     Data := vstTree.FocusedNode.GetData;
     TFileUtils.ShellOpen(Data.Path);
   end;
end;

procedure TframePathes.aEditUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframePathes.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframePathes.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
end;

procedure TframePathes.vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PParamPath;
begin
  inherited;
  Data := Node.GetData;
  Data.WithSubdir := Node.CheckState = csCheckedNormal;
end;

procedure TframePathes.vstTreeClick(Sender: TObject);
var
  Data: PParamPath;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) and (vstTree.FocusedColumn = COL_OPEN_DIALOG) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TDirectory.Exists(Data^.Path) then
      OpenDialog.DefaultFolder := Data^.Path
    else
      OpenDialog.DefaultFolder := TDirectory.GetCurrentDirectory;
    if OpenDialog.Execute then
      Data^.Path := OpenDialog.FileName;
<<<<<<< HEAD:Sources/Frame.Pathes.pas
=======
    vstTree.FocusedColumn := COL_PATH;
>>>>>>> Development:Sources/Frames/Frame.Pathes.pas
  end;
end;

procedure TframePathes.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PParamPath;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_INFO:
      Result := CompareText(Data1^.Info, Data2^.Info);
    COL_PATH:
      Result := CompareText(Data1^.Path, Data2^.Path);
  end;
end;

procedure TframePathes.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframePathes.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PParamPath;
begin
  inherited;
  Data := Node^.GetData;
  case Column of
    COL_PATH:
      Data^.Path := NewText;
    COL_INFO:
      Data^.Info := NewText;
  end;
end;

procedure TframePathes.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PATH, COL_INFO]);
end;

procedure TframePathes.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PParamPath;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframePathes.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
begin
  inherited;
  if (Column = COL_OPEN_DIALOG) and (Kind in [ikNormal, ikSelected]) then
    ImageIndex := 5;
end;

procedure TframePathes.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PParamPath;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PATH:
      CellText := Data^.Path;
    COL_INFO:
      CellText := Data^.Info;
  end
end;

procedure TframePathes.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframePathes.SearchText(const aText: string);
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
