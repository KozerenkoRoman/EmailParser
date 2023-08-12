object InformationDialog: TInformationDialog
  Left = 0
  Top = 0
  ClientHeight = 480
  ClientWidth = 486
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 13
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 486
    Height = 480
    Align = alClient
    TabOrder = 0
    object wbMessage: TWebBrowser
      Left = 1
      Top = 1
      Width = 484
      Height = 436
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      ParentCustomHint = False
      Align = alClient
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      OnBeforeNavigate2 = wbMessageBeforeNavigate2
      ExplicitHeight = 439
      ControlData = {
        4C00000006320000102D00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126209000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
    object pnlBottom: TPanel
      Left = 1
      Top = 437
      Width = 484
      Height = 42
      Align = alBottom
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        484
        42)
      object btnSave: TBitBtn
        Left = 261
        Top = 1
        Width = 110
        Height = 40
        Margins.Bottom = 0
        Action = aSave
        Anchors = [akTop, akRight]
        Caption = 'Save'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Images = DMImage.vil32
        ParentFont = False
        TabOrder = 0
      end
      object btnOk: TBitBtn
        Left = 374
        Top = 1
        Width = 110
        Height = 40
        Action = aOk
        Anchors = [akTop, akRight]
        Caption = 'Ok'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Images = DMImage.vil32
        ParentFont = False
        TabOrder = 1
      end
    end
  end
  object ActionList: TActionList
    Images = DMImage.vil32
    Left = 168
    Top = 160
    object aOk: TAction
      Caption = 'Ok'
      ImageIndex = 46
      ImageName = 'tick'
      ShortCut = 27
      OnExecute = aOkExecute
    end
    object aSave: TAction
      Caption = 'Save'
      ImageIndex = 10
      ImageName = 'Save_32x32'
      OnExecute = aSaveExecute
    end
  end
  object SaveTextFileDialog: TSaveTextFileDialog
    DefaultExt = '*.html'
    FileName = 'InformationDialog.html'
    Filter = '*.html'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 168
    Top = 104
  end
end
