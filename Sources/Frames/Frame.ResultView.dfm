inherited frameResultView: TframeResultView
  Width = 806
  Height = 629
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  ExplicitWidth = 806
  ExplicitHeight = 629
  PixelsPerInch = 144
  object splInfo: TSplitter [0]
    Left = 0
    Top = 345
    Width = 806
    Height = 4
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 212
    ExplicitWidth = 671
  end
  inherited tbMain: TToolBar
    Width = 806
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 806
    inherited btnSep01: TToolButton
      Visible = False
    end
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
    object btnSep05: TToolButton
      Left = 463
      Top = 0
      Width = 10
      ImageIndex = 71
      ImageName = 'email'
      Style = tbsSeparator
    end
    object btnOpenEmail: TToolButton
      Left = 473
      Top = 0
      Action = aOpenEmail
    end
    object btnOpenLogFile: TToolButton
      Left = 512
      Top = 0
      Action = aOpenLogFile
    end
  end
  object pcInfo: TPageControl [2]
    Left = 0
    Top = 349
    Width = 806
    Height = 280
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = tsPlainText
    Align = alBottom
    TabOrder = 2
    OnChange = pcInfoChange
    object tsPlainText: TTabSheet
      Caption = 'Plain Text'
      object memTextPlain: TMemo
        Left = 0
        Top = 0
        Width = 798
        Height = 250
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
        Width = 798
        Height = 250
        Align = alClient
        TabOrder = 0
        OnBeforeNavigate2 = wbBodyBeforeNavigate2
        ControlData = {
          4C0000007A520000D71900000000000000000000000000000000000000000000
          000000004C000000000000000000000001000000E0D057007335CF11AE690800
          2B2E126208000000000000004C0000000114020000000000C000000000000046
          8000000000000000000000000000000000000000000000000000000000000000
          00000000000000000100000000000000000000000000000000000000}
      end
    end
    object tsAttachments: TTabSheet
      Caption = 'Attachments'
      ImageIndex = 2
      inline frameAttachments: TframeAttachments
        Left = 0
        Top = 0
        Width = 798
        Height = 250
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 798
        ExplicitHeight = 250
        inherited tbMain: TToolBar
          Width = 798
          ExplicitWidth = 798
        end
        inherited vstTree: TVirtualStringTree
          Width = 798
          Height = 211
          ExplicitWidth = 798
          ExplicitHeight = 211
        end
        inherited alFrame: TActionList
          Left = 336
          Top = 96
        end
        inherited pmFrame: TPopupMenu
          Left = 392
          Top = 96
        end
        inherited SaveDialogAttachment: TSaveDialog
          Left = 216
          Top = 144
        end
      end
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 806
    Height = 306
    Header.MainColumn = 0
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenEmailExecute
    OnFocusChanged = vstTreeFocusChanged
    OnGetText = vstTreeGetText
    ExplicitTop = 39
    ExplicitWidth = 806
    ExplicitHeight = 306
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
    Left = 100
    Top = 100
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
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
  end
  inherited pmFrame: TPopupMenu
    Left = 172
  end
  object SaveDialogEmail: TSaveDialog
    DefaultExt = '*.eml'
    Filter = 'Email|*.eml|All files|*.*'
    Left = 96
    Top = 168
  end
end
