inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 646
  ClientWidth = 979
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 991
  ExplicitHeight = 684
  TextHeight = 13
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 200
    Height = 585
    Color = clMedGray
    OpenedWidth = 200
    Placement = svpLeft
    TabOrder = 0
    ExplicitHeight = 584
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 200
      Height = 585
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
      ExplicitHeight = 584
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 979
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 975
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
    object pnlLeft: TPanel
      Left = 0
      Top = 0
      Width = 217
      Height = 41
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
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
    object pnlSrchBox: TPanel
      Left = 791
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 787
      object srchBox: TSearchBox
        Left = 16
        Top = 8
        Width = 162
        Height = 25
        AutoSize = False
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        CanUndoSelText = True
        TabOrder = 0
        OnInvokeSearch = srchBoxInvokeSearch
      end
    end
  end
  object pnlCard: TCardPanel
    Left = 200
    Top = 41
    Width = 779
    Height = 585
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 777
      Height = 583
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExpParameters: TframeRegExpParameters
        Left = 0
        Top = 0
        Width = 777
        Height = 583
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 777
        ExplicitHeight = 583
        inherited tbMain: TToolBar
          Width = 777
          ExplicitWidth = 777
        end
        inherited tbSettings: TToolBar
          Width = 777
          ExplicitWidth = 777
          inherited pnlSettings: TPanel
            inherited cbSetOfTemplates: TComboBox
              Height = 21
              ExplicitHeight = 21
            end
          end
        end
        inherited vstTree: TVirtualStringTree
          Width = 777
          Height = 505
          ExplicitWidth = 777
          ExplicitHeight = 505
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 777
      Height = 583
      Caption = 'crdPathsToFindScripts'
      CardIndex = 1
      TabOrder = 1
      inline framePathes: TframePathes
        Left = 0
        Top = 0
        Width = 777
        Height = 583
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 777
        ExplicitHeight = 583
        inherited tbMain: TToolBar
          Width = 777
          ExplicitWidth = 777
        end
        inherited vstTree: TVirtualStringTree
          Width = 777
          Height = 544
          ExplicitWidth = 777
          ExplicitHeight = 544
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 777
      Height = 583
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameCommonSettings: TframeCommonSettings
        Left = 0
        Top = 0
        Width = 777
        Height = 583
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 777
        ExplicitHeight = 583
        inherited tbMain: TToolBar
          Width = 777
          ExplicitWidth = 777
          inherited btnSave: TToolButton
            Action = aSaveCommonSettings
          end
        end
        inherited grdCommonParams: TGridPanel
          Width = 777
          Height = 544
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
            end>
          ExplicitWidth = 777
          ExplicitHeight = 544
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 777
      Height = 583
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 777
        Height = 583
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
        ExplicitWidth = 777
        ExplicitHeight = 583
        inherited tbMain: TToolBar
          Width = 777
          ExplicitWidth = 777
        end
        inherited pcMain: TPageControl
          Width = 777
          Height = 583
          ExplicitWidth = 777
          ExplicitHeight = 583
          inherited tsEmail: TTabSheet
            ExplicitTop = 25
            ExplicitWidth = 769
            ExplicitHeight = 554
            inherited splInfo: TSplitter
              Top = 269
              Width = 769
              ExplicitTop = 358
              ExplicitWidth = 769
            end
            inherited pcInfo: TPageControl
              Top = 274
              Width = 769
              ExplicitTop = 274
              ExplicitWidth = 769
              inherited tsPlainText: TTabSheet
                ExplicitHeight = 252
                inherited memTextPlain: TMemo
                  Height = 252
                  ExplicitHeight = 252
                end
              end
              inherited tsHtmlText: TTabSheet
                ExplicitTop = 25
                ExplicitWidth = 761
                ExplicitHeight = 251
                inherited wbBody: TWebBrowser
                  Width = 761
                  Height = 251
                  ExplicitWidth = 744
                  ExplicitHeight = 251
                  ControlData = {
                    4C000000A74E0000F11900000000000000000000000000000000000000000000
                    000000004C000000000000000000000001000000E0D057007335CF11AE690800
                    2B2E126200000000000000004C0000000114020000000000C000000000000046
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
            inherited frameEmails: TframeEmails
              Width = 769
              Height = 269
              ExplicitWidth = 769
              ExplicitHeight = 269
              inherited tbMain: TToolBar
                Width = 769
                ExplicitWidth = 769
              end
              inherited vstTree: TVirtualStringTree
                Width = 769
                Height = 230
                ExplicitWidth = 769
                ExplicitHeight = 230
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            ExplicitHeight = 645
            inherited frameAllAttachments: TframeAllAttachments
              Height = 645
              ExplicitHeight = 645
              inherited vstTree: TVirtualStringTree
                Height = 606
                ExplicitHeight = 606
              end
            end
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 626
    Width = 979
    Height = 20
    Panels = <>
    ExplicitTop = 625
    ExplicitWidth = 975
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
