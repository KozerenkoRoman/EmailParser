inherited frameAllAttachments: TframeAllAttachments
  Width = 663
  Height = 374
  ExplicitWidth = 663
  ExplicitHeight = 374
  inherited tbMain: TToolBar
    Width = 663
    ExplicitWidth = 663
    inherited btnAdd: TToolButton
      Action = aOpenAttachFile
      Visible = False
    end
    object btnSep04: TToolButton
      Left = 375
      Top = 0
      Width = 8
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
    Width = 663
    Height = 335
    Header.MainColumn = 0
    OnBeforeCellPaint = vstTreeBeforeCellPaint
    OnCompareNodes = vstTreeCompareNodes
    OnDblClick = aOpenParsedTextExecute
    OnGetText = vstTreeGetText
    OnGetImageIndex = vstTreeGetImageIndex
    ExplicitWidth = 663
    ExplicitHeight = 335
    Columns = <
      item
        Alignment = taRightJustify
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
  end
  inherited alFrame: TActionList
    Left = 100
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
    inherited aRefresh: TAction
      OnExecute = aRefreshExecute
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
    Left = 200
    Top = 100
  end
end
