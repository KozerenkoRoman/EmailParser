inherited frameAttachments: TframeAttachments
  Width = 663
  Height = 374
  ExplicitWidth = 663
  ExplicitHeight = 374
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 663
    ExplicitWidth = 663
    inherited btnAdd: TToolButton
      Action = aOpenAttachFile
      Visible = False
    end
    inherited btnSep02: TToolButton
      Visible = False
    end
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 8
      Style = tbsSeparator
    end
    object btnOpenAttachFile: TToolButton
      Left = 383
      Top = 0
      Action = aOpenAttachFile
    end
    object btnOpenParsedText: TToolButton
      Left = 422
      Top = 0
      Action = aOpenParsedText
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 663
    Height = 335
    Header.MainColumn = 0
    Indent = 12
    TreeOptions.AutoOptions = [toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenParsedTextExecute
    OnPaintText = vstTreePaintText
    OnGetImageIndex = vstTreeGetImageIndex
    ExplicitWidth = 663
    ExplicitHeight = 335
    Columns = <
      item
        CaptionAlignment = taCenter
        MaxWidth = 100
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = '#'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'File Name'
        Width = 130
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Path'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Content Type'
        Width = 129
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Text'
        Width = 172
      end>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    inherited aRefresh: TAction
      Visible = False
    end
    object aOpenAttachFile: TAction [9]
      Caption = 'Open Attach File'
      Hint = 'Open Attach File'
      ImageIndex = 69
      ImageName = 'email_attach'
      OnExecute = aOpenAttachFileExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenParsedText: TAction [10]
      Caption = 'Open Parsed Text'
      Hint = 'Open Parsed Text'
      ImageIndex = 72
      ImageName = 'email_open'
      OnExecute = aOpenParsedTextExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenLocation: TAction
      Caption = 'Open Location'
      Hint = 'Open Location'
      ImageIndex = 5
      ImageName = 'Open_32x32'
      OnExecute = aOpenLocationExecute
    end
  end
  inherited pmFrame: TPopupMenu
    object miSep: TMenuItem
      Caption = '-'
    end
    object miOpenAttachFile: TMenuItem
      Action = aOpenAttachFile
    end
    object miOpenParsedText: TMenuItem
      Action = aOpenParsedText
    end
    object miOpenLocation: TMenuItem
      Action = aOpenLocation
    end
  end
  object SaveDialogAttachment: TSaveDialog
    Filter = 'All files|*.*'
    Left = 208
    Top = 104
  end
end
