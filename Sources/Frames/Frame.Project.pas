﻿unit Frame.Project;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Files.Utils,
  Vcl.WinXPanels, Frame.Custom, Publishers, DaModule, Performer, Global.Resources;
{$ENDREGION}

type
  TframeProject = class(TframeSource)
    aLoadProject        : TAction;
    aSetCurrent         : TAction;
    btnLoadProject      : TToolButton;
    btnSep04            : TToolButton;
    btnSetCurrent       : TToolButton;
    aAttachmentsMain    : TAction;
    aAttachmentsSub     : TAction;
    aPathForAttachments : TAction;
    dlgAttachmments     : TFileOpenDialog;
    procedure aAttachmentsMainExecute(Sender: TObject);
    procedure aAttachmentsSubExecute(Sender: TObject);
    procedure aPathForAttachmentsExecute(Sender: TObject);
    procedure aAddExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aLoadProjectExecute(Sender: TObject);
    procedure aLoadProjectUpdate(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSetCurrentExecute(Sender: TObject);
    procedure aSetCurrentUpdate(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UItypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure vstTreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
  private const
    COL_NAME        = 0;
    COL_INFO        = 1;
    COL_HASH        = 2;
    COL_PATH_ATTACH = 3;
    COL_OPEN_DIALOG = 4;

    C_IDENTITY_NAME = 'frameProject';
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
  end;

implementation

{$R *.dfm}

{ TframeProject }

constructor TframeProject.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TProject);
  dlgAttachmments.Title := Application.Title;
end;

destructor TframeProject.Destroy;
begin

  inherited;
end;

procedure TframeProject.Initialize;
begin
  inherited Initialize;
  vstTree.FullExpand;
  Translate;
end;

procedure TframeProject.Deinitialize;
begin
  inherited;

end;

procedure TframeProject.Translate;
begin
  inherited;
  aLoadProject.Hint := TLang.Lang.Translate('LoadProject');
  aSetCurrent.Hint  := TLang.Lang.Translate('SetCurrent');
  vstTree.Header.Columns[COL_HASH].Text        := TLang.Lang.Translate('Hash');
  vstTree.Header.Columns[COL_INFO].Text        := TLang.Lang.Translate('Info');
  vstTree.Header.Columns[COL_NAME].Text        := TLang.Lang.Translate('Name');
  vstTree.Header.Columns[COL_PATH_ATTACH].Text := TLang.Lang.Translate('PathForAttachments');
end;

function TframeProject.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeProject.LoadFromXML;

 procedure LoadNode;
  var
    Data    : PProject;
    Hash    : string;
    NewNode : PVirtualNode;
  begin
    TGeneral.XMLParams.CurrentSection := 'Project';
    try
      while not TGeneral.XMLParams.IsLastKey do
      begin
        if TGeneral.XMLParams.ReadAttributes then
        begin
          Hash := TGeneral.XMLParams.Attributes.GetAttributeValue('Hash', '');
          if not Hash.IsEmpty then
          begin
            NewNode := vstTree.AddChild(nil);
            Data := NewNode.GetData;
            Data^.Hash               := Hash;
            Data^.Name               := TGeneral.XMLParams.Attributes.GetAttributeValue('Name', '');
            Data^.Info               := TGeneral.XMLParams.Attributes.GetAttributeValue('Info', '');
            Data^.Current            := TGeneral.XMLParams.Attributes.GetAttributeValue('Current', False);
            Data^.PathForAttachments := TGeneral.XMLParams.Attributes.GetAttributeValue('PathForAttachments', C_ATTACHMENTS_DIR);
            if Data^.Current then
              TGeneral.CurrentProject := Data^;
          end;
        end;
        TGeneral.XMLParams.NextKey;
      end;
    finally
      TGeneral.XMLParams.CurrentSection := '';
      TPublishers.ConfigPublisher.UpdateProject;
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

procedure TframeProject.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PProject;
  begin
    Data := aNode^.GetData;
    TGeneral.XMLParams.Attributes.AddNode;
    TGeneral.XMLParams.Attributes.SetAttributeValue('Name', Data^.Name);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Current', Data^.Current);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Hash', Data^.Hash);
    TGeneral.XMLParams.Attributes.SetAttributeValue('Info', Data^.Info);
    TGeneral.XMLParams.Attributes.SetAttributeValue('PathForAttachments', Data^.PathForAttachments);
    TGeneral.XMLParams.WriteAttributes;

    if Data^.Current then
      TGeneral.CurrentProject := Data^;
  end;

var
  Node: PVirtualNode;
begin
  inherited;
  TGeneral.XMLParams.EraseSection('Project');
  TGeneral.XMLParams.CurrentSection := 'Project';
  try
    Node := vstTree.RootNode.FirstChild;
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

procedure TframeProject.aAddExecute(Sender: TObject);
var
  NewNode: PVirtualNode;
  Data: PProject;
begin
  inherited;
  vstTree.ClearSelection;
  NewNode := vstTree.AddChild(nil);
  Data := NewNode^.GetData;
  vstTree.Selected[NewNode] := True;

  Data^.Hash := TFileUtils.GetHashString(TPath.GetRandomFileName);
  Data^.Name := '';
end;

procedure TframeProject.aDeleteExecute(Sender: TObject);
var
  Data: PProject;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    if Data^.Current then
      TGeneral.CurrentProject := Default(TProject);
    TGeneral.XMLParams.DeleteKey(TGeneral.XMLParams.GetXPath('Sorter.' + Data^.Hash));
    TGeneral.XMLParams.DeleteKey(TGeneral.XMLParams.GetXPath('Path.' + Data^.Hash));
    SaveToXML;
    vstTree.DeleteNode(vstTree.FocusedNode);
    TPublishers.ConfigPublisher.UpdateProject;
  end;
end;

procedure TframeProject.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframeProject.aLoadProjectExecute(Sender: TObject);
begin
  inherited;
  TPerformer.GetInstance.IsQuiet := True;
  try
    TPublishers.ProgressPublisher.ClearTree;
    DaMod.FillAllEmailsRecord;
  finally
    TPerformer.GetInstance.IsQuiet := False;
  end;
end;

procedure TframeProject.aLoadProjectUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and
                             not TGeneral.CurrentProject.Hash.IsEmpty;
end;

procedure TframeProject.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

procedure TframeProject.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
end;

procedure TframeProject.aSetCurrentExecute(Sender: TObject);
var
  Data: PProject;
  FocusedNode: PVirtualNode;
  RunNode: PVirtualNode;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    vstTree.BeginUpdate;
    try
      FocusedNode := vstTree.FocusedNode;
      RunNode := vstTree.RootNode.FirstChild;
      while Assigned(RunNode) do
      begin
        Data := RunNode^.GetData;
        Data^.Current := False;
        RunNode := RunNode.NextSibling;
      end;
      Data := FocusedNode^.GetData;
      Data^.Current := True;
    finally
      vstTree.EndUpdate;
    end;
    SaveToXML;
    TPublishers.ConfigPublisher.UpdateProject;
  end;
end;

procedure TframeProject.aSetCurrentUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframeProject.vstTreeNodeClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
var
  Point: TPoint;
  CellRect: TRect;
begin
  inherited;
  if Assigned(HitInfo.HitNode) and (HitInfo.HitColumn = COL_OPEN_DIALOG) then
  begin
    CellRect := vstTree.GetDisplayRect(HitInfo.HitNode, HitInfo.HitColumn, False);
    Point := TPoint.Create(CellRect.BottomRight.X - CellRect.Width, CellRect.BottomRight.Y);
    Point := vstTree.ClientToScreen(Point);
    pmFrame.Popup(Point.X, Point.Y);
  end;
end;

procedure TframeProject.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PProject;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_HASH:
      Result := CompareText(Data1^.Hash, Data2^.Hash);
    COL_INFO:
      Result := CompareText(Data1^.Info, Data2^.Info);
    COL_NAME:
      Result := CompareText(Data1^.Name, Data2^.Name);
    COL_PATH_ATTACH:
      Result := CompareText(Data1^.PathForAttachments, Data2^.PathForAttachments);
  end;
end;

procedure TframeProject.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeProject.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_NAME, COL_INFO, COL_HASH, COL_PATH_ATTACH]);
end;

procedure TframeProject.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UItypes.TImageIndex);
var
  Data: PProject;
begin
  inherited;
  if (Column = COL_OPEN_DIALOG) and (Kind in [ikNormal, ikSelected]) then
    ImageIndex := 5
  else if (Column = COL_NAME) and (Kind in [ikNormal, ikSelected]) then
  begin
    Data := Node^.GetData;
    if Data^.Current then
      ImageIndex := 83
    else
      ImageIndex := 21;
  end;
end;

procedure TframeProject.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PProject;
begin
  inherited;
  CellText := '';
  Data := Node^.GetData;
  case Column of
    COL_HASH:
      CellText := Data^.Hash;
    COL_INFO:
      CellText := Data^.Info;
    COL_NAME:
      CellText := Data^.Name;
    COL_PATH_ATTACH:
      CellText := Data^.PathForAttachments;
  end
end;

procedure TframeProject.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;NewText: string);
var
  Data: PProject;
begin
  inherited;
  Data := Node^.GetData;
  case Column of
    COL_INFO:
      Data^.Info := NewText;
    COL_NAME:
      Data^.Name := NewText;
    COL_HASH:
      Data^.Hash := NewText;
    COL_PATH_ATTACH:
      Data^.PathForAttachments := NewText;
  end;
end;

procedure TframeProject.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PProject;
begin
  inherited;
  Data := Node^.GetData;
  if Data^.Current then
    TargetCanvas.Font.Color := clNavy;
end;

procedure TframeProject.aAttachmentsMainExecute(Sender: TObject);
var
  Data: PProject;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    Data^.PathForAttachments := C_ATTACHMENTS_DIR;
    vstTree.InvalidateNode(vstTree.FocusedNode);
  end;
end;

procedure TframeProject.aAttachmentsSubExecute(Sender: TObject);
var
  Data: PProject;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    Data^.PathForAttachments := C_ATTACHMENTS_SUB_DIR;
    vstTree.InvalidateNode(vstTree.FocusedNode);
  end;
end;

procedure TframeProject.aPathForAttachmentsExecute(Sender: TObject);
var
  Data: PProject;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
    if dlgAttachmments.Execute then
    begin
      Data := vstTree.FocusedNode^.GetData;
      Data^.PathForAttachments := dlgAttachmments.FileName;
      vstTree.InvalidateNode(vstTree.FocusedNode);
    end;
end;

end.
