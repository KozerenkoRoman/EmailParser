unit Global.Types;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Global.Resources,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter, XmlFiles,
  System.IOUtils, Vcl.Forms, ArrayHelper, Data.DB, System.Win.Registry, Common.Types, Translate.Lang,
  System.IniFiles;
{$ENDREGION}

type
  PRegExpData = ^TRegExpData;
  TRegExpData = record
    ParameterName  : string;
    RegExpTemplate : string;
    procedure Clear;
  end;

  PParamPath = ^TParamPath;
  TParamPath = record
    Path       : string;
    Info       : string;
    WithSubdir : Boolean;
    procedure Clear;
  end;
  TParamPathArray = TArrayRecord<TParamPath>;

  PAttachments = ^TAttachments;
  TAttachments = record
    ShortName   : string;
    FileName    : string;
    ContentID   : string;
    ContentType : string;
    ParsedText  : string;
    procedure Clear;
  end;
  TAttachmentsArray = TArray<TAttachments>;

  PResultData = ^TResultData;
  TResultData = record
    Position    : Integer;
    Attachments : TAttachmentsArray;
    Body        : string;
    FileName    : TFileName;
    From        : string;
    MessageId   : string;
    ShortName   : string;
    Subject     : string;
    TimeStamp   : TDateTime;
    ContentType : string;
    ParsedText  : string;
    procedure Clear;
    procedure Assign(const aData: TResultData);
  end;

  TGeneral = record
  public
    class function GetPathList: TArray<TParamPath>; static;
    class function GetRegExpParametersList: TArray<TRegExpData>; static;
    class function XMLFile: TXMLFile; static;
    class function XMLParams: TXMLFile; static;
  end;

  TAttachmentsDir = (adAttachments, adSubAttachments, adUserDefined);
  TAttachmentsDirHelper = record helper for TAttachmentsDir
    function FromString(aDir: string): TAttachmentsDir;
  end;

const
  C_ICON_SIZE = 39;

resourcestring
  C_ATTACHMENTS_DIR       = '#Attachments';
  C_ATTACHMENTS_SUB_DIR   = '#Sub#Attachments';
  C_IDENTITY_COLUMNS_NAME = '.Columns';
  C_SECTION_MAIN          = 'Main';


var
  General: TGeneral;

implementation

var
  FXMLFile: TXMLFile = nil;
  FXMLParams: TXMLFile = nil;

{ TGeneral }

class function TGeneral.XMLParams: TXMLFile;
begin
  if not Assigned(FXMLParams) then
  begin
    FXMLParams := TXmlFile.Create(TPath.ChangeExtension(TPath.GetFullPath(Application.ExeName), '.xml'));
    FXMLParams.UsedAttributes := [uaComment, uaValue];
  end;
  Result := FXMLParams;
end;

class function TGeneral.GetRegExpParametersList: TArray<TRegExpData>;
var
  Data: TRegExpData;
  i: Integer;
begin
  XMLParams.Open;
  XMLParams.CurrentSection := 'RegExpParameters';
  try
    i := 0;
    SetLength(Result, XMLParams.ChildCount);
     while not XMLParams.IsLastKey do
    begin
      if XMLParams.ReadAttributes then
      begin
        Data.ParameterName  := XMLParams.Attributes.GetAttributeValue('ParameterName', '');
        Data.RegExpTemplate := XMLParams.Attributes.GetAttributeValue('RegExpTemplate', '');
        Result[i] := Data;
        Inc(i);
      end;
      XMLParams.NextKey;
    end;
  finally
    XMLParams.CurrentSection := '';
  end;
end;

class function TGeneral.GetPathList: TArray<TParamPath>;
var
  Data: TParamPath;
  i: Integer;
begin
  XMLParams.Open;
  XMLParams.CurrentSection := 'Path';
  try
    i := 0;
    SetLength(Result, XMLParams.ChildCount);
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

class function TGeneral.XMLFile: TXMLFile;
begin
  if not Assigned(FXmlFile) then
    FXmlFile := TXmlFile.Create(GetEnvironmentVariable('USERPROFILE') + '\' + TPath.GetFileNameWithoutExtension(Application.ExeName) + '.xml');
  Result := FXmlFile;
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

procedure TResultData.Assign(const aData: TResultData);
begin
  Self.Position    := aData.Position;
  Self.ShortName   := aData.ShortName;
  Self.FileName    := aData.FileName;
  Self.MessageId   := aData.MessageId;
  Self.Subject     := aData.Subject;
  Self.Attachments := aData.Attachments;
  Self.TimeStamp   := aData.TimeStamp;
  Self.Body        := aData.Body;
  Self.From        := aData.From;
  Self.ContentType := aData.ContentType;
  Self.ParsedText  := aData.ParsedText;
  SetLength(Self.Attachments, Length(aData.Attachments));
  for var att := Low(Self.Attachments) to High(Self.Attachments) do
  begin
    Self.Attachments[att].ShortName   := aData.Attachments[att].ShortName;
    Self.Attachments[att].FileName    := aData.Attachments[att].FileName;
    Self.Attachments[att].ContentID   := aData.Attachments[att].ContentID;
    Self.Attachments[att].ContentType := aData.Attachments[att].ContentType;
    Self.Attachments[att].ParsedText  := aData.Attachments[att].ParsedText;
  end;
end;

procedure TResultData.Clear;
begin
  for var att := Low(Self.Attachments) to High(Self.Attachments) do
    Self.Attachments[att].Clear;
  Self := Default(TResultData);
end;

{ TAttachments }

procedure TAttachments.Clear;
begin
  Self := Default (TAttachments);
end;

{ TAttachmentsDirHelper }

function TAttachmentsDirHelper.FromString(aDir: string): TAttachmentsDir;
begin
  if aDir.IsEmpty then
    Result := adSubAttachments
  else if aDir.Equals(C_ATTACHMENTS_DIR) then
    Result := adAttachments
  else if aDir.Equals(C_ATTACHMENTS_SUB_DIR) then
    Result := adSubAttachments
  else
    Result := adUserDefined;
end;

initialization

finalization
  if Assigned(FXMLFile) then
  begin
    FXMLFile.Save;
    FreeAndNil(FXMLFile);
  end;

  if Assigned(FXMLParams) then
    FreeAndNil(FXMLParams);

end.
