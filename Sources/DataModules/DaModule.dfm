object DaMod: TDaMod
  Height = 398
  Width = 542
  object Connection: TFDConnection
    Params.Strings = (
      'LockingMode=Normal'
      'Database=D:\Work\EmailParser\bin\EmailParser.db'
      'OpenMode=ReadOnly'
      'DriverID=SQLite'
      'StringFormat=Unicode')
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvCmdExecMode]
    TxOptions.DisconnectAction = xdNone
    Left = 72
    Top = 24
  end
  object qEmail: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select MESSAGE_ID,'
      '       SHORT_NAME,'
      '       SUBJECT, '
      '       ADDRESS_FROM, '
      '       CONTENT_TYPE, '
      '       TIME_STAMP'
      'from emails '
      'where  HASH = :HASH')
    Left = 208
    Top = 16
    ParamData = <
      item
        Name = 'HASH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object FDSQLiteDriverLink: TFDPhysSQLiteDriverLink
    DriverID = 'SQLite'
    Left = 72
    Top = 88
  end
  object qEmailBodyAndText: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select BODY, PARSED_TEXT'
      'from emails '
      'where HASH = :HASH')
    Left = 208
    Top = 80
    ParamData = <
      item
        Name = 'HASH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object qAttachments: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select HASH, '
      '       CONTENT_ID, '
      '       FILE_NAME, '
      '       SHORT_NAME, '
      '       CONTENT_TYPE, '
      '       FROM_ZIP,'
      '       IMAGE_INDEX'
      'from attachments '
      'where  PARENT_HASH = :PARENT_HASH')
    Left = 312
    Top = 16
    ParamData = <
      item
        Name = 'PARENT_HASH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object qAllEmails: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select HASH,'
      '       MESSAGE_ID,'
      '       FILE_NAME,'
      '       SHORT_NAME,'
      '       SUBJECT, '
      '       ADDRESS_FROM, '
      '       CONTENT_TYPE, '
      '       TIME_STAMP'
      'from emails')
    Left = 208
    Top = 152
  end
end
