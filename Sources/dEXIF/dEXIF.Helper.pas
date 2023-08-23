unit dEXIF.Helper;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.StdCtrls, Translate.Lang, Vcl.ExtCtrls, System.IniFiles, System.IOUtils,

  dGlobal, dMetadata, dEXIF, dIPTC;
{$ENDREGION}

type
  TEXIFObject = (eoEXIF, eoMSpecific, eoIPTC, eoSummaryShort, eoSummaryLong);
  TEXIFObjects = set of TEXIFObject;

  TEXIFDump = class
  private const
    C_OPEN_TAG    = '<%s>';
    C_CLOSE_TAG   = '</%s>';
    C_COMMENT_TAG = '<!--%s-->';
  private
    FBuilder     : TStringBuilder;
    FEXIFObjects : TEXIFObjects;
    FFileName    : TFileName;
    FImgData     : TImgData;
    procedure AppendComment(const aTagValue: string);
    procedure AppendTag(const aTagName, aTagValue: string);
    procedure DumpEXIFAsTags;
    procedure DumpEXIFAsText;
    procedure DumpMSpecificAsTags;
    procedure DumpMSpecificAsText;
  public
    constructor Create(const aFileName: TFileName; const aEXIFObjects: TEXIFObjects = [eoEXIF]);
    destructor Destroy; override;

    function GetTags: string;
    function GetText: string;
  end;

implementation

{ TEXIFDump }

constructor TEXIFDump.Create(const aFileName: TFileName; const aEXIFObjects: TEXIFObjects = [eoEXIF]);
begin
  FFileName := aFileName;
  FBuilder  := TStringBuilder.Create;
  FImgData  := TImgData.Create;
  FImgData.BuildList := GenAll;
  FEXIFObjects := aEXIFObjects;
end;

destructor TEXIFDump.Destroy;
begin
  FreeAndNil(FBuilder);
  FreeAndNil(FImgData);
  inherited;
end;

procedure TEXIFDump.DumpEXIFAsText;
var
  tag: TTagEntry;
begin
  if not (eoEXIF in FEXIFObjects) then
    Exit;

  FBuilder.AppendLine
          .AppendLine('-- EXIF-Data --------------')
          .AppendLine('ErrStr = ' + FImgData.ErrStr);
  if not FImgData.HasEXIF() then
    Exit;

//  FBuilder.AppendLine(FImgData.ExifObj.TraceStr);
  FImgData.ExifObj.ResetIterator;
  while FImgData.ExifObj.IterateFoundTags(GenericEXIF, tag) do
    FBuilder.AppendLine(tag.Desc.Trim)
            .Append(dExifDelim)
            .Append(tag.Data.Trim)
            .AppendLine(' ');
end;

procedure TEXIFDump.DumpMSpecificAsText;
var
  tag: TTagEntry;
begin
  if not (eoMSpecific in FEXIFObjects) then
    Exit;
  FBuilder.AppendLine
          .AppendLine('-- Maker Specific Data ----')
          .AppendLine(FImgData.ExifObj.msTraceStr);
  FImgData.ExifObj.ResetIterator;
  while FImgData.ExifObj.IterateFoundTags(CustomEXIF, tag) do
    FBuilder.AppendLine(tag.Desc)
            .Append(DexifDelim)
            .Append(tag.Data)
            .AppendLine(' ');
end;

function TEXIFDump.GetText: string;
var
  ts: TStringList;
begin
  if not TFile.Exists(FFileName) then
    Exit('');

  FImgData.BuildList := GenAll;
  FImgData.ProcessFile(FFileName);
  DumpEXIFAsText;

  if not FImgData.HasMetaData then
    Exit;

  if FImgData.HasEXIF and FImgData.ExifObj.msAvailable then
    DumpMSpecificAsText;

  if FImgData.HasComment then
    FBuilder.AppendLine
            .AppendLine('Comment segment available')
            .AppendLine(FImgData.Comment);

  if (eoIPTC in FEXIFObjects) and FImgData.HasIPTC then
  begin
    ts := TStringList.Create;
    try
      FImgData.IptcObj.IPTCArrayToList(ts);
      if (ts.Count > 0) then
      begin
        FBuilder.AppendLine
                .AppendLine('IPTC segment available')
                .AppendLine;
        for var i := 0 to ts.Count - 1 do
          FBuilder.AppendLine(ts.strings[i]);
      end;
    finally
      FreeAndNil(ts);
    end;
  end;

  if not FImgData.HasEXIF then
    Exit;

  if (eoSummaryShort in FEXIFObjects) then
    FBuilder.AppendLine
            .AppendLine('-- EXIF Summary (short) -----')
            .AppendLine(FImgData.ExifObj.toShortString())
            .AppendLine;

  if (eoSummaryLong in FEXIFObjects) then
    FBuilder.AppendLine
            .AppendLine('-- EXIF Summary (long) ------')
            .AppendLine(FImgData.ExifObj.toLongString())
            .AppendLine;
  Result := FBuilder.ToString;
end;

procedure TEXIFDump.AppendComment(const aTagValue: string);
begin
  FBuilder.AppendFormat(C_COMMENT_TAG, [aTagValue.Trim])
          .AppendLine;
end;

procedure TEXIFDump.AppendTag(const aTagName, aTagValue: string);
begin
  FBuilder.AppendFormat(C_OPEN_TAG, [aTagName.Trim])
          .Append(aTagValue.Trim)
          .AppendFormat(C_CLOSE_TAG, [aTagName.Trim])
          .AppendLine;
end;

procedure TEXIFDump.DumpEXIFAsTags;
var
  tag: TTagEntry;
begin
  if not (eoEXIF in FEXIFObjects) then
    Exit;
  AppendComment('EXIF-Data');
  AppendTag('ErrStr', FImgData.ErrStr);

  if not FImgData.HasEXIF() then
    Exit;

  FImgData.ExifObj.ResetIterator;
  while FImgData.ExifObj.IterateFoundTags(GenericEXIF, tag) do
    AppendTag(tag.Desc, tag.Data);
end;

procedure TEXIFDump.DumpMSpecificAsTags;
var
  tag: TTagEntry;
begin
  if not(eoMSpecific in FEXIFObjects) then
    Exit;
  AppendComment('Maker Specific Data');

  // FImgData.AppendLine(FImgData.ExifObj.msTraceStr);
  FImgData.ExifObj.ResetIterator;
  while FImgData.ExifObj.IterateFoundTags(CustomEXIF, tag) do
    AppendTag(tag.Desc, tag.Data);
end;

function TEXIFDump.GetTags: string;
var
  ts: TStringList;
begin
  if not TFile.Exists(FFileName) then
    Exit('');

  FImgData.BuildList := GenAll;
  FImgData.ProcessFile(FFileName);
  DumpEXIFAsTags;

  if not FImgData.HasMetaData then
    Exit;

  if FImgData.HasEXIF and FImgData.ExifObj.msAvailable then
    DumpMSpecificAsTags;

  if FImgData.HasComment then
  begin
    AppendComment('Comment segment available');
    AppendComment(FImgData.Comment);
  end;

  if (eoIPTC in FEXIFObjects) and FImgData.HasIPTC then
  begin
    ts := TStringList.Create;
    try
      FImgData.IptcObj.IPTCArrayToList(ts);
      if (ts.Count > 0) then
      begin
        AppendComment('IPTC segment available');
        for var i := 0 to ts.Count - 1 do
          AppendComment(ts.strings[i]);
      end;
    finally
      FreeAndNil(ts);
    end;
  end;

  if not FImgData.HasEXIF then
    Exit;

  if (eoSummaryShort in FEXIFObjects) then
  begin
    AppendComment('EXIF Summary (short)');
    FBuilder.AppendLine(FImgData.ExifObj.toShortString()) //TODO: get strings as tags
    .AppendLine;
  end;

  if (eoSummaryLong in FEXIFObjects) then
  begin
    AppendComment('EXIF Summary (long)');
    FBuilder.AppendLine(FImgData.ExifObj.toLongString()) //TODO: get strings as tags
            .AppendLine;
  end;
  Result := FBuilder.ToString;
end;

end.
