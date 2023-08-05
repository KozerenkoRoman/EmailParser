inherited frameLogView: TframeLogView
  Width = 823
  Height = 496
  ExplicitWidth = 823
  ExplicitHeight = 496
  inherited vstTree: TVirtualStringTree
    Width = 823
    Height = 452
    Colors.GridLineColor = cl3DLight
    DefaultNodeHeight = 20
    Header.Height = 25
    Header.MainColumn = 2
    Header.SortColumn = 2
    Images = DMImage.vil16
    ParentShowHint = True
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDrawText = vstTreeDrawText
    OnGetText = vstTreeGetText
    OnInitNode = vstTreeInitNode
    ExplicitWidth = 823
    ExplicitHeight = 452
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Operation'
        Width = 173
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Info'
        Width = 446
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Time'
        Width = 120
      end>
  end
  inherited tbMain: TToolBar
    Width = 817
    ExplicitWidth = 817
    object btnExecute: TToolButton
      Left = 328
      Top = 0
      Hint = 'Execute'
      ImageIndex = 12
      ImageName = 'lightning'
    end
    object btnOpenLogFile: TToolButton
      Left = 367
      Top = 0
      Action = aOpenLogFile
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
      ImageIndex = 5
      ImageName = 'Open_32x32'
      OnExecute = aOpenLogFileExecute
    end
  end
end
