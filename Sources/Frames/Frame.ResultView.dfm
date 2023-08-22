inherited frameResultView: TframeResultView
  Width = 940
  Height = 673
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  ExplicitWidth = 940
  ExplicitHeight = 673
  PixelsPerInch = 144
  inherited tbMain: TToolBar
    Width = 940
    Height = 0
    Visible = False
    ExplicitWidth = 940
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
    Width = 940
    Height = 673
    ActivePage = tsEmail
    Align = alClient
    TabOrder = 1
    object tsEmail: TTabSheet
      Caption = 'Email'
      object splInfo: TSplitter
        Left = 0
        Top = 358
        Width = 932
        Height = 5
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = 277
        ExplicitWidth = 798
      end
      object pcInfo: TPageControl
        Left = 0
        Top = 363
        Width = 932
        Height = 280
        ActivePage = tsHtmlText
        Align = alBottom
        TabOrder = 1
        object tsPlainText: TTabSheet
          Caption = 'Plain Text'
          object memTextPlain: TMemo
            Left = 0
            Top = 0
            Width = 924
            Height = 250
            Align = alClient
            BevelInner = bvNone
            BevelOuter = bvNone
            BorderStyle = bsNone
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
            Width = 924
            Height = 250
            Align = alClient
            TabOrder = 0
            OnBeforeNavigate2 = wbBodyBeforeNavigate2
            ExplicitWidth = 798
            ControlData = {
              4C000000805F0000D71900000000000000000000000000000000000000000000
              000000004C000000000000000000000001000000E0D057007335CF11AE690800
              2B2E126208000000000000004C0000000114020000000000C000000000000046
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
            Width = 924
            Height = 250
            Align = alClient
            TabOrder = 0
            ExplicitLeft = 168
            ExplicitTop = -124
            inherited tbMain: TToolBar
              Width = 924
            end
            inherited vstTree: TVirtualStringTree
              Width = 924
              Height = 211
            end
          end
        end
      end
      inline frameEmails: TframeEmails
        Left = 0
        Top = 0
        Width = 932
        Height = 358
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 932
        ExplicitHeight = 358
        inherited tbMain: TToolBar
          Width = 932
          ExplicitWidth = 932
        end
        inherited vstTree: TVirtualStringTree
          Width = 932
          Height = 319
          ExplicitWidth = 932
          ExplicitHeight = 319
        end
      end
    end
    object tsAllAttachments: TTabSheet
      Caption = 'All attachments'
      ImageIndex = 1
      inline frameAllAttachments: TframeAllAttachments
        Left = 0
        Top = 0
        Width = 932
        Height = 643
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 269
        ExplicitTop = 269
        inherited tbMain: TToolBar
          Width = 932
        end
        inherited vstTree: TVirtualStringTree
          Width = 932
          Height = 604
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
end
