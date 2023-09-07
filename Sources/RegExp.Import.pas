unit RegExp.Import;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  System.UITypes, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.ImageList, System.Math, Vcl.DBCtrls,
  VirtualTrees, DebugWriter, Html.Lib, Column.Types, Global.Types, CommonForms, VirtualTrees.Helper, System.Types,
  DaImages, XmlFiles, Common.Types, VirtualTrees.ExportHelper, System.Generics.Collections, System.Generics.Defaults,
  Translate.Lang, Global.Resources, Vcl.ToolWin, Vcl.ComCtrls, ArrayHelper, RegExp.Utils;
{$ENDREGION}

type
  TfrmImportFromXML = class(TCommonForm)
    ActionListMain    : TActionList;
    aImport           : TAction;
    btnImport         : TToolButton;
    btnOk             : TBitBtn;
    cbSetOfTemplates  : TComboBox;
    dlgImport         : TFileOpenDialog;
    edtPath           : TButtonedEdit;
    lblPathToFile     : TLabel;
    lblSetOfTemplates : TLabel;
    pnlBottom         : TPanel;
    pnlSettings       : TPanel;
    pnlTop            : TPanel;
    tbSettings        : TToolBar;
    vstTree           : TVirtualStringTree;
    procedure aImportExecute(Sender: TObject);
    procedure cbSetOfTemplatesChange(Sender: TObject);
    procedure edtPathRightButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure aImportUpdate(Sender: TObject);
    procedure vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private const
    COL_PARAM_NAME      = 0;
    COL_REGEXP_TEMPLATE = 1;
    COL_GROUP_INDEX     = 2;
    COL_USE_RAW_TEXT    = 3;

    C_IDENTITY_NAME = 'ImportFromXML';
  private
    FFileName: TFileName;
    procedure LoadFromXML(const aFileName: TFileName);
  protected
    function GetIdentityName: string; override;
  public
    class function ShowDocument: TModalResult;
    procedure Initialize;
    procedure Deinitialize;
    procedure Translate;
  end;

implementation

{$R *.dfm}

class function TfrmImportFromXML.ShowDocument: TModalResult;
begin
  with TfrmImportFromXML.Create(nil) do
    try
      Initialize;
      Result := ShowModal;
      if (Result = mrOk) then
        Deinitialize;
    finally
      Free;
    end;
end;

procedure TfrmImportFromXML.FormCreate(Sender: TObject);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TRegExpData);
end;

procedure TfrmImportFromXML.Initialize;
begin
  TVirtualTree.Initialize(vstTree);
  LoadFormPosition;
  Translate;
  tbSettings.ButtonHeight := C_ICON_SIZE;
  tbSettings.ButtonWidth  := C_ICON_SIZE;
  tbSettings.Height       := C_ICON_SIZE + 2;
end;

procedure TfrmImportFromXML.Deinitialize;
begin
   TStoreHelper.SaveToXml(vstTree, GetIdentityName);
end;

function TfrmImportFromXML.GetIdentityName: string;
begin
  inherited;
  Result := C_IDENTITY_NAME;
end;

procedure TfrmImportFromXML.Translate;
begin
  aImport.Hint              := TLang.Lang.Translate('Import');
  btnOk.Caption             := TLang.Lang.Translate('Ok');
  lblPathToFile.Caption     := TLang.Lang.Translate('Path');
  lblSetOfTemplates.Caption := TLang.Lang.Translate('SetOfTemplates');
  vstTree.Header.Columns[COL_PARAM_NAME].Text      := TLang.Lang.Translate('TemplateName');
  vstTree.Header.Columns[COL_REGEXP_TEMPLATE].Text := TLang.Lang.Translate('RegExpTemplate');
  vstTree.Header.Columns[COL_GROUP_INDEX].Text     := TLang.Lang.Translate('GroupIndex');
  vstTree.Header.Columns[COL_USE_RAW_TEXT].Text    := TLang.Lang.Translate('UseRawText');
end;

procedure TfrmImportFromXML.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TfrmImportFromXML.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PRegExpData;
begin
  inherited;
  CellText := '';
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_PARAM_NAME:
      CellText := Data^.ParameterName;
    COL_REGEXP_TEMPLATE:
      CellText := Data^.RegExpTemplate;
    COL_GROUP_INDEX:
      CellText := Data^.GroupIndex.ToString;
  end;
end;

procedure TfrmImportFromXML.vstTreeChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PRegExpData;
begin
  inherited;
  Data := Node.GetData;
  Data.UseRawText := Node.CheckState = csCheckedNormal;
end;

procedure TfrmImportFromXML.edtPathRightButtonClick(Sender: TObject);
begin
  inherited;
  if dlgImport.Execute then
  begin
    TButtonedEdit(Sender).Text := dlgImport.FileName;
    LoadFromXML(dlgImport.FileName);
  end;
end;

procedure TfrmImportFromXML.aImportExecute(Sender: TObject);
begin
  inherited;
  if string(cbSetOfTemplates.Text).Trim.IsEmpty then
    cbSetOfTemplates.Text := 'Set Of Templates ' + cbSetOfTemplates.ItemIndex.ToString;
  TRegExpUtils.SaveSetOfTemplate(vstTree, string.Empty, cbSetOfTemplates.Text);
end;

procedure TfrmImportFromXML.aImportUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

procedure TfrmImportFromXML.cbSetOfTemplatesChange(Sender: TObject);
var
  XmlFile: TXmlFile;
begin
  inherited;
  if (cbSetOfTemplates.ItemIndex > -1) then
  begin
    XmlFile := TXmlFile.Create(FFileName);
    try
      TRegExpUtils.RestoreSetOfTemplate(XmlFile, vstTree, TStringObject(cbSetOfTemplates.Items.Objects[cbSetOfTemplates.ItemIndex]).StringValue);
    finally
      FreeAndNil(XmlFile);
    end;
  end;
end;

procedure TfrmImportFromXML.LoadFromXML(const aFileName: TFileName);
var
  XmlFile: TXmlFile;

  function GetRegExpParametersList: TRegExpArray;
  var
    Data: TRegExpData;
    i: Integer;
  begin
    XmlFile.CurrentSection := 'RegExpParameters';
    try
      i := 0;
      Result.Count := XmlFile.ChildCount;
      while not XmlFile.IsLastKey do
      begin
        if XmlFile.ReadAttributes then
        begin
          Data.ParameterName  := XmlFile.Attributes.GetAttributeValue('ParameterName', '');
          Data.RegExpTemplate := XmlFile.Attributes.GetAttributeValue('RegExpTemplate', '');
          Data.GroupIndex     := XmlFile.Attributes.GetAttributeValue('GroupIndex', 0);
          Data.UseRawText     := XmlFile.Attributes.GetAttributeValue('UseRawText', False);
          Result[i] := Data;
          Inc(i);
        end;
        XmlFile.NextKey;
      end;
    finally
      XmlFile.CurrentSection := '';
    end;
  end;

  procedure LoadNode;
  var
    arrParams : TArrayRecord<TRegExpData>;
    Data      : PRegExpData;
    NewNode   : PVirtualNode;
  begin
    arrParams := GetRegExpParametersList;
    for var Param in arrParams do
    begin
      NewNode := vstTree.AddChild(nil);
      Data    := NewNode.GetData;
      Data^   := Param;
      vstTree.CheckType[NewNode] := ctCheckBox;
      if Param.UseRawText then
        NewNode.CheckState := csCheckedNormal
      else
        NewNode.CheckState := csUnCheckedNormal;
    end;
  end;

  procedure LoadSetsOfTemplate;
  var
    arrSections: TArray<string>;
    Name: string;
  begin
    for var i := 0 to cbSetOfTemplates.Items.Count - 1 do
      cbSetOfTemplates.Items.Objects[i].Free;
    cbSetOfTemplates.Items.Clear;
    arrSections := XmlFile.ReadSection(C_SECTION_TEMPLATE_SETS);
    for var Section in arrSections do
    begin
      if XmlFile.ReadAttributes(C_SECTION_TEMPLATE_SETS, Section) then
        Name := XmlFile.Attributes.GetAttributeValue('Name', Section);
      cbSetOfTemplates.Items.AddObject(Name, TStringObject.Create(Section));
    end;
  end;

begin
  inherited;
  XmlFile := TXmlFile.Create(aFileName);
  try
    FFileName := aFileName;
    XmlFile.Open;
    LoadSetsOfTemplate;
    vstTree.BeginUpdate;
    try
      vstTree.Clear;
      LoadNode;
    finally
      vstTree.EndUpdate;
    end;
    cbSetOfTemplates.ItemIndex := XmlFile.ReadInteger(C_SECTION_MAIN, 'TemplateIndex', -1);
    if (cbSetOfTemplates.ItemIndex > -1) then
      cbSetOfTemplatesChange(nil);
  finally
    FreeAndNil(XmlFile);
  end;
end;

end.
