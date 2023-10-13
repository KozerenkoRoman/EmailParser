inherited frmSettings: TfrmSettings
  Caption = 'Email Parser'
  ClientHeight = 662
  ClientWidth = 988
  Constraints.MinHeight = 700
  Constraints.MinWidth = 1000
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  OnClose = FormClose
  ExplicitWidth = 1000
  ExplicitHeight = 700
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 200
    Height = 602
    Color = clMedGray
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 0
    ExplicitHeight = 601
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 200
      Height = 193
      Align = alTop
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 40
      ButtonWidth = 200
      ButtonOptions = [boFullSize, boShowCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Color = clNone
          Collapsed = False
          Items = <
            item
              Action = aPathsFindFiles
            end
            item
              Action = aEditRegExpParameters
            end
            item
              Action = aEditCommonParameters
            end
            item
              Action = aSearch
            end>
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      HotButtonColor = 12477460
      Images = DMImage.vil32
      RegularButtonColor = clNone
      SelectedButtonColor = clNone
      TabOrder = 0
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 988
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 984
    DesignSize = (
      988
      41)
    object imgMenu: TImage
      Left = 7
      Top = 5
      Width = 32
      Height = 32
      Cursor = crHandPoint
      Picture.Data = {
        0954506E67496D61676589504E470D0A1A0A0000000D49484452000000200000
        00200806000000737A7AF40000002B744558744372656174696F6E2054696D65
        0053756E20322041756720323031352031373A30353A3430202D30363030AB9D
        78EE0000000774494D4507DF0802160936B3167602000000097048597300002E
        2300002E230178A53F760000000467414D410000B18F0BFC61050000003B4944
        415478DAEDD3310100200C0341EA5F3454020BA1C3BD81DC925A9F2B00809180
        DD3D19EB00AE00C9000066BE00201900C0CC1700240300003859BE2421B37CDF
        370000000049454E44AE426082}
      OnClick = aToggleSplitPanelExecute
    end
    object lblTitle: TLabel
      Left = 260
      Top = 9
      Width = 1000
      Height = 19
      Anchors = [akTop, akRight]
      Caption = 'Paths to find files'
      Constraints.MinWidth = 1000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 268
    end
    object srchBox: TSearchBox
      Left = 802
      Top = 10
      Width = 159
      Height = 25
      Anchors = [akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnInvokeSearch = srchBoxInvokeSearch
      ExplicitLeft = 798
    end
  end
  object pnlCard: TCardPanel
    Left = 200
    Top = 41
    Width = 788
    Height = 602
    Align = alClient
    ActiveCard = crdCommonParams
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 786
      Height = 600
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExpParameters: TframeRegExpParameters
        Left = 0
        Top = 0
        Width = 786
        Height = 600
        Align = alClient
        BiDiMode = bdLeftToRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ExplicitWidth = 786
        ExplicitHeight = 600
        inherited vstTree: TVirtualStringTree
          Width = 786
          Height = 556
          Header.MainColumn = 0
          ExplicitWidth = 786
          ExplicitHeight = 556
        end
        inherited tbMain: TToolBar
          Width = 780
          ExplicitWidth = 780
        end
        inherited alFrame: TActionList
          Left = 224
          Top = 80
        end
        inherited pmFrame: TPopupMenu
          Left = 224
          Top = 136
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 786
      Height = 600
      Caption = 'crdPaths'
      CardIndex = 1
      TabOrder = 1
      inline framePathes: TframePathes
        Left = 0
        Top = 0
        Width = 786
        Height = 600
        Align = alClient
        BiDiMode = bdLeftToRight
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ExplicitWidth = 786
        ExplicitHeight = 600
        inherited vstTree: TVirtualStringTree
          Width = 786
          Height = 556
          ExplicitWidth = 786
          ExplicitHeight = 556
        end
        inherited tbMain: TToolBar
          Width = 780
          ExplicitWidth = 780
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 786
      Height = 600
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 786
        Height = 600
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        inherited tbMain: TToolBar
          Width = 780
          ExplicitWidth = 776
          inherited btnSave: TToolButton
            Action = aSaveCommonSettings
          end
        end
        inherited grdCommonParams: TGridPanel
          Width = 786
          Height = 556
          ControlCollection = <
            item
              Column = 0
              Control = frameSettings.lblLanguage
              Row = 0
            end
            item
              Column = 0
              Control = frameSettings.lblExtensions
              Row = 1
            end
            item
              Column = 0
              Control = frameSettings.Label5
              Row = 2
            end
            item
              Column = 0
              Control = frameSettings.Label7
              Row = 3
            end
            item
              Column = 1
              Control = frameSettings.cbLanguage
              Row = 0
            end
            item
              Column = 1
              Control = frameSettings.edtExtensions
              Row = 1
            end>
          ExplicitTop = 44
          ExplicitWidth = 782
          ExplicitHeight = 555
        end
      end
    end
    object crdSearch: TCard
      Left = 1
      Top = 1
      Width = 786
      Height = 600
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 786
        Height = 600
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        ExplicitWidth = 786
        ExplicitHeight = 600
        inherited splInfo: TSplitter
          Top = 413
          Width = 786
          ExplicitTop = 369
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 786
          Height = 369
          ExplicitWidth = 786
          ExplicitHeight = 369
        end
        inherited tbMain: TToolBar
          Width = 780
          ExplicitWidth = 780
        end
        inherited gbInfo: TGroupBox
          Top = 426
          Width = 780
          ExplicitTop = 426
          ExplicitWidth = 780
          inherited memInfo: TMemo
            Width = 776
            ExplicitWidth = 776
          end
        end
        inherited pnlBottom: TPanel
          Top = 559
          Width = 786
          ExplicitTop = 559
          ExplicitWidth = 786
          inherited btnBreak: TBitBtn
            Left = 665
            ExplicitLeft = 665
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 643
    Width = 988
    Height = 19
    Panels = <>
    ExplicitTop = 642
    ExplicitWidth = 984
  end
  object alSettings: TActionList
    Images = DMImage.vil32
    Left = 104
    Top = 216
    object aToggleSplitPanel: TAction
      OnExecute = aToggleSplitPanelExecute
    end
    object aPathsFindFiles: TAction
      Caption = 'Paths to find files'
      ImageIndex = 24
      ImageName = 'TreeView_32x32'
      OnExecute = aPathsFindFilesExecute
    end
    object aEditRegExpParameters: TAction
      Caption = 'Edit RegExp parameters'
      ImageIndex = 1
      ImageName = 'Edit_32x32'
      OnExecute = aEditRegExpParametersExecute
    end
    object aSearch: TAction
      Caption = 'Search'
      ImageIndex = 21
      ImageName = 'Zoom_32x32'
      OnExecute = aSearchExecute
    end
    object aEditCommonParameters: TAction
      Caption = 'Edit Common Parameters'
      ImageIndex = 63
      ImageName = 'PageSetup_32x32'
      OnExecute = aEditCommonParametersExecute
    end
    object aSaveCommonSettings: TAction
      ImageIndex = 10
      ImageName = 'Save_32x32'
      OnExecute = aSaveCommonSettingsExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 105
    Top = 282
  end
end
