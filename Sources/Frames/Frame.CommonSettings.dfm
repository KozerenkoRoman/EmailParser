inherited frameCommonSettings: TframeCommonSettings
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
    ExplicitWidth = 852
    inherited btnSep03: TToolButton
      Visible = False
    end
  end
  object grdCommonParams: TGridPanel [2]
    Left = 0
    Top = 46
    Width = 858
    Height = 509
    Align = alClient
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWindow
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 250.000000000000000000
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
      end>
    TabOrder = 2
    object lblLanguage: TLabel
      AlignWithMargins = True
      Left = 190
      Top = 3
      Width = 57
      Height = 29
      Align = alRight
      Caption = 'Language'
      Layout = tlCenter
      ExplicitHeight = 17
    end
    object lblExtensions: TLabel
      AlignWithMargins = True
      Left = 105
      Top = 38
      Width = 142
      Height = 29
      Align = alRight
      Caption = 'File extensions to search'
      Layout = tlCenter
      ExplicitHeight = 17
    end
    object lblPathForAttachments: TLabel
      AlignWithMargins = True
      Left = 80
      Top = 73
      Width = 167
      Height = 29
      Align = alRight
      Caption = 'Paths for saving attachments'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 17
    end
    object lblDeleteAttachments: TLabel
      AlignWithMargins = True
      Left = 56
      Top = 108
      Width = 191
      Height = 29
      Align = alRight
      Caption = 'Delete attachments after analysis'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 17
    end
    object cbLanguage: TComboBox
      AlignWithMargins = True
      Left = 260
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
      Left = 260
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
      Left = 260
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
      Left = 260
      Top = 108
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 3
    end
  end
  inherited alFrame: TActionList
    inherited aExportToExcel: TAction
      Visible = False
    end
    inherited aExportToCSV: TAction
      Visible = False
    end
    inherited aPrint: TAction
      Visible = False
    end
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aColumnSettings: TAction
      Visible = False
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
    object miAttachmentsMain: TMenuItem [3]
      Action = aAttachmentsMain
    end
    object miAttachmentsSub: TMenuItem [4]
      Action = aAttachmentsSub
    end
    object miPathForAttachments: TMenuItem [5]
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
