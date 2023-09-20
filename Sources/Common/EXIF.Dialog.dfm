object EXIFDialog: TEXIFDialog
  Left = 0
  Top = 0
  ClientHeight = 477
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 435
    Width = 474
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 434
    ExplicitWidth = 470
    DesignSize = (
      474
      42)
    object btnSave: TBitBtn
      Left = 243
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
      ExplicitLeft = 239
    end
    object btnOk: TBitBtn
      Left = 356
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
      ExplicitLeft = 352
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 474
    Height = 435
    ActivePage = tsMain
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 470
    ExplicitHeight = 434
    object tsMain: TTabSheet
      Caption = 'Main'
      object ValueListEditor: TValueListEditor
        Left = 0
        Top = 0
        Width = 466
        Height = 407
        Align = alClient
        DoubleBuffered = True
        FixedCols = 1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
        ParentDoubleBuffered = False
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 462
        ExplicitHeight = 406
        ColWidths = (
          208
          252)
      end
    end
    object tsPhoto: TTabSheet
      Caption = 'Photo'
      ImageIndex = 2
      object Image: TImage
        Left = 0
        Top = 0
        Width = 466
        Height = 407
        Align = alClient
        Center = True
        Proportional = True
        ExplicitLeft = 64
        ExplicitTop = 72
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
    end
    object tsPlainText: TTabSheet
      Caption = 'Plain Text'
      ImageIndex = 1
      object wbMessage: TWebBrowser
        Left = 0
        Top = 0
        Width = 466
        Height = 407
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
        ControlData = {
          4C0000002A300000112A00000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E12620B000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
  end
  object ActionList: TActionList
    Images = DMImage.vil32
    Left = 168
    Top = 160
    object aOk: TAction
      Caption = 'Ok'
      ImageIndex = 44
      ImageName = 'tick'
      ShortCut = 27
      OnExecute = aOkExecute
    end
    object aSave: TAction
      Caption = 'Save'
      ImageIndex = 9
      ImageName = 'Save_32x32'
      OnExecute = aSaveExecute
    end
  end
  object SaveTextFileDialog: TSaveTextFileDialog
    DefaultExt = '*.html'
    Filter = 'HTML|*.html|All files|*.*'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Encodings.Strings = (
      'ANSI'
      'ASCII'
      'Unicode'
      'UTF-8'
      'UTF-7')
    Left = 168
    Top = 104
  end
end
