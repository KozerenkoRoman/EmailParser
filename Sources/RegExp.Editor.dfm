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
    object gbSampleText: TGroupBox
      AlignWithMargins = True
      Left = 3
      Top = 188
      Width = 470
      Height = 339
      Align = alClient
      Caption = 'Sample Text'
      TabOrder = 1
      ExplicitWidth = 466
      ExplicitHeight = 338
      object edSample: TMemo
        Left = 2
        Top = 19
        Width = 466
        Height = 318
        Align = alClient
        Ctl3D = True
        ParentCtl3D = False
        PopupMenu = pmMemo
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitWidth = 462
        ExplicitHeight = 317
      end
    end
    object pcTypePattern: TPageControl
      Left = 0
      Top = 0
      Width = 476
      Height = 185
      ActivePage = tsAhoCorasick
      Align = alTop
      MultiLine = True
      TabOrder = 0
      ExplicitWidth = 472
      object tsRegularExpression: TTabSheet
        Caption = 'Regular Expression'
        object pnlTemplateName: TPanel
          Left = 0
          Top = 0
          Width = 468
          Height = 27
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitWidth = 464
          DesignSize = (
            468
            27)
          object lblExamples: TLabel
            Left = 0
            Top = 0
            Width = 88
            Height = 27
            Align = alLeft
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'Examples'
            Layout = tlCenter
          end
          object cbSetOfTemplates: TComboBox
            AlignWithMargins = True
            Left = 94
            Top = 0
            Width = 371
            Height = 25
            Style = csDropDownList
            Anchors = [akLeft, akTop, akRight]
            ParentColor = True
            TabOrder = 0
            OnCloseUp = cbSetOfTemplatesCloseUp
          end
        end
        object edRegEx: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 30
          Width = 462
          Height = 120
          Align = alClient
          Ctl3D = True
          ParentCtl3D = False
          PopupMenu = pmMemo
          ScrollBars = ssVertical
          TabOrder = 1
          ExplicitWidth = 458
        end
      end
      object tsAhoCorasick: TTabSheet
        Caption = 'Aho Corasick'
        ImageIndex = 1
        object edAhoCorasick: TMemo
          Left = 0
          Top = 0
          Width = 468
          Height = 153
          Align = alClient
          Ctl3D = True
          ParentCtl3D = False
          PopupMenu = pmMemo
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitWidth = 464
        end
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
      Left = 613
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
      ExplicitLeft = 609
    end
    object btnOk: TBitBtn
      Left = 725
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
      ExplicitLeft = 721
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
      Width = 460
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
      object edtTemplateName: TEdit
        Left = 106
        Top = 6
        Width = 349
        Height = 25
        TabOrder = 0
      end
    end
    object btnTest: TToolButton
      Left = 460
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
      object lblGroupIndex: TLabel
        Left = 14
        Top = 53
        Width = 72
        Height = 17
        Caption = 'Group index'
      end
      object lblColor: TLabel
        Left = 14
        Top = 81
        Width = 32
        Height = 17
        Caption = 'Color'
      end
      object lblUseRawText: TLabel
        Left = 14
        Top = 109
        Width = 69
        Height = 17
        Caption = 'UseRawText'
      end
      object lblTypePattern: TLabel
        Left = 14
        Top = 22
        Width = 72
        Height = 17
        Caption = 'Type Pattern'
      end
      object edtGroupIndex: TNumberBox
        Left = 144
        Top = 50
        Width = 56
        Height = 25
        Decimal = 0
        Mode = nbmCurrency
        MaxValue = 100.000000000000000000
        TabOrder = 0
        SpinButtonOptions.Placement = nbspCompact
        UseMouseWheel = True
      end
      object cbWebColor: TColorBox
        Left = 144
        Top = 81
        Width = 201
        Height = 22
        DefaultColorColor = clInfoBk
        Selected = clInfoBk
        Style = [cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames, cbCustomColors]
        TabOrder = 1
      end
      object cbUseRawText: TCheckBox
        Left = 143
        Top = 110
        Width = 39
        Height = 17
        TabOrder = 2
      end
      object cbTypePattern: TComboBox
        Left = 144
        Top = 19
        Width = 201
        Height = 25
        Style = csDropDownList
        TabOrder = 3
        OnChange = cbTypePatternChange
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
        Height = 355
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
        OnCustomDrawItem = tvResultsCustomDrawItem
        ExplicitHeight = 354
      end
    end
  end
  object alPattern: TActionList
    Images = DMImage.vil32
    Left = 104
    Top = 248
    object aTest: TAction
      ImageIndex = 40
      ImageName = 'page_white_lightning'
      OnExecute = aTestExecute
    end
    object aCopy: TAction
      Caption = 'Copy'
      ImageIndex = 73
      ImageName = 'page_copy'
      ShortCut = 16451
      OnExecute = aCopyExecute
    end
    object aPaste: TAction
      Caption = 'Paste'
      ImageIndex = 74
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
