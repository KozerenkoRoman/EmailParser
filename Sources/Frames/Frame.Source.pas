unit Frame.Source;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.Threading, System.Generics.Collections, Vcl.ActnList,
  System.Generics.Defaults, DebugWriter, Global.Types, System.IniFiles, System.Math, System.Actions, Vcl.Menus,
  Vcl.ExtDlgs, Vcl.Printers, MessageDialog, VirtualTrees.ExportHelper, DaImages, Common.Types, Vcl.ComCtrls,
  Vcl.ToolWin, Translate.Lang, VirtualTrees.Helper, Column.Settings, Global.Resources, Vcl.WinXPanels, Frame.Custom;
{$ENDREGION}

type
  TframeSource = class(TFrameCustom)
    aCollapseAll      : TAction;
    aColumnSettings   : TAction;
    aExpandAll        : TAction;
    aExportToCSV      : TAction;
    aExportToExcel    : TAction;
    aPrint            : TAction;
    btnColumnSettings : TToolButton;
    btnExportToCSV    : TToolButton;
    btnExportToExcel  : TToolButton;
    btnPrint          : TToolButton;
    btnSep03          : TToolButton;
    miCollapseAll     : TMenuItem;
    miExpandAll       : TMenuItem;
    vstTree           : TVirtualStringTree;
    procedure aCollapseAllExecute(Sender: TObject);
    procedure aColumnSettingsExecute(Sender: TObject);
    procedure aExpandAllExecute(Sender: TObject);
    procedure aExportToCSVExecute(Sender: TObject);
    procedure aExportToExcelExecute(Sender: TObject);
    procedure aExportToExcelUpdate(Sender: TObject);
    procedure aExportToHTMLExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    procedure vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
    procedure vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
  private const
    C_IDENTITY_NAME = 'frameSource';
  protected
    function GetIdentityName: string; override;
    procedure Deinitialize; override;
    procedure Initialize; override;
    procedure Translate; override;
    procedure SaveToXML; override;
    procedure LoadFromXML; override;
    procedure SearchText(const aText: string); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TFrameSource }

constructor TframeSource.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TframeSource.Destroy;
begin

  inherited;
end;

procedure TframeSource.Initialize;
begin
  inherited;
  TVirtualTree.Initialize(vstTree);
  LoadFromXML;
  tbMain.ButtonHeight := C_ICON_SIZE;
  tbMain.ButtonWidth  := C_ICON_SIZE;
  tbMain.Height       := C_ICON_SIZE + 2;
  vstTree.FullExpand;
end;

procedure TframeSource.Translate;
begin
  inherited;
  aAdd.Hint            := TLang.Lang.Translate('Add');
  aCollapseAll.Caption := TLang.Lang.Translate('CollapseAll');
  aColumnSettings.Hint := TLang.Lang.Translate('ColumnSettings');
  aDelete.Hint         := TLang.Lang.Translate('Delete');
  aEdit.Hint           := TLang.Lang.Translate('Edit');
  aExpandAll.Caption   := TLang.Lang.Translate('ExpandAll');
  aExportToCSV.Hint    := TLang.Lang.Translate('ExportToCSV');
  aExportToExcel.Hint  := TLang.Lang.Translate('ExportToExcel');
  aPrint.Hint          := TLang.Lang.Translate('Print');
  aRefresh.Hint        := TLang.Lang.Translate('Refresh');
  aSave.Hint           := TLang.Lang.Translate('Save');
end;

procedure TframeSource.Deinitialize;
begin
  SaveToXML;
  inherited;
end;

function TframeSource.GetIdentityName: string;
begin
  inherited;
  Result := C_IDENTITY_NAME;
end;

procedure TframeSource.LoadFromXML;
begin
  inherited;
  TStoreHelper.LoadFromXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeSource.SaveToXML;
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  inherited;
end;

procedure TframeSource.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeSource.SearchText(const aText: string);
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

procedure TframeSource.vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
begin
  inherited;
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeSource.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
//
end;

procedure TframeSource.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
begin
  inherited;
  CellText := '';
end;

procedure TframeSource.vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
begin
  inherited;
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeSource.vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  inherited;
  if Sender.MultiLine[Node] then
  begin
    TargetCanvas.Font := Sender.Font;
    NodeHeight := vstTree.ComputeNodeHeight(TargetCanvas, Node, 0) + 6;
  end;
end;

procedure TframeSource.aCollapseAllExecute(Sender: TObject);
begin
  inherited;
  vstTree.BeginUpdate;
  try
    vstTree.FullCollapse;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeSource.aColumnSettingsExecute(Sender: TObject);
begin
  inherited;
  if TfrmColumnSettings.ShowSettings(vstTree, GetIdentityName, 0) = mrOk then
    TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeSource.aExpandAllExecute(Sender: TObject);
begin
  inherited;
  vstTree.BeginUpdate;
  try
    vstTree.FullExpand;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeSource.aExportToCSVExecute(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToCSV(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TframeSource.aExportToExcelExecute(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToExcel(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TframeSource.aExportToExcelUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TframeSource.aExportToHTMLExecute(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToHTML(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TframeSource.aPrintExecute(Sender: TObject);
begin
  inherited;
  Printer.Orientation := poLandscape;
  vstTree.Print(Printer, True);
end;

end.
