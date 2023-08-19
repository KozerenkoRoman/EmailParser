unit Frame.ResultView;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Custom, System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles, Vcl.Samples.Gauges,
  Performer, Winapi.ShellAPI, Vcl.OleCtrls, SHDocVw, Winapi.ActiveX, Frame.Attachments, Files.Utils,
  VirtualTrees.ExportHelper, Global.Resources, Publishers, Publishers.Interfaces;
{$ENDREGION}

type
  TframeResultView = class(TFrameCustom, IProgress, IUpdateXML)
    aBreak           : TAction;
    aOpenEmail       : TAction;
    aOpenLogFile     : TAction;
    aSearch          : TAction;
    btnBreak         : TToolButton;
    btnOpenEmail     : TToolButton;
    btnOpenLogFile   : TToolButton;
    btnSearch        : TToolButton;
    btnSep04         : TToolButton;
    btnSep05         : TToolButton;
    frameAttachments : TframeAttachments;
    memTextPlain     : TMemo;
    pcInfo           : TPageControl;
    SaveDialogEmail  : TSaveDialog;
    splInfo          : TSplitter;
    tsAttachments    : TTabSheet;
    tsHtmlText       : TTabSheet;
    tsPlainText      : TTabSheet;
    wbBody           : TWebBrowser;
    procedure aBreakExecute(Sender: TObject);
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenEmailUpdate(Sender: TObject);
    procedure aOpenLogFileExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure aSearchUpdate(Sender: TObject);
    procedure pcInfoChange(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure wbBodyBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
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
    FPerformer: TPerformer;
    FIsLoaded: Boolean;

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

constructor TframeResultView.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TResultData);
  FPerformer := TPerformer.Create;
  TPublishers.UpdateXMLPublisher.Subscribe(Self);
  TPublishers.ProgressPublisher.Subscribe(Self);
end;

destructor TframeResultView.Destroy;
begin
  TPublishers.UpdateXMLPublisher.Unsubscribe(Self);
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  FreeAndNil(FPerformer);
  inherited;
end;

function TframeResultView.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeResultView.Initialize;
begin
  inherited Initialize;
  frameAttachments.Initialize;
  LoadFromXML;
  Translate;
  UpdateColumns;
end;

procedure TframeResultView.Deinitialize;
begin
  inherited Deinitialize;
  frameAttachments.Deinitialize;
end;

procedure TframeResultView.Translate;
begin
  inherited Translate;
  frameAttachments.Translate;
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_MESSAGE_ID].Text   := TLang.Lang.Translate('MessageId');
  vstTree.Header.Columns[COL_DATE].Text         := TLang.Lang.Translate('Date');
  vstTree.Header.Columns[COL_SUBJECT].Text      := TLang.Lang.Translate('Subject');
  vstTree.Header.Columns[COL_ATTACH].Text       := TLang.Lang.Translate('Attachment');
  vstTree.Header.Columns[COL_FROM].Text         := TLang.Lang.Translate('From');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');

  aOpenEmail.Hint     := TLang.Lang.Translate('OpenEmail');
  aOpenLogFile.Hint   := TLang.Lang.Translate('OpenLogFile');
  aSearch.Hint        := TLang.Lang.Translate('StartSearch');
  tsPlainText.Caption := TLang.Lang.Translate('PlainText');
end;

procedure TframeResultView.UpdateColumns;
var
  Column: TVirtualTreeColumn;
  FRegExpList: TArrayRecord<TRegExpData>;
  Node: PVirtualNode;
  Data: PResultData;
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
        Data := Node.GetData;
        Data.Matches.Count := FRegExpList.Count;
        Node := Node.NextSibling;
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

procedure TframeResultView.UpdateXML;
begin
  UpdateColumns;
end;

procedure TframeResultView.SaveToXML;
begin
  inherited;

end;

procedure TframeResultView.LoadFromXML;
begin
  inherited;

end;

procedure TframeResultView.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PResultData;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
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
//  else
//    if (Data1^.Matches.Count >= Column - C_FIXED_COLUMNS) then
//      Result := CompareText(Data1^.Matches.Items[Column - C_FIXED_COLUMNS], Data2^.Matches.Items[Column - C_FIXED_COLUMNS]);
  end;
end;

procedure TframeResultView.vstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PResultData;
begin
  inherited;
  if FIsLoaded then
    Exit;
  Data := Node^.GetData;
  frameAttachments.Load(Data);
  if (pcInfo.ActivePage = tsPlainText) then
  begin
    memTextPlain.Lines.Text := Data^.ParsedText;
    wbBody.Navigate(C_HTML_BLANK);
  end
  else if (pcInfo.ActivePage = tsHtmlText) then
  begin
    THtmlLib.LoadStringToBrowser(wbBody, Data^.Body);
    if Assigned(wbBody.Document) then
      with wbBody.Application as IOleobject do
        DoVerb(OLEIVERB_UIACTIVATE, nil, wbBody, 0, Handle, GetClientRect);
  end;
end;

procedure TframeResultView.wbBodyBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  inherited;
  Cancel := URL <> C_HTML_BLANK;
end;

procedure TframeResultView.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PResultData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeResultView.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PResultData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
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
    if (Data^.Matches.Count >= Column - C_FIXED_COLUMNS) then
      CellText := Data^.Matches.Items[Column - C_FIXED_COLUMNS];
  end;
end;

procedure TframeResultView.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeResultView.SearchText(const aText: string);
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

procedure TframeResultView.aBreakExecute(Sender: TObject);
begin
  inherited;
  FIsLoaded := False;
  FPerformer.Break;
  vstTree.EndUpdate;
end;

procedure TframeResultView.aSearchUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not FIsLoaded;
end;

procedure TframeResultView.aOpenEmailExecute(Sender: TObject);
var
  Data: PResultData;
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

procedure TframeResultView.aOpenEmailUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeResultView.aOpenLogFileExecute(Sender: TObject);
begin
  inherited;
  if FileExists(LogWriter.LogFileName) then
    TFileUtils.ShellOpen(LogWriter.LogFileName);
end;

procedure TframeResultView.aRefreshExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PResultData;
  ResultDataArray : TResultDataArray;
  Counter: Integer;
begin
  inherited;
  if (vstTree.RootNode.ChildCount > 0) then
  begin
    ResultDataArray.Count := vstTree.RootNode.ChildCount;
    Node := vstTree.RootNode.FirstChild;
    Counter := 0;
    while Assigned(Node) do
    begin
      Data := Node.GetData;
      ResultDataArray[Counter] := Data^;
      Node := Node.NextSibling;
      Inc(Counter);
    end;
    FPerformer.Refresh(@ResultDataArray);
  end;
end;

procedure TframeResultView.pcInfoChange(Sender: TObject);
var
  Data: PResultData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;

    if (pcInfo.ActivePage = tsPlainText) and (not memTextPlain.Lines.Text.Equals(Data^.Body)) then
    begin
      memTextPlain.Lines.Text := Data^.ParsedText;
    end
    else if (pcInfo.ActivePage = tsHtmlText) then
    begin
      if not Assigned(wbBody.Document) or (wbBody.LocationURL = C_HTML_BLANK) then
        THtmlLib.LoadStringToBrowser(wbBody, Data^.Body);
      if Assigned(wbBody.Document) then
        with wbBody.Application as IOleobject do
          DoVerb(OLEIVERB_UIACTIVATE, nil, wbBody, 0, Handle, GetClientRect);
    end;
  end;
end;

procedure TframeResultView.aSaveExecute(Sender: TObject);
var
  Data: PResultData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TFile.Exists(Data^.FileName) then
    begin
      SaveDialogEmail.InitialDir := TPath.GetDirectoryName(Data^.FileName);
      SaveDialogEmail.FileName   := Data^.FileName;
      if SaveDialogEmail.Execute and (SaveDialogEmail.FileName <> Data^.FileName) then
        TFile.Copy(Data^.FileName, SaveDialogEmail.FileName);
    end
    else
      TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeResultView.aSearchExecute(Sender: TObject);
begin
  inherited;
  vstTree.Clear;
  frameAttachments.Clear;
  FIsLoaded := True;
  Application.ProcessMessages;
  FPerformer.Start;
end;

procedure TframeResultView.CompletedItem(const aResultData: TResultData);
var
  Data: PResultData;
  Node: PVirtualNode;
begin
  if Assigned(aResultData.ParentNode) then
    Node := aResultData.ParentNode
  else
    Node := vstTree.AddChild(nil);
  Data := Node^.GetData;
  Data^.Assign(aResultData);
  Data^.ParentNode := Node;
  if (Data^.Position = -1) then
    Data^.Position := vstTree.TotalCount;
end;

procedure TframeResultView.StartProgress(const aMaxPosition: Integer);
begin
  vstTree.BeginUpdate;
  TMessageDialog.ShowInfo(Format(TLang.Lang.Translate('FoundFiles'), [aMaxPosition]));
end;

procedure TframeResultView.EndProgress;
begin
  FIsLoaded := False;
  vstTree.EndUpdate;
end;

procedure TframeResultView.Progress;
begin

end;

end.
