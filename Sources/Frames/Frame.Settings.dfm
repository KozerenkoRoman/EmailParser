inherited frameSettings: TframeSettings
  Width = 784
  Height = 356
  OnCanResize = FrameCanResize
  ExplicitWidth = 784
  ExplicitHeight = 356
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 784
    ExplicitWidth = 784
  end
  object grdCommonParams: TGridPanel [1]
    Left = 0
    Top = 39
    Width = 784
    Height = 317
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
        Control = lblLoadRecordsFromDB
        Row = 4
      end
      item
        Column = 1
        Control = cbLoadRecordsFromDB
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
    object lblLoadRecordsFromDB: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 314
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Load records from the database at startup'
      Layout = tlCenter
      ExplicitLeft = 97
      ExplicitWidth = 220
      ExplicitHeight = 15
    end
    object cbLoadRecordsFromDB: TCheckBox
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
