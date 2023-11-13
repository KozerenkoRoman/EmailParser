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
      Width = 8
      Caption = 'btnSep04'
      ImageIndex = 68
      ImageName = 'email'
      Style = tbsSeparator
    end
    object btnSearch: TToolButton
      Left = 383
      Top = 0
      Action = aSearch
    end
    object btnBreak: TToolButton
      Left = 422
      Top = 0
      Action = aBreak
    end
    object btnFilter: TToolButton
      Left = 461
      Top = 0
      Action = aFilter
      Marked = True
      Style = tbsCheck
    end
    object btnSep05: TToolButton
      Left = 500
      Top = 0
      Width = 8
      ImageIndex = 68
      ImageName = 'email'
      Style = tbsSeparator
    end
    object btnOpenEmail: TToolButton
      Left = 508
      Top = 0
      Action = aOpenEmail
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 752
    Height = 307
    Header.MainColumn = 0
    Images = DMImage.vil16
    Indent = 15
    TreeOptions.AutoOptions = [toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnDblClick = aOpenEmailExecute
    OnEditing = vstTreeEditing
    OnFocusChanging = vstTreeFocusChanging
    OnPaintText = vstTreePaintText
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
    DefaultText = ''
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
    object aSearch: TAction [9]
      Hint = 'Start Search'
      ImageIndex = 11
      ImageName = 'lightning'
      OnExecute = aSearchExecute
      OnUpdate = aSearchUpdate
    end
    object aBreak: TAction [10]
      Hint = 'Break'
      ImageIndex = 12
      ImageName = 'lightning_delete'
      OnExecute = aBreakExecute
    end
    object aOpenEmail: TAction [11]
      Caption = 'Open Email'
      Hint = 'Open Email'
      ImageIndex = 68
      ImageName = 'email'
      OnExecute = aOpenEmailExecute
      OnUpdate = aOpenEmailUpdate
    end
    object aFilter: TAction [12]
      AutoCheck = True
      ImageIndex = 3
      ImageName = 'MasterFilter_32x32'
      OnExecute = aFilterExecute
      OnUpdate = aSearchUpdate
    end
    inherited aExpandAll: TAction
      OnUpdate = aExpandAllUpdate
    end
    inherited aCollapseAll: TAction
      OnUpdate = aExpandAllUpdate
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
    Left = 588
    Top = 116
    object miSep: TMenuItem
      Caption = '-'
    end
    object miOpenEmail: TMenuItem
      Action = aOpenEmail
    end
    object miOpenLocation: TMenuItem
      Action = aOpenLocation
    end
  end
  object SaveDialogEmail: TSaveDialog
    DefaultExt = '*.eml'
    Filter = 'Email|*.eml|All files|*.*'
    Left = 512
    Top = 184
  end
end
