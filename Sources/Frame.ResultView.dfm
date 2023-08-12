inherited frameResultView: TframeResultView
  Width = 1009
  Height = 606
  ExplicitWidth = 1009
  ExplicitHeight = 606
  PixelsPerInch = 144
  object splInfo: TSplitter [0]
    Left = 0
    Top = 560
    Width = 1009
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = -277
    ExplicitTop = 491
    ExplicitWidth = 1100
  end
  inherited vstTree: TVirtualStringTree
    Width = 1009
    Height = 314
    Colors.GridLineColor = cl3DLight
    DefaultNodeHeight = 20
    Header.Height = 25
    Header.MainColumn = 2
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenEmailExecute
    OnFocusChanged = vstTreeFocusChanged
    OnGetText = vstTreeGetText
    ExplicitTop = 46
    ExplicitWidth = 1009
    ExplicitHeight = 314
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = '#'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'File Name'
        Width = 107
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Path'
        Width = 280
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Message ID'
        Width = 172
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Date'
        Width = 120
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 5
        Text = 'Subject'
        Width = 72
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 6
        Text = 'Attach'
        Width = 75
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 7
        Text = 'Body'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 8
        Text = 'From'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 9
        Text = 'Content Type'
      end>
  end
  inherited tbMain: TToolBar
    Width = 1003
    ExplicitWidth = 1003
    object btnSearch: TToolButton
      Left = 390
      Top = 0
      Action = aSearch
    end
    object btnOpenEmail: TToolButton
      Left = 430
      Top = 0
      Action = aOpenEmail
    end
    object btnOpenLogFile: TToolButton
      Left = 470
      Top = 0
      Action = aOpenLogFile
    end
    object ToolButton1: TToolButton
      Left = 510
      Top = 0
      Caption = 'ToolButton1'
      ImageIndex = 71
      ImageName = 'email'
    end
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 565
    Width = 1009
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    DesignSize = (
      1009
      41)
    object gProgress: TGauge
      Left = 7
      Top = 9
      Width = 881
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      ForeColor = 1986047
      MaxValue = 2
      ParentColor = False
      Progress = 0
      ShowText = False
      ExplicitWidth = 553
    end
    object btnBreak: TBitBtn
      Left = 894
      Top = 1
      Width = 110
      Height = 40
      Anchors = [akTop, akRight]
      Caption = 'Break'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Images = DMImage.vil32
      ParentFont = False
      TabOrder = 0
    end
  end
  object pcInfo: TPageControl [4]
    Left = 0
    Top = 360
    Width = 1009
    Height = 200
    ActivePage = tsHtmlText
    Align = alBottom
    TabOrder = 3
    OnChange = pcInfoChange
    object tsPlainText: TTabSheet
      Caption = 'Plain Text'
      object memTextPlain: TMemo
        Left = 0
        Top = 0
        Width = 1001
        Height = 170
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsHtmlText: TTabSheet
      Caption = 'HTML'
      ImageIndex = 1
      object wbBody: TWebBrowser
        Left = 0
        Top = 0
        Width = 1001
        Height = 170
        Align = alClient
        TabOrder = 0
        OnBeforeNavigate2 = wbBodyBeforeNavigate2
        ExplicitHeight = 190
        ControlData = {
          4C00000075670000921100000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object tsAttachments: TTabSheet
      Caption = 'Attachments'
      ImageIndex = 2
    end
  end
  inherited alFrame: TActionList
    inherited aRefresh: TAction
      Visible = False
    end
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aEdit: TAction
      Visible = False
    end
    inherited aSave: TAction
      Visible = False
    end
    object aOpenLogFile: TAction [10]
      Hint = 'Open Log File'
      ImageIndex = 70
      ImageName = 'file_extension_log'
      OnExecute = aOpenLogFileExecute
    end
    object aSearch: TAction [11]
      ImageIndex = 21
      ImageName = 'Zoom_32x32'
      OnExecute = aSearchExecute
    end
    object aOpenEmail: TAction [12]
      Hint = 'Open Email'
      ImageIndex = 75
      ImageName = 'email_open'
      OnExecute = aOpenEmailExecute
      OnUpdate = aOpenEmailUpdate
    end
  end
end
