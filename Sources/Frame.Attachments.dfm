inherited frameAttachments: TframeAttachments
  Width = 849
  Height = 566
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  ExplicitWidth = 849
  ExplicitHeight = 566
  inherited vstTree: TVirtualStringTree
    Top = 40
    Width = 849
    Height = 526
    Header.MainColumn = 0
    Images = DMImage.vil16
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenAttachFileExecute
    OnGetText = vstTreeGetText
    ExplicitTop = 40
    ExplicitWidth = 849
    ExplicitHeight = 526
    Columns = <
      item
        CaptionAlignment = taCenter
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 0
        Text = 'File Name'
        Width = 130
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 1
        Text = 'Path'
        Width = 200
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible, coAllowFocus, coUseCaptionAlignment, coEditable, coStyleColor]
        Position = 2
        Text = 'Content Type'
        Width = 129
      end
      item
        CaptionAlignment = taCenter
        MaxWidth = 1000
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coAllowFocus, coUseCaptionAlignment, coStyleColor]
        Position = 3
        Text = 'Text'
        Width = 172
      end>
  end
  inherited tbMain: TToolBar
    Left = 0
    Top = 0
    Width = 849
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 849
    inherited btnAdd: TToolButton
      Action = aOpenAttachFile
      Visible = False
    end
    inherited btnEdit: TToolButton
      Visible = False
    end
    inherited btnSep02: TToolButton
      Visible = False
    end
    object btnOpenAttachFile: TToolButton
      Left = 390
      Top = 0
      Action = aOpenAttachFile
    end
  end
  inherited alFrame: TActionList
    inherited aRefresh: TAction
      Visible = False
    end
    inherited aAdd: TAction
      Visible = False
    end
    inherited aDelete: TAction
      Visible = False
    end
    inherited aSave: TAction
      Visible = False
    end
    object aOpenAttachFile: TAction
      ImageIndex = 72
      ImageName = 'email_attach'
      OnExecute = aOpenAttachFileExecute
    end
  end
end
