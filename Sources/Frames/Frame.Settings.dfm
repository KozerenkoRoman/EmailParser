inherited frameSettings: TframeSettings
  Width = 784
  Height = 519
  OnCanResize = FrameCanResize
  ExplicitWidth = 784
  ExplicitHeight = 519
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 784
    ExplicitWidth = 784
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 39
    Width = 784
    Height = 480
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
        Control = lblPathForAttachments
        Row = 2
      end
      item
        Column = 0
        Control = lblDeleteAttachments
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
      end
      item
        Column = 1
        Control = edtPathForAttachments
        Row = 2
      end
      item
        Column = 1
        Control = cbDeleteAttachments
        Row = 3
      end
      item
        Column = 0
        Control = ShapeDividingLine
        Row = 5
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
    DesignSize = (
      784
      480)
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
      Top = 38
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'File extensions to search'
      Layout = tlCenter
      ExplicitLeft = 189
      ExplicitWidth = 128
      ExplicitHeight = 15
    end
    object lblPathForAttachments: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Paths for saving attachments'
      Layout = tlCenter
      ExplicitLeft = 164
      ExplicitWidth = 153
      ExplicitHeight = 15
    end
    object lblDeleteAttachments: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 108
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Delete attachments after analysis'
      Layout = tlCenter
      ExplicitLeft = 144
      ExplicitWidth = 173
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
      Top = 41
      Width = 50
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 1
      Text = '*.eml'
    end
    object edtPathForAttachments: TButtonedEdit
      AlignWithMargins = True
      Left = 330
      Top = 76
      Width = 319
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Images = DMImage.vil16
      RightButton.DropDownMenu = pmFrame
      RightButton.ImageIndex = 5
      RightButton.ImageName = 'Open_32x32'
      RightButton.Visible = True
      TabOrder = 2
      Text = '#Attachments'
      OnRightButtonClick = aPathForAttachmentsExecute
    end
    object cbDeleteAttachments: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 108
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 3
    end
    object ShapeDividingLine: TShape
      Left = 1
      Top = 192
      Width = 317
      Height = 1
      Anchors = []
      Pen.Color = clBtnShadow
      ExplicitLeft = 0
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
      ExplicitLeft = 190
      ExplicitWidth = 127
      ExplicitHeight = 15
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
      ExplicitLeft = 209
      ExplicitWidth = 108
      ExplicitHeight = 15
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
      ExplicitLeft = 79
      ExplicitWidth = 238
      ExplicitHeight = 15
    end
    object cbLogWriteActive: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 213
      Width = 97
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 4
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
      TabOrder = 5
      SpinButtonOptions.Placement = nbspCompact
      UseMouseWheel = True
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
      TabOrder = 6
      SpinButtonOptions.Placement = nbspCompact
      UseMouseWheel = True
    end
  end
  inherited alFrame: TActionList
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
    Top = 224
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
    Left = 440
    Top = 166
  end
end
