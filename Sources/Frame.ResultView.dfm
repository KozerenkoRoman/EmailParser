inherited frameResultView: TframeResultView
  Width = 681
  Height = 504
  ExplicitWidth = 681
  ExplicitHeight = 504
  object splInfo: TSplitter [0]
    Left = 0
    Top = 317
    Width = 681
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = -277
    ExplicitTop = 491
    ExplicitWidth = 1100
  end
  inherited vstTree: TVirtualStringTree
    Width = 681
    Height = 273
    Colors.GridLineColor = cl3DLight
    DefaultNodeHeight = 20
    Header.Height = 25
    Header.MainColumn = 2
    Images = DMImage.vil16
    ParentShowHint = True
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDrawText = vstTreeDrawText
    OnGetText = vstTreeGetText
    OnInitNode = vstTreeInitNode
    ExplicitWidth = 681
    ExplicitHeight = 273
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'File Name'
        Width = 166
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Message ID'
        Width = 446
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Date'
        Width = 120
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Subject'
        Width = 72
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Attach'
        Width = 75
      end>
  end
  inherited tbMain: TToolBar
    Width = 675
    ExplicitWidth = 675
    object btnSearch: TToolButton
      Left = 328
      Top = 0
      Action = aSearch
    end
    object btnOpenEmail: TToolButton
      Left = 367
      Top = 0
      Action = aOpenEmail
    end
    object btnOpenLogFile: TToolButton
      Left = 406
      Top = 0
      Action = aOpenLogFile
    end
  end
  object gbInfo: TGroupBox [3]
    AlignWithMargins = True
    Left = 3
    Top = 330
    Width = 675
    Height = 130
    Margins.Top = 8
    Align = alBottom
    Caption = 'Info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    object memInfo: TMemo
      Left = 2
      Top = 18
      Width = 671
      Height = 110
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object pnlBottom: TPanel [4]
    Left = 0
    Top = 463
    Width = 681
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    DesignSize = (
      681
      41)
    object gProgress: TGauge
      Left = 7
      Top = 9
      Width = 553
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      BorderStyle = bsNone
      Color = clBtnFace
      ForeColor = 1986047
      MaxValue = 2
      ParentColor = False
      Progress = 0
      ShowText = False
      Visible = False
    end
    object btnBreak: TBitBtn
      Left = 566
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
    object aOpenLogFile: TAction
      Hint = 'Open Log File'
      ImageIndex = 70
      ImageName = 'file_extension_log'
      OnExecute = aOpenLogFileExecute
    end
    object aSearch: TAction
      ImageIndex = 21
      ImageName = 'Zoom_32x32'
      OnExecute = aSearchExecute
    end
    object aOpenEmail: TAction
      Hint = 'Open Email'
      ImageIndex = 75
      ImageName = 'email_open'
      OnExecute = aOpenEmailExecute
    end
  end
end
