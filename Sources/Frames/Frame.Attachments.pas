unit Frame.Attachments;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Utils.Files,
  Vcl.WinXPanels, Publishers.Interfaces, Publishers, Global.Utils, VirtualTrees.ExportHelper, Global.Resources,
  DaModule, System.Threading, EXIF.Dialog, XLSX.Dialog, Winapi.ShellAPI;
{$ENDREGION}

type
  TframeAttachments = class(TframeSource, IEmailChange, IConfig)
    aOpenAttachFile      : TAction;
    aOpenLocation        : TAction;
    aOpenParsedText      : TAction;
    btnOpenAttachFile    : TToolButton;
    btnOpenParsedText    : TToolButton;
    btnSep04             : TToolButton;
    miOpenAttachFile     : TMenuItem;
    miOpenLocation       : TMenuItem;
    miOpenParsedText     : TMenuItem;
    miSep                : TMenuItem;
    SaveDialogAttachment : TSaveDialog;
    procedure aOpenAttachFileExecute(Sender: TObject);
    procedure aOpenAttachFileUpdate(Sender: TObject);
    procedure aOpenLocationExecute(Sender: TObject);
    procedure aOpenParsedTextExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string); override;
    procedure vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private const
    COL_POSITION     = 0;
    COL_SHORT_NAME   = 1;
    COL_FILE_NAME    = 2;
    COL_CONTENT_TYPE = 3;
    COL_PARSED_TEXT  = 4;
    C_FIXED_COLUMNS  = 5;

    C_IDENTITY_NAME = 'frameAttachments';
  private
    //IEmailChange
    procedure FocusChanged(const aData: PResultData);

    //IConfig
    procedure IConfig.UpdateRegExp = UpdateColumns;
    procedure UpdateFilter;
    procedure UpdateColumns;
  protected
    function GetIdentityName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

implementation

{$R *.dfm}

{ TframeAttachments }

constructor TframeAttachments.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TAttachData);
  TPublishers.EmailPublisher.Subscribe(Self);
  TPublishers.ConfigPublisher.Subscribe(Self);
end;

destructor TframeAttachments.Destroy;
begin
  TPublishers.EmailPublisher.Unsubscribe(Self);
  TPublishers.ConfigPublisher.Unsubscribe(Self);
  inherited;
end;

function TframeAttachments.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeAttachments.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  Translate;
  UpdateColumns;
end;

procedure TframeAttachments.Translate;
begin
  inherited;
  aOpenAttachFile.Caption := TLang.Lang.Translate('OpenFile');
  aOpenAttachFile.Hint    := TLang.Lang.Translate('OpenFile');
  aOpenLocation.Caption   := TLang.Lang.Translate('OpenLocation');
  aOpenLocation.Hint      := TLang.Lang.Translate('OpenLocation');
  aOpenParsedText.Caption := TLang.Lang.Translate('OpenParsedText');
  aOpenParsedText.Hint    := TLang.Lang.Translate('OpenParsedText');
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');
  vstTree.Header.Columns[COL_PARSED_TEXT].Text  := TLang.Lang.Translate('Text');
end;

procedure TframeAttachments.Deinitialize;
begin

  inherited Deinitialize;
end;

procedure TframeAttachments.UpdateColumns;
var
  Column     : TVirtualTreeColumn;
  Node       : PVirtualNode;
  CurrNode   : PVirtualNode;
  Data       : PAttachData;
begin
  vstTree.BeginUpdate;
  while (C_FIXED_COLUMNS < vstTree.Header.Columns.Count) do
    vstTree.Header.Columns.Delete(C_FIXED_COLUMNS);

  Node := vstTree.RootNode.FirstChild;
  while Assigned(Node) do
  begin
    Data := Node^.GetData;
    Data^.Matches.Count := TGeneral.PatternList.Count;
    if (Node.ChildCount > 0) then
    begin
      CurrNode := Node.FirstChild;
      while Assigned(CurrNode) do
      begin
        Data := CurrNode^.GetData;
        Data^.Matches.Count := TGeneral.PatternList.Count;
        CurrNode := CurrNode.NextSibling;
      end;
    end;
    Node := Node.NextSibling;
  end;

  try
    for var item in TGeneral.PatternList do
    begin
      Column := vstTree.Header.Columns.Add;
      Column.Text             := item^.ParameterName;
      Column.Options          := Column.Options - [coEditable];
      Column.CaptionAlignment := taCenter;
      Column.Alignment        := taLeftJustify;
      Column.Width            := 100;
      Column.Options          := Column.Options + [coVisible];
    end;
    TStoreHelper.LoadFromXML(vstTree, GetIdentityName + C_IDENTITY_COLUMNS_NAME);
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAttachments.UpdateFilter;
begin
  //nothing
end;

procedure TframeAttachments.aOpenAttachFileExecute(Sender: TObject);
var
  Data: PAttachment;
  FileName: string;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      FileName := Data^.FileName;
      if TFile.Exists(FileName) then
        TFileUtils.ShellOpen(FileName)
      else if Data^.FromZip then
      begin
        Data := TGeneral.AttachmentList.GetItem(Data^.ParentHash);
        if Assigned(Data) then
        begin
          if TFile.Exists(Data^.FileName) then
            TFileUtils.ShellOpen(Data^.FileName)
          else
            TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
        end
        else
          TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [FileName]));
      end
      else
        TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [FileName]));
    end;
  end;
end;

procedure TframeAttachments.aOpenAttachFileUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeAttachments.aOpenLocationExecute(Sender: TObject);
var
  Data: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
      if not Data^.FileName.IsEmpty then
        Winapi.ShellAPI.ShellExecute(0, nil, 'explorer.exe', PChar('/select,' + Data^.FileName), nil, SW_SHOWNORMAL)
  end;
end;

procedure TframeAttachments.aOpenParsedTextExecute(Sender: TObject);
var
  Data: PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) then
    begin
      if Data^.ParsedText.IsEmpty then
        Data^.ParsedText := TDaMod.GetAttachmentAsRawText(Data^.Hash);
      if Data^.ContentType.StartsWith('image', True) then
        TEXIFDialog.ShowMessage(Data^.ParsedText, Data^.FileName, Data^.Matches)
      else if Data^.ContentType.EndsWith('sheet', True) then
        TXLSXDialog.ShowMessage(Data^.ParsedText, Data^.Matches)
      else
        TInformationDialog.ShowMessage(TGlobalUtils.GetHighlightText(Data^.ParsedText.Replace(#10, '<br>'), Data^.Matches), GetIdentityName);
    end;
  end;
end;

procedure TframeAttachments.aSaveExecute(Sender: TObject);
var
  Data : PAttachment;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(vstTree.FocusedNode^.GetData).Hash);
    if Assigned(Data) and TFile.Exists(Data^.FileName) then
    begin
      SaveDialogAttachment.InitialDir := TPath.GetDirectoryName(Data^.FileName);
      SaveDialogAttachment.Filter     := 'Attachment|*' + TPath.GetExtension(Data^.FileName) + '|All files|*.*';
      SaveDialogAttachment.FileName   := Data^.FileName;
      if SaveDialogAttachment.Execute and (SaveDialogAttachment.FileName <> Data^.FileName) then
        TFile.Copy(Data^.FileName, SaveDialogAttachment.FileName);
    end
    else
      TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeAttachments.vstTreeBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PAttachment;
  AttachData: PAttachData;
begin
  inherited;
  if (Sender.GetNodeLevel(Node) >= 1) then
  begin
    AttachData := Node^.GetData;
    if Assigned(AttachData) and (Column >= C_FIXED_COLUMNS) then
      if not AttachData^.Matches[Column - C_FIXED_COLUMNS].IsEmpty then
      begin
        TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
        TargetCanvas.FillRect(CellRect);
      end;
  end
  else
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      if (Column < C_FIXED_COLUMNS) then
      begin
        if Data^.FromZip then
        begin
          TargetCanvas.Brush.Color := clWebWhiteSmoke;
          TargetCanvas.FillRect(CellRect);
        end
      end
      else if (Data^.Matches[Column - C_FIXED_COLUMNS].Count > 0) then
      begin
        TargetCanvas.Brush.Color := TGeneral.PatternList[Column - C_FIXED_COLUMNS].Color;
        TargetCanvas.FillRect(CellRect);
      end;
  end;
end;

procedure TframeAttachments.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAttachment;
begin
  inherited;
  Data1 := TGeneral.AttachmentList.GetItem(PAttachData(Node1^.GetData).Hash);
  Data2 := TGeneral.AttachmentList.GetItem(PAttachData(Node2^.GetData).Hash);
  if (not Assigned(Data1)) or (not Assigned(Data2)) then
    Result := 0
  else
    case Column of
      COL_POSITION:
        Result := CompareValue(vstTree.AbsoluteIndex(Node1), vstTree.AbsoluteIndex(Node2));
      COL_SHORT_NAME:
        Result := CompareText(Data1^.ShortName, Data2^.ShortName);
      COL_FILE_NAME:
        Result := CompareText(Data1^.FileName, Data2^.FileName);
      COL_CONTENT_TYPE:
        Result := CompareText(Data1^.ContentType, Data2^.ContentType);
      COL_PARSED_TEXT:
        Result := CompareText(Data1^.ParsedText, Data2^.ParsedText);
    end;
end;

procedure TframeAttachments.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
var
  Data: PAttachment;
begin
  inherited;
  if (Column = COL_SHORT_NAME) and (Kind in [ikNormal, ikSelected]) then
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      ImageIndex := Data^.ImageIndex;
  end;
end;

procedure TframeAttachments.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PAttachment;
  AttachData: PAttachData;
begin
  inherited;
  CellText := '';
  if (Column >= C_FIXED_COLUMNS) then
  begin
    if (Sender.GetNodeLevel(Node) >= 1) then
    begin
      AttachData := Node^.GetData;
      if Assigned(AttachData) then
        CellText := AttachData^.Matches.Items[Column - C_FIXED_COLUMNS];
    end
  end
  else
  begin
    Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
    if Assigned(Data) then
      case Column of
        COL_POSITION:
          CellText := (vstTree.AbsoluteIndex(Node) + 1).ToString;
        COL_SHORT_NAME:
          CellText := Data^.ShortName;
        COL_FILE_NAME:
          CellText := Data^.FileName;
        COL_CONTENT_TYPE:
          CellText := Data^.ContentType;
        COL_PARSED_TEXT:
          CellText := Data^.ParsedText;
      end;
  end;
end;

procedure TframeAttachments.vstTreePaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var
  Data: PAttachment;
begin
  inherited;
  Data := TGeneral.AttachmentList.GetItem(PAttachData(Node^.GetData).Hash);
  if Assigned(Data) then
    if (Column in [COL_FILE_NAME, COL_SHORT_NAME]) and Data^.FromZip then
      TargetCanvas.Font.Color := clNavy;
end;

procedure TframeAttachments.FocusChanged(const aData: PResultData);
var
  arr        : array of array of string;
  ChildNode  : PVirtualNode;
  Attachment : PAttachment;
  Data       : PAttachData;
  IsEmpty    : Boolean;
  MaxCol     : Integer;
  Node       : PVirtualNode;
begin
  if not Assigned(aData) then
    Exit;

  vstTree.BeginUpdate;
  try
    vstTree.Clear;
    if (not aData.MessageId.IsEmpty) then  //?
      for var attHash in aData.Attachments do
        if TGeneral.AttachmentList.TryGetValue(attHash, Attachment) then
        begin
          Node := vstTree.AddChild(nil);
          Data := Node^.GetData;
          Data^.Hash := Attachment.Hash;

          MaxCol := 0;
          for var i := 0 to Attachment.Matches.Count - 1 do
            MaxCol := Max(MaxCol, Attachment.Matches[i].Count);

          IsEmpty := False;
          SetLength(arr, MaxCol, Attachment.Matches.Count);
          for var i := 0 to Attachment.Matches.Count - 1 do
            for var j := 0 to Attachment.Matches[i].Count - 1 do
            begin
              arr[j, i] := Attachment.Matches[i].Items[j].Trim;
              IsEmpty := IsEmpty or arr[j, i].IsEmpty;
            end;

          Data^.Matches.Count := MaxCol;
          if not IsEmpty then
            for var i := Low(arr) to High(arr) do
            begin
              ChildNode := vstTree.AddChild(Node);
              Data := ChildNode^.GetData;
              Data^.Hash := Attachment.Hash;
              Data^.Matches.AddRange(arr[i]);
              vstTree.ValidateNode(ChildNode, False);
            end;
          vstTree.ValidateNode(Node, False);
        end;
  finally
    vstTree.EndUpdate;
  end;
end;

end.
