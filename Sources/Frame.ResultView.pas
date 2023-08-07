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
  Performer;
{$ENDREGION}

type
  TframeResultView = class(TframeCustom)
    aOpenEmail     : TAction;
    aOpenLogFile   : TAction;
    aSearch        : TAction;
    btnBreak       : TBitBtn;
    btnOpenEmail   : TToolButton;
    btnOpenLogFile : TToolButton;
    btnSearch      : TToolButton;
    gbInfo         : TGroupBox;
    gProgress      : TGauge;
    memInfo        : TMemo;
    pnlBottom      : TPanel;
    splInfo        : TSplitter;
    procedure aOpenEmailExecute(Sender: TObject);
    procedure aOpenLogFileExecute(Sender: TObject);
    procedure aSearchExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private const
    COL_FILE_NAME  = 0;
    COL_MESSAGE_ID = 1;
    COL_DATE       = 2;
    COL_SUBJECT    = 3;
    COL_ATTACH     = 4;

    C_IDENTITY_NAME = 'frameResultView';
  private
    FPerformer: TPerformer;
    procedure DoEndEvent;
    procedure DoStartProgressEvent(const aMaxPosition: Integer);
    procedure DoProgressEvent;
    procedure DoCompletedItem(const aResultData: TResultData);

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
  FPerformer.OnEndEvent           := DoEndEvent;
  FPerformer.OnStartProgressEvent := DoStartProgressEvent;
  FPerformer.OnProgressEvent      := DoProgressEvent;
  FPerformer.OnCompletedItem      := DoCompletedItem;
end;

destructor TframeResultView.Destroy;
begin
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
  LoadFromXML;
  vstTree.FullExpand;
  Translate;

  btnSearch.Left        := 1;
  btnSep02.Left         := 500;
  btnExportToExcel.Left := 500;
  btnExportToCSV.Left   := 500;
  btnPrint.Left         := 500;

  gProgress.ForeColor := C_TOP_COLOR;
  gProgress.Progress  := 0;
end;

procedure TframeResultView.Translate;
begin
  inherited;
  vstTree.Header.Columns[COL_FILE_NAME].Text  := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_MESSAGE_ID].Text := TLang.Lang.Translate('MessageId');
  vstTree.Header.Columns[COL_DATE].Text       := TLang.Lang.Translate('Date');
  vstTree.Header.Columns[COL_SUBJECT].Text    := TLang.Lang.Translate('Subject');
  vstTree.Header.Columns[COL_ATTACH].Text     := TLang.Lang.Translate('Attachment');

  aOpenLogFile.Hint := TLang.Lang.Translate('OpenLogFile');
  aSearch.Hint      := TLang.Lang.Translate('StartSearch');
  gbInfo.Caption    := TLang.Lang.Translate('Info');
  aOpenEmail.Hint   := TLang.Lang.Translate('OpenEmail');
end;

procedure TframeResultView.Deinitialize;
begin
  inherited Deinitialize;
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
    COL_FILE_NAME:
      Result := CompareText(Data1^.ShortName, Data2^.ShortName);
    COL_MESSAGE_ID:
      Result := CompareText(Data1^.MessageId, Data2^.MessageId);
    COL_DATE:
      Result := CompareValue(Data1^.TimeStamp, Data2^.TimeStamp);
    COL_SUBJECT:
      Result := CompareText(Data1^.Subject, Data2^.Subject);
    COL_ATTACH:
      Result := CompareValue(Data1^.Attach, Data2^.Attach);
  end;
end;

procedure TframeResultView.vstTreeDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
//var
//  Data: PResultData;
begin
  inherited;
//  Data := Node^.GetData;
//  case Data.DetailType of
//    ddError:
//      TargetCanvas.Font.Color := clRed;
//    ddWarning:
//      TargetCanvas.Font.Color := clMaroon;
//    ddEnterMethod, ddExitMethod:
//      TargetCanvas.Font.Color := clNavy;
//  end;
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
    COL_FILE_NAME:
      CellText := Data^.ShortName;
    COL_MESSAGE_ID:
      CellText := Data^.MessageId;
    COL_DATE:
      CellText := DateTimeToStr(Data^.TimeStamp);
    COL_SUBJECT:
      CellText := Data^.Subject;
    COL_ATTACH:
      CellText := Data^.Attach.ToString;
  end;
end;

procedure TframeResultView.vstTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  inherited;
  Node.States := Node.States + [vsMultiline];
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

procedure TframeResultView.aOpenEmailExecute(Sender: TObject);
begin
  inherited;
//
end;

procedure TframeResultView.aOpenLogFileExecute(Sender: TObject);
begin
  inherited;
  if FileExists(LogWriter.LogFileName) then
    ShellOpen(PChar(LogWriter.LogFileName));
end;

procedure TframeResultView.aSearchExecute(Sender: TObject);
begin
  inherited;
  vstTree.Clear;
  Application.ProcessMessages;
  FPerformer.Start;
end;

procedure TframeResultView.DoCompletedItem(const aResultData: TResultData);
var
  Data: PResultData;
  NewNode: PVirtualNode;
begin
  vstTree.BeginUpdate;
  try
    NewNode := vstTree.AddChild(nil);
    Data := NewNode.GetData;
    Data^.Assign(aResultData);
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeResultView.DoEndEvent;
begin
  btnBreak.Enabled    := False;
  btnBreak.Caption    := TLang.Lang.Translate('Ok');
  btnBreak.ImageIndex := 46;
  gProgress.Progress  := 0;
  gProgress.Visible   := False;
end;

procedure TframeResultView.DoProgressEvent;
begin
  if (gProgress.Progress >= gProgress.MaxValue) then
    gProgress.MaxValue := gProgress.MaxValue + 1;
  gProgress.Progress := gProgress.Progress + 1;
  gProgress.Refresh;
end;

procedure TframeResultView.DoStartProgressEvent(const aMaxPosition: Integer);
begin
  gProgress.Visible := True;
  gProgress.MaxValue := aMaxPosition;
  gProgress.Progress := 0;
end;

end.
