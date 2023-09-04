unit RegExp.Types;

interface

{$REGION 'Region uses'}

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Defaults, System.Generics.Collections,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Winapi.Windows;
{$ENDREGION}

type
  TPatternItem = record
    Name    : string;
    Pattern : string;
  end;

const
  ArrayPatterns: array [0 .. 12] of TPatternItem = (
    (Name: 'Date in dd-mm-yyyy format' ; Pattern: '(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d'),
    (Name: 'Date in mm-dd-yyyy format' ; Pattern: '(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d'),
    (Name: 'Simple world'     ; Pattern: '\b(?:\w|-)+\b'),
    (Name: 'Email addresses'  ; Pattern: '((?>[a-zA-Z\d!#$%&''*+\-/=?^_`{|}~]+\x20*' +
                                         '|"((?=[\x01-\x7f])[^"\\]|\\[\x01-\x7f])*"\' +
                                         'x20*)*(?<angle><))?((?!\.)(?>\.?[a-zA-Z\d!' +
                                         '#$%&''*+\-/=?^_`{|}~]+)+|"((?=[\x01-\x7f])' +
                                         '[^"\\]|\\[\x01-\x7f])*")@(((?!-)[a-zA-Z\d\' +
                                         '-]+(?<!-)\.)+[a-zA-Z]{2,}|\[(((?(?<!\[)\.)' +
                                         '(25[0-5]|2[0-4]\d|[01]?\d?\d)){4}|[a-zA-Z\' +
                                         'd\-]*[a-zA-Z\d]:((?=[\x01-\x7f])[^\\\[\]]|' +
                                         '\\[\x01-\x7f])+)\])(?(angle)>)'),
    (Name: 'Phone numbers'    ; Pattern: '\+?\(?([0-9]{3})\)?[-.]?\(?([0-9]{3})\)?[-.]?\(?([0-9]{4})\)?'),
    (Name: 'HTML tags'        ; Pattern: '<(?:"[^"]*"[''"]*|''[^'']*''[''"]*|[^''">])+>'),
    (Name: 'IP addresses'     ; Pattern: '(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' +
                                         '\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'),
    (Name: 'MAC address'      ; Pattern: '(?:[0-9A-Fa-f]{2}[:-]){5}(?:[0-9A-Fa-f]{2})'),
    (Name: 'Street address'   ; Pattern: '(\d{1,}) [a-zA-Z0-9\s]+(\,)? [a-zA-Z]+(\,)? [A-Z]{2} [0-9]{5,6}'),
    (Name: 'URL with http'    ; Pattern: 'https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)'),
    (Name: 'URL without http' ; Pattern: '[-a-zA-Z0-9:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9():%_\+.~#?&//=]*)'),
    (Name: 'ZIP code'         ; Pattern: '[0-9]{5}(?:-[0-9]{4})?'),
    (Name: 'GUID'             ; Pattern: '(?:\{{0,1}(?:[0-9a-fA-F]){8}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){4}-(?:[0-9a-fA-F]){12}\}{0,1})')
   );

implementation

end.
