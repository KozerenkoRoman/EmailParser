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
  TNodeType = (ntNode, ntGroup);

  PRegExpData = ^TRegExpData;
  TRegExpData = record
    ParameterName: string;
    RegExpTemplate: string;
    procedure Clear;
  end;

  PParamPath = ^TParamPath;
  TParamPath = record
    Path: string;
    Info: string;
    WithSubdir: Boolean;
    procedure Clear;
  end;
  TParamPathArray = TArrayRecord<TParamPath>;

  PResultData = ^TResultData;
  TResultData = record
    ShortName : string;
    FileName  : TFileName;
    MessageId : string;
    Subject   : string;
    Attach    : Integer;
    TimeStamp : TDateTime;
    procedure Clear;
    procedure Assign(const aData: TResultData);
  end;

  TGeneral = record
  public
    class function XMLFile: TXMLFile; static;
    class function XmlParams: TXMLFile; static;
    class function GetPathList: TArray<TParamPath>; static;
    class function GetRegExpParametersList: TArray<TRegExpData>; static;
  end;

const
  C_SECTION_MAIN = 'Main';

var
  General: TGeneral;

implementation

var
  FXMLFile: TXMLFile = nil;
  FXMLParams: TXMLFile = nil;

{ TGeneral }

class function TGeneral.XmlParams: TXMLFile;
begin
  if not Assigned(FXMLParams) then
    FXMLParams := TXmlFile.Create(TPath.ChangeExtension(TPath.GetFullPath(Application.ExeName), '.xml'));
  Result := FXMLParams;
end;

class function TGeneral.GetRegExpParametersList: TArray<TRegExpData>;
var
  Data: TRegExpData;
  i: Integer;
begin
  XmlParams.Open;
  XmlParams.CurrentSection := 'RegExpParameters';
  try
    i := 0;
    SetLength(Result, XmlParams.ChildCount);
     while not XmlParams.IsLastKey do
    begin
      if XmlParams.ReadAttributes then
      begin
        Data.ParameterName  := XmlParams.Attributes.GetAttributeValue('ParameterName', '');
        Data.RegExpTemplate := XmlParams.Attributes.GetAttributeValue('RegExpTemplate', '');
        Result[i] := Data;
        Inc(i);
      end;
      XmlParams.NextKey;
    end;
  finally
    XmlParams.CurrentSection := '';
  end;
end;

class function TGeneral.GetPathList: TArray<TParamPath>;
var
  Data: TParamPath;
  i: Integer;
begin
  XmlParams.Open;
  XmlParams.CurrentSection := 'Path';
  try
    i := 0;
    SetLength(Result, XmlParams.ChildCount);
    while not XmlParams.IsLastKey do
    begin
      if XmlParams.ReadAttributes then
      begin
        Data.WithSubdir := XmlParams.Attributes.GetAttributeValue('WithSubdir', True);
        Data.Path       := XmlParams.Attributes.GetAttributeValue('Path', '');
        Data.Info       := XmlParams.Attributes.GetAttributeValue('Info', '');
        Result[i]       := Data;
        Inc(i);
      end;
      XmlParams.NextKey;
    end;
  finally
    XmlParams.CurrentSection := '';
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
  Self.ShortName := aData.ShortName;
  Self.FileName  := aData.FileName;
  Self.MessageId := aData.MessageId;
  Self.Subject   := aData.Subject;
  Self.Attach    := aData.Attach;
  Self.TimeStamp := aData.TimeStamp;
end;

procedure TResultData.Clear;
begin
  Self := Default(TResultData);
end;

initialization

finalization

  if Assigned(FXmlFile) then
  begin
    FXmlFile.Save;
    FreeAndNil(FXmlFile);
  end;


end.
