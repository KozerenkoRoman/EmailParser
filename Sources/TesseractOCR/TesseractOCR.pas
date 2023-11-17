// ---------------------------------------------------------------------
//
// Optical Character Recognition Component
// based on Tesseract - an open source system
// https://github.com/tesseract-ocr/
//
// ---------------------------------------------------------------------

unit TesseractOCR;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.Types, System.Classes, System.SysUtils, Vcl.Graphics, Vcl.Forms, System.Math,
  TesseractOCR.Types;
{$ENDREGION}

type
  TOCRWord = record
    Location   : TRect;
    Text       : string;
    Confidence : Single;
    Flags      : TOCRWordFlags;
    FontName   : string;
    PointSize  : Integer;
  end;
  TOCRWordDynArray = array of TOCRWord;

  TOCRTextLine = record
    Location         : TRect;
    Text             : string;
    Confidence       : Single;
    DeskewAngle      : Single;
    Orientation      : TOCRPageOrientation;
    WritingDirection : TOCRWritingDirection;
    TextLineOrder    : TOCRTextLineOrder;
  end;
  TOCRTextLineDynArray = array of TOCRTextLine;

  TOCRParagraph = record
    Location         : TRect;
    Text             : string;
    Confidence       : Single;
    FirstLineIndent  : Integer;
    DeskewAngle      : Single;
    Justification    : TOCRParagraphJustification;
    Orientation      : TOCRPageOrientation;
    WritingDirection : TOCRWritingDirection;
    TextLineOrder    : TOCRTextLineOrder;
    IsListItem       : Boolean;
    IsCrown          : Boolean;
    IsLeftToRight    : Boolean;
  end;
  TOCRParagraphDynArray = array of TOCRParagraph;

  TOCRSymbol = record
    Location   : TRect;
    Text       : string;
    Confidence : Single;
  end;
  TOCRSymbolDynArray = array of TOCRSymbol;

  TOCRRegion = record
    Location         : TRect;
    Text             : string;
    Confidence       : Single;
    DeskewAngle      : Single;
    Orientation      : TOCRPageOrientation;
    WritingDirection : TOCRWritingDirection;
    TextLineOrder    : TOCRTextLineOrder;
  end;
  TOCRRegionDynArray = array of TOCRRegion;

  TOCRChoice = record
    Text       : string;
    Confidence : Single;
  end;
  TOCRChoiceDynArray = array of TOCRChoice;

  TOCRSymbolChoice = record
    Location   : TRect;
    Text       : string;
    Confidence : Single;
    Choices    : TOCRChoiceDynArray;
  end;
  TOCRSymbolChoiceDynArray = array of TOCRSymbolChoice;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TTesseractOCR = class(TComponent)
  private
    FActive              : Boolean;
    FHandle              : Pointer;
    FDataPath            : string;
    FEngineMode          : TOCREngineMode;
    FLanguage            : TOCRLanguage;
    FLanguageCode        : string;
    FPageNumber          : Integer;
    FPageSegmentation    : TOCRPageSegmentation;
    FPdfFileName         : string;
    FPdfTitle            : string;
    FPicture             : TPicture;
    FPictureFileName     : string;
    FPictureData         : TByteDynArray;
    FPictureHeight       : Integer;
    FPictureLeft         : Integer;
    FPictureTop          : Integer;
    FPictureWidth        : Integer;
    FPixelFormat         : TOCRPixelFormat;
    FRecognized          : Boolean;
    FConnectedComponents : TRectDynArray;
    FRegions             : TRectDynArray;
    FRegionDetails       : TOCRRegionDynArray;
    FStrips              : TRectDynArray;
    FTextLines           : TRectDynArray;
    FTextLineDetails     : TOCRTextLineDynArray;
    FWords               : TRectDynArray;
    FWordDetails         : TOCRWordDynArray;
    FParagraphs          : TOCRParagraphDynArray;
    FSymbols             : TOCRSymbolDynArray;
    FSymbolChoices       : TOCRSymbolChoiceDynArray;
    FOnProgress          : TOCRProgressEvent;
    FLayoutAnalysed      : Boolean;
    FPageOrientation     : TOCRPageOrientation;
    FTextLineOrder       : TOCRTextLineOrder;
    FWritingDirection    : TOCRWritingDirection;
    FDeskewAngle         : Single;
    FResolution          : Integer;
    FParameterNames      : TAnsiStringDynArray;
    FParameterValues     : TAnsiStringDynArray;
    function GetActive: Boolean;
    function GetAltoText: string;
    function GetAvailableLanguages: TStringDynArray;
    function GetBooleanParameter(const Name: string): Boolean;
    function GetBoxText: string;
    function GetConfidence: Integer;
    function GetConnectedComponentCount: Integer;
    function GetConnectedComponents(Index: Integer): TRect;
    function GetDeskewAngle: Single;
    function GetDoubleParameter(const Name: string): Double;
    function GetHtmlText: string;
    function GetImagelibVersions: string;
    function GetInitLanguages: string;
    function GetIntegerParameter(const Name: string): Integer;
    function GetLanguageCode: string;
    function GetLeptonicaVersion: string;
    function GetLoadedLanguages: TStringDynArray;
    function GetPageCount: Integer;
    function GetPageOrientation: TOCRPageOrientation;
    function GetParagraphCount: Integer;
    function GetParagraphs(Index: Integer): TOCRParagraph;
    function GetRegionCount: Integer;
    function GetRegionDetailCount: Integer;
    function GetRegionDetails(Index: Integer): TOCRRegion;
    function GetRegions(Index: Integer): TRect;
    function GetStringParameter(const Name: string): string;
    function GetStripCount: Integer;
    function GetStrips(Index: Integer): TRect;
    function GetSymbolChoiceCount: Integer;
    function GetSymbolChoices(Index: Integer): TOCRSymbolChoice;
    function GetSymbolCount: Integer;
    function GetSymbols(Index: Integer): TOCRSymbol;
    function GetText: string;
    function GetTextLineCount: Integer;
    function GetTextLineDetailCount: Integer;
    function GetTextLineDetails(Index: Integer): TOCRTextLine;
    function GetTextLineOrder: TOCRTextLineOrder;
    function GetTextLines(Index: Integer): TRect;
    function GetTsvText: string;
    function GetUnichar(Id: Integer): string;
    function GetUnlv: AnsiString;
    function GetUnlvText: string;
    function GetUtf8Text: AnsiString;
    function GetVersion: string;
    function GetWordCount: Integer;
    function GetWordDetailCount: Integer;
    function GetWordDetails(Index: Integer): TOCRWord;
    function GetWords(Index: Integer): TRect;
    function GetWritingDirection: TOCRWritingDirection;
    procedure CheckPageNumber;
    procedure SetActive(Value: Boolean);
    procedure SetBooleanParameter(const Name: string; Value: Boolean);
    procedure SetDataPath(const Value: string);
    procedure SetDoubleParameter(const Name: string; Value: Double);
    procedure SetEngineMode(Value: TOCREngineMode);
    procedure SetIntegerParameter(const Name: string; Value: Integer);
    procedure SetLanguageCode(const Value: string);
    procedure SetLangugage(Value: TOCRLanguage);
    procedure SetPageNumber(Value: Integer);
    procedure SetPicture(Value: TPicture);
    procedure SetPictureFileName(const Value: string);
    procedure SetPictureHeight(const Value: Integer);
    procedure SetPictureLeft(Value: Integer);
    procedure SetPictureTop(Value: Integer);
    procedure SetPictureWidth(Value: Integer);
    procedure SetRecognized(Value: Boolean);
    procedure SetResolution(Value: Integer);
    procedure SetStringParameter(const Name, Value: string);
  protected
    function PictureData(var BytesPerPixel, Width, Height: Integer): TByteDynArray;
    procedure AnalyseLayout;
    procedure CheckActive;
    procedure CheckInactive;
    procedure DoRecognize(PrepareOnly: Boolean);
    procedure Loaded; override;
    procedure PictureChanged(Sender: TObject);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function AdaptToWord(PageSegmentation: TOCRPageSegmentation; const Word: string): Boolean;
    function GetTextDirection(var Offset: Integer; var Slope: Single): Boolean;
    function IsValidCharacter(Character: AnsiChar): Boolean; overload;
    function IsValidCharacter(const Character: AnsiString): Boolean; overload;
    function IsValidWord(const Word: string): Boolean;
    function PrintVariables(const FileName: string): Boolean;
    procedure AddInitParameter(const Name, Value: AnsiString);
    procedure ClearAdaptiveClassifier;
    procedure ClearInitParameters;
    procedure ClearPersistentCache;
    procedure ReadConfigFile(const FileName: string);
    procedure Recognize;

    property AltoText                : string               read GetAltoText;
    property AvailableLanguages      : TStringDynArray      read GetAvailableLanguages;
    property BoxText                 : string               read GetBoxText;
    property Confidence              : Integer              read GetConfidence;
    property ConnectedComponentCount : Integer              read GetConnectedComponentCount;
    property DeskewAngle             : Single               read GetDeskewAngle;
    property Handle                  : Pointer              read FHandle;
    property HtmlText                : string               read GetHtmlText;
    property ImagelibVersions        : string               read GetImagelibVersions;
    property InitLanguages           : string               read GetInitLanguages;
    property LeptonicaVersion        : string               read GetLeptonicaVersion;
    property LoadedLanguages         : TStringDynArray      read GetLoadedLanguages;
    property PageCount               : Integer              read GetPageCount;
    property PageOrientation         : TOCRPageOrientation  read GetPageOrientation;
    property ParagraphCount          : Integer              read GetParagraphCount;
    property Recognized              : Boolean              read FRecognized write SetRecognized;
    property RegionCount             : Integer              read GetRegionCount;
    property RegionDetailCount       : Integer              read GetRegionDetailCount;
    property StripCount              : Integer              read GetStripCount;
    property SymbolChoiceCount       : Integer              read GetSymbolChoiceCount;
    property SymbolCount             : Integer              read GetSymbolCount;
    property Text                    : string               read GetText;
    property TextLineCount           : Integer              read GetTextLineCount;
    property TextLineDetailCount     : Integer              read GetTextLineDetailCount;
    property TextLineOrder           : TOCRTextLineOrder    read GetTextLineOrder;
    property TsvText                 : string               read GetTsvText;
    property Unlv                    : AnsiString           read GetUnlv;
    property UnlvText                : string               read GetUnlvText;
    property Utf8Text                : AnsiString           read GetUtf8Text;
    property Version                 : string               read GetVersion;
    property WordCount               : Integer              read GetWordCount;
    property WordDetailCount         : Integer              read GetWordDetailCount;
    property WritingDirection        : TOCRWritingDirection read GetWritingDirection;

    property BooleanParameter[const Name: string]: Boolean   read GetBooleanParameter write SetBooleanParameter;
    property ConnectedComponents[Index: Integer]: TRect      read GetConnectedComponents;
    property DoubleParameter[const Name: string]: Double     read GetDoubleParameter  write SetDoubleParameter;
    property IntegerParameter[const Name: string]: Integer   read GetIntegerParameter write SetIntegerParameter;
    property Paragraphs[Index: Integer]: TOCRParagraph       read GetParagraphs;
    property Parameter[const Name: string]: string           read GetStringParameter  write SetStringParameter;
    property RegionDetails[Index: Integer]: TOCRRegion       read GetRegionDetails;
    property Regions[Index: Integer]: TRect                  read GetRegions;
    property StringParameter[const Name: string]: string     read GetStringParameter  write SetStringParameter;
    property Strips[Index: Integer]: TRect                   read GetStrips;
    property SymbolChoices[Index: Integer]: TOCRSymbolChoice read GetSymbolChoices;
    property Symbols[Index: Integer]: TOCRSymbol             read GetSymbols;
    property TextLineDetails[Index: Integer]: TOCRTextLine   read GetTextLineDetails;
    property TextLines[Index: Integer]: TRect                read GetTextLines;
    property Unichar[Id: Integer]: string                    read GetUnichar;
    property WordDetails[Index: Integer]: TOCRWord           read GetWordDetails;
    property Words[Index: Integer]: TRect                    read GetWords;
  published
    property Active           : Boolean              read GetActive         write SetActive         default False;
    property DataPath         : string               read FDataPath         write SetDataPath;
    property EngineMode       : TOCREngineMode       read FEngineMode       write SetEngineMode     default emDefault;
    property Language         : TOCRLanguage         read FLanguage         write SetLangugage      default lgDefault;
    property LanguageCode     : string               read GetLanguageCode   write SetLanguageCode;
    property PageNumber       : Integer              read FPageNumber       write SetPageNumber     default 1;
    property PageSegmentation : TOCRPageSegmentation read FPageSegmentation write FPageSegmentation default psAuto;
    property PdfFileName      : string               read FPdfFileName      write FPdfFileName;
    property PdfTitle         : string               read FPdfTitle         write FPdfTitle;
    property Picture          : TPicture             read FPicture          write SetPicture;
    property PictureFileName  : string               read FPictureFileName  write SetPictureFileName;
    property PictureHeight    : Integer              read FPictureHeight    write SetPictureHeight  default 0;
    property PictureLeft      : Integer              read FPictureLeft      write SetPictureLeft    default 0;
    property PictureTop       : Integer              read FPictureTop       write SetPictureTop     default 0;
    property PictureWidth     : Integer              read FPictureWidth     write SetPictureWidth   default 0;
    property PixelFormat      : TOCRPixelFormat      read FPixelFormat      write FPixelFormat      default piAuto;
    property Resolution       : Integer              read FResolution       write SetResolution     default 0;
    property OnProgress       : TOCRProgressEvent    read FOnProgress       write FOnProgress;
  end;

var
  LibraryName: string = {$IFDEF CPUX64}'ocr64.dll' {$ELSE} 'ocr.dll'{$ENDIF CPUX64};

function Loaded: Boolean;
procedure LoadLibrary;
procedure UnloadLibrary;

implementation

type
  TOCRProgress = function(Data: Pointer; Progress, WordCount: Integer): Boolean; cdecl;

  TOCRBox = record
    Left   : Integer;
    Top    : Integer;
    Width  : Integer;
    Height : Integer;
  end;
  TOCRBoxArray = array [0..MaxInt div SizeOf(TOCRBox) - 1] of TOCRBox;
  POCRBoxArray = ^TOCRBoxArray;

  TAnsiStringArray = array [0..MaxInt div SizeOf(PAnsiChar) - 1] of PAnsiChar;
  PAnsiStringArray = ^TAnsiStringArray;

  TWordItem = record
    Left             : Integer;
    Top              : Integer;
    Right            : Integer;
    Bottom           : Integer;
    PointSize        : Integer;
    Confidence       : Single;
    Text, FontName   : PAnsiChar;
    IsBold           : Byte;
    IsItalic         : Byte;
    IsUnderlined     : Byte;
    IsMonospace      : Byte;
    IsSerif          : Byte;
    IsSmallCaps      : Byte;
    IsDropCap        : Byte;
    IsSubscript      : Byte;
    IsSuperscript    : Byte;
    IsNumeric        : Byte;
    IsFromDictionary : Byte;
    Padding1         : Byte;
    Padding2         : Byte;
    Padding3         : Byte;
    Padding4         : Byte;
    Padding5         : Byte;
  end;

  TWordItemArray = array [0..MaxInt div SizeOf(TWordItem) - 1] of TWordItem;
  PWordItemArray = ^TWordItemArray;

  TParagraphItem = record
    Left             : Integer;
    Top              : Integer;
    Right            : Integer;
    Bottom           : Integer;
    Text             : PAnsiChar;
    Confidence       : Single;
    FirstLineIndent  : Integer;
    DeskewAngle      : Single;
    Justification    : Integer;
    Orientation      : Integer;
    WritingDirection : Integer;
    TextLineOrder    : Integer;
    IsListItem       : Byte;
    IsCrown          : Byte;
    IsLeftToRight    : Byte;
    Padding1         : Byte;
  end;
  TParagraphItemArray = array [0..MaxInt div SizeOf(TParagraphItem) - 1] of TParagraphItem;
  PParagraphItemArray = ^TParagraphItemArray;

  TTextLineItem = record
    Left             : Integer;
    Top              : Integer;
    Right            : Integer;
    Bottom           : Integer;
    Text             : PAnsiChar;
    Confidence       : Single;
    DeskewAngle      : Single;
    Orientation      : Integer;
    WritingDirection : Integer;
    TextLineOrder    : Integer;
  end;
  TTextLineItemArray = array [0..MaxInt div SizeOf(TTextLineItem) - 1] of TTextLineItem;
  PTextLineItemArray = ^TTextLineItemArray;

  TSymbolItem = record
    Left: Integer;
    Top: Integer;
    Right: Integer;
    Bottom: Integer;
    Text: PAnsiChar;
    Confidence: Single;
  end;
  TSymbolItemArray = array [0..MaxInt div SizeOf(TSymbolItem) - 1] of TSymbolItem;
  PSymbolItemArray = ^TSymbolItemArray;

  TBlockItem = record
    Left             : Integer;
    Top              : Integer;
    Right            : Integer;
    Bottom           : Integer;
    Text             : PAnsiChar;
    Confidence       : Single;
    DeskewAngle      : Single;
    Orientation      : Integer;
    WritingDirection : Integer;
    TextLineOrder    : Integer;
  end;
  TBlockItemArray = array [0..MaxInt div SizeOf(TBlockItem) - 1] of TBlockItem;
  PBlockItemArray = ^TBlockItemArray;

  TArithmeticMask = record
    Fpu: Word;
    Sse: Word;
  end;

  TChoiceItem = record
    Text: PAnsiChar;
    Confidence: Single;
  end;
  TChoiceItemArray = array [0..MaxInt div SizeOf(TChoiceItem) - 1] of TChoiceItem;
  PChoiceItemArray = ^TChoiceItemArray;

  TSymbolChoiceItem = record
    Left        : Integer;
    Top         : Integer;
    Right       : Integer;
    Bottom      : Integer;
    Text        : PAnsiChar;
    Confidence  : Single;
    ChoiceCount : Integer;
    Choices     : PChoiceItemArray;
  end;
  TSymbolChoiceItemArray = array [0..MaxInt div SizeOf(TSymbolChoiceItem) - 1] of TSymbolChoiceItem;
  PSymbolChoiceItemArray = ^TSymbolChoiceItemArray;

var
  hLibrary: HMODULE;
  TesseractNew: function(var Version: Integer): Pointer; cdecl;
  TesseractAdaptToWordStr: function(Api: Pointer; Mode: Integer; WordStr: PAnsiChar): Boolean; cdecl;
  TesseractAddImage: function(PdfRenderer, Api: Pointer): Boolean; cdecl;
  TesseractAnalyseLayout: function(Api: Pointer; var Orientation, Direction, Order: Integer; var DeskewAngle: Single): Boolean; cdecl;
  TesseractBeginDocument: function(PdfRenderer: Pointer; const Title: PAnsiChar): Boolean; cdecl;
  TesseractClear: procedure(Api: Pointer); cdecl;
  TesseractClearAdaptiveClassifier: procedure(Api: Pointer); cdecl;
  TesseractClearPersistentCache: procedure; cdecl;
  TesseractCreatePdfRenderer: function(Api: Pointer; OutputBase: PAnsiChar; TextOnly: Boolean): Pointer; cdecl;
  TesseractDelete: procedure(Api: Pointer); cdecl;
  TesseractDeleteBlockItems: procedure(Items: PBlockItemArray; Size: Integer); cdecl;
  TesseractDeleteBoxes: procedure(Boxes: POCRBoxArray); cdecl;
  TesseractDeleteParagraphItems: procedure(Items: PParagraphItemArray; Size: Integer); cdecl;
  TesseractDeletePdfRenderer: procedure(PdfRenderer: Pointer); cdecl;
  TesseractDeleteString: procedure(AString: PAnsiChar); cdecl;
  TesseractDeleteStringArray: procedure(StringArray: PAnsiStringArray; Size: Integer); cdecl;
  TesseractDeleteSymbolChoiceItems: procedure(Items: PSymbolChoiceItemArray; Size: Integer); cdecl;
  TesseractDeleteSymbolItems: procedure(Items: PSymbolItemArray; Size: Integer); cdecl;
  TesseractDeleteTextLineItems: procedure(Items: PTextLineItemArray; Size: Integer); cdecl;
  TesseractDeleteWordItems: procedure(Items: PWordItemArray; Size: Integer); cdecl;
  TesseractEnd: procedure(Api: Pointer); cdecl;
  TesseractEndDocument: function(PdfRenderer: Pointer): Boolean; cdecl;
  TesseractGetAltoText: function(Api: Pointer; PageNumber: Integer): PAnsiChar; cdecl;
  TesseractGetAvailableLanguages: function(Api: Pointer; var Languages: PAnsiStringArray): Integer; cdecl;
  TesseractGetBlockItems: function(Api: Pointer; var Items: PBlockItemArray): Integer; cdecl;
  TesseractGetBoolVariable: function(Api: Pointer; Name: PAnsiChar; var Value: Boolean): Boolean; cdecl;
  TesseractGetBoxText: function(Api: Pointer; PageNumber: Integer): PAnsiChar; cdecl;
  TesseractGetConnectedComponents: function(Api: Pointer; var ConnectedComponents: POCRBoxArray): Integer; cdecl;
  TesseractGetDoubleVariable: function(Api: Pointer; Name: PAnsiChar; var Value: Double): Boolean; cdecl;
  TesseractGetHOCRText: function(Api: Pointer; PageNumber: Integer): PAnsiChar; cdecl;
  TesseractGetImagelibVersions: function: PAnsiChar; cdecl;
  TesseractGetInitLanguages: function(Api: Pointer): PAnsiChar; cdecl;
  TesseractGetIntVariable: function(Api: Pointer; Name: PAnsiChar; var Value: Integer): Boolean; cdecl;
  TesseractGetLeptonicaVersion: function: PAnsiChar; cdecl;
  TesseractGetLoadedLanguages: function(Api: Pointer; var Languages: PAnsiStringArray): Integer; cdecl;
  TesseractGetPageSegMode: function(Api: Pointer): Integer; cdecl;
  TesseractGetParagraphItems: function(Api: Pointer; var Items: PParagraphItemArray): Integer; cdecl;
  TesseractGetRegions: function(Api: Pointer; var Regions: POCRBoxArray): Integer; cdecl;
  TesseractGetStringVariable: function(Api: Pointer; Name: PAnsiChar): PAnsiChar; cdecl;
  TesseractGetStrips: function(Api: Pointer; var Strips: POCRBoxArray): Integer; cdecl;
  TesseractGetSymbolChoiceItems: function(Api: Pointer; var Items: PSymbolChoiceItemArray): Integer; cdecl;
  TesseractGetSymbolItems: function(Api: Pointer; var Items: PSymbolItemArray): Integer; cdecl;
  TesseractGetTextDirection: function(Api: Pointer; var Offset: Integer; var Slope: Single): Boolean; cdecl;
  TesseractGetTextLineItems: function(Api: Pointer; var Items: PTextLineItemArray): Integer; cdecl;
  TesseractGetTextLines: function(Api: Pointer; var TextLines: POCRBoxArray): Integer; cdecl;
  TesseractGetTSVText: function(Api: Pointer; PageNumber: Integer): PAnsiChar; cdecl;
  TesseractGetUnichar: function(Api: Pointer; UnicharId: Integer): PAnsiChar; cdecl;
  TesseractGetUNLVText: function(Api: Pointer): PAnsiChar; cdecl;
  TesseractGetUTF8Text: function(Api: Pointer): PAnsiChar; cdecl;
  TesseractGetVersion: function: PAnsiChar; cdecl;
  TesseractGetWordItems: function(Api: Pointer; var Items: PWordItemArray): Integer; cdecl;
  TesseractGetWords: function(Api: Pointer; var Words: POCRBoxArray): Integer; cdecl;
  TesseractInit: function(Api: Pointer; Datapath: PAnsiChar; Language: PAnsiChar; EngineMode, VariableCount: Integer; VariableNames, VariableValues: Pointer): Integer; cdecl;
  TesseractIsValidCharacter: function(Api: Pointer; Utf8Character: PAnsiChar): Boolean; cdecl;
  TesseractIsValidWord: function(Api: Pointer; Word: PAnsiChar): Integer; cdecl;
  TesseractMeanTextConf: function(Api: Pointer): Integer; cdecl;
  TesseractPageCount: function(Filename: PAnsiChar): Integer; cdecl;
  TesseractPrintVariables: function(Api: Pointer; FileName: PAnsiChar): Boolean; cdecl;
  TesseractReadConfigFile: procedure(Api: Pointer; Filename: PAnsiChar); cdecl;
  TesseractRecognize: function(Api: Pointer; Progress: TOCRProgress; Data: Pointer): Boolean; cdecl;
  TesseractRect: function(Api: Pointer; ImageData: PByte; BytesPerPixel, BytesPerLine, Left, Top, Width, Height: Integer): PAnsiChar; cdecl;
  TesseractSetImage: procedure(Api: Pointer; ImageData: PByte; Width, Height, BytesPerPixel, BytesPerLine: Integer); cdecl;
  TesseractSetImageFile: function(Api: Pointer; FileName: PAnsiChar; Page: Integer): Boolean; cdecl;
  TesseractSetInputName: procedure(Api: Pointer; Name: PAnsiChar); cdecl;
  TesseractSetMinOrientationMargin: procedure(Api: Pointer; Margin: Double); cdecl;
  TesseractSetOutputName: procedure(Api: Pointer; Name: PAnsiChar); cdecl;
  TesseractSetPageSegMode: procedure(Api: Pointer; Mode: Integer); cdecl;
  TesseractSetRectangle: procedure(Api: Pointer; Left, Top, Width, Height: Integer); cdecl;
  TesseractSetSourceResolution: procedure(Api: Pointer; Ppi: Integer); cdecl;
  TesseractSetVariable: function(Api: Pointer; Name: PAnsiChar; Value: PAnsiChar): Boolean; cdecl;

function SetArithmeticMask: TArithmeticMask;
var
  ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Result.Fpu := ControlWord and $3F;
  Set8087CW(ControlWord or $3F);

{$IFDEF FPC}
  ControlWord := GetSSECSR;
  Result.Sse := ControlWord and $1F80;
  SetSSECSR(ControlWord or $1F80);
{$ELSE}
{$IFDEF CPUX64}
  ControlWord := GetMXCSR;
  Result.Sse := ControlWord and $1F80;
  SetMXCSR(ControlWord or $1F80);
{$ENDIF CPUX64}
{$ENDIF FPC}
end;

procedure RestoreArithmeticMask(Mask: TArithmeticMask);
var
  ControlWord: Word;
begin
  ControlWord := Get8087CW;
  Set8087CW((ControlWord and (not $3F)) or Mask.Fpu);

{$IFDEF FPC}
  ControlWord := GetSSECSR;
  SetSSECSR((ControlWord and (not $1F80)) or Mask.Sse);
{$ELSE}
{$IFDEF CPUX64}
  ControlWord := GetMXCSR;
  SetMXCSR((ControlWord and (not $1F80)) or Mask.Sse);
{$ENDIF CPUX64}
{$ENDIF FPC}
end;

procedure Check(Value: Boolean; const Message: string);
begin
  if not Value then
    raise EOCRError.Create(Message);
end;

constructor TTesseractOCR.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEngineMode       := emDefault;
  FLanguage         := lgDefault;
  FPageNumber       := 1;
  FPageSegmentation := psAuto;
  FPicture          := TPicture.Create;
  FPicture.OnChange := PictureChanged;
  FPixelFormat      := piAuto;
  FDataPath         := ExtractFilePath(Application.ExeName) + 'tessdata';
end;

destructor TTesseractOCR.Destroy;
begin
  Active := False;
  FPicture.Free;
  inherited Destroy;
end;

procedure TTesseractOCR.CheckActive;
begin
  Check(Active, 'Cannot perform this operation on an inactive ' + Name + ' component');
end;

procedure TTesseractOCR.CheckInactive;
begin
  if not (csDesigning in ComponentState) then
    Check(not Active, 'Cannot perform this operation on an active ' + Name + ' component');
end;

function TTesseractOCR.GetActive: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := FHandle <> nil
  else
    Result := FActive;
end;

procedure TTesseractOCR.SetActive(Value: Boolean);
var
  TesseractDataPath: PAnsiChar;
  TesseractLanguageCode: PAnsiChar;
  Version: Integer;
begin
  if (Active <> Value) then
    if not (csDesigning in ComponentState) then
      if not (csLoading in ComponentState) then
        if Value then
        begin
          LoadLibrary;
          FHandle := TesseractNew(Version);
          Check(FHandle <> nil, rsCannotInitializeLibrary);
          Check(Version = $86, rsIncorrectDllLibraryVersion);

          if (DataPath = '') then
            TesseractDataPath := nil
          else
            TesseractDataPath := PAnsiChar(AnsiString(IncludeTrailingPathDelimiter(DataPath)));

          if (LanguageCode = '') then
            TesseractLanguageCode := nil
          else
            TesseractLanguageCode := PAnsiChar(AnsiString(LanguageCode));
          if TesseractInit(FHandle, TesseractDataPath, TesseractLanguageCode, Integer(EngineMode), Length(FParameterNames), FParameterNames, FParameterValues) <> 0 then
          begin
            Active := False;
            Check(False, rsCannotInitializeLibrary);
          end
        end
        else
        begin
          Recognized := False;
          TesseractEnd(FHandle);
          TesseractDelete(FHandle);
          FHandle := nil;
        end;
  FActive := Value;
end;

procedure TTesseractOCR.Loaded;
begin
  inherited;
  SetActive(FActive);
end;

procedure TTesseractOCR.CheckPageNumber;
var MaxPageNumber: Integer;
begin
  MaxPageNumber := PageCount;
  if MaxPageNumber = 0 then
    MaxPageNumber := 1;
  Check((PageNumber >= 1) and (PageNumber <= MaxPageNumber), rsPagenumberHasToBe1To + MaxPageNumber.ToString);
end;

function TTesseractOCR.GetVersion: string;
begin
  LoadLibrary;
  Result := UTF8ToString(TesseractGetVersion)
end;

function TTesseractOCR.GetLeptonicaVersion: string;
var
  Data: PAnsiChar;
begin
  LoadLibrary;
  Data := TesseractGetLeptonicaVersion;
  Result := UTF8ToString(Data);
  if Data <> nil then
    TesseractDeleteString(Data);
end;

function TTesseractOCR.GetImagelibVersions: string;
var
  Data: PAnsiChar;
begin
  LoadLibrary;
  Data := TesseractGetImagelibVersions;
  Result := UTF8ToString(Data);
  if Data <> nil then
    TesseractDeleteString(Data);
end;

procedure TTesseractOCR.SetDataPath(const Value: string);
begin
  if FDataPath <> Value then
  begin
    CheckInactive;
    FDataPath := Value;
  end
end;

procedure TTesseractOCR.SetLangugage(Value: TOCRLanguage);
begin
  if FLanguage <> Value then
  begin
    CheckInactive;
    FLanguage := Value;
  end
end;

function TTesseractOCR.GetLanguageCode: string;
begin
  if FLanguage = lgCustom then
    Result := FLanguageCode
  else
    Result := LanguageCodes[FLanguage]
end;

procedure TTesseractOCR.SetLanguageCode(const Value: string);
begin
  if (FLanguageCode <> Value) then
  begin
    CheckInactive;
    FLanguage := lgCustom;
    FLanguageCode := Value;

    for var Item := Low(TOCRLanguage) to High(TOCRLanguage) do
      if (Value = LanguageCodes[Item]) then
      begin
        FLanguage := Item;
        Break;
      end;
  end;
end;

procedure TTesseractOCR.SetEngineMode(Value: TOCREngineMode);
begin
  if (FEngineMode <> Value) then
  begin
    CheckInactive;
    FEngineMode := Value;
  end
end;

function TTesseractOCR.GetText: string;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil; // to avoid warning
  if Recognized then
    try
      Data := TesseractGetUTF8Text(FHandle);
      Result := UTF8ToString(Data);
    finally
      if Data <> nil then
        TesseractDeleteString(Data);
    end;
end;

function TTesseractOCR.GetUtf8Text: AnsiString;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil; // to avoid warning
  if Recognized then
    try
      Data := TesseractGetUTF8Text(FHandle);
      Result := AnsiString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end;
end;

function TTesseractOCR.GetUnlvText: string;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil; // to avoid warning
  if Recognized then
    try
      Data := TesseractGetUNLVText(FHandle);
      Result := UTF8ToString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end;
end;

function TTesseractOCR.GetAltoText: string;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil; // to avoid warning
  if Recognized then
    try
      Data := TesseractGetAltoText(FHandle, PageNumber - 1);
      Result := UTF8ToString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end;
end;

function TTesseractOCR.GetUnlv: AnsiString;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil; // to avoid warning
  if Recognized then
    try
      Data := TesseractGetUNLVText(FHandle);
      Result := AnsiString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end;
end;

function TTesseractOCR.GetBoxText: string;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil;
  if Recognized then
    try
      Data := TesseractGetBoxText(FHandle, PageNumber - 1);
      Result := UTF8ToString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end
end;

function TTesseractOCR.GetTsvText: string;
var
  Data: PAnsiChar;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil;
  if Recognized then
    try
      Data := TesseractGetTSVText(FHandle, PageNumber - 1);
      Result := UTF8ToString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);
    end
end;

function TTesseractOCR.GetHtmlText: string;
var
  Data: PAnsiChar;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  Data := nil;
  if Recognized then
    try
      ArithmeticMask := SetArithmeticMask;
      Data := TesseractGetHOCRText(FHandle, PageNumber - 1);
      Result := UTF8ToString(Data);
    finally
      if (Data <> nil) then
        TesseractDeleteString(Data);

      RestoreArithmeticMask(ArithmeticMask);
    end
end;

function GetBytesPerPixel(PixelFormat: TOCRPixelFormat): Integer;
begin
  case PixelFormat of
    pi8Bit:
      Result := 1;
    pi24Bit:
      Result := 3;
    pi32Bit:
      Result := 4;
  else
    Result := 0;
  end
end;

function TTesseractOCR.PictureData(var BytesPerPixel, Width, Height: Integer): TByteDynArray;
var
  Bitmap: TBitmap;
{$IFNDEF FPC}
  ScanLine: Pointer;
{$ENDIF FPC}
  BytesPerLine, Index, EndIndex: Integer;
  OldHeight, OldLeft, OldTop, OldWidth: Integer;
  Temp: Byte;
begin
  OldHeight := PictureHeight;
  OldLeft   := PictureLeft;
  OldTop    := PictureTop;
  OldWidth  := PictureWidth;

  Bitmap := TBitmap.Create;
  try
    Bitmap.Assign(FPicture.Graphic);
    BytesPerPixel := GetBytesPerPixel(FPixelFormat);
    case FPixelFormat of
      pi8Bit:
        Bitmap.PixelFormat := pf8bit;
      pi24Bit:
        Bitmap.PixelFormat := pf24bit;
      pi32Bit:
        Bitmap.PixelFormat := pf32Bit;
    else // piAuto
      case Bitmap.PixelFormat of
        pf8bit:
          BytesPerPixel := 1;
        pf24bit:
          BytesPerPixel := 3;
        pf32Bit:
          BytesPerPixel := 4;
      else
        begin
          Bitmap.PixelFormat := pf32Bit;
          BytesPerPixel := 4;
        end
      end
    end;

    Width := Bitmap.Width;
    Height := Bitmap.Height;
    BytesPerLine := BytesPerPixel * Width;
    SetLength(Result, BytesPerLine * Height);

{$IFDEF FPC}
    if Length(Result) > 0 then
    begin
      Move(Bitmap.RawImage.Data^, Result[0], Length(Result));

      // switch RGB to BRG
      case BytesPerPixel of
        3:
          begin
            Index := 0;
            EndIndex := Length(Result);
            while Index < EndIndex do
            begin
              Temp := Result[Index];
              Result[Index] := Result[Index + 2];
              Result[Index + 2] := Temp;
              Inc(Index, 3);
            end
          end;
        4:
          begin
            Index := 0;
            EndIndex := Length(Result);
            while Index < EndIndex do
            begin
              Temp := Result[Index];
              Result[Index] := Result[Index + 2];
              Result[Index + 2] := Temp;
              Inc(Index, 4);
            end
          end;
      end;
    end;
{$ELSE}
    for var i := 0 to Height - 1 do
    begin
      ScanLine := Bitmap.ScanLine[i];
      Move(ScanLine^, Result[I * BytesPerLine], BytesPerLine);

      // switch RGB to BRG
      case BytesPerPixel of
        3:
          begin
            Index := i * BytesPerLine;
            EndIndex := Index + BytesPerLine;
            while (Index < EndIndex) do
            begin
              Temp := Result[Index];
              Result[Index] := Result[Index + 2];
              Result[Index + 2] := Temp;
              Inc(Index, 3);
            end
          end;
        4:
          begin
            Index := I * BytesPerLine;
            EndIndex := Index + BytesPerLine;
            while (Index < EndIndex) do
            begin
              Temp := Result[Index];
              Result[Index] := Result[Index + 2];
              Result[Index + 2] := Temp;
              Inc(Index, 4);
            end
          end;
      end;
    end;
{$ENDIF FPC}
  finally
    Bitmap.Free;
    PictureHeight := OldHeight;
    PictureLeft   := OldLeft;
    PictureTop    := OldTop;
    PictureWidth  := OldWidth;
  end;
end;

function ProgressFunc(Data: Pointer; Progress, WordCount: Integer): Boolean; cdecl;
var
  Cancel: Boolean;
begin
  Cancel := False;
  TTesseractOCR(Data).FOnProgress(TTesseractOCR(Data), Cancel, Progress, WordCount);
  Result := Cancel;
end;

procedure TTesseractOCR.Recognize;
begin
  DoRecognize(False);
end;

procedure TTesseractOCR.DoRecognize(PrepareOnly: Boolean);
var
  BytesPerPixel, BitmapWidth, BitmapHeight: Integer;
  ArithmeticMask: TArithmeticMask;
  PdfRenderer: Pointer;
  PdfFile: AnsiString;
begin
  CheckActive;
  Recognized           := False;
  FLayoutAnalysed      := False;
  FConnectedComponents := nil;
  FRegions             := nil;
  FRegionDetails       := nil;
  FStrips              := nil;
  FTextLines           := nil;
  FWords               := nil;
  FWordDetails         := nil;
  FTextLineDetails     := nil;
  FParagraphs          := nil;
  FSymbols             := nil;
  FSymbolChoices       := nil;

  if (EngineMode <> emTesseractOnly) then
    Check(not(FPageSegmentation in [psOSDOnly, psAutoOSD, psSparseTextOSD]), rsUnsupportedOSD);

  if (PictureFileName <> '') then
  begin
    TesseractSetPageSegMode(FHandle, Integer(FPageSegmentation));
    CheckPageNumber;
    Check(TesseractSetImageFile(FHandle, PAnsiChar(AnsiString(PictureFileName)), PageNumber - 1), rsImageFileCannotBeUsed + ': ' + PictureFileName);
    if (PictureWidth <> 0) and (PictureHeight <> 0) then
      TesseractSetRectangle(FHandle, PictureLeft, PictureTop, PictureWidth, PictureHeight);
    if (Resolution <> 0) then
      TesseractSetSourceResolution(FHandle, Resolution);

    if not PrepareOnly then
    begin
      ArithmeticMask := SetArithmeticMask;
      try
        PdfRenderer := nil;
        PdfFile := AnsiString(ChangeFileExt(PdfFileName, ''));
        if (PdfFile <> '') then
        begin
          PdfRenderer := TesseractCreatePdfRenderer(FHandle, PAnsiChar(PdfFile), False);
          Check(PdfRenderer <> nil, rsCannotCreatePdfRenderer);
        end;

        try
          if (PdfRenderer <> nil) then
            Check(TesseractBeginDocument(PdfRenderer, PAnsiChar(AnsiString(PdfTitle))), rsPdfRenderingError);

          if Assigned(FOnProgress) then
            FRecognized := TesseractRecognize(FHandle, ProgressFunc, Self)
          else
            FRecognized := TesseractRecognize(FHandle, nil, Self);

          if (PdfRenderer <> nil) then
          begin
            Check(TesseractAddImage(PdfRenderer, FHandle), rsPdfRenderingError);
            Check(TesseractEndDocument(PdfRenderer), rsPdfRenderingError);
          end;
        finally
          if (PdfRenderer <> nil) then
            TesseractDeletePdfRenderer(PdfRenderer);
        end;
      finally
        RestoreArithmeticMask(ArithmeticMask);
      end
    end;
  end
  else
  begin
    FPictureData := PictureData(BytesPerPixel, BitmapWidth, BitmapHeight);
    if (FPictureData <> nil) then
    begin
      TesseractSetPageSegMode(FHandle, Integer(FPageSegmentation));
      TesseractSetImage(FHandle, @FPictureData[0], BitmapWidth, BitmapHeight, BytesPerPixel, BytesPerPixel * BitmapWidth);
      if (PictureWidth <> 0) and (PictureHeight <> 0) then
        TesseractSetRectangle(FHandle, PictureLeft, PictureTop, PictureWidth, PictureHeight);
      if (Resolution <> 0) then
        TesseractSetSourceResolution(FHandle, Resolution);

      if not PrepareOnly then
      begin
        ArithmeticMask := SetArithmeticMask;
        try
          PdfRenderer := nil;
          PdfFile := AnsiString(ChangeFileExt(PdfFileName, ''));
          if (PdfFile <> '') then
          begin
            PdfRenderer := TesseractCreatePdfRenderer(FHandle, PAnsiChar(PdfFile), False);
            Check(PdfRenderer <> nil, rsCannotCreatePdfRenderer);
          end;

          try
            if (PdfRenderer <> nil) then
              Check(TesseractBeginDocument(PdfRenderer, PAnsiChar(AnsiString(FPdfTitle))), rsPdfRenderingError);

            if Assigned(FOnProgress) then
              FRecognized := TesseractRecognize(FHandle, ProgressFunc, Self)
            else
              FRecognized := TesseractRecognize(FHandle, nil, Self);

            if (PdfRenderer <> nil) then
            begin
              Check(TesseractAddImage(PdfRenderer, FHandle), rsPdfRenderingError);
              Check(TesseractEndDocument(PdfRenderer), rsPdfRenderingError);
            end;
          finally
            if (PdfRenderer <> nil) then
              TesseractDeletePdfRenderer(PdfRenderer);
          end;
        finally
          RestoreArithmeticMask(ArithmeticMask);
        end
      end;
    end
  end
end;

procedure TTesseractOCR.SetRecognized(Value: Boolean);
begin
  FRecognized := Value;
  if not FRecognized then
    if Active then
      if not (csDesigning in ComponentState) then
      begin
        FPictureData := nil;
        TesseractClear(FHandle);
      end;
end;

procedure TTesseractOCR.SetPictureHeight(const Value: Integer);
begin
  if (FPictureHeight <> Value) then
  begin
    if (Value < 0) then
      FPictureHeight := 0
    else
      FPictureHeight := Value;
    Recognized := False;
  end
end;

procedure TTesseractOCR.SetPictureLeft(Value: Integer);
begin
  if FPictureLeft <> Value then
  begin
    if (Value < 0) then
      FPictureLeft := 0
    else
      FPictureLeft := Value;
    Recognized := False;
  end
end;

procedure TTesseractOCR.SetPictureTop(Value: Integer);
begin
  if (FPictureTop <> Value) then
  begin
    if (Value < 0) then
      FPictureTop := 0
    else
      FPictureTop := Value;
    Recognized := False;
  end
end;

procedure TTesseractOCR.SetPictureWidth(Value: Integer);
begin
  if (FPictureWidth <> Value) then
  begin
    if (Value < 0) then
      FPictureWidth := 0
    else
      FPictureWidth := Value;
    Recognized := False;
  end;
end;

procedure TTesseractOCR.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
end;

procedure TTesseractOCR.PictureChanged(Sender: TObject);
begin
  if not (csLoading in ComponentState) then
  begin
    FPictureFileName := '';
    PictureLeft      := 0;
    PictureTop       := 0;
    PictureWidth     := FPicture.Width;
    PictureHeight    := FPicture.Height;
  end;
  Recognized := False;
end;

procedure TTesseractOCR.SetPictureFileName(const Value: string);
begin
  if (Value <> FPictureFileName) then
  begin
    SetPicture(nil);
    FPictureFileName := Value;
    Recognized := False;
  end
end;

function TTesseractOCR.IsValidWord(const Word: string): Boolean;
begin
  CheckActive;
  Result := TesseractIsValidWord(FHandle, PAnsiChar(AnsiString(Word))) <> 0;
end;

function TTesseractOCR.PrintVariables(const FileName: string): Boolean;
begin
  CheckActive;
  Result := TesseractPrintVariables(FHandle, PAnsiChar(AnsiString(FileName)));
end;

procedure TTesseractOCR.ReadConfigFile(const FileName: string);
begin
  CheckActive;
  TesseractReadConfigFile(FHandle, PAnsiChar(AnsiString(FileName)));
end;

function TTesseractOCR.GetBooleanParameter(const Name: string): Boolean;
begin
  CheckActive;
  Check(TesseractGetBoolVariable(FHandle, PAnsiChar(AnsiString(Name)), Result), 'Cannot get parameter ''' + Name + '''');
end;

procedure TTesseractOCR.SetBooleanParameter(const Name: string; Value: Boolean);
var StringValue: AnsiString;
begin
  CheckActive;
  if Value then
    StringValue := 'T'
  else
    StringValue := 'F';
  Check(TesseractSetVariable(FHandle, PAnsiChar(AnsiString(Name)), PAnsiChar(AnsiString(StringValue))), 'Cannot set parameter ''' + Name + '''');
end;

function TTesseractOCR.GetIntegerParameter(const Name: string): Integer;
begin
  CheckActive;
  Check(TesseractGetIntVariable(FHandle, PAnsiChar(AnsiString(Name)), Result), 'Cannot get parameter ''' + Name + '''');
end;

procedure TTesseractOCR.SetIntegerParameter(const Name: string; Value: Integer);
begin
  CheckActive;
  Check(TesseractSetVariable(FHandle, PAnsiChar(AnsiString(Name)), PAnsiChar(AnsiString(IntToStr(Value)))), 'Cannot set parameter ''' + Name + '''');
end;

function TTesseractOCR.GetDoubleParameter(const Name: string): Double;
begin
  CheckActive;
  Check(TesseractGetDoubleVariable(FHandle, PAnsiChar(AnsiString(Name)), Result), 'Cannot get parameter ''' + Name + '''');
end;

procedure TTesseractOCR.SetDoubleParameter(const Name: string; Value: Double);
begin
  CheckActive;
  Check(TesseractSetVariable(FHandle, PAnsiChar(AnsiString(Name)), PAnsiChar(AnsiString(FloatToStr(Value)))), 'Cannot set parameter ''' + Name + '''');
end;

function TTesseractOCR.GetStringParameter(const Name: string): string;
begin
  CheckActive;
  Result := UTF8ToString(TesseractGetStringVariable(FHandle, PAnsiChar(AnsiString(Name))));
end;

procedure TTesseractOCR.SetStringParameter(const Name, Value: string);
begin
  CheckActive;
  Check(TesseractSetVariable(FHandle, PAnsiChar(AnsiString(Name)), PAnsiChar(AnsiString(Value))), 'Cannot set parameter ''' + Name + '''');
end;

function TTesseractOCR.GetConfidence: Integer;
begin
  CheckActive;
  Result := TesseractMeanTextConf(FHandle);
end;

function TTesseractOCR.GetUnichar(Id: Integer): string;
begin
  CheckActive;
  Result := UTF8ToString(TesseractGetUnichar(FHandle, Id));
end;

function TTesseractOCR.GetTextDirection(var Offset: Integer; var Slope: Single): Boolean;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized then
    Result := TesseractGetTextDirection(FHandle, Offset, Slope)
  else
    Result := False
end;

procedure TTesseractOCR.ClearAdaptiveClassifier;
begin
  CheckActive;
  TesseractClearAdaptiveClassifier(FHandle);
end;

procedure TTesseractOCR.ClearPersistentCache;
begin
  LoadLibrary;
  TesseractClearPersistentCache;
end;

function TTesseractOCR.IsValidCharacter(Character: AnsiChar): Boolean;
begin
  Result := IsValidCharacter(AnsiString(Character));
end;

function TTesseractOCR.IsValidCharacter(const Character: AnsiString): Boolean;
begin
  CheckActive;
  if (Character = '') then
    Result := False
  else
    Result := TesseractIsValidCharacter(FHandle, PAnsiChar(Character));
end;

function TTesseractOCR.AdaptToWord(PageSegmentation: TOCRPageSegmentation; const Word: string): Boolean;
begin
  CheckActive;
  Result := TesseractAdaptToWordStr(FHandle, Integer(PageSegmentation), PAnsiChar(AnsiString(Word)));
end;

function TTesseractOCR.GetConnectedComponentCount: Integer;
var
  ConnectedComponentCount: Integer;
  ConnectedComponents: POCRBoxArray;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FConnectedComponents = nil) then
    try
      ConnectedComponentCount := TesseractGetConnectedComponents(FHandle, ConnectedComponents);
      if (ConnectedComponentCount > 0) then
      begin
        SetLength(FConnectedComponents, ConnectedComponentCount);
        for var i := 0 to ConnectedComponentCount - 1 do
          with ConnectedComponents[i] do
            FConnectedComponents[i] := Rect(Left, Top, Left + Width, Top + Height);
      end
    finally
      if (ConnectedComponents <> nil) then
        TesseractDeleteBoxes(ConnectedComponents);
    end;
  Result := Length(FConnectedComponents);
end;

function TTesseractOCR.GetConnectedComponents(Index: Integer): TRect;
begin
  Check((Index >= 0) and (Index < ConnectedComponentCount), rsIncorrectConnectedComponentIndex);
  Result := FConnectedComponents[Index];
end;

function TTesseractOCR.GetRegionCount: Integer;
var
  RegionCount: Integer;
  Regions: POCRBoxArray;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FRegions = nil) then
    try
      RegionCount := TesseractGetRegions(FHandle, Regions);
      if (RegionCount > 0) then
      begin
        SetLength(FRegions, RegionCount);
        for var i := 0 to RegionCount - 1 do
          with Regions[i] do
            FRegions[i] := Rect(Left, Top, Left + Width, Top + Height);
      end
    finally
      if Regions <> nil then
        TesseractDeleteBoxes(Regions);
    end;
  Result := Length(FRegions);
end;

function TTesseractOCR.GetRegions(Index: Integer): TRect;
begin
  Check((Index >= 0) and (Index < RegionCount), rsIncorrectRegionIndex);
  Result := FRegions[Index];
end;

function TTesseractOCR.GetStripCount: Integer;
var
  StripCount: Integer;
  Strips: POCRBoxArray;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FStrips = nil) then
    try
      StripCount := TesseractGetStrips(FHandle, Strips);
      if (StripCount > 0) then
      begin
        SetLength(FStrips, StripCount);
        for var i := 0 to StripCount - 1 do
          with Strips[i] do
            FStrips[i] := Rect(Left, Top, Left + Width, Top + Height);
      end
    finally
      if Strips <> nil then
        TesseractDeleteBoxes(Strips);
    end;
  Result := Length(FStrips);
end;

function TTesseractOCR.GetStrips(Index: Integer): TRect;
begin
  Check((Index >= 0) and (Index < StripCount), rsIncorrectStripIndex);
  Result := FStrips[Index];
end;

function TTesseractOCR.GetTextLineCount: Integer;
var
  TextLineCount, i: Integer;
  TextLines: POCRBoxArray;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FTextLines = nil) then
    try
      TextLineCount := TesseractGetTextLines(FHandle, TextLines);
      if TextLineCount > 0 then
      begin
        SetLength(FTextLines, TextLineCount);
        for i := 0 to TextLineCount - 1 do
          with TextLines[i] do
            FTextLines[i] := Rect(Left, Top, Left + Width, Top + Height);
      end
    finally
      if TextLines <> nil then
        TesseractDeleteBoxes(TextLines);
    end;
  Result := Length(FTextLines);
end;

function TTesseractOCR.GetTextLines(Index: Integer): TRect;
begin
  Check((Index >= 0) and (Index < TextLineCount), rsIncorrectTextLineIndex);
  Result := FTextLines[Index];
end;

function TTesseractOCR.GetWordCount: Integer;
var
  WordCount: Integer;
  Words: POCRBoxArray;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FWords = nil) then
    try
      WordCount := TesseractGetWords(FHandle, Words);
      if WordCount > 0 then
      begin
        SetLength(FWords, WordCount);
        for var i := 0 to WordCount - 1 do
          with Words[i] do
            FWords[i] := Rect(Left, Top, Left + Width, Top + Height);
      end
    finally
      if Words <> nil then
        TesseractDeleteBoxes(Words);
    end;
  Result := Length(FWords);
end;

function TTesseractOCR.GetWords(Index: Integer): TRect;
begin
  Check((Index >= 0) and (Index < WordCount), rsIncorrectWordIndex);
  Result := FWords[Index];
end;

function TTesseractOCR.GetWordDetailCount: Integer;
var
  WordCount: Integer;
  Words: PWordItemArray;
  Flags: TOCRWordFlags;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FWordDetails = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      WordCount := TesseractGetWordItems(FHandle, Words);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if (WordCount > 0) then
    try
      SetLength(FWordDetails, WordCount);
      for var i := 0 to WordCount - 1 do
        with Words[i] do
        begin
          Flags := [];
          if IsBold <> 0 then
            Flags := Flags + [wfBold];
          if IsItalic <> 0 then
            Flags := Flags + [wfItalic];
          if IsUnderlined <> 0 then
            Flags := Flags + [wfUnderlined];
          if IsMonospace <> 0 then
            Flags := Flags + [wfMonospace];
          if IsSerif <> 0 then
            Flags := Flags + [wfSerif];
          if IsSmallCaps <> 0 then
            Flags := Flags + [wfSmallCaps];
          if IsDropCap <> 0 then
            Flags := Flags + [wfDropCap];
          if IsSubscript <> 0 then
            Flags := Flags + [wfSubscript];
          if IsSuperscript <> 0 then
            Flags := Flags + [wfSuperscript];
          if IsNumeric <> 0 then
            Flags := Flags + [wfNumeric];
          if IsFromDictionary <> 0 then
            Flags := Flags + [wfFromDictionary];
          FWordDetails[i].Location := Rect(Left, Top, Right, Bottom);
          FWordDetails[i].Text := UTF8ToString(Text);
          FWordDetails[i].Flags := Flags;
          FWordDetails[i].FontName := UTF8ToString(FontName);
          FWordDetails[i].PointSize := PointSize;
          FWordDetails[i].Confidence := Confidence;
        end;
    finally
      if Words <> nil then
        TesseractDeleteWordItems(Words, WordCount);
    end
  end;
  Result := Length(FWordDetails);
end;

function TTesseractOCR.GetWordDetails(Index: Integer): TOCRWord;
begin
  Check((Index >= 0) and (Index < WordDetailCount), rsIncorrectWordDetailIndex);
  Result := FWordDetails[Index];
end;

function TTesseractOCR.GetTextLineDetailCount: Integer;
var
  Count: Integer;
  TextLines: PTextLineItemArray;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FTextLineDetails = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      Count := TesseractGetTextLineItems(FHandle, TextLines);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if (Count > 0) then
    try
      SetLength(FTextLineDetails, Count);
      for var i := 0 to Count - 1 do
        with TextLines[i] do
        begin
          FTextLineDetails[i].Location         := Rect(Left, Top, Right, Bottom);
          FTextLineDetails[i].Text             := UTF8ToString(Text);
          FTextLineDetails[i].Confidence       := Confidence;
          FTextLineDetails[i].DeskewAngle      := DeskewAngle;
          FTextLineDetails[i].Orientation      := TOCRPageOrientation(Orientation);
          FTextLineDetails[i].WritingDirection := TOCRWritingDirection(WritingDirection);
          FTextLineDetails[i].TextLineOrder    := TOCRTextLineOrder(TextLineOrder);
        end;
    finally
      if TextLines <> nil then
        TesseractDeleteTextLineItems(TextLines, Count);
    end
  end;
  Result := Length(FTextLineDetails);
end;

function TTesseractOCR.GetTextLineDetails(Index: Integer): TOCRTextLine;
begin
  Check((Index >= 0) and (Index < TextLineDetailCount), rsIncorrectTextLineDetailIndex);
  Result := FTextLineDetails[Index];
end;

function TTesseractOCR.GetParagraphCount: Integer;
var
  Count: Integer;
  Paragraphs: PParagraphItemArray;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FParagraphs = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      Count := TesseractGetParagraphItems(FHandle, Paragraphs);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if Count > 0 then
      try
        SetLength(FParagraphs, Count);
        for var I := 0 to Count - 1 do
          with Paragraphs[I] do
          begin
            FParagraphs[I].Location         := Rect(Left, Top, Right, Bottom);
            FParagraphs[I].Text             := UTF8ToString(Text);
            FParagraphs[I].Confidence       := Confidence;
            FParagraphs[I].FirstLineIndent  := FirstLineIndent;
            FParagraphs[I].DeskewAngle      := DeskewAngle;
            FParagraphs[I].Justification    := TOCRParagraphJustification(Justification);
            FParagraphs[I].Orientation      := TOCRPageOrientation(Orientation);
            FParagraphs[I].WritingDirection := TOCRWritingDirection(WritingDirection);
            FParagraphs[I].TextLineOrder    := TOCRTextLineOrder(TextLineOrder);
            FParagraphs[I].IsListItem       := IsListItem <> 0;
            FParagraphs[I].IsCrown          := IsCrown <> 0;
            FParagraphs[I].IsLeftToRight    := IsLeftToRight <> 0;
          end;
      finally
        if Paragraphs <> nil then
          TesseractDeleteParagraphItems(Paragraphs, Count);
      end
  end;
  Result := Length(FParagraphs);
end;

function TTesseractOCR.GetParagraphs(Index: Integer): TOCRParagraph;
begin
  Check((Index >= 0) and (Index < ParagraphCount), rsIncorrectParagraphIndex);
  Result := FParagraphs[Index];
end;

function TTesseractOCR.GetSymbolCount: Integer;
var
  Count: Integer;
  Symbols: PSymbolItemArray;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FSymbols = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      Count := TesseractGetSymbolItems(FHandle, Symbols);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if (Count > 0) then
      try
        SetLength(FSymbols, Count);
        for var i := 0 to Count - 1 do
          with Symbols[i] do
          begin
            FSymbols[i].Location := Rect(Left, Top, Right, Bottom);
            FSymbols[i].Text := UTF8ToString(Text);
            FSymbols[i].Confidence := Confidence;
          end;
      finally
        if Symbols <> nil then
          TesseractDeleteSymbolItems(Symbols, Count);
      end
  end;
  Result := Length(FSymbols);
end;

function TTesseractOCR.GetSymbols(Index: Integer): TOCRSymbol;
begin
  Check((Index >= 0) and (Index < SymbolCount), rsIncorrectSymbolIndex);
  Result := FSymbols[Index];
end;

function TTesseractOCR.GetRegionDetailCount: Integer;
var
  Count: Integer;
  RegionDetails: PBlockItemArray;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FRegionDetails = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      Count := TesseractGetBlockItems(FHandle, RegionDetails);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if (Count > 0) then
    try
      SetLength(FRegionDetails, Count);
      for var i := 0 to Count - 1 do
        with RegionDetails[i] do
        begin
          FRegionDetails[i].Location := Rect(Left, Top, Right, Bottom);
          FRegionDetails[i].Text := UTF8ToString(Text);
          FRegionDetails[i].Confidence := Confidence;
          FRegionDetails[i].DeskewAngle := DeskewAngle;
          FRegionDetails[i].Orientation := TOCRPageOrientation(Orientation);
          FRegionDetails[i].WritingDirection := TOCRWritingDirection(WritingDirection);
          FRegionDetails[i].TextLineOrder := TOCRTextLineOrder(TextLineOrder);
        end;
    finally
      if RegionDetails <> nil then
        TesseractDeleteBlockItems(RegionDetails, Count);
    end
  end;
  Result := Length(FRegionDetails);
end;

function TTesseractOCR.GetRegionDetails(Index: Integer): TOCRRegion;
begin
  Check((Index >= 0) and (Index < RegionDetailCount), rsIncorrectRegionDetailIndex);
  Result := FRegionDetails[Index];
end;

function TTesseractOCR.GetSymbolChoiceCount: Integer;
var
  Count: Integer;
  SymbolChoices: PSymbolChoiceItemArray;
  ArithmeticMask: TArithmeticMask;
begin
  CheckActive;
  if not Recognized then
    Recognize;
  if Recognized and (FSymbolChoices = nil) then
  begin
    ArithmeticMask := SetArithmeticMask;
    try
      Count := TesseractGetSymbolChoiceItems(FHandle, SymbolChoices);
    finally
      RestoreArithmeticMask(ArithmeticMask);
    end;

    if (Count > 0) then
    try
      SetLength(FSymbolChoices, Count);
      for var i := 0 to Count - 1 do
        with SymbolChoices[i] do
        begin
          FSymbolChoices[i].Location := Rect(Left, Top, Right, Bottom);
          FSymbolChoices[i].Text := UTF8ToString(Text);
          FSymbolChoices[i].Confidence := Confidence;
          SetLength(FSymbolChoices[i].Choices, ChoiceCount);
          for var j := 0 to ChoiceCount - 1 do
          begin
            FSymbolChoices[i].Choices[j].Text := UTF8ToString(Choices[j].Text);
            FSymbolChoices[i].Choices[j].Confidence := Choices[j].Confidence;
          end;
        end;
    finally
      if SymbolChoices <> nil then
        TesseractDeleteSymbolChoiceItems(SymbolChoices, Count);
    end
  end;
  Result := Length(FSymbolChoices);
end;

function TTesseractOCR.GetSymbolChoices(Index: Integer): TOCRSymbolChoice;
begin
  Check((Index >= 0) and (Index < SymbolChoiceCount), rsIncorrectSymbolIndex);
  Result := FSymbolChoices[Index];
end;

function TTesseractOCR.GetInitLanguages: string;
begin
  CheckActive;
  Result := UTF8ToString(TesseractGetInitLanguages(FHandle));
end;

function TTesseractOCR.GetLoadedLanguages: TStringDynArray;
var
  Count: Integer;
  Languages: PAnsiStringArray;
begin
  CheckActive;
  Count := TesseractGetLoadedLanguages(FHandle, Languages);
  if Count > 0 then
  try
    SetLength(Result, Count);
    for var i := 0 to Count - 1 do
      Result[i] := UTF8ToString(Languages[i]);
  finally
    TesseractDeleteStringArray(Languages, Count);
  end;
end;

function TTesseractOCR.GetAvailableLanguages: TStringDynArray;
var
  Count: Integer;
  Languages: PAnsiStringArray;
begin
  CheckActive;
  Count := TesseractGetAvailableLanguages(FHandle, Languages);
  if (Count > 0) then
  try
    SetLength(Result, Count);
    for var i := 0 to Count - 1 do
      Result[i] := UTF8ToString(Languages[i]);
  finally
    TesseractDeleteStringArray(Languages, Count);
  end;
end;

procedure TTesseractOCR.AnalyseLayout;
var
  PageOrientation: Integer;
  TextLineOrder: Integer;
  WritingDirection: Integer;
begin
  CheckActive;
  if not FLayoutAnalysed then
  begin
    DoRecognize(True);
    Check(TesseractAnalyseLayout(FHandle, PageOrientation, WritingDirection, TextLineOrder, FDeskewAngle), rsCannotAnalyseLayout);
    FPageOrientation  := TOCRPageOrientation(PageOrientation);
    FWritingDirection := TOCRWritingDirection(WritingDirection);
    FTextLineOrder    := TOCRTextLineOrder(TextLineOrder);
    FLayoutAnalysed   := True;
  end;
end;

function TTesseractOCR.GetPageOrientation: TOCRPageOrientation;
begin
  AnalyseLayout;
  Result := FPageOrientation;
end;

function TTesseractOCR.GetWritingDirection: TOCRWritingDirection;
begin
  AnalyseLayout;
  Result := FWritingDirection;
end;

function TTesseractOCR.GetTextLineOrder: TOCRTextLineOrder;
begin
  AnalyseLayout;
  Result := FTextLineOrder;
end;

function TTesseractOCR.GetDeskewAngle: Single;
begin
  AnalyseLayout;
  Result := FDeskewAngle;
end;

function TTesseractOCR.GetPageCount: Integer;
begin
  CheckActive;
  Result := TesseractPageCount(PAnsiChar(AnsiString(PictureFileName)));
end;

procedure TTesseractOCR.SetPageNumber(Value: Integer);
begin
  if FPageNumber <> Value then
  begin
    FPageNumber := Value;
    Recognized := False;
  end;
end;

procedure TTesseractOCR.SetResolution(Value: Integer);
begin
  if FResolution <> Value then
  begin
    FResolution := Value;
    Recognized := False;
  end;
end;

procedure TTesseractOCR.ClearInitParameters;
begin
  FParameterNames := nil;
  FParameterValues := nil;
end;

procedure TTesseractOCR.AddInitParameter(const Name, Value: AnsiString);
var
  Size: Integer;
begin
  Size := Length(FParameterNames) + 1;
  SetLength(FParameterNames, Size);
  SetLength(FParameterValues, Size);
  FParameterNames[Size - 1] := Name;
  FParameterValues[Size - 1] := Value;
end;

// Tesseract library

function Loaded: Boolean;
begin
  Result := hLibrary <> 0;
end;

procedure UnloadLibrary;
begin
  if Loaded then
  begin
    FreeLibrary(hLibrary);
    hLibrary := 0;
  end;
end;

procedure CheckLoadLibrary(const Name: string);
begin
  hLibrary := Winapi.Windows.LoadLibrary(PChar(Name));
  Check(hLibrary <> 0, SysErrorMessage(GetLastError) + ': ' + Name);
end;

function CheckGetProcAddress(const Name: string): Pointer;
var
  ErrorMessage: string;
begin
  Result := GetProcAddress(hLibrary, PChar(Name));
  if Result = nil then
  begin
    ErrorMessage := SysErrorMessage(GetLastError) + ': ' + Name;
    UnloadLibrary;
    Check(False, ErrorMessage);
  end;
end;

procedure LoadLibrary;
begin
  if not Loaded then
  begin
    CheckLoadLibrary(LibraryName);
    TesseractAdaptToWordStr          := CheckGetProcAddress('AdaptToWordStr');
    TesseractAddImage                := CheckGetProcAddress('AddImage');
    TesseractAnalyseLayout           := CheckGetProcAddress('AnalyseLayout');
    TesseractBeginDocument           := CheckGetProcAddress('BeginDocument');
    TesseractClear                   := CheckGetProcAddress('Clear');
    TesseractClearAdaptiveClassifier := CheckGetProcAddress('ClearAdaptiveClassifier');
    TesseractClearPersistentCache    := CheckGetProcAddress('ClearPersistentCache');
    TesseractCreatePdfRenderer       := CheckGetProcAddress('CreatePdfRenderer');
    TesseractDelete                  := CheckGetProcAddress('Delete');
    TesseractDeleteBlockItems        := CheckGetProcAddress('DeleteBlockItems');
    TesseractDeleteBoxes             := CheckGetProcAddress('DeleteBoxes');
    TesseractDeleteParagraphItems    := CheckGetProcAddress('DeleteParagraphItems');
    TesseractDeletePdfRenderer       := CheckGetProcAddress('DeletePdfRenderer');
    TesseractDeleteString            := CheckGetProcAddress('DeleteString');
    TesseractDeleteStringArray       := CheckGetProcAddress('DeleteStringArray');
    TesseractDeleteSymbolChoiceItems := CheckGetProcAddress('DeleteSymbolChoiceItems');
    TesseractDeleteSymbolItems       := CheckGetProcAddress('DeleteSymbolItems');
    TesseractDeleteTextLineItems     := CheckGetProcAddress('DeleteTextLineItems');
    TesseractDeleteWordItems         := CheckGetProcAddress('DeleteWordItems');
    TesseractEnd                     := CheckGetProcAddress('End');
    TesseractEndDocument             := CheckGetProcAddress('EndDocument');
    TesseractGetAltoText             := CheckGetProcAddress('GetAltoText');
    TesseractGetAvailableLanguages   := CheckGetProcAddress('GetAvailableLanguages');
    TesseractGetBlockItems           := CheckGetProcAddress('GetBlockItems');
    TesseractGetBoolVariable         := CheckGetProcAddress('GetBoolVariable');
    TesseractGetBoxText              := CheckGetProcAddress('GetBoxText');
    TesseractGetConnectedComponents  := CheckGetProcAddress('GetConnectedComponents');
    TesseractGetDoubleVariable       := CheckGetProcAddress('GetDoubleVariable');
    TesseractGetHOCRText             := CheckGetProcAddress('GetHOCRText');
    TesseractGetImagelibVersions     := CheckGetProcAddress('GetImagelibVersions');
    TesseractGetInitLanguages        := CheckGetProcAddress('GetInitLanguages');
    TesseractGetIntVariable          := CheckGetProcAddress('GetIntVariable');
    TesseractGetLeptonicaVersion     := CheckGetProcAddress('GetLeptonicaVersion');
    TesseractGetLoadedLanguages      := CheckGetProcAddress('GetLoadedLanguages');
    TesseractGetPageSegMode          := CheckGetProcAddress('GetPageSegMode');
    TesseractGetParagraphItems       := CheckGetProcAddress('GetParagraphItems');
    TesseractGetRegions              := CheckGetProcAddress('GetRegions');
    TesseractGetStringVariable       := CheckGetProcAddress('GetStringVariable');
    TesseractGetStrips               := CheckGetProcAddress('GetStrips');
    TesseractGetSymbolChoiceItems    := CheckGetProcAddress('GetSymbolChoiceItems');
    TesseractGetSymbolItems          := CheckGetProcAddress('GetSymbolItems');
    TesseractGetTextDirection        := CheckGetProcAddress('GetTextDirection');
    TesseractGetTextLineItems        := CheckGetProcAddress('GetTextLineItems');
    TesseractGetTextLines            := CheckGetProcAddress('GetTextLines');
    TesseractGetTSVText              := CheckGetProcAddress('GetTSVText');
    TesseractGetUnichar              := CheckGetProcAddress('GetUnichar');
    TesseractGetUNLVText             := CheckGetProcAddress('GetUNLVText');
    TesseractGetUTF8Text             := CheckGetProcAddress('GetUTF8Text');
    TesseractGetVersion              := CheckGetProcAddress('GetTesseractVersion');
    TesseractGetWordItems            := CheckGetProcAddress('GetWordItems');
    TesseractGetWords                := CheckGetProcAddress('GetWords');
    TesseractInit                    := CheckGetProcAddress('Init');
    TesseractIsValidCharacter        := CheckGetProcAddress('IsValidCharacter');
    TesseractIsValidWord             := CheckGetProcAddress('IsValidWord');
    TesseractMeanTextConf            := CheckGetProcAddress('MeanTextConf');
    TesseractNew                     := CheckGetProcAddress('New');
    TesseractPageCount               := CheckGetProcAddress('PageCount');
    TesseractPrintVariables          := CheckGetProcAddress('PrintVariables');
    TesseractReadConfigFile          := CheckGetProcAddress('ReadConfigFile');
    TesseractRecognize               := CheckGetProcAddress('Recognize');
    TesseractRect                    := CheckGetProcAddress('TesseractRect');
    TesseractSetImage                := CheckGetProcAddress('SetImage');
    TesseractSetImageFile            := CheckGetProcAddress('SetImageFile');
    TesseractSetInputName            := CheckGetProcAddress('SetInputName');
    TesseractSetMinOrientationMargin := CheckGetProcAddress('SetMinOrientationMargin');
    TesseractSetOutputName           := CheckGetProcAddress('SetOutputName');
    TesseractSetPageSegMode          := CheckGetProcAddress('SetPageSegMode');
    TesseractSetRectangle            := CheckGetProcAddress('SetRectangle');
    TesseractSetSourceResolution     := CheckGetProcAddress('SetSourceResolution');
    TesseractSetVariable             := CheckGetProcAddress('SetVariable');
  end;
end;

end.
