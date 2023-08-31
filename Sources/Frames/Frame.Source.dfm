inherited frameSource: TframeSource
  Width = 551
  Height = 399
  ExplicitWidth = 551
  ExplicitHeight = 399
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
      ImageIndex = 16
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
    Height = 360
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    CustomCheckImages = DMImage.ilCustomCheckImages
    DefaultNodeHeight = 17
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
    PopupMenu = pmFrame
    TabOrder = 1
    TextMargin = 3
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    TreeOptions.SelectionOptions = [toExtendedFocus, toAlwaysSelectNode]
    OnColumnResize = vstTreeColumnResize
    OnFreeNode = vstTreeFreeNode
    OnHeaderDragged = vstTreeHeaderDragged
    OnMeasureItem = vstTreeMeasureItem
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <>
  end
  inherited alFrame: TActionList
    Left = 104
    Top = 168
    object aExportToExcel: TAction
      Hint = 'Export To Excel'
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      OnExecute = aExportToExcelExecute
    end
    object aExportToCSV: TAction
      Hint = 'Export to CSV'
      ImageIndex = 17
      ImageName = 'ExportToCSV_32x32'
      OnExecute = aExportToCSVExecute
    end
    object aPrint: TAction
      Hint = 'Print'
      ImageIndex = 15
      ImageName = 'Print_32x32'
      OnExecute = aPrintExecute
    end
    object aColumnSettings: TAction
      Hint = 'Column Settings'
      ImageIndex = 63
      ImageName = 'PageSetup_32x32'
      OnExecute = aColumnSettingsExecute
    end
  end
end
