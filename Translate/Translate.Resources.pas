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
    Key: string;
    En: string;
    Uk: string;
  end;

resourcestring
  en_Add                 = 'Add';
  en_ProgramVersion      = 'Version';
  en_Backup              = 'backup';
  en_Begin               = 'begin';
  en_Break               = 'Break';
  en_Cancel              = 'Cancel';
  en_ClassName           = 'Class name';
  en_CollapseAll         = 'Collapse All';
  en_Compatibility       = 'Compatibility';
  en_CompHierarchy       = 'Components hierarchy';
  en_CompName            = 'Component name';
  en_Delete              = 'Delete';
  en_DirectoryNotFound   = 'Directory "%s" not found';
  en_Edit                = 'Edit';
  en_EditCommonParameters = 'Common parameters';
  en_EditRegExpParameters = 'RegExp parameters';
  en_Enabled             = 'Enabled';
  en_Disabled            = 'Disabled';
  en_End                 = 'end';
  en_Error               = 'Error';
  en_Errors              = 'Errors';
  en_Execution           = 'Execution of scripts';
  en_ExpandAll           = 'Expand All';
  en_ExportToCSV         = 'Export To CSV';
  en_ExportToExcel       = 'Export To Excel';
  en_KeyNotFound         = 'Key "%s" not found';
  en_FileNotFound        = 'File "%s" not found';
  en_FileIsDisabled      = 'File "%s" is disabled';
  en_GettingStarted      = 'Getting started';
  en_Go                  = 'Go';
  en_Info                = 'Info ';
  en_ModuleName          = 'Module name';
  en_Ok                  = 'Ok';
  en_Operation           = 'Operation';
  en_ParameterName       = 'Parameter name';
  en_Parameter           = 'Parameter';
  en_Parameters          = 'Parameters';
  en_Path                = 'Path';
  en_PathsToFindFiles    = 'Paths to find files';
  en_PhysicalName        = 'Database file name';
  en_BackupName          = 'Backup file name';
  en_Position            = 'Position';
  en_Print               = 'Print';
  en_ProgramShutdown     = 'Program shutdown';
  en_ProgramStopsWorking = 'Application will be terminated!';
  en_Refresh             = 'Refresh';
  en_Save                = 'Save';
  en_Script              = 'Script';
  en_SQLVersion          = 'SQL Version';
  en_SystemInfo          = 'System Information';
  en_Time                = 'Time';
  en_Value               = 'Value';
  en_Successful          = 'Operation is successful';
  en_Failed              = 'Operation was failed';
  en_OpenLogFile         = 'Open Log File';
  en_SetMultiUserMode    = 'Set multi user mode';
  en_SetSingleUserMode   = 'Set single user mode';
  en_DBNotConnected      = 'DB is not connected';
  en_RestoreDB           = 'Restore DB from backup file';
  en_RestoreConfirm      = 'Are you sure you want to restore DB from backup?';
  en_Server              = 'Server';
  en_RegExpTemplate      = 'RegExp Template';
  en_WithSubdir          = 'With subdir';

  uk_Add = 'Додати';
  uk_ProgramVersion = 'Версія';
  uk_Backup = 'резервне копіювання';
  uk_Begin = 'початок';
  uk_Break = 'Зупинити';
  uk_Cancel = 'Скасувати';
  uk_ClassName = 'Назва класу';
  uk_CollapseAll = 'Згорнути все';
  uk_Compatibility = 'Сумісність';
  uk_CompHierarchy = 'Ієрархія компонентів';
  uk_CompName = 'Назва компонента';
  uk_Delete = 'Видалити';
  uk_DirectoryNotFound = 'Каталог "%s" не знайдено';
  uk_Edit = 'Редагувати';
  uk_EditCommonParameters = 'Загальні параметри';
  uk_EditRegExpParameters = 'RegExp параметри';
  uk_Enabled = 'Увімкнено';
  uk_Disabled = 'Вимкнено';
  uk_End = 'кінець';
  uk_Error = 'Помилка';
  uk_Errors = 'Помилки';
  uk_Execution = 'Виконання сценаріїв';
  uk_ExpandAll = 'Розгорнути все';
  uk_ExportToCSV = 'Експортувати до CSV';
  uk_ExportToExcel = 'Експортувати до Excel';
  uk_KeyNotFound = 'Ключ "%s" не знайдено';
  uk_FileNotFound = 'Файл "%s" не знайдено';
  uk_FileIsDisabled = 'Файл "%s" вимкнено';
  uk_GettingStarted = 'Початок роботи';
  uk_Go = 'Почати';
  uk_Info = 'Опис ';
  uk_ModuleName = 'Назва модуля';
  uk_Ok = 'Ок';
  uk_Operation = 'Операція';
  uk_ParameterName = 'Назва параметра';
  uk_Parameter = 'Параметр';
  uk_Parameters = 'Параметри';
  uk_Path = 'Шлях';
  uk_PathsToFindFiles = 'Шляхи для пошуку файлів';
  uk_PhysicalName = 'Назва файлу бази даних';
  uk_BackupName = 'Ім''я файлу резервної копії';
  uk_Position = 'Позиція';
  uk_Print = 'Друк';
  uk_ProgramShutdown = 'Закриття програми';
  uk_ProgramStopsWorking = 'Програму буде зупинено!';
  uk_Refresh = 'Оновити';
  uk_Save = 'Зберегти';
  uk_Script = 'Сценарій';
  uk_SQLVersion = 'Версія SQL';
  uk_SystemInfo = 'Інформація про систему';
  uk_Time = 'Час';
  uk_Value = 'Значення';
  uk_Successful = 'Операція успішна';
  uk_Failed = 'Операція була невдалою';
  uk_OpenLogFile = 'Відкрити файл журналу';
  uk_SetMultiUserMode = 'Установити багатокористувацький режим';
  uk_SetSingleUserMode = 'Установити режим для одного користувача';
  uk_DBNotConnected = 'БД не підключено';
  uk_RestoreDB = 'Відновити БД з файлу резервної копії';
  uk_RestoreConfirm = 'Ви впевнені, що бажаєте відновити БД з резервної копії?';
  uk_Server = 'Сервер';
  uk_RegExpTemplate = 'Шаблон регулярного виразу';
  uk_WithSubdir = 'З підкаталогами';

const
   ArrayMessages: array[1 .. 63] of TMessageItem = (
    (Key: 'Add'                  ; En: en_Add;                  Uk: uk_Add),
    (Key: 'ATMVersion'           ; En: en_ProgramVersion;       Uk: uk_ProgramVersion),
    (Key: 'Cancel'               ; En: en_Cancel;               Uk: uk_Cancel),
    (Key: 'ClassName'            ; En: en_ClassName;            Uk: uk_ClassName),
    (Key: 'CollapseAll'          ; En: en_CollapseAll;          Uk: uk_CollapseAll),
    (Key: 'Compatibility'        ; En: en_Compatibility;        Uk: uk_Compatibility),
    (Key: 'CompHierarchy'        ; En: en_CompHierarchy;        Uk: uk_CompHierarchy),
    (Key: 'CompName'             ; En: en_CompName;             Uk: uk_CompName),
    (Key: 'Delete'               ; En: en_Delete;               Uk: uk_Delete),
    (Key: 'DirectoryNotFound'    ; En: en_DirectoryNotFound;    Uk: uk_DirectoryNotFound),
    (Key: 'Edit'                 ; En: en_Edit;                 Uk: uk_Edit),
    (Key: 'EditRegExpParameters' ; En: en_EditRegExpParameters; Uk: uk_EditRegExpParameters),
    (Key: 'EditCommonParameters' ; En: en_EditCommonParameters; Uk: uk_EditCommonParameters),
    (Key: 'Enabled'              ; En: en_Enabled;              Uk: uk_Enabled),
    (Key: 'Error'                ; En: en_Error;                Uk: uk_Error),
    (Key: 'Errors'               ; En: en_Errors;               Uk: uk_Errors),
    (Key: 'ExpandAll'            ; En: en_ExpandAll;            Uk: uk_ExpandAll),
    (Key: 'ExportToCSV'          ; En: en_ExportToCSV;          Uk: uk_ExportToCSV),
    (Key: 'ExportToExcel'        ; En: en_ExportToExcel;        Uk: uk_ExportToExcel),
    (Key: 'GettingStarted'       ; En: en_GettingStarted;       Uk: uk_GettingStarted),
    (Key: 'FileNotFound'         ; En: en_FileNotFound;         Uk: uk_FileNotFound),
    (Key: 'Go'                   ; En: en_Go;                   Uk: uk_Go),
    (Key: 'Info'                 ; En: en_Info;                 Uk: uk_Info),
    (Key: 'ModuleName'           ; En: en_ModuleName;           Uk: uk_ModuleName),
    (Key: 'Ok'                   ; En: en_Ok;                   Uk: uk_Ok),
    (Key: 'Operation'            ; En: en_Operation;            Uk: uk_Operation),
    (Key: 'Parameter'            ; En: en_Parameter;            Uk: uk_Parameter),
    (Key: 'Parameters'           ; En: en_Parameters;           Uk: uk_Parameters),
    (Key: 'ParameterName'        ; En: en_ParameterName;        Uk: uk_ParameterName),
    (Key: 'RegExpTemplate'       ; En: en_RegExpTemplate;       Uk: uk_RegExpTemplate),
    (Key: 'Path'                 ; En: en_Path;                 Uk: uk_Path),
    (Key: 'PathsToFindFiles'     ; En: en_PathsToFindFiles;     Uk: uk_PathsToFindFiles),
    (Key: 'Position'             ; En: en_Position;             Uk: uk_Position),
    (Key: 'Print'                ; En: en_Print;                Uk: uk_Print),
    (Key: 'ProgramShutdown'      ; En: en_ProgramShutdown;      Uk: uk_ProgramShutdown),
    (Key: 'ProgramStopsWorking'  ; En: en_ProgramStopsWorking;  Uk: uk_ProgramStopsWorking),
    (Key: 'Refresh'              ; En: en_Refresh;              Uk: uk_Refresh),
    (Key: 'Save'                 ; En: en_Save;                 Uk: uk_Save),
    (Key: 'Script'               ; En: en_Script;               Uk: uk_Script),
    (Key: 'SQLVersion'           ; En: en_SQLVersion;           Uk: uk_SQLVersion),
    (Key: 'SystemInfo'           ; En: en_SystemInfo;           Uk: uk_SystemInfo),
    (Key: 'Time'                 ; En: en_Time;                 Uk: uk_Time),
    (Key: 'Value'                ; En: en_Value;                Uk: uk_Value),
    (Key: 'Break'                ; En: en_Break;                Uk: uk_Break),
    (Key: 'Execution'            ; En: en_Execution;            Uk: uk_Execution),
    (Key: 'PhysicalName'         ; En: en_PhysicalName;         Uk: uk_PhysicalName),
    (Key: 'Begin'                ; En: en_Begin;                Uk: uk_Begin),
    (Key: 'End'                  ; En: en_End;                  Uk: uk_End),
    (Key: 'Backup'               ; En: en_Backup;               Uk: uk_Backup),
    (Key: 'BackupName'           ; En: en_BackupName;           Uk: uk_BackupName),
    (Key: 'Successful'           ; En: en_Successful;           Uk: uk_Successful),
    (Key: 'OpenLogFile'          ; En: en_OpenLogFile;          Uk: uk_OpenLogFile),
    (Key: 'Failed'               ; En: en_Failed;               Uk: uk_Failed),
    (Key: 'SetMultiUserMode'     ; En: en_SetMultiUserMode;     Uk: uk_SetMultiUserMode),
    (Key: 'Disabled'             ; En: en_Disabled;             Uk: uk_Disabled),
    (Key: 'SetSingleUserMode'    ; En: en_SetSingleUserMode;    Uk: uk_SetSingleUserMode),
    (Key: 'FileIsDisabled'       ; En: en_FileIsDisabled;       Uk: uk_FileIsDisabled),
    (Key: 'DBNotConnected'       ; En: en_DBNotConnected;       Uk: uk_DBNotConnected),
    (Key: 'RestoreDB'            ; En: en_RestoreDB;            Uk: uk_RestoreDB),
    (Key: 'RestoreConfirm'       ; En: en_RestoreConfirm;       Uk: uk_RestoreConfirm),
    (Key: 'Server'               ; En: en_Server;               Uk: uk_Server),
    (Key: 'KeyNotFound'          ; En: en_KeyNotFound;          Uk: uk_KeyNotFound),
    (Key: 'WithSubdir'           ; En: en_WithSubdir;           Uk: uk_WithSubdir)
     );

 implementation

 end.
