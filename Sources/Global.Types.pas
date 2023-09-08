unit Global.Types;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Data.DB, System.Win.Registry, Common.Types, Translate.Lang,
  System.IniFiles, VirtualTrees, System.RegularExpressions, System.Math;
{$ENDREGION}

type
  PRegExpData = ^TRegExpData;
  TRegExpData = record
    ParameterName  : string;
    RegExpTemplate : string;
    GroupIndex     : Integer;
    UseRawText     : Boolean;
    procedure Clear;
  end;
  TRegExpArray = TArrayRecord<TRegExpData>;

  PParamPath = ^TParamPath;
  TParamPath = record
    Path       : string;
    Info       : string;
    WithSubdir : Boolean;
    procedure Clear;
  end;
  TParamPathArray = TArrayRecord<TParamPath>;

  PSorterPath = ^TSorterPath;
  TSorterPath = record
    Mask       : string;
    Path       : string;
    Info       : string;
    procedure Clear;
  end;
  TSorterPathArray = TArrayRecord<TSorterPath>;
  TMatchCollectionArray = TArrayRecord<TMatchCollection>;

  PAttachment = ^TAttachment;
  TAttachment = record
    Hash        : string;
    ParentHash  : string;
    ParentName  : string;
    Position    : Integer;
    ShortName   : string;
    FileName    : string;
    ContentID   : string;
    ContentType : string;
    ParsedText  : string;
    ImageIndex  : Byte;
    Matches     : TArrayRecord<TStringArray>;
    FromZip     : Boolean;
    FromDB      : Boolean;
    procedure Assign(const aData: TAttachment);
    procedure Clear;
    procedure LengthAlignment;
  end;
  TAttachmentArray = TArray<TAttachment>;
  PAttachmentArray = ^TAttachmentArray;

  PResultData = ^TResultData;
  TResultData = record
    Attachments : TAttachmentArray;
    Body        : string;
    FileName    : TFileName;
    Hash        : string;
    From        : string;
    MessageId   : string;
    ShortName   : string;
    Subject     : string;
    TimeStamp   : TDateTime;
    ContentType : string;
    ParsedText  : string;
    Matches     : TArrayRecord<TStringArray>;
    ParentNode  : PVirtualNode;
    Position    : Integer;
    IsMatch     : Boolean;
    procedure Clear;
    procedure LengthAlignment;
  end;
  TResultDataArray = TArrayRecord<PResultData>;
  PResultDataArray = ^TResultDataArray;

  PEmail = ^TEmail;
  TEmail = record
    Hash    : string;
    Matches : TStringArray;
  end;

  TEmailList = class(TObjectDictionary<string, PResultData>)
  public
    constructor Create;
    destructor Destroy; override;
    function GetItem(const aKey: string): PResultData;
    procedure AddItem(const aResultData: PResultData);
    procedure ClearData;
    procedure ClearParentNodePointer;
  end;

  TGeneral = record
  public
    class function GetCounterValue: Integer; static;
    class function GetPathList: TParamPathArray; static;
    class function GetSorterPathList: TSorterPathArray;  static;
    class function GetRegExpParametersList: TRegExpArray; static;
    class function XMLFile: TXMLFile; static;
    class function XMLParams: TXMLFile; static;
    class procedure NoHibernate; static;
    class var
      EmailList: TEmailList;
  end;

  TAttachmentDir = (adAttachment, adSubAttachment, adUserDefined);
  TAttachmentDirHelper = record helper for TAttachmentDir
    function FromString(aDir: string): TAttachmentDir;
  end;

  TExtIcon = (eiPdf = 20, eiPng = 21, eiGif = 8, eiIco = 2, eiJpg = 12, eiZip = 30, eiRar = 23, eiHtml = 9, eiTxt = 27,
              eiXls = 29, eiDoc = 04);
  TExtIconHelper = record helper for TExtIcon
    function ToByte: Byte;
  end;

const
  C_ICON_SIZE = 39;
  C_TOP_COLOR = $001E4DFF;

var
  General: TGeneral;

implementation

var
  FXMLFile: TXMLFile = nil;
  FXMLParams: TXMLFile = nil;

{ TGeneral }

class procedure TGeneral.NoHibernate;
begin
  if Assigned(@SetThreadExecutionState) then
    SetThreadExecutionState(ES_SYSTEM_REQUIRED or ES_CONTINUOUS {or ES_DISPLAY_REQUIRED});
end;

class function TGeneral.XMLFile: TXMLFile;
begin
  if not Assigned(FXmlFile) then
    FXmlFile := TXmlFile.Create(GetEnvironmentVariable('USERPROFILE') + '\' + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.xml');
  Result := FXmlFile;
end;

class function TGeneral.XMLParams: TXMLFile;
begin
  if not Assigned(FXMLParams) then
  begin
    FXMLParams := TXmlFile.Create(TPath.Combine(TPath.GetDirectoryName(Application.ExeName), C_XML_PARAMS_FILE));
    FXMLParams.UsedAttributes := [uaComment, uaValue];
  end;
  Result := FXMLParams;
end;

class function TGeneral.GetRegExpParametersList: TRegExpArray;
var
  Data: TRegExpData;
  i: Integer;
begin
  XMLParams.Open;
  XMLParams.CurrentSection := C_SECTION_REGEXP;
  try
    i := 0;
    Result.Count := XMLParams.ChildCount;
    while not XMLParams.IsLastKey do
    begin
      if XMLParams.ReadAttributes then
      begin
        Data.ParameterName  := XMLParams.Attributes.GetAttributeValue('ParameterName', '');
        Data.RegExpTemplate := XMLParams.Attributes.GetAttributeValue('RegExpTemplate', '');
        Data.GroupIndex     := XMLParams.Attributes.GetAttributeValue('GroupIndex', 0);
        Data.UseRawText     := XMLParams.Attributes.GetAttributeValue('UseRawText', False);
        Result[i] := Data;
        Inc(i);
      end;
      XMLParams.NextKey;
    end;
  finally
    XMLParams.CurrentSection := '';
  end;
end;

class function TGeneral.GetPathList: TParamPathArray;
var
  Data: TParamPath;
  i: Integer;
begin
  XMLParams.Open;
  XMLParams.CurrentSection := 'Path';
  try
    i := 0;
    Result.Count := XMLParams.ChildCount;
    while not XMLParams.IsLastKey do
    begin
      if XMLParams.ReadAttributes then
      begin
        Data.WithSubdir := XMLParams.Attributes.GetAttributeValue('WithSubdir', True);
        Data.Path       := XMLParams.Attributes.GetAttributeValue('Path', '');
        Data.Info       := XMLParams.Attributes.GetAttributeValue('Info', '');
        Result[i]       := Data;
        Inc(i);
      end;
      XMLParams.NextKey;
    end;
  finally
    XMLParams.CurrentSection := '';
  end;
end;

class function TGeneral.GetSorterPathList: TSorterPathArray;
var
  Data: TSorterPath;
  i: Integer;
begin
  XMLParams.Open;
  XMLParams.CurrentSection := 'Sorter';
  try
    i := 0;
    Result.Count := XMLParams.ChildCount;
    while not XMLParams.IsLastKey do
    begin
      if XMLParams.ReadAttributes then
      begin
        Data.Mask := XMLParams.Attributes.GetAttributeValue('Mask', '');
        Data.Path := XMLParams.Attributes.GetAttributeValue('Path', '');
        Data.Info := XMLParams.Attributes.GetAttributeValue('Info', '');
        Result[i] := Data;
        Inc(i);
      end;
      XMLParams.NextKey;
    end;
  finally
    XMLParams.CurrentSection := '';
  end;
end;

class function TGeneral.GetCounterValue: Integer;
begin
  Result := XMLParams.ReadInteger(C_SECTION_MAIN, 'Counter', 0);
  Inc(Result);
  XMLParams.WriteInteger(C_SECTION_MAIN, 'Counter', Result);
end;

{TParamPath}

procedure TParamPath.Clear;
begin
  Self := Default(TParamPath);
end;

{TRegExpData}

procedure TRegExpData.Clear;
begin
  Self := Default(TRegExpData);
end;

{ TResultData }

procedure TResultData.Clear;
begin
  Matches.Clear;
  for var att := Low(Self.Attachments) to High(Self.Attachments) do
    Self.Attachments[att].Clear;
  Self := Default(TResultData);
  Self.ParentNode := nil;
  Self.IsMatch    := False;
end;

procedure TResultData.LengthAlignment;
var
  MaxLen: Integer;
  i: Integer;
begin
  MaxLen := 0;
  for i := Low(Matches.Items) to High(Matches.Items) do
    MaxLen := Max(MaxLen, Matches[i].Count);
  for i := Low(Matches.Items) to High(Matches.Items) do
    Matches[i].Count := MaxLen;
end;

{ TAttachment }

procedure TAttachment.Assign(const aData: TAttachment);
begin
  Self.Hash        := aData.Hash;
  Self.ParentHash  := aData.ParentHash;
  Self.ShortName   := aData.ShortName;
  Self.FileName    := aData.FileName;
  Self.ContentID   := aData.ContentID;
  Self.ContentType := aData.ContentType;
  Self.ParsedText  := aData.ParsedText;
  Self.ImageIndex  := aData.ImageIndex;
  Self.ParentName  := aData.ParentName;
  Self.FromZip     := aData.FromZip;
  Self.FromDB      := aData.FromDB;
  Self.Matches.Count := aData.Matches.Count;
  for var i := 0 to Self.Matches.Count - 1 do
    Self.Matches[i] := aData.Matches[i];
end;

procedure TAttachment.Clear;
begin
  Self := Default(TAttachment);
  Matches.Clear;
end;

procedure TAttachment.LengthAlignment;
var
  MaxLen: Integer;
  i: Integer;
begin
  MaxLen := 0;
  for i := Low(Matches.Items) to High(Matches.Items) do
    MaxLen := Max(MaxLen, Matches[i].Count);
  for i := Low(Matches.Items) to High(Matches.Items) do
    Matches[i].Count := MaxLen;
end;

{ TAttachmentDirHelper }

function TAttachmentDirHelper.FromString(aDir: string): TAttachmentDir;
begin
  if aDir.IsEmpty then
    Result := adSubAttachment
  else if aDir.Equals(C_ATTACHMENTS_DIR) then
    Result := adAttachment
  else if aDir.Equals(C_ATTACHMENTS_SUB_DIR) then
    Result := adSubAttachment
  else
    Result := adUserDefined;
end;

{ TExtIconHelper }

function TExtIconHelper.ToByte: Byte;
begin
  Result := Ord(Self);
end;

{ TEmailList }

constructor TEmailList.Create;
begin
  inherited Create([], 500000);

end;

destructor TEmailList.Destroy;
begin
  ClearData;
  inherited;
end;

function TEmailList.GetItem(const aKey: string): PResultData;
begin
  Result := nil;
  if Self.ContainsKey(aKey) then
    Result := Self.Items[aKey];
end;

procedure TEmailList.AddItem(const aResultData: PResultData);
begin
  Self.AddOrSetValue(aResultData.Hash, aResultData);
end;

procedure TEmailList.ClearData;
begin
  for var item in Self do
    Dispose(item.Value);
  Self.Clear;
end;

procedure TEmailList.ClearParentNodePointer;
begin
  for var item in Self.Values do
    item.ParentNode := nil;
end;

{ TSorterPath }

procedure TSorterPath.Clear;
begin
  Self := Default(TSorterPath);
end;

initialization
  TGeneral.EmailList := TEmailList.Create;

finalization
  if Assigned(FXMLFile) then
  begin
    FXMLFile.Save;
    FreeAndNil(FXMLFile);
  end;
  if Assigned(TGeneral.EmailList) then
    FreeAndNil(TGeneral.EmailList);

end.
