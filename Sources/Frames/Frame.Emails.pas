unit Frame.Emails;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Vcl.Samples.Gauges,
  Performer, Winapi.ShellAPI, Vcl.OleCtrls, SHDocVw, Winapi.ActiveX, Frame.Attachments, Files.Utils, DaModule,
  VirtualTrees.ExportHelper, Global.Resources, Publishers, Publishers.Interfaces, Vcl.WinXPanels, Frame.Custom;
{$ENDREGION}

type
  TframeEmails = class(TframeSource, IProgress, IUpdateXML)
    aBreak          : TAction;
    aCollapseAll    : TAction;
    aExpandAll      : TAction;
    aFilter         : TAction;
    aOpenEmail      : TAction;
    aOpenLogFile    : TAction;
    aSearch         : TAction;
    btnBreak        : TToolButton;
    btnFilter       : TToolButton;
    btnOpenEmail    : TToolButton;
    btnOpenLogFile  : TToolButton;
    btnSearch       : TToolButton;
    btnSep04        : TToolButton;
    btnSep05        : TToolButton;
    miCollapseAll   : TMenuItem;
    miExpandAll     : TMenuItem;
    SaveDialogEmail : TSaveDialog;
    procedure aBreakExecute(Sender: TObject);
    procedure aCollapseAllExecute(Sender: TObject);
    procedure aExpandAllExecute(Sender: TObject);
    procedure aExpandAllUpdate(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenEmailUpdate(Sender: TObject);
    procedure aOpenLogFileExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aSearchUpdate(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_POSITION      = 0;
    COL_SHORT_NAME    = 1;
    COL_FILE_NAME     = 2;
    COL_MESSAGE_ID    = 3;
    COL_DATE          = 4;
    COL_SUBJECT       = 5;
    COL_ATTACH        = 6;
    COL_FROM          = 7;
    COL_CONTENT_TYPE  = 8;

    C_FIXED_COLUMNS   = 9;

    C_IDENTITY_NAME = 'frameResultView';
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

    procedure UpdateColumns;
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

{ TframeResultView }

constructor TframeEmails.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TEmail);
  FPerformer := TPerformer.Create;
  TPublishers.UpdateXMLPublisher.Subscribe(Self);
  TPublishers.ProgressPublisher.Subscribe(Self);
  FIsFiltered := False;
end;

destructor TframeEmails.Destroy;
begin
  TPublishers.UpdateXMLPublisher.Unsubscribe(Self);
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  FreeAndNil(FPerformer);
  inherited;
end;

function TframeEmails.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeEmails.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  Translate;
  UpdateColumns;
end;

procedure TframeEmails.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeEmails.Translate;
begin
  inherited Translate;
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_MESSAGE_ID].Text   := TLang.Lang.Translate('MessageId');
  vstTree.Header.Columns[COL_DATE].Text         := TLang.Lang.Translate('Date');
  vstTree.Header.Columns[COL_SUBJECT].Text      := TLang.Lang.Translate('Subject');
  vstTree.Header.Columns[COL_ATTACH].Text       := TLang.Lang.Translate('Attachment');
  vstTree.Header.Columns[COL_FROM].Text         := TLang.Lang.Translate('From');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');

  aCollapseAll.Caption := TLang.Lang.Translate('CollapseAll');
  aExpandAll.Caption   := TLang.Lang.Translate('ExpandAll');
  aOpenEmail.Hint      := TLang.Lang.Translate('OpenEmail');
  aOpenLogFile.Hint    := TLang.Lang.Translate('OpenLogFile');
  aSearch.Hint         := TLang.Lang.Translate('StartSearch');
end;

procedure TframeEmails.UpdateColumns;
var
  Column     : TVirtualTreeColumn;
  CurrNode   : PVirtualNode;
  DataEmail  : PEmail;
  RegExpList : TArrayRecord<TRegExpData>;
begin
  vstTree.BeginUpdate;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  RegExpList := TGeneral.GetRegExpParametersList;
  for var ResultData in TGeneral.EmailList.Values do
  begin
    ResultData.Matches.Count := RegExpList.Count;
    if Assigned(ResultData.ParentNode) then
      if (ResultData.ParentNode.ChildCount > 0) then
      begin
        CurrNode := ResultData.ParentNode.FirstChild;
        while Assigned(CurrNode) do
        begin
          DataEmail := CurrNode^.GetData;
          DataEmail^.Matches.Count := RegExpList.Count;
          CurrNode := CurrNode.NextSibling;
        end;
      end;
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

procedure TframeEmails.SaveToXML;
begin
  inherited;

end;

procedure TframeEmails.LoadFromXML;
begin
  inherited;

end;

procedure TframeEmails.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PResultData;
begin
  inherited;
  Data1 := TGeneral.EmailList.GetItem(PEmail(Node1^.GetData).Hash);
  Data2 := TGeneral.EmailList.GetItem(PEmail(Node2^.GetData).Hash);

  if (not Assigned(Data1)) or (not Assigned(Data2)) then
    Result := 0
  else
    case Column of
      COL_POSITION:
        Result := CompareValue(Data1^.Position, Data2^.Position);
      COL_FILE_NAME:
        Result := CompareText(Data1^.FileName, Data2^.FileName);
      COL_SHORT_NAME:
        Result := CompareText(Data1^.ShortName, Data2^.ShortName);
      COL_MESSAGE_ID:
        Result := CompareText(Data1^.MessageId, Data2^.MessageId);
      COL_DATE:
        Result := CompareValue(Data1^.TimeStamp, Data2^.TimeStamp);
      COL_SUBJECT:
        Result := CompareText(Data1^.Subject, Data2^.Subject);
      COL_ATTACH:
        Result := CompareValue(Length(Data1^.Attachments), Length(Data2^.Attachments));
      COL_FROM:
        Result := CompareText(Data1^.From, Data2^.From);
      COL_CONTENT_TYPE:
        Result := CompareText(Data1^.ContentType, Data2^.ContentType);
    end;
end;

procedure TframeEmails.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeEmails.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := True;
end;

procedure TframeEmails.vstTreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
var
  NewData: PResultData;
  OldData: PResultData;
begin
  inherited;
  if FIsLoaded then
    Exit;
  if (OldNode = NewNode) and (OldColumn <> NewColumn) then
    Exit;
  if Assigned(NewNode) then
  begin
    NewData := TGeneral.EmailList.GetItem(PEmail(NewNode^.GetData).Hash);
    if Assigned(OldNode) then
    begin
      OldData := TGeneral.EmailList.GetItem(PEmail(OldNode^.GetData).Hash);
      if Assigned(OldData) and Assigned(NewData) then
        if (OldData.Hash <> NewData.Hash) then
          TPublishers.EmailPublisher.FocusChanged(NewData);
    end
    else if Assigned(NewData) then
      TPublishers.EmailPublisher.FocusChanged(NewData);
  end
  else
    TPublishers.EmailPublisher.FocusChanged(nil);
end;

procedure TframeEmails.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  DataEmail: PEmail;
  Data: PResultData;
begin
  if (Column >= C_FIXED_COLUMNS) then
  begin
    if (Sender.GetNodeLevel(Node) >= 1) then
    begin
      DataEmail := Node^.GetData;
      if Assigned(DataEmail) then
        if not DataEmail^.Matches[Column - C_FIXED_COLUMNS].IsEmpty then
        begin
          TargetCanvas.Brush.Color := arrWebColors[Column - C_FIXED_COLUMNS];
          TargetCanvas.FillRect(CellRect);
        end;
    end
    else
    begin
      Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
      if Assigned(Data) then
        if Data^.IsMatch then
        begin
          TargetCanvas.Brush.Color := arrWebColors[Column - C_FIXED_COLUMNS];
          TargetCanvas.FillRect(CellRect);
        end;
    end
  end;
end;

procedure TframeEmails.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PResultData;
  DataEmail: PEmail;
begin
  inherited;
  if (Column >= C_FIXED_COLUMNS) then
  begin
    if (Sender.GetNodeLevel(Node) >= 1) then
    begin
      DataEmail := Node^.GetData;
      if Assigned(DataEmail) then
        CellText := DataEmail^.Matches.Items[Column - C_FIXED_COLUMNS];
    end
  end
  else
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
    if Assigned(Data) then
      case Column of
        COL_POSITION:
          CellText := Data^.Position.ToString;
        COL_FILE_NAME:
          CellText := Data^.FileName;
        COL_SHORT_NAME:
          CellText := Data^.ShortName;
        COL_MESSAGE_ID:
          CellText := Data^.MessageId;
        COL_DATE:
          CellText := DateTimeToStr(Data^.TimeStamp);
        COL_SUBJECT:
          CellText := Data^.Subject;
        COL_ATTACH:
          if (Length(Data^.Attachments) = 0) then
            CellText := ''
          else
            CellText := Length(Data^.Attachments).ToString;
        COL_FROM:
          CellText := Data^.From;
        COL_CONTENT_TYPE:
          CellText := Data^.ContentType;
      else
        CellText :='';
      end;
    end;
end;

procedure TframeEmails.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PResultData;
begin
  inherited;
  Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
  if Assigned(Data) then
    if (Column in [COL_FILE_NAME, COL_SHORT_NAME]) then
      TargetCanvas.Font.Color := clNavy;
end;

procedure TframeEmails.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeEmails.SearchText(const aText: string);
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

procedure TframeEmails.aBreakExecute(Sender: TObject);
begin
  inherited;
  FIsLoaded := False;
  FPerformer.Stop;
  vstTree.EndUpdate;
end;

procedure TframeEmails.aSearchUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded;
end;

procedure TframeEmails.aOpenEmailExecute(Sender: TObject);
var
  Data: PResultData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      if TFile.Exists(Data^.FileName) then
        TFileUtils.ShellOpen(Data^.FileName)
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
    end;
  end;
end;

procedure TframeEmails.aOpenEmailUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeEmails.aOpenLogFileExecute(Sender: TObject);
begin
  inherited;
  if FileExists(LogWriter.LogFileName) then
    TFileUtils.ShellOpen(LogWriter.LogFileName);
end;

procedure TframeEmails.aRefreshExecute(Sender: TObject);
begin
  inherited;
  if (vstTree.RootNode.ChildCount > 0) then
  begin
    FIsLoaded   := True;
    FIsFiltered := True;
    aFilter.Checked    := True;
    aFilter.ImageIndex := 56;
    Application.ProcessMessages;
    FPerformer.Count := vstTree.RootNode.ChildCount;
    FPerformer.RefreshEmails;
  end;
end;

procedure TframeEmails.aSaveExecute(Sender: TObject);
var
  Data: PResultData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
      if TFile.Exists(Data^.FileName) then
      begin
        SaveDialogEmail.InitialDir := TPath.GetDirectoryName(Data^.FileName);
        SaveDialogEmail.FileName := Data^.FileName;
        if SaveDialogEmail.Execute and (SaveDialogEmail.FileName <> Data^.FileName) then
          TFile.Copy(Data^.FileName, SaveDialogEmail.FileName);
      end
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeEmails.aCollapseAllExecute(Sender: TObject);
begin
  inherited;
  vstTree.BeginUpdate;
  try
    vstTree.FullCollapse;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeEmails.aExpandAllExecute(Sender: TObject);
begin
  inherited;
  vstTree.BeginUpdate;
  try
    vstTree.FullExpand;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeEmails.aExpandAllUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded
end;

procedure TframeEmails.aFilterExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PResultData;
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
        Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
        if Assigned(Data) then
        begin
          vstTree.IsVisible[Node] := not FIsFiltered or Data^.IsMatch;
          vstTree.InvalidateNode(Node);
        end;
        Node := Node.NextSibling;
      end;
    finally
      vstTree.EndUpdate;
    end;
  end;
end;

procedure TframeEmails.aSearchExecute(Sender: TObject);
begin
  inherited;
  FIsLoaded   := True;
  FIsFiltered := True;
  aFilter.Checked    := True;
  aFilter.ImageIndex := 56;
  Application.ProcessMessages;
  FPerformer.Start;
end;

procedure TframeEmails.ClearTree;
begin
  TGeneral.EmailList.ClearParentNodePointer;
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeEmails.CompletedItem(const aResultData: PResultData);
var
  arr:  array of array of string;
  ChildNode: PVirtualNode;
  Data: PEmail;
  MaxCol: Integer;
  Node: PVirtualNode;
  IsEmpty: Boolean;
begin
  if not Assigned(aResultData) then
    Exit;

  if not Assigned(aResultData^.ParentNode) then
  begin
    Node := vstTree.AddChild(nil);
    aResultData^.ParentNode := Node;
  end
  else
    Node := aResultData^.ParentNode;

  Data := Node^.GetData;
  Data^.Hash := aResultData.Hash;
  if (aResultData^.Position <= 0) then
    aResultData^.Position := vstTree.RootNode.ChildCount;

  MaxCol := 0;
  for var i := 0 to aResultData.Matches.Count - 1 do
    MaxCol := Max(MaxCol, aResultData.Matches[i].Count);

  IsEmpty := False;
  SetLength(arr, MaxCol, aResultData.Matches.Count);
  for var i := 0 to aResultData.Matches.Count - 1 do
    for var j := 0 to aResultData.Matches[i].Count - 1 do
    begin
      arr[j, i] := aResultData.Matches[i].Items[j].Trim;
      IsEmpty := IsEmpty or arr[j, i].IsEmpty;
    end;

  if not IsEmpty then
    for var i := Low(arr) to High(arr) do
    begin
      ChildNode := vstTree.AddChild(Node);
      Data := ChildNode^.GetData;
      Data^.Hash := aResultData.Hash;
      Data^.Matches.AddRange(arr[i]);
      aResultData^.IsMatch := True;
      vstTree.ValidateNode(ChildNode, False);
    end;

  vstTree.IsVisible[Node] := not FIsFiltered or aResultData^.IsMatch;
  vstTree.ValidateNode(Node, False);
end;

procedure TframeEmails.StartProgress(const aMaxPosition: Integer);
var
  CurrNode : PVirtualNode;
begin
  vstTree.BeginUpdate;
  TPublishers.EmailPublisher.FocusChanged(nil);
  if (aMaxPosition > 0) then
    TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [aMaxPosition]))
  else
    TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [vstTree.RootNode.ChildCount]));

  CurrNode := vstTree.RootNode.FirstChild;
  while Assigned(CurrNode) do
  begin
    if (CurrNode.ChildCount > 0) then
      vstTree.DeleteChildren(CurrNode);
    CurrNode := CurrNode.NextSibling;
  end;
end;

procedure TframeEmails.EndProgress;
begin
  FIsLoaded := False;
  vstTree.EndUpdate;

  if (FPerformer.FromDBCount > 0) then
    TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('SearchComplete') + sLineBreak +
                                   TLang.Lang.Translate('DuplicateCount'),
                                   [FPerformer.Count, FPerformer.FromDBCount]))
  else
    TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('SearchComplete'),
                                   [FPerformer.Count]));
  FPerformer.Clear;
end;

procedure TframeEmails.Progress;
begin

end;

end.
