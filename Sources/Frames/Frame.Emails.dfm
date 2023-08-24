inherited frameEmails: TframeEmails
  Width = 752
  Height = 346
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  ExplicitWidth = 752
  ExplicitHeight = 346
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 752
    ExplicitWidth = 752
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 10
      Caption = 'btnSep04'
      ImageIndex = 71
      ImageName = 'email'
      Style = tbsSeparator
    end
    object btnSearch: TToolButton
      Left = 385
      Top = 0
      Action = aSearch
    end
    object btnBreak: TToolButton
      Left = 424
      Top = 0
      Action = aBreak
    end
    object btnFilter: TToolButton
      Left = 463
      Top = 0
      Action = aFilter
      Marked = True
      Style = tbsCheck
    end
    object btnSep05: TToolButton
      Left = 502
      Top = 0
      Width = 10
      ImageIndex = 71
      ImageName = 'email'
      Style = tbsSeparator
    end
    object btnOpenEmail: TToolButton
      Left = 512
      Top = 0
      Action = aOpenEmail
    end
    object btnOpenLogFile: TToolButton
      Left = 551
      Top = 0
      Action = aOpenLogFile
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 752
    Height = 307
    Header.MainColumn = 0
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenEmailExecute
    OnFocusChanged = vstTreeFocusChanged
    OnGetText = vstTreeGetText
    ExplicitWidth = 752
    ExplicitHeight = 307
    Columns = <
      item
        CaptionAlignment = taCenter
        MaxWidth = 200
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = '#'
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'File Name'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Path'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Message ID'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Date'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 5
        Text = 'Subject'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 6
        Text = 'Attach'
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 7
        Text = 'From'
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 8
        Text = 'Content Type'
      end>
  end
  inherited alFrame: TActionList
    Left = 508
    Top = 116
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
      OnUpdate = aOpenEmailUpdate
    end
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    object aOpenLogFile: TAction
      Hint = 'Open Log File'
      ImageIndex = 70
      ImageName = 'file_extension_log'
      OnExecute = aOpenLogFileExecute
    end
    object aSearch: TAction
      Hint = 'Start Search'
      ImageIndex = 12
      ImageName = 'lightning'
      OnExecute = aSearchExecute
      OnUpdate = aSearchUpdate
    end
    object aBreak: TAction
      Hint = 'Break'
      ImageIndex = 13
      ImageName = 'lightning_delete'
      OnExecute = aBreakExecute
    end
    object aOpenEmail: TAction
      Hint = 'Open Email'
      ImageIndex = 75
      ImageName = 'email_open'
      OnExecute = aOpenEmailExecute
      OnUpdate = aOpenEmailUpdate
    end
    object aFilter: TAction
      AutoCheck = True
      ImageIndex = 3
      ImageName = 'MasterFilter_32x32'
      OnExecute = aFilterExecute
      OnUpdate = aSearchUpdate
    end
  end
  inherited pmFrame: TPopupMenu
    Left = 588
    Top = 116
  end
  object SaveDialogEmail: TSaveDialog
    DefaultExt = '*.eml'
    Filter = 'Email|*.eml|All files|*.*'
    Left = 512
    Top = 184
  end
end
