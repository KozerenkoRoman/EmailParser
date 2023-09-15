inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 565
  ClientWidth = 936
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 948
  ExplicitHeight = 603
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 504
    AnimationDelay = 20
    CloseStyle = svcCompact
    Color = clMedGray
    CompactWidth = 47
    OpenedWidth = 250
    Placement = svpLeft
    TabOrder = 0
    OnClosed = splViewClosed
    OnOpened = splViewOpened
    ExplicitHeight = 503
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 293
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ButtonFlow = cbfVertical
      ButtonHeight = 40
      ButtonWidth = 200
      ButtonOptions = [boFullSize, boGradientFill, boShowCaptions, boCaptionOnlyBorder]
      Categories = <
        item
          Caption = 'Main'
          Color = clSilver
          Collapsed = False
          Items = <
            item
              Caption = 'Paths to find files'
              ImageIndex = 24
              ImageName = 'TreeView_32x32'
            end
            item
              Caption = 'Edit RegExp parameters'
              ImageIndex = 1
              ImageName = 'Edit_32x32'
            end
            item
              Caption = 'Edit Common Parameters'
              ImageIndex = 63
              ImageName = 'PageSetup_32x32'
            end
            item
              Caption = 'Search'
              ImageIndex = 21
              ImageName = 'Zoom_32x32'
            end>
          TextColor = clWindowFrame
        end
        item
          Caption = 'Utils'
          Color = clSilver
          Collapsed = False
          Items = <
            item
              Caption = 'Search duplicate files'
              ImageIndex = 81
              ImageName = 'Zoom100_32x32'
            end
            item
              Caption = 'Open Log File'
              ImageIndex = 70
              ImageName = 'file_extension_log'
            end>
          TextColor = clWindowFrame
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
      OnSelectedItemChange = catMenuItemsSelectedItemChange
      ExplicitHeight = 292
    end
    object cbRegExp: TCheckListBox
      Left = 0
      Top = 293
      Width = 250
      Height = 211
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = True
      CheckBoxPadding = 4
      ItemHeight = 19
      ParentCtl3D = False
      TabOrder = 1
      Visible = False
      ExplicitTop = 292
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 936
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 932
    object lblTitle: TLabel
      Left = 250
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
      Width = 250
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
      Left = 748
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 744
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
    Left = 250
    Top = 41
    Width = 686
    Height = 504
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 684
      Height = 502
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 684
        Height = 502
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 684
        ExplicitHeight = 502
        inherited tbMain: TToolBar
          Width = 684
          ExplicitWidth = 684
        end
        inherited vstTree: TVirtualStringTree
          Width = 684
          Height = 420
          Font.Height = -11
          Font.Name = 'Tahoma'
          ExplicitWidth = 684
          ExplicitHeight = 420
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 684
          ExplicitWidth = 684
          inherited pnlSettings: TPanel
            inherited lblSetOfTemplates: TLabel
              Font.Height = -13
              ParentFont = False
            end
          end
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 684
      Height = 502
      Caption = 'crdPathsToFindFiles'
      CardIndex = 1
      TabOrder = 1
      object splPath: TSplitter
        Left = 0
        Top = 316
        Width = 684
        Height = 3
        Cursor = crVSplit
        Align = alTop
        ExplicitTop = 295
        ExplicitWidth = 287
      end
      object gbPathes: TGroupBox
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 678
        Height = 310
        Align = alTop
        Caption = 'gbPathes'
        TabOrder = 0
        inline framePathes: TframePathes
          Left = 2
          Top = 17
          Width = 674
          Height = 291
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 674
          ExplicitHeight = 291
          inherited tbMain: TToolBar
            Width = 674
            ExplicitWidth = 670
          end
          inherited vstTree: TVirtualStringTree
            Width = 674
            Height = 252
            ExplicitWidth = 674
            ExplicitHeight = 252
            DefaultText = ''
          end
        end
      end
      object gbSorter: TGroupBox
        Left = 0
        Top = 319
        Width = 684
        Height = 183
        Align = alClient
        Caption = 'gbSorter'
        TabOrder = 1
        inline frameSorter: TframeSorter
          Left = 2
          Top = 17
          Width = 680
          Height = 164
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 680
          ExplicitHeight = 164
          inherited tbMain: TToolBar
            Width = 680
            ExplicitWidth = 676
          end
          inherited vstTree: TVirtualStringTree
            Width = 680
            Height = 125
            ExplicitWidth = 680
            ExplicitHeight = 125
            DefaultText = ''
          end
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 684
      Height = 502
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 684
        Height = 502
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 684
        ExplicitHeight = 502
        inherited tbMain: TToolBar
          Width = 684
          ExplicitWidth = 684
        end
        inherited grdCommonParams: TGridPanel
          Width = 684
          Height = 463
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
              Control = frameSettings.lblPathForAttachments
              Row = 2
            end
            item
              Column = 0
              Control = frameSettings.lblDeleteAttachments
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
            end
            item
              Column = 1
              Control = frameSettings.edtPathForAttachments
              Row = 2
            end
            item
              Column = 1
              Control = frameSettings.cbDeleteAttachments
              Row = 3
            end
            item
              Column = 0
              Control = frameSettings.lblLoadRecordsFromDB
              Row = 4
            end
            item
              Column = 1
              Control = frameSettings.cbLoadRecordsFromDB
              Row = 4
            end>
          ExplicitWidth = 684
          ExplicitHeight = 463
          inherited lblLanguage: TLabel
            ExplicitLeft = 264
            ExplicitWidth = 53
            ExplicitHeight = 14
          end
          inherited lblExtensions: TLabel
            ExplicitLeft = 183
            ExplicitWidth = 134
            ExplicitHeight = 14
          end
          inherited lblPathForAttachments: TLabel
            ExplicitLeft = 158
            ExplicitWidth = 159
            ExplicitHeight = 14
          end
          inherited lblDeleteAttachments: TLabel
            ExplicitLeft = 135
            ExplicitWidth = 182
            ExplicitHeight = 14
          end
          inherited cbLanguage: TComboBox
            Height = 22
            ExplicitTop = 6
            ExplicitHeight = 22
          end
          inherited edtExtensions: TEdit
            Height = 22
            ExplicitTop = 41
            ExplicitHeight = 22
          end
          inherited edtPathForAttachments: TButtonedEdit
            Height = 22
            ExplicitTop = 76
            ExplicitHeight = 22
          end
          inherited lblLoadRecordsFromDB: TLabel
            ExplicitLeft = 84
            ExplicitWidth = 233
            ExplicitHeight = 14
          end
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 684
      Height = 502
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 684
        Height = 502
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
        ExplicitWidth = 684
        ExplicitHeight = 502
        inherited tbMain: TToolBar
          Width = 684
          ExplicitWidth = 684
        end
        inherited pcMain: TPageControl
          Width = 684
          Height = 502
          ExplicitWidth = 684
          ExplicitHeight = 502
          inherited tsEmail: TTabSheet
            ExplicitTop = 25
            ExplicitWidth = 676
            ExplicitHeight = 473
            inherited splInfo: TSplitter
              Top = 188
              Width = 676
              ExplicitTop = 358
              ExplicitWidth = 680
            end
            inherited pcInfo: TPageControl
              Top = 193
              Width = 676
              ExplicitTop = 193
              ExplicitWidth = 676
              inherited tsHtmlText: TTabSheet
                ExplicitTop = 25
                ExplicitWidth = 668
                ExplicitHeight = 251
                inherited wbBody: TWebBrowser
                  Width = 668
                  Height = 251
                  ExplicitWidth = 668
                  ExplicitHeight = 251
                  ControlData = {
                    4C0000000A450000F11900000000000000000000000000000000000000000000
                    000000004C000000000000000000000001000000E0D057007335CF11AE690800
                    2B2E126208000000000000004C0000000114020000000000C000000000000046
                    8000000000000000000000000000000000000000000000000000000000000000
                    00000000000000000100000000000000000000000000000000000000}
                end
              end
              inherited tsAttachments: TTabSheet
                inherited frameAttachments: TframeAttachments
                  inherited vstTree: TVirtualStringTree
                    Font.Name = 'Tahoma'
                    DefaultText = ''
                  end
                end
              end
            end
            inherited frameEmails: TframeEmails
              Width = 676
              Height = 188
              ExplicitWidth = 676
              ExplicitHeight = 188
              inherited tbMain: TToolBar
                Width = 676
                ExplicitWidth = 676
              end
              inherited vstTree: TVirtualStringTree
                Width = 676
                Height = 149
                Font.Name = 'Tahoma'
                ExplicitWidth = 676
                ExplicitHeight = 149
                DefaultText = ''
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            inherited frameAllAttachments: TframeAllAttachments
              inherited vstTree: TVirtualStringTree
                Font.Name = 'Tahoma'
                DefaultText = ''
              end
              inherited tbFileSearch: TToolBar
                inherited pnlFileSearch: TPanel
                  inherited edtPath: TButtonedEdit
                    Height = 22
                    ExplicitHeight = 22
                  end
                  inherited cbExt: TComboBox
                    Height = 22
                    ExplicitHeight = 22
                  end
                end
              end
            end
          end
        end
      end
    end
    object crdSearchDuplicateFiles: TCard
      Left = 1
      Top = 1
      Width = 684
      Height = 502
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 4
      TabOrder = 4
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 684
        Height = 502
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 684
        ExplicitHeight = 502
        inherited tbMain: TToolBar
          Width = 684
          ExplicitWidth = 684
        end
        inherited vstTree: TVirtualStringTree
          Width = 684
          Height = 424
          ExplicitWidth = 684
          ExplicitHeight = 424
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 684
          ExplicitWidth = 684
          inherited pnlFileSearch: TPanel
            ParentColor = True
          end
          inherited btnFileSearch: TToolButton
            Wrap = True
          end
          inherited btnFileBreak: TToolButton
            Left = 0
            Top = 38
            ExplicitLeft = 0
            ExplicitTop = 38
          end
          inherited btnSep04: TToolButton
            Left = 39
            Top = 38
            ExplicitLeft = 39
            ExplicitTop = 38
          end
          inherited btnDeleteSelected: TToolButton
            Left = 47
            Top = 38
            ExplicitLeft = 47
            ExplicitTop = 38
          end
          inherited btnRemoveChecks: TToolButton
            Left = 86
            Top = 38
            ExplicitLeft = 86
            ExplicitTop = 38
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 545
    Width = 936
    Height = 20
    Panels = <>
    ExplicitTop = 544
    ExplicitWidth = 932
  end
  object alSettings: TActionList
    Images = DMImage.vil32
    Left = 152
    Top = 368
    object aToggleSplitPanel: TAction
      OnExecute = aToggleSplitPanelExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 153
    Top = 434
  end
end
