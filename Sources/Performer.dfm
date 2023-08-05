inherited frmPerformer: TfrmPerformer
  Caption = 'Email Parser'
  ClientHeight = 784
  ClientWidth = 1100
  Position = poScreenCenter
  OnShow = FormShow
  ExplicitWidth = 1116
  ExplicitHeight = 823
  TextHeight = 13
  object splInfo: TSplitter
    Left = 0
    Top = 597
    Width = 1100
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 640
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = 12477460
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 1096
    DesignSize = (
      1100
      41)
    object srchBox: TSearchBox
      Left = 929
      Top = 11
      Width = 159
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 0
      OnInvokeSearch = srchBoxInvokeSearch
      ExplicitLeft = 925
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 743
    Width = 1100
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 742
    ExplicitWidth = 1096
    DesignSize = (
      1100
      41)
    object gProgress: TGauge
      Left = 18
      Top = 3
      Width = 959
      Height = 20
      BorderStyle = bsNone
      Color = clBtnFace
      ForeColor = 1986047
      MaxValue = 2
      ParentColor = False
      Progress = 0
      ShowText = False
      Visible = False
    end
    object btnBreak: TBitBtn
      Left = 983
      Top = 1
      Width = 110
      Height = 40
      Action = aBreak
      Anchors = [akTop, akRight]
      Caption = 'Break'
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      Images = DMImage.vil32
      ParentFont = False
      TabOrder = 0
      ExplicitLeft = 979
    end
  end
  inline frameLogView: TframeLogView
    Left = 0
    Top = 41
    Width = 1100
    Height = 556
    Align = alClient
    BiDiMode = bdLeftToRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBiDiMode = False
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ExplicitTop = 41
    ExplicitWidth = 1100
    ExplicitHeight = 556
    inherited vstTree: TVirtualStringTree
      Width = 1100
      Height = 512
      OnFocusChanged = frameLogViewvstTreeFocusChanged
      ExplicitWidth = 1100
      ExplicitHeight = 512
    end
    inherited tbMain: TToolBar
      Width = 1094
      ExplicitWidth = 1090
      inherited btnExecute: TToolButton
        Action = aExecute
      end
    end
  end
  object gbInfo: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 610
    Width = 1094
    Height = 130
    Margins.Top = 8
    Align = alBottom
    Caption = 'Info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 609
    ExplicitWidth = 1090
    object memInfo: TMemo
      Left = 2
      Top = 18
      Width = 1090
      Height = 110
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitWidth = 1086
    end
  end
  object alPerformer: TActionList
    Images = DMImage.vil32
    Left = 208
    Top = 232
    object aBreak: TAction
      Caption = 'Break'
      ImageIndex = 43
      ImageName = 'RemovePivotField_32x32'
      OnExecute = aBreakExecute
    end
    object aExecute: TAction
      Caption = 'Execute'
      ImageIndex = 12
      ImageName = 'lightning'
      OnExecute = aExecuteExecute
    end
  end
end
