inherited frmRegExpEditor: TfrmRegExpEditor
  ClientHeight = 624
  ClientWidth = 824
  Constraints.MinHeight = 449
  Constraints.MinWidth = 560
  Font.Height = -13
  Font.Name = 'Segoe UI'
  ShowHint = True
  ExplicitWidth = 836
  ExplicitHeight = 662
  TextHeight = 17
  object splPattern: TSplitter
    Left = 465
    Top = 45
    Height = 537
    Align = alRight
    ExplicitLeft = 487
    ExplicitTop = 85
    ExplicitHeight = 511
  end
  object pnlMain: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 48
    Width = 459
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 455
    ExplicitHeight = 530
    object gbRegularExpression: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 453
      Height = 135
      Margins.Top = 10
      Align = alTop
      Caption = 'Regular Expression'
      TabOrder = 0
      ExplicitWidth = 449
      object edRegEx: TMemo
        AlignWithMargins = True
        Left = 5
        Top = 49
        Width = 443
        Height = 81
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 439
      end
      object pnlTemplateName: TPanel
        Left = 2
        Top = 19
        Width = 449
        Height = 27
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
        ExplicitWidth = 445
        DesignSize = (
          449
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
          Width = 341
          Height = 25
          Style = csDropDownList
          Anchors = [akLeft, akTop, akRight]
          ParentColor = True
          TabOrder = 0
          OnCloseUp = cbSetOfTemplatesCloseUp
          ExplicitWidth = 337
        end
      end
    end
    object gbSampleText: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 151
      Width = 453
      Height = 377
      Align = alClient
      Caption = 'Sample Text'
      TabOrder = 1
      ExplicitWidth = 449
      ExplicitHeight = 376
      object edSample: TMemo
        Left = 2
        Top = 19
        Width = 449
        Height = 356
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 445
        ExplicitHeight = 355
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 582
    Width = 824
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 581
    ExplicitWidth = 820
    DesignSize = (
      824
      42)
    object btnCancel: TBitBtn
      Left = 588
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
      ExplicitLeft = 584
    end
    object btnOk: TBitBtn
      Left = 700
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
      ExplicitLeft = 696
    end
  end
  object tbPattern: TToolBar
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 818
    Height = 39
    ButtonHeight = 39
    ButtonWidth = 39
    Images = DMImage.vil32
    TabOrder = 3
    Transparent = False
    ExplicitWidth = 814
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
    Left = 471
    Top = 48
    Width = 350
    Height = 531
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object gbOptions: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 10
      Width = 344
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
      Width = 344
      Height = 377
      Align = alClient
      Caption = 'Results'
      TabOrder = 1
      object tvResults: TTreeView
        Left = 2
        Top = 19
        Width = 340
        Height = 328
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
        ExplicitHeight = 327
      end
      object edtResult: TEdit
        AlignWithMargins = True
        Left = 2
        Top = 350
        Width = 340
        Height = 25
        Margins.Left = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 349
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
