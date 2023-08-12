object frameCustom: TframeCustom
  Left = 0
  Top = 0
  Width = 849
  Height = 566
  TabOrder = 0
  object vstTree: TVirtualStringTree
    Left = 0
    Top = 46
    Width = 849
    Height = 520
    Align = alClient
    CustomCheckImages = DMImage.ilCustomCheckImages
    DefaultNodeHeight = 27
    Header.AutoSizeIndex = -1
    Header.Height = 20
    Header.MainColumn = -1
    Header.MaxHeight = 15000
    Header.MinHeight = 20
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort]
    IncrementalSearch = isVisibleOnly
    Indent = 0
    LineStyle = lsSolid
    Margin = 6
    PopupMenu = pmFrame
    TabOrder = 0
    TextMargin = 6
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
    ExplicitTop = 38
    ExplicitHeight = 528
    Columns = <>
  end
  object tbMain: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 843
    Height = 40
    ButtonHeight = 40
    ButtonWidth = 40
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object btnAdd: TToolButton
      Left = 0
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aAdd
    end
    object btnEdit: TToolButton
      Left = 40
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aEdit
    end
    object btnDelete: TToolButton
      Left = 80
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aDelete
    end
    object btnSave: TToolButton
      Left = 120
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aSave
    end
    object btnSep01: TToolButton
      Left = 160
      Top = 0
      Width = 10
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 170
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aRefresh
    end
    object btnSep02: TToolButton
      Left = 210
      Top = 0
      Width = 10
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      ImageIndex = 33
      ImageName = 'Download_32x32'
      Style = tbsSeparator
    end
    object btnExportToExcel: TToolButton
      Left = 220
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aExportToExcel
    end
    object btnExportToCSV: TToolButton
      Left = 260
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aExportToCSV
    end
    object btnPrint: TToolButton
      Left = 300
      Top = 0
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Action = aPrint
    end
    object btnSep03: TToolButton
      Left = 340
      Top = 0
      Width = 10
      Caption = 'btnSep03'
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnColumnSettings: TToolButton
      Left = 350
      Top = 0
      Action = aColumnSettings
    end
  end
  object alFrame: TActionList
    Images = DMImage.vil32
    Left = 328
    Top = 160
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
    object aExportToHTML: TAction
      Hint = 'Export To HTML'
      ImageIndex = 66
      ImageName = 'ExportToHTML_32x32'
      OnExecute = aExportToHTMLExecute
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
    object aEdit: TAction
      Hint = 'Edit'
      ImageIndex = 1
      ImageName = 'Edit_32x32'
    end
    object aSave: TAction
      Hint = 'Save'
      ImageIndex = 10
      ImageName = 'Save_32x32'
    end
    object aExpandAll: TAction
      Caption = 'Expand All'
      Hint = 'Expand All'
      ImageIndex = 68
      ImageName = 'ShowDetail_32x32'
      OnExecute = aExpandAllExecute
    end
    object aCollapseAll: TAction
      Caption = 'Collapse All'
      Hint = 'Collapse All'
      ImageIndex = 67
      ImageName = 'HideDetail_32x32'
      OnExecute = aCollapseAllExecute
    end
    object aColumnSettings: TAction
      Hint = 'Column Settings'
      ImageIndex = 63
      ImageName = 'PageSetup_32x32'
      OnExecute = aColumnSettingsExecute
    end
  end
  object pmFrame: TPopupMenu
    Images = DMImage.vil16
    Left = 328
    Top = 208
    object miAdd: TMenuItem
      Action = aAdd
      Caption = 'Add'
    end
    object miEdit: TMenuItem
      Action = aEdit
      Caption = 'Edit'
    end
    object miDelete: TMenuItem
      Action = aDelete
      Caption = 'Delete'
    end
    object miSep01: TMenuItem
      Caption = '-'
    end
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
