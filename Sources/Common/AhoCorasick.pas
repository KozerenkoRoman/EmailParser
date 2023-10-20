unit AhoCorasick;

interface

{$REGION 'Region uses'}
uses
  System.Classes, Generics.Collections, Winapi.Windows, System.SysUtils;
{$ENDREGION}

type
  TAppender<T> = class
    class procedure AddItem(var Arr: TArray<T>; const Value: T);
    class procedure AddRange(var Arr: TArray<T>; const Value: TArray<T>);
  end;

  PNode = ^TNode;
  TNode = record
  public
    Fail: PNode;
    Next: array [AnsiChar] of PNode;
    Output: TArray<string>;
  end;

  TAhoCorasick = class
  private
    Root: TNode;
  public
    constructor Create;
    destructor Destroy; override;
    function Search(const aText: string): TArray<string>;
    procedure AddPattern(const aPattern: string);
    procedure Build;
  end;

implementation

{ TAppender<T> }

class procedure TAppender<T>.AddItem(var Arr: TArray<T>; const Value: T);
begin
  SetLength(Arr, Length(Arr) + 1);
  Arr[High(Arr)] := Value;
end;

class procedure TAppender<T>.AddRange(var Arr: TArray<T>; const Value: TArray<T>);
var
  Index: Integer;
begin
  Index := Length(Arr);
  SetLength(Arr, Length(Arr) + Length(Value));
  for var i := Low(Value) to High(Value) do
    Arr[Index + i] := Value[i];
end;

{ TAhoCorasick }

constructor TAhoCorasick.Create;
begin

end;

destructor TAhoCorasick.Destroy;
var
  Node: PNode;
  Stack: TStack<PNode>;
begin
  Stack := TStack<PNode>.Create;
  try
    Stack.Push(@Root);
    while Stack.Count > 0 do
    begin
      Node := Stack.Pop;
      for var i := Low(Node.Next) to High(Node.Next) do
        if Assigned(Node.Next[i]) then
          Stack.Push(Node.Next[i]);
      if Assigned(Node) and (Node <> @Root) then
        Dispose(Node);
    end;
  finally
    FreeAndNil(Stack);
  end;
  inherited Destroy;
end;

procedure TAhoCorasick.AddPattern(const aPattern: string);
var
  AnsiTextBuf: TBytes;
  NextNode:PNode;
  Node: PNode;
begin
  Node := @Root;
  AnsiTextBuf := TEncoding.ASCII.GetBytes(aPattern);
  for var i := Low(AnsiTextBuf) to High(AnsiTextBuf) do
  begin
    if not Assigned(Node.Next[AnsiChar(AnsiTextBuf[i])]) then
    begin
      New(NextNode);
      FillChar(NextNode^.Next, SizeOf(NextNode^.Next), 0);
      Node.Next[AnsiChar(AnsiTextBuf[i])] := NextNode;
    end;
    Node := Node.Next[AnsiChar(AnsiTextBuf[i])];
  end;
  TAppender<string>.AddItem(Node.Output, aPattern);
end;

procedure TAhoCorasick.Build;
var
  FailNode: PNode;
  Key: AnsiChar;
  NextNode: PNode;
  Node: PNode;
  Queue: TQueue<PNode>;
begin
  Queue := TQueue<PNode>.Create;
  try
    Queue.Enqueue(@Root);
    while (Queue.Count <> 0) do
    begin
      Node := Queue.Dequeue;
      for Key := Low(Node.Next) to High(Node.Next) do
      begin
        NextNode := Node.Next[Key];
        FailNode := Node.Fail;
        while (Assigned(FailNode)) and (not Assigned(FailNode.Next[Key])) do
          FailNode := FailNode.Fail;
        if Assigned(NextNode) then
        begin
          if Assigned(FailNode) then
            NextNode.Fail := FailNode.Next[Key]
          else
            NextNode.Fail := @Root;
          TAppender<string>.AddRange(Node.Output, NextNode.Fail.Output);
          Queue.Enqueue(NextNode);
        end;
      end;
    end;
  finally
    Queue.Free;
  end;
end;

function TAhoCorasick.Search(const aText: string): TArray<string>;
var
  AnsiTextBuf: TBytes;
  NextNode: PNode;
  Node: PNode;
begin
  Node := @Root;
  AnsiTextBuf := TEncoding.ASCII.GetBytes(aText);
  for var i := Low(AnsiTextBuf) to High(AnsiTextBuf) do
  begin
    while (Assigned(Node)) and (not Assigned(Node.Next[AnsiChar(AnsiTextBuf[i])])) do
      Node := Node.Fail;
    if Assigned(Node) then
      Node := Node.Next[AnsiChar(AnsiTextBuf[i])];
    if not Assigned(Node) then
      Node := @Root;
    NextNode := Node;
    while Assigned(NextNode) do
    begin
      if (Length(NextNode.Output) > 0) then
        TAppender<string>.AddRange(Result, NextNode.Output);
      NextNode := NextNode.Fail;
    end;
  end;
end;

end.
