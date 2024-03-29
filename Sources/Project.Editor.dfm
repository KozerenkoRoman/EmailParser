inherited frmProjectEditor: TfrmProjectEditor
  BorderStyle = bsDialog
  ClientHeight = 291
  ClientWidth = 768
  Constraints.MinHeight = 290
  Constraints.MinWidth = 560
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Position = poMainFormCenter
  ShowHint = True
  OnDestroy = FormDestroy
  ExplicitWidth = 784
  ExplicitHeight = 330
  TextHeight = 17
  object pnlBottom: TPanel
    Left = 0
    Top = 249
    Width = 768
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 250
    ExplicitWidth = 772
    DesignSize = (
      768
      42)
    object btnCancel: TBitBtn
      Left = 536
      Top = 1
      Width = 110
      Height = 40
      Anchors = [akTop, akRight]
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 41
      ImageName = 'RemovePivotField_32x32'
      Images = DMImage.vil32
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
    end
    object btnOk: TBitBtn
      Left = 648
      Top = 1
      Width = 110
      Height = 40
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 44
      ImageName = 'tick'
      Images = DMImage.vil32
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
    end
  end
  object grdCommonParams: TGridPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 249
    Margins.Top = 6
    Align = alClient
    BevelOuter = bvNone
    ColumnCollection = <
      item
        SizeStyle = ssAbsolute
        Value = 300.000000000000000000
      end
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = lblLanguageOCR
        Row = 4
      end
      item
        Column = 0
        Control = lblName
        Row = 0
      end
      item
        Column = 0
        Control = lblDeleteAttachments
        Row = 2
      end
      item
        Column = 1
        Control = cbLanguageOCR
        Row = 4
      end
      item
        Column = 1
        Control = edtName
        Row = 0
      end
      item
        Column = 1
        Control = cbDeleteAttachments
        Row = 2
      end
      item
        Column = 0
        Control = lblProjectId
        Row = 5
      end
      item
        Column = 0
        Control = lblInfo
        Row = 1
      end
      item
        Column = 1
        Control = edtInfo
        Row = 1
      end
      item
        Column = 1
        Control = cbUseOCR
        Row = 3
      end
      item
        Column = 0
        Control = lblUseOCR
        Row = 3
      end
      item
        Column = 1
        Control = edtProjectId
        Row = 5
      end
      item
        Column = 1
        Control = edtPath
        Row = 6
      end
      item
        Column = 0
        Control = lblPathForAttachments
        Row = 6
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
    ExplicitWidth = 772
    ExplicitHeight = 250
    object lblLanguageOCR: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 143
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Language OCR'
      Layout = tlCenter
      ExplicitLeft = 210
      ExplicitWidth = 87
      ExplicitHeight = 17
    end
    object lblName: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Name'
      Layout = tlCenter
      ExplicitLeft = 262
      ExplicitWidth = 35
      ExplicitHeight = 17
    end
    object lblDeleteAttachments: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 73
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Delete attachments after analysis'
      Layout = tlCenter
      ExplicitLeft = 106
      ExplicitWidth = 191
      ExplicitHeight = 17
    end
    object cbLanguageOCR: TComboBox
      AlignWithMargins = True
      Left = 310
      Top = 146
      Width = 140
      Height = 25
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Style = csDropDownList
      TabOrder = 0
    end
    object edtName: TEdit
      AlignWithMargins = True
      Left = 310
      Top = 6
      Width = 463
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 1
      ExplicitHeight = 25
    end
    object cbDeleteAttachments: TCheckBox
      AlignWithMargins = True
      Left = 310
      Top = 73
      Width = 50
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 2
    end
    object lblProjectId: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 178
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Project Id'
      Layout = tlCenter
      ExplicitLeft = 242
      ExplicitWidth = 55
      ExplicitHeight = 17
    end
    object lblInfo: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 38
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Info'
      Layout = tlCenter
      ExplicitLeft = 275
      ExplicitWidth = 22
      ExplicitHeight = 17
    end
    object edtInfo: TEdit
      AlignWithMargins = True
      Left = 310
      Top = 41
      Width = 463
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 3
      ExplicitHeight = 25
    end
    object cbUseOCR: TCheckBox
      AlignWithMargins = True
      Left = 310
      Top = 108
      Width = 97
      Height = 29
      Margins.Left = 10
      Align = alLeft
      TabOrder = 4
    end
    object lblUseOCR: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 108
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Use OCR'
      Layout = tlCenter
      ExplicitLeft = 245
      ExplicitWidth = 52
      ExplicitHeight = 17
    end
    object edtProjectId: TEdit
      AlignWithMargins = True
      Left = 310
      Top = 181
      Width = 463
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      TabOrder = 5
      ExplicitHeight = 25
    end
    object edtPath: TButtonedEdit
      AlignWithMargins = True
      Left = 310
      Top = 216
      Width = 463
      Height = 23
      Margins.Left = 10
      Margins.Top = 6
      Margins.Bottom = 6
      Align = alLeft
      Images = DMImage.vil16
      RightButton.ImageIndex = 5
      RightButton.ImageName = 'Open_32x32'
      RightButton.Visible = True
      TabOrder = 6
      OnRightButtonClick = edtPathRightButtonClick
      ExplicitHeight = 25
    end
    object lblPathForAttachments: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 213
      Width = 294
      Height = 29
      Align = alClient
      Alignment = taRightJustify
      Caption = 'Path For Attachments'
      Layout = tlCenter
      ExplicitLeft = 174
      ExplicitWidth = 123
      ExplicitHeight = 17
    end
  end
  object alProject: TActionList
    Images = DMImage.vil32
    Left = 48
    Top = 16
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
  object pmAttachmments: TPopupMenu
    Images = DMImage.vil16
    Left = 40
    Top = 124
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
    FileName = 'D:\Work\EmailParser\Sources\TesseractOCR'
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 260
    Top = 274
  end
end
