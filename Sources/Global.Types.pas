﻿unit Global.Types;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} System.IOUtils, Vcl.Forms,
  ArrayHelper, VirtualTrees, System.RegularExpressions, System.Math, Vcl.Graphics, Utils.Files, XmlFiles,
  TesseractOCR.Types, System.JSON, System.IniFiles;
{$ENDREGION}

type
  TTypePattern = (tpRegularExpression, tpAhoCorasick);
  TTypePatternHelper = record helper for TTypePattern
    function ToString: string;
  end;

  PProject = ^TProject;
  TProject = record
    Current            : Boolean;
    ProjectId          : string;
    Name               : string;
    Info               : string;
    PathForAttachments : string;
    DeleteAttachments  : Boolean;
    UseOCR             : Boolean;
    LanguageOCR        : TOCRLanguage;
  end;

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
    Mask : string;
    Path : string;
    Info : string;
    procedure Clear;
  end;
  TSorterPathArray = TArrayRecord<TSorterPath>;
  TMatchCollectionArray = TArrayRecord<TMatchCollection>;

  PAttachment = ^TAttachment;
  TAttachment = record
    Id          : string;
    ParentId    : string;
    Hash        : string;
    ParentHash  : string;
    ParentName  : string;
    ShortName   : string;
    FileName    : string;
    ContentId   : string;
    ContentType : string;
    ParsedText  : string;
    ImageIndex  : Byte;
    Matches     : TArrayRecord<TStringArray>;
    OwnerNode   : PVirtualNode;
    FromZip     : Boolean;
    FromDB      : Boolean;
    Size        : Integer;
    function ToJSON: string;
    procedure Clear;
    procedure LengthAlignment;
    class operator Initialize(out aDest: TAttachment);
  end;

  PResultData = ^TResultData;
  TResultData = record
    Id          : string;
    Attachments : TArrayRecord<string>;
    Body        : string;
    FileName    : TFileName;
    Hash        : string;
    From        : string;
    To_         : string;
    CC          : string;
    MessageId   : string;
    ShortName   : string;
    Subject     : string;
    TimeStamp   : TDateTime;
    ContentType : string;
    ParsedText  : string;
    Matches     : TArrayRecord<TStringArray>;
    OwnerNode   : PVirtualNode;
    function ToJSON: string;
    procedure Clear;
    procedure LengthAlignment;
    class operator Initialize(out aDest: TResultData);
  end;
  TResultDataArray = TArrayRecord<PResultData>;
  PResultDataArray = ^TResultDataArray;

  PEmail = ^TEmail;
  TEmail = record
    Hash    : string;
    Matches : TStringArray;
  end;

  PAttachData = ^TAttachData;
  TAttachData = record
    Hash    : string;
    Matches : TStringArray;
  end;

  PFileData = ^TFileData;
  TFileData = record
    Hash      : string;
    FileName  : string;
    ShortName : string;
    Date      : TDateTime;
    Size      : Integer;
    IsDeleted : Boolean;
  end;

  PPassword = ^TPassword;
  TPassword = record
    Hash      : string;
    FileName  : string;
    ShortName : string;
    Password  : string;
    IsDeleted : Boolean;
    Info      : string;
  end;
  TPasswordArray = TArrayRecord<PPassword>;

  PPasswordData = ^TPasswordData;
  TPasswordData = record
    Hash: string;
  end;

  PPatternData = ^TPatternData;
  TPatternData = record
    TypePattern   : TTypePattern;
    ParameterName : string;
    Pattern       : string;
    GroupIndex    : Integer;
    UseRawText    : Boolean;
    Color         : TColor;
    IsSelected    : Boolean;
    procedure Assign(Source: TPatternData);
    procedure Clear;
  end;

  TPasswordList = class(TObjectDictionary<string, PPassword>)
  public
    constructor Create;
    destructor Destroy; override;
    function GetItem(const aKey: string): PPassword;
    procedure LoadData;
    procedure ClearData;
  end;

  TPatternList = class(TList<PPatternData>)
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadData;
    procedure ClearData;
  end;

  TEmailList = class(TObjectDictionary<string, PResultData>)
  public
    constructor Create;
    destructor Destroy; override;
    function GetItem(const aKey: string): PResultData;
    procedure ClearData;
    procedure ClearParentNodePointer;
    procedure SetCapacity(const aValue: Integer);
    procedure UpdateMatches(const aCount: Integer);
  end;

  TAttachmentList = class(TObjectDictionary<string, PAttachment>)
  public
    constructor Create;
    destructor Destroy; override;
    function GetItem(const aKey: string): PAttachment;
    procedure ClearData;
    procedure ClearParentNodePointer;
    procedure SetCapacity(const aValue: Integer);
    procedure UpdateMatches(const aCount: Integer);
  end;

  TGeneral = record
  public
    class function GetCounterValue: Integer; static;
    class function GetPathList: TParamPathArray; static;
    class function GetSorterPathList: TSorterPathArray; static;
    class function XMLFile: TXMLFile; static;
    class function XMLParams: TXMLFile; static;
    class procedure NoHibernate; static;
    class procedure Initialize; static;
    class var
      ActiveFrame    : TFrame;
      AttachmentList : TAttachmentList;
      CurrentProject : TProject;
      EmailList      : TEmailList;
      PasswordList   : TPasswordList;
      PatternList    : TPatternList;
  end;

  TAttachmentDir = (adAttachment, adSubAttachment, adUserDefined);
  TAttachmentDirHelper = record helper for TAttachmentDir
    function FromString(aDir: string): TAttachmentDir;
  end;

  TFilterSet = set of 0 .. SizeOf(Cardinal) * 8 - 1;     //Count of RegExp patterns - 32
  TFilterOperation = (foAND, foOR);
  TExtIcon = (eiPdf = 20, eiPng = 21, eiGif = 8, eiIco = 2, eiJpg = 12, eiZip = 30, eiRar = 23, eiHtml = 9,
              eiTxt = 0,  eiXls = 29, eiDoc = 4, eiTiff = 25);
  TExtIconHelper = record helper for TExtIcon
    function ToByte: Byte;
  end;

const
  C_ICON_SIZE     = 40;
  C_TOP_COLOR     = $001E4DFF;
  C_PROGRESS_STEP = 10;
  MaxCardinal: Cardinal = $FFFFFFFF;

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

class function TGeneral.GetPathList: TParamPathArray;
var
  Data: TParamPath;
  i: Integer;
  Section: string;
begin
  if not CurrentProject.ProjectId.IsEmpty then
    Section := 'Path.' + CurrentProject.ProjectId
  else
    Section := 'Path';
  XMLParams.Open;
  XMLParams.CurrentSection := Section;
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
  Section: string;
begin
  if not CurrentProject.ProjectId.IsEmpty then
    Section := 'Sorter.' + CurrentProject.ProjectId
  else
    Section := 'Sorter';
  XMLParams.Open;
  XMLParams.CurrentSection := Section;
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

class procedure TGeneral.Initialize;
begin
  XMLParams.Open;
  PasswordList.LoadData;
  PatternList.LoadData;
  ActiveFrame    := nil;
  CurrentProject := Default(TProject);
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

{ TResultData }

procedure TResultData.Clear;
begin
  Matches.Clear;
  Self.Attachments.Clear;
  Self := Default(TResultData);
  Self.OwnerNode := nil;
end;

class operator TResultData.Initialize(out aDest: TResultData);
begin
  aDest.OwnerNode := nil;
  aDest.Id        := TFileUtils.GetGuid;
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

function TResultData.ToJSON: string;
var
  MailJSON: TJSONObject;
  ResultJSON: TJSONObject;
  TagsArray: TJSONArray;
begin
  ResultJSON := TJSONObject.Create;
  try
    ResultJSON.AddPair('id', Self.Id);
    // ResultJSON.AddPair('parentId', '');
    ResultJSON.AddPair('projectId', TGeneral.CurrentProject.ProjectId);
    ResultJSON.AddPair('hash', Self.Hash);
    ResultJSON.AddPair('filePath', TPath.GetDirectoryName(Self.FileName));
    ResultJSON.AddPair('fileName', TPath.GetFileName(Self.FileName));
    ResultJSON.AddPair('contentType', 'multipart/mixed');
    ResultJSON.AddPair('rawText', Self.Body);
    ResultJSON.AddPair('plainText', Self.ParsedText);
    // ResultJSON.AddPair('comment', '');
    ResultJSON.AddPair('rank', 0);
    ResultJSON.AddPair('isChecked', False);

    MailJSON := TJSONObject.Create;
    MailJSON.AddPair('from', Self.From);
    MailJSON.AddPair('to', Self.To_);
    MailJSON.AddPair('cc', Self.cc);
    MailJSON.AddPair('messageId', Self.MessageId);
    MailJSON.AddPair('timeStamp', Self.TimeStamp);
    ResultJSON.AddPair('jsonObj', MailJSON);

    if Self.Matches.Count > 0 then
    begin
      var
        st: THashedStringList;
      st := THashedStringList.Create;
      st.Duplicates := TDuplicates.dupIgnore;
      try
        for var i := 0 to Self.Matches.Count - 1 do
          for var j := 0 to Self.Matches[i].Count - 1 do
            st.AddPair(TGeneral.PatternList[i].ParameterName, Self.Matches[i][j]);

        TagsArray := TJSONArray.Create;
        for var i := 0 to st.Count - 1 do
        begin
          var
          TagsJson := TJSONObject.Create;
          TagsJson.AddPair('name', st.Names[i]);
          TagsJson.AddPair('value', st.ValueFromIndex[i]);
          TagsJson.AddPair('barnId', Self.Id);
          TagsArray.Add(TagsJson);
        end;
      finally
        FreeAndNil(st);
      end;
      if (TagsArray.Count > 0) then
        ResultJSON.AddPair('tags', TagsArray);
    end;

    Result := ResultJSON.ToJSON;
  finally
    FreeAndNil(ResultJSON);
  end;
end;

{ TAttachment }

procedure TAttachment.Clear;
begin
  Self := Default(TAttachment);
  Matches.Clear;
end;

class operator TAttachment.Initialize(out aDest: TAttachment);
begin
  aDest.OwnerNode := nil;
  aDest.FromZip   := False;
  aDest.FromDB    := False;
  aDest.Id        := TFileUtils.GetGuid;
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

function TAttachment.ToJSON: string;
var
  ResultJSON: TJSONObject;
  TagsArray: TJSONArray;
begin
  ResultJSON := TJSONObject.Create;
  try
    ResultJSON.AddPair('id', Self.Id);
    if not Self.ParentId.IsEmpty then
      ResultJSON.AddPair('parentId', Self.ParentId);
    ResultJSON.AddPair('projectId', TGeneral.CurrentProject.ProjectId);
    ResultJSON.AddPair('hash', Self.Hash);
    ResultJSON.AddPair('filePath', TPath.GetDirectoryName(Self.FileName));
    ResultJSON.AddPair('fileName', Self.ShortName);
    ResultJSON.AddPair('contentType', Self.ContentType);
    ResultJSON.AddPair('rawText', '');
    ResultJSON.AddPair('plainText', Self.ParsedText);
    ResultJSON.AddPair('rank', 0);
    ResultJSON.AddPair('isChecked', False);

    if Self.Matches.Count > 0 then
    begin
      var
        st: THashedStringList;
      st := THashedStringList.Create;
      st.Duplicates := TDuplicates.dupIgnore;
      try
        for var i := 0 to Self.Matches.Count - 1 do
          for var j := 0 to Self.Matches[i].Count - 1 do
            st.AddPair(TGeneral.PatternList[i].ParameterName, Self.Matches[i][j]);

        TagsArray := TJSONArray.Create;
        for var i := 0 to st.Count - 1 do
        begin
          var
          TagsJson := TJSONObject.Create;
          TagsJson.AddPair('name', st.Names[i]);
          TagsJson.AddPair('value', st.ValueFromIndex[i]);
          TagsJson.AddPair('barnId', Self.Id);
          TagsArray.Add(TagsJson);
        end;
      finally
        FreeAndNil(st);
      end;
      if (TagsArray.Count > 0) then
        ResultJSON.AddPair('tags', TagsArray);
    end;

    Result := ResultJSON.ToJSON;
  finally
    FreeAndNil(ResultJSON);
  end;
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
  inherited Create([], 100000);

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

procedure TEmailList.SetCapacity(const aValue: Integer);
begin
  if (aValue > Self.Count) and (aValue > Self.Capacity) then
    Self.Capacity := aValue * 2;
end;

procedure TEmailList.UpdateMatches(const aCount: Integer);
begin
  for var item in Self.Values do
    if Assigned(item) then
      item^.Matches.Count := aCount;
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
    item.OwnerNode := nil;
end;

{ TAttachmentList }

constructor TAttachmentList.Create;
begin
  inherited Create([], 100000);

end;

destructor TAttachmentList.Destroy;
begin
  ClearData;
  inherited;
end;

function TAttachmentList.GetItem(const aKey: string): PAttachment;
begin
  Result := nil;
  if Self.ContainsKey(aKey) then
    Result := Self.Items[aKey];
end;

procedure TAttachmentList.SetCapacity(const aValue: Integer);
begin
  if (aValue > Self.Count) and (aValue > Self.Capacity) then
    Self.Capacity := aValue * 2;
end;

procedure TAttachmentList.ClearData;
begin
  for var item in Self do
    Dispose(item.Value);
  Self.Clear;
end;

procedure TAttachmentList.ClearParentNodePointer;
begin
  for var item in Self.Values do
    item.OwnerNode := nil;
end;

procedure TAttachmentList.UpdateMatches(const aCount: Integer);
begin
  for var item in Self.Values do
    if Assigned(item) then
      item^.Matches.Count := aCount;
end;

{ TSorterPath }

procedure TSorterPath.Clear;
begin
  Self := Default(TSorterPath);
end;

{ TPasswordList }

constructor TPasswordList.Create;
begin
  inherited Create([], 100);

end;

destructor TPasswordList.Destroy;
begin
  ClearData;
  inherited;
end;

procedure TPasswordList.ClearData;
begin
  for var item in Self do
    Dispose(item.Value);
  Self.Clear;
end;

function TPasswordList.GetItem(const aKey: string): PPassword;
begin
  Result := nil;
  if Self.ContainsKey(aKey) then
    Result := Self.Items[aKey];
end;

procedure TPasswordList.LoadData;
var
  Data: PPassword;
begin
  TGeneral.XMLParams.CurrentSection := 'Passwords';
  try
    while not TGeneral.XMLParams.IsLastKey do
    begin
      if TGeneral.XMLParams.ReadAttributes then
      begin
        New(Data);
        Data^.FileName  := TGeneral.XMLParams.Attributes.GetAttributeValue('FileName', '');
        Data^.ShortName := TPath.GetFileName(Data^.FileName);
        Data^.Password  := TGeneral.XMLParams.Attributes.GetAttributeValue('Password', '');
        Data^.Hash      := TGeneral.XMLParams.Attributes.GetAttributeValue('Hash', '');
        Data^.Info      := TGeneral.XMLParams.Attributes.GetAttributeValue('Info', '');
        Data^.IsDeleted := not TFile.Exists(Data^.FileName);
        if Data^.Hash.IsEmpty and not Data^.IsDeleted then
          Data^.Hash := TFileUtils.GetHash(Data^.FileName);
        if not Data^.Hash.IsEmpty then
          Self.Add(Data^.Hash, Data)
        else
          Dispose(Data);
      end;
      TGeneral.XMLParams.NextKey;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
  end;
end;

{ TTypePatternHelper }

function TTypePatternHelper.ToString: string;
begin
  case Self of
    tpRegularExpression:
      Result := 'RegExpTemplate';
    tpAhoCorasick:
      Result := 'AhoCorasick';
  end;
end;

{ TPatternList }

constructor TPatternList.Create;
begin
  inherited Create;

end;

destructor TPatternList.Destroy;
begin
  ClearData;
  inherited;
end;

procedure TPatternList.ClearData;
begin
  for var item in Self do
    Dispose(item);
  Self.Clear;
end;

procedure TPatternList.LoadData;
var
  Data: PPatternData;
begin
  ClearData;
  TGeneral.XMLParams.CurrentSection := C_SECTION_REGEXP;
  try
    while not TGeneral.XMLParams.IsLastKey do
    begin
      if TGeneral.XMLParams.ReadAttributes then
      begin
        New(Data);
        Data^.TypePattern   := TGeneral.XMLParams.Attributes.GetAttributeValue('TypePattern', TTypePattern.tpRegularExpression);
        Data^.ParameterName := TGeneral.XMLParams.Attributes.GetAttributeValue('ParameterName', '');
        Data^.Pattern       := TGeneral.XMLParams.Attributes.GetAttributeValue('RegExpTemplate', '');
        Data^.GroupIndex    := TGeneral.XMLParams.Attributes.GetAttributeValue('GroupIndex', 0);
        Data^.UseRawText    := TGeneral.XMLParams.Attributes.GetAttributeValue('UseRawText', False);
        Data^.Color         := TGeneral.XMLParams.Attributes.GetAttributeValue('Color', clRed  {arrWebColors[Random(High(arrWebColors))].Color});
        Data^.IsSelected    := True;
        Self.Add(Data);
      end;
      TGeneral.XMLParams.NextKey;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
  end;

  TGeneral.EmailList.UpdateMatches(Self.Count);
  TGeneral.AttachmentList.UpdateMatches(Self.Count);
end;

{ TPatternData }

procedure TPatternData.Assign(Source: TPatternData);
begin
  Self.TypePattern    := Source.TypePattern;
  Self.ParameterName  := Source.ParameterName;
  Self.Pattern        := Source.Pattern;
  Self.GroupIndex     := Source.GroupIndex;
  Self.UseRawText     := Source.UseRawText;
  Self.Color          := Source.Color;
  Self.IsSelected     := Source.IsSelected;
end;

procedure TPatternData.Clear;
begin
  Self := Default(TPatternData);
end;

initialization
  TGeneral.AttachmentList := TAttachmentList.Create;
  TGeneral.EmailList      := TEmailList.Create;
  TGeneral.PasswordList   := TPasswordList.Create;
  TGeneral.PatternList    := TPatternList.Create;

finalization
  if Assigned(FXMLFile) then
  begin
    FXMLFile.Save;
    FreeAndNil(FXMLFile);
  end;

  if Assigned(TGeneral.AttachmentList) then
    FreeAndNil(TGeneral.AttachmentList);
  if Assigned(TGeneral.EmailList) then
    FreeAndNil(TGeneral.EmailList);
  if Assigned(TGeneral.PasswordList) then
    FreeAndNil(TGeneral.PasswordList);
  if Assigned(TGeneral.PatternList) then
    FreeAndNil(TGeneral.PatternList);

end.
