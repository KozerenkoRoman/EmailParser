unit DaModule.Resources;

interface

{$REGION 'Region uses'}
uses
  Classes, SysUtils, IniFiles,
  FireDAC.ConsoleUI.Wait, FireDAC.Phys.SQLite, FireDAC.Comp.Client, FireDAC.Phys.SQLiteWrapper,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Phys.SQLiteWrapper.Stat;
{$ENDREGION}

resourcestring
  rsSQLCreateTables = 'create table if not exists EMAILS('                                    + sLineBreak +
                     '  MESSAGE_ID   text primary key,'                                       + sLineBreak +
                     '  FILE_NAME    text,'                                                   + sLineBreak +
                     '  SHORT_NAME   text,'                                                   + sLineBreak +
                     '  SUBJECT      text,'                                                   + sLineBreak +
                     '  BODY         text,'                                                   + sLineBreak +
                     '  PARSED_TEXT  text,'                                                   + sLineBreak +
                     '  ADDRESS_FROM text,'                                                   + sLineBreak +
                     '  CONTENT_TYPE text,'                                                   + sLineBreak +
                     '  TIME_STAMP   datetime);'                                              + sLineBreak +
                     'create unique index if not exists UI_MESSAGE_ID on EMAILS(MESSAGE_ID);' + sLineBreak +

                     'create table if not exists ATTACHMENTS('                              + sLineBreak +
                     '  CONTENT_ID   text primary key,'                                     + sLineBreak +
                     '  MESSAGE_ID   text references EMAILS(MESSAGE_ID) on delete cascade,' + sLineBreak +
                     '  FILE_NAME    text,'                                                 + sLineBreak +
                     '  SHORT_NAME   text,'                                                 + sLineBreak +
                     '  CONTENT_TYPE text,'                                                 + sLineBreak +
                     '  PARSED_TEXT  text,'                                                 + sLineBreak +
                     '  IMAGE_INDEX  integer);'                                             + sLineBreak +
                     'create unique index if not exists UI_CONTENT_ID on ATTACHMENTS(CONTENT_ID);';
  rsSQLInsertEmail = 'insert or ignore into EMAILS(MESSAGE_ID, FILE_NAME, SHORT_NAME, SUBJECT, BODY, PARSED_TEXT, ADDRESS_FROM, CONTENT_TYPE, TIME_STAMP) ' + sLineBreak +
                     '                      values(:MESSAGE_ID, :FILE_NAME, :SHORT_NAME, :SUBJECT, :BODY, :PARSED_TEXT, :ADDRESS_FROM, :CONTENT_TYPE, :TIME_STAMP)';



  rsSQLInsertAttachment = 'insert or ignore into ATTACHMENTS(MESSAGE_ID, CONTENT_ID, FILE_NAME, SHORT_NAME, CONTENT_TYPE, PARSED_TEXT, IMAGE_INDEX) ' + sLineBreak +
                          '                           values(:MESSAGE_ID, :CONTENT_ID, :FILE_NAME, :SHORT_NAME, :CONTENT_TYPE, :PARSED_TEXT, :IMAGE_INDEX)';
//  SQL_DeleteKey       = 'delete from KEYS where SECTION_ID = (select SECTION_ID from SECTIONS where SECTION_NAME = ?) and KEY_NAME = ?';
//  SQL_DeleteSection   = 'delete from SECTIONS where SECTION_NAME = ?';
//  SQL_InsertSection   = 'insert into SECTIONS(SECTION_NAME) values(?)';
//  SQL_SelectKeyID     = 'select KEY_ID from KEYS where SECTION_ID = ? and KEY_NAME = ?';
//  SQL_SelectKeyValue  = 'select KEY_VALUE from KEYS where SECTION_ID = (select SECTION_ID from SECTIONS where SECTION_NAME = ?) and KEY_NAME = ?';
//  SQL_SelectKeyValues = 'select KEY_NAME, KEY_VALUE from KEYS where SECTION_ID = (select SECTION_ID from SECTIONS where SECTION_NAME = ?) and KEY_NAME like ?';
//  SQL_SelectSectionID = 'select SECTION_ID from SECTIONS where SECTION_NAME = ?';
//  SQL_SelectSection   = 'select KEY_NAME from KEYS where SECTION_ID = (select SECTION_ID from SECTIONS where SECTION_NAME = ?)';
//  SQL_SelectSections  = 'select SECTION_NAME from SECTIONS where SECTION_NAME like ?';
//  SQL_UpdateKey       = 'update KEYS set KEY_VALUE = ? where KEY_ID = ?';

implementation


end.
