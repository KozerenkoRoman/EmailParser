unit Frame.Emails;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, XmlFiles, Vcl.Samples.Gauges,
  Performer, Winapi.ShellAPI, Vcl.OleCtrls, SHDocVw, Winapi.ActiveX, Frame.Attachments, Files.Utils, DaModule,
  VirtualTrees.ExportHelper, Global.Resources, Publishers, Publishers.Interfaces, Vcl.WinXPanels, Frame.Custom;
{$ENDREGION}

type
  TframeEmails = class(TframeSource, IProgress, IConfig)
    aBreak          : TAction;
    aFilter         : TAction;
    aOpenEmail      : TAction;
    aOpenLocation   : TAction;
    aSearch         : TAction;
    btnBreak        : TToolButton;
    btnFilter       : TToolButton;
    btnOpenEmail    : TToolButton;
    btnSearch       : TToolButton;
    btnSep04        : TToolButton;
    btnSep05        : TToolButton;
    miOpenEmail     : TMenuItem;
    miOpenLocation  : TMenuItem;
    miSep           : TMenuItem;
    SaveDialogEmail : TSaveDialog;
    procedure aBreakExecute(Sender: TObject);
    procedure aExpandAllUpdate(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenEmailUpdate(Sender: TObject);
    procedure aOpenLocationExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aSearchUpdate(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeFocusChanging(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
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
    COL_ID            = 9;
    COL_HASH          = 10;
    C_FIXED_COLUMNS   = 11;

    C_IDENTITY_NAME = 'frameResultView';
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

{ TframeResultView }

constructor TframeEmails.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TEmail);
  FPerformer := TPerformer.GetInstance;
  TPublishers.ProgressPublisher.Subscribe(Self);
  TPublishers.ConfigPublisher.Subscribe(Self);
  TPublishers.ConfigPublisher.Subscribe(TPerformer.GetInstance);
  FIsFiltered := False;
end;

destructor TframeEmails.Destroy;
begin
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(TPerformer.GetInstance);
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
  vstTree.Header.Columns[COL_HASH].Text         := TLang.Lang.Translate('Hash');

  aBreak.Hint           := TLang.Lang.Translate('Break');
  aFilter.Hint          := TLang.Lang.Translate('Filter');
  aOpenEmail.Caption    := TLang.Lang.Translate('OpenEmail');
  aOpenEmail.Hint       := TLang.Lang.Translate('OpenEmail');
  aOpenLocation.Caption := TLang.Lang.Translate('OpenLocation');
  aOpenLocation.Hint    := TLang.Lang.Translate('OpenLocation');
  aSearch.Hint          := TLang.Lang.Translate('StartSearch');
end;

procedure TframeEmails.UpdateColumns;
var
  Column     : TVirtualTreeColumn;
  CurrNode   : PVirtualNode;
  Node       : PVirtualNode;
  DataEmail  : PEmail;
begin
  vstTree.BeginUpdate;
  try
    while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
      vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

    Node := vstTree.RootNode.FirstChild;
    while Assigned(Node) do
    begin
      DataEmail := Node^.GetData;
      DataEmail^.Matches.Count := TGeneral.PatternList.Count;
      if (Node.ChildCount > 0) then
      begin
        CurrNode := Node.FirstChild;
        while Assigned(CurrNode) do
        begin
          DataEmail := CurrNode^.GetData;
          DataEmail^.Matches.Count := TGeneral.PatternList.Count;
          CurrNode := CurrNode.NextSibling;
        end;
      end;
      Node := Node.NextSibling;
    end;

    for var ResultData in TGeneral.EmailList.Values do
    begin
      ResultData.Matches.Count := TGeneral.PatternList.Count;
      if Assigned(ResultData.OwnerNode) then
        if (ResultData.OwnerNode.ChildCount > 0) then
        begin
          CurrNode := ResultData.OwnerNode.FirstChild;
          while Assigned(CurrNode) do
          begin
            DataEmail := CurrNode^.GetData;
            DataEmail^.Matches.Count := TGeneral.PatternList.Count;
            CurrNode := CurrNode.NextSibling;
          end;
        end;
    end;

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

procedure TframeEmails.SaveToXML;
begin
  inherited;

end;

procedure TframeEmails.LoadFromXML;
begin
  inherited;

end;

procedure TframeEmails.UpdateFilter(const aOperation: TFilterOperation);
var
  ChildMatches  : Cardinal;
  ChildNode     : PVirtualNode;
  Data          : PEmail;
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
        Result := CompareValue(vstTree.AbsoluteIndex(Node1), vstTree.AbsoluteIndex(Node2));
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
        Result := CompareValue(Data1^.Attachments.Count, Data2^.Attachments.Count);
      COL_FROM:
        Result := CompareText(Data1^.From, Data2^.From);
      COL_CONTENT_TYPE:
        Result := CompareText(Data1^.ContentType, Data2^.ContentType);
      COL_ID:
        Result := CompareText(Data1^.Id, Data2^.Id);
      COL_HASH:
        Result := CompareText(Data1^.Hash, Data2^.Hash);
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
          TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
          TargetCanvas.FillRect(CellRect);
        end;
    end
    else
    begin
      Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
      if Assigned(Data) then
        if (Data^.Matches[Column - C_FIXED_COLUMNS].Count > 0) then
        begin
          TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
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
  CellText := '';
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
          CellText := (vstTree.AbsoluteIndex(Node) + 1).ToString;
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
          if (Data^.Attachments.Count > 0) then
            CellText := Data^.Attachments.Count.ToString;
        COL_FROM:
          CellText := Data^.From;
        COL_CONTENT_TYPE:
          CellText := Data^.ContentType;
        COL_ID:
          CellText := Data^.Id;
        COL_HASH:
          CellText := Data^.Hash;
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

procedure TframeEmails.aOpenLocationExecute(Sender: TObject);
var
  Data: PResultData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
      if not string(Data^.FileName).IsEmpty then
        Winapi.ShellAPI.ShellExecute(0, nil, 'explorer.exe', PChar('/select,' + Data^.FileName), nil, SW_SHOWNORMAL)
  end;
end;

procedure TframeEmails.aRefreshExecute(Sender: TObject);
begin
  inherited;
  if (vstTree.RootNode.ChildCount > 0) then
  begin
    FIsLoaded   := True;
    FIsFiltered := True;
    aFilter.Checked    := True;
    aFilter.ImageIndex := 53;
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

procedure TframeEmails.aExpandAllUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded
end;

procedure TframeEmails.aFilterExecute(Sender: TObject);
begin
  inherited;
  FIsFiltered := TAction(Sender).Checked;
  if TAction(Sender).Checked then
    TAction(Sender).ImageIndex := 53
  else
    TAction(Sender).ImageIndex := 3;

  UpdateFilter(foOR);
end;

procedure TframeEmails.aSearchExecute(Sender: TObject);
begin
  inherited;
  FIsLoaded   := True;
  FIsFiltered := True;
  aFilter.Checked    := True;
  aFilter.ImageIndex := 53;
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

procedure TframeEmails.CompletedAttach(const aAttachment: PAttachment);
begin
  //nothing
end;

procedure TframeEmails.CompletedItem(const aResultData: PResultData);
var
  arr       : array of array of string;
  ChildNode : PVirtualNode;
  Data      : PEmail;
  MaxCol    : Integer;
  Node      : PVirtualNode;
  IsEmpty   : Boolean;
begin
  if not Assigned(aResultData) then
    Exit;

  if not Assigned(aResultData^.OwnerNode) then
  begin
    Node := vstTree.AddChild(nil);
    aResultData^.OwnerNode := Node;
  end
  else
    Node := aResultData^.OwnerNode;

  Data := Node^.GetData;
  Data^.Hash := aResultData.Hash;

  MaxCol := 0;
  for var i := 0 to aResultData.Matches.Count - 1 do
    MaxCol := Max(MaxCol, aResultData.Matches[i].Count);

  SetLength(arr, MaxCol, aResultData.Matches.Count);
  for var i := 0 to aResultData.Matches.Count - 1 do
    for var j := 0 to aResultData.Matches[i].Count - 1 do
      arr[j, i] := aResultData.Matches[i].Items[j].Trim;

  for var i := Low(arr) to High(arr) do
  begin
    IsEmpty := True;
    for var j := Low(arr[i]) to High(arr[i]) do
      IsEmpty := IsEmpty and string(arr[i]).IsEmpty;
    if not IsEmpty then
    begin
      ChildNode := vstTree.AddChild(Node);
      Data := ChildNode^.GetData;
      Data^.Hash := aResultData.Hash;
      Data^.Matches.AddRange(arr[i]);
      vstTree.ValidateNode(ChildNode, False);
    end;
  end;
  vstTree.IsVisible[Node] := not FIsFiltered or (Node.ChildCount > 0);
  vstTree.ValidateNode(Node, False);
end;

procedure TframeEmails.StartProgress(const aMaxPosition: Integer);
var
  CurrNode : PVirtualNode;
begin
  vstTree.BeginUpdate;
  TPublishers.EmailPublisher.FocusChanged(nil);
  CurrNode := vstTree.RootNode.FirstChild;
  while Assigned(CurrNode) do
  begin
    if (CurrNode.ChildCount > 0) then
      vstTree.DeleteChildren(CurrNode);
    CurrNode := CurrNode.NextSibling;
  end;

  if not FPerformer.IsQuiet then
  begin
    if (aMaxPosition > 0) then
      TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [aMaxPosition]))
    else
      TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [vstTree.RootNode.ChildCount]));
  end;
end;

procedure TframeEmails.EndProgress;
begin
  FIsLoaded := False;
  vstTree.EndUpdate;

   if not FPerformer.IsQuiet then
  begin
    if (FPerformer.FromDBCount > 0) then
      TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('SearchComplete') + sLineBreak +
                                     TLang.Lang.Translate('DuplicateCount'),
                                     [FPerformer.Count, FPerformer.FromDBCount]))
    else
      TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('SearchComplete'),
                                     [FPerformer.Count]));
  end;
  FPerformer.Clear;
end;

procedure TframeEmails.Progress;
begin
  // Nothing
end;

end.
