inherited frameProject: TframeProject
  Width = 798
  Height = 470
  ExplicitWidth = 798
  ExplicitHeight = 470
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 798
    ExplicitWidth = 798
    inherited btnExportToExcel: TToolButton
      Left = 211
      ExplicitLeft = 211
    end
    inherited btnExportToCSV: TToolButton
      Left = 250
      ExplicitLeft = 250
    end
    inherited btnPrint: TToolButton
      Left = 289
      ExplicitLeft = 289
    end
    inherited btnSep03: TToolButton
      Left = 328
      ExplicitLeft = 328
    end
    inherited btnColumnSettings: TToolButton
      Left = 336
      ExplicitLeft = 336
    end
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
    Width = 798
    Height = 431
    Header.MainColumn = 0
    Images = DMImage.vil16
    Indent = 15
    PopupMenu = nil
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnDblClick = aEditExecute
    OnEditing = vstTreeEditing
    OnPaintText = vstTreePaintText
    OnGetImageIndexEx = vstTreeGetImageIndexEx
    OnNewText = vstTreeNewText
    OnNodeClick = vstTreeNodeClick
    ExplicitTop = 39
    ExplicitWidth = 798
    ExplicitHeight = 431
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
        Width = 175
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
        Width = 312
      end
      item
        MaxWidth = 100
        MinWidth = 50
        Position = 4
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 5
        Text = 'Use OCR'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 200
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 6
        Text = 'Language OCR'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 100
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 7
        Text = 'Delete attach'
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
      Visible = True
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
    Left = 260
    Top = 274
  end
end
