﻿{*******************************************************************}
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
  en_AhoCorasick          = 'Aho Corasick Algorithm';
  en_AllAttachments       = 'All attachments';
  en_AllCheck             = 'Set all checks';
  en_AllUnCheck           = 'Remove all checks';
  en_Attachment           = 'Attachment';
  en_Begin                = 'begin';
  en_Body                 = 'Body';
  en_Break                = 'Break';
  en_BruteForce           = 'Brute force';
  en_Cancel               = 'Cancel';
  en_ClassName            = 'Class name';
  en_CollapseAll          = 'Collapse All';
  en_Color                = 'Color';
  en_ColumnSettings       = 'Column settings';
  en_Compatibility        = 'Compatibility';
  en_CompHierarchy        = 'Components hierarchy';
  en_CompName             = 'Component name';
  en_ContentType          = 'Content Type';
  en_Copy                 = 'Copy';
  en_Date                 = 'Date';
  en_Delete               = 'Delete';
  en_DeleteAttachments    = 'Delete attachments after analysis';
  en_DeleteFile           = 'Delete file';
  en_DeleteFilePrompt     = 'File "%s" will be deleted. Continue?';
  en_DeletePrompt         = 'Delete item "%s"?';
  en_DeleteSelected       = 'Delete Selected';
  en_DeleteSelectedPrompt = '%d items will be removed. Continue?';
  en_DirectoryNotFound    = 'Directory "%s" not found';
  en_Disabled             = 'Disabled';
  en_Down                 = 'Down';
  en_DuplicateCount       = 'Found %d records in DB / Duplicates';
  en_Edit                 = 'Edit';
  en_EditCommonParameters = 'Common parameters';
  en_EditRegExpParameters = 'RegExp parameters';
  en_Email                = 'Email';
  en_Emails               = 'Emails';
  en_Enabled              = 'Enabled';
  en_End                  = 'end';
  en_Error                = 'Error';
  en_Errors               = 'Errors';
  en_Examples             = 'Examples';
  en_Execution            = 'Execution of scripts';
  en_ExpandAll            = 'Expand All';
  en_ExportToCSV          = 'Export To CSV';
  en_ExportToExcel        = 'Export To Excel';
  en_ExtendedFilter       = 'Extended filter';
  en_Failed               = 'Operation was failed';
  en_FileExtensions       = 'File extensions to search';
  en_FileIsDisabled       = 'File "%s" is disabled';
  en_FileName             = 'File name';
  en_FileNotFound         = 'File "%s" not found';
  en_FileNotSelected      = 'No file selected';
  en_Filter               = 'Filter';
  en_FoundFiles           = 'Found %d files';
  en_From                 = 'From';
  en_GettingStarted       = 'Getting started';
  en_Go                   = 'Go';
  en_GroupIndex           = 'Group index';
  en_Hash                 = 'Hash';
  en_Id                   = 'Id';
  en_Import               = 'Import';
  en_Info                 = 'Info ';
  en_IsHTTPClientActive   = 'Is HTTP-client active?';
  en_IsLogginActive       = 'Write information to the log file';
  en_Language             = 'Language';
  en_LanguageOCR          = 'Language of optical character recognition';
  en_LoadProject          = 'Load current project';
  en_LoadRecordsFromDB    = 'Load records from DB at startup';
  en_Main                 = 'Main';
  en_Mask                 = 'Mask';
  en_Matches              = 'Matches';
  en_MaxSizeLogFile       = 'Max Size Of Log File (Mb)';
  en_MessageId            = 'Message Id';
  en_ModuleName           = 'Module name';
  en_Name                 = 'Name';
  en_NewNamePrompt        = 'Enter a name for the new template set';
  en_NewNameSet           = 'New template set';
  en_NoDataToDisplay      = 'No data to display';
  en_NoMatchFound         = 'No match found';
  en_NumberOfDays         = 'Number of days during which logs are stored';
  en_Ok                   = 'Ok';
  en_OpenEmail            = 'Open email';
  en_OpenFile             = 'Open File';
  en_OpenLocation         = 'Open Location';
  en_OpenLogFile          = 'Open Log File';
  en_OpenParsedText       = 'Open parsed text';
  en_Operation            = 'Operation';
  en_Options              = 'Options';
  en_Parameter            = 'Parameter';
  en_Parameters           = 'Parameters';
  en_Password             = 'Password';
  en_PasswordList         = 'Password list';
  en_PasswordNotFound     = 'Password not found';
  en_PasswordNotRequired  = 'Password is not required';
  en_Paste                = 'Paste';
  en_Path                 = 'Path';
  en_PathForAttachments   = 'Paths for saving attachments';
  en_PathNotExists        = 'Paths "%s" not exists';
  en_PathsToFindFiles     = 'Paths to find files';
  en_PathsToFindNotExists = 'Paths to find files not exists';
  en_PathsToFindSaveFiles = 'Paths';
  en_PathsToSaveFiles     = 'Paths for saving files';
  en_PlainText            = 'Plain Text';
  en_Position             = 'Position';
  en_Print                = 'Print';
  en_ProgramShutdown      = 'Program shutdown';
  en_ProgramStopsWorking  = 'Application will be terminated!';
  en_ProgramVersion       = 'Version';
  en_Project              = 'Project';
  en_Refresh              = 'Refresh';
  en_RegExpIsEmpty        = 'There are no regular expression patterns';
  en_RegExpTemplate       = 'RegExp Template';
  en_Results              = 'Results';
  en_SampleText           = 'Sample text';
  en_Save                 = 'Save';
  en_SaveAs               = 'Save as...';
  en_Script               = 'Script';
  en_Search               = 'Search';
  en_SearchComplete       = 'Search %d files complete';
  en_SearchDuplicateFiles = 'Search duplicate files';
  en_SelectAll            = 'Select all';
  en_Server               = 'Server';
  en_SetCurrent           = 'Set current';
  en_SetOfTemplates       = 'Set of templates';
  en_ShowSearchBar        = 'Show search bar';
  en_Size                 = 'Size';
  en_StartSearch          = 'Start Search';
  en_Style                = 'Style';
  en_Subject              = 'Subject';
  en_Successful           = 'Operation is successful';
  en_SystemInfo           = 'System information';
  en_TemplateName         = 'Template name';
  en_Text                 = 'Text';
  en_Time                 = 'Time';
  en_TypePattern          = 'Type pattern';
  en_Up                   = 'Up';
  en_UseOCR               = 'Use optical character recognition';
  en_UseRawText           = 'Use raw text';
  en_Utilities            = 'Utilities';
  en_Value                = 'Value';
  en_WithSubdir           = 'With subdir';

  //Ukrainian
  uk_Add                  = 'Додати';
  uk_AhoCorasick          = 'Алгоритм Ахо-Корасік';
  uk_AllAttachments       = 'Всі вкладення';
  uk_AllCheck             = 'Встановити позначки';
  uk_AllUnCheck           = 'Зняти всі позначки';
  uk_Attachment           = 'Вкладення';
  uk_Begin                = 'початок';
  uk_Body                 = 'Тіло';
  uk_Break                = 'Зупинити';
  uk_BruteForce           = 'Підбір паролів';
  uk_Cancel               = 'Скасувати';
  uk_ClassName            = 'Назва класу';
  uk_CollapseAll          = 'Згорнути все';
  uk_Color                = 'Колір';
  uk_ColumnSettings       = 'Налаштування стовпців';
  uk_Compatibility        = 'Сумісність';
  uk_CompHierarchy        = 'Ієрархія компонентів';
  uk_CompName             = 'Назва компонента';
  uk_ContentType          = 'Тип контенту';
  uk_Copy                 = 'Копіювати';
  uk_Date                 = 'Дата';
  uk_Delete               = 'Видалити';
  uk_DeleteAttachments    = 'Видалити вкладення після аналізу';
  uk_DeleteFile           = 'Видалити файл';
  uk_DeleteFilePrompt     = 'Файл "%s" буде видалено. Продовжити?';
  uk_DeletePrompt         = 'Видалити запис "%s"?';
  uk_DeleteSelected       = 'Видалити вибрані';
  uk_DeleteSelectedPrompt = 'Буде видалено %d записів. Продовжити?';
  uk_DirectoryNotFound    = 'Каталог "%s" не знайдено';
  uk_Disabled             = 'Вимкнено';
  uk_Down                 = 'Вниз';
  uk_DuplicateCount       = 'Знайдено %d записів в БД / дублікатів файлів';
  uk_Edit                 = 'Редагувати';
  uk_EditCommonParameters = 'Загальні параметри';
  uk_EditRegExpParameters = 'RegExp параметри';
  uk_Email                = 'Лист';
  uk_Emails               = 'Листи';
  uk_Enabled              = 'Увімкнено';
  uk_End                  = 'кінець';
  uk_Error                = 'Помилка';
  uk_Errors               = 'Помилки';
  uk_Examples             = 'Приклади';
  uk_Execution            = 'Виконання сценаріїв';
  uk_ExpandAll            = 'Розгорнути все';
  uk_ExportToCSV          = 'Експортувати до CSV';
  uk_ExportToExcel        = 'Експортувати до Excel';
  uk_ExtendedFilter       = 'Розширений фільтр';
  uk_Failed               = 'Операція була невдалою';
  uk_FileExtensions       = 'Розширення файлів для пошуку';
  uk_FileIsDisabled       = 'Файл "%s" вимкнено';
  uk_FileName             = 'Назва файлу';
  uk_FileNotFound         = 'Файл "%s" не знайдено';
  uk_FileNotSelected      = 'Файл не вибрано';
  uk_Filter               = 'Фільтрувати';
  uk_FoundFiles           = 'Знайдено %d файлів';
  uk_From                 = 'Відправник';
  uk_GettingStarted       = 'Початок роботи';
  uk_Go                   = 'Почати';
  uk_GroupIndex           = 'Індекс групи';
  uk_Hash                 = 'Хеш';
  uk_Id                   = 'Id';
  uk_Import               = 'Імпорт';
  uk_Info                 = 'Опис ';
  uk_IsHTTPClientActive   = 'Активувати HTTP-клієнта?';
  uk_IsLogginActive       = 'Записувати інформацію в лог-файл';
  uk_Language             = 'Мова';
  uk_LanguageOCR          = 'Мова системи розпізнавання текстів';
  uk_LoadProject          = 'Завантажити поточний проект';
  uk_LoadRecordsFromDB    = 'Завантажувати записи з БД при старті';
  uk_Main                 = 'Основне';
  uk_Mask                 = 'Маска';
  uk_Matches              = 'Співпадіння';
  uk_MaxSizeLogFile       = 'Максимальний розмір лог-файлу (Mb)';
  uk_MessageId            = 'Id листа';
  uk_ModuleName           = 'Назва модуля';
  uk_Name                 = 'Назва';
  uk_NewNamePrompt        = 'Введіть назву нового набору шаблонів';
  uk_NewNameSet           = 'Новий набір шаблонів';
  uk_NoDataToDisplay      = 'Немає даних для відображення';
  uk_NoMatchFound         = 'Співпадіння відсутні';
  uk_NumberOfDays         = 'Кількість днів, протягом яких зберігаються логи';
  uk_Ok                   = 'Ок';
  uk_OpenEmail            = 'Відкрити email';
  uk_OpenFile             = 'Відкрити файл';
  uk_OpenLocation         = 'Відкрити розташування';
  uk_OpenLogFile          = 'Відкрити журнал логування';
  uk_OpenParsedText       = 'Відкрити текст';
  uk_Operation            = 'Операція';
  uk_Options              = 'Опції';
  uk_Parameter            = 'Параметр';
  uk_Parameters           = 'Параметри';
  uk_Password             = 'Пароль';
  uk_PasswordList         = 'Список паролів';
  uk_PasswordNotFound     = 'Пароль не знайдено';
  uk_PasswordNotRequired  = 'Не потребує паролю';
  uk_Paste                = 'Вставити';
  uk_Path                 = 'Шлях';
  uk_PathForAttachments   = 'Шляхи для збереження вкладень';
  uk_PathNotExists        = 'Шлях "%s" не існує';
  uk_PathsToFindFiles     = 'Шляхи для пошуку файлів';
  uk_PathsToFindNotExists = 'Шляхи для пошуку файлів відсутні';
  uk_PathsToFindSaveFiles = 'Шляхи';
  uk_PathsToSaveFiles     = 'Шляхи для збереження файлів';
  uk_PlainText            = 'Простий текст';
  uk_Position             = 'Позиція';
  uk_Print                = 'Друк';
  uk_ProgramShutdown      = 'Закриття програми';
  uk_ProgramStopsWorking  = 'Програму буде зупинено!';
  uk_ProgramVersion       = 'Версія';
  uk_Project              = 'Проект';
  uk_Refresh              = 'Оновити';
  uk_RegExpIsEmpty        = 'Шаблони регулярних виразів відсутні';
  uk_RegExpTemplate       = 'Шаблон регулярного виразу';
  uk_Results              = 'Результат';
  uk_SampleText           = 'Приклад тексту';
  uk_Save                 = 'Зберегти';
  uk_SaveAs               = 'Зберегти як...';
  uk_Script               = 'Сценарій';
  uk_Search               = 'Пошук та парсинг';
  uk_SearchComplete       = 'Пошук %d файлів завершено.';
  uk_SearchDuplicateFiles = 'Пошук дублікатів файлів';
  uk_SelectAll            = 'Виділити все';
  uk_Server               = 'Сервер';
  uk_SetCurrent           = 'Встановити поточним';
  uk_SetOfTemplates       = 'Набір шаблонів';
  uk_ShowSearchBar        = 'Показати панель пошуку';
  uk_Size                 = 'Розмір';
  uk_StartSearch          = 'Почати пошук';
  uk_Style                = 'Стиль';
  uk_Subject              = 'Тема';
  uk_Successful           = 'Операція успішна';
  uk_SystemInfo           = 'Інформація про систему';
  uk_TemplateName         = 'Назва шаблону';
  uk_Text                 = 'Текст';
  uk_Time                 = 'Час';
  uk_TypePattern          = 'Тип шаблону';
  uk_Up                   = 'Вгору';
  uk_UseOCR               = 'Використовувати систему розпізнавання текстів';
  uk_UseRawText           = 'Парсити сирий текст';
  uk_Utilities            = 'Утиліти';
  uk_Value                = 'Значення';
  uk_WithSubdir           = 'З підкаталогами';

const
   ArrayMessages: array[1 .. 140] of TMessageItem = (
    (Key: 'Add'                  ; En: en_Add;                  Uk: uk_Add),
    (Key: 'AhoCorasick'          ; En: en_AhoCorasick;          Uk: uk_AhoCorasick),
    (Key: 'AllAttachments'       ; En: en_AllAttachments;       Uk: uk_AllAttachments),
    (Key: 'AllCheck'             ; En: en_AllCheck;             Uk: uk_AllCheck),
    (Key: 'AllUnCheck'           ; En: en_AllUnCheck;           Uk: uk_AllUnCheck),
    (Key: 'Attachment'           ; En: en_Attachment;           Uk: uk_Attachment),
    (Key: 'Begin'                ; En: en_Begin;                Uk: uk_Begin),
    (Key: 'Body'                 ; En: en_Body;                 Uk: uk_Body),
    (Key: 'Break'                ; En: en_Break;                Uk: uk_Break),
    (Key: 'BruteForce'           ; En: en_BruteForce;           Uk: uk_BruteForce),
    (Key: 'Cancel'               ; En: en_Cancel;               Uk: uk_Cancel),
    (Key: 'ClassName'            ; En: en_ClassName;            Uk: uk_ClassName),
    (Key: 'CollapseAll'          ; En: en_CollapseAll;          Uk: uk_CollapseAll),
    (Key: 'Color'                ; En: en_Color;                Uk: uk_Color),
    (Key: 'ColumnSettings'       ; En: en_ColumnSettings;       Uk: uk_ColumnSettings),
    (Key: 'Compatibility'        ; En: en_Compatibility;        Uk: uk_Compatibility),
    (Key: 'CompHierarchy'        ; En: en_CompHierarchy;        Uk: uk_CompHierarchy),
    (Key: 'CompName'             ; En: en_CompName;             Uk: uk_CompName),
    (Key: 'ContentType'          ; En: en_ContentType;          Uk: uk_ContentType),
    (Key: 'Copy'                 ; En: en_Copy;                 Uk: uk_Copy),
    (Key: 'Date'                 ; En: en_Date;                 Uk: uk_Date),
    (Key: 'Delete'               ; En: en_Delete;               Uk: uk_Delete),
    (Key: 'DeleteAttachments'    ; En: en_DeleteAttachments;    Uk: uk_DeleteAttachments),
    (Key: 'DeleteFile'           ; En: en_DeleteFile;           Uk: uk_DeleteFile),
    (Key: 'DeleteFilePrompt'     ; En: en_DeleteFilePrompt;     Uk: uk_DeleteFilePrompt),
    (Key: 'DeletePrompt'         ; En: en_DeletePrompt;         Uk: uk_DeletePrompt),
    (Key: 'DeleteSelected'       ; En: en_DeleteSelected;       Uk: uk_DeleteSelected),
    (Key: 'DeleteSelectedPrompt' ; En: en_DeleteSelectedPrompt; Uk: uk_DeleteSelectedPrompt),
    (Key: 'DirectoryNotFound'    ; En: en_DirectoryNotFound;    Uk: uk_DirectoryNotFound),
    (Key: 'Disabled'             ; En: en_Disabled;             Uk: uk_Disabled),
    (Key: 'Down'                 ; En: en_Down;                 Uk: uk_Down),
    (Key: 'DuplicateCount'       ; En: en_DuplicateCount;       Uk: uk_DuplicateCount),
    (Key: 'Edit'                 ; En: en_Edit;                 Uk: uk_Edit),
    (Key: 'EditCommonParameters' ; En: en_EditCommonParameters; Uk: uk_EditCommonParameters),
    (Key: 'EditRegExpParameters' ; En: en_EditRegExpParameters; Uk: uk_EditRegExpParameters),
    (Key: 'Email'                ; En: en_Email;                Uk: uk_Email),
    (Key: 'Emails'               ; En: en_Emails;               Uk: uk_Emails),
    (Key: 'Enabled'              ; En: en_Enabled;              Uk: uk_Enabled),
    (Key: 'End'                  ; En: en_End;                  Uk: uk_End),
    (Key: 'Error'                ; En: en_Error;                Uk: uk_Error),
    (Key: 'Errors'               ; En: en_Errors;               Uk: uk_Errors),
    (Key: 'Examples'             ; En: en_Examples;             Uk: uk_Examples),
    (Key: 'Execution'            ; En: en_Execution;            Uk: uk_Execution),
    (Key: 'ExpandAll'            ; En: en_ExpandAll;            Uk: uk_ExpandAll),
    (Key: 'ExportToCSV'          ; En: en_ExportToCSV;          Uk: uk_ExportToCSV),
    (Key: 'ExportToExcel'        ; En: en_ExportToExcel;        Uk: uk_ExportToExcel),
    (Key: 'ExtendedFilter'       ; En: en_ExtendedFilter;       Uk: uk_ExtendedFilter),
    (Key: 'Failed'               ; En: en_Failed;               Uk: uk_Failed),
    (Key: 'FileExtensions'       ; En: en_FileExtensions;       Uk: uk_FileExtensions),
    (Key: 'FileIsDisabled'       ; En: en_FileIsDisabled;       Uk: uk_FileIsDisabled),
    (Key: 'FileName'             ; En: en_FileName;             Uk: uk_FileName),
    (Key: 'FileNotFound'         ; En: en_FileNotFound;         Uk: uk_FileNotFound),
    (Key: 'FileNotSelected'      ; En: en_FileNotSelected;      Uk: uk_FileNotSelected),
    (Key: 'Filter'               ; En: en_Filter;               Uk: uk_Filter),
    (Key: 'FoundFiles'           ; En: en_FoundFiles;           Uk: uk_FoundFiles),
    (Key: 'From'                 ; En: en_From;                 Uk: uk_From),
    (Key: 'GettingStarted'       ; En: en_GettingStarted;       Uk: uk_GettingStarted),
    (Key: 'Go'                   ; En: en_Go;                   Uk: uk_Go),
    (Key: 'GroupIndex'           ; En: en_GroupIndex;           Uk: uk_GroupIndex),
    (Key: 'Hash'                 ; En: en_Hash;                 Uk: uk_Hash),
    (Key: 'Id'                   ; En: en_Id;                   Uk: uk_Id),
    (Key: 'Import'               ; En: en_Import;               Uk: uk_Import),
    (Key: 'Info'                 ; En: en_Info;                 Uk: uk_Info),
    (Key: 'IsHTTPClientActive'   ; En: en_IsHTTPClientActive;   Uk: uk_IsHTTPClientActive),
    (Key: 'IsLogginActive'       ; En: en_IsLogginActive;       Uk: uk_IsLogginActive),
    (Key: 'Language'             ; En: en_Language;             Uk: uk_Language),
    (Key: 'LanguageOCR'          ; En: en_LanguageOCR;          Uk: uk_LanguageOCR),
    (Key: 'LoadProject'          ; En: en_LoadProject;          Uk: uk_LoadProject),
    (Key: 'LoadRecordsFromDB'    ; En: en_LoadRecordsFromDB;    Uk: uk_LoadRecordsFromDB),
    (Key: 'Main'                 ; En: en_Main;                 Uk: uk_Main),
    (Key: 'Mask'                 ; En: en_Mask;                 Uk: uk_Mask),
    (Key: 'Matches'              ; En: en_Matches;              Uk: uk_Matches),
    (Key: 'MaxSizeLogFile'       ; En: en_MaxSizeLogFile;       Uk: uk_MaxSizeLogFile),
    (Key: 'MessageId'            ; En: en_MessageId;            Uk: uk_MessageId),
    (Key: 'ModuleName'           ; En: en_ModuleName;           Uk: uk_ModuleName),
    (Key: 'Name'                 ; En: en_Name;                 Uk: uk_Name),
    (Key: 'NewNamePrompt'        ; En: en_NewNamePrompt;        Uk: uk_NewNamePrompt),
    (Key: 'NewNameSet'           ; En: en_NewNameSet;           Uk: uk_NewNameSet),
    (Key: 'NoDataToDisplay'      ; En: en_NoDataToDisplay;      Uk: uk_NoDataToDisplay),
    (Key: 'NoMatchFound'         ; En: en_NoMatchFound;         Uk: uk_NoMatchFound),
    (Key: 'NumberOfDays'         ; En: en_NumberOfDays;         Uk: uk_NumberOfDays),
    (Key: 'Ok'                   ; En: en_Ok;                   Uk: uk_Ok),
    (Key: 'OpenEmail'            ; En: en_OpenEmail;            Uk: uk_OpenEmail),
    (Key: 'OpenFile'             ; En: en_OpenFile;             Uk: uk_OpenFile),
    (Key: 'OpenLocation'         ; En: en_OpenLocation;         Uk: uk_OpenLocation),
    (Key: 'OpenLogFile'          ; En: en_OpenLogFile;          Uk: uk_OpenLogFile),
    (Key: 'OpenParsedText'       ; En: en_OpenParsedText;       Uk: uk_OpenParsedText),
    (Key: 'Operation'            ; En: en_Operation;            Uk: uk_Operation),
    (Key: 'Options'              ; En: en_Options;              Uk: uk_Options),
    (Key: 'Parameter'            ; En: en_Parameter;            Uk: uk_Parameter),
    (Key: 'Parameters'           ; En: en_Parameters;           Uk: uk_Parameters),
    (Key: 'Password'             ; En: en_Password;             Uk: uk_Password),
    (Key: 'PasswordList'         ; En: en_PasswordList;         Uk: uk_PasswordList),
    (Key: 'PasswordNotFound'     ; En: en_PasswordNotFound;     Uk: uk_PasswordNotFound),
    (Key: 'PasswordNotRequired'  ; En: en_PasswordNotRequired;  Uk: uk_PasswordNotRequired),
    (Key: 'Paste'                ; En: en_Paste;                Uk: uk_Paste),
    (Key: 'Path'                 ; En: en_Path;                 Uk: uk_Path),
    (Key: 'PathForAttachments'   ; En: en_PathForAttachments;   Uk: uk_PathForAttachments),
    (Key: 'PathNotExists'        ; En: en_PathNotExists;        Uk: uk_PathNotExists),
    (Key: 'PathsToFindFiles'     ; En: en_PathsToFindFiles;     Uk: uk_PathsToFindFiles),
    (Key: 'PathsToFindNotExists' ; En: en_PathsToFindNotExists; Uk: uk_PathsToFindNotExists),
    (Key: 'PathsToFindSaveFiles' ; En: en_PathsToFindSaveFiles; Uk: uk_PathsToFindSaveFiles),
    (Key: 'PathsToSaveFiles'     ; En: en_PathsToSaveFiles;     Uk: uk_PathsToSaveFiles),
    (Key: 'PlainText'            ; En: en_PlainText;            Uk: uk_PlainText),
    (Key: 'Position'             ; En: en_Position;             Uk: uk_Position),
    (Key: 'Print'                ; En: en_Print;                Uk: uk_Print),
    (Key: 'ProgramShutdown'      ; En: en_ProgramShutdown;      Uk: uk_ProgramShutdown),
    (Key: 'ProgramStopsWorking'  ; En: en_ProgramStopsWorking;  Uk: uk_ProgramStopsWorking),
    (Key: 'ProgramVersion'       ; En: en_ProgramVersion;       Uk: uk_ProgramVersion),
    (Key: 'Project'              ; En: en_Project;              Uk: uk_Project),
    (Key: 'Refresh'              ; En: en_Refresh;              Uk: uk_Refresh),
    (Key: 'RegExpIsEmpty'        ; En: en_RegExpIsEmpty;        Uk: uk_RegExpIsEmpty),
    (Key: 'RegExpTemplate'       ; En: en_RegExpTemplate;       Uk: uk_RegExpTemplate),
    (Key: 'Results'              ; En: en_Results;              Uk: uk_Results),
    (Key: 'SampleText'           ; En: en_SampleText;           Uk: uk_SampleText),
    (Key: 'Save'                 ; En: en_Save;                 Uk: uk_Save),
    (Key: 'SaveAs'               ; En: en_SaveAs;               Uk: uk_SaveAs),
    (Key: 'Search'               ; En: en_Search;               Uk: uk_Search),
    (Key: 'SearchComplete'       ; En: en_SearchComplete;       Uk: uk_SearchComplete),
    (Key: 'SearchDuplicateFiles' ; En: en_SearchDuplicateFiles; Uk: uk_SearchDuplicateFiles),
    (Key: 'SelectAll'            ; En: en_SelectAll;            Uk: uk_SelectAll),
    (Key: 'SetCurrent'           ; En: en_SetCurrent;           Uk: uk_SetCurrent),
    (Key: 'SetOfTemplates'       ; En: en_SetOfTemplates;       Uk: uk_SetOfTemplates),
    (Key: 'ShowSearchBar'        ; En: en_ShowSearchBar;        Uk: uk_ShowSearchBar),
    (Key: 'Size'                 ; En: en_Size;                 Uk: uk_Size),
    (Key: 'StartSearch'          ; En: en_StartSearch;          Uk: uk_StartSearch),
    (Key: 'Style'                ; En: en_Style;                Uk: uk_Style),
    (Key: 'Subject'              ; En: en_Subject;              Uk: uk_Subject),
    (Key: 'Successful'           ; En: en_Successful;           Uk: uk_Successful),
    (Key: 'SystemInfo'           ; En: en_SystemInfo;           Uk: uk_SystemInfo),
    (Key: 'TemplateName'         ; En: en_TemplateName;         Uk: uk_TemplateName),
    (Key: 'Text'                 ; En: en_Text;                 Uk: uk_Text),
    (Key: 'Time'                 ; En: en_Time;                 Uk: uk_Time),
    (Key: 'TypePattern'          ; En: en_TypePattern;          Uk: uk_TypePattern),
    (Key: 'Up'                   ; En: en_Up;                   Uk: uk_Up),
    (Key: 'UseOCR'               ; En: en_UseOCR;               Uk: uk_UseOCR),
    (Key: 'UseRawText'           ; En: en_UseRawText;           Uk: uk_UseRawText),
    (Key: 'Utilities'            ; En: en_Utilities;            Uk: uk_Utilities),
    (Key: 'Value'                ; En: en_Value;                Uk: uk_Value),
    (Key: 'WithSubdir'           ; En: en_WithSubdir;           Uk: uk_WithSubdir)
     );

 implementation

 end.
