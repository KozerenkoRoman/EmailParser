inherited frmMain: TfrmMain
  Caption = 'Email Parser'
  ClientHeight = 643
  ClientWidth = 1170
  Constraints.MinHeight = 500
  Constraints.MinWidth = 600
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  ExplicitWidth = 1182
  ExplicitHeight = 681
  TextHeight = 13
  object splView: TSplitView
    Left = 0
    Top = 41
    Width = 250
    Height = 582
    Color = clMedGray
    OpenedWidth = 250
    Placement = svpLeft
    TabOrder = 0
    ExplicitHeight = 581
    object catMenuItems: TCategoryButtons
      Left = 0
      Top = 0
      Width = 250
      Height = 582
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
          Caption = 'Main'
          Color = clSilver
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
          TextColor = clWindowFrame
        end
        item
          Caption = 'Utils'
          Color = clSilver
          Collapsed = False
          Items = <
            item
              Action = aSearchDuplicateFiles
            end
            item
              Action = aOpenLogFile
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
      ExplicitHeight = 581
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1170
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 1986047
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 1166
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
      Left = 982
      Top = 0
      Width = 188
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 978
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
    Width = 920
    Height = 582
    Align = alClient
    ActiveCard = crdPathsToFindScripts
    TabOrder = 2
    object crdRegExpParameters: TCard
      Left = 1
      Top = 1
      Width = 918
      Height = 580
      Caption = 'crdRegExpParameters'
      CardIndex = 0
      TabOrder = 0
      inline frameRegExp: TframeRegExp
        Left = 0
        Top = 0
        Width = 918
        Height = 580
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 918
        ExplicitHeight = 580
        inherited tbMain: TToolBar
          Width = 918
          ExplicitWidth = 918
        end
        inherited vstTree: TVirtualStringTree
          Width = 918
          Height = 498
          Font.Height = -11
          Font.Name = 'Tahoma'
          ExplicitWidth = 918
          ExplicitHeight = 498
          DefaultText = ''
        end
        inherited tbSettings: TToolBar
          Width = 918
          ExplicitWidth = 918
          inherited pnlSettings: TPanel
            inherited cbSetOfTemplates: TComboBox
              Height = 21
              ExplicitHeight = 21
            end
          end
        end
      end
    end
    object crdPathsToFindScripts: TCard
      Left = 1
      Top = 1
      Width = 918
      Height = 580
      Caption = 'crdPathsToFindFiles'
      CardIndex = 1
      TabOrder = 1
      object splPath: TSplitter
        Left = 0
        Top = 316
        Width = 918
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
        Width = 912
        Height = 310
        Align = alTop
        Caption = 'gbPathes'
        TabOrder = 0
        inline framePathes: TframePathes
          Left = 2
          Top = 15
          Width = 908
          Height = 293
          Align = alClient
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 15
          ExplicitWidth = 908
          ExplicitHeight = 293
          inherited tbMain: TToolBar
            Width = 908
            ExplicitWidth = 904
          end
          inherited vstTree: TVirtualStringTree
            Width = 908
            Height = 254
            ExplicitWidth = 908
            ExplicitHeight = 254
            DefaultText = ''
          end
        end
      end
      object gbSorter: TGroupBox
        Left = 0
        Top = 319
        Width = 918
        Height = 261
        Align = alClient
        Caption = 'gbSorter'
        TabOrder = 1
        inline frameSorter: TframeSorter
          Left = 2
          Top = 15
          Width = 914
          Height = 244
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 2
          ExplicitTop = 15
          ExplicitWidth = 914
          ExplicitHeight = 244
          inherited tbMain: TToolBar
            Width = 914
            ExplicitWidth = 910
          end
          inherited vstTree: TVirtualStringTree
            Width = 914
            Height = 205
            ExplicitWidth = 914
            ExplicitHeight = 205
            DefaultText = ''
          end
        end
      end
    end
    object crdCommonParams: TCard
      Left = 1
      Top = 1
      Width = 918
      Height = 580
      Caption = 'crdCommonParams'
      CardIndex = 2
      TabOrder = 2
      inline frameSettings: TframeSettings
        Left = 0
        Top = 0
        Width = 918
        Height = 580
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        ExplicitWidth = 918
        ExplicitHeight = 580
        inherited tbMain: TToolBar
          Width = 918
          ExplicitWidth = 918
        end
        inherited grdCommonParams: TGridPanel
          Width = 918
          Height = 541
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
          ExplicitWidth = 918
          ExplicitHeight = 541
          inherited edtPathForAttachments: TButtonedEdit
            Width = 96
            ExplicitWidth = 96
            ExplicitHeight = 25
          end
        end
      end
    end
    object crdResultView: TCard
      Left = 1
      Top = 1
      Width = 918
      Height = 580
      Caption = 'crdResultView'
      CardIndex = 3
      TabOrder = 3
      inline frameResultView: TframeResultView
        Left = 0
        Top = 0
        Width = 918
        Height = 580
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
        ExplicitWidth = 918
        ExplicitHeight = 580
        inherited tbMain: TToolBar
          Width = 918
          ExplicitWidth = 918
        end
        inherited pcMain: TPageControl
          Width = 918
          Height = 580
          ExplicitWidth = 918
          ExplicitHeight = 580
          inherited tsEmail: TTabSheet
            ExplicitTop = 25
            ExplicitWidth = 910
            ExplicitHeight = 551
            inherited splInfo: TSplitter
              Top = 266
              Width = 910
              ExplicitTop = 358
              ExplicitWidth = 914
            end
            inherited pcInfo: TPageControl
              Top = 271
              Width = 910
              ExplicitTop = 271
              ExplicitWidth = 910
              inherited tsBodyText: TTabSheet
                ExplicitHeight = 252
                inherited memTextBody: TMemo
                  Height = 252
                  ExplicitHeight = 252
                end
              end
              inherited tsPlainText: TTabSheet
                ExplicitHeight = 252
                inherited memTextPlain: TMemo
                  Height = 252
                  ExplicitHeight = 252
                end
              end
              inherited tsHtmlText: TTabSheet
                ExplicitTop = 25
                ExplicitWidth = 902
                ExplicitHeight = 251
                inherited wbBody: TWebBrowser
                  Width = 902
                  Height = 251
                  ExplicitWidth = 902
                  ExplicitHeight = 251
                  ControlData = {
                    4C000000395D0000F11900000000000000000000000000000000000000000000
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
                    Font.Name = 'Tahoma'
                    ExplicitHeight = 213
                    DefaultText = ''
                  end
                end
              end
            end
            inherited frameEmails: TframeEmails
              Width = 910
              Height = 266
              ExplicitWidth = 910
              ExplicitHeight = 266
              inherited tbMain: TToolBar
                Width = 910
                ExplicitWidth = 910
              end
              inherited vstTree: TVirtualStringTree
                Width = 910
                Height = 227
                Font.Name = 'Tahoma'
                ExplicitWidth = 910
                ExplicitHeight = 227
                DefaultText = ''
              end
            end
          end
          inherited tsAllAttachments: TTabSheet
            ExplicitHeight = 645
            inherited frameAllAttachments: TframeAllAttachments
              Height = 645
              ExplicitHeight = 645
              inherited vstTree: TVirtualStringTree
                Height = 567
                Font.Name = 'Tahoma'
                ExplicitHeight = 567
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
      Width = 918
      Height = 580
      Caption = 'crdSearchDuplicateFiles'
      CardIndex = 4
      TabOrder = 4
      inline frameDuplicateFiles: TframeDuplicateFiles
        Left = 0
        Top = 0
        Width = 918
        Height = 580
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 918
        ExplicitHeight = 580
        inherited tbMain: TToolBar
          Width = 918
          ExplicitWidth = 918
        end
        inherited vstTree: TVirtualStringTree
          Width = 918
          Height = 502
          ExplicitWidth = 918
          ExplicitHeight = 502
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 918
          ExplicitWidth = 918
          inherited pnlFileSearch: TPanel
            ParentColor = True
            inherited edtPath: TButtonedEdit
              Height = 21
              ExplicitHeight = 21
            end
            inherited cbExt: TComboBox
              Height = 21
              ExplicitHeight = 21
            end
          end
        end
      end
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 623
    Width = 1170
    Height = 20
    Panels = <>
    ExplicitTop = 622
    ExplicitWidth = 1166
  end
  object alSettings: TActionList
    Images = DMImage.vil32
    Left = 104
    Top = 368
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
    object aSearchDuplicateFiles: TAction
      Caption = 'Search duplicate files'
      ImageIndex = 81
      ImageName = 'Zoom100_32x32'
      OnExecute = aSearchDuplicateFilesExecute
    end
    object aEditCommonParameters: TAction
      Caption = 'Edit Common Parameters'
      ImageIndex = 63
      ImageName = 'PageSetup_32x32'
      OnExecute = aEditCommonParametersExecute
    end
    object aOpenLogFile: TAction
      Caption = 'Open Log File'
      ImageIndex = 70
      ImageName = 'file_extension_log'
      OnExecute = aOpenLogFileExecute
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 105
    Top = 434
  end
end
