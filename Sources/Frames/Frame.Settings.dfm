inherited frameSettings: TframeSettings
  Width = 909
  Height = 638
  ExplicitWidth = 909
  ExplicitHeight = 638
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 909
    ExplicitWidth = 784
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 59
    Width = 909
    Height = 579
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
        Row = 1
      end
      item
        Column = 0
        Control = lblDeleteAttachments
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
        Row = 1
      end
      item
        Column = 1
        Control = cbDeleteAttachments
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
        Row = 7
      end
      item
        Column = 0
        Control = lblLogWriteActive
        Row = 6
      end
      item
        Column = 0
        Control = lblNumberOfDays
        Row = 8
      end
      item
        Column = 1
        Control = cbLogWriteActive
        Row = 6
      end
      item
        Column = 1
        Control = edtMaxSize
        Row = 7
      end
      item
        Column = 1
        Control = edtNumberOfDays
        Row = 8
      end
      item
        Column = 0
        Control = lblStyle
        Row = 4
      end
      item
        Column = 1
        Control = cbStyle
        Row = 4
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
    ExplicitWidth = 784
    ExplicitHeight = 460
    DesignSize = (
      909
      579)
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
      ExplicitLeft = 240
      ExplicitWidth = 77
      ExplicitHeight = 25
    end
    object lblExtensions: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 38
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'File extensions to search'
      Layout = tlCenter
      ExplicitLeft = 126
      ExplicitWidth = 191
      ExplicitHeight = 25
    end
    object lblDeleteAttachments: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Delete attachments after analysis'
      Layout = tlCenter
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 6
      Width = 140
      Height = 33
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
      Top = 41
      Width = 50
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 1
      Text = '*.eml'
      ExplicitHeight = 33
    end
    object cbDeleteAttachments: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 73
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 2
      ExplicitTop = 108
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
      Top = 248
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Max size of log file (Mb)'
      Layout = tlCenter
      ExplicitLeft = 127
      ExplicitWidth = 190
      ExplicitHeight = 25
    end
    object lblLogWriteActive: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 213
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Is loggin write active'
      Layout = tlCenter
      ExplicitLeft = 155
      ExplicitWidth = 162
      ExplicitHeight = 25
    end
    object lblNumberOfDays: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 283
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Number of days during which logs are stored'
      Layout = tlCenter
      ExplicitLeft = -43
      ExplicitWidth = 360
      ExplicitHeight = 25
    end
    object cbLogWriteActive: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 213
      Width = 97
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 3
    end
    object edtMaxSize: TNumberBox
      AlignWithMargins = True
      Left = 330
      Top = 251
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
      ExplicitHeight = 33
    end
    object edtNumberOfDays: TNumberBox
      AlignWithMargins = True
      Left = 330
      Top = 286
      Width = 70
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Decimal = 0
      Mode = nbmCurrency
      MaxValue = 100.000000000000000000
      TabOrder = 5
      SpinButtonOptions.Placement = nbspCompact
      UseMouseWheel = True
      ExplicitHeight = 33
    end
    object lblStyle: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Style'
      Layout = tlCenter
      ExplicitLeft = 280
      ExplicitWidth = 37
      ExplicitHeight = 25
    end
    object cbStyle: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 146
      Width = 145
      Height = 33
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Style = csDropDownList
      TabOrder = 6
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
