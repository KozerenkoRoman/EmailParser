inherited frameProject: TframeProject
  Width = 1217
  Height = 552
  ExplicitWidth = 1217
  ExplicitHeight = 552
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 1217
    ExplicitWidth = 856
    object btnSep04: TToolButton
      Left = 563
      Top = 0
      Width = 8
      Caption = 'btnSep04'
      ImageIndex = 76
      ImageName = 'toolbar_add'
      Style = tbsSeparator
    end
    object btnSetCurrent: TToolButton
      Left = 571
      Top = 0
      Action = aSetCurrent
    end
    object btnLoadProject: TToolButton
      Left = 630
      Top = 0
      Action = aLoadProject
    end
  end
  inherited vstTree: TVirtualStringTree
    Width = 1217
    Height = 493
    Header.MainColumn = 3
    Images = DMImage.vil16
    Indent = 15
    PopupMenu = nil
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnEditing = vstTreeEditing
    OnPaintText = vstTreePaintText
    OnGetImageIndex = vstTreeGetImageIndex
    OnNewText = vstTreeNewText
    OnNodeClick = vstTreeNodeClick
    ExplicitWidth = 856
    ExplicitHeight = 354
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
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 200
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Path For Attachments'
        Width = 500
      end
      item
        MaxWidth = 100
        MinWidth = 50
        Position = 4
        Width = 100
      end>
    DefaultText = ''
  end
  inherited alFrame: TActionList
    Left = 96
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
      OnUpdate = aSetCurrentUpdate
    end
    object aLoadProject: TAction
      Hint = 'Load Project'
      ImageIndex = 43
      ImageName = 'database_lightning'
      OnExecute = aLoadProjectExecute
      OnUpdate = aLoadProjectUpdate
    end
    object aPathForAttachments: TAction
      Caption = 'Open'
      ImageIndex = 5
      ImageName = 'Open_32x32'
      OnExecute = aPathForAttachmentsExecute
    end
    object aAttachmentsSub: TAction
      Caption = '#Attachments (subdirectories)'
      OnExecute = aAttachmentsSubExecute
    end
    object aAttachmentsMain: TAction
      Caption = '#Attachments (main directory)'
      OnExecute = aAttachmentsMainExecute
    end
  end
  inherited pmFrame: TPopupMenu
    Left = 88
    Top = 260
    object miAttachmentsMain: TMenuItem
      Action = aAttachmentsMain
    end
    object miAttachmentsSub: TMenuItem
      Action = aAttachmentsSub
    end
    object miPathForAttachments: TMenuItem
      Action = aPathForAttachments
    end
  end
  object dlgAttachmments: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 516
    Top = 210
  end
end
