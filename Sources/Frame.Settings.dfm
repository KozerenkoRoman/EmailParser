inherited frameSettings: TframeSettings
  Width = 858
  Height = 555
  ExplicitWidth = 858
  ExplicitHeight = 555
  inherited vstTree: TVirtualStringTree
    Left = 792
    Top = 504
    Width = 23
    Height = 25
    Align = alNone
    Visible = False
    ExplicitLeft = 792
    ExplicitTop = 504
    ExplicitWidth = 23
    ExplicitHeight = 25
  end
  inherited tbMain: TToolBar
    Width = 852
  end
  object grdCommonParams: TGridPanel [2]
    Left = 0
    Top = 44
    Width = 858
    Height = 511
    Align = alClient
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 200.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblLanguage
        Row = 0
      end
      item
        Column = 0
        Control = lblExtensions
        Row = 1
      end
      item
        Column = 0
        Control = Label5
        Row = 2
      end
      item
        Column = 0
        Control = Label7
        Row = 3
      end
      item
        Column = 1
        Control = cbLanguage
        Row = 0
      end
      item
        Column = 1
        Control = edtExtensions
        Row = 1
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    RowCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end>
    TabOrder = 2
    ExplicitTop = -1
    ExplicitWidth = 786
    ExplicitHeight = 556
    object lblLanguage: TLabel
      AlignWithMargins = True
      Left = 141
      Top = 4
      Width = 57
      Height = 29
      Align = alRight
      Caption = 'Language'
      Layout = tlCenter
      ExplicitLeft = 244
      ExplicitTop = 1
      ExplicitHeight = 17
    end
    object lblExtensions: TLabel
      AlignWithMargins = True
      Left = 56
      Top = 39
      Width = 142
      Height = 29
      Align = alRight
      Caption = 'File extensions to search'
      Layout = tlCenter
      ExplicitLeft = 159
      ExplicitTop = 36
      ExplicitHeight = 17
    end
    object Label5: TLabel
      AlignWithMargins = True
      Left = 160
      Top = 74
      Width = 38
      Height = 29
      Align = alRight
      Caption = 'Label5'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 263
      ExplicitTop = 71
      ExplicitHeight = 17
    end
    object Label7: TLabel
      AlignWithMargins = True
      Left = 160
      Top = 109
      Width = 38
      Height = 29
      Align = alRight
      Caption = 'Label7'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 263
      ExplicitTop = 106
      ExplicitHeight = 17
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 211
      Top = 4
      Width = 145
      Height = 22
      Margins.Left = 10
      Align = alLeft
      Style = csOwnerDrawFixed
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtExtensions: TEdit
      AlignWithMargins = True
      Left = 211
      Top = 39
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 1
      Text = '*.eml'
      ExplicitLeft = 311
      ExplicitHeight = 25
    end
  end
  inherited alFrame: TActionList
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aEdit: TAction
      Visible = False
    end
  end
end
