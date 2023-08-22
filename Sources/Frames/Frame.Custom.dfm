object FrameCustom: TFrameCustom
  Left = 0
  Top = 0
  Width = 587
  Height = 425
  TabOrder = 0
  object tbMain: TToolBar
    Left = 0
    Top = 0
    Width = 587
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = 3
    ExplicitWidth = 581
    object btnAdd: TToolButton
      Left = 0
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aAdd
    end
    object btnEdit: TToolButton
      Left = 39
      Top = 0
      Action = aEdit
    end
    object btnDelete: TToolButton
      Left = 78
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aDelete
    end
    object btnSave: TToolButton
      Left = 117
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aSave
    end
    object btnSep01: TToolButton
      Left = 156
      Top = 0
      Width = 8
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 164
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aRefresh
    end
    object btnSep02: TToolButton
      Left = 203
      Top = 0
      Width = 8
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ImageIndex = 33
      ImageName = 'Download_32x32'
      Style = tbsSeparator
    end
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
  object vstTree: TVirtualStringTree
    Left = 0
    Top = 39
    Width = 587
    Height = 386
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
    ExplicitTop = 45
    ExplicitHeight = 380
    Columns = <>
  end
  object alFrame: TActionList
    Images = DMImage.vil32
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
    object aRefresh: TAction
      Hint = 'Refresh'
      ImageIndex = 32
      ImageName = 'Refresh_32x32'
    end
    object aAdd: TAction
      Hint = 'Add'
      ImageIndex = 52
      ImageName = 'AddItem_32x32'
    end
    object aDelete: TAction
      Hint = 'Delete'
      ImageIndex = 0
      ImageName = 'DeleteList_32x32'
    end
    object aSave: TAction
      Hint = 'Save'
      ImageIndex = 10
      ImageName = 'Save_32x32'
    end
    object aColumnSettings: TAction
      Hint = 'Column Settings'
      ImageIndex = 63
      ImageName = 'PageSetup_32x32'
      OnExecute = aColumnSettingsExecute
    end
    object aEdit: TAction
      ImageIndex = 1
      ImageName = 'Edit_32x32'
      Visible = False
    end
  end
  object pmFrame: TPopupMenu
    Images = DMImage.vil16
    Left = 100
    Top = 100
  end
end
