unit Frame.AllAttachments;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles, Files.Utils,
  Vcl.WinXPanels, Publishers.Interfaces, Publishers;
{$ENDREGION}

type
  TframeAllAttachments = class(TFrameSource, IProgress, IUpdateXML)
    aOpenAttachFile      : TAction;
    aOpenParsedText      : TAction;
    btnOpenAttachFile    : TToolButton;
    btnOpenParsedText    : TToolButton;
    btnSep04             : TToolButton;
    SaveDialogAttachment : TSaveDialog;
    procedure aOpenAttachFileExecute(Sender: TObject);
    procedure aOpenAttachFileUpdate(Sender: TObject);
    procedure aOpenParsedTextExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
  private const
    COL_SHORT_NAME   = 0;
    COL_FILE_NAME    = 1;
    COL_CONTENT_TYPE = 2;
    COL_PARSED_TEXT  = 3;

    C_IDENTITY_NAME = 'frameAllAttachments';
  private
      //IUpdateXML
    procedure UpdateXML;

    //IProgress
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: TResultData);

    procedure SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
  protected
    function GetIdentityName: string; override;
    procedure SearchText(const aText: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
  end;

implementation

{$R *.dfm}

{ TframeAllAttachments }

constructor TframeAllAttachments.Create(AOwner: TComponent);
begin
  inherited;
  vstTree.NodeDataSize := SizeOf(TAttachments);
  TPublishers.UpdateXMLPublisher.Subscribe(Self);
  TPublishers.ProgressPublisher.Subscribe(Self);
end;

destructor TframeAllAttachments.Destroy;
begin
  TPublishers.UpdateXMLPublisher.Unsubscribe(Self);
  TPublishers.ProgressPublisher.Unsubscribe(Self);
  inherited;
end;

function TframeAllAttachments.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeAllAttachments.Initialize;
begin
  inherited Initialize;
  vstTree.FullExpand;
  Translate;
end;

procedure TframeAllAttachments.Deinitialize;
begin

  inherited Deinitialize;
end;

procedure TframeAllAttachments.Translate;
begin
  inherited;
  aOpenAttachFile.Hint  := TLang.Lang.Translate('OpenFile');
  vstTree.Header.Columns[COL_SHORT_NAME].Text   := TLang.Lang.Translate('FileName');
  vstTree.Header.Columns[COL_FILE_NAME].Text    := TLang.Lang.Translate('Path');
  vstTree.Header.Columns[COL_CONTENT_TYPE].Text := TLang.Lang.Translate('ContentType');
  vstTree.Header.Columns[COL_PARSED_TEXT].Text  := TLang.Lang.Translate('Text');
end;

procedure TframeAllAttachments.aOpenAttachFileExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TFile.Exists(Data^.FileName) then
      TFileUtils.ShellOpen(Data^.FileName)
    else
      TMessageDialog.ShowWarning(Format(TLang.Lang.Translate('FileNotFound'), [Data^.FileName]));
  end;
end;

procedure TframeAllAttachments.aOpenAttachFileUpdate(Sender: TObject);
begin
  inherited;
  TAction(Sender).Enabled := not vstTree.IsEmpty and Assigned(vstTree.FocusedNode);
end;

procedure TframeAllAttachments.aOpenParsedTextExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    TInformationDialog.ShowMessage(Data^.ParsedText, GetIdentityName);
  end;
end;

procedure TframeAllAttachments.aSaveExecute(Sender: TObject);
var
  Data: PAttachments;
begin
  inherited;
  if not vstTree.IsEmpty and Assigned(vstTree.FocusedNode) then
  begin
    Data := vstTree.FocusedNode.GetData;
    if TFile.Exists(Data^.FileName) then
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

procedure TframeAllAttachments.vstTreeCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PAttachments;
begin
  inherited;
  Data1 := Node1^.GetData;
  Data2 := Node2^.GetData;
  case Column of
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

procedure TframeAllAttachments.vstTreeFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PAttachments;
begin
  inherited;
  Data := Node^.GetData;
  if Assigned(Data) then
    Data^.Clear;
end;

procedure TframeAllAttachments.vstTreeGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: System.UITypes.TImageIndex);
var
  Data: PAttachments;
begin
  inherited;
  if (Column = COL_SHORT_NAME) and (Kind in [ikNormal, ikSelected]) then
  begin
    Data := Node^.GetData;
    ImageIndex := Data^.ImageIndex;
  end;
end;

procedure TframeAllAttachments.vstTreeGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PAttachments;
begin
  inherited;
  CellText := '';
  Data := Node^.GetData;
  case Column of
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

procedure TframeAllAttachments.SearchForText(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  CellText: string;
begin
  vstTreeGetText(Sender, Node, vstTree.FocusedColumn, ttNormal, CellText);
  Abort := CellText.ToUpper.Contains(string(Data).ToUpper);
end;

procedure TframeAllAttachments.SearchText(const aText: string);
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
      vstTree.FocusedNode    := Node;
      vstTree.Selected[Node] := True;
    end;
  finally
    vstTree.EndUpdate;
  end;
end;

procedure TframeAllAttachments.StartProgress(const aMaxPosition: Integer);
begin
  vstTree.BeginUpdate;
  vstTree.Clear;
end;

procedure TframeAllAttachments.CompletedItem(const aResultData: TResultData);
var
  Data: PAttachments;
  Node: PVirtualNode;
begin
  for var i := Low(aResultData.Attachments) to High(aResultData.Attachments) do
  begin
    Node := vstTree.AddChild(nil);
    Data := Node^.GetData;
    Data^.Assign(aResultData.Attachments[i]);
  end;
end;

procedure TframeAllAttachments.EndProgress;
begin
  vstTree.EndUpdate;
end;

procedure TframeAllAttachments.Progress;
begin

end;

procedure TframeAllAttachments.UpdateXML;
begin

end;

end.
