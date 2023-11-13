inherited frameSorter: TframeSorter
  Width = 656
  Height = 309
  ExplicitWidth = 656
  ExplicitHeight = 309
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 656
    ExplicitWidth = 656
  end
  inherited vstTree: TVirtualStringTree
    Width = 656
    Height = 250
    Header.MainColumn = 0
    Images = DMImage.vil16
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnEditing = vstTreeEditing
    OnGetImageIndex = vstTreeGetImageIndex
    OnNewText = vstTreeNewText
    OnNodeClick = vstTreeNodeClick
    ExplicitWidth = 656
    ExplicitHeight = 250
    Columns = <
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Mask of files'
        Width = 182
      end
      item
        BiDiMode = bdLeftToRight
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Path'
        Width = 182
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 100
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Info'
        Width = 100
      end>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    inherited aAdd: TAction
      OnExecute = aAddExecute
    end
    inherited aEdit: TAction
      OnExecute = aEditExecute
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
  end
  object OpenDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoPathMustExist]
    Left = 192
    Top = 96
  end
end
