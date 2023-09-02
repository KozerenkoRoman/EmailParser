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
  en_AllAttachments       = 'All attachments';
  en_Attachment           = 'Attachment';
  en_Begin                = 'begin';
  en_Body                 = 'Body';
  en_Break                = 'Break';
  en_Cancel               = 'Cancel';
  en_ClassName            = 'Class name';
  en_CollapseAll          = 'Collapse All';
  en_ColumnSettings       = 'Column settings';
  en_Compatibility        = 'Compatibility';
  en_CompHierarchy        = 'Components hierarchy';
  en_CompName             = 'Component name';
  en_ContentType          = 'Content Type';
  en_Copy                 = 'Copy';
  en_Date                 = 'Date';
  en_Delete               = 'Delete';
  en_DeleteAttachments    = 'Delete attachments after analysis';
  en_DeletePrompt         = 'Delete item "%s"?';
  en_DirectoryNotFound    = 'Directory "%s" not found';
  en_Disabled             = 'Disabled';
  en_DuplicateCount       = 'Found %d records in DB';
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
  en_Failed               = 'Operation was failed';
  en_FileExtensions       = 'File extensions to search';
  en_FileIsDisabled       = 'File "%s" is disabled';
  en_FileName             = 'File name';
  en_FileNotFound         = 'File "%s" not found';
  en_FoundFiles           = 'Found %d files';
  en_From                 = 'From';
  en_GettingStarted       = 'Getting started';
  en_Go                   = 'Go';
  en_GroupIndex           = 'Group index';
  en_Info                 = 'Info ';
  en_Language             = 'Language';
  en_Mask                 = 'Mask';
  en_Matches              = 'Matches';
  en_MessageId            = 'Message Id';
  en_ModuleName           = 'Module name';
  en_NewNamePrompt        = 'Enter a name for the new template set';
  en_NewNameSet           = 'New template set';
  en_NoDataToDisplay      = 'No data to display';
  en_NoMatchFound         = 'No match found';
  en_Ok                   = 'Ok';
  en_OpenEmail            = 'Open email';
  en_OpenFile             = 'Open File';
  en_OpenLogFile          = 'Open Log File';
  en_Operation            = 'Operation';
  en_Options              = 'Options';
  en_Parameter            = 'Parameter';
  en_Parameters           = 'Parameters';
  en_UseRawText           = 'Use raw text';
  en_Paste                = 'Paste';
  en_Path                 = 'Path';
  en_PathForAttachments   = 'Paths for saving attachments';
  en_PathsToFindFiles     = 'Paths to find files';
  en_PathsToFindSaveFiles = 'Paths for search and saving attachments';
  en_PathsToSaveFiles     = 'Paths for saving files';
  en_PlainText            = 'Plain Text';
  en_Position             = 'Position';
  en_Print                = 'Print';
  en_ProgramShutdown      = 'Program shutdown';
  en_ProgramStopsWorking  = 'Application will be terminated!';
  en_ProgramVersion       = 'Version';
  en_Refresh              = 'Refresh';
  en_RegExpTemplate       = 'RegExp Template';
  en_Results              = 'Results';
  en_SampleText           = 'Sample Text';
  en_Save                 = 'Save';
  en_SaveAs               = 'Save as...';
  en_Script               = 'Script';
  en_Search               = 'Search';
  en_SearchComplete       = 'Search complete';
  en_SelectAll            = 'SelectAll';
  en_Server               = 'Server';
  en_SetOfTemplates       = 'Set of templates';
  en_StartSearch          = 'Start Search';
  en_Subject              = 'Subject';
  en_Successful           = 'Operation is successful';
  en_SystemInfo           = 'System Information';
  en_TemplateName         = 'Template name';
  en_Text                 = 'Text';
  en_Time                 = 'Time';
  en_Value                = 'Value';
  en_WithSubdir           = 'With subdir';

  //Ukrainian
  uk_Add                  = 'Додати';
  uk_AllAttachments       = 'Всі вкладення';
  uk_Attachment           = 'Вкладення';
  uk_Begin                = 'початок';
  uk_Body                 = 'Тіло';
  uk_Break                = 'Зупинити';
  uk_Cancel               = 'Скасувати';
  uk_ClassName            = 'Назва класу';
  uk_CollapseAll          = 'Згорнути все';
  uk_ColumnSettings       = 'Налаштування стовпців';
  uk_Compatibility        = 'Сумісність';
  uk_CompHierarchy        = 'Ієрархія компонентів';
  uk_CompName             = 'Назва компонента';
  uk_ContentType          = 'Тип контенту';
  uk_Copy                 = 'Копіювати';
  uk_Date                 = 'Дата';
  uk_Delete               = 'Видалити';
  uk_DeleteAttachments    = 'Видалити вкладення після аналізу';
  uk_DeletePrompt         = 'Видалити запис "%s"?';
  uk_DirectoryNotFound    = 'Каталог "%s" не знайдено';
  uk_Disabled             = 'Вимкнено';
  uk_DuplicateCount       = 'Знайдено %d записів в БД';
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
  uk_Failed               = 'Операція була невдалою';
  uk_FileExtensions       = 'Розширення файлів для пошуку';
  uk_FileIsDisabled       = 'Файл "%s" вимкнено';
  uk_FileName             = 'Назва файлу';
  uk_FileNotFound         = 'Файл "%s" не знайдено';
  uk_FoundFiles           = 'Знайдено %d файлів';
  uk_From                 = 'Відправник';
  uk_GettingStarted       = 'Початок роботи';
  uk_Go                   = 'Почати';
  uk_GroupIndex           = 'Індекс групи';
  uk_Info                 = 'Опис ';
  uk_Language             = 'Мова';
  uk_Mask                 = 'Маска';
  uk_Matches              = 'Співпадіння';
  uk_MessageId            = 'Id листа';
  uk_ModuleName           = 'Назва модуля';
  uk_NewNamePrompt        = 'Введіть назву нового набору шаблонів';
  uk_NewNameSet           = 'Новий набір шаблонів';
  uk_NoDataToDisplay      = 'Немає даних для відображення';
  uk_NoMatchFound         = 'Співпадіння відсутні';
  uk_Ok                   = 'Ок';
  uk_OpenEmail            = 'Відкрити email';
  uk_OpenFile             = 'Відкрити файл';
  uk_OpenLogFile          = 'Відкрити файл журналу';
  uk_Operation            = 'Операція';
  uk_Options              = 'Опції';
  uk_Parameter            = 'Параметр';
  uk_Parameters           = 'Параметри';
  uk_UseRawText           = 'Парсити сирий текст';
  uk_Paste                = 'Вставити';
  uk_Path                 = 'Шлях';
  uk_PathForAttachments   = 'Шляхи для збереження вкладень';
  uk_PathsToFindFiles     = 'Шляхи для пошуку файлів';
  uk_PathsToFindSaveFiles = 'Шляхи для пошуку та збереження файлів';
  uk_PathsToSaveFiles     = 'Шляхи для збереження файлів';
  uk_PlainText            = 'Простий текст';
  uk_Position             = 'Позиція';
  uk_Print                = 'Друк';
  uk_ProgramShutdown      = 'Закриття програми';
  uk_ProgramStopsWorking  = 'Програму буде зупинено!';
  uk_ProgramVersion       = 'Версія';
  uk_Refresh              = 'Оновити';
  uk_RegExpTemplate       = 'Шаблон регулярного виразу';
  uk_Results              = 'Результат';
  uk_SampleText           = 'Приклад тексту';
  uk_Save                 = 'Зберегти';
  uk_SaveAs               = 'Зберегти як...';
  uk_Script               = 'Сценарій';
  uk_Search               = 'Пошук';
  uk_SearchComplete       = 'Пошук завершено';
  uk_SelectAll            = 'Виділити все';
  uk_Server               = 'Сервер';
  uk_SetOfTemplates       = 'Набір шаблонів';
  uk_StartSearch          = 'Почати пошук';
  uk_Subject              = 'Тема';
  uk_Successful           = 'Операція успішна';
  uk_SystemInfo           = 'Інформація про систему';
  uk_TemplateName         = 'Назва шаблону';
  uk_Text                 = 'Текст';
  uk_Time                 = 'Час';
  uk_Value                = 'Значення';
  uk_WithSubdir           = 'З підкаталогами';

const
   ArrayMessages: array[1 .. 96] of TMessageItem = (
    (Key: 'Add'                  ; En: en_Add;                  Uk: uk_Add),
    (Key: 'AllAttachments'       ; En: en_AllAttachments;       Uk: uk_AllAttachments),
    (Key: 'Attachment'           ; En: en_Attachment;           Uk: uk_Attachment),
    (Key: 'Begin'                ; En: en_Begin;                Uk: uk_Begin),
    (Key: 'Body'                 ; En: en_Body;                 Uk: uk_Body),
    (Key: 'Break'                ; En: en_Break;                Uk: uk_Break),
    (Key: 'Cancel'               ; En: en_Cancel;               Uk: uk_Cancel),
    (Key: 'ClassName'            ; En: en_ClassName;            Uk: uk_ClassName),
    (Key: 'CollapseAll'          ; En: en_CollapseAll;          Uk: uk_CollapseAll),
    (Key: 'ColumnSettings'       ; En: en_ColumnSettings;       Uk: uk_ColumnSettings),
    (Key: 'Compatibility'        ; En: en_Compatibility;        Uk: uk_Compatibility),
    (Key: 'CompHierarchy'        ; En: en_CompHierarchy;        Uk: uk_CompHierarchy),
    (Key: 'CompName'             ; En: en_CompName;             Uk: uk_CompName),
    (Key: 'ContentType'          ; En: en_ContentType;          Uk: uk_ContentType),
    (Key: 'Copy'                 ; En: en_Copy;                 Uk: uk_Copy),
    (Key: 'Date'                 ; En: en_Date;                 Uk: uk_Date),
    (Key: 'Delete'               ; En: en_Delete;               Uk: uk_Delete),
    (Key: 'DeleteAttachments'    ; En: en_DeleteAttachments;    Uk: uk_DeleteAttachments),
    (Key: 'DeletePrompt'         ; En: en_DeletePrompt;         Uk: uk_DeletePrompt),
    (Key: 'DirectoryNotFound'    ; En: en_DirectoryNotFound;    Uk: uk_DirectoryNotFound),
    (Key: 'Disabled'             ; En: en_Disabled;             Uk: uk_Disabled),
    (Key: 'Edit'                 ; En: en_Edit;                 Uk: uk_Edit),
    (Key: 'EditCommonParameters' ; En: en_EditCommonParameters; Uk: uk_EditCommonParameters),
    (Key: 'EditRegExpParameters' ; En: en_EditRegExpParameters; Uk: uk_EditRegExpParameters),
    (Key: 'Emails'               ; En: en_Emails;               Uk: uk_Emails),
    (Key: 'Email'                ; En: en_Email;                Uk: uk_Email),
    (Key: 'Enabled'              ; En: en_Enabled;              Uk: uk_Enabled),
    (Key: 'End'                  ; En: en_End;                  Uk: uk_End),
    (Key: 'Error'                ; En: en_Error;                Uk: uk_Error),
    (Key: 'Errors'               ; En: en_Errors;               Uk: uk_Errors),
    (Key: 'Examples'             ; En: en_Examples;             Uk: uk_Examples),
    (Key: 'Execution'            ; En: en_Execution;            Uk: uk_Execution),
    (Key: 'ExpandAll'            ; En: en_ExpandAll;            Uk: uk_ExpandAll),
    (Key: 'ExportToCSV'          ; En: en_ExportToCSV;          Uk: uk_ExportToCSV),
    (Key: 'ExportToExcel'        ; En: en_ExportToExcel;        Uk: uk_ExportToExcel),
    (Key: 'Failed'               ; En: en_Failed;               Uk: uk_Failed),
    (Key: 'FileExtensions'       ; En: en_FileExtensions;       Uk: uk_FileExtensions),
    (Key: 'FileIsDisabled'       ; En: en_FileIsDisabled;       Uk: uk_FileIsDisabled),
    (Key: 'FileName'             ; En: en_FileName;             Uk: uk_FileName),
    (Key: 'FileNotFound'         ; En: en_FileNotFound;         Uk: uk_FileNotFound),
    (Key: 'DuplicateCount'       ; En: en_DuplicateCount;       Uk: uk_DuplicateCount),
    (Key: 'FoundFiles'           ; En: en_FoundFiles;           Uk: uk_FoundFiles),
    (Key: 'From'                 ; En: en_From;                 Uk: uk_From),
    (Key: 'GettingStarted'       ; En: en_GettingStarted;       Uk: uk_GettingStarted),
    (Key: 'Go'                   ; En: en_Go;                   Uk: uk_Go),
    (Key: 'GroupIndex'           ; En: en_GroupIndex;           Uk: uk_GroupIndex),
    (Key: 'Info'                 ; En: en_Info;                 Uk: uk_Info),
    (Key: 'Language'             ; En: en_Language;             Uk: uk_Language),
    (Key: 'Matches'              ; En: en_Matches;              Uk: uk_Matches),
    (Key: 'Mask'                 ; En: en_Mask;                 Uk: uk_Mask),
    (Key: 'MessageId'            ; En: en_MessageId;            Uk: uk_MessageId),
    (Key: 'ModuleName'           ; En: en_ModuleName;           Uk: uk_ModuleName),
    (Key: 'NewNamePrompt'        ; En: en_NewNamePrompt;        Uk: uk_NewNamePrompt),
    (Key: 'NewNameSet'           ; En: en_NewNameSet;           Uk: uk_NewNameSet),
    (Key: 'NoDataToDisplay'      ; En: en_NoDataToDisplay;      Uk: uk_NoDataToDisplay),
    (Key: 'NoMatchFound'         ; En: en_NoMatchFound;         Uk: uk_NoMatchFound),
    (Key: 'Ok'                   ; En: en_Ok;                   Uk: uk_Ok),
    (Key: 'OpenEmail'            ; En: en_OpenEmail;            Uk: uk_OpenEmail),
    (Key: 'OpenFile'             ; En: en_OpenFile;             Uk: uk_OpenFile),
    (Key: 'OpenLogFile'          ; En: en_OpenLogFile;          Uk: uk_OpenLogFile),
    (Key: 'Operation'            ; En: en_Operation;            Uk: uk_Operation),
    (Key: 'Options'              ; En: en_Options;              Uk: uk_Options),
    (Key: 'Parameter'            ; En: en_Parameter;            Uk: uk_Parameter),
    (Key: 'Parameters'           ; En: en_Parameters;           Uk: uk_Parameters),
    (Key: 'Paste'                ; En: en_Paste;                Uk: uk_Paste),
    (Key: 'Path'                 ; En: en_Path;                 Uk: uk_Path),
    (Key: 'PathForAttachments'   ; En: en_PathForAttachments;   Uk: uk_PathForAttachments),
    (Key: 'PathsToFindFiles'     ; En: en_PathsToFindFiles;     Uk: uk_PathsToFindFiles),
    (Key: 'PathsToFindSaveFiles' ; En: en_PathsToFindSaveFiles; Uk: uk_PathsToFindSaveFiles),
    (Key: 'PathsToSaveFiles'     ; En: en_PathsToSaveFiles;     Uk: uk_PathsToSaveFiles),
    (Key: 'PlainText'            ; En: en_PlainText;            Uk: uk_PlainText),
    (Key: 'Position'             ; En: en_Position;             Uk: uk_Position),
    (Key: 'Print'                ; En: en_Print;                Uk: uk_Print),
    (Key: 'ProgramShutdown'      ; En: en_ProgramShutdown;      Uk: uk_ProgramShutdown),
    (Key: 'ProgramStopsWorking'  ; En: en_ProgramStopsWorking;  Uk: uk_ProgramStopsWorking),
    (Key: 'ProgramVersion'       ; En: en_ProgramVersion;       Uk: uk_ProgramVersion),
    (Key: 'Refresh'              ; En: en_Refresh;              Uk: uk_Refresh),
    (Key: 'RegExpTemplate'       ; En: en_RegExpTemplate;       Uk: uk_RegExpTemplate),
    (Key: 'Results'              ; En: en_Results;              Uk: uk_Results),
    (Key: 'SampleText'           ; En: en_SampleText;           Uk: uk_SampleText),
    (Key: 'Save'                 ; En: en_Save;                 Uk: uk_Save),
    (Key: 'SaveAs'               ; En: en_SaveAs;               Uk: uk_SaveAs),
    (Key: 'Search'               ; En: en_Search;               Uk: uk_Search),
    (Key: 'SearchComplete'       ; En: en_SearchComplete;       Uk: uk_SearchComplete),
    (Key: 'SelectAll'            ; En: en_SelectAll;            Uk: uk_SelectAll),
    (Key: 'SetOfTemplates'       ; En: en_SetOfTemplates;       Uk: uk_SetOfTemplates),
    (Key: 'StartSearch'          ; En: en_StartSearch;          Uk: uk_StartSearch),
    (Key: 'Subject'              ; En: en_Subject;              Uk: uk_Subject),
    (Key: 'Successful'           ; En: en_Successful;           Uk: uk_Successful),
    (Key: 'SystemInfo'           ; En: en_SystemInfo;           Uk: uk_SystemInfo),
    (Key: 'TemplateName'         ; En: en_TemplateName;         Uk: uk_TemplateName),
    (Key: 'Text'                 ; En: en_Text;                 Uk: uk_Text),
    (Key: 'Time'                 ; En: en_Time;                 Uk: uk_Time),
    (Key: 'UseRawText'           ; En: en_UseRawText;           Uk: uk_UseRawText),
    (Key: 'Value'                ; En: en_Value;                Uk: uk_Value),
    (Key: 'WithSubdir'           ; En: en_WithSubdir;           Uk: uk_WithSubdir)
     );

 implementation

 end.
