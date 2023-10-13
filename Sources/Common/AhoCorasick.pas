unit AhoCorasick;

interface

{$REGION 'Region uses'}
uses
  System.Classes, Generics.Collections, Winapi.Windows, System.SysUtils;
{$ENDREGION}

type
  TNode = class
  public
    Next: array [Char] of TNode;
    Fail: TNode;
    Output: TStringList;
    constructor Create;
    destructor Destroy; override;
  end;

  TAhoCorasick = class
  private
    Root: TNode;
  public
    constructor Create;
    destructor Destroy; override;
    function Search(const aText: string): TStringList;
    procedure AddPattern(const aPattern: string);
    procedure Build;
  end;

implementation

{ TNode }

constructor TNode.Create;
begin
  FillChar(Next, SizeOf(Next), 0);
  Fail := nil;
  Output := TStringList.Create;
end;

destructor TNode.Destroy;
var
  Key: Char;
begin
  for Key := Low(Next) to High(Next) do
    if Assigned(Next[Key]) then
      Next[Key].Free;
  FreeAndNil(Output);
  inherited;
end;

{ TAhoCorasick }

constructor TAhoCorasick.Create;
begin
  Root := TNode.Create;
end;

destructor TAhoCorasick.Destroy;
begin
  FreeAndNil(Root);
  inherited;
end;

procedure TAhoCorasick.AddPattern(const aPattern: string);
var
  Node: TNode;
  i: Integer;
begin
  Node := Root;
  for i := 1 to Length(aPattern) do
  begin
    if not Assigned(Node.Next[aPattern[i]]) then
      Node.Next[aPattern[i]] := TNode.Create;
    Node := Node.Next[aPattern[i]];
  end;
  Node.Output.Add(aPattern);
end;

procedure TAhoCorasick.Build;
var
  FailNode: TNode;
  Key: Char;
  NextNode: TNode;
  Node: TNode;
  Queue: TQueue<TNode>;
begin
  Queue := TQueue<TNode>.Create;
  try
    Queue.Enqueue(Root);
    while Queue.Count <> 0 do
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
            NextNode.Fail := Root;
          NextNode.Output.AddStrings(NextNode.Fail.Output);
          Queue.Enqueue(NextNode);
        end;
      end;
    end;
  finally
    Queue.Free;
  end;
end;

function TAhoCorasick.Search(const aText: string): TStringList;
var
  i: Integer;
  NextNode: TNode;
  Node: TNode;
begin
  Result := TStringList.Create;
  Node := Root;
  for i := 1 to Length(aText) do
  begin
    while (Assigned(Node)) and (not Assigned(Node.Next[aText[i]])) do
      Node := Node.Fail;
    if Assigned(Node) then
      Node := Node.Next[aText[i]];
    if not Assigned(Node) then
      Node := Root;
    NextNode := Node;
    while Assigned(NextNode) do
    begin
      if (NextNode.Output.Count > 0) then
        Result.AddStrings(NextNode.Output);
      NextNode := NextNode.Fail;
    end;
  end;
end;

end.
