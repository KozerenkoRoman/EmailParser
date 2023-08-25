inherited frameCommonSettings: TframeCommonSettings
  Width = 791
  Height = 356
  ExplicitWidth = 791
  ExplicitHeight = 356
  inherited tbMain: TToolBar
    Width = 791
    ExplicitWidth = 791
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 39
    Width = 791
    Height = 317
    Align = alClient
    BevelOuter = bvNone
    Color = clWindow
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
        Control = lblParseBodyAsHTML
        Row = 4
      end
      item
        Column = 1
        Control = cbParseBodyAsHTML
        Row = 4
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentBackground = False
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
      Top = 38
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
      ExplicitLeft = 150
      ExplicitWidth = 167
      ExplicitHeight = 17
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
      ExplicitLeft = 126
      ExplicitWidth = 191
      ExplicitHeight = 17
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 330
      Top = 3
      Width = 134
      Height = 25
      Margins.Left = 10
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
    end
    object edtExtensions: TEdit
      AlignWithMargins = True
      Left = 330
      Top = 38
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 1
      Text = '*.eml'
      ExplicitHeight = 25
    end
    object edtPathForAttachments: TButtonedEdit
      AlignWithMargins = True
      Left = 330
      Top = 73
      Width = 436
      Height = 29
      Margins.Left = 10
      Align = alLeft
      Images = DMImage.vil16
      RightButton.DropDownMenu = pmFrame
      RightButton.ImageIndex = 5
      RightButton.ImageName = 'Open_32x32'
      RightButton.Visible = True
      TabOrder = 2
      Text = '#Attachments'
      OnRightButtonClick = aPathForAttachmentsExecute
      ExplicitHeight = 25
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
    object lblParseBodyAsHTML: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Parse body with RegExp in HTML-text'
      Layout = tlCenter
      ExplicitLeft = 98
      ExplicitWidth = 219
      ExplicitHeight = 17
    end
    object cbParseBodyAsHTML: TCheckBox
      AlignWithMargins = True
      Left = 330
      Top = 143
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 4
    end
  end
  inherited alFrame: TActionList
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
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
