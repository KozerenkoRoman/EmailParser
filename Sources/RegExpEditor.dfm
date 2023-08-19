inherited frmRegExpEditor: TfrmRegExpEditor
  ClientHeight = 480
  ClientWidth = 776
  Constraints.MinHeight = 500
  Constraints.MinWidth = 700
  Font.Height = -13
  Font.Name = 'Segoe UI'
  ShowHint = True
  ExplicitWidth = 788
  ExplicitHeight = 518
  TextHeight = 17
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 48
    Width = 427
    Height = 387
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 710
    ExplicitHeight = 511
    object gbRegularExpression: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 421
      Height = 135
      Margins.Top = 10
      Align = alTop
      Caption = 'Regular Expression'
      TabOrder = 0
      ExplicitWidth = 704
      object edRegEx: TMemo
        AlignWithMargins = True
        Left = 5
        Top = 22
        Width = 411
        Height = 108
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 694
      end
    end
    object gbSampleText: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 151
      Width = 421
      Height = 233
      Align = alClient
      Caption = 'Sample Text'
      TabOrder = 1
      ExplicitWidth = 704
      ExplicitHeight = 357
      object edSample: TMemo
        Left = 2
        Top = 19
        Width = 417
        Height = 212
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 700
        ExplicitHeight = 336
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 438
    Width = 776
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 562
    ExplicitWidth = 1059
    DesignSize = (
      776
      42)
    object btnCancel: TBitBtn
      Left = 548
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
      ImageIndex = 43
      ImageName = 'RemovePivotField_32x32'
      Images = DMImage.vil32
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 831
    end
    object btnOk: TBitBtn
      Left = 660
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
      ImageIndex = 46
      ImageName = 'tick'
      Images = DMImage.vil32
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
      ExplicitLeft = 943
    end
  end
  object tbPattern: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 770
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    Images = DMImage.vil32
    TabOrder = 2
    Transparent = False
    ExplicitWidth = 1053
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 497
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      DoubleBuffered = True
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object lblPatterns: TLabel
        Left = 0
        Top = 0
        Width = 125
        Height = 39
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Patterns'
        Layout = tlCenter
        ExplicitLeft = -3
        ExplicitTop = -3
      end
      object cbSetOfTemplates: TComboBox
        AlignWithMargins = True
        Left = 128
        Top = 7
        Width = 363
        Height = 25
        Style = csDropDownList
        ParentColor = True
        TabOrder = 0
        Items.Strings = (
          'sdfg sdfg sdf'
          'sdf gsdfg sdf hsdfh '
          'sdfg sdfh sdh ewty we y'
          'wer ery weyr wey '
          'ewr er t')
      end
    end
    object btnSaveSet: TToolButton
      Left = 497
      Top = 0
      Caption = 'Save template set'
      DropdownMenu = pmPattern
      ImageIndex = 26
      ImageName = 'SaveAll_32x32'
      Style = tbsDropDown
    end
    object btnDeleteSet: TToolButton
      Left = 551
      Top = 0
      Action = aDeletePattern
    end
    object btnTest: TToolButton
      Left = 590
      Top = 0
      Action = aTest
    end
  end
  object pnlRight: TPanel
    AlignWithMargins = True
    Left = 436
    Top = 48
    Width = 337
    Height = 387
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitLeft = 719
    ExplicitHeight = 511
    object gbOptions: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 331
      Height = 135
      Margins.Top = 10
      Align = alTop
      Caption = 'Options'
      TabOrder = 0
      object chkSingleLine: TCheckBox
        Left = 5
        Top = 41
        Width = 300
        Height = 17
        Caption = 'Single Line'
        TabOrder = 0
      end
      object chkIgnorePatternSpace: TCheckBox
        Left = 5
        Top = 110
        Width = 300
        Height = 17
        Caption = 'Ignore Pattern Space'
        TabOrder = 1
      end
      object chkExplicitCapture: TCheckBox
        Left = 5
        Top = 87
        Width = 300
        Height = 17
        Caption = 'Explicit Capture'
        TabOrder = 2
      end
      object chkMultiLine: TCheckBox
        Left = 5
        Top = 64
        Width = 300
        Height = 17
        Caption = 'Multi Line'
        TabOrder = 3
      end
      object chkIgnoreCase: TCheckBox
        Left = 5
        Top = 18
        Width = 300
        Height = 17
        Caption = 'Ignore Case'
        TabOrder = 4
      end
    end
    object gbResults: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 151
      Width = 331
      Height = 233
      Align = alClient
      Caption = 'Results'
      TabOrder = 1
      ExplicitHeight = 357
      object tvResults: TTreeView
        Left = 2
        Top = 19
        Width = 327
        Height = 212
        Align = alClient
        Indent = 19
        TabOrder = 0
        ExplicitHeight = 336
      end
    end
  end
  object alPattern: TActionList
    Images = DMImage.vil32
    Left = 104
    Top = 248
    object aSavePattern: TAction
      Caption = 'Save pattern'
      ImageIndex = 10
      ImageName = 'Save_32x32'
    end
    object aSavePatternAs: TAction
      Caption = 'Save pattern as...'
    end
    object aDeletePattern: TAction
      ImageIndex = 65
      ImageName = 'DeleteList2_32x32'
    end
    object aTest: TAction
      ImageIndex = 42
      ImageName = 'page_white_lightning'
      OnExecute = aTestExecute
    end
    object aCopy: TAction
      Caption = 'Copy'
      ImageIndex = 76
      ImageName = 'page_copy'
      ShortCut = 16451
      OnExecute = aCopyExecute
    end
    object aPaste: TAction
      Caption = 'Paste'
      ImageIndex = 77
      ImageName = 'page_paste'
      ShortCut = 16470
      OnExecute = aPasteExecute
    end
    object aSelectAll: TAction
      Caption = 'Select All'
      ShortCut = 16449
      OnExecute = aSelectAllExecute
    end
  end
  object pmPattern: TPopupMenu
    Images = DMImage.vil16
    Left = 100
    Top = 180
    object miSaveSet: TMenuItem
      Action = aSavePattern
      Default = True
    end
    object miSaveSetAs: TMenuItem
      Action = aSavePatternAs
    end
  end
  object pmMemo: TPopupMenu
    Images = DMImage.vil16
    Left = 187
    Top = 184
    object miCopy: TMenuItem
      Action = aCopy
    end
    object miPaste: TMenuItem
      Action = aPaste
    end
    object miSelectAll: TMenuItem
      Action = aSelectAll
    end
  end
end
