inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 773
  ClientWidth = 1207
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 1219
  ExplicitHeight = 827
  PixelsPerInch = 144
  TextHeight = 15
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 712
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
      Top = 457
      Width = 250
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      Visible = False
      ExplicitTop = 0
    end
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 457
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
              ImageIndex = 8
              ImageName = 'TextBox_32x32'
            end
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
      ExplicitHeight = 455
    end
    object pnlExtendedFilter: TGroupBox
      Left = 0
      Top = 462
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
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
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
    Width = 1207
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 1197
    object lblProject: TLabel
      Left = 250
      Top = 0
      Width = 648
      Height = 41
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
      ExplicitWidth = 5
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
      Left = 898
      Top = 0
      Width = 309
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 888
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
    Width = 957
    Height = 712
    Align = alClient
    ActiveCard = crdProject
    TabOrder = 2
    object crdProject: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdProject'
      CardIndex = 0
      TabOrder = 0
      inline frameProject: TframeProject
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 955
        end
        inherited vstTree: TVirtualStringTree
          Width = 955
          Height = 651
          ExplicitWidth = 955
          ExplicitHeight = 651
          DefaultText = ''
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdPathsToFindFiles'
      CardIndex = 1
      TabOrder = 2
      object splPath: TSplitter
        Left = 0
        Top = 316
        Width = 955
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
        Width = 949
        Height = 310
        Align = alTop
        Caption = 'gbPathes'
        TabOrder = 0
        inline framePathes: TframePathes
          Left = 2
          Top = 17
          Width = 945
          Height = 291
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 945
          ExplicitHeight = 291
          inherited tbMain: TToolBar
            Width = 945
            ExplicitWidth = 945
          end
          inherited vstTree: TVirtualStringTree
            Width = 945
            Height = 232
            ExplicitWidth = 945
            ExplicitHeight = 232
            DefaultText = ''
          end
        end
      end
      object gbSorter: TGroupBox
        Left = 0
        Top = 319
        Width = 955
        Height = 391
        Align = alClient
        Caption = 'gbSorter'
        TabOrder = 1
        inline frameSorter: TframeSorter
          Left = 2
          Top = 17
          Width = 951
          Height = 372
          Margins.Left = 5
          Margins.Top = 5
          Margins.Right = 5
          Margins.Bottom = 5
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 17
          ExplicitWidth = 951
          ExplicitHeight = 372
          inherited tbMain: TToolBar
            Width = 951
            ExplicitWidth = 951
          end
          inherited vstTree: TVirtualStringTree
            Width = 951
            Height = 313
            ExplicitWidth = 951
            ExplicitHeight = 313
            DefaultText = ''
          end
        end
      end
    end
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdRegExpParameters'
      CardIndex = 2
      TabOrder = 1
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 955
        end
        inherited vstTree: TVirtualStringTree
          Width = 955
          Height = 628
          ExplicitWidth = 955
          ExplicitHeight = 628
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 955
          ExplicitWidth = 955
          inherited pnlSettings: TPanel
            inherited cbSetOfTemplates: TComboBox
              Height = 23
              ExplicitHeight = 23
            end
          end
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdCommonParams'
      CardIndex = 3
      TabOrder = 3
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 945
        end
        inherited grdCommonParams: TGridPanel
          Width = 955
          Height = 651
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
              Control = frameSettings.lblDeleteAttachments
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
              Row = 1
            end
            item
              Column = 1
              Control = frameSettings.cbDeleteAttachments
              Row = 2
            end
            item
              Column = 0
              Control = frameSettings.ShapeDividingLine
              Row = 3
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
            end
            item
              Column = 0
              Control = frameSettings.lblStyle
              Row = 4
            end
            item
              Column = 1
              Control = frameSettings.cbStyle
              Row = 4
            end>
          ExplicitWidth = 945
          ExplicitHeight = 649
          inherited lblLanguage: TLabel
            ExplicitLeft = 265
            ExplicitWidth = 52
            ExplicitHeight = 15
          end
          inherited lblExtensions: TLabel
            ExplicitLeft = 189
            ExplicitWidth = 128
            ExplicitHeight = 15
          end
          inherited lblDeleteAttachments: TLabel
            ExplicitLeft = 144
            ExplicitWidth = 173
            ExplicitHeight = 15
          end
          inherited cbLanguage: TComboBox
            Height = 23
            ExplicitHeight = 23
          end
          inherited edtExtensions: TEdit
            ExplicitHeight = 23
          end
          inherited cbDeleteAttachments: TCheckBox
            ExplicitTop = 73
          end
          inherited lblMaxSize: TLabel
            ExplicitLeft = 190
            ExplicitWidth = 127
            ExplicitHeight = 15
          end
          inherited lblLogWriteActive: TLabel
            ExplicitLeft = 209
            ExplicitWidth = 108
            ExplicitHeight = 15
          end
          inherited lblNumberOfDays: TLabel
            ExplicitLeft = 79
            ExplicitWidth = 238
            ExplicitHeight = 15
          end
          inherited edtMaxSize: TNumberBox
            ExplicitHeight = 23
          end
          inherited edtNumberOfDays: TNumberBox
            ExplicitHeight = 23
          end
          inherited lblStyle: TLabel
            ExplicitLeft = 292
            ExplicitWidth = 25
            ExplicitHeight = 15
          end
          inherited cbStyle: TComboBox
            Height = 23
            ExplicitHeight = 23
          end
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdResultView'
      CardIndex = 4
      TabOrder = 4
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 955
        end
        inherited pcMain: TPageControl
          Width = 955
          Height = 710
          ExplicitWidth = 955
          ExplicitHeight = 710
          inherited tsEmail: TTabSheet
            ExplicitTop = 26
            ExplicitWidth = 947
            ExplicitHeight = 680
            inherited splInfo: TSplitter
              Top = 395
              Width = 947
              ExplicitTop = 236
              ExplicitWidth = 730
            end
            inherited pcInfo: TPageControl
              Top = 400
              Width = 947
              ExplicitTop = 400
              ExplicitWidth = 947
              inherited tsBodyText: TTabSheet
                ExplicitTop = 26
                ExplicitHeight = 250
              end
              inherited tsPlainText: TTabSheet
                ExplicitTop = 26
                ExplicitHeight = 250
              end
              inherited tsHtmlText: TTabSheet
                ExplicitTop = 26
                ExplicitWidth = 939
                ExplicitHeight = 250
                inherited wbBody: TWebBrowser
                  Width = 939
                  ExplicitWidth = 1244
                  ExplicitHeight = 375
                  ControlData = {
                    4C000000B34000003A1100000000000000000000000000000000000000000000
                    000000004C000000000000000000000001000000E0D057007335CF11AE690800
                    2B2E12620A000000000000004C0000000114020000000000C000000000000046
                    8000000000000000000000000000000000000000000000000000000000000000
                    00000000000000000100000000000000000000000000000000000000}
                end
              end
              inherited tsAttachments: TTabSheet
                ExplicitTop = 26
                ExplicitHeight = 250
                inherited frameAttachments: TframeAttachments
                  Height = 250
                  ParentFont = False
                  ExplicitHeight = 250
                  inherited vstTree: TVirtualStringTree
                    Height = 191
                    ExplicitHeight = 191
                    DefaultText = ''
                  end
                end
              end
            end
            inherited frameEmails: TframeEmails
              Width = 947
              Height = 395
              ParentFont = False
              ExplicitWidth = 947
              ExplicitHeight = 395
              inherited tbMain: TToolBar
                Width = 947
                ExplicitWidth = 947
              end
              inherited vstTree: TVirtualStringTree
                Width = 947
                Height = 336
                ExplicitWidth = 947
                ExplicitHeight = 336
                DefaultText = ''
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            ExplicitTop = 26
            ExplicitHeight = 420
            inherited frameAllAttachments: TframeAllAttachments
              Height = 420
              ParentFont = False
              ExplicitHeight = 420
              inherited vstTree: TVirtualStringTree
                Height = 322
                ExplicitTop = 98
                ExplicitHeight = 322
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
      Width = 955
      Height = 710
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 5
      TabOrder = 5
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 955
        end
        inherited vstTree: TVirtualStringTree
          Width = 955
          Height = 612
          ExplicitTop = 98
          ExplicitWidth = 955
          ExplicitHeight = 612
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 955
          ExplicitWidth = 955
          inherited pnlFileSearch: TPanel
            inherited edtPath: TButtonedEdit
              Height = 23
              ExplicitHeight = 23
            end
            inherited cbExt: TComboBox
              Height = 23
              ExplicitHeight = 23
            end
          end
        end
      end
    end
    object crdBruteForce: TCard
      Left = 1
      Top = 1
      Width = 955
      Height = 710
      Caption = 'crdBruteForce'
      CardIndex = 6
      TabOrder = 6
      inline frameBruteForce: TframeBruteForce
        Left = 0
        Top = 0
        Width = 955
        Height = 710
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 955
        ExplicitHeight = 710
        inherited tbMain: TToolBar
          Width = 955
          ExplicitWidth = 955
        end
        inherited vstTree: TVirtualStringTree
          Width = 955
          Height = 628
          ExplicitWidth = 955
          ExplicitHeight = 628
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 955
          ExplicitWidth = 955
          inherited pnlSettings: TPanel
            inherited edtFileName: TButtonedEdit
              Height = 23
              ExplicitHeight = 23
            end
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 753
    Width = 1207
    Height = 20
    Panels = <>
    ExplicitTop = 751
    ExplicitWidth = 1197
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
