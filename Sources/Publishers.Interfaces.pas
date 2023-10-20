unit Publishers.Interfaces;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Generics.Collections, System.Generics.Defaults,
  Winapi.Messages, Common.Types, Global.Types;
{$ENDREGION}

type
  IConfig = interface
    ['{8CB90EEC-FA3A-40EA-B04F-84A104F282B2}']
    procedure UpdateRegExp;
    procedure UpdateFilter(const aOperation: TFilterOperation);
    procedure UpdateLanguage;
    procedure UpdateProject;
  end;

  IProgress = interface
    ['{41337754-3054-48D3-B8B7-42574B6586E9}']
    procedure EndProgress;
    procedure StartProgress(const aMaxPosition: Integer);
    procedure Progress;
    procedure CompletedItem(const aData: PResultData);
    procedure CompletedAttach(const aAttachment: PAttachment);
    procedure ClearTree;
  end;

  IEmailChange = interface
    ['{25917581-2499-4D63-9C42-287C539841CE}']
    procedure FocusChanged(const aData: PResultData);
  end;

  ITranslate = interface
    ['{7BACF2F8-0FCA-4FF2-8095-81542FDEFE70}']

  end;

implementation

end.
