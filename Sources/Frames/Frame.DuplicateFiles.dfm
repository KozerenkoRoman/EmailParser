inherited frameDuplicateFiles: TframeDuplicateFiles
  Width = 869
  Height = 424
  ExplicitWidth = 869
  ExplicitHeight = 424
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 869
    ExplicitWidth = 869
    inherited btnAdd: TToolButton
      Action = nil
      Visible = False
    end
    inherited btnSep01: TToolButton
      Visible = False
    end
    inherited btnColumnSettings: TToolButton [7]
      Left = 211
      ExplicitLeft = 211
    end
    inherited btnSep03: TToolButton [8]
      Left = 250
      ExplicitLeft = 250
    end
    inherited btnPrint: TToolButton
      Left = 258
      ExplicitLeft = 258
    end
    inherited btnExportToExcel: TToolButton [10]
      Left = 297
    end
    inherited btnExportToCSV: TToolButton [11]
      Left = 336
    end
  end
  inherited vstTree: TVirtualStringTree
    Top = 78
    Width = 869
    Height = 346
    Alignment = taRightJustify
    Header.MainColumn = 0
    Indent = 15
    TreeOptions.AutoOptions = [toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = vstTreeDblClick
    OnPaintText = vstTreePaintText
    ExplicitTop = 78
    ExplicitWidth = 869
    ExplicitHeight = 346
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'File Name'
        Width = 180
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Path'
        Width = 310
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Date'
        Width = 208
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 4
        Text = 'Size'
        Width = 172
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'Info'
        Width = 131
      end>
    DefaultText = ''
  end
  object tbFileSearch: TToolBar [2]
    Left = 0
    Top = 39
    Width = 869
    Height = 39
    ButtonHeight = 38
    ButtonWidth = 39
    Caption = 'tbFileSearch'
    Images = DMImage.vil32
    TabOrder = 2
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
    object btnSep04: TToolButton
      Left = 617
      Top = 0
      Width = 8
      ImageName = 'all_check_boxes'
      Style = tbsSeparator
    end
    object btnDeleteSelected: TToolButton
      Left = 625
      Top = 0
      Action = aDeleteSelected
      ImageIndex = 62
    end
    object btnAllUnCheck: TToolButton
      Left = 664
      Top = 0
      Action = aAllUnCheck
    end
    object btnAllCheck: TToolButton
      Left = 703
      Top = 0
      Action = aAllCheck
    end
  end
  inherited alFrame: TActionList
    Left = 100
    inherited aDelete: TAction
      Visible = False
    end
    inherited aSave: TAction
      Visible = False
    end
    inherited aRefresh: TAction
      Visible = False
    end
    object aFileSearch: TAction
      ImageIndex = 12
      ImageName = 'lightning'
      OnExecute = aFileSearchExecute
    end
    object aFileBreak: TAction
      ImageIndex = 13
      ImageName = 'lightning_delete'
      OnExecute = aFileBreakExecute
    end
    object aDeleteSelected: TAction
      ImageIndex = 65
      ImageName = 'DeleteList2_32x32'
      OnExecute = aDeleteSelectedExecute
      OnUpdate = aDeleteSelectedUpdate
    end
    object aAllUnCheck: TAction
      ImageIndex = 81
      ImageName = 'check_box_uncheck2'
      OnExecute = aAllUnCheckExecute
      OnUpdate = aDeleteSelectedUpdate
    end
    object aAllCheck: TAction
      ImageIndex = 80
      ImageName = 'check_boxes2'
      OnExecute = aAllCheckExecute
      OnUpdate = aAllCheckUpdate
    end
    object aOpenLocation: TAction
      Caption = 'Open Location'
      ImageIndex = 5
      ImageName = 'Open_32x32'
      OnExecute = aOpenLocationExecute
    end
    object aOpenFile: TAction
      Caption = 'Open File'
      OnExecute = aOpenFileExecute
    end
  end
  inherited pmFrame: TPopupMenu
    object miSep01: TMenuItem
      Caption = '-'
    end
    object miOpenFile: TMenuItem
      Action = aOpenFile
      Default = True
    end
    object miOpenLocation: TMenuItem
      Action = aOpenLocation
    end
  end
  object dlgFileSearch: TFileOpenDialog
    DefaultExtension = '*.*'
    FavoriteLinks = <>
    FileName = 'D:\Work\EmailParser\Sources\Frames'
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
