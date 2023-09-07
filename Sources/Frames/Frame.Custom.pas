﻿unit Frame.Custom;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, VirtualTrees, Vcl.StdCtrls, Vcl.CheckLst, Vcl.Samples.Spin, Vcl.Buttons, Vcl.ExtCtrls,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.Threading, System.Generics.Collections, Vcl.ActnList,
  System.Generics.Defaults, DebugWriter, Global.Types, System.IniFiles, System.Math, System.Actions, Vcl.Menus,
  Vcl.ExtDlgs, Vcl.Printers, MessageDialog, VirtualTrees.ExportHelper, DaImages, Common.Types, Vcl.ComCtrls,
  Vcl.ToolWin, Translate.Lang, VirtualTrees.Helper, Column.Settings, Global.Resources, Vcl.WinXPanels;
{$ENDREGION}

type
  TFrameCustom = class(TFrame)
    aAdd       : TAction;
    aDelete    : TAction;
    aEdit      : TAction;
    alFrame    : TActionList;
    aRefresh   : TAction;
    aSave      : TAction;
    btnAdd     : TToolButton;
    btnDelete  : TToolButton;
    btnEdit    : TToolButton;
    btnRefresh : TToolButton;
    btnSave    : TToolButton;
    btnSep01   : TToolButton;
    btnSep02   : TToolButton;
    pmFrame    : TPopupMenu;
    tbMain     : TToolBar;
  private const
    C_IDENTITY_NAME = 'frameCustom';
  protected
    function GetIdentityName: string; virtual;
    procedure Deinitialize; virtual;
    procedure Initialize; virtual;
    procedure LoadFromXML; virtual; abstract;
    procedure SaveToXML; virtual; abstract;
    procedure Translate; virtual;
  end;

implementation

{$R *.dfm}

{ TFrameCustom }

procedure TFrameCustom.Initialize;
begin
  TGeneral.XMLParams.Open;
end;

procedure TFrameCustom.Deinitialize;
begin
  TGeneral.XMLParams.Save;
end;

procedure TFrameCustom.Translate;
begin
  aAdd.Hint     := TLang.Lang.Translate('Add');
  aDelete.Hint  := TLang.Lang.Translate('Delete');
  aEdit.Hint    := TLang.Lang.Translate('Edit');
  aRefresh.Hint := TLang.Lang.Translate('Refresh');
  aSave.Hint    := TLang.Lang.Translate('Save');
end;

function TFrameCustom.GetIdentityName: string;
begin
  Result := C_IDENTITY_NAME;
end;

end.
