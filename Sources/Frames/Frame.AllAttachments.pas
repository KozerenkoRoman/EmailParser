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
  Vcl.WinXPanels, Publishers.Interfaces, Publishers, VirtualTrees.ExportHelper, Global.Resources, Global.Utils,
  Performer, DaModule, Vcl.WinXCtrls;
{$ENDREGION}

type
  TframeAllAttachments = class(TframeSource, IProgress, IUpdateXML)
    aFileBreak           : TAction;
    aFileSearch          : TAction;
    aFileSearchShow      : TAction;
    aFilter              : TAction;
    aOpenAttachFile      : TAction;
    aOpenEmail           : TAction;
    aOpenParsedText      : TAction;
    btnFileBreak         : TToolButton;
    btnFileSearch        : TToolButton;
    btnFilter            : TToolButton;
    btnOpenAttachFile    : TToolButton;
    btnOpenEmail         : TToolButton;
    btnOpenParsedText    : TToolButton;
    btnSep04             : TToolButton;
    btnSep05             : TToolButton;
    cbExt                : TComboBox;
    dlgFileSearch        : TFileOpenDialog;
    edtPath              : TButtonedEdit;
    lblPath              : TLabel;
    pnlFileSearch        : TPanel;
    SaveDialogAttachment : TSaveDialog;
    tbFileSearch         : TToolBar;
    procedure aExpandAllUpdate(Sender: TObject);
    procedure aFileBreakExecute(Sender: TObject);
    procedure aFileSearchExecute(Sender: TObject);
    procedure aFileSearchShowExecute(Sender: TObject);
    procedure aFileSearchUpdate(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure aOpenAttachFileExecute(Sender: TObject);
    procedure aOpenAttachFileUpdate(Sender: TObject);
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenParsedTextExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure edtPathRightButtonClick(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_POSITION     = 0;
    COL_EMAIL_NAME   = 1;
    COL_SHORT_NAME   = 2;
    COL_FILE_NAME    = 3;
    COL_CONTENT_TYPE = 4;
    COL_PARSED_TEXT  = 5;
    C_FIXED_COLUMNS  = 6;

    C_IDENTITY_NAME = 'frameAllAttachment';
  private
    FIsFiltered : Boolean;
    FIsLoaded   : Boolean;
    FPerformer  : TPerformer;

      //IUpdateXML
    procedure IUpdateXML.UpdateXML = UpdateColumns;

    //IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachment: PAttachment);

    procedure UpdateColumns;
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  protected
    function GetIdentityName: string; override;
    procedure SearchText(const aText: string); override;
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

{ TframeAllAttachment }

constructor TframeAllAttachments.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TAttachData);
  TPublishers.ProgressPublisher.Subscribe(Self);
  TPublishers.UpdateXMLPublisher.Subscribe(Self);
  FIsFiltered := False;
end;

destructor TframeAllAttachments.Destroy;
begin
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.UpdateXMLPublisher.Unsubscribe(Self);
  inherited;
end;

procedure TframeAllAttachments.edtPathRightButtonClick(Sender: TObject);
begin
  inherited;
  if dlgFileSearch.Execute then
    TButtonedEdit(Sender).Text := dlgFileSearch.FileName;
end;

function TframeAllAttachments.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeAllAttachments.Initialize;
begin
  inherited Initialize;
  Translate;
  UpdateColumns;
  tbFileSearch.Color := clBtnFace;
  FPerformer := TPerformer.GetInstance;
end;

procedure TframeAllAttachments.Deinitialize;
begin

  inherited Deinitialize;
end;

procedure TframeAllAttachments.Translate;
begin
  inherited;
  aOpenAttachFile.Hint := TLang.Lang.Translate('OpenFile');
  aOpenEmail.Hint      := TLang.Lang.Translate('OpenEmail');
  aOpenEmail.Hint      := TLang.Lang.Translate('OpenEmail');
  aFileSearch.Hint     := TLang.Lang.Translate('StartSearch');
  aFileBreak.Hint      := TLang.Lang.Translate('Break');
  lblPath.Caption      := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_EMAIL_NAME].Text   := TLang.Lang.Translate('Email');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');
  vstTree.Header.Columns[COL_PARSED_TEXT].Text  := TLang.Lang.Translate('Text');
end;

procedure TframeAllAttachments.SaveToXML;
begin
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'AttachmentsPath', edtPath.Text, lblPath.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'AttachmentsExt', cbExt.Text);
  TGeneral.XMLParams.Save;
  inherited;
end;

procedure TframeAllAttachments.LoadFromXML;
begin
  inherited;
  edtPath.Text := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'AttachmentsPath', TDirectory.GetCurrentDirectory);
  cbExt.Text   := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'AttachmentsExt', '*.*');
end;

procedure TframeAllAttachments.aFileSearchShowExecute(Sender: TObject);
begin
  inherited;
  tbFileSearch.Visible := not tbFileSearch.Visible;
  if tbFileSearch.Visible then
    aFileSearchShow.ImageIndex := 80
  else
    aFileSearchShow.ImageIndex := 79;
  Self.Realign;
end;

procedure TframeAllAttachments.aFileSearchUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded;
end;

procedure TframeAllAttachments.aFilterExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PAttachment;
begin
  inherited;
  FIsFiltered := TAction(Sender).Checked;
  if TAction(Sender).Checked then
    TAction(Sender).ImageIndex := 56
  else
    TAction(Sender).ImageIndex := 3;

  if (vstTree.RootNode.ChildCount > 0) then
  begin
    Node := vstTree.RootNode.FirstChild;
    vstTree.BeginUpdate;
    try
      while Assigned(Node) do
      begin
        Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
        if Assigned(Data) then
        begin
          vstTree.IsVisible[Node] := not FIsFiltered or (Node.ChildCount > 0);
          vstTree.InvalidateNode(Node);
        end;
        Node := Node.NextSibling;
      end;
    finally
      vstTree.EndUpdate;
    end;
  end;
end;

procedure TframeAllAttachments.aOpenAttachFileExecute(Sender: TObject);
var
  Data: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      if TFile.Exists(Data^.FileName) then
        TFileUtils.ShellOpen(Data^.FileName)
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
    end;
  end;
end;

procedure TframeAllAttachments.aOpenAttachFileUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeAllAttachments.aOpenEmailExecute(Sender: TObject);
var
  ResultData: PResultData;
  AttData: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    AttData := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(AttData) then
    begin
      ResultData := TGeneral.EmailList.GetItem(AttData.ParentHash);
      if Assigned(ResultData) then
      begin
        if TFile.Exists(ResultData^.FileName) then
          TFileUtils.ShellOpen(ResultData^.FileName)
        else
          TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [ResultData^.FileName]));
      end;
    end;
  end;
end;

procedure TframeAllAttachments.aOpenParsedTextExecute(Sender: TObject);
var
  Data: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      if Data^.ParsedText.IsEmpty then
        Data^.ParsedText := TDaMod.GetAttachmentAsRawText(Data^.Hash);
      TInformationDialog.ShowMessage(TGlobalUtils.GetHighlightText(Data^.ParsedText.Replace(#10, '<br>'), Data^.Matches), GetIdentityName);
    end;
  end;
end;

procedure TframeAllAttachments.aRefreshExecute(Sender: TObject);
begin
  inherited;
  if not vstTree.IsEmpty then
  begin
    FIsFiltered := True;
    aFilter.Checked := True;
    aFilter.ImageIndex := 56;

    FPerformer.IsQuiet := True;
    FPerformer.Count := vstTree.RootNodeCount;
    FPerformer.RefreshAttachment;
  end;
end;

procedure TframeAllAttachments.aSaveExecute(Sender: TObject);
var
  Data : PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) and TFile.Exists(Data^.FileName) then
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
  Data: PAttachment;
  AttachData: PAttachData;
begin
  inherited;
  if (Sender.GetNodeLevel(Node) >= 1) then
  begin
    AttachData := Node^.GetData;
    if Assigned(AttachData) and (Column >= C_FIXED_COLUMNS) then
      if not AttachData^.Matches[Column - C_FIXED_COLUMNS].IsEmpty then
      begin
        TargetCanvas.Brush.Color := TGeneral.RegExpColumns[Column - C_FIXED_COLUMNS].Color;
        TargetCanvas.FillRect(CellRect);
      end;
  end
  else
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      if (Column < C_FIXED_COLUMNS) then
      begin
        if Data^.FromZip then
        begin
          TargetCanvas.Brush.Color := clWebWhiteSmoke;
          TargetCanvas.FillRect(CellRect);
        end
      end
      else if (Data^.Matches[Column - C_FIXED_COLUMNS].Count > 0) then
      begin
        TargetCanvas.Brush.Color := TGeneral.RegExpColumns[Column - C_FIXED_COLUMNS].Color;
        TargetCanvas.FillRect(CellRect);
      end;
  end;
end;

procedure TframeAllAttachments.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PAttachment;
begin
  inherited;
  Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
  if (Column in [COL_FILE_NAME, COL_SHORT_NAME]) and Data^.FromDB then
    TargetCanvas.Font.Color := clNavy;
end;

procedure TframeAllAttachments.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAttachment;
begin
  inherited;
  Data1 := TGeneral.AttachmentList.GetItem(PAttachData(Node1^.GetData).Hash);
  Data2 := TGeneral.AttachmentList.GetItem(PAttachData(Node2^.GetData).Hash);
  if (not Assigned(Data1)) or (not Assigned(Data2)) then
    Result := 0
  else
  case Column of
    COL_POSITION:
      Result := CompareValue(vstTree.AbsoluteIndex(Node1), vstTree.AbsoluteIndex(Node2));
    COL_SHORT_NAME:
      Result := CompareText(Data1^.ShortName, Data2^.ShortName);
    COL_EMAIL_NAME:
      Result := CompareText(Data1^.ParentName, Data2^.ParentName);
    COL_FILE_NAME:
      Result := CompareText(Data1^.FileName, Data2^.FileName);
    COL_CONTENT_TYPE:
      Result := CompareText(Data1^.ContentType, Data2^.ContentType);
    COL_PARSED_TEXT:
      Result := CompareText(Data1^.ParsedText, Data2^.ParsedText);
  end;
end;

procedure TframeAllAttachments.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
var
  Data: PAttachment;
begin
  inherited;
  if (Column = COL_SHORT_NAME) and (Kind in [ikNormal, ikSelected]) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      ImageIndex := Data^.ImageIndex;
  end;
end;

procedure TframeAllAttachments.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PAttachment;
  AttachData: PAttachData;
begin
  inherited;
  CellText := '';
  if (Column >= C_FIXED_COLUMNS) then
  begin
    if (Sender.GetNodeLevel(Node) >= 1) then
    begin
      AttachData := Node^.GetData;
      if Assigned(AttachData) then
        CellText := AttachData^.Matches.Items[Column - C_FIXED_COLUMNS];
    end
  end
  else
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      case Column of
        COL_POSITION:
          CellText := (vstTree.AbsoluteIndex(Node) + 1).ToString;
        COL_SHORT_NAME:
          CellText := Data^.ShortName;
        COL_EMAIL_NAME:
          CellText := Data^.ParentName;
        COL_FILE_NAME:
          CellText := Data^.FileName;
        COL_CONTENT_TYPE:
          CellText := Data^.ContentType;
        COL_PARSED_TEXT:
          CellText := Data^.ParsedText;
      end;
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

procedure TframeAllAttachments.aExpandAllUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded
end;

procedure TframeAllAttachments.aFileBreakExecute(Sender: TObject);
begin
  inherited;
  FIsLoaded := False;
  FPerformer.Stop;
  vstTree.EndUpdate;
end;

procedure TframeAllAttachments.aFileSearchExecute(Sender: TObject);
begin
  inherited;
  ClearTree;
  FIsLoaded   := True;
  FIsFiltered := True;
  aFilter.Checked    := True;
  aFilter.ImageIndex := 56;
  FPerformer.IsQuiet := True;
  FPerformer.FileSearch(edtPath.Text, cbExt.Text);
end;

procedure TframeAllAttachments.StartProgress(const aMaxPosition: Integer);
var
  CurrNode : PVirtualNode;
begin
  vstTree.BeginUpdate;
  CurrNode := vstTree.RootNode.FirstChild;
  while Assigned(CurrNode) do
  begin
    if (CurrNode.ChildCount > 0) then
      vstTree.DeleteChildren(CurrNode);
    CurrNode := CurrNode.NextSibling;
  end;
end;

procedure TframeAllAttachments.ClearTree;
var
  item : TPair<string, PAttachment>;
begin
  TGeneral.AttachmentList.ClearParentNodePointer;
  for item in TGeneral.AttachmentList do
  begin
    TGeneral.AttachmentList.ExtractPair(item.Key);
    Dispose(item.Value);
  end;

  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    vstTree.Invalidate;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAllAttachments.CompletedAttach(const aAttachment: PAttachment);
var
  arr       : array of array of string;
  ChildNode : PVirtualNode;
  Data      : PAttachData;
  IsEmpty   : Boolean;
  MaxCol    : Integer;
  Node      : PVirtualNode;
begin
  if not Assigned(aAttachment) then
    Exit;
  if not Assigned(aAttachment^.ParentNode) then
  begin
    Node := vstTree.AddChild(nil);
    aAttachment^.ParentNode := Node;
  end
  else
    Node := aAttachment^.ParentNode;

  Data := Node^.GetData;
  Data^.Hash := aAttachment^.Hash;
  MaxCol := 0;
  for var i := 0 to aAttachment.Matches.Count - 1 do
    MaxCol := Max(MaxCol, aAttachment.Matches[i].Count);

  IsEmpty := False;
  SetLength(arr, MaxCol, aAttachment^.Matches.Count);
  for var i := 0 to aAttachment^.Matches.Count - 1 do
    for var j := 0 to aAttachment^.Matches[i].Count - 1 do
    begin
      arr[j, i] := aAttachment^.Matches[i].Items[j].Trim;
      IsEmpty := IsEmpty or arr[j, i].IsEmpty;
    end;

  Data^.Matches.Count := MaxCol;
  if not IsEmpty then
    for var i := Low(arr) to High(arr) do
    begin
      ChildNode := vstTree.AddChild(Node);
      Data := ChildNode^.GetData;
      Data^.Hash := aAttachment^.Hash;
      Data^.Matches.AddRange(arr[i]);
      vstTree.ValidateNode(ChildNode, False);
    end;
  vstTree.IsVisible[Node] := not FIsFiltered or (Node.ChildCount > 0);
  vstTree.ValidateNode(Node, False);
end;

procedure TframeAllAttachments.CompletedItem(const aResultData: PResultData);
begin
  //nothing
end;

procedure TframeAllAttachments.UpdateColumns;
var
  Column     : TVirtualTreeColumn;
  Node       : PVirtualNode;
  CurrNode   : PVirtualNode;
  Data       : PAttachData;
  RegExpList : TArrayRecord<TRegExpData>;
begin
  vstTree.BeginUpdate;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  RegExpList := TGeneral.GetRegExpParametersList;
  Node := vstTree.RootNode.FirstChild;
  while Assigned(Node) do
  begin
    Data := Node^.GetData;
    Data^.Matches.Count := RegExpList.Count;
    if (Node.ChildCount > 0) then
    begin
      CurrNode := Node.FirstChild;
      while Assigned(CurrNode) do
      begin
        Data := CurrNode^.GetData;
        Data^.Matches.Count := RegExpList.Count;
        CurrNode := CurrNode.NextSibling;
      end;
    end;
    Node := Node.NextSibling;
  end;

  try
    for var item in RegExpList do
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
  FIsLoaded := False;
  vstTree.EndUpdate;
  FPerformer.IsQuiet := False;
  FPerformer.Clear;
end;

procedure TframeAllAttachments.Progress;
begin

end;

end.
