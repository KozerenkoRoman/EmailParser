unit Frame.Custom;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.Threading, System.Generics.Collections, Vcl.ActnList,
  System.Generics.Defaults, DebugWriter, Global.Types, System.IniFiles, System.Math, System.Actions, Vcl.Menus,
  Vcl.ExtDlgs, Vcl.Printers, MessageDialog, VirtualTrees.ExportHelper, DaImages, Common.Types, Vcl.ComCtrls,
  Vcl.ToolWin, Translate.Lang;
{$ENDREGION}

type
  TframeCustom = class(TFrame)
    aAdd             : TAction;
    aCollapseAll     : TAction;
    aDelete          : TAction;
    aEdit            : TAction;
    aExpandAll       : TAction;
    aExportToCSV     : TAction;
    aExportToExcel   : TAction;
    alFrame          : TActionList;
    aPrint           : TAction;
    aRefresh         : TAction;
    aSave            : TAction;
    btnAdd           : TToolButton;
    btnDelete        : TToolButton;
    btnEdit          : TToolButton;
    btnExportToCSV   : TToolButton;
    btnExportToExcel : TToolButton;
    btnPrint         : TToolButton;
    btnRefresh       : TToolButton;
    btnSave          : TToolButton;
    btnSep01         : TToolButton;
    btnSep02         : TToolButton;
    miAdd            : TMenuItem;
    miCollapseAll    : TMenuItem;
    miDelete         : TMenuItem;
    miEdit           : TMenuItem;
    miExpandAll      : TMenuItem;
    miSep01          : TMenuItem;
    pmFrame          : TPopupMenu;
    tbMain           : TToolBar;
    vstTree          : TVirtualStringTree;
    procedure aCollapseAllExecute(Sender: TObject);
    procedure aExpandAllExecute(Sender: TObject);
    procedure aExportToCSVExecute(Sender: TObject);
    procedure aExportToExcelExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
    procedure vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
  private const
    C_IDENTITY_NAME = 'frameCustom';
    C_IDENTITY_COLUMNS_NAME = '.Columns';
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

{ TframeCustom }

constructor TframeCustom.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.CheckImageKind    := ckCustom;
  vstTree.CustomCheckImages := DMImage.ilCustomCheckImages;
  vstTree.Colors.FocusedSelectionColor   := clWebLightSteelBlue;
  vstTree.Colors.UnfocusedSelectionColor := clWebLightSteelBlue;
  vstTree.Colors.SelectionTextColor      := clBlack;
  vstTree.Colors.GridLineColor           := cl3DLight;
//  vstTree.TreeOptions.AutoOptions      := {vstTree.TreeOptions.AutoOptions +} [toAutoDropExpand, toAutoExpand, toAutoTristateTracking, toAutoChangeScale];
//  vstTree.TreeOptions.MiscOptions      := vstTree.TreeOptions.MiscOptions + [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, {toGridExtensions,} toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick];
//  vstTree.TreeOptions.PaintOptions     := {vstTree.TreeOptions.PaintOptions +} [toHideFocusRect, toUseBlendedSelection, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware];
//  vstTree.TreeOptions.SelectionOptions := vstTree.TreeOptions.SelectionOptions + [toExtendedFocus, toAlwaysSelectNode] - [toFullRowSelect];
end;

destructor TframeCustom.Destroy;
begin

  inherited;
end;

procedure TframeCustom.Initialize;
begin
  TStoreHelper.LoadFromXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  aAdd.Hint           := TLang.Lang.Translate('Add');
  aCollapseAll.Hint   := TLang.Lang.Translate('CollapseAll');
  aDelete.Hint        := TLang.Lang.Translate('Delete');
  aEdit.Hint          := TLang.Lang.Translate('Edit');
  aExpandAll.Hint     := TLang.Lang.Translate('ExpandAll');
  aExportToCSV.Hint   := TLang.Lang.Translate('ExportToCSV');
  aExportToExcel.Hint := TLang.Lang.Translate('ExportToExcel');
  aPrint.Hint         := TLang.Lang.Translate('Print');
  aRefresh.Hint       := TLang.Lang.Translate('Refresh');
  aSave.Hint          := TLang.Lang.Translate('Save');

  miAdd.Caption         := aAdd.Hint;
  miCollapseAll.Caption := aCollapseAll.Hint;
  miDelete.Caption      := aDelete.Hint;
  miEdit.Caption        := aEdit.Hint;
  miExpandAll.Caption   := aExpandAll.Hint;
end;

procedure TframeCustom.Translate;
begin

end;

procedure TframeCustom.Deinitialize;
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

function TframeCustom.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeCustom.vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeCustom.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
//
end;

procedure TframeCustom.vstTreeHeaderDragged(Sender: TVTHeader; Column: TColumnIndex; OldPosition: Integer);
begin
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

procedure TframeCustom.vstTreeMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if Sender.MultiLine[Node] then
  begin
    TargetCanvas.Font := Sender.Font;
    NodeHeight := vstTree.ComputeNodeHeight(TargetCanvas, Node, 0) + 6;
  end;
end;

procedure TframeCustom.aCollapseAllExecute(Sender: TObject);
begin
  vstTree.FullCollapse(nil);
end;

procedure TframeCustom.aExpandAllExecute(Sender: TObject);
begin
  vstTree.FullExpand(nil);
end;

procedure TframeCustom.aExportToCSVExecute(Sender: TObject);
begin
  TExcelExportHelper.ExportToCSV(vstTree, GetIdentityName);
end;

procedure TframeCustom.aExportToExcelExecute(Sender: TObject);
begin
  TExcelExportHelper.ExportToExcel(vstTree, GetIdentityName);
end;

procedure TframeCustom.aPrintExecute(Sender: TObject);
begin
  Printer.Orientation := poLandscape;
  vstTree.Print(Printer, True);
end;

end.
