unit TesseractOCR.Consts;


{ The MIT License (MIT)

  TTesseractOCR4
  Copyright (c) 2018 Damian Woroch, http://rime.ddns.net/

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE. }

interface

type
  TOCRLanguage = (lgUnknow, lgAfrikaans, lgAmharic, lgArabic, lgAssamese, lgAzerbaijani,
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

{$IFDEF FPC}
    PUTF8Char = PAnsiChar;
{$ENDIF}

  TOCRLanguageHelper = record helper for TOCRLanguage
    function FromString(const Value: string): TOCRLanguage;
    function ToString: string;
    function ToLanguageName: string;
  end;

const
{$IFDEF USE_CPPAN_BINARIES}
    libleptonica = {$IFDEF Linux}'libpvt.cppan.demo.danbloomberg.leptonica-1.76.0.so'{$ELSE}'pvt.cppan.demo.danbloomberg.leptonica-1.76.0.dll'{$ENDIF};
    libtesseract = {$IFDEF Linux}'libpvt.cppan.demo.google.tesseract.libtesseract-master.so'{$ELSE}'pvt.cppan.demo.google.tesseract.libtesseract-master.dll'{$ENDIF};
{$ELSE}
    libleptonica = {$IFDEF Linux}'liblept.so.5'{$ELSE}'liblept-5.dll'{$ENDIF};
    libtesseract = {$IFDEF Linux}'libtesseract.so.4'{$ELSE}'libtesseract-5.dll'{$ENDIF};
{$ENDIF}

implementation

{ TOCRLanguageHelper }

function TOCRLanguageHelper.ToString: string;
const
  OCRLanguageCodes: array [TOCRLanguage] of string = ('', 'afr', 'amh', 'ara', 'asm', 'aze', 'aze_cyrl', 'bel',
    'ben', 'bod', 'bos', 'bre', 'bul', 'cat', 'ceb', 'ces', 'chi_sim', 'chi_sim_vert', 'chi_tra', 'chi_tra_vert',
    'chr', 'cos', 'cym', 'dan', 'deu', 'div', 'dzo', 'ell', 'eng', 'enm', 'epo', 'equ', 'est', 'eus', 'fao', 'fas',
    'fil', 'fin', 'fra', 'frk', 'frm', 'fry', 'gla', 'gle', 'glg', 'grc', 'guj', 'hat', 'heb', 'hin', 'hrv', 'hun',
    'hye', 'iku', 'ind', 'isl', 'ita', 'ita_old', 'jav', 'jpn', 'jpn_vert', 'kan', 'kat', 'kat_old', 'kaz', 'khm',
    'kir', 'kmr', 'kor', 'kor_vert', 'lao', 'lat', 'lav', 'lit', 'ltz', 'mal', 'mar', 'mkd', 'mlt', 'mon', 'mri',
    'msa', 'mya', 'nep', 'nld', 'nor', 'oci', 'ori', 'osd', 'pan', 'pol', 'por', 'pus', 'que', 'ron', 'rus', 'san',
    'sin', 'slk', 'slv', 'snd', 'spa', 'spa_old', 'sqi', 'srp', 'srp_latn', 'sun', 'swa', 'swe', 'syr', 'tam', 'tat',
    'tel', 'tgk', 'tha', 'tir', 'ton', 'tur', 'uig', 'ukr', 'urd', 'uzb', 'uzb_cyrl', 'vie', 'yid', 'yor');
begin
  Result := OCRLanguageCodes[Self];
end;

function TOCRLanguageHelper.ToLanguageName: string;
const
  OCRLanguageNames: array [TOCRLanguage] of string = ('', 'Afrikaans', 'Amharic', 'Arabic', 'Assamese',
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
  Result := OCRLanguageNames[Self];
end;

function TOCRLanguageHelper.FromString(const Value: string): TOCRLanguage;
begin
  Result := lgUnknow;
  for var Item := Low(TOCRLanguage) to High(TOCRLanguage) do
    if Value = Item.ToString then
    begin
      Result := Item;
      Break;
    end;
end;

end.
