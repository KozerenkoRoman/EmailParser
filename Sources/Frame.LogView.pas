unit Frame.LogView;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Custom, System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles;
{$ENDREGION}

type
  PLogData = ^TLogData;
  TLogData = record
    TimeStamp  : TDateTime;
    Operation  : string;
    Info       : string;
    DetailType : TLogDetailType;
    procedure Clear;
  end;

  TframeLogView = class(TframeCustom)
    aOpenLogFile: TAction;
    btnExecute: TToolButton;
    btnOpenLogFile: TToolButton;
    procedure aOpenLogFileExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
  private const
    COL_TIME      = 2;
    COL_OPERATION = 0;
    COL_INFO      = 1;

    C_IDENTITY_NAME = 'frameLogView';
  private
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
    procedure SearchText(const aText: string); override;
    procedure Write(const aDetailType: TLogDetailType; const aOperation, aInfo: string);
  end;

implementation

{$R *.dfm}

{ TframeLogView }

constructor TframeLogView.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TLogData);
end;

destructor TframeLogView.Destroy;
begin

  inherited;
end;

function TframeLogView.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeLogView.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  vstTree.FullExpand;
  vstTree.Header.Columns[COL_INFO].Text      := TLang.Lang.Translate('Info');
  vstTree.Header.Columns[COL_OPERATION].Text := TLang.Lang.Translate('Operation');
  vstTree.Header.Columns[COL_TIME].Text      := TLang.Lang.Translate('Time');
  btnExecute.Left       := 1;
  btnSep02.Left         := 500;
  btnExportToExcel.Left := 500;
  btnExportToCSV.Left   := 500;
  btnPrint.Left         := 500;
end;

procedure TframeLogView.Deinitialize;
begin
  inherited Deinitialize;
end;

procedure TframeLogView.SaveToXML;

begin
  inherited;

end;

procedure TframeLogView.LoadFromXML;
begin
  inherited;

end;

procedure TframeLogView.Write(const aDetailType: TLogDetailType; const aOperation, aInfo: string);
var
  Data: PLogData;
  NewNode: PVirtualNode;
  Info: string;
begin
  Info := aInfo;
  if (aDetailType = ddEnterMethod) then
    Info := Info + ' :' + TLang.Lang.Translate('Begin')
  else if (aDetailType = ddExitMethod) then
    Info := Info + ' :' + TLang.Lang.Translate('End');

  LogWriter.Write(aDetailType, Self, aOperation, Info);
  vstTree.BeginUpdate;
  try
    NewNode := vstTree.AddChild(nil);
    Data := NewNode.GetData;
    Data.TimeStamp := Now;
    Data.DetailType := aDetailType;
    Data.Info := Info;
    Data.Operation := aOperation;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeLogView.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PLogData;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_INFO:
      Result := CompareText(Data1^.Info, Data2^.Info);
    COL_OPERATION:
      Result := CompareText(Data1^.Operation, Data2^.Operation);
    COL_TIME:
      Result := CompareValue(Data1^.TimeStamp, Data2^.TimeStamp);
  end;
end;

procedure TframeLogView.vstTreeDrawText(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; const Text: string; const CellRect: TRect; var DefaultDraw: Boolean);
var
  Data: PLogData;
begin
  inherited;
  Data := Node^.GetData;
  case Data.DetailType of
    ddError:
      TargetCanvas.Font.Color := clRed;
    ddWarning:
      TargetCanvas.Font.Color := clMaroon;
    ddEnterMethod, ddExitMethod:
      TargetCanvas.Font.Color := clNavy;
  end;
end;

procedure TframeLogView.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PLogData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeLogView.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PLogData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_OPERATION:
      CellText := Data^.Operation;
    COL_INFO:
      CellText := Data^.Info;
    COL_TIME:
      CellText := FormatDateTime('hh:nn:ss.zzz', Data^.TimeStamp);
  end
end;

procedure TframeLogView.vstTreeInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  inherited;
  Node.States := Node.States + [vsMultiline];
end;

procedure TframeLogView.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeLogView.SearchText(const aText: string);
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

procedure TframeLogView.aOpenLogFileExecute(Sender: TObject);
begin
  inherited;
  if FileExists(LogWriter.LogFileName) then
    ShellOpen(PChar(LogWriter.LogFileName));
end;

{ TLogData }

procedure TLogData.Clear;
begin
  Self := Default(TLogData);
end;

end.
