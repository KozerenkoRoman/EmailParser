inherited frmSettings: TfrmSettings
  Caption = 'Email Parser'
  ClientHeight = 575
  ClientWidth = 916
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  DoubleBuffered = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 928
  ExplicitHeight = 613
  TextHeight = 13
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 217
    Height = 514
    Color = clMedGray
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 0
    ExplicitHeight = 513
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 217
      Height = 514
      Align = alClient
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
      ExplicitHeight = 193
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 916
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      916
      41)
    object lblTitle: TLabel
      Left = 217
      Top = 0
      Width = 143
      Height = 41
      Align = alLeft
      Caption = 'Paths to find files'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 19
    end
    object srchBox: TSearchBox
      Left = 744
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
      ExplicitLeft = 740
    end
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 217
      Height = 41
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
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
    end
  end
  object pnlCard: TCardPanel
    Left = 217
    Top = 41
    Width = 699
    Height = 514
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 512
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExpParameters: TframeRegExpParameters
        Left = 0
        Top = 0
        Width = 697
        Height = 512
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 697
        ExplicitHeight = 512
        inherited vstTree: TVirtualStringTree
          Width = 697
          Height = 467
          ExplicitWidth = 697
          ExplicitHeight = 467
        end
        inherited tbMain: TToolBar
          Width = 691
          ExplicitWidth = 691
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 512
      Caption = 'crdPathsToFindScripts'
      CardIndex = 1
      TabOrder = 1
      inline framePathes: TframePathes
        Left = 0
        Top = 0
        Width = 697
        Height = 512
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 697
        ExplicitHeight = 512
        inherited vstTree: TVirtualStringTree
          Width = 697
          Height = 467
          ExplicitWidth = 697
          ExplicitHeight = 467
        end
        inherited tbMain: TToolBar
          Width = 691
          ExplicitWidth = 687
        end
        inherited pmFrame: TPopupMenu
          Left = 260
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 512
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameCommonSettings: TframeCommonSettings
        Left = 0
        Top = 0
        Width = 697
        Height = 512
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 697
        ExplicitHeight = 512
        inherited tbMain: TToolBar
          Width = 691
          ExplicitWidth = 691
          inherited btnSave: TToolButton
            Action = aSaveCommonSettings
          end
        end
        inherited grdCommonParams: TGridPanel
          Width = 697
          Height = 467
          ControlCollection = <
            item
              Column = 0
              Control = frameCommonSettings.lblLanguage
              Row = 0
            end
            item
              Column = 0
              Control = frameCommonSettings.lblExtensions
              Row = 1
            end
            item
              Column = 0
              Control = frameCommonSettings.lblPathForAttachments
              Row = 2
            end
            item
              Column = 0
              Control = frameCommonSettings.lblDeleteAttachments
              Row = 3
            end
            item
              Column = 1
              Control = frameCommonSettings.cbLanguage
              Row = 0
            end
            item
              Column = 1
              Control = frameCommonSettings.edtExtensions
              Row = 1
            end
            item
              Column = 1
              Control = frameCommonSettings.edtPathForAttachments
              Row = 2
            end
            item
              Column = 1
              Control = frameCommonSettings.cbDeleteAttachments
              Row = 3
            end
            item
              Column = 0
              Control = frameCommonSettings.lblParseBodyAsHTML
              Row = 4
            end
            item
              Column = 1
              Control = frameCommonSettings.cbParseBodyAsHTML
              Row = 4
            end
            item
              Column = 0
              Control = frameCommonSettings.lblUseLastGroup
              Row = 5
            end
            item
              Column = 1
              Control = frameCommonSettings.cbUseLastGroup
              Row = 5
            end>
          ExplicitWidth = 697
          ExplicitHeight = 467
          inherited lblLanguage: TLabel
            ExplicitLeft = 260
            ExplicitTop = 3
          end
          inherited lblExtensions: TLabel
            ExplicitLeft = 175
            ExplicitTop = 38
          end
          inherited lblPathForAttachments: TLabel
            ExplicitLeft = 150
            ExplicitTop = 73
          end
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 697
      Height = 512
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 697
        Height = 512
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 697
        ExplicitHeight = 512
        inherited splInfo: TSplitter
          Top = 228
          Width = 697
          ExplicitTop = 345
          ExplicitWidth = 714
        end
        inherited vstTree: TVirtualStringTree
          Width = 697
          Height = 189
          ExplicitWidth = 697
          ExplicitHeight = 189
        end
        inherited tbMain: TToolBar
          Width = 697
          ExplicitWidth = 697
        end
        inherited pcInfo: TPageControl
          Top = 232
          Width = 697
          ExplicitTop = 232
          ExplicitWidth = 697
          inherited tsPlainText: TTabSheet
            ExplicitTop = 25
            ExplicitWidth = 689
            ExplicitHeight = 251
            inherited memTextPlain: TMemo
              Width = 689
              Height = 251
              ExplicitWidth = 689
              ExplicitHeight = 251
            end
          end
          inherited tsHtmlText: TTabSheet
            ExplicitHeight = 252
            inherited wbBody: TWebBrowser
              Height = 252
              ExplicitWidth = 798
              ExplicitHeight = 252
              ControlData = {
                4C0000007A5200000C1A00000000000000000000000000000000000000000000
                000000004C000000000000000000000001000000E0D057007335CF11AE690800
                2B2E126208000000000000004C0000000114020000000000C000000000000046
                8000000000000000000000000000000000000000000000000000000000000000
                00000000000000000100000000000000000000000000000000000000}
            end
          end
          inherited tsAttachments: TTabSheet
            ExplicitHeight = 252
            inherited frameAttachments: TframeAttachments
              Height = 252
              ExplicitHeight = 252
              inherited vstTree: TVirtualStringTree
                Height = 213
                ExplicitHeight = 213
              end
            end
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 555
    Width = 916
    Height = 20
    Panels = <>
    ExplicitTop = 554
    ExplicitWidth = 912
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
