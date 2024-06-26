﻿unit Frame.DuplicateFiles;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Utils.Files,
  Vcl.WinXPanels, Publishers.Interfaces, Publishers, VirtualTrees.ExportHelper, Global.Resources, Global.Utils,
  DaModule, Vcl.WinXCtrls, System.Types, Performer, System.Threading, Winapi.ShellAPI;
{$ENDREGION}

type
  TframeDuplicateFiles = class(TframeSource)
    aAllCheck         : TAction;
    aAllUnCheck       : TAction;
    aDeleteSelected   : TAction;
    aFileBreak        : TAction;
    aFileSearch       : TAction;
    aOpenFile         : TAction;
    aOpenLocation     : TAction;
    btnAllCheck       : TToolButton;
    btnAllUnCheck     : TToolButton;
    btnDeleteSelected : TToolButton;
    btnFileBreak      : TToolButton;
    btnFileSearch     : TToolButton;
    btnSep04          : TToolButton;
    cbExt             : TComboBox;
    dlgFileSearch     : TFileOpenDialog;
    edtPath           : TButtonedEdit;
    lblPath           : TLabel;
    miOpenFile        : TMenuItem;
    miOpenLocation    : TMenuItem;
    miSep01           : TMenuItem;
    pnlFileSearch     : TPanel;
    tbFileSearch      : TToolBar;
    procedure aAllCheckExecute(Sender: TObject);
    procedure aAllCheckUpdate(Sender: TObject);
    procedure aAllUnCheckExecute(Sender: TObject);
    procedure aDeleteSelectedExecute(Sender: TObject);
    procedure aDeleteSelectedUpdate(Sender: TObject);
    procedure aFileBreakExecute(Sender: TObject);
    procedure aFileSearchExecute(Sender: TObject);
    procedure aOpenFileExecute(Sender: TObject);
    procedure aOpenLocationExecute(Sender: TObject);
    procedure edtPathRightButtonClick(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeDblClick(Sender: TObject);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_SHORT_NAME = 0;
    COL_FILE_NAME  = 1;
    COL_DATE       = 2;
    COL_SIZE       = 3;
    COL_HASH       = 4;

    C_IDENTITY_NAME = 'frameDuplicateFiles';
    procedure FileListClear;
    procedure AddNode(aData: TFileData);
  private
    FBreak : Boolean;
    FFileList: TObjectDictionary<string, TList<PVirtualNode>>;
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
  end;

implementation

{$R *.dfm}

{ TframeDuplicateFiles }

constructor TframeDuplicateFiles.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TFileData);
  FFileList := TObjectDictionary<string, TList<PVirtualNode>>.Create([]);
end;

destructor TframeDuplicateFiles.Destroy;
begin
  FileListClear;
  FreeAndNil(FFileList);
  inherited;
end;

function TframeDuplicateFiles.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeDuplicateFiles.Initialize;
begin
  inherited Initialize;
  Translate;
  tbFileSearch.Color := clBtnFace;
end;

procedure TframeDuplicateFiles.Deinitialize;
begin

  inherited Deinitialize;
end;

procedure TframeDuplicateFiles.Translate;
begin
  inherited;
  aAllCheck.Hint        := TLang.Lang.Translate('AllCheck');
  aAllUnCheck.Hint      := TLang.Lang.Translate('AllUnCheck');
  aDeleteSelected.Hint  := TLang.Lang.Translate('DeleteSelected');
  aFileBreak.Hint       := TLang.Lang.Translate('Break');
  aFileSearch.Hint      := TLang.Lang.Translate('StartSearch');
  aOpenFile.Caption     := TLang.Lang.Translate('OpenFile');
  aOpenFile.Hint        := TLang.Lang.Translate('OpenFile');
  aOpenLocation.Caption := TLang.Lang.Translate('OpenLocation');
  aOpenLocation.Hint    := TLang.Lang.Translate('OpenLocation');
  lblPath.Caption       := TLang.Lang.Translate('Path');

  vstTree.Header.Columns[COL_DATE].Text       := TLang.Lang.Translate('Date');
  vstTree.Header.Columns[COL_FILE_NAME].Text  := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_HASH].Text       := TLang.Lang.Translate('Hash');
  vstTree.Header.Columns[COL_SHORT_NAME].Text := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_SIZE].Text       := TLang.Lang.Translate('Size');
end;

procedure TframeDuplicateFiles.SaveToXML;
begin
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'DuplicatePath', edtPath.Text, lblPath.Caption);
  TGeneral.XMLParams.WriteString(C_SECTION_MAIN, 'DuplicateExt', cbExt.Text);
  TGeneral.XMLParams.Save;
  inherited;
end;

procedure TframeDuplicateFiles.LoadFromXML;
begin
  inherited;
  edtPath.Text := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'DuplicatePath', TDirectory.GetCurrentDirectory);
  cbExt.Text   := TGeneral.XMLParams.ReadString(C_SECTION_MAIN, 'DuplicateExt', '*.*');
end;

procedure TframeDuplicateFiles.FileListClear;
begin
  for var pair in FFileList do
    pair.Value.Free;
  FFileList.Clear;
end;

procedure TframeDuplicateFiles.edtPathRightButtonClick(Sender: TObject);
begin
  inherited;
  if dlgFileSearch.Execute then
    TButtonedEdit(Sender).Text := dlgFileSearch.FileName;
end;

procedure TframeDuplicateFiles.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PFileData;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
    COL_SIZE:
      Result := CompareValue(Data1^.Size, Data2^.Size);
    COL_SHORT_NAME:
      Result := CompareText(Data1^.ShortName, Data2^.ShortName);
    COL_FILE_NAME:
      Result := CompareText(Data1^.FileName, Data2^.FileName);
    COL_HASH:
      Result := CompareText(Data1^.Hash, Data2^.Hash);
    COL_DATE:
      Result := CompareValue(Data1^.Date, Data2^.Date);
  end;
end;

procedure TframeDuplicateFiles.vstTreeDblClick(Sender: TObject);
var
  Data: PFileData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    if Assigned(Data) then
    begin
      if TFile.Exists(Data^.FileName) then
        TFileUtils.ShellOpen(Data^.FileName)
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.ShortName]));
    end;
  end;
end;

procedure TframeDuplicateFiles.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PFileData;
begin
  inherited;
  CellText := '';
  Data := Node^.GetData;
  if Assigned(Data) then
    case Column of
      COL_SIZE:
        CellText := Format('%.0n', [Data^.Size + 0.0]);
      COL_SHORT_NAME:
        CellText := Data^.ShortName;
      COL_FILE_NAME:
        CellText := Data^.FileName;
      COL_HASH:
        CellText := Data^.Hash;
      COL_DATE:
        CellText := DateTimeToStr(Data^.Date);
    end;
end;

procedure TframeDuplicateFiles.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PFileData;
begin
  inherited;
  if (Sender.GetNodeLevel(Node) = 0) then
    TargetCanvas.Font.Color := clNavy;

  Data := Node^.GetData;
  if Data.IsDeleted and (Column in [COL_SHORT_NAME]) then
  begin
    TargetCanvas.Font.Style := TargetCanvas.Font.Style + [fsStrikeOut];
    TargetCanvas.Font.Color := clRed;
  end;
end;

procedure TframeDuplicateFiles.aFileBreakExecute(Sender: TObject);
begin
  inherited;
  FBreak := True;
end;

procedure TframeDuplicateFiles.AddNode(aData: TFileData);
var
  Data: PFileData;
  Node: PVirtualNode;
  NodeList: TList<PVirtualNode>;
  ParentNode: PVirtualNode;
begin
  if aData.Hash.IsEmpty or not TFile.Exists(aData.FileName) then
    Exit;

  if not FFileList.ContainsKey(aData.Hash) then
  begin
    NodeList := TList<PVirtualNode>.Create;
    FFileList.Add(aData.Hash, NodeList);
    ParentNode := vstTree.RootNode;
  end
  else
  begin
    NodeList := FFileList.Items[aData.Hash];
    ParentNode := NodeList.Items[0];
  end;
  Node := vstTree.AddChild(ParentNode);
  Data := Node^.GetData;
  Data^.Hash      := aData.Hash;
  Data^.Date      := aData.Date;
  Data^.Size      := aData.Size;
  Data^.FileName  := aData.FileName;
  Data^.ShortName := aData.ShortName;
  Data^.IsDeleted := False;

  vstTree.CheckType[Node] := ctCheckBox;
  vstTree.IsVisible[Node] := ParentNode <> vstTree.RootNode;
  if (ParentNode <> vstTree.RootNode) then
  begin
    vstTree.IsVisible[ParentNode] := (ParentNode.ChildCount > 0);
    Node.CheckState := TCheckState.csCheckedNormal;
  end;
  NodeList.Add(Node);
  TPublishers.ProgressPublisher.Progress;
end;

procedure TframeDuplicateFiles.aFileSearchExecute(Sender: TObject);
var
  FileList  : TStringDynArray;
  Performer : TPerformer;
begin
  inherited;
  LogWriter.Write(ddEnterMethod, Self, 'FileSearch');
  Performer := TPerformer.GetInstance;
  Performer.IsQuiet := False;
  vstTree.BeginUpdate;
  vstTree.Clear;
  FileListClear;
  FBreak := False;

  FileList := TDirectory.GetFiles(edtPath.Text, cbExt.Text, TSearchOption.soAllDirectories);
  TPublishers.ProgressPublisher.StartProgress(Length(FileList));
  LogWriter.Write(ddText, Self, 'Length file list - ' + Length(FileList).ToString);

  Tthread.CreateAnonymousThread(
    procedure
    begin
      TParallel.For(Low(FileList), High(FileList),
        procedure(i: Int64; LoopState: TParallel.TLoopState)
        var
          Data: TFileData;
        begin
          TTask.CurrentTask.CheckCanceled;
          System.TMonitor.Enter(Self);
          try
            if FBreak then
              LoopState.Break;
          finally
            System.TMonitor.Exit(Self);
          end;

          if TFile.Exists(FileList[i]) then
            try
              Data.Hash      := TFileUtils.GetHash(FileList[i]);
              Data.Date      := TFile.GetCreationTime(FileList[i]);
              Data.Size      := TFile.GetSize(FileList[i]);
              Data.FileName  := FileList[i];
              Data.ShortName := TPath.GetFileName(FileList[i]);
              Tthread.Queue(nil,
                procedure
                begin
                  AddNode(Data);
                end);
            except
              on E: Exception do
                LogWriter.Write(ddError, Self, E.Message);
            end;
        end);

      Tthread.Synchronize(nil,
        procedure
        begin
          TMessageDialog.ShowInfo(TLang.Lang.Translate('Successful'));
          LogWriter.Write(ddExitMethod, Self, 'FileSearch');
          Performer.Count := vstTree.TotalCount;
          Performer.FromDBCount := vstTree.TotalCount - vstTree.RootNodeCount;
          TPublishers.ProgressPublisher.EndProgress;
          vstTree.FullExpand;
          vstTree.EndUpdate;
          Performer.IsQuiet := False;
        end)
    end).Start;
  Performer.IsQuiet := True;
end;

procedure TframeDuplicateFiles.aOpenFileExecute(Sender: TObject);
var
  Data: PFileData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    if Assigned(Data) then
    begin
      if TFile.Exists(Data^.FileName) then
        TFileUtils.ShellOpen(Data^.FileName)
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
    end
  end;
end;

procedure TframeDuplicateFiles.aOpenLocationExecute(Sender: TObject);
var
  Data: PFileData;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode^.GetData;
    if Assigned(Data) then
      if not Data^.FileName.IsEmpty then
        Winapi.ShellAPI.ShellExecute(0, nil, 'explorer.exe', PChar('/select,' + Data^.FileName), nil, SW_SHOWNORMAL)
  end;
end;

procedure TframeDuplicateFiles.aDeleteSelectedExecute(Sender: TObject);
var
  Data     : PFileData;
  FileList : TStringDynArray;
  i        : Integer;
  Node     : PVirtualNode;
begin
  inherited;
  if (TMessageDialog.ShowQuestion(Format(TLang.Lang.Translate('DeleteSelectedPrompt'), [vstTree.CheckedCount]), [mbYes, mbNo], True) = mrNo) then
    Exit;

  TPerformer.GetInstance.IsQuiet := True;
  TPublishers.ProgressPublisher.StartProgress(vstTree.CheckedCount);
  SetLength(FileList, vstTree.CheckedCount);
  vstTree.BeginUpdate;
  try
    i := 0;
    Node := vstTree.GetNextChecked(vstTree.RootNode.FirstChild, True);
    while Assigned(Node) do
    begin
      Data := Node^.GetData;
      if TFile.Exists(Data^.FileName) then
      begin
        FileList[i] := Data^.FileName;
        Data^.IsDeleted := True;
        Node.CheckState := TCheckState.csUncheckedNormal;
        Inc(i);
      end;
      Node := vstTree.GetNextChecked(Node, True);
    end;

    TParallel.For(Low(FileList), High((FileList)),
        procedure(i: Integer)
        begin
          if TFile.Exists(FileList[i]) then
          try
            TFile.Delete(FileList[i]);
            LogWriter.Write(ddText, Self, 'Delete files', FileList[i]);
          except
            on E: Exception do
              LogWriter.Write(ddError, Self, 'Delete files', E.Message);
          end;
          TPublishers.ProgressPublisher.Progress;
        end);

    TMessageDialog.ShowInfo(TLang.Lang.Translate('Successful'));
  finally
    TPublishers.ProgressPublisher.EndProgress;
    TPerformer.GetInstance.IsQuiet := False;
    vstTree.EndUpdate;
  end;
end;

procedure TframeDuplicateFiles.aAllCheckExecute(Sender: TObject);
var
  ParentNode: PVirtualNode;
  Node: PVirtualNode;
begin
  inherited;
  vstTree.BeginUpdate;
  try
    ParentNode := vstTree.RootNode.FirstChild;
    while Assigned(ParentNode) do
    begin
      ParentNode.CheckState := TCheckState.csUncheckedNormal;
      Node := ParentNode.FirstChild;
      while Assigned(Node) do
      begin
        Node.CheckState := TCheckState.csCheckedNormal;
        Node := vstTree.GetNextSibling(Node);
      end;
      ParentNode := vstTree.GetNextSibling(ParentNode);
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeDuplicateFiles.aAllUnCheckExecute(Sender: TObject);
var
  Node: PVirtualNode;
begin
  inherited;
  vstTree.BeginUpdate;
  try
    Node := vstTree.GetNextChecked(vstTree.RootNode.FirstChild, True);
    while Assigned(Node) do
    begin
      Node.CheckState := TCheckState.csUncheckedNormal;
      Node := vstTree.GetNextChecked(Node, True);
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeDuplicateFiles.aDeleteSelectedUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := vstTree.CheckedCount > 0;
end;

procedure TframeDuplicateFiles.aAllCheckUpdate(Sender: TObject);
begin
  inherited;
    TAction(Sender).Enabled := not vstTree.IsEmpty;
end;

end.
