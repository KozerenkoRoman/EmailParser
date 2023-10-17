inherited frameProject: TframeProject
  inherited tbMain: TToolBar
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 8
      Caption = 'btnSep04'
      ImageIndex = 76
      ImageName = 'toolbar_add'
      Style = tbsSeparator
    end
    object btnSetCurrent: TToolButton
      Left = 383
      Top = 0
      Action = aSetCurrent
    end
    object btnLoadProject: TToolButton
      Left = 422
      Top = 0
      Action = aLoadProject
    end
  end
  inherited vstTree: TVirtualStringTree
    Header.MainColumn = 0
    Images = DMImage.vil16
    Indent = 15
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnEditing = vstTreeEditing
    OnPaintText = vstTreePaintText
    OnGetImageIndex = vstTreeGetImageIndex
    OnNewText = vstTreeNewText
    Columns = <
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Name'
        Width = 214
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Info'
        Width = 241
      end
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Hash'
        Width = 182
      end>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    inherited aAdd: TAction
      OnExecute = aAddExecute
    end
    inherited aEdit: TAction
      OnUpdate = aDeleteUpdate
    end
    inherited aDelete: TAction
      OnExecute = aDeleteExecute
      OnUpdate = aDeleteUpdate
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
    end
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    inherited aExpandAll: TAction
      Visible = False
    end
    inherited aCollapseAll: TAction
      Visible = False
    end
    object aSetCurrent: TAction
      Hint = 'Set current'
      ImageIndex = 83
      ImageName = 'page_white_star'
      OnExecute = aSetCurrentExecute
    end
    object aLoadProject: TAction
      Hint = 'Load Project'
      ImageIndex = 43
      ImageName = 'database_lightning'
    end
  end
end
