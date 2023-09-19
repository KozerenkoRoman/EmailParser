object FrameCustom: TFrameCustom
  Left = 0
  Top = 0
  Width = 373
  Height = 300
  TabOrder = 0
  object tbMain: TToolBar
    Left = 0
    Top = 0
    Width = 373
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    TabOrder = 0
    ExplicitWidth = 377
    object btnAdd: TToolButton
      Left = 0
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aAdd
    end
    object btnEdit: TToolButton
      Left = 39
      Top = 0
      Action = aEdit
    end
    object btnDelete: TToolButton
      Left = 78
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aDelete
    end
    object btnSave: TToolButton
      Left = 117
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aSave
    end
    object btnSep01: TToolButton
      Left = 156
      Top = 0
      Width = 8
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ImageIndex = 16
      ImageName = 'ExportToXLS_32x32'
      Style = tbsSeparator
    end
    object btnRefresh: TToolButton
      Left = 164
      Top = 0
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Action = aRefresh
    end
    object btnSep02: TToolButton
      Left = 203
      Top = 0
      Width = 8
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      ImageIndex = 33
      ImageName = 'Download_32x32'
      Style = tbsSeparator
    end
  end
  object alFrame: TActionList
    Images = DMImage.vil32
    Left = 96
    Top = 160
    object aAdd: TAction
      Hint = 'Add'
      ImageIndex = 52
      ImageName = 'AddItem_32x32'
    end
    object aEdit: TAction
      ImageIndex = 1
      ImageName = 'Edit_32x32'
      Visible = False
    end
    object aDelete: TAction
      Hint = 'Delete'
      ImageIndex = 0
      ImageName = 'DeleteList_32x32'
    end
    object aSave: TAction
      Hint = 'Save'
      ImageIndex = 10
      ImageName = 'Save_32x32'
    end
    object aRefresh: TAction
      Hint = 'Refresh'
      ImageIndex = 32
      ImageName = 'Refresh_32x32'
    end
  end
  object pmFrame: TPopupMenu
    Images = DMImage.vil16
    Left = 100
    Top = 100
  end
end
