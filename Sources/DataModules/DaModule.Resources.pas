unit DaModule.Resources;

interface

{$REGION 'Region uses'}
uses
  Classes, SysUtils, IniFiles,
  FireDAC.ConsoleUI.Wait, FireDAC.Phys.SQLite, FireDAC.Comp.Client, FireDAC.Phys.SQLiteWrapper,
  FireDAC.Stan.Async, FireDAC.Stan.Def, FireDAC.Phys.SQLiteWrapper.Stat;
{$ENDREGION}

resourcestring
  rsSQLCreateTables =
                     'create table if not exists PROJECT('                             + sLineBreak +
                     '  ID   varchar(36) primary key,'                                 + sLineBreak +
                     '  NAME text,'                                                    + sLineBreak +
                     '  INFO text);'                                                   + sLineBreak +

                     'create table if not exists EMAILS('                              + sLineBreak +
                     '  ID           varchar(36) primary key,'                         + sLineBreak +
                     '  HASH         text,'                                            + sLineBreak +
                     '  MESSAGE_ID   text,'                                            + sLineBreak +
                     '  FILE_NAME    text,'                                            + sLineBreak +
                     '  SHORT_NAME   text,'                                            + sLineBreak +
                     '  ATTACH       text,'                                            + sLineBreak +
                     '  SUBJECT      text,'                                            + sLineBreak +
                     '  BODY         blob,'                                            + sLineBreak +
                     '  PARSED_TEXT  blob,'                                            + sLineBreak +
                     '  ADDRESS_FROM text,'                                            + sLineBreak +
                     '  CONTENT_TYPE text,'                                            + sLineBreak +
                     '  TIME_STAMP   datetime);'                                       + sLineBreak +
                     'create unique index if not exists UI_EMAILS on EMAILS(HASH);'    + sLineBreak +

                     'create table if not exists PROJECTS_EMAILS('                     + sLineBreak +
                     '  PROJECT_ID   varchar(36),'                                     + sLineBreak +
                     '  EMAIL_ID     varchar(36));'                                    + sLineBreak +
                     'create unique index if not exists UI_PE on PROJECTS_EMAILS(PROJECT_ID, EMAIL_ID);'   + sLineBreak +

                     'create table if not exists ATTACHMENTS('                         + sLineBreak +
                     '  ID           varchar(36) primary key,'                         + sLineBreak +
                     '  HASH         text,'                                            + sLineBreak +
                     '  PARENT_HASH  text references EMAILS(HASH) on delete cascade,'  + sLineBreak +
                     '  CONTENT_ID   text,'                                            + sLineBreak +
                     '  FILE_NAME    text,'                                            + sLineBreak +
                     '  SHORT_NAME   text,'                                            + sLineBreak +
                     '  CONTENT_TYPE text,'                                            + sLineBreak +
                     '  PARSED_TEXT  blob,'                                            + sLineBreak +
                     '  FROM_ZIP     integer,'                                         + sLineBreak +
                     '  IMAGE_INDEX  integer);'                                        + sLineBreak +
                     'create unique index if not exists UI_ATTACHMENTS on ATTACHMENTS(HASH);'      + sLineBreak +
                     'create index if not exists IDX_PARENT_HASH on ATTACHMENTS(PARENT_HASH ASC);' + sLineBreak +

                     'create table if not exists PROJECTS_ATTACHMENTS('                            + sLineBreak +
                     '  PROJECT_ID    varchar(36),'                                                + sLineBreak +
                     '  ATTACHMENT_ID varchar(36));'                                               + sLineBreak +
                     'create unique index if not exists UI_PA on PROJECTS_ATTACHMENTS(PROJECT_ID, ATTACHMENT_ID);';

  rsSQLInsertEmail = 'insert or ignore into EMAILS(ID, HASH, MESSAGE_ID, FILE_NAME, SHORT_NAME, ATTACH, SUBJECT, BODY, PARSED_TEXT, ADDRESS_FROM, CONTENT_TYPE, TIME_STAMP) ' + sLineBreak +
                                           'values(:ID, :HASH, :MESSAGE_ID, :FILE_NAME, :SHORT_NAME, :ATTACH, :SUBJECT, :BODY, :PARSED_TEXT, :ADDRESS_FROM, :CONTENT_TYPE, :TIME_STAMP)';

  rsSQLInsertProject = 'insert or ignore into PROJECT(ID, NAME, INFO) ' + sLineBreak +
                     '                        values(:ID, :NAME, :INFO)';

  rsSQLInsertProjectsEmails = 'insert or ignore into PROJECTS_EMAILS(PROJECT_ID, EMAIL_ID) ' + sLineBreak +
                                                             'values(:PROJECT_ID, :EMAIL_ID)';

  rsSQLInsertProjectAttachments ='insert or ignore into PROJECTS_ATTACHMENTS(PROJECT_ID, ATTACHMENT_ID) ' + sLineBreak +
                                                                     'values(:PROJECT_ID, :ATTACHMENT_ID)';

  rsSQLInsertAttachment = 'insert or ignore into ATTACHMENTS(ID, HASH, PARENT_HASH, CONTENT_ID, FILE_NAME, SHORT_NAME, CONTENT_TYPE, PARSED_TEXT, FROM_ZIP, IMAGE_INDEX) ' + sLineBreak +
                                                     'values(:ID, :HASH, :PARENT_HASH, :CONTENT_ID, :FILE_NAME, :SHORT_NAME, :CONTENT_TYPE, :PARSED_TEXT, :FROM_ZIP, :IMAGE_INDEX)';

  rsSQLSelectBodyAsParsedText        = 'select PARSED_TEXT from EMAILS where HASH = :HASH';
  rsSQLSelectBodyAsRawText           = 'select BODY from EMAILS where HASH = :HASH';
  rsSQLSelectAttachmentsAsParsedText = 'select PARSED_TEXT from ATTACHMENTS where HASH = :HASH';

implementation

end.
