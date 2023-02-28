program WKServer;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Types,
  IPPeerServer,
  IPPeerAPI,
  IdHTTPWebBrokerBridge,
  Web.WebReq,
  Web.WebBroker,
  uwdmPrincipal in 'uwdmPrincipal.pas' {wdmPrincipal: TWebModule},
  udaoEndereco in 'model\udaoEndereco.pas',
  udaoEnderecoIntegracao in 'model\udaoEnderecoIntegracao.pas',
  udaoPessoa in 'model\udaoPessoa.pas',
  udtoEndereco in 'model\udtoEndereco.pas',
  udtoEnderecoIntegracao in 'model\udtoEnderecoIntegracao.pas',
  udtoPessoa in 'model\udtoPessoa.pas',
  uJsonObject in 'model\uJsonObject.pas',
  uConstantes in '..\Util\uConstantes.pas',
  uFuncoes in '..\Util\uFuncoes.pas';

{$R *.res}

function BindPort(APort: Integer): Boolean;
var
  LTestServer: IIPTestServer;
begin
  Result := True;
  try
    LTestServer := PeerFactory.CreatePeer(EmptyStr, IIPTestServer) as IIPTestServer;
    LTestServer.TestOpenPort(APort, nil);
  except
    Result := False;
  end;
end;

function CheckPort(APort: Integer): Integer;
begin
  if BindPort(APort) then
    Result := APort
  else
    Result := 0;
end;

procedure SetPort(const AServer: TIdHTTPWebBrokerBridge; APort: String);
begin
  if not AServer.Active then
  begin
    APort := APort.Replace(cstCommandSetPort, EmptyStr).Trim;
    if CheckPort(APort.ToInteger) > 0 then
    begin
      AServer.DefaultPort := APort.ToInteger;
      Writeln(Format(sPortSet, [APort]));
    end
    else
      Writeln(Format(sPortInUse, [APort]));
  end
  else
    Writeln(sServerRunning);
  Write(cstArrow);
end;

procedure StartServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if not AServer.Active then
  begin
    if CheckPort(AServer.DefaultPort) > 0 then
    begin
      Writeln(Format(sStartingServer, [AServer.DefaultPort]));
      AServer.Bindings.Clear;
      AServer.Active := True;
    end
    else
      Writeln(Format(sPortInUse, [AServer.DefaultPort.ToString]));
  end
  else
    Writeln(sServerRunning);
  Write(cstArrow);
end;

procedure StopServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if AServer.Active then
  begin
    Writeln(sStoppingServer);
    AServer.Active := False;
    AServer.Bindings.Clear;
    Writeln(sServerStopped);
  end
  else
    Writeln(sServerNotRunning);
  Write(cstArrow);
end;

procedure WriteCommands;
begin
  Writeln(sCommands);
  Write(cstArrow);
end;

procedure WriteStatus(const AServer: TIdHTTPWebBrokerBridge);
begin
  Writeln(sIndyVersion + AServer.SessionList.Version);
  Writeln(sActive + AServer.Active.ToString(TUseBoolStrs.True));
  Writeln(sPort + AServer.DefaultPort.ToString);
  Writeln(sSessionID + AServer.SessionIDCookieName);
  Write(cstArrow);
end;

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LResponse: string;
begin
  WriteCommands;
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.DefaultPort := APort;
    while True do
    begin
      Readln(LResponse);
      LResponse := LowerCase(LResponse);
      if LResponse.StartsWith(cstCommandSetPort) then
        SetPort(LServer, LResponse)
      else if sametext(LResponse, cstCommandStart) then
        StartServer(LServer)
      else if sametext(LResponse, cstCommandStatus) then
        WriteStatus(LServer)
      else if sametext(LResponse, cstCommandStop) then
        StopServer(LServer)
      else if sametext(LResponse, cstCommandHelp) then
        WriteCommands
      else if sametext(LResponse, cstCommandExit) then
        if LServer.Active then
        begin
          StopServer(LServer);
          break
        end
        else
          break
      else
      begin
        Writeln(sInvalidCommand);
        Write(cstArrow);
      end;
    end;
  finally
    LServer.Free;
  end;
end;

begin
  try
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
    RunServer(8000);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.
