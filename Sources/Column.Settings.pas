unit Column.Settings;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Data.DB, IBX.IBCustomDataSet, IBX.IBQuery, IBX.IB, Vcl.Buttons, Vcl.DBGrids,
  System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus, Vcl.Mask, Vcl.ImgList, Winapi.ActiveX,
  System.UITypes, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.ImageList, System.Math, Vcl.DBCtrls,
  VirtualTrees, DebugWriter, HtmlLib, Column.Types, Global.Types, CustomForms, VirtualTrees.Helper, System.Types,
  DaImages, XmlFiles, Common.Types, VirtualTrees.ExportHelper, System.Generics.Collections, System.Generics.Defaults,
  Translate.Lang, Global.Resources;
{$ENDREGION}

type
  TfrmColumnSettings = class(TCustomForm)
    aCancel        : TAction;
    ActionListMain : TActionList;
    btnCancel      : TBitBtn;
    btnOk          : TBitBtn;
    pnlBottom      : TPanel;
    vstColumns     : TVirtualStringTree;
    procedure aCancelExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure vstColumnsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstColumnsCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstColumnsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstColumnsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
  private
    FArrayColumns: PArrayColumns;
    FIdentityName: string;
    procedure RestoreColumnSettings(const aXmlParams: string);
  private const
    COL_NAME     = 0;
    COL_WIDTH    = 1;
    COL_POSITION = 2;

    C_SECTION_COLUMNS = 'Columns';
    C_ATTR_INDEX    = 'Index';
    C_ATTR_NAME     = 'Name';
    C_ATTR_POSITION = 'Position';
    C_ATTR_VISIBLE  = 'Visible';
    C_ATTR_WIDTH    = 'Width';
    C_ATTR_TAG      = 'Tag';

    C_IDENTITY_NAME = 'ColumnSettings';
  protected
    function GetIdentityName: string; override;
  public
    class function ShowDocument(const aArrayColumns: PArrayColumns; const aIdentityName: string): TModalResult;
    class function ShowSettings(const aTree: TVirtualStringTree; const aIdentityName: string; const aFixedColumn: Integer): TModalResult;
    procedure Initialize;
    procedure Denitialize;
  end;

implementation

{$R *.dfm}

class function TfrmColumnSettings.ShowDocument(const aArrayColumns: PArrayColumns; const aIdentityName: string): TModalResult;
begin
  with TfrmColumnSettings.Create(nil) do
    try
      FArrayColumns := aArrayColumns;
      FIdentityName := aIdentityName;
      Initialize;
      Result := ShowModal;
      if (Result = mrOk) then
        Denitialize;
    finally
      Free;
    end;
end;

class function TfrmColumnSettings.ShowSettings(const aTree: TVirtualStringTree; const aIdentityName: string; const aFixedColumn: Integer): TModalResult;
var
  ArrayColumns: TArrayColumns;
  ColumnIndex: Integer;
  Column: TVirtualTreeColumn;
begin
  Result := mrCancel;
  SetLength(ArrayColumns, 0);
  if (aTree.Header.Columns.Count - aFixedColumn > 0) then
  begin
    SetLength(ArrayColumns, aTree.Header.Columns.Count - aFixedColumn);
    for ColumnIndex := aFixedColumn to aTree.Header.Columns.Count - 1 do
    begin
      Column := aTree.Header.Columns[ColumnIndex];
      if Assigned(Column) then
      begin
        ArrayColumns[ColumnIndex - aFixedColumn].Name     := Column.Text;
        ArrayColumns[ColumnIndex - aFixedColumn].Position := Column.Position;
        ArrayColumns[ColumnIndex - aFixedColumn].Index    := Column.Index;
        ArrayColumns[ColumnIndex - aFixedColumn].Width    := Column.Width;
        ArrayColumns[ColumnIndex - aFixedColumn].Visible  := coVisible in Column.Options;
      end;
    end;
  end;

  if (TfrmColumnSettings.ShowDocument(@ArrayColumns, aIdentityName) = mrOk) then
  begin
    Result := mrOk;
    TArray.Sort<TColumnSetting>(ArrayColumns, TComparer<TColumnSetting>.Construct(
      function(const Left, Right: TColumnSetting): Integer
      begin
        if (Left.Position > Right.Position) then
          Result := GreaterThanValue
        else if (Left.Position = Right.Position) then
          Result := EqualsValue
        else
          Result := LessThanValue;
      end));

    for var i := Low(ArrayColumns) to High(ArrayColumns) do
    begin
      ColumnIndex := ArrayColumns[i].Index;
      if (ColumnIndex <= aTree.Header.Columns.Count - 1) then
      begin
        Column := aTree.Header.Columns[ColumnIndex];
        if Assigned(Column) then
        begin
          Column.Position := ArrayColumns[i].Position;
          Column.Width    := ArrayColumns[i].Width;
          if ArrayColumns[i].Visible then
            Column.Options := Column.Options + [coVisible]
          else
            Column.Options := Column.Options - [coVisible];
        end;
      end;
    end;
  end;
end;

procedure TfrmColumnSettings.FormCreate(Sender: TObject);
begin
  inherited;
  vstColumns.NodeDataSize := SizeOf(TColumnSetting);
  TVirtualTree.Initialize(vstColumns);
end;

procedure TfrmColumnSettings.Initialize;
var
  Data: PColumnSetting;
  Node: PVirtualNode;
begin
  TVirtualTree.Initialize(vstColumns);
  vstColumns.BeginUpdate;
  try
    if (Length(FArrayColumns^) > 0) then
      for var i := Low(FArrayColumns^) to High(FArrayColumns^) do
      begin
        Node := vstColumns.AddChild(nil);
        Node^.CheckType := ctCheckBox;
        Data := Node^.GetData;
        Data^.AssignFrom(FArrayColumns^[i]);
        if Data^.Visible then
          Node^.CheckState := csCheckedNormal
        else
          Node^.CheckState := csUncheckedNormal;
      end;
  finally
    vstColumns.EndUpdate;
  end;
  RestoreColumnSettings(FIdentityName);
  TStoreHelper.LoadFromXml(vstColumns, GetIdentityName + C_IDENTITY_COLUMNS_NAME);

  btnOk.Caption     := TLang.Lang.Translate('Ok');
  btnCancel.Caption := TLang.Lang.Translate('Cancel');
end;

procedure TfrmColumnSettings.Denitialize;
var
  Data: PColumnSetting;
  Node: PVirtualNode;
  Index: Integer;
begin
  vstColumns.BeginUpdate;
  try
    SetLength(FArrayColumns^, vstColumns.RootNodeCount);
    Index := 0;
    Node := vstColumns.GetFirst;
    while Assigned(Node) do
    begin
      Data := Node^.GetData;
      FArrayColumns^[Index].AssignFrom(Data^);
      Inc(Index);
      Node := Node.NextSibling;
    end;
  finally
    vstColumns.EndUpdate;
  end;
  TStoreHelper.SaveToXml(vstColumns, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
end;

function TfrmColumnSettings.GetIdentityName: string;
begin
  inherited;
  Result := C_IDENTITY_NAME;
end;

procedure TfrmColumnSettings.vstColumnsChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PColumnSetting;
begin
  Data := Node^.GetData;
  Data^.Visible := Node.CheckState = csCheckedNormal;
end;

procedure TfrmColumnSettings.vstColumnsCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PColumnSetting;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  case Column of
    COL_NAME:
      Result := CompareText(Data1^.Name, Data2^.Name);
    COL_WIDTH:
      Result := CompareValue(Data1^.Width, Data2^.Width);
    COL_POSITION:
      Result := CompareValue(Data1^.Position, Data2^.Position);
  end;
end;

procedure TfrmColumnSettings.vstColumnsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PColumnSetting;
begin
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^ := Default(TColumnSetting);
end;

procedure TfrmColumnSettings.vstColumnsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PColumnSetting;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    COL_NAME:
      CellText := Data^.Name;
    COL_WIDTH:
      CellText := Data^.Width.ToString;
    COL_POSITION:
      CellText := Data^.Position.ToString;
  else
    CellText := '';
  end;
end;

procedure TfrmColumnSettings.aCancelExecute(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TfrmColumnSettings.RestoreColumnSettings(const aXmlParams: string);
var
  XMLFile: TXMLFile;
  Index: Integer;
  Node: PVirtualNode;
  Data: PColumnSetting;
begin
  if not aXmlParams.IsEmpty then
  begin
    XMLFile := TXMLFile.Create;
    try
      XMLFile.XMLText := aXmlParams;
      XMLFile.CurrentSection := C_SECTION_COLUMNS;
      while not XMLFile.IsLastKey do
      begin
        if XMLFile.ReadAttributes then
        begin
          Index := XMLFile.Attributes.GetAttributeValue(C_ATTR_INDEX, -1);
          Node := vstColumns.GetFirst;
          Data := nil;
          while Assigned(Node) do
          begin
            Data := Node^.GetData;
            if (Data^.Index = Index) then
              Break;
            Node := Node.NextSibling;
            Data := nil;
          end;

          if Assigned(Node) and Assigned(Data) then
          begin
            Data^.Position := XMLFile.Attributes.GetAttributeValue(C_ATTR_POSITION, Data^.Position);
            Data^.Name     := XMLFile.Attributes.GetAttributeValue(C_ATTR_NAME, Data^.Name);
            Data^.Width    := XMLFile.Attributes.GetAttributeValue(C_ATTR_WIDTH, Data^.Width);
            Data^.Visible  := XMLFile.Attributes.GetAttributeValue(C_ATTR_VISIBLE, Data^.Visible);
            if Data^.Visible then
              Node.CheckState := csCheckedNormal
            else
              Node.CheckState := csUncheckedNormal;
            vstColumns.InvalidateNode(Node);
          end;
        end;
        XMLFile.NextKey;
      end;
    finally
      FreeAndNil(XMLFile);
    end;
  end;
end;

end.
