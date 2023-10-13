inherited frameResultView: TframeResultView
  Width = 697
  ExplicitWidth = 697
  inherited tbMain: TToolBar
    Width = 697
    Height = 0
    Visible = False
    ExplicitWidth = 697
    ExplicitHeight = 0
    inherited btnAdd: TToolButton
      Visible = False
    end
    inherited btnDelete: TToolButton
      Visible = False
    end
    inherited btnSave: TToolButton
      Visible = False
    end
    inherited btnSep01: TToolButton
      Visible = False
    end
    inherited btnRefresh: TToolButton
      Visible = False
    end
    inherited btnSep02: TToolButton
      Visible = False
    end
  end
  object pcMain: TPageControl [1]
    Left = 0
    Top = 0
    Width = 697
    Height = 300
    ActivePage = tsEmail
    Align = alClient
    TabOrder = 1
    object tsEmail: TTabSheet
      Caption = 'Email'
      object splInfo: TSplitter
        Left = 0
        Top = -15
        Width = 689
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 277
        ExplicitWidth = 798
      end
      object pcInfo: TPageControl
        Left = 0
        Top = -10
        Width = 689
        Height = 280
        ActivePage = tsHtmlText
        Align = alBottom
        TabOrder = 1
        object tsBodyText: TTabSheet
          Caption = 'Body Text'
          ImageIndex = 3
          object memTextBody: TMemo
            Left = 0
            Top = 0
            Width = 681
            Height = 250
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            PopupMenu = pmMemo
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsPlainText: TTabSheet
          Caption = 'Plain Text'
          object memTextPlain: TMemo
            Left = 0
            Top = 0
            Width = 681
            Height = 250
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
            PopupMenu = pmMemo
            ReadOnly = True
            ScrollBars = ssVertical
            TabOrder = 0
          end
        end
        object tsHtmlText: TTabSheet
          Caption = 'HTML'
          ImageIndex = 1
          object wbBody: TWebBrowser
            Left = 0
            Top = 0
            Width = 681
            Height = 250
            Align = alClient
            TabOrder = 0
            OnBeforeNavigate2 = wbBodyBeforeNavigate2
            ExplicitWidth = 924
            ControlData = {
              4C00000062460000D71900000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E12620A000000000000004C0000000114020000000000C000000000000046
              8000000000000000000000000000000000000000000000000000000000000000
              00000000000000000100000000000000000000000000000000000000}
          end
        end
        object tsAttachments: TTabSheet
          Caption = 'Attachments'
          ImageIndex = 2
          inline frameAttachments: TframeAttachments
            Left = 0
            Top = 0
            Width = 681
            Height = 250
            Align = alClient
            TabOrder = 0
            ExplicitWidth = 681
            ExplicitHeight = 250
            inherited tbMain: TToolBar
              Width = 681
              ExplicitWidth = 681
            end
            inherited vstTree: TVirtualStringTree
              Width = 681
              Height = 211
              ExplicitWidth = 681
              ExplicitHeight = 211
              DefaultText = ''
            end
          end
        end
      end
      inline frameEmails: TframeEmails
        Left = 0
        Top = 0
        Width = 689
        Height = 358
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 689
        ExplicitHeight = 358
        inherited tbMain: TToolBar
          Width = 689
          ExplicitWidth = 689
        end
        inherited vstTree: TVirtualStringTree
          Width = 689
          Height = 319
          ExplicitWidth = 689
          ExplicitHeight = 319
          DefaultText = ''
        end
      end
    end
    object tsAllAttachments: TTabSheet
      Caption = 'All attachments'
      ImageIndex = 1
      inline frameAllAttachments: TframeAllAttachments
        Left = 0
        Top = 0
        Width = 689
        Height = 270
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 689
        ExplicitHeight = 270
        inherited tbMain: TToolBar
          Width = 689
          ExplicitWidth = 689
        end
        inherited vstTree: TVirtualStringTree
          Width = 689
          Height = 192
          ExplicitWidth = 689
          ExplicitHeight = 192
          DefaultText = ''
        end
        inherited tbFileSearch: TToolBar
          Width = 689
          ExplicitWidth = 689
        end
      end
    end
  end
  inherited alFrame: TActionList
    Left = 76
    Top = 108
    inherited aEdit: TAction
      Visible = True
    end
  end
  inherited pmFrame: TPopupMenu
    Left = 156
    Top = 108
  end
  object SaveDialogEmail: TSaveDialog
    DefaultExt = '*.eml'
    Filter = 'Email|*.eml|All files|*.*'
    Left = 80
    Top = 184
  end
  object alMemo: TActionList
    Images = DMImage.vil32
    Left = 88
    Top = 472
    object aCopy: TAction
      Caption = 'Copy'
      ImageIndex = 76
      ImageName = 'page_copy'
      ShortCut = 16451
      OnExecute = aCopyExecute
    end
    object aPaste: TAction
      Caption = 'Paste'
      ImageIndex = 77
      ImageName = 'page_paste'
      ShortCut = 16470
      OnExecute = aPasteExecute
    end
    object aSelectAll: TAction
      Caption = 'Select All'
      ShortCut = 16449
      OnExecute = aSelectAllExecute
    end
  end
  object pmMemo: TPopupMenu
    Images = DMImage.vil16
    Left = 211
    Top = 480
    object miCopy: TMenuItem
      Action = aCopy
      ImageIndex = 73
    end
    object miPaste: TMenuItem
      Action = aPaste
      ImageIndex = 74
    end
    object miSelectAll: TMenuItem
      Action = aSelectAll
    end
  end
end
