inherited framePathes: TframePathes
  Width = 711
  Height = 436
  ExplicitWidth = 711
  ExplicitHeight = 436
  inherited tbMain: TToolBar
    Width = 711
    ExplicitWidth = 711
  end
  inherited vstTree: TVirtualStringTree
    Width = 711
    Height = 397
    Header.MainColumn = 3
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
    ExplicitWidth = 711
    ExplicitHeight = 397
    Columns = <
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Path'
        Width = 450
      end
      item
        Position = 1
        Width = 71
      end
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Info'
        Width = 120
      end
      item
        Alignment = taCenter
        CaptionAlignment = taCenter
        Layout = blGlyphBottom
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'With subdir'
        Width = 84
      end>
  end
  inherited alFrame: TActionList
    inherited aAdd: TAction
      OnExecute = aAddExecute
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
  end
  inherited pmFrame: TPopupMenu
    inherited miExpandAll: TMenuItem
      ImageName = 'ShowDetail_16x16'
    end
    inherited miCollapseAll: TMenuItem
      ImageName = 'HideDetail_16x16'
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
