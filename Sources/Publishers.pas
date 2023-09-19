unit Publishers;

interface

{$REGION 'Region uses'}

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections, System.Generics.Defaults,
  Vcl.Forms, Winapi.Messages, DebugWriter, System.Threading, System.Types, Global.Types,
  {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF} Publishers.Interfaces;
{$ENDREGION}

type
  TCustomPublisher = class(TThreadList<TObject>)
  protected
    function Count: Integer;
  public
    procedure Subscribe(aItem: TObject); virtual;
    procedure Unsubscribe(aItem: TObject); virtual;
  end;

  TConfigPublisher = class(TCustomPublisher)
  public
    procedure UpdateRegExp;
    procedure UpdateFilter(const aOperation: TFilterOperation);
    procedure UpdateLanguage;
  end;

  TProgressPublisher = class(TCustomPublisher)
  public
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aResultData: PResultData);
    procedure CompletedAttach(const aAttachment: PAttachment);
    procedure ClearTree;
  end;

  TEmailPublisher = class(TCustomPublisher)
  public
    procedure FocusChanged(const aData: PResultData);
  end;

  TPublishers = class
  class var
    EmailPublisher    : TEmailPublisher;
    ProgressPublisher : TProgressPublisher;
    ConfigPublisher   : TConfigPublisher;
  end;

implementation

{ TCustomPublisher }

function TCustomPublisher.Count: Integer;
begin
  try
    Result := Self.LockList.Count;
  finally
    Self.UnlockList;
  end;
end;

procedure TCustomPublisher.Subscribe(aItem: TObject);
begin
  try
    if (Self.LockList.IndexOf(aItem) < 0) then
      Self.Add(aItem);
  finally
    Self.UnlockList;
  end;
end;

procedure TCustomPublisher.Unsubscribe(aItem: TObject);
begin
  try
    if (Self.LockList.IndexOf(aItem) >= 0) then
      Self.Remove(aItem);
  finally
    Self.UnlockList;
  end;
end;

{ TConfigPublisher }

procedure TConfigPublisher.UpdateFilter(const aOperation: TFilterOperation);
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IConfig;
            begin
              if Supports(Item, IConfig, obj) then
                obj.UpdateFilter(aOperation);
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TConfigPublisher.UpdateLanguage;
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IConfig;
            begin
              if Supports(Item, IConfig, obj) then
                obj.UpdateLanguage;
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TConfigPublisher.UpdateRegExp;
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IConfig;
            begin
              if Supports(Item, IConfig, obj) then
                obj.UpdateRegExp;
            end);
      finally
        Self.UnlockList;
      end;
end;

{ TProgressPublisher }

procedure TProgressPublisher.ClearTree;
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IProgress;
            begin
              if Supports(Item, IProgress, obj) then
                obj.ClearTree;
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TProgressPublisher.CompletedAttach(const aAttachment: PAttachment);
var
  Item: TObject;
begin
  if not Application.Terminated then
    TThread.Queue(nil,
      procedure
      var
        obj: IProgress;
      begin
        for var i := 0 to Self.Count - 1 do
          try
            Item := Self.LockList.Items[i];
            if Assigned(Item) then
              if Supports(Item, IProgress, obj) then
                obj.CompletedAttach(aAttachment);
          finally
            Self.UnlockList;
          end;
      end);
end;

procedure TProgressPublisher.CompletedItem(const aResultData: PResultData);
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IProgress;
            begin
              if Supports(Item, IProgress, obj) then
                obj.CompletedItem(aResultData);
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TProgressPublisher.EndProgress;
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IProgress;
            begin
              if Supports(Item, IProgress, obj) then
                obj.EndProgress;
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TProgressPublisher.Progress;
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IProgress;
            begin
              if Supports(Item, IProgress, obj) then
                obj.Progress;
            end);
      finally
        Self.UnlockList;
      end;
end;

procedure TProgressPublisher.StartProgress(const aMaxPosition: Integer);
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IProgress;
            begin
              if Supports(Item, IProgress, obj) then
                obj.StartProgress(aMaxPosition);
            end);
      finally
        Self.UnlockList;
      end;
end;

{ TEmailPublisher }

procedure TEmailPublisher.FocusChanged(const aData: PResultData);
var
  Item: TObject;
begin
  if not Application.Terminated then
    for var i := 0 to Self.Count - 1 do
      try
        Item := Self.LockList.Items[i];
        if Assigned(Item) then
          TThread.Queue(nil,
            procedure
            var
              obj: IEmailChange;
            begin
              if Supports(Item, IEmailChange, obj) then
                obj.FocusChanged(aData);
            end);
      finally
        Self.UnlockList;
      end;
end;

initialization
  TPublishers.ProgressPublisher := TProgressPublisher.Create;
  TPublishers.ConfigPublisher   := TConfigPublisher.Create;
  TPublishers.EmailPublisher    := TEmailPublisher.Create;

finalization
  if Assigned(TPublishers.ConfigPublisher) then
    FreeAndNil(TPublishers.ConfigPublisher);
  if Assigned(TPublishers.ProgressPublisher) then
    FreeAndNil(TPublishers.ProgressPublisher);
  if Assigned(TPublishers.EmailPublisher) then
    FreeAndNil(TPublishers.EmailPublisher);

end.
