object frmImportFromXML: TfrmImportFromXML
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight]
  Caption = 'Import From XML'
  ClientHeight = 542
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  ShowHint = True
  OnCreate = FormCreate
  TextHeight = 13
  object pnlBottom: TPanel
    Left = 0
    Top = 500
    Width = 745
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 499
    ExplicitWidth = 741
    DesignSize = (
      745
      42)
    object btnOk: TBitBtn
      Left = 615
      Top = 1
      Width = 108
      Height = 40
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 44
      ImageName = 'tick'
      Images = DMImage.vil32
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 611
    end
  end
  object vstTree: TVirtualStringTree
    Left = 0
    Top = 69
    Width = 745
    Height = 431
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    CustomCheckImages = DMImage.ilCustomCheckImages
    Header.AutoSizeIndex = 0
    Header.Height = 17
    Header.MainColumn = 3
    Header.MaxHeight = 20
    Header.MinHeight = 17
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible]
    Images = DMImage.vilFileExt
    IncrementalSearch = isVisibleOnly
    Indent = 0
    LineStyle = lsSolid
    Margin = 2
    TabOrder = 1
    TextMargin = 3
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoSort, toAutoTristateTracking, toAutoChangeScale]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toEditOnClick, toEditOnDblClick]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedSelection, toShowFilteredNodes]
    TreeOptions.SelectionOptions = [toExtendedFocus, toAlwaysSelectNode]
    OnChecked = vstTreeChecked
    OnFreeNode = vstTreeFreeNode
    OnGetText = vstTreeGetText
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Name'
        Width = 150
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'RegExp Template'
        Width = 300
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        MaxWidth = 500
        MinWidth = 50
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Group index'
        Width = 100
      end
      item
        Alignment = taCenter
        CaptionAlignment = taCenter
        Layout = blGlyphBottom
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'Use Raw Text'
        Width = 103
      end
      item
        Alignment = taCenter
        Position = 4
        Text = 'Type Pattern'
        Width = 200
      end>
  end
  object tbSettings: TToolBar
    Left = 0
    Top = 28
    Width = 745
    Height = 41
    ButtonHeight = 39
    ButtonWidth = 39
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = DMImage.vil32
    TabOrder = 2
    Transparent = False
    ExplicitWidth = 741
    object pnlSettings: TPanel
      Left = 0
      Top = 0
      Width = 482
      Height = 39
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lblSetOfTemplates: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 1
        Width = 108
        Height = 33
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Set of templates'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        Transparent = False
        Layout = tlCenter
      end
      object cbSetOfTemplates: TComboBox
        AlignWithMargins = True
        Left = 117
        Top = 8
        Width = 364
        Height = 21
        TabOrder = 0
        OnChange = cbSetOfTemplatesChange
      end
    end
    object btnImport: TToolButton
      Left = 482
      Top = 0
      Action = aImport
      ImageIndex = 58
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 745
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitWidth = 741
    object lblPathToFile: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 108
      Height = 22
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
      Transparent = False
      Layout = tlCenter
      ExplicitTop = -5
      ExplicitHeight = 33
    end
    object edtPath: TButtonedEdit
      Left = 117
      Top = 4
      Width = 364
      Height = 21
      Images = DMImage.vil16
      ReadOnly = True
      RightButton.ImageIndex = 5
      RightButton.ImageName = 'Open_32x32'
      RightButton.Visible = True
      TabOrder = 0
      OnRightButtonClick = edtPathRightButtonClick
    end
  end
  object ActionListMain: TActionList
    Images = DMImage.vil16
    Left = 92
    Top = 180
    object aImport: TAction
      Caption = 'aImport'
      ImageIndex = 61
      ImageName = 'ExportToXML_32x32'
      OnExecute = aImportExecute
      OnUpdate = aImportUpdate
    end
  end
  object dlgImport: TFileOpenDialog
    DefaultExtension = '*.xml'
    FavoriteLinks = <>
    FileName = 'EmailParser.xml'
    FileTypes = <
      item
        DisplayName = 'Xml'
        FileMask = '*.xml'
      end
      item
        DisplayName = 'All files'
        FileMask = '*.*'
      end>
    Options = [fdoPathMustExist, fdoFileMustExist]
    Left = 96
    Top = 248
  end
end
