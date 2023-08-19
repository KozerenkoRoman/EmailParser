unit CommonForms;

interface

{$REGION 'Region uses'}
uses
  Windows, ActnList, AppEvnts, Classes, Controls, Dialogs, Vcl.Forms, Messages, System.Actions, Variants,
  System.TypInfo, Vcl.Graphics, System.SysUtils,{$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF}
  DebugWriter, Utils.LocalInformation, HtmlConsts, HtmlLib, Global.Resources, Utils.VerInfo, Translate.Lang,
  Global.Types;
{$ENDREGION}

type
  TDialogMode = (dmInsert, dmUpdate, dmView);

  TCommonForm = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
  private const
    C_COMPONENT_CLASSNAME       = 'ClassName';
    C_COMPONENT_HIERARCHY_CLASS = 'CompHierarchy';
    C_COMPONENT_MODULENAME      = 'ModuleName';
    C_COMPONENT_NAME            = 'CompName';
    C_SYS_SHOW_CLASS_INFO       = 'System Info';

    SC_SYS_INFO     = WM_USER + 150;
    WM_AFTER_SHOW   = WM_USER + 151;
    WM_AFTER_CREATE = WM_USER + 152;
  protected const
    C_KEY_FORM_HEIGHT = 'Height';
    C_KEY_FORM_WIDTH  = 'Width';
    C_KEY_FORM_LEFT   = 'Left';
    C_KEY_FORM_TOP    = 'Top';
  private
    FDialogMode: TDialogMode;
    FOnAfterCreate: TNotifyEvent;
    FOnAfterShow: TNotifyEvent;
    function GetClassInfo: string;
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMAfterShow(var Msg: TMessage); message WM_AFTER_SHOW;
    procedure WMAfterCreate(var Msg: TMessage); message WM_AFTER_CREATE;
  protected
    procedure ScaleForm(aForm: TForm; aScreenWidth, aScreenHeight: LongInt);
    function GetIdentityName: string; virtual;
    procedure SaveFormPosition;
    procedure LoadFormPosition;

    property OnAfterShow   : TNotifyEvent read FOnAfterShow   write FOnAfterShow;
    property OnAfterCreate : TNotifyEvent read FOnAfterCreate write FOnAfterCreate;
  public
    constructor Create(AOwner: TComponent); override;
    property DialogMode: TDialogMode read FDialogMode write FDialogMode;
  end;

implementation

{$R *.dfm}

uses
  InformationDialog;

{TCommonForm}

constructor TCommonForm.Create(AOwner: TComponent);
var
  SysMenu: HMENU;
begin
  inherited;
  SysMenu := GetSystemMenu(Handle, False);
  AppendMenu(SysMenu, MF_SEPARATOR, 0, '');
  AppendMenu(SysMenu, MF_STRING, SC_SYS_INFO, PWideChar(C_SYS_SHOW_CLASS_INFO));
  Caption := Format(rsCaption, [Application.Title, TVersionInfo.GetAppVersion]);
  ShowHint := True;
  PostMessage(Self.Handle, WM_AFTER_CREATE, 0, 0);
end;

procedure TCommonForm.FormAfterMonitorDpiChanged(Sender: TObject; OldDPI, NewDPI: Integer);
begin
  DisableAlign;
  try
    for var i := 0 to ControlCount - 1 do
      Controls[i].ScaleForPPI(NewDPI);
  finally
    EnableAlign;
  end;
end;

procedure TCommonForm.FormShow(Sender: TObject);
begin
  inherited;
  PostMessage(Self.Handle, WM_AFTER_SHOW, 0, 0);
end;

procedure TCommonForm.WMAfterCreate(var Msg: TMessage);
begin
  if Assigned(FOnAfterCreate) then
    FOnAfterCreate(Self);
end;

procedure TCommonForm.WMAfterShow(var Msg: TMessage);
begin
  if Assigned(FOnAfterShow) then
    FOnAfterShow(Self);
end;

procedure TCommonForm.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_SYS_INFO then
    TInformationDialog.ShowMessage(Self.GetClassInfo, 'ClassInfo')
  else
    inherited;
end;

function TCommonForm.GetClassInfo: string;
var
  loClass : TClass;
  sText   : string;
begin
  sText := Concat(C_HTML_HEAD_OPEN,
                  C_STYLE,
                  C_HTML_HEAD_CLOSE,
                  C_HTML_BODY_OPEN);

  //C_COMPONENT_CLASSNAME
  loClass := Self.ClassType;
  sText   := Concat(sText, THtmlLib.GetTableTag(VarArrayOf([TLang.Lang.Translate(C_COMPONENT_NAME),
                                                            TLang.Lang.Translate(C_COMPONENT_CLASSNAME),
                                                            TLang.Lang.Translate(C_COMPONENT_MODULENAME)]),
                                                            Self.Caption));
  sText := Concat(sText, THtmlLib.GetTableLineTag(VarArrayOf([Self.Name, loClass.ClassName, loClass.UnitName + '.pas'])));
  sText := Concat(sText, C_HTML_TABLE_CLOSE, C_HTML_BREAK);

  //C_COMPONENT_HIERARCHY_CLASS
  sText := Concat(sText, THtmlLib.GetTableTag(VarArrayOf([TLang.Lang.Translate(C_COMPONENT_CLASSNAME),
                                                          TLang.Lang.Translate(C_COMPONENT_MODULENAME)]),
                                                          THtmlLib.GetColorTag(TLang.Lang.Translate(C_COMPONENT_HIERARCHY_CLASS), clNavy)));
  while (loClass.ClassName <> 'TForm') do
  begin
    loClass := loClass.ClassParent;
    sText   := Concat(sText, THtmlLib.GetTableLineTag(VarArrayOf([loClass.ClassName, loClass.UnitName + '.pas'])));
  end;
  Result := Concat(sText, C_HTML_TABLE_CLOSE, C_HTML_BODY_CLOSE);
end;

function TCommonForm.GetIdentityName: string;
begin
  Result := '';
end;

procedure TCommonForm.SaveFormPosition;
var
  IdentityName: string;
begin
  IdentityName := GetIdentityName;
  if not IdentityName.IsEmpty then
  begin
    General.XMLFile.WriteInteger(IdentityName, C_KEY_FORM_HEIGHT, Self.Height);
    General.XMLFile.WriteInteger(IdentityName, C_KEY_FORM_WIDTH, Self.Width);
    General.XMLFile.WriteInteger(IdentityName, C_KEY_FORM_LEFT, Self.Left);
    General.XMLFile.WriteInteger(IdentityName, C_KEY_FORM_TOP, Self.Top);
  end;
end;

procedure TCommonForm.LoadFormPosition;
var
  IdentityName: string;
begin
  IdentityName := GetIdentityName;
  if not IdentityName.IsEmpty then
  begin
    Self.Height := General.XMLFile.ReadInteger(IdentityName, C_KEY_FORM_HEIGHT, Self.Height);
    Self.Width  := General.XMLFile.ReadInteger(IdentityName, C_KEY_FORM_WIDTH, Self.Width);
    Self.Left   := General.XMLFile.ReadInteger(IdentityName, C_KEY_FORM_LEFT, Self.Left);
    Self.Top    := General.XMLFile.ReadInteger(IdentityName, C_KEY_FORM_TOP, Self.Top);
    if (Self.Top < 0) then
      Self.Top := 0
    else if (Self.Top > Screen.DesktopHeight) then
      Self.Top := Screen.DesktopHeight - Self.Height;
    if (Self.Left < 0) then
      Self.Left := 0
    else if (Self.Left > Screen.DesktopWidth) then
      Self.Left := Screen.DesktopWidth - Self.Width;
  end;
end;

procedure TCommonForm.ScaleForm(aForm: TForm; aScreenWidth, aScreenHeight: LongInt);
begin
  aForm.Scaled     := True;
  aForm.AutoScroll := False;
  aForm.Position   := poScreenCenter;
//  aForm.Font.Name := 'Arial';
  if (Screen.Width <> aScreenWidth) then
  begin
    aForm.Height := LongInt(aForm.Height) * LongInt(Screen.Height) div aScreenHeight;
    aForm.Width  := LongInt(aForm.Width) * LongInt(Screen.Width) div aScreenWidth;
    aForm.ScaleBy(Screen.Width, aScreenWidth);
  end;
end;

end.
