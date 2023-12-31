inherited frameRegExp: TframeRegExp
  Width = 749
  Height = 444
  ExplicitWidth = 749
  ExplicitHeight = 444
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Top = 41
    Width = 749
    Height = 41
    TabOrder = 2
    ExplicitTop = 41
    ExplicitWidth = 749
    ExplicitHeight = 41
    inherited btnSave: TToolButton
      Action = nil
      Visible = False
      OnClick = aSaveExecute
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
  end
  inherited vstTree: TVirtualStringTree
    Top = 82
    Width = 749
    Height = 362
    Alignment = taRightJustify
    Header.MainColumn = 3
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnChecked = vstTreeChecked
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnDblClick = aEditExecute
    OnEditing = vstTreeEditing
    OnNewText = vstTreeNewText
    ExplicitTop = 82
    ExplicitWidth = 749
    ExplicitHeight = 362
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Name'
        Width = 150
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'RegExp Template'
        Width = 300
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Group index'
        Width = 100
      end
      item
        Alignment = taCenter
        CaptionAlignment = taCenter
        Layout = blGlyphBottom
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'Use Raw Text'
        Width = 103
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Type Pattern'
        Width = 200
      end>
    DefaultText = ''
  end
  object tbSettings: TToolBar [2]
    Left = 0
    Top = 0
    Width = 749
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
      Width = 336
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblSetOfTemplates: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 1
        Width = 108
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Set of templates'
        Transparent = False
        Layout = tlCenter
      end
      object cbSetOfTemplates: TComboBox
        AlignWithMargins = True
        Left = 117
        Top = 8
        Width = 213
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbSetOfTemplatesChange
      end
    end
    object btnSave02: TToolButton
      Left = 336
      Top = 0
      Action = aSave
    end
    object btnSaveSetAs: TToolButton
      Left = 375
      Top = 0
      Action = aSaveAs
    end
    object btnDeleteSet: TToolButton
      Left = 414
      Top = 0
      Action = aDeleteSet
    end
    object btnSep05: TToolButton
      Left = 453
      Top = 0
      Width = 8
      Caption = 'btnSep05'
      ImageIndex = 61
      ImageName = 'sql'
      Style = tbsSeparator
    end
    object btnImportFromXML: TToolButton
      Left = 461
      Top = 0
      Action = aImportFromXML
    end
  end
  inherited alFrame: TActionList
    Left = 96
    inherited aAdd: TAction
      OnExecute = aAddExecute
      OnUpdate = aAddUpdate
    end
    inherited aRefresh: TAction [1]
      OnExecute = aRefreshExecute
    end
    inherited aEdit: TAction [2]
      Visible = True
      OnExecute = aEditExecute
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
      OnUpdate = aSaveUpdate
    end
    object aSaveAs: TAction [8]
      Caption = 'Save temlate set as...'
      ImageIndex = 24
      ImageName = 'SaveAll_32x32'
      OnExecute = aSaveAsExecute
    end
    inherited aExpandAll: TAction
      Visible = False
    end
    inherited aCollapseAll: TAction
      Visible = False
    end
    object aDeleteSet: TAction
      ImageIndex = 62
      ImageName = 'DeleteList2_32x32'
      OnExecute = aDeleteSetExecute
    end
    object aImportFromXML: TAction
      ImageIndex = 59
      ImageName = 'ImportXML'
      OnExecute = aImportFromXMLExecute
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
  end
end
