inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 613
  ClientWidth = 986
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 998
  ExplicitHeight = 651
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 552
    AnimationDelay = 20
    CloseStyle = svcCompact
    Color = clMedGray
    CompactWidth = 48
    OpenedWidth = 250
    Placement = svpLeft
    TabOrder = 0
    OnClosed = splViewClosed
    OnOpened = splViewOpened
    object splExtendedFilter: TSplitter
      Left = 0
      Top = 547
      Width = 250
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 300
    end
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 297
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
              ImageIndex = 22
              ImageName = 'TreeView_32x32'
            end
            item
              Caption = 'Edit RegExp parameters'
              ImageIndex = 1
              ImageName = 'Edit_32x32'
            end
            item
              Caption = 'Edit Common Parameters'
              ImageIndex = 60
              ImageName = 'PageSetup_32x32'
            end
            item
              Caption = 'Search'
              ImageIndex = 20
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
              ImageIndex = 78
              ImageName = 'Zoom100_32x32'
            end
            item
              Caption = 'Brute Force'
              ImageIndex = 82
              ImageName = 'winrar_view'
            end
            item
              Caption = 'Open Log File'
              ImageIndex = 67
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
      ExplicitHeight = 296
    end
    object pnlExtendedFilter: TGroupBox
      Left = 0
      Top = 297
      Width = 250
      Height = 250
      Align = alBottom
      Caption = 'Extended filter'
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      Visible = False
      inline frameMatchesFilter: TframeMatchesFilter
        Left = 2
        Top = 17
        Width = 246
        Height = 231
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 2
        ExplicitTop = 17
        ExplicitWidth = 246
        ExplicitHeight = 231
        inherited tbMain: TToolBar
          Width = 246
          ExplicitWidth = 246
        end
        inherited vstTree: TVirtualStringTree
          Width = 246
          Height = 209
          ExplicitWidth = 246
          ExplicitHeight = 209
          Columns = <
            item
              CaptionAlignment = taCenter
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
              Position = 0
              Text = 'Name'
              Width = 242
            end>
          DefaultText = ''
        end
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 986
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 982
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
      Left = 798
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 794
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
    Width = 736
    Height = 552
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 734
        Height = 550
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 734
        ExplicitHeight = 550
        inherited tbMain: TToolBar
          Width = 734
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 734
          Height = 468
          ExplicitWidth = 738
          ExplicitHeight = 469
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 734
          ExplicitWidth = 372
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdPathsToFindFiles'
      CardIndex = 1
      TabOrder = 1
      object splPath: TSplitter
        Left = 0
        Top = 316
        Width = 734
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
        Width = 728
        Height = 310
        Align = alTop
        Caption = 'gbPathes'
        TabOrder = 0
        inline framePathes: TframePathes
          Left = 2
          Top = 17
          Width = 724
          Height = 291
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 724
          ExplicitHeight = 291
          inherited tbMain: TToolBar
            Width = 724
            ExplicitWidth = 720
          end
          inherited vstTree: TVirtualStringTree
            Width = 724
            Height = 252
            ExplicitWidth = 724
            ExplicitHeight = 252
            DefaultText = ''
          end
        end
      end
      object gbSorter: TGroupBox
        Left = 0
        Top = 319
        Width = 734
        Height = 231
        Align = alClient
        Caption = 'gbSorter'
        TabOrder = 1
        inline frameSorter: TframeSorter
          Left = 2
          Top = 17
          Width = 730
          Height = 212
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 730
          ExplicitHeight = 212
          inherited tbMain: TToolBar
            Width = 730
            ExplicitWidth = 726
          end
          inherited vstTree: TVirtualStringTree
            Width = 730
            Height = 173
            ExplicitWidth = 730
            ExplicitHeight = 173
            DefaultText = ''
          end
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 734
        Height = 550
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 734
        ExplicitHeight = 550
        inherited tbMain: TToolBar
          Width = 734
          ExplicitWidth = 730
        end
        inherited grdCommonParams: TGridPanel
          Width = 734
          Height = 511
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
            end
            item
              Column = 0
              Control = frameSettings.Shape1
              Row = 5
            end
            item
              Column = 0
              Control = frameSettings.lblMaxSize
              Row = 7
            end
            item
              Column = 0
              Control = frameSettings.lblLogWriteActive
              Row = 6
            end
            item
              Column = 0
              Control = frameSettings.lblNumberOfDays
              Row = 8
            end
            item
              Column = 1
              Control = frameSettings.cbLogWriteActive
              Row = 6
            end
            item
              Column = 1
              Control = frameSettings.edtMaxSize
              Row = 7
            end
            item
              Column = 1
              Control = frameSettings.edtNumberOfDays
              Row = 8
            end>
          ExplicitWidth = 372
          ExplicitHeight = 339
          inherited edtMaxSize: TNumberBox
            ExplicitTop = 251
          end
          inherited edtNumberOfDays: TNumberBox
            ExplicitTop = 286
          end
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 734
        Height = 550
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 734
        ExplicitHeight = 550
        inherited tbMain: TToolBar
          Width = 734
          ExplicitWidth = 734
        end
        inherited pcMain: TPageControl
          Width = 734
          Height = 550
          ExplicitWidth = 734
          ExplicitHeight = 550
          inherited tsEmail: TTabSheet
            ExplicitWidth = 726
            ExplicitHeight = 520
            inherited splInfo: TSplitter
              Top = 235
              Width = 726
              ExplicitTop = 236
              ExplicitWidth = 730
            end
            inherited pcInfo: TPageControl
              Top = 240
              Width = 726
              ExplicitTop = 240
              ExplicitWidth = 726
              inherited tsHtmlText: TTabSheet
                ExplicitWidth = 718
                inherited wbBody: TWebBrowser
                  Width = 718
                  ExplicitWidth = 722
                  ControlData = {
                    4C000000354A0000D71900000000000000000000000000000000000000000000
                    000000004C000000000000000000000001000000E0D057007335CF11AE690800
                    2B2E126202000000000000004C0000000114020000000000C000000000000046
                    8000000000000000000000000000000000000000000000000000000000000000
                    00000000000000000100000000000000000000000000000000000000}
                end
              end
              inherited tsAttachments: TTabSheet
                inherited frameAttachments: TframeAttachments
                  inherited vstTree: TVirtualStringTree
                    DefaultText = ''
                  end
                end
              end
            end
            inherited frameEmails: TframeEmails
              Width = 726
              Height = 235
              ExplicitWidth = 726
              ExplicitHeight = 235
              inherited tbMain: TToolBar
                Width = 726
                ExplicitWidth = 726
              end
              inherited vstTree: TVirtualStringTree
                Width = 726
                Height = 196
                ExplicitWidth = 726
                ExplicitHeight = 196
                DefaultText = ''
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            inherited frameAllAttachments: TframeAllAttachments
              inherited vstTree: TVirtualStringTree
                DefaultText = ''
              end
            end
          end
        end
      end
    end
    object crdSearchDuplicateFiles: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 4
      TabOrder = 4
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 734
        Height = 550
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 734
        ExplicitHeight = 550
        inherited tbMain: TToolBar
          Width = 734
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 734
          Height = 472
          ExplicitWidth = 738
          ExplicitHeight = 473
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 734
          ExplicitWidth = 372
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
          inherited btnAllUnCheck: TToolButton
            Left = 86
            Top = 38
            ExplicitLeft = 86
            ExplicitTop = 38
          end
          inherited btnAllCheck: TToolButton
            Left = 125
            Top = 38
            ExplicitLeft = 125
            ExplicitTop = 38
          end
        end
      end
    end
    object crdBruteForce: TCard
      Left = 1
      Top = 1
      Width = 734
      Height = 550
      Caption = 'crdBruteForce'
      CardIndex = 5
      TabOrder = 5
      inline frameBruteForce: TframeBruteForce
        Left = 0
        Top = 0
        Width = 734
        Height = 550
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 734
        ExplicitHeight = 550
        inherited tbMain: TToolBar
          Width = 734
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 734
          Height = 468
          ExplicitWidth = 738
          ExplicitHeight = 469
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 734
          ExplicitWidth = 738
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 593
    Width = 986
    Height = 20
    Panels = <>
    ExplicitTop = 592
    ExplicitWidth = 982
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
