unit MailMessage.Helper;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, DebugWriter, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF}
  System.StrUtils, System.Generics.Defaults, System.Generics.Collections, System.DateUtils, System.UITypes,
  clMailMessage, Global.Types, clHtmlParser;
{$ENDREGION}

type
  TclMailMessageHelper = class helper for TclMailMessage
  private
    class var FData: PResultData;
    function GetResultData: PResultData;
    procedure SetResultData(const Value: PResultData);
  public
    property ResultData: PResultData read GetResultData write SetResultData;
  end;

  TclHtmlParserHelper = class helper for TclHtmlParser
  private
    class var FData: PResultData;
    function GetResultData: PResultData;
    procedure SetResultData(const Value: PResultData);
  public
    property ResultData: PResultData read GetResultData write SetResultData;
  end;

implementation

{ TclMailMessageHelper }

function TclMailMessageHelper.GetResultData: PResultData;
begin
  Assert(FData <> nil, 'ResultData cannot be nil');
  Result := FData;
end;

procedure TclMailMessageHelper.SetResultData(const Value: PResultData);
begin
  FData := Value;
end;

{ TclHtmlParserHelper }

function TclHtmlParserHelper.GetResultData: PResultData;
begin
  Assert(FData <> nil, 'ResultData cannot be nil');
  Result := FData;
end;

procedure TclHtmlParserHelper.SetResultData(const Value: PResultData);
begin
  FData := Value;
end;

end.
