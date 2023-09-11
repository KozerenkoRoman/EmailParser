inherited framePathes: TframePathes
  Width = 1067
  Height = 654
  ExplicitWidth = 1067
  ExplicitHeight = 654
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 1067
    ExplicitWidth = 1067
    inherited btnSep02: TToolButton [7]
      Left = 366
      ExplicitLeft = 366
    end
    inherited btnPrint: TToolButton [8]
      Left = 378
      ExplicitLeft = 378
    end
    inherited btnSep03: TToolButton [9]
      Left = 437
      ExplicitLeft = 437
    end
    inherited btnColumnSettings: TToolButton [10]
      Left = 449
      ExplicitLeft = 449
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 1067
    Height = 595
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
    ExplicitWidth = 1067
    ExplicitHeight = 595
    Columns = <
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 15
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Path'
        Width = 600
      end
      item
        MaxWidth = 1000
        MinWidth = 15
        Position = 1
        Width = 100
      end
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 15
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Info'
        Width = 180
      end
      item
        Alignment = taCenter
        CaptionAlignment = taCenter
        Layout = blGlyphBottom
        MaxWidth = 500
        MinWidth = 15
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'With subdir'
        Width = 100
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
