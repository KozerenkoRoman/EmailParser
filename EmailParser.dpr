program EmailParser;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$R 'Logo.res' 'Resources\Logo.rc'}

uses
  Vcl.Forms,
  System.SysUtils,
  ArrayHelper in 'Sources\Common\ArrayHelper.pas',
  Column.Settings in 'Sources\Column.Settings.pas' {frmColumnSettings},
  Column.Types in 'Sources\Column.Types.pas',
  Common.Types in 'Sources\Common\Common.Types.pas',
  CustomForms in 'Sources\CustomForms.pas' {CustomForm},
  DaImages in 'Sources\DataModules\DaImages.pas' {DMImage: TDataModule},
  DebugWriter in 'Sources\Common\DebugWriter.pas',
  ExecConsoleProgram in 'Sources\Common\ExecConsoleProgram.pas',
  Files.Utils in 'Sources\Common\Files.Utils.pas',
  Frame.Attachments in 'Sources\Frames\Frame.Attachments.pas' {frameAttachments: TFrame},
  Frame.CommonSettings in 'Sources\Frames\Frame.CommonSettings.pas' {frameCommonSettings: TFrame},
  Frame.Custom in 'Sources\Frames\Frame.Custom.pas' {frameCustom: TFrame},
  Frame.Pathes in 'Sources\Frames\Frame.Pathes.pas' {framePathes: TFrame},
  Frame.RegExpParameters in 'Sources\Frames\Frame.RegExpParameters.pas' {frameRegExpParameters: TFrame},
  Frame.ResultView in 'Sources\Frames\Frame.ResultView.pas' {frameResultView: TFrame},
  Global.Resources in 'Sources\Global.Resources.pas',
  Global.Types in 'Sources\Global.Types.pas',
  HtmlConsts in 'Sources\Common\HtmlConsts.pas',
  HtmlLib in 'Sources\Common\HtmlLib.pas',
  HtmlParserEx in 'Sources\Common\HtmlParserEx.pas',
  InformationDialog in 'Sources\InformationDialog.pas' {InformationDialog},
  MailMessage.Helper in 'Sources\CleverInternetSuite\MailMessage.Helper.pas',
  MessageDialog in 'Sources\Common\MessageDialog.pas',
  PdfiumCore in 'Sources\PDFiumLib\PdfiumCore.pas',
  PdfiumCtrl in 'Sources\PDFiumLib\PdfiumCtrl.pas',
  PdfiumLib in 'Sources\PDFiumLib\PdfiumLib.pas',
  Performer in 'Sources\Performer.pas',
  Performer.Interfaces in 'Sources\Performer.Interfaces.pas',
  Settings in 'Sources\Settings.pas' {frmSettings},
  SplashScreen in 'Sources\SplashScreen.pas' {frmSplashScreen},
  Translate.Lang in 'Sources\Translate\Translate.Lang.pas',
  Translate.Resources in 'Sources\Translate\Translate.Resources.pas',
  Utils in 'Sources\Common\Utils.pas',
  Utils.Exceptions in 'Sources\Common\Utils.Exceptions.pas',
  Utils.LocalInformation in 'Sources\Common\Utils.LocalInformation.pas',
  Utils.VerInfo in 'Sources\Common\Utils.VerInfo.pas',
  VirtualTrees.ExportHelper in 'Sources\Virtual TreeView\VirtualTrees.ExportHelper.pas',
  VirtualTrees.Helper in 'Sources\Virtual TreeView\VirtualTrees.Helper.pas',
  XmlFiles in 'Sources\Common\XmlFiles.pas';

{$R *.res}

begin
  // ReportMemoryLeaksOnShutdown := {$IFDEF DEBUG} True {$ELSE} False {$ENDIF DEBUG};
  PDFiumDllDir := ExtractFilePath(ParamStr(0)) + {$IFDEF CPUX64}'x64' {$ELSE} 'x86' {$ENDIF CPUX64};
  IsMultiThread := True;
  try
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    try
      {$IFDEF RELEASE}
      TfrmSplashScreen.ShowSplashScreen;
      {$ENDIF}
      Application.CreateForm(TDMImage, DMImage);
  Application.CreateForm(TfrmSettings, frmSettings);
  frmSettings.Initialize;
    finally
      TfrmSplashScreen.HideSplashScreen;
    end;
    Application.ShowMainForm := True;
    Application.Run;
//    frmSettings.Deinitialize;
  except
    on E: Exception do
    begin
      TfrmSplashScreen.HideSplashScreen;
      if Assigned(LogWriter) then
        LogWriter.Write(ddError, E.Message);
    end;
  end;

end.
