unit RegExp.Utils;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Buttons, Vcl.DBGrids, Vcl.Mask, System.UITypes, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF}
  VirtualTrees, DebugWriter, Html.Lib, Column.Types, Global.Types, CommonForms, VirtualTrees.Helper, System.Types,
  DaImages, XmlFiles, Common.Types, System.Generics.Collections, System.Generics.Defaults, Winapi.msxml,
  Translate.Lang, Global.Resources, Vcl.ToolWin, Vcl.ComCtrls, ArrayHelper;
{$ENDREGION}

type
  TRegExpUtils = class
  public
    class function SaveSetOfTemplate(const aTree: TVirtualStringTree; const aSection, aName: string): string;
    class procedure RestoreSetOfTemplate(const aXmlFile: TXmlFile; const aTree: TVirtualStringTree; const aSection: string);
  end;

implementation

class procedure TRegExpUtils.RestoreSetOfTemplate(const aXmlFile: TXmlFile; const aTree: TVirtualStringTree; const aSection: string);
var
  Data: PRegExpData;
  Node: PVirtualNode;
begin
  aXmlFile.Open;
  aXmlFile.CurrentSection := aXmlFile.GetXPath(C_SECTION_TEMPLATE_SETS, aSection);
  aTree.BeginUpdate;
  try
    aTree.Clear;
    while not aXmlFile.IsLastKey do
    begin
      if aXmlFile.ReadAttributes then
      begin
        Node := aTree.AddChild(nil);
        Data := Node.GetData;
        Data^.ParameterName  := aXmlFile.Attributes.GetAttributeValue('ParameterName', '');
        Data^.RegExpTemplate := aXmlFile.Attributes.GetAttributeValue('RegExpTemplate', '');
        Data^.GroupIndex     := aXmlFile.Attributes.GetAttributeValue('GroupIndex', 0);
        Data^.UseRawText     := aXmlFile.Attributes.GetAttributeValue('UseRawText', False);
        aTree.CheckType[Node] := ctCheckBox;
        if Data^.UseRawText then
          Node.CheckState := csCheckedNormal
        else
          Node.CheckState := csUnCheckedNormal;
      end;
      aXmlFile.NextKey;
    end;
  finally
    aXmlFile.CurrentSection := '';
    aTree.EndUpdate;
  end;
end;

class function TRegExpUtils.SaveSetOfTemplate(const aTree: TVirtualStringTree; const aSection, aName: string): string;

 procedure SaveNode(const aXmlNode: IXMLDOMNode; const aTreeNode: PVirtualNode);
  var
    Data: PRegExpData;
  begin
    if Assigned(aXmlNode) and Assigned(aTreeNode) then
    begin
      Data := aTreeNode^.GetData;
      with TGeneral.XMLParams do
      begin
        Attributes.Node := aXmlNode;
        Attributes.SetAttributeValue('ParameterName', Data^.ParameterName);
        Attributes.SetAttributeValue('RegExpTemplate', Data^.RegExpTemplate);
        Attributes.SetAttributeValue('GroupIndex', Data^.GroupIndex);
        Attributes.SetAttributeValue('UseRawText', Data^.UseRawText);
        WriteAttributes;
      end;
    end;
  end;

var
  iItemNode : IXMLDOMNode;
  iSetNode  : IXMLDOMNode;
  NewSet    : string;
  TreeNode  : PVirtualNode;
begin
  if aSection.IsEmpty then
    NewSet := 'Set.' + TGeneral.GetCounterValue.ToString
  else
    NewSet := aSection;
  Result := NewSet;

  TGeneral.XMLParams.Open;
  try
    iSetNode := TGeneral.XMLParams.GetNode(TGeneral.XMLParams.GetXPath(C_SECTION_TEMPLATE_SETS, NewSet));
    if aSection.IsEmpty then
      with TGeneral.XMLParams do
      begin
        Attributes.Node := iSetNode;
        Attributes.SetAttributeValue('Name', aName);
        WriteAttributes;
      end
    else
      TGeneral.XMLParams.EraseSection(TGeneral.XMLParams.GetXPath(C_SECTION_TEMPLATE_SETS, NewSet));

    TreeNode := aTree.GetFirst;
    while Assigned(TreeNode) do
    begin
      iItemNode := TGeneral.XMLParams.XMLDomDocument.createNode(varNull, 'Item', '');
      iSetNode.appendChild(iItemNode);
      SaveNode(iItemNode, TreeNode);
      TreeNode := TreeNode.NextSibling;
    end;
  finally
    TGeneral.XMLParams.CurrentSection := '';
    TGeneral.XMLParams.Save;
  end;
end;

end.
