inherited frameSettings: TframeSettings
  Width = 646
  Height = 412
  ExplicitWidth = 646
  ExplicitHeight = 412
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 646
    ExplicitWidth = 909
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 39
    Width = 646
    Height = 373
    Margins.Top = 6
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 320.000000000000000000
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
        Row = 2
      end
      item
        Column = 1
        Control = cbLanguage
        Row = 0
      end
      item
        Column = 1
        Control = edtExtensions
        Row = 2
      end
      item
        Column = 0
        Control = ShapeDividingLine
        Row = 3
      end
      item
        Column = 0
        Control = lblMaxSize
        Row = 5
      end
      item
        Column = 0
        Control = lblLogWriteActive
        Row = 4
      end
      item
        Column = 0
        Control = lblNumberOfDays
        Row = 6
      end
      item
        Column = 1
        Control = cbLogWriteActive
        Row = 4
      end
      item
        Column = 1
        Control = edtMaxSize
        Row = 5
      end
      item
        Column = 1
        Control = edtNumberOfDays
        Row = 6
      end
      item
        Column = 0
        Control = lblStyle
        Row = 1
      end
      item
        Column = 1
        Control = cbStyle
        Row = 1
      end>
    ParentColor = True
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
      end
      item
        SizeStyle = ssAbsolute
        Value = 35.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 1
    ExplicitWidth = 909
    ExplicitHeight = 386
    DesignSize = (
      646
      373)
    object lblLanguage: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Language'
      Layout = tlCenter
      ExplicitLeft = 265
      ExplicitWidth = 52
      ExplicitHeight = 15
    end
    object lblExtensions: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'File extensions to search'
      Layout = tlCenter
      ExplicitLeft = 189
      ExplicitTop = 38
      ExplicitWidth = 128
      ExplicitHeight = 15
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 6
      Width = 140
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
    end
    object edtExtensions: TEdit
      AlignWithMargins = True
      Left = 330
      Top = 76
      Width = 50
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 1
      Text = '*.eml'
      ExplicitTop = 41
    end
    object ShapeDividingLine: TShape
      Left = 1
      Top = 122
      Width = 318
      Height = 1
      Anchors = []
      Pen.Color = clBtnShadow
    end
    object lblMaxSize: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 178
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Max size of log file (Mb)'
      Layout = tlCenter
      ExplicitLeft = 190
      ExplicitTop = 248
      ExplicitWidth = 127
      ExplicitHeight = 15
    end
    object lblLogWriteActive: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Is loggin write active'
      Layout = tlCenter
      ExplicitLeft = 209
      ExplicitTop = 213
      ExplicitWidth = 108
      ExplicitHeight = 15
    end
    object lblNumberOfDays: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 213
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Number of days during which logs are stored'
      Layout = tlCenter
      ExplicitLeft = 79
      ExplicitTop = 283
      ExplicitWidth = 238
      ExplicitHeight = 15
    end
    object cbLogWriteActive: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 143
      Width = 97
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 2
      ExplicitTop = 213
    end
    object edtMaxSize: TNumberBox
      AlignWithMargins = True
      Left = 330
      Top = 181
      Width = 70
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Decimal = 0
      Mode = nbmCurrency
      MaxValue = 100.000000000000000000
      TabOrder = 3
      SpinButtonOptions.Placement = nbspCompact
      UseMouseWheel = True
      ExplicitTop = 251
    end
    object edtNumberOfDays: TNumberBox
      AlignWithMargins = True
      Left = 330
      Top = 216
      Width = 70
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Decimal = 0
      Mode = nbmCurrency
      MaxValue = 100.000000000000000000
      TabOrder = 4
      SpinButtonOptions.Placement = nbspCompact
      UseMouseWheel = True
      ExplicitTop = 286
    end
    object lblStyle: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 38
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Style'
      Layout = tlCenter
      ExplicitLeft = 292
      ExplicitTop = 143
      ExplicitWidth = 25
      ExplicitHeight = 15
    end
    object cbStyle: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 41
      Width = 145
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Style = csDropDownList
      TabOrder = 5
      ExplicitTop = 146
    end
  end
  inherited alFrame: TActionList
    Left = 72
    Top = 388
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
    end
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
  end
  inherited pmFrame: TPopupMenu
    Left = 88
    Top = 260
  end
end
