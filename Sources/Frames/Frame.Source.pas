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
    aColumnSettings   : TAction;
    aExportToCSV      : TAction;
    aExportToExcel    : TAction;
    aPrint            : TAction;
    btnColumnSettings : TToolButton;
    btnExportToCSV    : TToolButton;
    btnExportToExcel  : TToolButton;
    btnPrint          : TToolButton;
    btnSep03          : TToolButton;
    vstTree           : TVirtualStringTree;
    procedure aColumnSettingsExecute(Sender: TObject);
    procedure aExportToCSVExecute(Sender: TObject);
    procedure aExportToExcelExecute(Sender: TObject);
    procedure aExportToHTMLExecute(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure vstTreeColumnResize(Sender: TVTHeader; Column: TColumnIndex);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
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
    procedure SearchText(const aText: string); virtual; abstract;
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
  TVirtualTree.Initialize(vstTree);
end;

destructor TframeSource.Destroy;
begin

  inherited;
end;

procedure TframeSource.Initialize;
begin
  inherited;
  TStoreHelper.LoadFromXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  tbMain.ButtonHeight := C_ICON_SIZE;
  tbMain.ButtonWidth  := C_ICON_SIZE;
  tbMain.Height       := C_ICON_SIZE + 2;
  vstTree.FullExpand;
end;

procedure TframeSource.Translate;
begin
  inherited;
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

procedure TframeSource.Deinitialize;
begin
  inherited;
  TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

function TframeSource.GetIdentityName: string;
begin
  inherited;
  Result := C_IDENTITY_NAME;
end;

procedure TframeSource.LoadFromXML;
begin
  inherited;

end;

procedure TframeSource.SaveToXML;
begin
  inherited;

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

procedure TframeSource.aColumnSettingsExecute(Sender: TObject);
begin
  inherited;
  if TfrmColumnSettings.ShowSettings(vstTree, GetIdentityName, 0) = mrOk then
    TStoreHelper.SaveToXml(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
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
