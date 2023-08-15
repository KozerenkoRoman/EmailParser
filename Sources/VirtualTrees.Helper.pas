unit VirtualTrees.Helper;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, DebugWriter, {$IFDEF USE_CODE_SITE}CodeSiteLogging, {$ENDIF}
  CustomForms, HtmlLib, VirtualTrees, DaImages, HtmlConsts, System.StrUtils, Utils, System.Generics.Defaults,
  System.Generics.Collections, System.DateUtils, System.UITypes;
{$ENDREGION}

type
  TVirtualTree = class
  public
    class procedure Initialize(Sender: TVirtualStringTree);
  end;

implementation

{ TVirtualTree }

class procedure TVirtualTree.Initialize(Sender: TVirtualStringTree);
begin
  Sender.CheckImageKind    := ckCustom;
  Sender.CustomCheckImages := DMImage.ilCustomCheckImages;
  Sender.Colors.FocusedSelectionColor   := clWebLightSteelBlue;
  Sender.Colors.GridLineColor           := clSilver;
  Sender.Colors.SelectionTextColor      := clBlack;
  Sender.Colors.UnfocusedSelectionColor := clWebLightSteelBlue;
  Sender.TextMargin := 2;
  Sender.Header.Height      := 17;
  Sender.Header.MinHeight   := 17;
  Sender.Header.Font.Height := -13;
  Sender.Header.Options     := [hoColumnResize, hoDblClickResize, hoDrag, hoShowHint, hoShowImages, hoShowSortGlyphs, hoVisible, hoHeaderClickAutoSort];
  Sender.TreeOptions.AutoOptions      := Sender.TreeOptions.AutoOptions + [toAutoDropExpand, toAutoExpand, toAutoTristateTracking, toAutoChangeScale];
  Sender.TreeOptions.MiscOptions      := Sender.TreeOptions.MiscOptions + [toAcceptOLEDrop, toCheckSupport, {toFullRepaintOnResize,} toGridExtensions, toInitOnSave, toToggleOnDblClick, toWheelPanning, toEditOnClick];
  Sender.TreeOptions.PaintOptions     := Sender.TreeOptions.PaintOptions + [toHideFocusRect, toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware];
  Sender.TreeOptions.SelectionOptions := Sender.TreeOptions.SelectionOptions + [toExtendedFocus, toAlwaysSelectNode] - [toFullRowSelect];
end;

end.
