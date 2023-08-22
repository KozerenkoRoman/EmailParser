inherited frameRegExpParameters: TframeRegExpParameters
  Width = 753
  Height = 444
  ExplicitWidth = 753
  ExplicitHeight = 444
  inherited tbMain: TToolBar
    Top = 39
    Width = 753
    ExplicitTop = 39
    ExplicitWidth = 753
  end
  object tbSettings: TToolBar [1]
    Left = 0
    Top = 0
    Width = 753
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    TabOrder = 2
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 449
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object cbSetOfTemplates: TComboBox
        AlignWithMargins = True
        Left = 117
        Top = 8
        Width = 332
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnChange = cbSetOfTemplatesChange
      end
    end
    object btnSaveSet: TToolButton
      Left = 449
      Top = 0
      Caption = 'Save template set'
      DropdownMenu = pmFrame
      ImageIndex = 26
      ImageName = 'SaveAll_32x32'
      Style = tbsDropDown
      OnClick = aSaveSetExecute
    end
    object btnDeleteSet: TToolButton
      Left = 503
      Top = 0
      Action = aDeleteSet
    end
  end
  inherited vstTree: TVirtualStringTree
    Top = 78
    Width = 753
    Height = 366
    Alignment = taRightJustify
    DefaultNodeHeight = 18
    Header.MainColumn = 0
    OnCompareNodes = vstTreeCompareNodes
    OnCreateEditor = vstTreeCreateEditor
    OnDblClick = aEditExecute
    OnEditing = vstTreeEditing
    OnGetText = vstTreeGetText
    OnNewText = vstTreeNewText
    ExplicitTop = 78
    ExplicitWidth = 753
    ExplicitHeight = 366
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
      end>
  end
  inherited alFrame: TActionList
    Left = 96
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    inherited aAdd: TAction
      OnExecute = aAddExecute
      OnUpdate = aAddUpdate
    end
    inherited aEdit: TAction [5]
      Visible = True
      OnExecute = aEditExecute
      OnUpdate = aDeleteUpdate
    end
    inherited aDelete: TAction [6]
      OnExecute = aDeleteExecute
      OnUpdate = aDeleteUpdate
    end
    inherited aSave: TAction [7]
      OnExecute = aSaveExecute
    end
    inherited aColumnSettings: TAction [8]
    end
    object aSaveSet: TAction
      Caption = 'Save template set'
      ImageIndex = 10
      ImageName = 'Save_32x32'
      OnExecute = aSaveSetExecute
      OnUpdate = aSaveSetUpdate
    end
    object aSaveSetAs: TAction
      Caption = 'Save temlate set as...'
      OnExecute = aSaveSetAsExecute
    end
    object aDeleteSet: TAction
      ImageIndex = 65
      ImageName = 'DeleteList2_32x32'
      OnExecute = aDeleteSetExecute
      OnUpdate = aSaveSetUpdate
    end
  end
  inherited pmFrame: TPopupMenu
    object miSaveSet: TMenuItem
      Action = aSaveSet
      Default = True
    end
    object miSaveSetAs: TMenuItem
      Action = aSaveSetAs
    end
  end
end
