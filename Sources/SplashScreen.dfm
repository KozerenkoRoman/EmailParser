object frmSplashScreen: TfrmSplashScreen
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 450
  ClientWidth = 650
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  TextHeight = 13
  object imgLogo: TImage
    Left = 0
    Top = 0
    Width = 650
    Height = 450
  end
  object lblVersion: TLabel
    Left = 8
    Top = 355
    Width = 48
    Height = 16
    Caption = 'Version:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblInfo: TLabel
    Left = 8
    Top = 374
    Width = 27
    Height = 16
    Caption = 'Info:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblCitation: TLabel
    AlignWithMargins = True
    Left = 8
    Top = 393
    Width = 638
    Height = 52
    AutoSize = False
    Caption = 'Citation'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
end
