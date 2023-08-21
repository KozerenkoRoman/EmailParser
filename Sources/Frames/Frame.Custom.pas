unit Frame.Custom;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.Threading, System.Generics.Collections, Vcl.ActnList,
  System.Generics.Defaults, DebugWriter, Global.Types, System.IniFiles, System.Math, System.Actions, Vcl.Menus,
  Vcl.ExtDlgs, Vcl.Printers, MessageDialog, VirtualTrees.ExportHelper, DaImages, Common.Types, Vcl.ComCtrls,
  Vcl.ToolWin, Translate.Lang, VirtualTrees.Helper, Column.Settings, Global.Resources, Vcl.WinXPanels;
{$ENDREGION}

type
  TFrameCustom = class(TFrame)
    aAdd              : TAction;
    aColumnSettings   : TAction;
    aDelete           : TAction;
    aEdit             : TAction;
    aExportToCSV      : TAction;
    aExportToExcel    : TAction;
    alFrame           : TActionList;
    aPrint            : TAction;
    aRefresh          : TAction;
    aSave             : TAction;
    btnAdd            : TToolButton;
    btnColumnSettings : TToolButton;
    btnDelete         : TToolButton;
    btnEdit           : TToolButton;
    btnExportToCSV    : TToolButton;
    btnExportToExcel  : TToolButton;
    btnPrint          : TToolButton;
    btnRefresh        : TToolButton;
    btnSave           : TToolButton;
    btnSep01          : TToolButton;
    btnSep02          : TToolButton;
    btnSep03          : TToolButton;
    crdMain           : TCard;
    pmFrame           : TPopupMenu;
    pnlFrame          : TCardPanel;
    tbMain            : TToolBar;
    vstTree           : TVirtualStringTree;
    procedure aCollapseAllExecute(Sender: TObject);
    procedure aColumnSettingsExecute(Sender: TObject);
    procedure aExpandAllExecute(Sender: TObject);
    procedure aExportToCSVExecute(Sender: TObject);
    procedure aExportToExcelExecute(Sender: TObject);
    procedure aExportToHTMLExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
    procedure vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
  private const
    C_IDENTITY_NAME = 'frameCustom';
  protected
    function GetIdentityName: string; virtual;
    procedure Deinitialize; virtual;
    procedure Initialize; virtual;
    procedure Translate; virtual;
    procedure SaveToXML; virtual; abstract;
    procedure LoadFromXML; virtual; abstract;
    procedure SearchText(const aText: string); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

{ TFrameCustom }

constructor TFrameCustom.Create(AOwner: TComponent);
begin
  inherited;
  TVirtualTree.Initialize(vstTree);
end;

destructor TFrameCustom.Destroy;
begin

  inherited;
end;

procedure TFrameCustom.Initialize;
begin
  TStoreHelper.LoadFromXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  tbMain.ButtonHeight := C_ICON_SIZE;
  tbMain.ButtonWidth  := C_ICON_SIZE;
  tbMain.Height       := C_ICON_SIZE + 2;
  vstTree.FullExpand;
end;

procedure TFrameCustom.Translate;
begin
  aAdd.Hint            := TLang.Lang.Translate('Add');
  aColumnSettings.Hint := TLang.Lang.Translate('ColumnSettings');
  aDelete.Hint         := TLang.Lang.Translate('Delete');
  aEdit.Hint           := TLang.Lang.Translate('Edit');
  aExportToCSV.Hint    := TLang.Lang.Translate('ExportToCSV');
  aExportToExcel.Hint  := TLang.Lang.Translate('ExportToExcel');
  aPrint.Hint          := TLang.Lang.Translate('Print');
  aRefresh.Hint        := TLang.Lang.Translate('Refresh');
  aSave.Hint           := TLang.Lang.Translate('Save');
end;

procedure TFrameCustom.Deinitialize;
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

function TFrameCustom.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TFrameCustom.vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TFrameCustom.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
//
end;

procedure TFrameCustom.vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TFrameCustom.vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if Sender.MultiLine[Node] then
  begin
    TargetCanvas.Font := Sender.Font;
    NodeHeight := vstTree.ComputeNodeHeight(TargetCanvas, Node, 0) + 6;
  end;
end;

procedure TFrameCustom.aCollapseAllExecute(Sender: TObject);
begin
  vstTree.FullCollapse(nil);
end;

procedure TFrameCustom.aColumnSettingsExecute(Sender: TObject);
begin
  if TfrmColumnSettings.ShowSettings(vstTree, GetIdentityName, 0) = mrOk then
    TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TFrameCustom.aExpandAllExecute(Sender: TObject);
begin
  vstTree.FullExpand(nil);
end;

procedure TFrameCustom.aExportToCSVExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToCSV(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrameCustom.aExportToExcelExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToExcel(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrameCustom.aExportToHTMLExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    TExcelExportHelper.ExportToHTML(vstTree, GetIdentityName);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFrameCustom.aPrintExecute(Sender: TObject);
begin
  Printer.Orientation := poLandscape;
  vstTree.Print(Printer, True);
end;

end.
