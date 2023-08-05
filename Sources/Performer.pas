unit Performer;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, DebugWriter, Common.Types, System.IniFiles,
  System.IOUtils, Global.Resources, Utils, MessageDialog, System.Threading, HtmlLib, CustomForms, Vcl.WinXCtrls,
  Vcl.WinXPanels, System.Actions, Vcl.ActnList, DaImages, Vcl.Imaging.pngimage, Vcl.CategoryButtons, Frame.Custom,
  Vcl.ComCtrls, Vcl.Menus, Frame.LogView, Vcl.Buttons, Vcl.Samples.Gauges, Global.Types, ArrayHelper,
  System.Generics.Collections, System.Generics.Defaults, System.Types, System.RegularExpressions, VirtualTrees,
  clHtmlParser, clMailMessage;
{$ENDREGION}

type
  TfrmPerformer = class(TCustomForm)
    aBreak: TAction;
    alPerformer: TActionList;
    btnBreak: TBitBtn;
    frameLogView: TframeLogView;
    gbInfo: TGroupBox;
    gProgress: TGauge;
    memInfo: TMemo;
    pnlBottom: TPanel;
    pnlTop: TPanel;
    splInfo: TSplitter;
    srchBox: TSearchBox;
    aExecute: TAction;
    procedure aBreakExecute(Sender: TObject);
    procedure aExecuteExecute(Sender: TObject);
    procedure srchBoxInvokeSearch(Sender: TObject);
    procedure frameLogViewvstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    FBreak: Boolean;
    function GetDirectoriesList: TStringArray;
    procedure Execute;
    procedure IncProgress;
    procedure LoadAndExecute;
  public
    procedure Initialize;
    procedure Deinitialize;
    class function ShowDocument: Boolean;
  end;

implementation

{$R *.dfm}

{ TfrmPerformer }

class function TfrmPerformer.ShowDocument: Boolean;
begin
  with TfrmPerformer.Create(nil) do
    try
      Result := False;
      Initialize;
      ShowModal;
      if (ModalResult = mrOk) then
      begin
        Result := True;
      end;
    finally
      Deinitialize;
      Free;
    end;
end;

procedure TfrmPerformer.Initialize;
begin
  frameLogView.Initialize;
  pnlTop.Color        := C_TOP_COLOR;
  gProgress.ForeColor := C_TOP_COLOR;

  aExecute.Hint  := TLang.Lang.Translate('Go');
  aBreak.Caption := TLang.Lang.Translate('Break');
  gbInfo.Caption := TLang.Lang.Translate('Info');
  gProgress.Progress := 0;
end;

procedure TfrmPerformer.Deinitialize;
begin

end;

procedure TfrmPerformer.IncProgress;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      if (gProgress.Progress >= gProgress.MaxValue) then
        gProgress.MaxValue := gProgress.MaxValue + 1;
      gProgress.Progress := gProgress.Progress + 1;
      gProgress.Refresh;
    end)
end;

procedure TfrmPerformer.Execute;
begin
  gProgress.Visible := True;
  FBreak := False;
  try
    LoadAndExecute;
  finally
    gProgress.Visible := False;
    aBreak.Caption := TLang.Lang.Translate('Ok');
    aBreak.ImageIndex := 46;
    btnBreak.ImageIndex := 46;
    btnBreak.ModalResult := mrOk;
  end;
end;

procedure TfrmPerformer.aBreakExecute(Sender: TObject);
begin
  inherited;
  FBreak := True;
  Application.ProcessMessages;
end;

procedure TfrmPerformer.aExecuteExecute(Sender: TObject);
begin
  inherited;
  Execute;
end;

function TfrmPerformer.GetDirectoriesList: TStringArray;
var
  PathList: TArray<TParamPath>;
begin
  PathList := TGeneral.GetPathList;
  for var Dir in PathList do
  begin
    if not TDirectory.Exists(Dir.Path) then
      frameLogView.Write(ddWarning, 'ExecuteFile', Format(TLang.Lang.Translate('DirectoryNotFound'), [Dir.Path]))
    else
      Result.AddUnique(Dir.Path);
  end;
end;

procedure TfrmPerformer.LoadAndExecute;
var
  DirList: TStringArray;
  FileList: TStringDynArray;
begin
//  IdMessage1.Att := ;
  DirList := GetDirectoriesList;
  for var Dir in DirList do
  begin
    Application.ProcessMessages;
    if not FBreak then
      try
       FileList := TDirectory.GetFiles(Dir);
       gProgress.MaxValue := Length(FileList);
       frameLogView.Write(TLogDetailType.ddText, 'Found count files:', Length(FileList).ToString);
       for var FileName in FileList do
       begin

         IncProgress;
       end;
      except
        on E: Exception do
        begin
          TMessageDialog.ShowError(TLang.Lang.Translate('Failed'), E.Message);
          Exit;
        end;
      end;
  end;
end;

procedure TfrmPerformer.srchBoxInvokeSearch(Sender: TObject);
begin
  inherited;
  frameLogView.SearchText(srchBox.Text);
end;

procedure TfrmPerformer.frameLogViewvstTreeFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var
  Data: PLogData;
begin
  inherited;
  if Assigned(Node) then
  begin
    memInfo.Lines.BeginUpdate;
    try
      Data := Node.GetData;
      memInfo.Lines.Text := Data.Info;
    finally
      memInfo.Lines.EndUpdate;
    end;
  end;
end;

end.
