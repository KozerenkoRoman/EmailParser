unit Frame.AllAttachments;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Files.Utils,
  Vcl.WinXPanels, Publishers.Interfaces, Publishers, VirtualTrees.ExportHelper, Global.Resources, Html.Utils,
  Performer;
{$ENDREGION}

type
  TframeAllAttachments = class(TFrameSource, IProgress, IUpdateXML)
    aOpenAttachFile      : TAction;
    aOpenParsedText      : TAction;
    btnOpenAttachFile    : TToolButton;
    btnOpenParsedText    : TToolButton;
    btnSep04             : TToolButton;
    SaveDialogAttachment : TSaveDialog;
    procedure aOpenAttachFileExecute(Sender: TObject);
    procedure aOpenAttachFileUpdate(Sender: TObject);
    procedure aOpenParsedTextExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure aRefreshExecute(Sender: TObject);
  private const
    COL_POSITION     = 0;
    COL_SHORT_NAME   = 1;
    COL_FILE_NAME    = 2;
    COL_CONTENT_TYPE = 3;
    COL_PARSED_TEXT  = 4;

    C_FIXED_COLUMNS  = 5;

    C_IDENTITY_NAME = 'frameAllAttachments';
  private
      //IUpdateXML
    procedure UpdateXML;

    //IProgress
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: TResultData);

    procedure UpdateColumns;
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  protected
    function GetIdentityName: string; override;
    procedure SearchText(const aText: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

implementation

{$R *.dfm}

{ TframeAllAttachments }

constructor TframeAllAttachments.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TAttachments);
  TPublishers.UpdateXMLPublisher.Subscribe(Self);
  TPublishers.ProgressPublisher.Subscribe(Self);
end;

destructor TframeAllAttachments.Destroy;
begin
  TPublishers.UpdateXMLPublisher.Unsubscribe(Self);
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  inherited;
end;

function TframeAllAttachments.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeAllAttachments.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  UpdateColumns;
  Translate;
end;

procedure TframeAllAttachments.Deinitialize;
begin

  inherited Deinitialize;
end;

procedure TframeAllAttachments.Translate;
begin
  inherited;
  aOpenAttachFile.Hint := TLang.Lang.Translate('OpenFile');
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');
  vstTree.Header.Columns[COL_PARSED_TEXT].Text  := TLang.Lang.Translate('Text');
end;

procedure TframeAllAttachments.aOpenAttachFileExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TFile.Exists(Data^.FileName) then
      TFileUtils.ShellOpen(Data^.FileName)
    else
      TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeAllAttachments.aOpenAttachFileUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeAllAttachments.aOpenParsedTextExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    TInformationDialog.ShowMessage(THtmlUtils.GetHighlightText(Data^.ParsedText, Data^.Matches), GetIdentityName);
  end;
end;

procedure TframeAllAttachments.aRefreshExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PAttachments;
  AttachmentsArray : TAttachmentsArray;
  Counter: Integer;
  Performer: TPerformer;
begin
  inherited;
  if (vstTree.RootNode.ChildCount > 0) then
  begin
    SetLength(AttachmentsArray, vstTree.RootNode.ChildCount);
    Node := vstTree.RootNode.FirstChild;
    Counter := 0;
    while Assigned(Node) do
    begin
      Data := Node^.GetData;
      AttachmentsArray[Counter] := Data^;
      Node := Node.NextSibling;
      Inc(Counter);
    end;

    Performer := TPerformer.Create;
    try
      Performer.RefreshAttachments(@AttachmentsArray);
    finally
      FreeAndNil(Performer);
    end;
  end;
end;

procedure TframeAllAttachments.aSaveExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TFile.Exists(Data^.FileName) then
    begin
      SaveDialogAttachment.InitialDir := TPath.GetDirectoryName(Data^.FileName);
      SaveDialogAttachment.Filter     := 'Attachment|*' + TPath.GetExtension(Data^.FileName) + '|All files|*.*';
      SaveDialogAttachment.FileName   := Data^.FileName;
      if SaveDialogAttachment.Execute and (SaveDialogAttachment.FileName <> Data^.FileName) then
        TFile.Copy(Data^.FileName, SaveDialogAttachment.FileName);
    end
    else
      TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeAllAttachments.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PAttachments;
begin
  if (Column >= C_FIXED_COLUMNS) then
  begin
    Data := Node^.GetData;
    if not Data^.Matches[Column - C_FIXED_COLUMNS].IsEmpty then
    begin
      TargetCanvas.Brush.Color := arrWebColors[Column - C_FIXED_COLUMNS];
      TargetCanvas.FillRect(CellRect);
    end;
  end;
end;

procedure TframeAllAttachments.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAttachments;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_POSITION:
      Result := CompareValue(Data1^.Position, Data2^.Position);
    COL_SHORT_NAME:
      Result := CompareText(Data1^.ShortName, Data2^.ShortName);
    COL_FILE_NAME:
      Result := CompareText(Data1^.FileName, Data2^.FileName);
    COL_CONTENT_TYPE:
      Result := CompareText(Data1^.ContentType, Data2^.ContentType);
    COL_PARSED_TEXT:
      Result := CompareText(Data1^.ParsedText, Data2^.ParsedText);
  else
    if (Column >= 0) and
       (Data1^.Matches.Count > 0) and
       (Data2^.Matches.Count > 0) and
       (Data1^.Matches.Count >= Column - C_FIXED_COLUMNS) and
       (Data2^.Matches.Count >= Column - C_FIXED_COLUMNS) then
      Result := CompareText(Data1^.Matches.Items[Column - C_FIXED_COLUMNS], Data2^.Matches.Items[Column - C_FIXED_COLUMNS]);
  end;
end;

procedure TframeAllAttachments.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PAttachments;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeAllAttachments.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
var
  Data: PAttachments;
begin
  inherited;
  if (Column = COL_SHORT_NAME) and (Kind in [ikNormal, ikSelected]) then
  begin
    Data := Node^.GetData;
    ImageIndex := Data^.ImageIndex;
  end;
end;

procedure TframeAllAttachments.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PAttachments;
begin
  inherited;
  CellText := '';
  Data := Node^.GetData;
  case Column of
    COL_POSITION:
      CellText := Data^.Position.ToString;
    COL_SHORT_NAME:
      CellText := Data^.ShortName;
    COL_FILE_NAME:
      CellText := Data^.FileName;
    COL_CONTENT_TYPE:
      CellText := Data^.ContentType;
    COL_PARSED_TEXT:
      CellText := Data^.ParsedText;
  else
    if (Column >= 0) and (Data^.Matches.Count >= Column - C_FIXED_COLUMNS) then
      CellText := Data^.Matches.Items[Column - C_FIXED_COLUMNS];
  end;
end;

procedure TframeAllAttachments.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeAllAttachments.SearchText(const aText: string);
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
      vstTree.FocusedNode    := Node;
      vstTree.Selected[Node] := True;
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAllAttachments.StartProgress(const aMaxPosition: Integer);
begin
  vstTree.BeginUpdate;
  vstTree.Clear;
end;

procedure TframeAllAttachments.CompletedItem(const aResultData: TResultData);
var
  Data: PAttachments;
  Node: PVirtualNode;
begin
  for var i := Low(aResultData.Attachments) to High(aResultData.Attachments) do
  begin
    Node := vstTree.AddChild(nil);
    Data := Node^.GetData;
    Data^.Assign(aResultData.Attachments[i]);
    Data^.Position := vstTree.TotalCount;
  end;
end;

procedure TframeAllAttachments.UpdateColumns;
var
  Column: TVirtualTreeColumn;
  FRegExpList: TArrayRecord<TRegExpData>;
  Node: PVirtualNode;
  Data: PAttachments;
begin
  vstTree.BeginUpdate;
  FRegExpList := TGeneral.GetRegExpParametersList;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  if (FRegExpList.Count + C_FIXED_COLUMNS <> vstTree.Header.Columns.Count) then
    if (vstTree.RootNode.ChildCount > 0) then
    begin
      Node := vstTree.RootNode.FirstChild;
      while Assigned(Node) do
      begin
        Data := Node^.GetData;
        Data^.Matches.Count := FRegExpList.Count;
        Node := Node^.NextSibling;
      end;
    end;

  try
    for var item in FRegExpList do
    begin
      Column := vstTree.Header.Columns.Add;
      Column.Text             := item.ParameterName;
      Column.Options          := Column.Options - [coEditable];
      Column.CaptionAlignment := taCenter;
      Column.Alignment        := taLeftJustify;
      Column.Width            := 100;
      Column.Options          := Column.Options + [coVisible];
    end;
    TStoreHelper.LoadFromXML(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAllAttachments.EndProgress;
begin
  vstTree.EndUpdate;
end;

procedure TframeAllAttachments.Progress;
begin

end;

procedure TframeAllAttachments.UpdateXML;
begin
  UpdateColumns;
end;

end.
