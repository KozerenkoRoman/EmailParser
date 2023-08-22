inherited frameAttachments: TframeAttachments
  Width = 519
  Height = 386


      inherited tbMain: TToolBar
        Left = 0
        Top = 0
        Width = 519
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
        inherited btnSep02: TToolButton
          Visible = False
        end
        object btnSep04: TToolButton
          Left = 375
          Top = 0
          Width = 8
          ImageIndex = 76
          ImageName = 'page_copy'
          Style = tbsSeparator
        end
        object btnOpenAttachFile: TToolButton
          Left = 383
          Top = 0
          Action = aOpenAttachFile
        end
        object btnOpenParsedText: TToolButton
          Left = 422
          Top = 0
          Action = aOpenParsedText
        end
      end
      inherited vstTree: TVirtualStringTree
        Top = 39
        Width = 519
        Height = 347
        Header.MainColumn = 0
        Images = DMImage.vil16
        TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toFullRepaintOnResize, toGridExtensions, toInitOnSave, toWheelPanning, toVariableNodeHeight, toFullRowDrag]
        TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toShowFilteredNodes]
        OnCompareNodes = vstTreeCompareNodes
        OnDblClick = aOpenParsedTextExecute
        OnGetText = vstTreeGetText
        ExplicitTop = 39
        ExplicitWidth = 849
        ExplicitHeight = 527
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
      OnExecute = aSaveExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenAttachFile: TAction
      ImageIndex = 72
      ImageName = 'email_attach'
      OnExecute = aOpenAttachFileExecute
      OnUpdate = aOpenAttachFileUpdate
    end
    object aOpenParsedText: TAction
      Hint = 'Open Parsed Text'
      ImageIndex = 75
      ImageName = 'email_open'
      OnExecute = aOpenParsedTextExecute
      OnUpdate = aOpenAttachFileUpdate
    end
  end
  object SaveDialogAttachment: TSaveDialog
    Filter = 'All files|*.*'
    Left = 224
    Top = 216
  end
end
