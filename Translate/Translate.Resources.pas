{*******************************************************************}
{                                                                   }
{                    unit Translate.Resources                       }
{                           v.1.0.0.2                               }
{                      created 22/11/2021                           }
{                                                                   }
{   Resource strings for localization of the user interface         }
{                                                                   }
{*******************************************************************}

unit Translate.Resources;

interface

type
  TMessageItem = record
    Key : string;
    En  : string;
    Uk  : string;
  end;

resourcestring
  //English
  en_Add                  = 'Add';
  en_Backup               = 'backup';
  en_BackupName           = 'Backup file name';
  en_Begin                = 'begin';
  en_Break                = 'Break';
  en_Cancel               = 'Cancel';
  en_ClassName            = 'Class name';
  en_CollapseAll          = 'Collapse All';
  en_Compatibility        = 'Compatibility';
  en_CompHierarchy        = 'Components hierarchy';
  en_CompName             = 'Component name';
  en_Date                 = 'Date';
  en_Delete               = 'Delete';
  en_DirectoryNotFound    = 'Directory "%s" not found';
  en_Disabled             = 'Disabled';
  en_Edit                 = 'Edit';
  en_EditCommonParameters = 'Common parameters';
  en_EditRegExpParameters = 'RegExp parameters';
  en_Enabled              = 'Enabled';
  en_End                  = 'end';
  en_Error                = 'Error';
  en_Errors               = 'Errors';
  en_Execution            = 'Execution of scripts';
  en_ExpandAll            = 'Expand All';
  en_ExportToCSV          = 'Export To CSV';
  en_ExportToExcel        = 'Export To Excel';
  en_Failed               = 'Operation was failed';
  en_FileIsDisabled       = 'File "%s" is disabled';
  en_FileNotFound         = 'File "%s" not found';
  en_GettingStarted       = 'Getting started';
  en_Go                   = 'Go';
  en_Info                 = 'Info ';
  en_MessageId            = 'Message Id';
  en_ModuleName           = 'Module name';
  en_Ok                   = 'Ok';
  en_OpenLogFile          = 'Open Log File';
  en_OpenEmail            = 'Open email';
  en_Operation            = 'Operation';
  en_Parameter            = 'Parameter';
  en_ParameterName        = 'Parameter name';
  en_Parameters           = 'Parameters';
  en_Path                 = 'Path';
  en_PathsToFindFiles     = 'Paths to find files';
  en_FileName             = 'File name';
  en_Position             = 'Position';
  en_Print                = 'Print';
  en_ProgramShutdown      = 'Program shutdown';
  en_ProgramStopsWorking  = 'Application will be terminated!';
  en_ProgramVersion       = 'Version';
  en_Refresh              = 'Refresh';
  en_RegExpTemplate       = 'RegExp Template';
  en_RestoreConfirm       = 'Are you sure you want to restore DB from backup?';
  en_Subject              = 'Subject';
  en_Save                 = 'Save';
  en_Script               = 'Script';
  en_Server               = 'Server';
  en_SetMultiUserMode     = 'Set multi user mode';
  en_SetSingleUserMode    = 'Set single user mode';
  en_Attachment           = 'Attachment';
  en_StartSearch          = 'Start Search';
  en_Successful           = 'Operation is successful';
  en_SystemInfo           = 'System Information';
  en_Time                 = 'Time';
  en_Value                = 'Value';
  en_WithSubdir           = 'With subdir';
  en_Language             = 'Language';
  en_FileExtensions       = 'File extensions to search';

  //Ukrainian
  uk_Add                  = 'Додати';
  uk_Backup               = 'резервне копіювання';
  uk_BackupName           = 'Ім''я файлу резервної копії';
  uk_Begin                = 'початок';
  uk_Break                = 'Зупинити';
  uk_Cancel               = 'Скасувати';
  uk_ClassName            = 'Назва класу';
  uk_CollapseAll          = 'Згорнути все';
  uk_Compatibility        = 'Сумісність';
  uk_CompHierarchy        = 'Ієрархія компонентів';
  uk_CompName             = 'Назва компонента';
  uk_Date                 = 'Дата';
  uk_Delete               = 'Видалити';
  uk_DirectoryNotFound    = 'Каталог "%s" не знайдено';
  uk_Disabled             = 'Вимкнено';
  uk_Edit                 = 'Редагувати';
  uk_EditCommonParameters = 'Загальні параметри';
  uk_EditRegExpParameters = 'RegExp параметри';
  uk_Enabled              = 'Увімкнено';
  uk_End                  = 'кінець';
  uk_Error                = 'Помилка';
  uk_Errors               = 'Помилки';
  uk_Execution            = 'Виконання сценаріїв';
  uk_ExpandAll            = 'Розгорнути все';
  uk_ExportToCSV          = 'Експортувати до CSV';
  uk_ExportToExcel        = 'Експортувати до Excel';
  uk_Failed               = 'Операція була невдалою';
  uk_FileIsDisabled       = 'Файл "%s" вимкнено';
  uk_FileNotFound         = 'Файл "%s" не знайдено';
  uk_GettingStarted       = 'Початок роботи';
  uk_Go                   = 'Почати';
  uk_Info                 = 'Опис ';
  uk_MessageId            = 'Id листа';
  uk_ModuleName           = 'Назва модуля';
  uk_Ok                   = 'Ок';
  uk_OpenLogFile          = 'Відкрити файл журналу';
  uk_OpenEmail            = 'Відкрити email';
  uk_Operation            = 'Операція';
  uk_Parameter            = 'Параметр';
  uk_ParameterName        = 'Назва параметра';
  uk_Parameters           = 'Параметри';
  uk_Path                 = 'Шлях';
  uk_PathsToFindFiles     = 'Шляхи для пошуку файлів';
  uk_FileName             = 'Назва файлу';
  uk_Position             = 'Позиція';
  uk_Print                = 'Друк';
  uk_ProgramShutdown      = 'Закриття програми';
  uk_ProgramStopsWorking  = 'Програму буде зупинено!';
  uk_ProgramVersion       = 'Версія';
  uk_Refresh              = 'Оновити';
  uk_RegExpTemplate       = 'Шаблон регулярного виразу';
  uk_RestoreConfirm       = 'Ви впевнені, що бажаєте відновити БД з резервної копії?';
  uk_Subject              = 'Тема';
  uk_Save                 = 'Зберегти';
  uk_Script               = 'Сценарій';
  uk_Server               = 'Сервер';
  uk_SetMultiUserMode     = 'Установити багатокористувацький режим';
  uk_SetSingleUserMode    = 'Установити режим для одного користувача';
  uk_Attachment           = 'Вкладення';
  uk_StartSearch          = 'Почати пошук';
  uk_Successful           = 'Операція успішна';
  uk_SystemInfo           = 'Інформація про систему';
  uk_Time                 = 'Час';
  uk_Value                = 'Значення';
  uk_WithSubdir           = 'З підкаталогами';
  uk_Language             = 'Мова';
  uk_FileExtensions       = 'Розширення файлів для пошуку';

const
   ArrayMessages: array[1 .. 67] of TMessageItem = (
    (Key: 'Add'                  ; En: en_Add;                  Uk: uk_Add),
    (Key: 'ATMVersion'           ; En: en_ProgramVersion;       Uk: uk_ProgramVersion),
    (Key: 'Backup'               ; En: en_Backup;               Uk: uk_Backup),
    (Key: 'BackupName'           ; En: en_BackupName;           Uk: uk_BackupName),
    (Key: 'Begin'                ; En: en_Begin;                Uk: uk_Begin),
    (Key: 'Break'                ; En: en_Break;                Uk: uk_Break),
    (Key: 'Cancel'               ; En: en_Cancel;               Uk: uk_Cancel),
    (Key: 'ClassName'            ; En: en_ClassName;            Uk: uk_ClassName),
    (Key: 'CollapseAll'          ; En: en_CollapseAll;          Uk: uk_CollapseAll),
    (Key: 'Compatibility'        ; En: en_Compatibility;        Uk: uk_Compatibility),
    (Key: 'CompHierarchy'        ; En: en_CompHierarchy;        Uk: uk_CompHierarchy),
    (Key: 'CompName'             ; En: en_CompName;             Uk: uk_CompName),
    (Key: 'Date'                 ; En: en_Date;                 Uk: uk_Date),
    (Key: 'Delete'               ; En: en_Delete;               Uk: uk_Delete),
    (Key: 'DirectoryNotFound'    ; En: en_DirectoryNotFound;    Uk: uk_DirectoryNotFound),
    (Key: 'Disabled'             ; En: en_Disabled;             Uk: uk_Disabled),
    (Key: 'Edit'                 ; En: en_Edit;                 Uk: uk_Edit),
    (Key: 'EditCommonParameters' ; En: en_EditCommonParameters; Uk: uk_EditCommonParameters),
    (Key: 'EditRegExpParameters' ; En: en_EditRegExpParameters; Uk: uk_EditRegExpParameters),
    (Key: 'Enabled'              ; En: en_Enabled;              Uk: uk_Enabled),
    (Key: 'End'                  ; En: en_End;                  Uk: uk_End),
    (Key: 'FileExtensions'       ; En: en_FileExtensions;       Uk: uk_FileExtensions),
    (Key: 'Error'                ; En: en_Error;                Uk: uk_Error),
    (Key: 'Errors'               ; En: en_Errors;               Uk: uk_Errors),
    (Key: 'Execution'            ; En: en_Execution;            Uk: uk_Execution),
    (Key: 'ExpandAll'            ; En: en_ExpandAll;            Uk: uk_ExpandAll),
    (Key: 'ExportToCSV'          ; En: en_ExportToCSV;          Uk: uk_ExportToCSV),
    (Key: 'ExportToExcel'        ; En: en_ExportToExcel;        Uk: uk_ExportToExcel),
    (Key: 'Failed'               ; En: en_Failed;               Uk: uk_Failed),
    (Key: 'FileIsDisabled'       ; En: en_FileIsDisabled;       Uk: uk_FileIsDisabled),
    (Key: 'FileName'             ; En: en_FileName;             Uk: uk_FileName),
    (Key: 'FileNotFound'         ; En: en_FileNotFound;         Uk: uk_FileNotFound),
    (Key: 'GettingStarted'       ; En: en_GettingStarted;       Uk: uk_GettingStarted),
    (Key: 'Go'                   ; En: en_Go;                   Uk: uk_Go),
    (Key: 'Info'                 ; En: en_Info;                 Uk: uk_Info),
    (Key: 'MessageId'            ; En: en_MessageId;            Uk: uk_MessageId),
    (Key: 'ModuleName'           ; En: en_ModuleName;           Uk: uk_ModuleName),
    (Key: 'Ok'                   ; En: en_Ok;                   Uk: uk_Ok),
    (Key: 'OpenEmail'            ; En: en_OpenEmail;            Uk: uk_OpenEmail),
    (Key: 'OpenLogFile'          ; En: en_OpenLogFile;          Uk: uk_OpenLogFile),
    (Key: 'Operation'            ; En: en_Operation;            Uk: uk_Operation),
    (Key: 'Parameter'            ; En: en_Parameter;            Uk: uk_Parameter),
    (Key: 'ParameterName'        ; En: en_ParameterName;        Uk: uk_ParameterName),
    (Key: 'Parameters'           ; En: en_Parameters;           Uk: uk_Parameters),
    (Key: 'Path'                 ; En: en_Path;                 Uk: uk_Path),
    (Key: 'PathsToFindFiles'     ; En: en_PathsToFindFiles;     Uk: uk_PathsToFindFiles),
    (Key: 'Position'             ; En: en_Position;             Uk: uk_Position),
    (Key: 'Print'                ; En: en_Print;                Uk: uk_Print),
    (Key: 'ProgramShutdown'      ; En: en_ProgramShutdown;      Uk: uk_ProgramShutdown),
    (Key: 'ProgramStopsWorking'  ; En: en_ProgramStopsWorking;  Uk: uk_ProgramStopsWorking),
    (Key: 'Refresh'              ; En: en_Refresh;              Uk: uk_Refresh),
    (Key: 'RegExpTemplate'       ; En: en_RegExpTemplate;       Uk: uk_RegExpTemplate),
    (Key: 'RestoreConfirm'       ; En: en_RestoreConfirm;       Uk: uk_RestoreConfirm),
    (Key: 'Save'                 ; En: en_Save;                 Uk: uk_Save),
    (Key: 'Script'               ; En: en_Script;               Uk: uk_Script),
    (Key: 'Server'               ; En: en_Server;               Uk: uk_Server),
    (Key: 'SetMultiUserMode'     ; En: en_SetMultiUserMode;     Uk: uk_SetMultiUserMode),
    (Key: 'SetSingleUserMode'    ; En: en_SetSingleUserMode;    Uk: uk_SetSingleUserMode),
    (Key: 'Attachment'           ; En: en_Attachment;           Uk: uk_Attachment),
    (Key: 'StartSearch'          ; En: en_StartSearch;          Uk: uk_StartSearch),
    (Key: 'Subject'              ; En: en_Subject;              Uk: uk_Subject),
    (Key: 'Successful'           ; En: en_Successful;           Uk: uk_Successful),
    (Key: 'SystemInfo'           ; En: en_SystemInfo;           Uk: uk_SystemInfo),
    (Key: 'Time'                 ; En: en_Time;                 Uk: uk_Time),
    (Key: 'Value'                ; En: en_Value;                Uk: uk_Value),
    (Key: 'Language'             ; En: en_Language;             Uk: uk_Language),
    (Key: 'WithSubdir'           ; En: en_WithSubdir;           Uk: uk_WithSubdir)
     );

 implementation

 end.
