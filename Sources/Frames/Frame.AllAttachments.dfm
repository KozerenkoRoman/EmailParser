inherited frameAllAttachments: TframeAllAttachments
  Width = 797
  Height = 448
  ExplicitWidth = 797
  ExplicitHeight = 448
  inherited tbMain: TToolBar
    Width = 797
    ExplicitWidth = 797
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 8
      Style = tbsSeparator
    end
    object btnFilter: TToolButton
      Left = 383
      Top = 0
      Action = aFilter
    end
    object btnOpenEmail: TToolButton
      Left = 422
      Top = 0
      Action = aOpenEmail
    end
    object btnOpenAttachFile: TToolButton
      Left = 461
      Top = 0
      Action = aOpenAttachFile
    end
    object btnOpenParsedText: TToolButton
      Left = 500
      Top = 0
      Action = aOpenParsedText
    end
    object btnSep05: TToolButton
      Left = 539
      Top = 0
      Width = 8
      Caption = 'btnSep05'
      Style = tbsSeparator
    end
    object btnShowSearchBar: TToolButton
      Left = 547
      Top = 0
      Action = aShowSearchBar
    end
  end
  inherited vstTree: TVirtualStringTree
    Top = 78
    Width = 797
    Height = 370
    Header.MainColumn = 0
    Indent = 15
    TreeOptions.AutoOptions = [toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenParsedTextExecute
    OnPaintText = vstTreePaintText
    OnGetImageIndex = vstTreeGetImageIndex
    ExplicitTop = 78
    ExplicitWidth = 797
    ExplicitHeight = 370
    Columns = <
      item
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = '#'
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Email Name'
        Width = 119
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'File Name'
        Width = 130
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 3
        Text = 'Path'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Content Type'
        Width = 129
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 5
        Text = 'Text'
        Width = 172
      end>
    DefaultText = ''
  end
  object tbFileSearch: TToolBar [2]
    Left = 0
    Top = 39
    Width = 797
    Height = 39
    ButtonHeight = 38
    ButtonWidth = 39
    Caption = 'tbFileSearch'
    Images = DMImage.vil32
    TabOrder = 2
    Visible = False
    object pnlFileSearch: TPanel
      Left = 0
      Top = 0
      Width = 539
      Height = 38
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object lblPath: TLabel
        Left = 0
        Top = 0
        Width = 65
        Height = 38
        Align = alLeft
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Path'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = True
        Layout = tlCenter
      end
      object edtPath: TButtonedEdit
        Left = 71
        Top = 8
        Width = 402
        Height = 23
        Images = DMImage.vil16
        RightButton.ImageIndex = 5
        RightButton.ImageName = 'Open_32x32'
        RightButton.Visible = True
        TabOrder = 0
        OnRightButtonClick = edtPathRightButtonClick
      end
      object cbExt: TComboBox
        Left = 474
        Top = 8
        Width = 64
        Height = 23
        ItemIndex = 0
        TabOrder = 1
        Text = '*.*'
        Items.Strings = (
          '*.*'
          '*.opt'
          '*.txt'
          '*.docx'
          '*.pdf'
          '*.xml'
          '*.htm?'
          '*.cfg'
          '*.ini')
      end
    end
    object btnFileSearch: TToolButton
      Left = 539
      Top = 0
      Action = aFileSearch
      ImageIndex = 11
    end
    object btnFileBreak: TToolButton
      Left = 578
      Top = 0
      Action = aFileBreak
      ImageIndex = 12
    end
  end
  inherited alFrame: TActionList
    Left = 100
    inherited aAdd: TAction
      Visible = False
      OnUpdate = aAddUpdate
    end
    inherited aEdit: TAction
      OnUpdate = aAddUpdate
    end
    inherited aDelete: TAction
      Visible = False
      OnUpdate = aAddUpdate
    end
    inherited aSave: TAction
      OnExecute = aSaveExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
    end
    object aOpenAttachFile: TAction [9]
      Hint = 'Open Attach File'
      ImageIndex = 69
      ImageName = 'email_attach'
      OnExecute = aOpenAttachFileExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenParsedText: TAction [10]
      Hint = 'Open Parsed Text'
      ImageIndex = 72
      ImageName = 'email_open'
      OnExecute = aOpenParsedTextExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenEmail: TAction [11]
      ImageIndex = 68
      ImageName = 'email'
      OnExecute = aOpenEmailExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    inherited aExpandAll: TAction
      OnUpdate = aExpandAllUpdate
    end
    inherited aCollapseAll: TAction
      OnUpdate = aExpandAllUpdate
    end
    object aFilter: TAction
      AutoCheck = True
      ImageIndex = 3
      ImageName = 'MasterFilter_32x32'
      OnExecute = aFilterExecute
      OnUpdate = aFileSearchUpdate
    end
    object aFileSearch: TAction
      ImageIndex = 12
      ImageName = 'lightning'
      OnExecute = aFileSearchExecute
      OnUpdate = aFileSearchUpdate
    end
    object aFileBreak: TAction
      ImageIndex = 13
      ImageName = 'lightning_delete'
      OnExecute = aFileBreakExecute
    end
    object aShowSearchBar: TAction
      AutoCheck = True
      ImageIndex = 76
      ImageName = 'toolbar_add'
      OnExecute = aShowSearchBarExecute
    end
  end
  object SaveDialogAttachment: TSaveDialog
    Filter = 'All files|*.*'
    Left = 200
    Top = 100
  end
  object dlgFileSearch: TFileOpenDialog
    DefaultExtension = '*.*'
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'All files'
        FileMask = '*.*'
      end
      item
        DisplayName = 'Opt'
        FileMask = '*.opt'
      end>
    Options = [fdoPickFolders, fdoPathMustExist]
    Left = 200
    Top = 168
  end
end
