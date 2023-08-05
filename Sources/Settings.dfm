inherited frmSettings: TfrmSettings
  Caption = 'Email Parser'
  ClientHeight = 618
  ClientWidth = 940
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ExplicitWidth = 956
  ExplicitHeight = 657
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 200
    Height = 577
    Color = clMedGray
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 0
    ExplicitHeight = 576
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
    Width = 940
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 936
    DesignSize = (
      940
      41)
    object imgMenu: TImage
      Left = -1
      Top = 5
      Width = 32
      Height = 32
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
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
      ExplicitLeft = 7
    end
    object lblTitle: TLabel
      Left = 228
      Top = 9
      Width = 143
      Height = 19
      Anchors = [akTop, akRight]
      Caption = 'Paths to find files'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 236
    end
    object btnSearch: TSpeedButton
      Left = 45
      Top = 2
      Width = 38
      Height = 38
      Action = aSearch
      Images = DMImage.vil32
      HotImageIndex = 21
      HotImageName = 'Zoom_32x32'
      Flat = True
      Transparent = False
    end
    object srchBox: TSearchBox
      Left = 770
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
      ExplicitLeft = 766
    end
  end
  object pnlCard: TCardPanel
    Left = 200
    Top = 41
    Width = 740
    Height = 577
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 738
      Height = 575
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExpParameters: TframeRegExpParameters
        Left = 0
        Top = 0
        Width = 738
        Height = 575
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
        ExplicitWidth = 738
        ExplicitHeight = 575
        inherited vstTree: TVirtualStringTree
          Width = 738
          Height = 531
          Header.MainColumn = 0
          ExplicitWidth = 738
          ExplicitHeight = 531
        end
        inherited tbMain: TToolBar
          Width = 732
          ExplicitWidth = 732
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
      Width = 738
      Height = 575
      Caption = 'crdPaths'
      CardIndex = 1
      TabOrder = 1
      inline framePathes: TframePathes
        Left = 0
        Top = 0
        Width = 738
        Height = 575
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
        ExplicitWidth = 738
        ExplicitHeight = 575
        inherited vstTree: TVirtualStringTree
          Width = 738
          Height = 531
          ExplicitWidth = 738
          ExplicitHeight = 531
        end
        inherited tbMain: TToolBar
          Width = 732
          ExplicitWidth = 728
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 738
      Height = 575
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
    end
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
      Hint = 'Search'
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
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 297
    Top = 202
  end
end
