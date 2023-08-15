inherited frameResultView: TframeResultView
  Width = 671
  Height = 516
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  object splInfo: TSplitter [0]
    Left = 0
    Top = 212
    Width = 671
    Height = 4
    Cursor = crVSplit
    Align = alBottom
  end
  inherited vstTree: TVirtualStringTree
    Header.MainColumn = 0
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenEmailExecute
    OnFocusChanged = vstTreeFocusChanged
    OnGetText = vstTreeGetText
    Columns = <
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 7
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = '#'
        Width = 33
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'File Name'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Path'
        Width = 187
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Message ID'
        Width = 115
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
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
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 6
        Text = 'Attach'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 7
        Text = 'Body'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 8
        Text = 'From'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 9
        Text = 'Content Type'
        Width = 100
      end>
  end
  inherited tbMain: TToolBar
    Left = 0
    Top = 0
    Width = 671
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
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
  end
  object pnlBottom: TPanel [3]
    Left = 0
    Top = 496
    Width = 671
    Height = 20
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object gProgress: TGauge
      Left = 0
      Top = 0
      Width = 671
      Height = 20
      Align = alClient
      BorderStyle = bsNone
      Color = clBtnFace
      ForeColor = 1986047
      MaxValue = 0
      ParentColor = False
      Progress = 0
      ShowText = False
    end
  end
  object pcInfo: TPageControl [4]
    Left = 0
    Top = 216
    Width = 671
    Height = 280
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    ActivePage = tsAttachments
    Align = alBottom
    TabOrder = 3
    OnChange = pcInfoChange
    object tsPlainText: TTabSheet
      Caption = 'Plain Text'
      object memTextPlain: TMemo
        Left = 0
        Top = 0
        Width = 663
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
        Width = 663
        Height = 250
        Align = alClient
        TabOrder = 0
        OnBeforeNavigate2 = wbBodyBeforeNavigate2
        ControlData = {
          4C00000086440000D71900000000000000000000000000000000000000000000
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
        Width = 663
        Height = 250
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 0
        inherited vstTree: TVirtualStringTree
        end
        inherited tbMain: TToolBar
          Width = 663
          ExplicitWidth = 663
          inherited btnAdd: TToolButton
          end
          inherited btnEdit: TToolButton
          end
          inherited btnDelete: TToolButton
           end
          inherited btnSave: TToolButton
  
          end
          inherited btnSep01: TToolButton
            Width = 15

          end
          inherited btnRefresh: TToolButton
            Left = 175

          end
          inherited btnSep02: TToolButton
            Left = 215
 
          end
          inherited btnExportToExcel: TToolButton
            Left = 230

          end
          inherited btnExportToCSV: TToolButton
            Left = 270
   
          end
          inherited btnPrint: TToolButton
            Left = 310
  
          end
          inherited btnSep03: TToolButton
            Left = 350
            Width = 5

          end
          inherited btnColumnSettings: TToolButton
            Left = 365

          end
          inherited btnOpenAttachFile: TToolButton
            Left = 405
    
          end
        end
        inherited alFrame: TActionList
          Left = 336
          Top = 96
        end
        inherited pmFrame: TPopupMenu
          Left = 392
          Top = 96
        end
      end
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
      OnUpdate = aOpenEmailUpdate
    end
  end
end
