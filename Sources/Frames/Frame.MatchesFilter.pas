unit Frame.MatchesFilter;

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
  RegExp.Utils, Publishers.Interfaces;
{$ENDREGION}

type
  TframeMatchesFilter = class(TframeSource, IConfig)
    aAllCheck     : TAction;
    aAllUnCheck   : TAction;
    aFilter       : TAction;
    btnAllCheck   : TToolButton;
    btnAllUnCheck : TToolButton;
    btnFilter     : TToolButton;
    procedure aAllCheckExecute(Sender: TObject);
    procedure aAllUnCheckExecute(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private const
    COL_PARAM_NAME = 0;

    C_IDENTITY_NAME = 'frameMatchesFilter';
  private
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);

    //IConfig
    procedure IConfig.UpdateRegExp = LoadFromXML;
    procedure UpdateFilter;

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

{ TframeMatchesFilter }

constructor TframeMatchesFilter.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TRegExpData);
  TPublishers.ConfigPublisher.Subscribe(Self);
end;

destructor TframeMatchesFilter.Destroy;
begin
  TPublishers.ConfigPublisher.Unsubscribe(Self);
  inherited;
end;

function TframeMatchesFilter.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeMatchesFilter.Initialize;
begin
  inherited Initialize;
  vstTree.Header.Options := vstTree.Header.Options + [hoAutoResize];
  tbMain.ButtonHeight := C_ICON_SIZE div 2;
  tbMain.ButtonWidth  := C_ICON_SIZE div 2;
  tbMain.Height       := C_ICON_SIZE div 2 + 2;

  Translate;
end;

procedure TframeMatchesFilter.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeMatchesFilter.Translate;
begin
  inherited;
  vstTree.Header.Columns[COL_PARAM_NAME].Text := TLang.Lang.Translate('TemplateName');
  aAllCheck.Hint   := TLang.Lang.Translate('AllCheck');
  aAllUnCheck.Hint := TLang.Lang.Translate('AllUnCheck');
  aFilter.Hint     := TLang.Lang.Translate('Filter');
end;

procedure TframeMatchesFilter.LoadFromXML;

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
      vstTree.CheckType[NewNode] := ctCheckBox;
      NewNode.CheckState := csCheckedNormal
    end;
  end;

begin
  inherited;
  TGeneral.XMLParams.Open;
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    LoadNode;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeMatchesFilter.SaveToXML;
begin
  inherited;

end;

procedure TframeMatchesFilter.UpdateFilter;
begin
  //nothing
end;

procedure TframeMatchesFilter.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PRegExpData;
begin
  Data := Node^.GetData;
  TargetCanvas.Brush.Color := Data.Color;
  TargetCanvas.FillRect(CellRect);
end;

procedure TframeMatchesFilter.vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node.GetData;
  Data.UseRawText := Node.CheckState = csCheckedNormal;
end;

procedure TframeMatchesFilter.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeMatchesFilter.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PRegExpData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PARAM_NAME:
      CellText := Data^.ParameterName;
  end;
end;

procedure TframeMatchesFilter.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeMatchesFilter.SearchText(const aText: string);
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

procedure TframeMatchesFilter.aAllCheckExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  inherited;
  vstTree.BeginUpdate;
  try
    Node := vstTree.RootNode.FirstChild;
    while Assigned(Node) do
    begin
      Node.CheckState := TCheckState.csCheckedNormal;
      Node := vstTree.GetNextSibling(Node);
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeMatchesFilter.aAllUnCheckExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  inherited;
  vstTree.BeginUpdate;
  try
    Node := vstTree.RootNode.FirstChild;
    while Assigned(Node) do
    begin
      Node.CheckState := TCheckState.csUncheckedNormal;
      Node := vstTree.GetNextSibling(Node);
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeMatchesFilter.aFilterExecute(Sender: TObject);
var
  Node: PVirtualNode;
  i: Integer;
begin
  inherited;
  i := 0;
  Node := vstTree.RootNode.FirstChild;
  while Assigned(Node) do
  begin
    TGeneral.RegExpColumns[i].IsSelected := Node.CheckState = TCheckState.csCheckedNormal;
    Node := vstTree.GetNextSibling(Node);
    Inc(i);
  end;
  TPublishers.ConfigPublisher.UpdateFilter;
end;

end.
