unit Frame.BruteForce;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Publishers,
  VCLTee.TeCanvas, Global.Resources, Winapi.msxml, Frame.Custom, Files.Utils, UnRAR.Helper, UnRAR;
{$ENDREGION}

type
  TframeBruteForce = class(TframeSource)
    aDown           : TAction;
    aStart          : TAction;
    aStop           : TAction;
    aUp             : TAction;
    btnDown         : TToolButton;
    btnSep04        : TToolButton;
    btnSep05        : TToolButton;
    btnStart        : TToolButton;
    btnStop         : TToolButton;
    btnUp           : TToolButton;
    edtFileName     : TButtonedEdit;
    lblPasswordList : TLabel;
    OpenDialog      : TFileOpenDialog;
    pnlSettings     : TPanel;
    tbSettings      : TToolBar;
    procedure aAddExecute(Sender: TObject);
    procedure aAddUpdate(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDeleteUpdate(Sender: TObject);
    procedure aDownExecute(Sender: TObject);
    procedure aDownUpdate(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aStartExecute(Sender: TObject);
    procedure aStopExecute(Sender: TObject);
    procedure aUpExecute(Sender: TObject);
    procedure aUpUpdate(Sender: TObject);
    procedure edtFileNameRightButtonClick(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
    procedure vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_FILE_NAME   = 0;
    COL_PASSWORD    = 1;
    COL_HASH        = 2;

    C_IDENTITY_NAME = 'frameBruteForce';
  private
    FPasswordsList: TArray<string>;
    FBreak : Boolean;
    procedure BruteForceProcess(aData: PPassword);
    procedure OnPasswordListChange(Sender: TObject; const Item: PPassword; Action: TCollectionNotification);
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

{ TframeBruteForce }

constructor TframeBruteForce.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TPasswordData);
  TGeneral.PasswordList.OnValueNotify := OnPasswordListChange;
end;

destructor TframeBruteForce.Destroy;
begin
  TGeneral.PasswordList.OnValueNotify := nil;
  inherited;
end;

function TframeBruteForce.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeBruteForce.Initialize;
begin
  inherited Initialize;
  tbSettings.ButtonHeight := C_ICON_SIZE;
  tbSettings.ButtonWidth  := C_ICON_SIZE;
  tbSettings.Height       := C_ICON_SIZE + 2;

  Translate;
end;

procedure TframeBruteForce.Deinitialize;
begin
  TGeneral.PasswordList.OnValueNotify := nil;
  inherited Deinitialize;
end;

procedure TframeBruteForce.Translate;
begin
  inherited;
  aDown.Hint  := TLang.Lang.Translate('Down');
  aSave.Hint  := TLang.Lang.Translate('Save');
  aStart.Hint := TLang.Lang.Translate('StartSearch');
  aStop.Hint  := TLang.Lang.Translate('Break');
  aUp.Hint    := TLang.Lang.Translate('Up');
  lblPasswordList.Caption := TLang.Lang.Translate('PasswordList');

  vstTree.Header.Columns[COL_FILE_NAME].Text := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_PASSWORD].Text  := TLang.Lang.Translate('Password');
  vstTree.Header.Columns[COL_HASH].Text      := TLang.Lang.Translate('Hash');
end;

procedure TframeBruteForce.LoadFromXML;

  procedure LoadNode;
  var
    arrPassword : TPasswordArray;
  begin
    inherited;
    arrPassword := TGeneral.GetPasswordList;
    for var arrData in arrPassword do
      if not arrData.Hash.IsEmpty then
        TGeneral.PasswordList.TryAdd(arrData.Hash, arrData)
      else
        Dispose(arrData);
  end;

begin
  inherited;
  edtFileName.Text := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'PasswordList', '');
  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    LoadNode;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeBruteForce.OnPasswordListChange(Sender: TObject; const Item: PPassword; Action: TCollectionNotification);
var
  Data: PPasswordData;
  Node: PVirtualNode;
begin
  case Action of
    cnAdded:
      begin
        Node := vstTree.AddChild(nil);
        Data := Node.GetData;
        Data^.Hash := Item^.Hash;
        vstTree.CheckType[Node] := ctCheckBox;
        if Item^.Password.IsEmpty then
          vstTree.CheckState[Node] := TCheckState.csCheckedNormal;
        vstTree.ValidateNode(Node, False);
      end;
    cnExtracted, cnRemoved:
      if Assigned(Item) then
        Dispose(Item);
  end;
end;

procedure TframeBruteForce.SaveToXML;

  procedure SaveNode(const aNode: PVirtualNode);
  var
    Data: PPassword;
    PwdData: PPasswordData;
  begin
    PwdData := aNode^.GetData;
    if not PwdData^.Hash.IsEmpty then
    begin
      Data := TGeneral.PasswordList.GetItem(PwdData^.Hash);
      if Assigned(Data) then
      begin
        TGeneral.XMLParams.Attributes.AddNode;
        TGeneral.XMLParams.Attributes.SetAttributeValue('FileName', Data.FileName);
        TGeneral.XMLParams.Attributes.SetAttributeValue('Password', Data.Password);
        TGeneral.XMLParams.Attributes.SetAttributeValue('Hash', Data.Hash);
        TGeneral.XMLParams.WriteAttributes;
      end;
    end;
  end;

var
  Node: PVirtualNode;
begin
  inherited;
  TGeneral.XMLParams.Open;
  try
    TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'PasswordList', edtFileName.Text, lblPasswordList.Caption);
    TGeneral.XMLParams.EraseSection('Passwords');
    TGeneral.XMLParams.CurrentSection := 'Passwords';
    Node := vstTree.GetFirst;
    while Assigned(Node) do
    begin
      SaveNode(Node);
      Node := Node.NextSibling;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
    TGeneral.XMLParams.Save;
  end;
end;

procedure TframeBruteForce.aAddExecute(Sender: TObject);
var
  Data : PPassword;
  Hash : string;
begin
  inherited;
  OpenDialog.DefaultFolder := TDirectory.GetCurrentDirectory;
  OpenDialog.FileTypeIndex := 1;
  if OpenDialog.Execute then
  begin
    Hash := TFileUtils.GetHash(OpenDialog.FileName);
    if not TGeneral.PasswordList.ContainsKey(Hash) then
    begin
      New(Data);
      Data^.FileName  := OpenDialog.FileName;
      Data^.Hash      := Hash;
      Data^.IsDeleted := False;
      TGeneral.PasswordList.TryAdd(Hash, Data);
    end;
  end;
end;

procedure TframeBruteForce.aAddUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := True;
end;

procedure TframeBruteForce.aDeleteExecute(Sender: TObject);
var
  Data: PPasswordData;
begin
  inherited;
  if Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    if Assigned(Data) then
      TGeneral.PasswordList.Remove(Data^.Hash);
    vstTree.DeleteNode(vstTree.FocusedNode);
    vstTree.Invalidate;
  end;
end;

procedure TframeBruteForce.aDeleteUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeBruteForce.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PPassword;
begin
  inherited;
  Data1 := TGeneral.PasswordList.GetItem(PPasswordData(Node1^.GetData).Hash);
  Data2 := TGeneral.PasswordList.GetItem(PPasswordData(Node2^.GetData).Hash);
  if Assigned(Data1) and Assigned(Data2) then
    case Column of
      COL_FILE_NAME:
        Result := CompareText(Data1^.FileName, Data2^.FileName);
      COL_PASSWORD:
        Result := CompareText(Data1^.Password, Data2^.Password);
      COL_HASH:
        Result := CompareText(Data1^.Hash, Data2^.Hash);
    end;
end;

procedure TframeBruteForce.vstTreeCreateEditor(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; out EditLink: IVTEditLink);
begin
  inherited;
  EditLink := TStringEditLink.Create;
end;

procedure TframeBruteForce.vstTreeNewText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var
  Data: PPassword;
begin
  inherited;
  case Column of
    COL_PASSWORD:
      begin
        Data := TGeneral.PasswordList.GetItem(PPasswordData(Node^.GetData).Hash);
        if Assigned(Data) then
          Data^.Password := NewText;
      end;
  end;
end;

procedure TframeBruteForce.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PPassword;
begin
  inherited;
  Data := TGeneral.PasswordList.GetItem(PPasswordData(Node^.GetData).Hash);
  if Assigned(Data) and Data.IsDeleted and (Column in [COL_FILE_NAME]) then
  begin
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsStrikeOut];
    TargetCanvas.Font.Color := clRed;
  end;
end;

procedure TframeBruteForce.vstTreeEditing(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
  inherited;
  Allowed := (Column in [COL_PASSWORD]);
end;

procedure TframeBruteForce.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PPassword;
begin
  inherited;
  CellText := '';
  Data := TGeneral.PasswordList.GetItem(PPasswordData(Node^.GetData).Hash);
  if Assigned(Data) then
    case Column of
      COL_FILE_NAME:
        CellText := Data^.FileName;
      COL_PASSWORD:
        CellText := Data^.Password;
      COL_HASH:
        CellText := Data^.Hash;
    end;
end;

procedure TframeBruteForce.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeBruteForce.SearchText(const aText: string);
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

procedure TframeBruteForce.aSaveExecute(Sender: TObject);
begin
  inherited;
  SaveToXML;
end;

procedure TframeBruteForce.aStartExecute(Sender: TObject);
var
  Node: PVirtualNode;
  Data: PPassword;
begin
  inherited;
  if string(edtFileName.Text).Trim.IsEmpty then
  begin
    TMessageDialog.ShowError(TLang.Lang.Translate('FileNotSelected'));
    SetFocusSafely(edtFileName);
    Exit;
  end;
  if not TFile.Exists(edtFileName.Text) then
  begin
    TMessageDialog.ShowError(Format(TLang.Lang.Translate('FileNotFound'), [edtFileName.Text]));
    SetFocusSafely(edtFileName);
    Exit;
  end;
  FPasswordsList := Concat([''], TFile.ReadAllLines(edtFileName.Text));
  FBreak := False;

  Node := vstTree.GetFirstChecked(TCheckState.csCheckedNormal);
  vstTree.BeginUpdate;
  try
    while Assigned(Node) do
    begin
      if FBreak then
        Exit;
      Data := TGeneral.PasswordList.GetItem(PPasswordData(Node^.GetData).Hash);
      if Assigned(Data) then
      begin
        if not Data^.Password.IsEmpty then
          FPasswordsList := Concat([Data^.Password], FPasswordsList);
        if TFile.Exists(Data^.FileName) then
          BruteForceProcess(Data)
        else
          Data^.IsDeleted := True;
      end;
      Node.CheckState := TCheckState.csUncheckedNormal;
      Node := vstTree.GetNextChecked(Node, True);
    end;
  finally
    vstTree.EndUpdate;
    TMessageDialog.ShowInfo(TLang.Lang.Translate('Successful'));
  end;
end;

procedure TframeBruteForce.aStopExecute(Sender: TObject);
begin
  inherited;
  FBreak := True;
end;

procedure TframeBruteForce.BruteForceProcess(aData: PPassword);
var
  FileList: TArray<string>;
  pwd: string;
  UnRAR: TUnRAR;
begin
  LogWriter.Write(ddEnterMethod, Self, 'BruteForceProcess', aData.FileName);
  try
    for var i := Low(FPasswordsList) to High(FPasswordsList) do
    begin
      if FBreak then
        Exit;
      pwd := FPasswordsList[i].Trim;
      LogWriter.Write(ddText, Self, (i + 1).ToString + ': ' + pwd);

      UnRAR := TUnRAR.Create(aData.FileName);
      try
        UnRAR.DestPath := TPath.GetTempPath;
        UnRAR.Password := pwd;
        try
          FileList := UnRAR.ExtractAll;
          if (UnRAR.LastError = ERAR_SUCCESS) then
          begin
            if not UnRAR.ArcInfo.IsNeedPassword then
              aData.Password := string.Empty
            else
              aData.Password := pwd;
            Break;
          end;
        except
          LogWriter.Write(ddError, Self, (i + 1).ToString + ': ' + pwd);
        end;
      finally
        FreeAndNil(UnRAR);
      end;
    end;
  finally
    LogWriter.Write(ddExitMethod, Self, 'BruteForceProcess', aData.FileName);
  end;
end;

procedure TframeBruteForce.aUpExecute(Sender: TObject);
var
  Node: PVirtualNode;
  PrevNode: PVirtualNode;
begin
  inherited;
  Node := vstTree.FocusedNode;
  if Assigned(Node) then
  begin
    PrevNode := Node.PrevSibling;
    if Assigned(PrevNode) then
      vstTree.MoveTo(Node, PrevNode, amInsertBefore, False);
  end;
end;

procedure TframeBruteForce.aDownExecute(Sender: TObject);
var
  Node: PVirtualNode;
  NextNode: PVirtualNode;
begin
  inherited;
  Node := vstTree.FocusedNode;
  if Assigned(Node) then
  begin
    NextNode := Node.NextSibling;
    if Assigned(NextNode) then
      vstTree.MoveTo(Node, NextNode, amInsertAfter, False);
  end;
end;

procedure TframeBruteForce.aUpUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := False;
  if Assigned(vstTree.FocusedNode) then
    TAction(Sender).Enabled := vstTree.FocusedNode <> vstTree.RootNode.FirstChild;
end;

procedure TframeBruteForce.aDownUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := False;
  if Assigned(vstTree.FocusedNode) then
    TAction(Sender).Enabled := vstTree.FocusedNode <> vstTree.RootNode.LastChild;
end;

procedure TframeBruteForce.edtFileNameRightButtonClick(Sender: TObject);
begin
  inherited;
  if TFile.Exists(edtFileName.Text) then
    OpenDialog.FileName := edtFileName.Text
  else
  begin
    OpenDialog.DefaultFolder := TDirectory.GetCurrentDirectory;
    OpenDialog.FileName := '';
  end;

  OpenDialog.FileTypeIndex := 2;
  if OpenDialog.Execute then
    edtFileName.Text := OpenDialog.FileName;
end;

end.
