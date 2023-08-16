unit Performer.Interfaces;

interface

{$REGION 'Region uses'}
uses
  Winapi.Windows, System.SysUtils, System.Classes;
{$ENDREGION}

type
  TAbortEvent = function: Boolean of object;
  TEndEvent = procedure of object;
  TProgressEvent = procedure of object;
  TStartProgressEvent = procedure(const aMaxPosition: Integer) of object;

  IProgress = interface
    ['{4B75DE9A-B825-487C-B6CA-479B40FB815D}']
    procedure DoEndEvent;
    procedure DoStartProgressEvent(const aMaxPosition: Integer);
    procedure DoProgressEvent;
  end;

implementation

end.

