inherited framePathes: TframePathes
  Width = 848
  Height = 436
  inherited vstTree: TVirtualStringTree
    Colors.GridLineColor = cl3DLight
    Header.MainColumn = 0
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toFullRowDrag, toEditOnClick, toEditOnDblClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnChecked = vstTreeChecked
    OnClick = vstTreeClick
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnEditing = vstTreeEditing
    OnGetText = vstTreeGetText
    OnGetImageIndex = vstTreeGetImageIndex
    OnNewText = vstTreeNewText
    Columns = <
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Path'
        Width = 450
      end
      item
        Position = 2
        Width = 71
      end
      item
        Alignment = taCenter
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'With subdir'
        Width = 84
      end
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Info'
        Width = 120
      end>
  end
  inherited tbMain: TToolBar
  end
  inherited alFrame: TActionList
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    inherited aAdd: TAction
      OnExecute = aAddExecute
    end
    inherited aDelete: TAction
      OnExecute = aDeleteExecute
      OnUpdate = aDeleteUpdate
    end
    inherited aEdit: TAction
      OnExecute = aEditExecute
      OnUpdate = aEditUpdate
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
    end
  end
  object OpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoPathMustExist]
    Left = 264
    Top = 160
  end
end
