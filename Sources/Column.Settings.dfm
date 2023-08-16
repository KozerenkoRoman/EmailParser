object frmColumnSettings: TfrmColumnSettings
  Left = 0
  Top = 0
  Anchors = [akLeft, akTop, akRight]
  BorderStyle = bsDialog
  Caption = 'Column Settings'
  ClientHeight = 511
  ClientWidth = 369
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
    Top = 469
    Width = 369
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 468
    ExplicitWidth = 365
    object btnCancel: TBitBtn
      Left = 151
      Top = 1
      Width = 110
      Height = 40
      Caption = 'Cancel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 43
      ImageName = 'RemovePivotField_32x32'
      Images = DMImage.vil32
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
    end
    object btnOk: TBitBtn
      Left = 263
      Top = 1
      Width = 110
      Height = 40
      Caption = 'Ok'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBtnText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 46
      ImageName = 'tick'
      Images = DMImage.vil32
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
    end
  end
  object vstColumns: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 369
    Height = 469
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Options = [hoAutoResize, hoColumnResize, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort]
    Header.SortColumn = 2
    TabOrder = 1
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnChecked = vstColumnsChecked
    OnCompareNodes = vstColumnsCompareNodes
    OnFreeNode = vstColumnsFreeNode
    OnGetText = vstColumnsGetText
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'Name'
        Width = 313
      end
      item
        Alignment = taRightJustify
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 1
        Text = 'Width'
        Width = 52
      end
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Position'
        Width = 30
      end>
  end
  object ActionListMain: TActionList
    Images = DMImage.vil16
    Left = 92
    Top = 180
    object aCancel: TAction
      Caption = 'Cancel'
      ImageIndex = 43
      ImageName = 'RemovePivotField_32x32'
      OnExecute = aCancelExecute
    end
  end
end
