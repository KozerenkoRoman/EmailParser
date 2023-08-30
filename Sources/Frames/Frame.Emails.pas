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
  TframeEmails = class(TFrameSource, IProgress, IUpdateXML)
    aBreak          : TAction;
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
    SaveDialogEmail : TSaveDialog;
    procedure aBreakExecute(Sender: TObject);
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
    procedure vstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
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
    procedure UpdateXML;

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

  aOpenEmail.Hint   := TLang.Lang.Translate('OpenEmail');
  aOpenLogFile.Hint := TLang.Lang.Translate('OpenLogFile');
  aSearch.Hint      := TLang.Lang.Translate('StartSearch');
end;

procedure TframeEmails.UpdateColumns;
var
  Column: TVirtualTreeColumn;
  RegExpList: TArrayRecord<TRegExpData>;
begin
  vstTree.BeginUpdate;
  RegExpList := TGeneral.GetRegExpParametersList;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  for var item in TGeneral.EmailList.Values do
    item.Matches.Count := RegExpList.Count;

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

procedure TframeEmails.UpdateXML;
begin
  UpdateColumns;
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
  else
    if (Column >= 0) and
       (Data1^.Matches.Count > 0) and
       (Data2^.Matches.Count > 0) and
       (Data1^.Matches.Count >= Column - C_FIXED_COLUMNS) and
       (Data2^.Matches.Count >= Column - C_FIXED_COLUMNS) then
      Result := CompareText(Data1^.Matches.Items[Column - C_FIXED_COLUMNS], Data2^.Matches.Items[Column - C_FIXED_COLUMNS]);
  end;
end;

procedure TframeEmails.vstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PResultData;
begin
  inherited;
  if FIsLoaded then
    Exit;
  if Assigned(Node) then
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
    if Assigned(Data) then
      TPublishers.EmailPublisher.FocusChanged(Data);
  end
  else
    TPublishers.EmailPublisher.FocusChanged(nil);
end;

procedure TframeEmails.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PResultData;
begin
  if (Column >= C_FIXED_COLUMNS) then
  begin
    Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
    if Assigned(Data) then
      if not Data^.Matches[Column - C_FIXED_COLUMNS].IsEmpty then
      begin
        TargetCanvas.Brush.Color := arrWebColors[Column - C_FIXED_COLUMNS];
        TargetCanvas.FillRect(CellRect);
      end;
  end;
end;

procedure TframeEmails.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PResultData;
begin
  inherited;
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
      if (Column >= 0) and (Data^.Matches.Count >= Column - C_FIXED_COLUMNS) then
        CellText := Data^.Matches.Items[Column - C_FIXED_COLUMNS];
    end;
end;

procedure TframeEmails.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PResultData;
begin
  inherited;
  Data := TGeneral.EmailList.GetItem(PEmail(Node^.GetData).Hash);
  if Assigned(Data) then
    if (Column in [COL_FILE_NAME, COL_SHORT_NAME]) and Data^.FromDB then
    begin
      TargetCanvas.Font.Style := [fsBold];
      TargetCanvas.Font.Color := clNavy;
    end;
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
  FPerformer.Break;
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
    FPerformer.RefreshEmails;
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
  FIsLoaded := True;
  Application.ProcessMessages;
  FPerformer.Start;
end;

procedure TframeEmails.ClearTree;
begin
  TGeneral.EmailList.ClearData;
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeEmails.CompletedItem(const aResultData: PResultData);
var
  Node: PVirtualNode;
  Data: PEmail;
begin
  if not Assigned(aResultData) then
    Exit;
  Node := vstTree.AddChild(nil);
  Data := Node^.GetData;
  Data^.Hash := aResultData.Hash;
  vstTree.IsVisible[Node] := not FIsFiltered or aResultData^.IsMatch;
  vstTree.ValidateNode(Node, False);
  aResultData^.Position := vstTree.AbsoluteIndex(Node) + 1;
end;

procedure TframeEmails.StartProgress(const aMaxPosition: Integer);
begin
  vstTree.BeginUpdate;
  TPublishers.EmailPublisher.FocusChanged(nil);
  TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [aMaxPosition]));
end;

procedure TframeEmails.EndProgress;
begin
  FIsLoaded := False;
  vstTree.EndUpdate;
  if (FPerformer.DuplicateCount > 0) then
    TMessageDialog.ShowInfo(TLang.Lang.Translate('SearchComplete') + sLineBreak +
                            Format(TLang.Lang.Translate('DuplicateCount'), [FPerformer.DuplicateCount]))
  else
    TMessageDialog.ShowInfo(TLang.Lang.Translate('SearchComplete'));
  FPerformer.Clear;
end;

procedure TframeEmails.Progress;
begin

end;

end.
