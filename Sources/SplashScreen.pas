unit SplashScreen;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  XmlFiles, System.IOUtils, System.Threading, Utils.VerInfo;
{$ENDREGION}

type
  TfrmSplashScreen = class(TForm)
    imgLogo: TImage;
    lblVersion: TLabel;
    lblInfo: TLabel;
  public
    class procedure ShowSplashScreen;
    class procedure HideSplashScreen;
    class procedure HideSplash;
  end;

implementation

var
  frmSplashScreen: TfrmSplashScreen;

{$R *.dfm}

{ TfrmSplashScreen }

class procedure TfrmSplashScreen.ShowSplashScreen;
var
  pngLogo : TPngImage;
  RStream : TResourceStream;
begin
  frmSplashScreen := TfrmSplashScreen.Create(Application);
  RStream := TResourceStream.Create(HInstance, 'IMG_LOGO', RT_RCDATA);
  try
    pngLogo := TPngImage.Create;
    try
      pngLogo.LoadFromStream(RStream);
      frmSplashScreen.imgLogo.Picture.Graphic := pngLogo;
    finally
      pngLogo.Free;
    end;
  finally
    RStream.Free;
  end;

  frmSplashScreen.lblInfo.Font.Color    := clWebDarkSlateBlue;
  frmSplashScreen.lblVersion.Font.Color := clWebDarkSlateBlue;
  frmSplashScreen.lblVersion.Caption    := 'Ver: ' + TVersionInfo.GetAppVersion;
  frmSplashScreen.Show;
  frmSplashScreen.BringToFront;
  frmSplashScreen.Refresh;
end;

class procedure TfrmSplashScreen.HideSplash;
begin
  if Assigned(frmSplashScreen) then
  begin
    frmSplashScreen.Close;
    frmSplashScreen := nil;
  end;
end;

class procedure TfrmSplashScreen.HideSplashScreen;
begin
  if Assigned(frmSplashScreen) then
  begin
    TTask.Create(
      procedure()
      begin
        TThread.NameThreadForDebugging('TfrmSplashScreen.HideSplashScreen');
        // let splash screen live for some seconds if we want to add some status message..
        Sleep(1500);
        TThread.Synchronize(nil,
          procedure
          begin
            frmSplashScreen.Close;
            frmSplashScreen := nil;
            Application.MainForm.Repaint;
          end);
      end).Start;
  end;
end;

end.
