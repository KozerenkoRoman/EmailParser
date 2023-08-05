{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSocketUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils,
{$ENDIF}
  clUtils;

type
  EclSocketError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

procedure RaiseSocketError(AErrorCode: Integer); overload;
procedure RaiseSocketError(const AErrorMessage: string; AErrorCode: Integer); overload;

resourcestring
  TimeoutOccurred = 'Timeout error occured';
  InvalidAddress = 'Invalid host address';
  InvalidPort = 'Invalid port number';
  InvalidBatchSize = 'Invalid Batch Size';
  InvalidNetworkStream = 'NetworkStream is required';
  ConnectionClosed = 'The connection to the server is not active';
  InvalidAddressFamily = 'Invalid address family';

const
  TimeoutOccurredCode = -1;
  InvalidAddressCode = -2;
  InvalidPortCode = -3;
  InvalidBatchSizeCode = -4;
  InvalidNetworkStreamCode = -5;
  ConnectionClosedCode = -6;
  InvalidAddressFamilyCode = -7;

implementation

procedure RaiseSocketError(AErrorCode: Integer);
begin
  raise EclSocketError.Create(GetErrorText(AErrorCode), AErrorCode);
end;

procedure RaiseSocketError(const AErrorMessage: string; AErrorCode: Integer);
begin
  raise EclSocketError.Create(AErrorMessage, AErrorCode);
end;

{ EclSocketError }

constructor EclSocketError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.
