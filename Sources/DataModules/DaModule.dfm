object DaMod: TDaMod
  Height = 398
  Width = 542
  object FDConnection1: TFDConnection
    TxOptions.DisconnectAction = xdNone
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 216
    Top = 88
  end
  object FDTransaction1: TFDTransaction
    Left = 216
    Top = 152
  end
end
