program EmailParser;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$R 'Logo.res' 'Resources\Logo.rc'}

uses
  Vcl.Forms,
  System.SysUtils,
  ArrayHelper in 'Common\ArrayHelper.pas',
  Common.Types in 'Common\Common.Types.pas',
  CustomForms in 'Sources\CustomForms.pas' {CustomForm},
  DaImages in 'DataModules\DaImages.pas' {DMImage: TDataModule},
  DebugWriter in 'Common\DebugWriter.pas',
  Frame.Custom in 'Sources\Frame.Custom.pas' {frameCustom: TFrame},
  Frame.Pathes in 'Sources\Frame.Pathes.pas' {framePathes: TFrame},
  Frame.RegExpParameters in 'Sources\Frame.RegExpParameters.pas' {frameRegExpParameters: TFrame},
  Frame.ResultView in 'Sources\Frame.ResultView.pas' {frameResultView: TFrame},
  Frame.Settings in 'Sources\Frame.Settings.pas' {frameSettings: TFrame},
  Global.Resources in 'Resources\Global.Resources.pas',
  Global.Types in 'Sources\Global.Types.pas',
  HtmlConsts in 'Common\HtmlConsts.pas',
  HtmlLib in 'Common\HtmlLib.pas',
  InformationDialog in 'Sources\InformationDialog.pas' {InformationDialog},
  MessageDialog in 'Common\MessageDialog.pas',
  Performer in 'Sources\Performer.pas',
  Settings in 'Sources\Settings.pas' {frmSettings},
  SplashScreen in 'Sources\SplashScreen.pas' {frmSplashScreen},
  Translate.Lang in 'Translate\Translate.Lang.pas',
  Translate.Resources in 'Translate\Translate.Resources.pas',
  Utils in 'Common\Utils.pas',
  Utils.Exceptions in 'Sources\Utils.Exceptions.pas',
  Utils.LocalInformation in 'Common\Utils.LocalInformation.pas',
  Utils.VerInfo in 'Common\Utils.VerInfo.pas',
  VirtualTrees.ExportHelper in 'Sources\VirtualTrees.ExportHelper.pas',
  XmlFiles in 'Common\XmlFiles.pas';

{$R *.res}

begin
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    try
      TfrmSplashScreen.ShowSplashScreen;
      Application.CreateForm(TDMImage, DMImage);
  Application.CreateForm(TfrmSettings, frmSettings);
  frmSettings.Initialize;
    finally
      TfrmSplashScreen.HideSplashScreen;
    end;
    Application.ShowMainForm := True;
    Application.Run;
  except
    on E: Exception do
    begin
      TfrmSplashScreen.HideSplashScreen;
      if Assigned(LogWriter) then
        LogWriter.Write(ddError, E.Message);
    end;
  end;
end.
