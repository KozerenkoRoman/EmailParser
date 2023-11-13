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
      'select BODY, '
      '       PARSED_TEXT'
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
      'select a.HASH, '
      '       a.PARENT_HASH, '
      '       e.SHORT_NAME as PARENT_NAME,'
      '       a.CONTENT_ID, '
      '       a.FILE_NAME, '
      '       a.SHORT_NAME, '
      '       a.CONTENT_TYPE, '
      '       a.FROM_ZIP,'
      '       a.IMAGE_INDEX'
      'from projects_attachments p,'
      '     attachments a left join emails e on a.PARENT_HASH = e.HASH'
      'where  a.HASH = p.ATTACHMENT_ID and'
      '       p.PROJECT_ID = :PROJECT_ID')
    Left = 320
    Top = 88
    ParamData = <
      item
        Name = 'PROJECT_ID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object qInsProject: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'insert or ignore into PROJECT(HASH, NAME, INFO)'
      '                       values(:HASH, :NAME, :INFO)')
    Left = 320
    Top = 160
    ParamData = <
      item
        Name = 'HASH'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'NAME'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end
      item
        Name = 'INFO'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
  object qEmails: TFDQuery
    Connection = Connection
    SQL.Strings = (
      'select HASH,'
      '       MESSAGE_ID,'
      '       FILE_NAME,'
      '       SHORT_NAME,'
      '       SUBJECT, '
      '       ATTACH,'
      '       ADDRESS_FROM, '
      '       CONTENT_TYPE, '
      '       TIME_STAMP'
      'from EMAILS e,'
      '     PROJECTS_EMAILS p '
      'where e.HASH = p.EMAIL_ID'
      '  and p.PROJECT_ID = :PROJECT_ID')
    Left = 320
    Top = 16
    ParamData = <
      item
        Name = 'PROJECT_ID'
        DataType = ftString
        ParamType = ptInput
        Value = Null
      end>
  end
end
