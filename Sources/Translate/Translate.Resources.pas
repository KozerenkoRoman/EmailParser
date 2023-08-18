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
  en_Attachment           = 'Attachment';
  en_Backup               = 'backup';
  en_BackupName           = 'Backup file name';
  en_Begin                = 'begin';
  en_Body                 = 'Body';
  en_Break                = 'Break';
  en_Cancel               = 'Cancel';
  en_ClassName            = 'Class name';
  en_CollapseAll          = 'Collapse All';
  en_Compatibility        = 'Compatibility';
  en_CompHierarchy        = 'Components hierarchy';
  en_CompName             = 'Component name';
  en_ContentType          = 'Content Type';
  en_Date                 = 'Date';
  en_Delete               = 'Delete';
  en_DeleteAttachments    = 'Delete attachments after analysis';
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
  en_FileExtensions       = 'File extensions to search';
  en_FileIsDisabled       = 'File "%s" is disabled';
  en_FileName             = 'File name';
  en_FileNotFound         = 'File "%s" not found';
  en_FoundFiles           = 'Found %d files';
  en_From                 = 'From';
  en_GettingStarted       = 'Getting started';
  en_Go                   = 'Go';
  en_Info                 = 'Info ';
  en_Language             = 'Language';
  en_Matches              = 'Matches';
  en_MessageId            = 'Message Id';
  en_ModuleName           = 'Module name';
  en_NoDataToDisplay      = 'No data to display';
  en_Ok                   = 'Ok';
  en_OpenEmail            = 'Open email';
  en_OpenFile             = 'Open File';
  en_OpenLogFile          = 'Open Log File';
  en_Operation            = 'Operation';
  en_Parameter            = 'Parameter';
  en_ParameterName        = 'Parameter name';
  en_Parameters           = 'Parameters';
  en_ParseBodyAsHTML      = 'Parse body with RegExp as HTML-text';
  en_Path                 = 'Path';
  en_PathForAttachments   = 'Paths for saving attachments';
  en_PathsToFindFiles     = 'Paths to find files';
  en_Position             = 'Position';
  en_Print                = 'Print';
  en_ProgramShutdown      = 'Program shutdown';
  en_ProgramStopsWorking  = 'Application will be terminated!';
  en_ProgramVersion       = 'Version';
  en_Refresh              = 'Refresh';
  en_RegExpTemplate       = 'RegExp Template';
  en_Save                 = 'Save';
  en_Script               = 'Script';
  en_Search               = 'Search';
  en_Server               = 'Server';
  en_StartSearch          = 'Start Search';
  en_Subject              = 'Subject';
  en_Successful           = 'Operation is successful';
  en_SystemInfo           = 'System Information';
  en_Text                 = 'Text';
  en_Time                 = 'Time';
  en_Value                = 'Value';
  en_WithSubdir           = 'With subdir';
  en_UseLastGroup         = 'Use only the last result group';
  en_PlainText            = 'Plain Text';

  //Ukrainian
  uk_Add                  = 'Додати';
  uk_Attachment           = 'Вкладення';
  uk_Backup               = 'резервне копіювання';
  uk_BackupName           = 'Ім''я файлу резервної копії';
  uk_Begin                = 'початок';
  uk_Body                 = 'Тіло';
  uk_Break                = 'Зупинити';
  uk_Cancel               = 'Скасувати';
  uk_ClassName            = 'Назва класу';
  uk_CollapseAll          = 'Згорнути все';
  uk_Compatibility        = 'Сумісність';
  uk_CompHierarchy        = 'Ієрархія компонентів';
  uk_CompName             = 'Назва компонента';
  uk_ContentType          = 'Тип контенту';
  uk_Date                 = 'Дата';
  uk_Delete               = 'Видалити';
  uk_DeleteAttachments    = 'Видалити вкладення після аналізу';
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
  uk_FileExtensions       = 'Розширення файлів для пошуку';
  uk_FileIsDisabled       = 'Файл "%s" вимкнено';
  uk_FileName             = 'Назва файлу';
  uk_FileNotFound         = 'Файл "%s" не знайдено';
  uk_FoundFiles           = 'Знайдено %d файлів';
  uk_From                 = 'Відправник';
  uk_GettingStarted       = 'Початок роботи';
  uk_Go                   = 'Почати';
  uk_Info                 = 'Опис ';
  uk_Language             = 'Мова';
  uk_Matches              = 'Співпадіння';
  uk_MessageId            = 'Id листа';
  uk_ModuleName           = 'Назва модуля';
  uk_NoDataToDisplay      = 'Немає даних для відображення';
  uk_Ok                   = 'Ок';
  uk_OpenEmail            = 'Відкрити email';
  uk_OpenFile             = 'Відкрити файл';
  uk_OpenLogFile          = 'Відкрити файл журналу';
  uk_Operation            = 'Операція';
  uk_Parameter            = 'Параметр';
  uk_ParameterName        = 'Назва параметра';
  uk_Parameters           = 'Параметри';
  uk_ParseBodyAsHTML      = 'Парсити тіло регулярними виразами як HTML-текст';
  uk_Path                 = 'Шлях';
  uk_PathForAttachments   = 'Шляхи для збереження вкладень';
  uk_PathsToFindFiles     = 'Шляхи для пошуку файлів';
  uk_Position             = 'Позиція';
  uk_Print                = 'Друк';
  uk_ProgramShutdown      = 'Закриття програми';
  uk_ProgramStopsWorking  = 'Програму буде зупинено!';
  uk_ProgramVersion       = 'Версія';
  uk_Refresh              = 'Оновити';
  uk_RegExpTemplate       = 'Шаблон регулярного виразу';
  uk_Save                 = 'Зберегти';
  uk_Script               = 'Сценарій';
  uk_Search               = 'Пошук';
  uk_Server               = 'Сервер';
  uk_StartSearch          = 'Почати пошук';
  uk_Subject              = 'Тема';
  uk_Successful           = 'Операція успішна';
  uk_SystemInfo           = 'Інформація про систему';
  uk_Text                 = 'Текст';
  uk_Time                 = 'Час';
  uk_Value                = 'Значення';
  uk_WithSubdir           = 'З підкаталогами';
  uk_UseLastGroup         = 'Використовувати лише останню групу співпадіння';
  uk_PlainText            = 'Простий текст';

const
   ArrayMessages: array[1 .. 76] of TMessageItem = (
    (Key: 'Add'                  ; En: en_Add;                  Uk: uk_Add),
    (Key: 'Attachment'           ; En: en_Attachment;           Uk: uk_Attachment),
    (Key: 'Backup'               ; En: en_Backup;               Uk: uk_Backup),
    (Key: 'BackupName'           ; En: en_BackupName;           Uk: uk_BackupName),
    (Key: 'Begin'                ; En: en_Begin;                Uk: uk_Begin),
    (Key: 'Body'                 ; En: en_Body;                 Uk: uk_Body),
    (Key: 'Break'                ; En: en_Break;                Uk: uk_Break),
    (Key: 'Cancel'               ; En: en_Cancel;               Uk: uk_Cancel),
    (Key: 'ClassName'            ; En: en_ClassName;            Uk: uk_ClassName),
    (Key: 'CollapseAll'          ; En: en_CollapseAll;          Uk: uk_CollapseAll),
    (Key: 'Compatibility'        ; En: en_Compatibility;        Uk: uk_Compatibility),
    (Key: 'CompHierarchy'        ; En: en_CompHierarchy;        Uk: uk_CompHierarchy),
    (Key: 'CompName'             ; En: en_CompName;             Uk: uk_CompName),
    (Key: 'ContentType'          ; En: en_ContentType;          Uk: uk_ContentType),
    (Key: 'Date'                 ; En: en_Date;                 Uk: uk_Date),
    (Key: 'Delete'               ; En: en_Delete;               Uk: uk_Delete),
    (Key: 'DeleteAttachments'    ; En: en_DeleteAttachments;    Uk: uk_DeleteAttachments),
    (Key: 'DirectoryNotFound'    ; En: en_DirectoryNotFound;    Uk: uk_DirectoryNotFound),
    (Key: 'Disabled'             ; En: en_Disabled;             Uk: uk_Disabled),
    (Key: 'Edit'                 ; En: en_Edit;                 Uk: uk_Edit),
    (Key: 'EditCommonParameters' ; En: en_EditCommonParameters; Uk: uk_EditCommonParameters),
    (Key: 'EditRegExpParameters' ; En: en_EditRegExpParameters; Uk: uk_EditRegExpParameters),
    (Key: 'Enabled'              ; En: en_Enabled;              Uk: uk_Enabled),
    (Key: 'End'                  ; En: en_End;                  Uk: uk_End),
    (Key: 'Error'                ; En: en_Error;                Uk: uk_Error),
    (Key: 'Errors'               ; En: en_Errors;               Uk: uk_Errors),
    (Key: 'Execution'            ; En: en_Execution;            Uk: uk_Execution),
    (Key: 'ExpandAll'            ; En: en_ExpandAll;            Uk: uk_ExpandAll),
    (Key: 'ExportToCSV'          ; En: en_ExportToCSV;          Uk: uk_ExportToCSV),
    (Key: 'ExportToExcel'        ; En: en_ExportToExcel;        Uk: uk_ExportToExcel),
    (Key: 'Failed'               ; En: en_Failed;               Uk: uk_Failed),
    (Key: 'FileExtensions'       ; En: en_FileExtensions;       Uk: uk_FileExtensions),
    (Key: 'FileIsDisabled'       ; En: en_FileIsDisabled;       Uk: uk_FileIsDisabled),
    (Key: 'FileName'             ; En: en_FileName;             Uk: uk_FileName),
    (Key: 'FileNotFound'         ; En: en_FileNotFound;         Uk: uk_FileNotFound),
    (Key: 'FoundFiles'           ; En: en_FoundFiles;           Uk: uk_FoundFiles),
    (Key: 'From'                 ; En: en_From;                 Uk: uk_From),
    (Key: 'GettingStarted'       ; En: en_GettingStarted;       Uk: uk_GettingStarted),
    (Key: 'Go'                   ; En: en_Go;                   Uk: uk_Go),
    (Key: 'Info'                 ; En: en_Info;                 Uk: uk_Info),
    (Key: 'Language'             ; En: en_Language;             Uk: uk_Language),
    (Key: 'Matches'              ; En: en_Matches;              Uk: uk_Matches),
    (Key: 'MessageId'            ; En: en_MessageId;            Uk: uk_MessageId),
    (Key: 'ModuleName'           ; En: en_ModuleName;           Uk: uk_ModuleName),
    (Key: 'NoDataToDisplay'      ; En: en_NoDataToDisplay;      Uk: uk_NoDataToDisplay),
    (Key: 'Ok'                   ; En: en_Ok;                   Uk: uk_Ok),
    (Key: 'OpenEmail'            ; En: en_OpenEmail;            Uk: uk_OpenEmail),
    (Key: 'OpenFile'             ; En: en_OpenFile;             Uk: uk_OpenFile),
    (Key: 'OpenLogFile'          ; En: en_OpenLogFile;          Uk: uk_OpenLogFile),
    (Key: 'Operation'            ; En: en_Operation;            Uk: uk_Operation),
    (Key: 'Parameter'            ; En: en_Parameter;            Uk: uk_Parameter),
    (Key: 'ParameterName'        ; En: en_ParameterName;        Uk: uk_ParameterName),
    (Key: 'Parameters'           ; En: en_Parameters;           Uk: uk_Parameters),
    (Key: 'ParseBodyAsHTML'      ; En: en_ParseBodyAsHTML;      Uk: uk_ParseBodyAsHTML),
    (Key: 'Path'                 ; En: en_Path;                 Uk: uk_Path),
    (Key: 'PathForAttachments'   ; En: en_PathForAttachments;   Uk: uk_PathForAttachments),
    (Key: 'PathsToFindFiles'     ; En: en_PathsToFindFiles;     Uk: uk_PathsToFindFiles),
    (Key: 'Position'             ; En: en_Position;             Uk: uk_Position),
    (Key: 'Print'                ; En: en_Print;                Uk: uk_Print),
    (Key: 'ProgramShutdown'      ; En: en_ProgramShutdown;      Uk: uk_ProgramShutdown),
    (Key: 'ProgramStopsWorking'  ; En: en_ProgramStopsWorking;  Uk: uk_ProgramStopsWorking),
    (Key: 'ProgramVersion'       ; En: en_ProgramVersion;       Uk: uk_ProgramVersion),
    (Key: 'Refresh'              ; En: en_Refresh;              Uk: uk_Refresh),
    (Key: 'RegExpTemplate'       ; En: en_RegExpTemplate;       Uk: uk_RegExpTemplate),
    (Key: 'Save'                 ; En: en_Save;                 Uk: uk_Save),
    (Key: 'Search'               ; En: en_Search;               Uk: uk_Search),
    (Key: 'PlainText'            ; En: en_PlainText;            Uk: uk_PlainText),
    (Key: 'StartSearch'          ; En: en_StartSearch;          Uk: uk_StartSearch),
    (Key: 'Subject'              ; En: en_Subject;              Uk: uk_Subject),
    (Key: 'Successful'           ; En: en_Successful;           Uk: uk_Successful),
    (Key: 'SystemInfo'           ; En: en_SystemInfo;           Uk: uk_SystemInfo),
    (Key: 'Text'                 ; En: en_Text;                 Uk: uk_Text),
    (Key: 'Time'                 ; En: en_Time;                 Uk: uk_Time),
    (Key: 'UseLastGroup'         ; En: en_UseLastGroup;         Uk: uk_UseLastGroup),
    (Key: 'Value'                ; En: en_Value;                Uk: uk_Value),
    (Key: 'WithSubdir'           ; En: en_WithSubdir;           Uk: uk_WithSubdir)
     );

 implementation

 end.
