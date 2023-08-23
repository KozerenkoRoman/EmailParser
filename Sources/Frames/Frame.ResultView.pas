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
  Frame.Emails, Frame.AllAttachments;
{$ENDREGION}

type
  TframeResultView = class(TFrameCustom, IEmailChange)
    frameAllAttachments : TframeAllAttachments;
    frameAttachments    : TframeAttachments;
    frameEmails         : TframeEmails;
    memTextPlain        : TMemo;
    pcInfo              : TPageControl;
    pcMain              : TPageControl;
    SaveDialogEmail     : TSaveDialog;
    splInfo             : TSplitter;
    tsAllAttachments    : TTabSheet;
    tsAttachments       : TTabSheet;
    tsEmail             : TTabSheet;
    tsHtmlText          : TTabSheet;
    tsPlainText         : TTabSheet;
    wbBody              : TWebBrowser;
    procedure wbBodyBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
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
  tsAllAttachments.Caption := TLang.Lang.Translate('AllAttachments');
  tsAttachments.Caption    := TLang.Lang.Translate('Attachment');
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
begin
  inherited;
  if Assigned(aData) then
  begin
    memTextPlain.Lines.Text := aData^.ParsedText;
    THtmlLib.LoadStringToBrowser(wbBody, aData^.Body);
    if Assigned(wbBody.Document) then
      with wbBody.Application as IOleobject do
        DoVerb(OLEIVERB_UIACTIVATE, nil, wbBody, 0, Handle, GetClientRect);
  end;
end;

end.
