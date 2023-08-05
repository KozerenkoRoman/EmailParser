object frameCustom: TframeCustom
  Left = 0
  Top = 0
  Width = 566
  Height = 377
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentFont = False
  ParentShowHint = False
  ShowHint = True
  TabOrder = 0
  object vstTree: TVirtualStringTree
    Left = 0
    Top = 44
    Width = 566
    Height = 333
    Align = alClient
    CustomCheckImages = DMImage.ilCustomCheckImages
    Header.AutoSizeIndex = -1
    Header.Height = 18
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort]
    LineStyle = lsSolid
    ParentShowHint = False
    PopupMenu = pmFrame
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    TreeOptions.SelectionOptions = [toExtendedFocus, toAlwaysSelectNode]
    OnColumnResize = vstTreeColumnResize
    OnFreeNode = vstTreeFreeNode
    OnHeaderDragged = vstTreeHeaderDragged
    OnMeasureItem = vstTreeMeasureItem
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <>
  end
  object tbMain: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 560
    Height = 38
    AutoSize = True
    ButtonHeight = 38
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object btnAdd: TToolButton
      Left = 0
      Top = 0
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
      Action = aDelete
    end
    object btnSave: TToolButton
      Left = 117
      Top = 0
      Action = aSave
    end
    object btnSep01: TToolButton
      Left = 156
      Top = 0
      Width = 8
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 164
      Top = 0
      Action = aRefresh
    end
    object btnSep02: TToolButton
      Left = 203
      Top = 0
      Width = 8
      ImageIndex = 33
      ImageName = 'Download_32x32'
      Style = tbsSeparator
    end
    object btnExportToExcel: TToolButton
      Left = 211
      Top = 0
      Action = aExportToExcel
    end
    object btnExportToCSV: TToolButton
      Left = 250
      Top = 0
      Action = aExportToCSV
    end
    object btnPrint: TToolButton
      Left = 289
      Top = 0
      Action = aPrint
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
