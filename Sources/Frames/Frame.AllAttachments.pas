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
  Performer, DaModule, Vcl.WinXCtrls, EXIF.Dialog, XLSX.Dialog, Winapi.ShellAPI;
{$ENDREGION}

type
  TframeAllAttachments = class(TframeSource, IProgress, IConfig)
    aDeleteFile           : TAction;
    aFileBreak           : TAction;
    aFileSearch          : TAction;
    aFilter              : TAction;
    aOpenAttachFile      : TAction;
    aOpenEmail           : TAction;
    aOpenLocation        : TAction;
    aOpenParsedText      : TAction;
    aShowSearchBar       : TAction;
    btnDeleteFile        : TToolButton;
    btnFileBreak         : TToolButton;
    btnFileSearch        : TToolButton;
    btnFilter            : TToolButton;
    btnOpenAttachFile    : TToolButton;
    btnOpenEmail         : TToolButton;
    btnOpenParsedText    : TToolButton;
    btnSep04             : TToolButton;
    btnSep05             : TToolButton;
    btnSep06             : TToolButton;
    cbExt                : TComboBox;
    dlgFileSearch        : TFileOpenDialog;
    edtPath              : TButtonedEdit;
    lblPath              : TLabel;
    miDeleteFile         : TMenuItem;
    miOpenAttachFile     : TMenuItem;
    miOpenEmail          : TMenuItem;
    miOpenLocation       : TMenuItem;
    miOpenParsedText     : TMenuItem;
    miSep01              : TMenuItem;
    miSep02              : TMenuItem;
    pnlFileSearch        : TPanel;
    SaveDialogAttachment : TSaveDialog;
    tbFileSearch         : TToolBar;
    procedure aAddUpdate(Sender: TObject);
    procedure aDeleteFileExecute(Sender: TObject);
    procedure aExpandAllUpdate(Sender: TObject);
    procedure aFileBreakExecute(Sender: TObject);
    procedure aFileSearchExecute(Sender: TObject);
    procedure aFileSearchUpdate(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure aOpenAttachFileExecute(Sender: TObject);
    procedure aOpenAttachFileUpdate(Sender: TObject);
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenLocationExecute(Sender: TObject);
    procedure aOpenParsedTextExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aShowSearchBarExecute(Sender: TObject);
    procedure edtPathRightButtonClick(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_POSITION     = 0;
    COL_EMAIL_NAME   = 1;
    COL_SHORT_NAME   = 2;
    COL_FILE_NAME    = 3;
    COL_CONTENT_TYPE = 4;
    COL_PARSED_TEXT  = 5;
    COL_FILE_SIZE    = 6;
    COL_ID           = 7;
    COL_PARENT_ID    = 8;
    COL_HASH         = 9;
    C_FIXED_COLUMNS  = 10;

    C_IDENTITY_NAME = 'frameAllAttachment';
  private
    FIsFiltered : Boolean;
    FIsLoaded   : Boolean;
    FPerformer  : TPerformer;

    //IConfig
    procedure IConfig.UpdateRegExp = UpdateColumns;
    procedure UpdateFilter(const aOperation: TFilterOperation);

    //IProgress
    procedure ClearTree;
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachment: PAttachment);

    procedure UpdateColumns;
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

{ TframeAllAttachment }

constructor TframeAllAttachments.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TAttachData);
  TPublishers.ProgressPublisher.Subscribe(Self);
  TPublishers.ConfigPublisher.Subscribe(Self);
  FIsFiltered := False;
end;

destructor TframeAllAttachments.Destroy;
begin
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(Self);
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
  aDeleteFile.Caption     := TLang.Lang.Translate('DeleteFile');
  aDeleteFile.Hint        := TLang.Lang.Translate('DeleteFile');
  aFileBreak.Hint         := TLang.Lang.Translate('Break');
  aFileSearch.Hint        := TLang.Lang.Translate('StartSearch');
  aFilter.Hint            := TLang.Lang.Translate('Filter');
  aOpenAttachFile.Caption := TLang.Lang.Translate('OpenFile');
  aOpenAttachFile.Hint    := TLang.Lang.Translate('OpenFile');
  aOpenEmail.Caption      := TLang.Lang.Translate('OpenEmail');
  aOpenEmail.Hint         := TLang.Lang.Translate('OpenEmail');
  aOpenLocation.Caption   := TLang.Lang.Translate('OpenLocation');
  aOpenLocation.Hint      := TLang.Lang.Translate('OpenLocation');
  aOpenParsedText.Caption := TLang.Lang.Translate('OpenParsedText');
  aOpenParsedText.Hint    := TLang.Lang.Translate('OpenParsedText');
  aShowSearchBar.Hint     := TLang.Lang.Translate('ShowSearchBar');
  lblPath.Caption         := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_EMAIL_NAME].Text   := TLang.Lang.Translate('Email');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');
  vstTree.Header.Columns[COL_PARSED_TEXT].Text  := TLang.Lang.Translate('Text');
  vstTree.Header.Columns[COL_FILE_SIZE].Text    := TLang.Lang.Translate('Size');
  vstTree.Header.Columns[COL_HASH].Text         := TLang.Lang.Translate('Hash');
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

procedure TframeAllAttachments.aShowSearchBarExecute(Sender: TObject);
begin
  inherited;
  tbFileSearch.Visible := not tbFileSearch.Visible;
  if tbFileSearch.Visible then
    TAction(Sender).ImageIndex := 77
  else
    TAction(Sender).ImageIndex := 76;
  Self.Realign;
end;

procedure TframeAllAttachments.aFilterExecute(Sender: TObject);
begin
  inherited;
  FIsFiltered := TAction(Sender).Checked;
  if TAction(Sender).Checked then
    TAction(Sender).ImageIndex := 53
  else
    TAction(Sender).ImageIndex := 3;
  UpdateFilter(foOR);
end;

procedure TframeAllAttachments.aFileSearchUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded;
end;

procedure TframeAllAttachments.aOpenAttachFileExecute(Sender: TObject);
var
  Data: PAttachment;
  FileName: string;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      FileName := Data^.FileName;
      if TFile.Exists(FileName) then
        TFileUtils.ShellOpen(FileName)
      else if Data^.FromZip then
      begin
        Data := TGeneral.AttachmentList.GetItem(Data^.ParentHash);
        if Assigned(Data) then
        begin
          if TFile.Exists(Data^.FileName) then
            TFileUtils.ShellOpen(Data^.FileName)
          else
            TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
        end
        else
          TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [FileName]));
      end
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [FileName]));
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

procedure TframeAllAttachments.aOpenLocationExecute(Sender: TObject);
var
  Data: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
      if not Data^.FileName.IsEmpty then
        Winapi.ShellAPI.ShellExecute(0, nil, 'explorer.exe', PChar('/select,' + Data^.FileName), nil, SW_SHOWNORMAL)
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

      if Data^.ContentType.StartsWith('image', True) then
        TEXIFDialog.ShowMessage(Data^.ParsedText, Data^.FileName, Data^.Matches)
      else if Data^.ContentType.EndsWith('sheet', True) then
        TXLSXDialog.ShowMessage(Data^.ParsedText, Data^.Matches)
      else
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
    aFilter.ImageIndex := 53;

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
        TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
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
        TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
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
  if Assigned(Data) then
    if (Column in [COL_FILE_NAME, COL_SHORT_NAME, COL_EMAIL_NAME]) and Data^.FromZip then
      TargetCanvas.Font.Color := clNavy;
end;

procedure TframeAllAttachments.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAttachment;
  AttachData1, AttachData2: PAttachData;
begin
  inherited;
  Result := 0;
  if (Column >= C_FIXED_COLUMNS) then
  begin
    if (Sender.GetNodeLevel(Node1) >= 1) and (Sender.GetNodeLevel(Node2) >= 1) then
    begin
      AttachData1 := Node1^.GetData;
      AttachData2 := Node2^.GetData;
      if Assigned(AttachData1) and Assigned(AttachData2) then
        Result := CompareText(AttachData1^.Matches.Items[Column - C_FIXED_COLUMNS], AttachData2^.Matches.Items[Column - C_FIXED_COLUMNS]);
    end
  end
  else
  begin
    Data1 := TGeneral.AttachmentList.GetItem(PAttachData(Node1^.GetData).Hash);
    Data2 := TGeneral.AttachmentList.GetItem(PAttachData(Node2^.GetData).Hash);
    if Assigned(Data1) and Assigned(Data2) then
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
        COL_FILE_SIZE:
          Result := CompareValue(Data1^.Size, Data2^.Size);
        COL_ID:
          Result := CompareText(Data1^.Id, Data2^.Id);
        COL_PARENT_ID:
          Result := CompareText(Data1^.ParentId, Data2^.ParentId);
        COL_HASH:
          Result := CompareText(Data1^.Hash, Data2^.Hash);
      end;
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
        COL_FILE_SIZE:
          if (Data^.Size > 0) then
            CellText := Data^.Size.ToString;
        COL_ID:
          CellText := Data^.Id;
        COL_PARENT_ID:
          CellText := Data^.ParentId;
        COL_HASH:
          CellText := Data^.Hash;
      end;
  end;
end;

procedure TframeAllAttachments.aAddUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Visible := False;
end;

procedure TframeAllAttachments.aDeleteFileExecute(Sender: TObject);
var
  Data: PAttachment;
  Node : PVirtualNode;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
      if not Data^.FileName.IsEmpty and
        (TMessageDialog.ShowQuestion(Format(TLang.Lang.Translate('DeleteFilePrompt'), [Data^.FileName])) = mrYes) then
      begin
        if TFile.Exists(Data^.FileName) then
          TFile.Delete(Data^.FileName);
        Node := vstTree.FocusedNode;
        if (Node.Parent <> vstTree.RootNode) then
          Node := Node.Parent;

        vstTree.DeleteNode(Node);
        if FIsFiltered then
          vstTree.FocusedNode := vstTree.GetFirstVisible;

        vstTree.Selected[vstTree.FocusedNode] := True;
        vstTree.SetFocus;
        Self.SetFocus;
      end;
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
  aFilter.ImageIndex := 53;
  FPerformer.IsQuiet := False;
  FPerformer.FileSearch(edtPath.Text, cbExt.Text);
end;

procedure TframeAllAttachments.StartProgress(const aMaxPosition: Integer);
var
  CurrNode : PVirtualNode;
begin
  vstTree.BeginUpdate;
  FIsLoaded   := True;
  FIsFiltered := True;
  aFilter.Checked    := True;
  aFilter.ImageIndex := 53;

  CurrNode := vstTree.RootNode.FirstChild;
  while Assigned(CurrNode) do
  begin
    if (CurrNode.ChildCount > 0) then
      vstTree.DeleteChildren(CurrNode);
    CurrNode := CurrNode.NextSibling;
  end;
end;

procedure TframeAllAttachments.EndProgress;
begin
  FIsLoaded := False;
  vstTree.EndUpdate;
  FPerformer.IsQuiet := False;
  FPerformer.Clear;
end;

procedure TframeAllAttachments.ClearTree;
begin
  TGeneral.AttachmentList.ClearParentNodePointer;
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
  MaxCol    : Integer;
  Node      : PVirtualNode;
  IsEmpty   : Boolean;
begin
  if not Assigned(aAttachment) then
    Exit;
  if not Assigned(aAttachment^.OwnerNode) then
  begin
    Node := vstTree.AddChild(nil);
    aAttachment^.OwnerNode := Node;
  end
  else
    Node := aAttachment^.OwnerNode;

  Data := Node^.GetData;
  Data^.Hash := aAttachment^.Hash;
  MaxCol := 0;
  for var i := 0 to aAttachment.Matches.Count - 1 do
    MaxCol := Max(MaxCol, aAttachment.Matches[i].Count);

  SetLength(arr, MaxCol, aAttachment^.Matches.Count);
  for var i := 0 to aAttachment^.Matches.Count - 1 do
    for var j := 0 to aAttachment^.Matches[i].Count - 1 do
      arr[j, i] := aAttachment^.Matches[i].Items[j].Trim;

  Data^.Matches.Count := MaxCol;
  for var i := Low(arr) to High(arr) do
  begin
    IsEmpty := True;
    for var j := Low(arr[i]) to High(arr[i]) do
      IsEmpty := IsEmpty and string(arr[i]).IsEmpty;
    if not IsEmpty then
    begin
      ChildNode := vstTree.AddChild(Node);
      Data := ChildNode^.GetData;
      Data^.Hash := aAttachment^.Hash;
      Data^.Matches.AddRange(arr[i]);
      vstTree.ValidateNode(ChildNode, False);
    end;
  end;
  vstTree.IsVisible[Node] := not FIsFiltered or (Node.ChildCount > 0);
  vstTree.ValidateNode(Node, False);
end;

procedure TframeAllAttachments.UpdateColumns;
var
  Column     : TVirtualTreeColumn;
  Node       : PVirtualNode;
  CurrNode   : PVirtualNode;
  Data       : PAttachData;
begin
  vstTree.BeginUpdate;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  Node := vstTree.RootNode.FirstChild;
  while Assigned(Node) do
  begin
    Data := Node^.GetData;
    Data^.Matches.Count := TGeneral.PatternList.Count;
    if (Node.ChildCount > 0) then
    begin
      CurrNode := Node.FirstChild;
      while Assigned(CurrNode) do
      begin
        Data := CurrNode^.GetData;
        Data^.Matches.Count := TGeneral.PatternList.Count;
        CurrNode := CurrNode.NextSibling;
      end;
    end;
    Node := Node.NextSibling;
  end;

  try
    for var item in TGeneral.PatternList do
    begin
      Column := vstTree.Header.Columns.Add;
      Column.Text             := item^.ParameterName;
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

procedure TframeAllAttachments.UpdateFilter(const aOperation: TFilterOperation);
var
  ChildMatches  : Cardinal;
  ChildNode     : PVirtualNode;
  Data          : PAttachData;
  FilterValue   : Cardinal;
  Node          : PVirtualNode;
  ParentMatches : Cardinal;
begin
  inherited;
  FilterValue := 0;
  for var i := 0 to TGeneral.PatternList.Count - 1 do
    if TGeneral.PatternList[i].IsSelected then
      Include(TFilterSet(FilterValue), i);
  if (FilterValue = 0) then
    FilterValue := MaxCardinal;

  vstTree.BeginUpdate;
  try
    Node := vstTree.RootNode.FirstChild;
    while Assigned(Node) do
    begin
      ParentMatches := 0;
      ChildNode := Node.FirstChild;
      while Assigned(ChildNode) do
      begin
        ChildMatches := 0;
        Data := ChildNode^.GetData;
        if Assigned(Data) then
          for var i := 0 to Data^.Matches.Count - 1 do
            if not Data^.Matches[i].IsEmpty then
            begin
              Include(TFilterSet(ParentMatches), i);
              Include(TFilterSet(ChildMatches), i);
            end;
        case aOperation of
          foAnd:
            vstTree.IsVisible[ChildNode] := not FIsFiltered or ((ChildMatches and FilterValue) >= FilterValue);
          foOR:
            vstTree.IsVisible[ChildNode] := not FIsFiltered or ((ChildMatches and FilterValue) > 0);
        end;
        ChildNode := vstTree.GetNextSibling(ChildNode);
      end;

      case aOperation of
        foAnd:
          vstTree.IsVisible[Node] := not FIsFiltered or ((ParentMatches and FilterValue) >= FilterValue);
        foOr:
          vstTree.IsVisible[Node] := not FIsFiltered or ((ParentMatches and FilterValue) > 0);
      end;

      Node := vstTree.GetNextSibling(Node);
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAllAttachments.CompletedItem(const aResultData: PResultData);
begin
  //nothing
end;

procedure TframeAllAttachments.Progress;
begin
  //nothing
end;

end.
