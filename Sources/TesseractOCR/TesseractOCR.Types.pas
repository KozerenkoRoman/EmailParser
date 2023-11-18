// ---------------------------------------------------------------------
//
// Optical Character Recognition Component
// based on Tesseract - an open source system
// https://github.com/tesseract-ocr/
//
// ---------------------------------------------------------------------

unit TesseractOCR.Types;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.Types, System.Classes, System.SysUtils, Vcl.Graphics, Vcl.Forms, System.Math;
{$ENDREGION}

type
  TOcrLanguage = (lgDefault, lgCustom, lgAfrikaans, lgAmharic, lgArabic, lgAssamese, lgAzerbaijani,
    lgAzerbaijaniCyrilic, lgBelarusian, lgBengali, lgTibetan, lgBosnian, lgBreton, lgBulgarian, lgCatalanValencian,
    lgCebuano, lgCzech, lgChineseSimplified, lgChineseSimplifiedVertical, lgChineseTraditional,
    lgChineseTraditionalVertical, lgCherokee, lgCorsican, lgWelsh, lgDanish, lgGerman, lgDhivehi, lgDzongkha,
    lgGreekModern, lgEnglish, lgEnglishMiddle, lgEsperanto, lgMath, lgEstonian, lgBasque, lgFaroese, lgPersian,
    lgFilipino, lgFinnish, lgFrench, lgFrankish, lgFrenchMiddle, lgWesternFrisian, lgScottishGaelic, lgIrish,
    lgGalician, lgGreekAncient, lgGujarati, lgHaitianCreole, lgHebrew, lgHindi, lgCroatian, lgHungarian, lgArmenian,
    lgInuktitut, lgIndonesian, lgIcelandic, lgItalian, lgItalianOld, lgJavanese, lgJapanese, lgJapaneseVertical,
    lgKannada, lgGeorgian, lgGeorgianOld, lgKazakh, lgCentralKhmer, lgKirghiz, lgKurmanji, lgKorean, lgKoreanVertical,
    lgLao, lgLatin, lgLatvian, lgLithuanian, lgLuxembourgish, lgMalayalam, lgMarathi, lgMacedonian, lgMaltese,
    lgMongolian, lgMaori, lgMalay, lgBurmese, lgNepali, lgDutchFlemish, lgNorwegian, lgOccitan, lgOriya, lgOSD,
    lgPanjabi, lgPolish, lgPortuguese, lgPushto, lgQuechua, lgRomanian, lgRussian, lgSanskrit, lgSinhala, lgSlovak,
    lgSlovenian, lgSindhi, lgSpanish, lgSpanishOld, lgAlbanian, lgSerbian, lgSerbianLatin, lgSundanese, lgSwahili,
    lgSwedish, lgSyriac, lgTamil, lgTatar, lgTelugu, lgTajik, lgThai, lgTigrinya, lgTonga, lgTurkish, lgUighur,
    lgUkrainian, lgUrdu, lgUzbek, lgUzbekCyrilic, lgVietnamese, lgYiddish, lgYoruba);

  TRectDynArray = array of TRect;
  TAnsiStringDynArray = array of AnsiString;

  EOcrError = class(Exception);

  TOcrEngineMode = (emTesseractOnly, emLSTMOnly, emCombined, emDefault);
  TOcrPageOrientation = (poUp, poRight, poDown, poLeft);
  TOcrPageSegmentation = (psOSDOnly, psAutoOSD, psAutoOnly, psAuto, psSingleColumn, psSingleVerticalBlock, psSingleBlock, psSingleLine, psSingleWord, psCircleWord, psSingleChar, psSparseText, psSparseTextOSD, psRawLine);
  TOcrParagraphJustification = (pjUnknown, pjLeft, pjCenter, pjRight);
  TOcrPixelFormat = (piAuto, pi8bit, pi24bit, pi32bit);
  TOcrTextLineOrder = (toLeftToRight, toRightToLeft, toTopToBottom);
  TOcrWritingDirection = (wdLeftToRight, wdRightToLeft, wdTopToBottom);

  TOcrProgressEvent = procedure (Sender: TObject; var Cancel: Boolean; Progress, WordCount: Integer) of object;

  TOcrWordFlag = (wfBold, wfItalic, wfUnderlined, wfMonospace, wfSerif, wfSmallCaps, wfDropCap, wfSubscript, wfSuperscript, wfNumeric, wfFromDictionary);
  TOcrWordFlags = set of TOcrWordFlag;

  TOCRLanguageHelper = record helper for TOCRLanguage
    function FromString(const Value: string): TOCRLanguage;
    function ToString: string;
    function ToLanguageName: string;
  end;

const
  LanguageCodes: array [TOcrLanguage] of string = ('', '', 'afr', 'amh', 'ara', 'asm', 'aze', 'aze_cyrl', 'bel', 'ben',
    'bod', 'bos', 'bre', 'bul', 'cat', 'ceb', 'ces', 'chi_sim', 'chi_sim_vert', 'chi_tra', 'chi_tra_vert', 'chr', 'cos',
    'cym', 'dan', 'deu', 'div', 'dzo', 'ell', 'eng', 'enm', 'epo', 'equ', 'est', 'eus', 'fao', 'fas', 'fil', 'fin',
    'fra', 'frk', 'frm', 'fry', 'gla', 'gle', 'glg', 'grc', 'guj', 'hat', 'heb', 'hin', 'hrv', 'hun', 'hye', 'iku',
    'ind', 'isl', 'ita', 'ita_old', 'jav', 'jpn', 'jpn_vert', 'kan', 'kat', 'kat_old', 'kaz', 'khm', 'kir', 'kmr',
    'kor', 'kor_vert', 'lao', 'lat', 'lav', 'lit', 'ltz', 'mal', 'mar', 'mkd', 'mlt', 'mon', 'mri', 'msa', 'mya', 'nep',
    'nld', 'nor', 'oci', 'ori', 'osd', 'pan', 'pol', 'por', 'pus', 'que', 'ron', 'rus', 'san', 'sin', 'slk', 'slv',
    'snd', 'spa', 'spa_old', 'sqi', 'srp', 'srp_latn', 'sun', 'swa', 'swe', 'syr', 'tam', 'tat', 'tel', 'tgk', 'tha',
    'tir', 'ton', 'tur', 'uig', 'ukr', 'urd', 'uzb', 'uzb_cyrl', 'vie', 'yid', 'yor');

resourcestring
  rsCannotAnalyseLayout              = 'Cannot analyse layout';
  rsCannotCreatePdfRenderer          = 'Cannot create PDF renderer';
  rsCannotInitializeLibrary          = 'Cannot initialize Tesseract library, check the language files';
  rsImageFileCannotBeUsed            = 'Image file cannot be used';
  rsIncorrectConnectedComponentIndex = 'Incorrect connected component index';
  rsIncorrectDllLibraryVersion       = 'Incorrect version of ocr.dll library';
  rsIncorrectParagraphIndex          = 'Incorrect paragraph index';
  rsIncorrectRegionDetailIndex       = 'Incorrect region detail index';
  rsIncorrectRegionIndex             = 'Incorrect region index';
  rsIncorrectStripIndex              = 'Incorrect strip index';
  rsIncorrectSymbolIndex             = 'Incorrect symbol index';
  rsIncorrectTextLineDetailIndex     = 'Incorrect text line detail index';
  rsIncorrectTextLineIndex           = 'Incorrect text line index';
  rsIncorrectWordDetailIndex         = 'Incorrect word detail index';
  rsIncorrectWordIndex               = 'Incorrect word index';
  rsPagenumberHasToBe1To             = 'PageNumber has to be 1 to ';
  rsPdfRenderingError                = 'Cannot render to PDF file';
  rsUnsupportedOSD                   = 'OSD page segmentation modes are not supported on LSTM engine';

implementation

{ TOCRLanguageHelper }

function TOCRLanguageHelper.FromString(const Value: string): TOCRLanguage;
begin
  Result := lgDefault;
  for var Item := Low(TOCRLanguage) to High(TOCRLanguage) do
    if Value = Item.ToString then
    begin
      Result := Item;
      Break;
    end;
end;

function TOCRLanguageHelper.ToLanguageName: string;
const
  LanguageNames: array [TOCRLanguage] of string = ('Default', 'Custom', 'Afrikaans', 'Amharic', 'Arabic', 'Assamese',
    'Azerbaijani Latin', 'Azerbaijani Cyrilic', 'Belarusian', 'Bengali', 'Tibetan', 'Bosnian', 'Breton', 'Bulgarian',
    'CatalanValencian', 'Cebuano', 'Czech', 'Chinese Simplified', 'Chinese Simplified Vertical', 'Chinese Traditional',
    'Chinese Traditional Vertical', 'Cherokee', 'Corsican', 'Welsh', 'Danish', 'German', 'Dhivehi', 'Dzongkha',
    'GreekModern', 'English', 'English Middle', 'Esperanto', 'Math', 'Estonian', 'Basque', 'Faroese', 'Persian',
    'Filipino', 'Finnish', 'French', 'Frankish', 'French Middle', 'Western Frisian', 'Scottish Gaelic', 'Irish',
    'Galician', 'Greek Ancient', 'Gujarati', 'Haitian Creole', 'Hebrew', 'Hindi', 'Croatian', 'Hungarian', 'Armenian',
    'Inuktitut', 'Indonesian', 'Icelandic', 'Italian', 'ItalianOld', 'Javanese', 'Japanese', 'Japanese Vertical',
    'Kannada', 'Georgian', 'Georgian Old', 'Kazakh', 'Central Khmer', 'Kirghiz', 'Kurmanji', 'Korean',
    'Korean Vertical', 'Lao', 'Latin', 'Latvian', 'Lithuanian', 'Luxembourgish', 'Malayalam', 'Marathi', 'Macedonian',
    'Maltese', 'Mongolian', 'Maori', 'Malay', 'Burmese', 'Nepali', 'Dutch Flemish', 'Norwegian', 'Occitan', 'Oriya',
    'OSD', 'Panjabi', 'Polish', 'Portuguese', 'Pushto', 'Quechua', 'Romanian', 'Russian', 'Sanskrit', 'Sinhala',
    'Slovak', 'Slovenian', 'Sindhi', 'Spanish', 'SpanishOld', 'Albanian', 'Serbian Cyrilic', 'Serbian Latin',
    'Sundanese', 'Swahili', 'Swedish', 'Syriac', 'Tamil', 'Tatar', 'Telugu', 'Tajik', 'Thai', 'Tigrinya', 'Tonga',
    'Turkish', 'Uighur', 'Ukrainian', 'Urdu', 'Uzbek Latin', 'Uzbek Cyrilic', 'Vietnamese', 'Yiddish', 'Yoruba');
begin
  Result := LanguageNames[Self];
end;

function TOCRLanguageHelper.ToString: string;
begin
  Result := LanguageCodes[Self];
end;

end.
