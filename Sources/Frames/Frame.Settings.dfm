inherited frameSettings: TframeSettings
  Width = 646
  Height = 516
  Font.Height = -13
  ParentFont = False
  ExplicitWidth = 646
  ExplicitHeight = 516
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 646
    ExplicitWidth = 646
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 39
    Width = 646
    Height = 477
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
        Control = ShapeDividingLine01
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
      end
      item
        Column = 0
        Control = ShapeDividingLine02
        Row = 7
      end
      item
        Column = 0
        Control = lblHTTPClientActive
        Row = 8
      end
      item
        Column = 1
        Control = cbHTTPClientActive
        Row = 8
      end
      item
        Column = 0
        Control = lblHost
        Row = 9
      end
      item
        Column = 0
        Control = lblPassword
        Row = 11
      end
      item
        Column = 0
        Control = lblUser
        Row = 10
      end
      item
        Column = 1
        Control = edtHost
        Row = 9
      end
      item
        Column = 1
        Control = edtUser
        Row = 10
      end
      item
        Column = 1
        Control = edtPassword
        Row = 11
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
    DesignSize = (
      646
      477)
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
      ExplicitLeft = 260
      ExplicitWidth = 57
      ExplicitHeight = 17
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
      ExplicitLeft = 175
      ExplicitWidth = 142
      ExplicitHeight = 17
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 6
      Width = 145
      Height = 25
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
      ExplicitHeight = 25
    end
    object ShapeDividingLine01: TShape
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
      ExplicitLeft = 174
      ExplicitWidth = 143
      ExplicitHeight = 17
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
      ExplicitLeft = 198
      ExplicitWidth = 119
      ExplicitHeight = 17
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
      ExplicitLeft = 50
      ExplicitWidth = 267
      ExplicitHeight = 17
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
      ExplicitHeight = 25
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
      ExplicitHeight = 25
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
      ExplicitLeft = 290
      ExplicitWidth = 27
      ExplicitHeight = 17
    end
    object cbStyle: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 41
      Width = 145
      Height = 25
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Style = csDropDownList
      TabOrder = 5
      ExplicitTop = 39
    end
    object ShapeDividingLine02: TShape
      Left = 1
      Top = 262
      Width = 318
      Height = 1
      Anchors = []
      Pen.Color = clBtnShadow
      ExplicitLeft = 127
    end
    object lblHTTPClientActive: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 283
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Is HTTP-client active?'
      Layout = tlCenter
      ExplicitLeft = 196
      ExplicitWidth = 121
      ExplicitHeight = 17
    end
    object cbHTTPClientActive: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 283
      Width = 97
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 6
      ExplicitLeft = 434
      ExplicitTop = 114
      ExplicitHeight = 17
    end
    object lblHost: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 318
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Host'
      Layout = tlCenter
      ExplicitLeft = 290
      ExplicitWidth = 27
      ExplicitHeight = 17
    end
    object lblPassword: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 388
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Password'
      Layout = tlCenter
      ExplicitLeft = 261
      ExplicitWidth = 56
      ExplicitHeight = 17
    end
    object lblUser: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 353
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'User'
      Layout = tlCenter
      ExplicitLeft = 290
      ExplicitWidth = 27
      ExplicitHeight = 17
    end
    object edtHost: TEdit
      AlignWithMargins = True
      Left = 330
      Top = 321
      Width = 207
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 7
    end
    object edtUser: TEdit
      AlignWithMargins = True
      Left = 330
      Top = 356
      Width = 121
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 8
      ExplicitLeft = 422
      ExplicitTop = 110
      ExplicitHeight = 25
    end
    object edtPassword: TEdit
      AlignWithMargins = True
      Left = 330
      Top = 391
      Width = 121
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      PasswordChar = '*'
      TabOrder = 9
      ExplicitHeight = 25
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
