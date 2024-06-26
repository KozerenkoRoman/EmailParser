inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 666
  ClientWidth = 1044
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 1060
  ExplicitHeight = 705
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 605
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
      Top = 350
      Width = 250
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitLeft = -3
      ExplicitTop = 378
    end
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 350
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
              Caption = 'Project'
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
    end
    object pnlExtendedFilter: TGroupBox
      Left = 0
      Top = 355
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
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
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
    Width = 1044
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 1042
    object lblProject: TLabel
      Left = 250
      Top = 0
      Width = 5
      Height = 19
      Align = alClient
      Alignment = taCenter
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
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
        Left = 5
        Top = 3
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
        Left = 43
        Top = 0
        Width = 207
        Height = 41
        Align = alRight
        AutoSize = False
        Caption = 'Project'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -14
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 44
      end
    end
    object pnlSrchBox: TPanel
      Left = 739
      Top = 0
      Width = 309
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 733
      object srchBox: TButtonedEdit
        Left = 2
        Top = 8
        Width = 303
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        Images = DMImage.vilFileExt
        LeftButton.ImageIndex = 100
        LeftButton.ImageName = 'remove-bold'
        ParentFont = False
        RightButton.ImageIndex = 99
        RightButton.ImageName = 'search'
        RightButton.Visible = True
        TabOrder = 0
        OnChange = srchBoxChange
        OnLeftButtonClick = srchBoxLeftButtonClick
        OnRightButtonClick = srchBoxRightButtonClick
      end
    end
  end
  object pnlCard: TCardPanel
    Left = 250
    Top = 41
    Width = 794
    Height = 605
    Align = alClient
    ActiveCard = crdProject
    TabOrder = 2
    ExplicitWidth = 798
    ExplicitHeight = 606
    object crdProject: TCard
      Left = 1
      Top = 1
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdProject'
      CardIndex = 0
      TabOrder = 0
      ExplicitWidth = 796
      ExplicitHeight = 604
      object splProject: TSplitter
        Left = 0
        Top = 347
        Width = 792
        Height = 6
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 281
        ExplicitWidth = 794
      end
      inline frameProject: TframeProject
        Left = 0
        Top = 0
        Width = 792
        Height = 347
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 792
        ExplicitHeight = 347
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 794
        end
        inherited vstTree: TVirtualStringTree
          Width = 792
          Height = 308
          ExplicitWidth = 794
          ExplicitHeight = 309
          DefaultText = ''
        end
      end
      object pcPathsAndSorter: TPageControl
        Left = 0
        Top = 353
        Width = 792
        Height = 250
        ActivePage = tsPathes
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 354
        ExplicitWidth = 796
        object tsPathes: TTabSheet
          Caption = 'tsPathes'
          inline framePathes: TframePathes
            Left = 0
            Top = 0
            Width = 784
            Height = 220
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            ExplicitWidth = 784
            ExplicitHeight = 220
            inherited tbMain: TToolBar
              Width = 784
              ExplicitWidth = 786
              inherited btnExportToExcel: TToolButton
                Left = 211
                ExplicitLeft = 211
              end
              inherited btnExportToCSV: TToolButton
                Left = 250
                ExplicitLeft = 250
              end
              inherited btnPrint: TToolButton
                Left = 289
                ExplicitLeft = 289
              end
              inherited btnSep03: TToolButton
                Left = 328
                ExplicitLeft = 328
              end
              inherited btnColumnSettings: TToolButton
                Left = 336
                ExplicitLeft = 336
              end
            end
            inherited vstTree: TVirtualStringTree
              Width = 784
              Height = 181
              ExplicitTop = 39
              ExplicitWidth = 786
              ExplicitHeight = 181
              DefaultText = ''
            end
          end
        end
        object tsSorter: TTabSheet
          Caption = 'tsSorter'
          ImageIndex = 1
          inline frameSorter: TframeSorter
            Left = 0
            Top = 0
            Width = 784
            Height = 220
            Margins.Left = 2
            Margins.Top = 2
            Margins.Right = 2
            Margins.Bottom = 2
            Align = alClient
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            ExplicitWidth = 784
            ExplicitHeight = 220
            inherited tbMain: TToolBar
              Width = 784
              ExplicitWidth = 786
              inherited btnExportToExcel: TToolButton
                Left = 211
                ExplicitLeft = 211
              end
              inherited btnExportToCSV: TToolButton
                Left = 250
                ExplicitLeft = 250
              end
              inherited btnPrint: TToolButton
                Left = 289
                ExplicitLeft = 289
              end
              inherited btnSep03: TToolButton
                Left = 328
                ExplicitLeft = 328
              end
              inherited btnColumnSettings: TToolButton
                Left = 336
                ExplicitLeft = 336
              end
            end
            inherited vstTree: TVirtualStringTree
              Width = 784
              Height = 181
              ExplicitTop = 39
              ExplicitWidth = 786
              ExplicitHeight = 181
              DefaultText = ''
            end
          end
        end
      end
    end
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdRegExpParameters'
      CardIndex = 1
      TabOrder = 1
      ExplicitWidth = 372
      ExplicitHeight = 378
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 792
        Height = 603
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 372
        ExplicitHeight = 378
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 794
          inherited btnExportToExcel: TToolButton
            Left = 211
            ExplicitLeft = 211
          end
          inherited btnSep04: TToolButton [8]
            Left = 250
            ExplicitLeft = 250
          end
          inherited btnExportToCSV: TToolButton [9]
            Left = 258
            ExplicitLeft = 258
          end
          inherited btnDown: TToolButton [10]
            Left = 297
            ExplicitLeft = 297
          end
          inherited btnUp: TToolButton [11]
            Left = 336
            ExplicitLeft = 336
          end
          inherited btnPrint: TToolButton [12]
            Left = 375
            ExplicitLeft = 375
          end
          inherited btnSep03: TToolButton [13]
            Left = 414
            ExplicitLeft = 414
          end
          inherited btnColumnSettings: TToolButton [14]
            Left = 422
            ExplicitLeft = 422
          end
        end
        inherited vstTree: TVirtualStringTree
          Width = 792
          Height = 521
          ExplicitWidth = 794
          ExplicitHeight = 522
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 792
          ExplicitWidth = 372
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      ExplicitWidth = 372
      ExplicitHeight = 378
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 792
        Height = 603
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 372
        ExplicitHeight = 378
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 790
        end
        inherited grdCommonParams: TGridPanel
          Width = 792
          Height = 564
          ControlCollection = <
            item
              Column = 0
              Control = frameSettings.lblLanguage
              Row = 0
            end
            item
              Column = 0
              Control = frameSettings.lblExtensions
              Row = 2
            end
            item
              Column = 1
              Control = frameSettings.cbLanguage
              Row = 0
            end
            item
              Column = 1
              Control = frameSettings.edtExtensions
              Row = 2
            end
            item
              Column = 0
              Control = frameSettings.ShapeDividingLine01
              Row = 3
            end
            item
              Column = 0
              Control = frameSettings.lblMaxSize
              Row = 5
            end
            item
              Column = 0
              Control = frameSettings.lblLogWriteActive
              Row = 4
            end
            item
              Column = 0
              Control = frameSettings.lblNumberOfDays
              Row = 6
            end
            item
              Column = 1
              Control = frameSettings.cbLogWriteActive
              Row = 4
            end
            item
              Column = 1
              Control = frameSettings.edtMaxSize
              Row = 5
            end
            item
              Column = 1
              Control = frameSettings.edtNumberOfDays
              Row = 6
            end
            item
              Column = 0
              Control = frameSettings.lblStyle
              Row = 1
            end
            item
              Column = 1
              Control = frameSettings.cbStyle
              Row = 1
            end
            item
              Column = 0
              Control = frameSettings.ShapeDividingLine02
              Row = 7
            end
            item
              Column = 0
              Control = frameSettings.lblHTTPClientActive
              Row = 8
            end
            item
              Column = 1
              Control = frameSettings.cbHTTPClientActive
              Row = 8
            end
            item
              Column = 0
              Control = frameSettings.lblHost
              Row = 9
            end
            item
              Column = 0
              Control = frameSettings.lblPassword
              Row = 11
            end
            item
              Column = 0
              Control = frameSettings.lblUser
              Row = 10
            end
            item
              Column = 1
              Control = frameSettings.edtHost
              Row = 9
            end
            item
              Column = 1
              Control = frameSettings.edtUser
              Row = 10
            end
            item
              Column = 1
              Control = frameSettings.edtPassword
              Row = 11
            end>
          ExplicitWidth = 372
          ExplicitHeight = 339
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      ExplicitWidth = 372
      ExplicitHeight = 378
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 792
        Height = 603
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 372
        ExplicitHeight = 378
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 794
        end
        inherited pcMain: TPageControl
          Width = 792
          Height = 603
          ExplicitWidth = 372
          ExplicitHeight = 378
          inherited tsEmail: TTabSheet
            ExplicitWidth = 784
            ExplicitHeight = 573
            inherited splInfo: TSplitter
              Top = 288
              Width = 784
              ExplicitTop = -15
              ExplicitWidth = 632
            end
            inherited pcInfo: TPageControl
              Top = 293
              Width = 784
              ExplicitTop = 293
              ExplicitWidth = 784
              inherited tsHtmlText: TTabSheet
                ExplicitWidth = 776
                inherited wbBody: TWebBrowser
                  Width = 778
                  ExplicitWidth = 778
                  ControlData = {
                    4C00000069500000D71900000000000000000000000000000000000000000000
                    000000004C000000000000000000000001000000E0D057007335CF11AE690800
                    2B2E12620A000000000000004C0000000114020000000000C000000000000046
                    8000000000000000000000000000000000000000000000000000000000000000
                    00000000000000000100000000000000000000000000000000000000}
                end
              end
              inherited tsAttachments: TTabSheet
                inherited frameAttachments: TframeAttachments
                  ParentFont = False
                  inherited tbMain: TToolBar
                    inherited btnExportToExcel: TToolButton
                      Left = 211
                      ExplicitLeft = 211
                    end
                    inherited btnSep04: TToolButton [8]
                      Left = 250
                      ExplicitLeft = 250
                    end
                    inherited btnExportToCSV: TToolButton [9]
                      Left = 258
                      ExplicitLeft = 258
                    end
                    inherited btnOpenAttachFile: TToolButton [10]
                      Left = 297
                      ExplicitLeft = 297
                    end
                    inherited btnOpenParsedText: TToolButton [11]
                      Left = 336
                      ExplicitLeft = 336
                    end
                    inherited btnPrint: TToolButton [12]
                      Left = 375
                      ExplicitLeft = 375
                    end
                    inherited btnSep03: TToolButton [13]
                      Left = 414
                      ExplicitLeft = 414
                    end
                    inherited btnColumnSettings: TToolButton [14]
                      Left = 422
                      ExplicitLeft = 422
                    end
                  end
                  inherited vstTree: TVirtualStringTree
                    ExplicitTop = 39
                    DefaultText = ''
                  end
                end
              end
            end
            inherited frameEmails: TframeEmails
              Width = 784
              Height = 288
              ParentFont = False
              ExplicitWidth = 784
              ExplicitHeight = 288
              inherited tbMain: TToolBar
                Width = 784
                ExplicitWidth = 786
                inherited btnExportToCSV: TToolButton
                  Left = 258
                  ExplicitLeft = 258
                end
                inherited btnSep04: TToolButton [9]
                  Left = 250
                  ExplicitLeft = 250
                end
                inherited btnPrint: TToolButton [10]
                  Left = 375
                  ExplicitLeft = 375
                end
                inherited btnSearch: TToolButton [11]
                  Left = 297
                  ExplicitLeft = 297
                end
                inherited btnBreak: TToolButton [12]
                  Left = 336
                  ExplicitLeft = 336
                end
                inherited btnSep03: TToolButton [13]
                  Left = 453
                  ExplicitLeft = 453
                end
                inherited btnFilter: TToolButton [14]
                  Left = 414
                  ExplicitLeft = 414
                end
                inherited btnColumnSettings: TToolButton [15]
                  Left = 469
                  ExplicitLeft = 469
                end
                inherited btnSep05: TToolButton
                  Left = 461
                  ExplicitLeft = 461
                end
              end
              inherited vstTree: TVirtualStringTree
                Width = 784
                Height = 249
                ExplicitWidth = 786
                ExplicitHeight = 250
                DefaultText = ''
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            inherited frameAllAttachments: TframeAllAttachments
              ParentFont = False
              inherited tbMain: TToolBar
                inherited btnExportToCSV: TToolButton
                  Left = 289
                  ExplicitLeft = 289
                end
                inherited btnPrint: TToolButton
                  Left = 250
                  ExplicitLeft = 250
                end
              end
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
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 4
      TabOrder = 4
      ExplicitWidth = 372
      ExplicitHeight = 378
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 792
        Height = 603
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 372
        ExplicitHeight = 378
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 794
          inherited btnColumnSettings: TToolButton [7]
            Left = 219
            ExplicitLeft = 219
          end
          inherited btnSep03: TToolButton [8]
            Left = 211
            ExplicitLeft = 211
          end
          inherited btnExportToExcel: TToolButton [9]
          end
          inherited btnExportToCSV: TToolButton [10]
          end
          inherited btnPrint: TToolButton [11]
          end
        end
        inherited vstTree: TVirtualStringTree
          Width = 792
          Height = 525
          ExplicitWidth = 794
          ExplicitHeight = 526
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 792
          ExplicitWidth = 372
        end
      end
    end
    object crdBruteForce: TCard
      Left = 1
      Top = 1
      Width = 792
      Height = 603
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Caption = 'crdBruteForce'
      CardIndex = 5
      TabOrder = 5
      inline frameBruteForce: TframeBruteForce
        Left = 0
        Top = 0
        Width = 792
        Height = 603
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 792
        ExplicitHeight = 603
        inherited tbMain: TToolBar
          Width = 792
          ExplicitWidth = 794
          inherited btnExportToExcel: TToolButton
            Left = 211
            ExplicitLeft = 211
          end
          inherited btnSep04: TToolButton [8]
            Left = 250
            ExplicitLeft = 250
          end
          inherited btnExportToCSV: TToolButton [9]
            Left = 258
            ExplicitLeft = 258
          end
          inherited btnDown: TToolButton [10]
            Left = 297
            ExplicitLeft = 297
          end
          inherited btnUp: TToolButton [11]
            Left = 336
            ExplicitLeft = 336
          end
          inherited btnPrint: TToolButton [12]
            Left = 375
            ExplicitLeft = 375
          end
          inherited btnSep05: TToolButton [13]
            Left = 414
            ExplicitLeft = 414
          end
          inherited btnStart: TToolButton [14]
            Left = 422
            ExplicitLeft = 422
          end
          inherited btnSep03: TToolButton [15]
            Left = 461
            ExplicitLeft = 461
          end
          inherited btnColumnSettings: TToolButton [16]
            Left = 469
            ExplicitLeft = 469
          end
        end
        inherited vstTree: TVirtualStringTree
          Width = 792
          Height = 521
          ExplicitWidth = 794
          ExplicitHeight = 522
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 792
          ExplicitWidth = 794
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 646
    Width = 1044
    Height = 20
    Margins.Left = 1
    Margins.Top = 1
    Margins.Right = 1
    Margins.Bottom = 1
    Panels = <>
    ExplicitWidth = 1042
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
  object NotificationCenter: TNotificationCenter
    Left = 531
    Top = 218
  end
  object Taskbar: TTaskbar
    TaskBarButtons = <>
    TabProperties = [AppPeekWhenActive]
    Left = 531
    Top = 282
  end
end
