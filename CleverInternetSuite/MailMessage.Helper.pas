unit MailMessage.Helper;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, DebugWriter, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF}
  System.StrUtils, System.Generics.Defaults, System.Generics.Collections, System.DateUtils, System.UITypes,
  clMailMessage, Global.Types;
{$ENDREGION}

type
  TclMailMessageHelper = class helper for TclMailMessage
  private
    class var FData: PResultData;
    function GetResultData: TResultData;
    procedure SetResultData(const Value: TResultData);
  public
    property ResultData: TResultData read GetResultData write SetResultData;
  end;

implementation

{ TclMailMessageHelper }

function TclMailMessageHelper.GetResultData: TResultData;
begin
  Assert(FData <> nil, 'ResultData cannot be nil');
  Result := FData^;
end;

procedure TclMailMessageHelper.SetResultData(const Value: TResultData);
begin
  FData := @Value;
end;

end.
