unit uwdmPrincipal;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, udaoPessoa, uDTOPessoa,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Comp.UI, REST.JSON, System.JSON,
  uThreadEnderecos, System.Generics.Collections;

type
  TwdmPrincipal = class(TWebModule)
    fdcConexao: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure wdmPrincipalDefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalPOSTPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalGETPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalDELETEPessoaAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalPATCHPessoaAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalExecutaIntegradorAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure wdmPrincipalPessoasLoteAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TwdmPrincipal;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TwdmPrincipal.wdmPrincipalDefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content :=
    '<html>' +
    '<head><title>Web Server Application</title></head>' +
    '<body>Web Server Application</body>' +
    '</html>';
end;

function AtualizarEndereco: Boolean;
var
  NewThread: TCepIntegracao;
begin
  NewThread := TCepIntegracao.Create(false);
  NewThread.FreeOnTerminate := True;
  while not(NewThread.Finished) do
  begin
    result := NewThread.Finished;
  end;
  result := NewThread.Finished;
end;

procedure TwdmPrincipal.wdmPrincipalDELETEPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ttyDAOPessoa: TDAOPessoa;
  ttyDTOPessoa: TDTOPessoa;
  LIdPessoa: System.Integer;
begin
  LIdPessoa := Request.QueryFields.Values['idpessoa'].ToInteger;
  ttyDTOPessoa := TDTOPessoa.Create();
  ttyDAOPessoa := TDAOPessoa.Create(fdcConexao);
  try
    try 
      ttyDAOPessoa.SafeDelete(LIdPessoa);
      Response.StatusCode := 200;
      Response.Content := '{"message": "Registro excluido com sucesso."}';
    except
      on e: Exception do
      begin
        Response.StatusCode := 501;
        Response.Content := '{"message": "Erro ao excluir o  recurso." erro: "'+e.Message+'"}';
      end;       
    end;              
  finally
    ttyDTOPessoa.Free;
    ttyDAOPessoa.Free;
  end;
end;

procedure TwdmPrincipal.wdmPrincipalExecutaIntegradorAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  try
    if AtualizarEndereco then
    begin
      Response.StatusCode := 200;
      Response.Content := '{"message": "Integrador executado com sucesso."}';
    end;
  except
    on e:Exception do
    begin
      Response.StatusCode := 501;
      Response.Content := '{"message": "Erro ao executar o integrador", messageErro: "'+e.Message+'"}';
    end;
  end;
end;

procedure TwdmPrincipal.wdmPrincipalGETPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ttyDAOPessoa: TDAOPessoa;
  ttyDTOPessoa: TDTOPessoa;
  LIdPessoa: System.Integer;
begin
  ttyDTOPessoa := TDTOPessoa.Create();
  ttyDAOPessoa := TDAOPessoa.Create(fdcConexao);
  LIdPessoa := Request.QueryFields.Values['idpessoa'].ToInteger;
  try
    if (ttyDAOPessoa.Load(ttyDTOPessoa, LIdPessoa)) then
    begin
      Response.StatusCode := 200;
      Response.Content := TJson.ObjectToJsonString(ttyDTOPessoa);
    end else
    begin
      Response.StatusCode := 404;
      Response.Content := '{"message": "Pessoa não encontrada com o Id informado."}';
    end;
  finally
    ttyDTOPessoa.Free;
    ttyDAOPessoa.Free;
  end;
end;

procedure TwdmPrincipal.wdmPrincipalPATCHPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ttyDAOPessoa: TDAOPessoa;
  ttyDTOPessoa: TDTOPessoa;
begin
  ttyDTOPessoa := TDTOPessoa.Create();
  ttyDAOPessoa := TDAOPessoa.Create(fdcConexao);
  try
    ttyDTOPessoa.idpessoa := Request.ContentFields.Values['idpessoa'].ToInteger;
    ttyDTOPessoa.flnatureza := Request.ContentFields.Values['flnatureza'].ToInteger;
    ttyDTOPessoa.dsdocumento := Request.ContentFields.Values['dsdocumento'];
    ttyDTOPessoa.nmprimeiro := Request.ContentFields.Values['nmprimeiro'];
    ttyDTOPessoa.nmsegundo := Request.ContentFields.Values['nmsegundo'];
    ttyDTOPessoa.dscep := Request.ContentFields.Values['dscep'];
    try
      ttyDAOPessoa.Save(ttyDTOPessoa);
    except
      Response.StatusCode := 500;
      Response.Content := '{"message": "Erro ao atualizar registro."}';
      exit;
    end;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Registro atualizado com suscesso."}'
  finally
    ttyDTOPessoa.Free;
    ttyDAOPessoa.Free;
  end;
end;

procedure TwdmPrincipal.wdmPrincipalPessoasLoteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ttyDTOPessoa: TDTOPessoa;
  ttyDAOPessoa: TDAOPessoa;
  sJObjetoElement: TJSONObject;
  JSonValueElement: TJSONArray;
  ArrayElement: TJSonValue;
  JsonArrayElement: TJSONArray;
  sjsonString: TJSonValue;
  sjsonValue: TJSonValue;
  i: Integer;
begin
  ttyDTOPessoa := TDTOPessoa.Create;
  ttyDAOPessoa := TDAOPessoa.Create(fdcConexao);

  sJObjetoElement := TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
  JSonValueElement := sJObjetoElement.FindValue('elements') as TJSONArray;
  JsonArrayElement := JSonValueElement.Items[0].FindValue('members') as TJSONArray;

  try
    for i := 0 to Pred(JSonValueElement.Count) do
    begin
      JsonArrayElement := JSonValueElement.Items[i].FindValue('members') as TJSONArray;

      for ArrayElement in JsonArrayElement do
      begin
        sjsonString := ArrayElement.FindValue('jsonString');
        sjsonValue := ArrayElement.FindValue('jsonValue');

        if sjsonString.FindValue('value').Value = 'flnatureza' then
        begin
          ttyDTOPessoa.flnatureza := sjsonValue.FindValue('value').Value.ToInteger;
        end else if sjsonString.FindValue('value').Value = 'dsdocumento' then
        begin
          ttyDTOPessoa.dsdocumento := sjsonValue.FindValue('value').Value;
        end else if sjsonString.FindValue('value').Value = 'nmprimeiro' then
        begin
          ttyDTOPessoa.nmprimeiro := sjsonValue.FindValue('value').Value;
        end else if sjsonString.FindValue('value').Value = 'nmsegundo' then
        begin
          ttyDTOPessoa.nmsegundo := sjsonValue.FindValue('value').Value;
        end else if sjsonString.FindValue('value').Value = 'dscep' then
        begin
          ttyDTOPessoa.dscep := sjsonValue.FindValue('value').Value;
        end;
      end;

      try
        ttyDTOPessoa.dtregistro := Now;
        ttyDAOPessoa.Save(ttyDTOPessoa);
      finally
        ttyDTOPessoa.Clear;
      end;
    end;
  finally
    ttyDAOPessoa.Free;
    ttyDTOPessoa.Free;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Lote cadastrado com suscesso."}'
  end;
end;

procedure TwdmPrincipal.wdmPrincipalPOSTPessoaAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  ttyDAOPessoa: TDAOPessoa;
  ttyDTOPessoa: TDTOPessoa;
begin
  ttyDTOPessoa := TDTOPessoa.Create();
  ttyDAOPessoa := TDAOPessoa.Create(fdcConexao);
  try
    ttyDTOPessoa.flnatureza := Request.ContentFields.Values['flnatureza'].ToInteger;
    ttyDTOPessoa.dsdocumento := Request.ContentFields.Values['dsdocumento'];
    ttyDTOPessoa.nmprimeiro := Request.ContentFields.Values['nmprimeiro'];
    ttyDTOPessoa.nmsegundo := Request.ContentFields.Values['nmsegundo'];
    ttyDTOPessoa.dscep := Request.ContentFields.Values['dscep'];
    ttyDTOPessoa.dtregistro := Now;
    try
      ttyDAOPessoa.Save(ttyDTOPessoa);
    except
      Response.StatusCode := 501;
      Response.Content := '{"message": "Erro ao cadastrar pessoa."}';
      exit;
    end;
    Response.StatusCode := 201;
    Response.Content := '{"message": "Pessoa cadastrada com suscesso."}'
  finally
    ttyDTOPessoa.Free;
    ttyDAOPessoa.Free;
  end;
end;

end.
