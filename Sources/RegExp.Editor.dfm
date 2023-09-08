inherited frmRegExpEditor: TfrmRegExpEditor
  ClientHeight = 623
  ClientWidth = 860
  Constraints.MinHeight = 449
  Constraints.MinWidth = 560
  Font.Height = -13
  Font.Name = 'Segoe UI'
  ShowHint = True
  ExplicitWidth = 872
  ExplicitHeight = 661
  TextHeight = 17
  object splPattern: TSplitter
    Left = 482
    Top = 45
    Height = 536
    Align = alRight
    ExplicitLeft = 487
    ExplicitTop = 85
    ExplicitHeight = 511
  end
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 48
    Width = 476
    Height = 530
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 472
    ExplicitHeight = 529
    object gbRegularExpression: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 470
      Height = 135
      Margins.Top = 10
      Align = alTop
      Caption = 'Regular Expression'
      TabOrder = 0
      ExplicitWidth = 466
      object edRegEx: TMemo
        AlignWithMargins = True
        Left = 5
        Top = 49
        Width = 460
        Height = 81
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 456
      end
      object pnlTemplateName: TPanel
        Left = 2
        Top = 19
        Width = 466
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 462
        DesignSize = (
          466
          27)
        object lblExamples: TLabel
          Left = 0
          Top = 0
          Width = 95
          Height = 27
          Align = alLeft
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'Examples'
          Layout = tlCenter
        end
        object cbSetOfTemplates: TComboBox
          AlignWithMargins = True
          Left = 101
          Top = 0
          Width = 354
          Height = 25
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ParentColor = True
          TabOrder = 0
          OnCloseUp = cbSetOfTemplatesCloseUp
          ExplicitWidth = 350
        end
      end
    end
    object gbSampleText: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 151
      Width = 470
      Height = 376
      Align = alClient
      Caption = 'Sample Text'
      TabOrder = 1
      ExplicitWidth = 466
      ExplicitHeight = 375
      object edSample: TMemo
        Left = 2
        Top = 19
        Width = 466
        Height = 355
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 462
        ExplicitHeight = 354
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 581
    Width = 860
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 580
    ExplicitWidth = 856
    DesignSize = (
      860
      42)
    object btnCancel: TBitBtn
      Left = 612
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
      ExplicitLeft = 608
    end
    object btnOk: TBitBtn
      Left = 724
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
      ExplicitLeft = 720
    end
  end
  object tbPattern: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 854
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    Images = DMImage.vil32
    TabOrder = 3
    Transparent = False
    ExplicitWidth = 850
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 577
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      DoubleBuffered = True
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object lblTemplateName: TLabel
        Left = 0
        Top = 0
        Width = 100
        Height = 39
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Template name'
        Layout = tlCenter
      end
      object lblGroupIndex: TLabel
        Left = 461
        Top = 9
        Width = 72
        Height = 17
        Caption = 'Group index'
      end
      object edtTemplateName: TEdit
        Left = 106
        Top = 6
        Width = 349
        Height = 25
        TabOrder = 0
      end
      object edtGroupIndex: TNumberBox
        Left = 539
        Top = 6
        Width = 38
        Height = 25
        Decimal = 0
        Mode = nbmCurrency
        MaxValue = 100.000000000000000000
        TabOrder = 1
        SpinButtonOptions.Placement = nbspCompact
        UseMouseWheel = True
      end
    end
    object btnTest: TToolButton
      Left = 577
      Top = 0
      Action = aTest
    end
  end
  object pnlRight: TPanel
    AlignWithMargins = True
    Left = 488
    Top = 48
    Width = 369
    Height = 530
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 484
    ExplicitHeight = 529
    object gbOptions: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 363
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
      Width = 363
      Height = 376
      Align = alClient
      Caption = 'Results'
      TabOrder = 1
      ExplicitHeight = 375
      object tvResults: TTreeView
        Left = 2
        Top = 19
        Width = 359
        Height = 327
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        Indent = 15
        ParentShowHint = False
        ReadOnly = True
        ShowButtons = False
        ShowHint = False
        TabOrder = 0
        ToolTips = False
        ExplicitHeight = 326
      end
      object edtResult: TEdit
        AlignWithMargins = True
        Left = 2
        Top = 349
        Width = 359
        Height = 25
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 348
      end
    end
  end
  object alPattern: TActionList
    Images = DMImage.vil32
    Left = 104
    Top = 248
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
  object pmMemo: TPopupMenu
    Images = DMImage.vil16
    Left = 107
    Top = 160
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
