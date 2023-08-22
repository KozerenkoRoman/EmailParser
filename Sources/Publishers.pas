unit Publishers;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Winapi.Messages, DebugWriter, System.Threading, System.Types, Global.Types,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Publishers.Interfaces;
{$ENDREGION}

type
  TCustomPublisher = class(TList<TObject>)
  public
    procedure Subscribe(aItem: TObject); virtual;
    procedure Unsubscribe(aItem: TObject); virtual;
  end;

  TUpdateXMLPublisher = class(TCustomPublisher)
  public
    procedure UpdateXML;
  end;

  TProgressPublisher = class(TCustomPublisher)
  public
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: TResultData);
  end;

  TEmailPublisher = class(TCustomPublisher)
  public
    procedure FocusChanged(const aData: PResultData);
  end;

  TPublishers = class
  class var
    ProgressPublisher  : TProgressPublisher;
    UpdateXMLPublisher : TUpdateXMLPublisher;
    EmailPublisher     : TEmailPublisher;
  end;

implementation

{ TCustomPublisher }

procedure TCustomPublisher.Subscribe(aItem: TObject);
begin
  if (Self.IndexOf(aItem) < 0) then
    Self.Add(aItem);
end;

procedure TCustomPublisher.Unsubscribe(aItem: TObject);
begin
  if (Self.IndexOf(aItem) >= 0) then
    Self.Remove(aItem);
end;

{ TUpdateXMLPublisher }

procedure TUpdateXMLPublisher.UpdateXML;
var
  Item: TObject;
  obj: IUpdateXML;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
    begin
      Item := Self.Items[i];
      if Assigned(Item) then
        if Supports(Item, IUpdateXML, obj) then
          TThread.Queue(nil,
            procedure
            begin
              obj.UpdateXML;
            end);
    end;
end;

{ TProgressPublisher }

procedure TProgressPublisher.CompletedItem(const aResultData: TResultData);
var
  Item: TObject;
  obj: IProgress;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      begin
        for var i := 0 to Self.Count - 1 do
        begin
          Item := Self.Items[i];
          if Assigned(Item) then
            if Supports(Item, IProgress, obj) then
              obj.CompletedItem(aResultData);
        end;
      end);
end;

procedure TProgressPublisher.EndProgress;
var
  Item: TObject;
  obj: IProgress;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      begin
        for var i := 0 to Self.Count - 1 do
        begin
          Item := Self.Items[i];
          if Assigned(Item) then
            if Supports(Item, IProgress, obj) then
              obj.EndProgress;
        end;
      end);
end;

procedure TProgressPublisher.Progress;
var
  Item: TObject;
  obj: IProgress;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      begin
        for var i := 0 to Self.Count - 1 do
        begin
          Item := Self.Items[i];
          if Assigned(Item) then
            if Supports(Item, IProgress, obj) then
              obj.Progress;
        end;
      end);
end;

procedure TProgressPublisher.StartProgress(const aMaxPosition: Integer);
var
  Item: TObject;
  obj: IProgress;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      begin
        for var i := 0 to Self.Count - 1 do
        begin
          Item := Self.Items[i];
          if Assigned(Item) then
            if Supports(Item, IProgress, obj) then
              obj.StartProgress(aMaxPosition);
        end;
      end);
end;

{ TEmailPublisher }

procedure TEmailPublisher.FocusChanged(const aData: PResultData);
var
  Item: TObject;
  obj: IEmailChange;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      begin
        for var i := 0 to Self.Count - 1 do
        begin
          Item := Self.Items[i];
          if Assigned(Item) then
            if Supports(Item, IEmailChange, obj) then
              obj.FocusChanged(aData);
        end;
      end);
end;

initialization
  TPublishers.ProgressPublisher  := TProgressPublisher.Create;
  TPublishers.UpdateXMLPublisher := TUpdateXMLPublisher.Create;
  TPublishers.EmailPublisher     := TEmailPublisher.Create;

finalization
  if Assigned(TPublishers.UpdateXMLPublisher) then
    FreeAndNil(TPublishers.UpdateXMLPublisher);
  if Assigned(TPublishers.ProgressPublisher) then
    FreeAndNil(TPublishers.ProgressPublisher);
  if Assigned(TPublishers.EmailPublisher) then
    FreeAndNil(TPublishers.EmailPublisher);

end.
