unit Frame.Settings;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.Custom, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.ComCtrls,
  Vcl.ToolWin, VirtualTrees, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Defaults,Translate.Lang, System.Math,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} MessageDialog, Common.Types, DaImages, System.RegularExpressions,
  System.IOUtils, ArrayHelper, Utils, InformationDialog, HtmlLib, HtmlConsts, XmlFiles, Global.Types;
{$ENDREGION}


type
  TframeSettings = class(TframeCustom)
    cbLanguage      : TComboBox;
    edtExtensions   : TEdit;
    grdCommonParams : TGridPanel;
    Label5          : TLabel;
    Label7          : TLabel;
    lblExtensions   : TLabel;
    lblLanguage     : TLabel;
    procedure aRefreshExecute(Sender: TObject);
  private const
    C_IDENTITY_NAME = 'frameSettings';
  protected
    function GetIdentityName: string; override;
    procedure LoadFromXML; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Deinitialize; override;
    procedure Translate; override;
    procedure SaveToXML; override;
  end;

var
  frameSettings: TframeSettings;

implementation

{$R *.dfm}

{ TframeSettings }

constructor TframeSettings.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TframeSettings.Destroy;
begin

  inherited;
end;

procedure TframeSettings.Initialize;
begin
  inherited Initialize;
  LoadFromXML;
  Translate;
end;

procedure TframeSettings.Translate;
begin
  inherited;
  lblLanguage.Caption   := TLang.Lang.Translate('Language');
  lblExtensions.Caption := TLang.Lang.Translate('FileExtensions');
end;

procedure TframeSettings.Deinitialize;
begin
  inherited Deinitialize;
end;

function TframeSettings.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

procedure TframeSettings.LoadFromXML;
begin
  inherited;
  cbLanguage.Items.Clear;
  for var lang := Low(TLanguage) to High(TLanguage) do
    cbLanguage.Items.Add(lang.ToString);
  cbLanguage.ItemIndex := TGeneral.XMLFile.ReadInteger('Language', C_SECTION_MAIN, 0);
  edtExtensions.Text   := TGeneral.XMLFile.ReadString('Extensions', C_SECTION_MAIN, '*.eml');
end;

procedure TframeSettings.SaveToXML;
begin
  inherited;
  TGeneral.XMLFile.WriteInteger('Language', C_SECTION_MAIN, cbLanguage.ItemIndex, cbLanguage.Text);
  TGeneral.XMLFile.WriteString('Extensions', C_SECTION_MAIN, edtExtensions.Text, lblExtensions.Caption);
end;

procedure TframeSettings.aRefreshExecute(Sender: TObject);
begin
  inherited;
  LoadFromXML;
end;

end.
