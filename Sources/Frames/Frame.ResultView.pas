unit Frame.ResultView;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.ExtCtrls, System.Generics.Collections, System.UITypes, DebugWriter,
  Global.Types, System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.Buttons, System.Generics.Defaults, Vcl.Menus, Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  Frame.Source, System.IOUtils, ArrayHelper, Utils, InformationDialog, Html.Lib, Html.Consts, XmlFiles, Vcl.Samples.Gauges,
  Performer, Winapi.ShellAPI, Vcl.OleCtrls, SHDocVw, Winapi.ActiveX, Frame.Attachments, Files.Utils,
  VirtualTrees.ExportHelper, Global.Resources, Publishers, Publishers.Interfaces, Vcl.WinXPanels, Frame.Custom,
  Frame.Emails, Frame.AllAttachments, DaModule;
{$ENDREGION}

type
  TframeResultView = class(TFrameCustom, IEmailChange)
    aCopy               : TAction;
    alMemo              : TActionList;
    aPaste              : TAction;
    aSelectAll          : TAction;
    frameAllAttachments : TframeAllAttachments;
    frameAttachments    : TframeAttachments;
    frameEmails         : TframeEmails;
    memTextBody         : TMemo;
    memTextPlain        : TMemo;
    miCopy              : TMenuItem;
    miPaste             : TMenuItem;
    miSelectAll         : TMenuItem;
    pcInfo              : TPageControl;
    pcMain              : TPageControl;
    pmMemo              : TPopupMenu;
    SaveDialogEmail     : TSaveDialog;
    splInfo             : TSplitter;
    tsAllAttachments    : TTabSheet;
    tsAttachments       : TTabSheet;
    tsBodyText          : TTabSheet;
    tsEmail             : TTabSheet;
    tsHtmlText          : TTabSheet;
    tsPlainText         : TTabSheet;
    wbBody              : TWebBrowser;
    procedure wbBodyBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
    procedure aCopyExecute(Sender: TObject);
    procedure aPasteExecute(Sender: TObject);
    procedure aSelectAllExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'frameResultView';
  private
    //IEmailChange
    procedure FocusChanged(const aData: PResultData);
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

{ TframeResultView }

constructor TframeResultView.Create(AOwner: TComponent);
begin
  inherited;
  TPublishers.EmailPublisher.Subscribe(Self);
end;

destructor TframeResultView.Destroy;
begin
  TPublishers.EmailPublisher.Unsubscribe(Self);
  inherited;
end;

function TframeResultView.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeResultView.Initialize;
begin
  inherited Initialize;
  frameEmails.Initialize;
  frameAllAttachments.Initialize;
  frameAttachments.Initialize;
  LoadFromXML;
  Translate;
end;

procedure TframeResultView.Deinitialize;
begin
  inherited Deinitialize;
  frameEmails.Deinitialize;
  frameAllAttachments.Deinitialize;
  frameAttachments.Deinitialize;
end;

procedure TframeResultView.Translate;
begin
  inherited Translate;
  frameEmails.Translate;
  frameAllAttachments.Translate;
  frameAttachments.Translate;
  aCopy.Caption            := TLang.Lang.Translate('Copy');
  aPaste.Caption           := TLang.Lang.Translate('Paste');
  aSelectAll.Caption       := TLang.Lang.Translate('SelectAll');
  tsAllAttachments.Caption := TLang.Lang.Translate('AllAttachments');
  tsAttachments.Caption    := TLang.Lang.Translate('Attachment');
  tsBodyText.Caption       := TLang.Lang.Translate('Body');
  tsEmail.Caption          := TLang.Lang.Translate('Emails');
  tsPlainText.Caption      := TLang.Lang.Translate('PlainText');
end;

procedure TframeResultView.SaveToXML;
begin
  inherited;

end;

procedure TframeResultView.LoadFromXML;
begin
  inherited;

end;

procedure TframeResultView.wbBodyBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  inherited;
  Cancel := URL <> C_HTML_BLANK;
end;

procedure TframeResultView.FocusChanged(const aData: PResultData);
var
  arr: TArray<string>;
begin
  inherited;
  if Assigned(aData) and (not aData.MessageId.IsEmpty) then
  begin
    arr := DaMod.GetBodyAndText(aData.Hash);
    memTextBody.Lines.Text  := arr[0];
    memTextPlain.Lines.Text := arr[1];
    THtmlLib.LoadStringToBrowser(wbBody, arr[0]);
    if Assigned(wbBody.Document) then
      with wbBody.Application as IOleobject do
        DoVerb(OLEIVERB_UIACTIVATE, nil, wbBody, 0, Handle, GetClientRect);
  end;
end;

procedure TframeResultView.aCopyExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).CopyToClipboard;
end;

procedure TframeResultView.aPasteExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).PasteFromClipboard;
end;

procedure TframeResultView.aSelectAllExecute(Sender: TObject);
begin
  inherited;
  if (Screen.ActiveControl is TMemo) then
    TMemo(Screen.ActiveControl).SelectAll;
end;


end.
