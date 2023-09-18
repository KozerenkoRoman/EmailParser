inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 614
  ClientWidth = 990
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 1002
  ExplicitHeight = 652
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 553
    AnimationDelay = 20
    CloseStyle = svcCompact
    Color = clMedGray
    CompactWidth = 47
    OpenedWidth = 250
    Placement = svpLeft
    TabOrder = 0
    OnClosed = splViewClosed
    OnOpened = splViewOpened
    object splMatchesFilter: TSplitter
      Left = 0
      Top = 295
      Width = 250
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 289
      ExplicitWidth = 240
    end
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 295
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
      ExplicitHeight = 294
    end
    object pnlMatchesFilter: TPanel
      Left = 0
      Top = 303
      Width = 250
      Height = 250
      Align = alBottom
      BevelOuter = bvNone
      Color = clMedGray
      TabOrder = 1
      Visible = False
      inline frameMatchesFilter: TframeMatchesFilter
        Left = 0
        Top = 0
        Width = 250
        Height = 250
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 250
        ExplicitHeight = 250
        inherited tbMain: TToolBar
          Width = 250
          ExplicitWidth = 250
          inherited btnSep02: TToolButton
            Left = 0
            Wrap = True
            ExplicitLeft = 0
            ExplicitHeight = 31
          end
          inherited btnExportToExcel: TToolButton
            Left = 0
            Top = 31
            ExplicitLeft = 0
            ExplicitTop = 31
          end
          inherited btnExportToCSV: TToolButton
            Left = 23
            Top = 31
            ExplicitLeft = 23
            ExplicitTop = 31
          end
          inherited btnPrint: TToolButton
            Left = 46
            Top = 31
            ExplicitLeft = 46
            ExplicitTop = 31
          end
          inherited btnSep03: TToolButton
            Left = 69
            Top = 31
            ExplicitLeft = 69
            ExplicitTop = 31
          end
          inherited btnColumnSettings: TToolButton
            Left = 77
            Top = 31
            ExplicitLeft = 77
            ExplicitTop = 31
          end
          inherited btnAllCheck: TToolButton
            Left = 100
            Top = 31
            ExplicitLeft = 100
            ExplicitTop = 31
          end
          inherited btnAllUnCheck: TToolButton
            Left = 123
            Top = 31
            ExplicitLeft = 123
            ExplicitTop = 31
          end
          inherited btnFilter: TToolButton
            Left = 146
            Top = 31
            ExplicitLeft = 146
            ExplicitTop = 31
          end
        end
        inherited vstTree: TVirtualStringTree
          Width = 250
          Height = 226
          ExplicitWidth = 250
          ExplicitHeight = 226
          Columns = <
            item
              CaptionAlignment = taCenter
              Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
              Position = 0
              Text = 'Name'
              Width = 246
            end>
          DefaultText = ''
        end
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 990
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 986
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
      Left = 802
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 798
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
    Width = 740
    Height = 553
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 738
      Height = 551
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 738
        Height = 551
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 738
        ExplicitHeight = 551
        inherited tbMain: TToolBar
          Width = 738
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 738
          Height = 469
          Font.Height = -11
          Font.Name = 'Tahoma'
          ExplicitWidth = 738
          ExplicitHeight = 469
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 738
          ExplicitWidth = 738
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
      Width = 738
      Height = 551
      Caption = 'crdPathsToFindFiles'
      CardIndex = 1
      TabOrder = 1
      object splPath: TSplitter
        Left = 0
        Top = 316
        Width = 738
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
        Width = 732
        Height = 310
        Align = alTop
        Caption = 'gbPathes'
        TabOrder = 0
        inline framePathes: TframePathes
          Left = 2
          Top = 17
          Width = 728
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
          ExplicitWidth = 728
          ExplicitHeight = 291
          inherited tbMain: TToolBar
            Width = 728
            ExplicitWidth = 724
          end
          inherited vstTree: TVirtualStringTree
            Width = 728
            Height = 252
            ExplicitWidth = 728
            ExplicitHeight = 252
            DefaultText = ''
          end
        end
      end
      object gbSorter: TGroupBox
        Left = 0
        Top = 319
        Width = 738
        Height = 232
        Align = alClient
        Caption = 'gbSorter'
        TabOrder = 1
        inline frameSorter: TframeSorter
          Left = 2
          Top = 17
          Width = 734
          Height = 213
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 734
          ExplicitHeight = 213
          inherited tbMain: TToolBar
            Width = 734
            ExplicitWidth = 730
          end
          inherited vstTree: TVirtualStringTree
            Width = 734
            Height = 174
            ExplicitWidth = 734
            ExplicitHeight = 174
            DefaultText = ''
          end
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 738
      Height = 551
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 738
        Height = 551
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 738
        ExplicitHeight = 551
        inherited tbMain: TToolBar
          Width = 738
          ExplicitWidth = 738
        end
        inherited grdCommonParams: TGridPanel
          Width = 738
          Height = 512
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
          ExplicitWidth = 738
          ExplicitHeight = 512
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
            ExplicitHeight = 22
          end
          inherited edtExtensions: TEdit
            Height = 22
            ExplicitHeight = 22
          end
          inherited edtPathForAttachments: TButtonedEdit
            Height = 22
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
      Width = 738
      Height = 551
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 738
        Height = 551
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
        ExplicitWidth = 738
        ExplicitHeight = 551
        inherited tbMain: TToolBar
          Width = 738
          ExplicitWidth = 738
        end
        inherited pcMain: TPageControl
          Width = 738
          Height = 551
          ExplicitWidth = 738
          ExplicitHeight = 551
          inherited tsEmail: TTabSheet
            ExplicitTop = 25
            ExplicitWidth = 730
            ExplicitHeight = 522
            inherited splInfo: TSplitter
              Top = 237
              Width = 730
              ExplicitTop = 358
              ExplicitWidth = 734
            end
            inherited pcInfo: TPageControl
              Top = 242
              Width = 730
              ExplicitTop = 242
              ExplicitWidth = 730
              inherited tsHtmlText: TTabSheet
                ExplicitTop = 25
                ExplicitWidth = 722
                ExplicitHeight = 251
                inherited wbBody: TWebBrowser
                  Width = 722
                  Height = 251
                  ExplicitWidth = 722
                  ExplicitHeight = 251
                  ControlData = {
                    4C0000009F4A0000F11900000000000000000000000000000000000000000000
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
              Width = 730
              Height = 237
              ExplicitWidth = 730
              ExplicitHeight = 237
              inherited tbMain: TToolBar
                Width = 730
                ExplicitWidth = 730
                inherited btnPrint: TToolButton [0]
                  Left = 0
                  ExplicitLeft = 0
                end
                inherited btnSep03: TToolButton [1]
                  Left = 0
                  Wrap = True
                  ExplicitLeft = 0
                  ExplicitHeight = 47
                end
                inherited btnOpenEmail: TToolButton [2]
                  Left = 0
                  Top = 47
                  ExplicitLeft = 0
                  ExplicitTop = 47
                end
                inherited btnSep05: TToolButton [3]
                  Left = 39
                  Top = 47
                  ExplicitLeft = 39
                  ExplicitTop = 47
                end
                inherited btnFilter: TToolButton [4]
                  Left = 47
                  Top = 47
                  ExplicitLeft = 47
                  ExplicitTop = 47
                end
                inherited btnBreak: TToolButton [5]
                  Left = 86
                  Top = 47
                  ExplicitLeft = 86
                  ExplicitTop = 47
                end
                inherited btnSep04: TToolButton [6]
                  Left = 125
                  Top = 47
                  ExplicitLeft = 125
                  ExplicitTop = 47
                end
                inherited btnSearch: TToolButton [7]
                  Left = 133
                  Top = 47
                  ExplicitLeft = 133
                  ExplicitTop = 47
                end
                inherited btnAdd: TToolButton [8]
                  Left = 172
                  Top = 47
                  ExplicitLeft = 172
                  ExplicitTop = 47
                end
                inherited btnEdit: TToolButton [9]
                  Left = 211
                  Top = 47
                  ExplicitLeft = 211
                  ExplicitTop = 47
                end
                inherited btnDelete: TToolButton [10]
                  Left = 250
                  Top = 47
                  ExplicitLeft = 250
                  ExplicitTop = 47
                end
                inherited btnSave: TToolButton [11]
                  Left = 289
                  Top = 47
                  ExplicitLeft = 289
                  ExplicitTop = 47
                end
                inherited btnSep01: TToolButton [12]
                  Left = 328
                  Top = 47
                  ExplicitLeft = 328
                  ExplicitTop = 47
                end
                inherited btnRefresh: TToolButton [13]
                  Left = 336
                  Top = 47
                  ExplicitLeft = 336
                  ExplicitTop = 47
                end
                inherited btnColumnSettings: TToolButton [14]
                  Left = 375
                  Top = 47
                  ExplicitLeft = 375
                  ExplicitTop = 47
                end
                inherited btnSep02: TToolButton [15]
                  Left = 414
                  Top = 47
                  ExplicitLeft = 414
                  ExplicitTop = 47
                end
                inherited btnExportToExcel: TToolButton [16]
                  Left = 422
                  Top = 47
                  ExplicitLeft = 422
                  ExplicitTop = 47
                end
                inherited btnExportToCSV: TToolButton [17]
                  Left = 461
                  Top = 47
                  ExplicitLeft = 461
                  ExplicitTop = 47
                end
              end
              inherited vstTree: TVirtualStringTree
                Width = 730
                Height = 198
                Font.Name = 'Tahoma'
                ExplicitWidth = 730
                ExplicitHeight = 198
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
      Width = 738
      Height = 551
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 4
      TabOrder = 4
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 738
        Height = 551
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 738
        ExplicitHeight = 551
        inherited tbMain: TToolBar
          Width = 738
          ExplicitWidth = 738
        end
        inherited vstTree: TVirtualStringTree
          Width = 738
          Height = 473
          ExplicitWidth = 738
          ExplicitHeight = 473
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 738
          ExplicitWidth = 738
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
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 594
    Width = 990
    Height = 20
    Panels = <>
    ExplicitTop = 593
    ExplicitWidth = 986
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
