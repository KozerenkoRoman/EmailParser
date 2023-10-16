inherited frameSource: TframeSource
  Width = 551
  Height = 284
  OnEnter = FrameEnter
  ExplicitWidth = 551
  ExplicitHeight = 284
  inherited tbMain: TToolBar
    Width = 551
    ExplicitWidth = 551
    object btnExportToExcel: TToolButton
      Left = 211
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aExportToExcel
    end
    object btnExportToCSV: TToolButton
      Left = 250
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aExportToCSV
    end
    object btnPrint: TToolButton
      Left = 289
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aPrint
    end
    object btnSep03: TToolButton
      Left = 328
      Top = 0
      Width = 8
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'btnSep03'
      ImageIndex = 15
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnColumnSettings: TToolButton
      Left = 336
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aColumnSettings
    end
  end
  object vstTree: TVirtualStringTree [1]
    Left = 0
    Top = 39
    Width = 551
    Height = 245
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    CustomCheckImages = DMImage.ilCustomCheckImages
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Height = 17
    Header.MainColumn = -1
    Header.MaxHeight = 20
    Header.MinHeight = 17
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort]
    Images = DMImage.vilFileExt
    IncrementalSearch = isVisibleOnly
    Indent = 0
    LineStyle = lsSolid
    Margin = 2
    ParentFont = False
    PopupMenu = pmFrame
    TabOrder = 1
    TextMargin = 3
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    TreeOptions.SelectionOptions = [toExtendedFocus, toAlwaysSelectNode]
    OnColumnResize = vstTreeColumnResize
    OnFreeNode = vstTreeFreeNode
    OnGetText = vstTreeGetText
    OnHeaderDragged = vstTreeHeaderDragged
    OnMeasureItem = vstTreeMeasureItem
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    ExplicitTop = 47
    Columns = <>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    Left = 104
    Top = 168
    object aExportToExcel: TAction
      Hint = 'Export To Excel'
      ImageIndex = 15
      ImageName = 'ExportToXLS_32x32'
      OnExecute = aExportToExcelExecute
      OnUpdate = aExportToExcelUpdate
    end
    object aExportToCSV: TAction
      Hint = 'Export to CSV'
      ImageIndex = 16
      ImageName = 'ExportToCSV_32x32'
      OnExecute = aExportToCSVExecute
      OnUpdate = aExportToExcelUpdate
    end
    object aPrint: TAction
      Hint = 'Print'
      ImageIndex = 14
      ImageName = 'Print_32x32'
      OnExecute = aPrintExecute
      OnUpdate = aExportToExcelUpdate
    end
    object aColumnSettings: TAction
      Hint = 'Column Settings'
      ImageIndex = 75
      ImageName = 'check_box_list'
      OnExecute = aColumnSettingsExecute
    end
    object aExpandAll: TAction
      Caption = 'Expand all'
      ImageIndex = 65
      ImageName = 'ShowDetail_32x32'
      OnExecute = aExpandAllExecute
      OnUpdate = aExportToExcelUpdate
    end
    object aCollapseAll: TAction
      Caption = 'Collapse All'
      ImageIndex = 64
      ImageName = 'HideDetail_32x32'
      OnExecute = aCollapseAllExecute
      OnUpdate = aExportToExcelUpdate
    end
  end
  inherited pmFrame: TPopupMenu
    object miExpandAll: TMenuItem
      Action = aExpandAll
      ImageName = 'ShowDetail_16x16'
    end
    object miCollapseAll: TMenuItem
      Action = aCollapseAll
      ImageName = 'HideDetail_16x16'
    end
  end
end
