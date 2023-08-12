unit Column.Types;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.Generics.Collections, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} DebugWriter;
{$ENDREGION}

type
  PColumnSetting = ^TColumnSetting;
  TColumnSetting = record
    Name     : string;
    Position : Integer;
    Index    : Integer;
    Width    : Integer;
    Visible  : Boolean;
    procedure AssignFrom(aColumnSetting: TColumnSetting);
    procedure Clear;
  end;

  TArrayColumns = TArray<TColumnSetting>;
  PArrayColumns = ^TArrayColumns;

implementation

{ TColumnSetting }

procedure TColumnSetting.AssignFrom(aColumnSetting: TColumnSetting);
begin
  Self.Name     := aColumnSetting.Name;
  Self.Position := aColumnSetting.Position;
  Self.Index    := aColumnSetting.Index;
  Self.Width    := aColumnSetting.Width;
  Self.Visible  := aColumnSetting.Visible;
end;

procedure TColumnSetting.Clear;
begin
  Name := '';
end;

end.
