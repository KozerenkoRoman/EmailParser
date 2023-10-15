inherited frameBruteForce: TframeBruteForce
  Width = 662
  Height = 400
  ExplicitWidth = 662
  ExplicitHeight = 400
  inherited tbMain: TToolBar
    Top = 41
    Width = 662
    Height = 41
    TabOrder = 2
    ExplicitTop = 41
    ExplicitWidth = 662
    ExplicitHeight = 41
    inherited btnSep02: TToolButton
      Visible = False
    end
    inherited btnSep03: TToolButton
      ImageIndex = 0
      ImageName = 'DeleteList_32x32'
    end
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 8
      ImageIndex = 28
      ImageName = 'Fill_32x32'
      Style = tbsSeparator
    end
    object btnDown: TToolButton
      Left = 383
      Top = 0
      Action = aDown
    end
    object btnUp: TToolButton
      Left = 422
      Top = 0
      Action = aUp
    end
    object btnSep05: TToolButton
      Left = 461
      Top = 0
      Width = 8
      ImageIndex = 32
      ImageName = 'AddFooter_32x32'
      Style = tbsSeparator
    end
    object btnStart: TToolButton
      Left = 469
      Top = 0
      Action = aStart
    end
    object btnStop: TToolButton
      Left = 508
      Top = 0
      Action = aStop
    end
  end
  inherited vstTree: TVirtualStringTree
    Top = 82
    Width = 662
    Height = 318
    Alignment = taRightJustify
    Header.MainColumn = 0
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible]
    Images = DMImage.vil16
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnEditing = vstTreeEditing
    OnGetText = vstTreeGetText
    OnPaintText = vstTreePaintText
    OnNewText = vstTreeNewText
    ExplicitTop = 82
    ExplicitWidth = 662
    ExplicitHeight = 318
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Short name'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'File name'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Password'
        Width = 257
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'Info'
        Width = 100
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Hash'
        Width = 250
      end>
    DefaultText = ''
  end
  object tbSettings: TToolBar [2]
    Left = 0
    Top = 0
    Width = 662
    Height = 41
    ButtonHeight = 39
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    TabOrder = 0
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 497
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblPasswordList: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 1
        Width = 108
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Password list'
        Transparent = False
        Layout = tlCenter
      end
      object edtFileName: TButtonedEdit
        Left = 117
        Top = 7
        Width = 377
        Height = 23
        Images = DMImage.vil16
        RightButton.ImageIndex = 5
        RightButton.ImageName = 'Open_32x32'
        RightButton.Visible = True
        TabOrder = 0
        OnRightButtonClick = edtFileNameRightButtonClick
      end
    end
  end
  inherited alFrame: TActionList
    Left = 96
    inherited aAdd: TAction
      OnExecute = aAddExecute
      OnUpdate = aAddUpdate
    end
    inherited aRefresh: TAction [1]
      Visible = False
    end
    inherited aEdit: TAction [2]
      OnUpdate = aDeleteUpdate
    end
    inherited aDelete: TAction [3]
      OnExecute = aDeleteExecute
      OnUpdate = aDeleteUpdate
    end
    inherited aExportToExcel: TAction [4]
    end
    inherited aExportToCSV: TAction [5]
    end
    inherited aPrint: TAction [6]
    end
    inherited aSave: TAction [7]
      OnExecute = aSaveExecute
    end
    inherited aExpandAll: TAction
      Visible = False
    end
    inherited aCollapseAll: TAction
      Visible = False
    end
    object aUp: TAction
      ImageIndex = 27
      ImageName = 'Up2_32x32'
      OnExecute = aUpExecute
      OnUpdate = aUpUpdate
    end
    object aDown: TAction
      ImageIndex = 28
      ImageName = 'Fill_32x32'
      OnExecute = aDownExecute
      OnUpdate = aDownUpdate
    end
    object aStart: TAction
      ImageIndex = 11
      ImageName = 'lightning'
      OnExecute = aStartExecute
    end
    object aStop: TAction
      ImageIndex = 12
      ImageName = 'lightning_delete'
      OnExecute = aStopExecute
    end
  end
  object OpenDialog: TFileOpenDialog
    DefaultExtension = '*.rar'
    FavoriteLinks = <>
    FileName = 'D:\Work\EmailParser\Sources\Frames'
    FileTypes = <
      item
        DisplayName = 'Rar files'
        FileMask = '*.rar'
      end
      item
        DisplayName = 'All files'
        FileMask = '*.*'
      end>
    Options = [fdoPathMustExist]
    Left = 96
    Top = 256
  end
end
