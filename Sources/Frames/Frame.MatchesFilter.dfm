inherited frameMatchesFilter: TframeMatchesFilter
  Width = 606
  Height = 265
  Align = alClient
  ExplicitWidth = 606
  ExplicitHeight = 265
  inherited tbMain: TToolBar
    Width = 606
    Height = 22
    ButtonHeight = 22
    ButtonWidth = 23
    Images = DMImage.vil16
    TabOrder = 1
    Transparent = False
    ExplicitWidth = 606
    ExplicitHeight = 22
    inherited btnAdd: TToolButton
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnEdit: TToolButton
      Left = 23
      ExplicitLeft = 23
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnDelete: TToolButton
      Left = 46
      ExplicitLeft = 46
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnSave: TToolButton
      Left = 69
      ExplicitLeft = 69
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnSep01: TToolButton
      Left = 92
      Visible = False
      ExplicitLeft = 92
      ExplicitHeight = 22
    end
    inherited btnRefresh: TToolButton
      Left = 100
      ExplicitLeft = 100
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnSep02: TToolButton
      Left = 123
      Visible = False
      ExplicitLeft = 123
      ExplicitHeight = 22
    end
    inherited btnExportToExcel: TToolButton
      Left = 131
      ExplicitLeft = 131
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnExportToCSV: TToolButton
      Left = 154
      ExplicitLeft = 154
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnPrint: TToolButton
      Left = 177
      ExplicitLeft = 177
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    inherited btnSep03: TToolButton
      Left = 200
      ExplicitLeft = 200
      ExplicitHeight = 22
    end
    inherited btnColumnSettings: TToolButton
      Left = 208
      ExplicitLeft = 208
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object btnAllUnCheck: TToolButton
      Left = 231
      Top = 0
      Action = aAllUnCheck
    end
    object btnAllCheck: TToolButton
      Left = 254
      Top = 0
      Action = aAllCheck
    end
    object btnFilterAND: TToolButton
      Left = 277
      Top = 0
      Action = aFilterAND
    end
    object btnFilterOR: TToolButton
      Left = 300
      Top = 0
      Action = aFilterOR
    end
  end
  inherited vstTree: TVirtualStringTree
    Top = 22
    Width = 606
    Height = 243
    Alignment = taRightJustify
    Header.MainColumn = 0
    Header.Options = [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible]
    PopupMenu = nil
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toFullVertGridLines, toUseBlendedSelection, toShowFilteredNodes]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnChecked = vstTreeChecked
    ExplicitTop = 22
    ExplicitWidth = 606
    ExplicitHeight = 243
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Name'
        Width = 602
      end>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    Left = 96
    Top = 64
    inherited aAdd: TAction
      Visible = False
    end
    inherited aRefresh: TAction [1]
      Visible = False
    end
    inherited aExportToExcel: TAction [2]
      Visible = False
    end
    inherited aEdit: TAction [3]
    end
    inherited aExportToCSV: TAction [4]
      Visible = False
    end
    inherited aDelete: TAction [5]
      Visible = False
    end
    inherited aPrint: TAction [6]
      Visible = False
    end
    inherited aSave: TAction [7]
      Visible = False
    end
    inherited aColumnSettings: TAction
      Visible = False
    end
    inherited aExpandAll: TAction
      Visible = False
    end
    inherited aCollapseAll: TAction
      Visible = False
    end
    object aFilterAND: TAction
      ImageIndex = 38
      ImageName = 'select_by_intersection'
      OnExecute = aFilterANDExecute
    end
    object aFilterOR: TAction
      ImageIndex = 35
      ImageName = 'select_by_adding_to_selection'
      OnExecute = aFilterORExecute
    end
    object aAllUnCheck: TAction
      ImageIndex = 81
      ImageName = 'check_box_uncheck2'
      OnExecute = aAllUnCheckExecute
    end
    object aAllCheck: TAction
      ImageIndex = 80
      ImageName = 'check_boxes2'
      OnExecute = aAllCheckExecute
    end
  end
  inherited pmFrame: TPopupMenu
    Images = DMImage.vil32
    Top = 124
  end
end
