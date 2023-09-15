program EmailParser;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
// {$DEFINE DETAILED_LOG}
{$R 'Logo.res' 'Resources\Logo.rc'}

uses
  Vcl.Forms,
  System.SysUtils,
  ArrayHelper in 'Sources\Common\ArrayHelper.pas',
  Column.Settings in 'Sources\Column.Settings.pas' {frmColumnSettings},
  Column.Types in 'Sources\Common\Column.Types.pas',
  Common.Types in 'Sources\Common\Common.Types.pas',
  CommonForms in 'Sources\CommonForms.pas' {CommonForm},
  DaImages in 'Sources\DataModules\DaImages.pas' {DMImage: TDataModule},
  DaModule in 'Sources\DataModules\DaModule.pas' {DaMod: TDataModule},
  DaModule.Resources in 'Sources\DataModules\DaModule.Resources.pas',
  DebugWriter in 'Sources\Common\DebugWriter.pas',
  dEXIF.Helper in 'Sources\dEXIF\dEXIF.Helper.pas',
  ExecConsoleProgram in 'Sources\Common\ExecConsoleProgram.pas',
  Files.Utils in 'Sources\Common\Files.Utils.pas',
  FireDAC.Phys.SQLiteIniFile in 'Sources\DataModules\FireDAC.Phys.SQLiteIniFile.pas',
  Frame.AllAttachments in 'Sources\Frames\Frame.AllAttachments.pas' {frameAllAttachments: TFrame},
  Frame.Attachments in 'Sources\Frames\Frame.Attachments.pas' {frameAttachments: TFrame},
  Frame.Custom in 'Sources\Frames\Frame.Custom.pas' {FrameCustom: TFrame},
  Frame.DuplicateFiles in 'Sources\Frames\Frame.DuplicateFiles.pas' {frameDuplicateFiles: TFrame},
  Frame.Emails in 'Sources\Frames\Frame.Emails.pas' {frameEmails: TFrame},
  Frame.Pathes in 'Sources\Frames\Frame.Pathes.pas' {framePathes: TFrame},
  Frame.RegExp in 'Sources\Frames\Frame.RegExp.pas' {frameRegExp: TFrame},
  Frame.ResultView in 'Sources\Frames\Frame.ResultView.pas' {frameResultView: TFrame},
  Frame.Settings in 'Sources\Frames\Frame.Settings.pas' {frameSettings: TFrame},
  Frame.Sorter in 'Sources\Frames\Frame.Sorter.pas' {frameSorter: TFrame},
  Frame.Source in 'Sources\Frames\Frame.Source.pas' {frameSource: TFrame},
  Global.Resources in 'Sources\Global.Resources.pas',
  Global.Types in 'Sources\Global.Types.pas',
  Global.Utils in 'Sources\Common\Global.Utils.pas',
  Html.Consts in 'Sources\Common\Html.Consts.pas',
  Html.Lib in 'Sources\Common\Html.Lib.pas',
  InformationDialog in 'Sources\Common\InformationDialog.pas' {TInformationDialog},
  MailMessage.Helper in 'Sources\CleverInternetSuite\MailMessage.Helper.pas',
  MainForm in 'Sources\MainForm.pas' {frmMain},
  MessageDialog in 'Sources\Common\MessageDialog.pas',
  PdfiumCore in 'Sources\PDFiumLib\PdfiumCore.pas',
  PdfiumCtrl in 'Sources\PDFiumLib\PdfiumCtrl.pas',
  PdfiumLib in 'Sources\PDFiumLib\PdfiumLib.pas',
  Performer in 'Sources\Performer.pas',
  Publishers in 'Sources\Publishers.pas',
  Publishers.Interfaces in 'Sources\Publishers.Interfaces.pas',
  RegExp.Editor in 'Sources\RegExp.Editor.pas' {frmRegExpEditor},
  RegExp.Import in 'Sources\RegExp.Import.pas' {frmImportFromXML},
  RegExp.Types in 'Sources\Common\RegExp.Types.pas',
  RegExp.Utils in 'Sources\RegExp.Utils.pas',
  SplashScreen in 'Sources\SplashScreen.pas' {frmSplashScreen},
  SplashScreen.Resources in 'Sources\SplashScreen.Resources.pas',
  Thread.Emails in 'Sources\DataModules\Thread.Emails.pas',
  Translate.Lang in 'Sources\Translate\Translate.Lang.pas',
  Translate.Resources in 'Sources\Translate\Translate.Resources.pas',
  UHtmlParse in 'Sources\HTMLParse\UHtmlParse.pas',
  Utils in 'Sources\Common\Utils.pas',
  Utils.Exceptions in 'Sources\Common\Utils.Exceptions.pas',
  Utils.LocalInformation in 'Sources\Common\Utils.LocalInformation.pas',
  Utils.VerInfo in 'Sources\Common\Utils.VerInfo.pas',
  Utils.Zip in 'Sources\Common\Utils.Zip.pas',
  VirtualTrees.ExportHelper in 'Sources\Virtual TreeView\VirtualTrees.ExportHelper.pas',
  VirtualTrees.Helper in 'Sources\Virtual TreeView\VirtualTrees.Helper.pas',
  XmlFiles in 'Sources\Common\XmlFiles.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := {$IFDEF DETAILED_LOG} True {$ELSE} False {$ENDIF DETAILED_LOG};
  PDFiumDllDir := ExtractFilePath(ParamStr(0)) + {$IFDEF CPUX64} '' {$ELSE} '' {$ENDIF CPUX64};
  IsMultiThread := True;
  try
    Application.Initialize;
    Application.Title := 'Email Parser';
    try
{$IFDEF RELEASE}
      TfrmSplashScreen.ShowSplashScreen;
{$ENDIF}
      Application.CreateForm(TDMImage, DMImage);
  Application.CreateForm(TDaMod, DaMod);
  Application.CreateForm(TfrmMain, frmMain);
  frmMain.Initialize;
    finally
      TfrmSplashScreen.HideSplashScreen;
    end;
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
