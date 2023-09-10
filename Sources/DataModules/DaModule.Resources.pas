unit DaModule.Resources;

interface

{$REGION 'Region uses'}
uses
  Classes, SysUtils, IniFiles,
  FireDAC.ConsoleUI.Wait, FireDAC.Phys.SQLite, FireDAC.Comp.Client, FireDAC.Phys.SQLiteWrapper,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Phys.SQLiteWrapper.Stat;
{$ENDREGION}

resourcestring
  rsSQLCreateTables = 'create table if not exists EMAILS('                                     + sLineBreak +
                     '  HASH         text primary key,'                                        + sLineBreak +
                     '  MESSAGE_ID   text,'                                                    + sLineBreak +
                     '  FILE_NAME    text,'                                                    + sLineBreak +
                     '  SHORT_NAME   text,'                                                    + sLineBreak +
                     '  SUBJECT      text,'                                                    + sLineBreak +
                     '  BODY         blob,'                                                    + sLineBreak +
                     '  PARSED_TEXT  blob,'                                                    + sLineBreak +
                     '  ADDRESS_FROM text,'                                                    + sLineBreak +
                     '  CONTENT_TYPE text,'                                                    + sLineBreak +
                     '  TIME_STAMP   datetime);'                                               + sLineBreak +
                     'create unique index if not exists UI_HASH on EMAILS(HASH);'              + sLineBreak +

                     'create table if not exists ATTACHMENTS('                                 + sLineBreak +
                     '  HASH         text primary key,'                                        + sLineBreak +
                     '  PARENT_HASH  text references EMAILS(HASH) on delete cascade,'          + sLineBreak +
                     '  CONTENT_ID   text,'                                                    + sLineBreak +
                     '  FILE_NAME    text,'                                                    + sLineBreak +
                     '  SHORT_NAME   text,'                                                    + sLineBreak +
                     '  CONTENT_TYPE text,'                                                    + sLineBreak +
                     '  PARSED_TEXT  blob,'                                                    + sLineBreak +
                     '  FROM_ZIP     integer,'                                                 + sLineBreak +
                     '  IMAGE_INDEX  integer);'                                                + sLineBreak +
                     'create unique index if not exists UI_HASH on ATTACHMENTS(HASH);'         + sLineBreak +
                     'create index if not exists IDX_PARENT_HASH on ATTACHMENTS(PARENT_HASH ASC);';
  rsSQLInsertEmail = 'insert or ignore into EMAILS(HASH, MESSAGE_ID, FILE_NAME, SHORT_NAME, SUBJECT, BODY, PARSED_TEXT, ADDRESS_FROM, CONTENT_TYPE, TIME_STAMP) ' + sLineBreak +
                     '                      values(:HASH, :MESSAGE_ID, :FILE_NAME, :SHORT_NAME, :SUBJECT, :BODY, :PARSED_TEXT, :ADDRESS_FROM, :CONTENT_TYPE, :TIME_STAMP)';

  rsSQLInsertAttachment = 'insert or ignore into ATTACHMENTS(HASH, PARENT_HASH, CONTENT_ID, FILE_NAME, SHORT_NAME, CONTENT_TYPE, PARSED_TEXT, FROM_ZIP, IMAGE_INDEX) ' + sLineBreak +
                          '                           values(:HASH, :PARENT_HASH, :CONTENT_ID, :FILE_NAME, :SHORT_NAME, :CONTENT_TYPE, :PARSED_TEXT, :FROM_ZIP, :IMAGE_INDEX)';

  rsSQLSelectBodyAsParsedText        = 'select PARSED_TEXT from EMAILS where HASH = :HASH';
  rsSQLSelectBodyAsRawText           = 'select BODY from EMAILS where HASH = :HASH';
  rsSQLSelectAttachmentsAsParsedText = 'select PARSED_TEXT from ATTACHMENTS where HASH = :HASH';

implementation

end.
