unit ufrmCadastroPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.JSON,
  System.IOUtils, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.Menus;

type
  TfrmCadastroPessoa = class(TForm)
    lblNome: TLabel;
    edNome: TEdit;
    edSobrenome: TEdit;
    lblSobrenome: TLabel;
    edDocumento: TEdit;
    lblDocumento: TLabel;
    edNatureza: TEdit;
    lblNatureza: TLabel;
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse1: TRESTResponse;
    edCep: TEdit;
    lblCep: TLabel;
    edIdPessoa: TEdit;
    lblIdPessoa: TLabel;
    RESTRequestIntegrador: TRESTRequest;
    RESTLote: TRESTRequest;
    ToolBar1: TToolBar;
    btnSalvar: TButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    btnLote: TButton;
    btnExcluir: TButton;
    btnIntegrador: TButton;
    ToolButton3: TToolButton;
    pnlPesquisa: TPanel;
    edtPesquisar: TEdit;
    Label1: TLabel;
    btnPesquisar: TButton;
    ActionList1: TActionList;
    actSalvar: TAction;
    actExcluir: TAction;
    actCarregarLote: TAction;
    actIntegrar: TAction;
    actPesquisar: TAction;
    edLogradouro: TEdit;
    lblLogradouro: TLabel;
    edBairro: TEdit;
    lblBairro: TLabel;
    edCidade: TEdit;
    lblCidade: TLabel;
    edUF: TEdit;
    lblUF: TLabel;
    procedure GetPessoa(const AId: System.String);
    function ValidaCampos: System.Boolean;
    function ValidaCEP(ACEP: String): System.Boolean;
    function RemoveAspasDuplas(const ATexto: System.String): System.String;
    procedure LimparCampos;
    procedure actSalvarExecute(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
    procedure actCarregarLoteExecute(Sender: TObject);
    procedure actIntegrarExecute(Sender: TObject);
    procedure actPesquisarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edCepExit(Sender: TObject);
    procedure edCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    function ConsultarCEP(ACEP: string): System.Boolean;
  public
    { Public declarations }
  end;
var
  frmCadastroPessoa: TfrmCadastroPessoa;

implementation

{$R *.dfm}

uses uFuncoes;

procedure TfrmCadastroPessoa.actCarregarLoteExecute(Sender: TObject);
var
  FileName: TFileName;
  JSONValue: TJSONArray;
  dlg: TOpenDialog;
  ttyObj: TJSONObject;
begin
  dlg := TOpenDialog.Create(nil);

  try
    dlg.Filter := 'All files (*.*)|*.*';
    if dlg.Execute(Handle) then
      FileName := dlg.FileName;
  finally
    dlg.Free;
  end;

  if FileName <> EmptyStr then
  begin
    JSONValue := TJSONObject.ParseJSONValue(TFile.ReadAllText(FileName)) as TJsonArray;
    RESTClient.ContentType := 'application/json';
    RESTLote.Body.ClearBody;
    RESTLote.AddBody(JSONValue);
    RESTLote.ExecuteAsync(
      procedure
      begin
        ttyObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
        try
          if (RESTResponse1.StatusCode = 200) then
          begin
            MessageInfo(ttyObj.Values['message'].ToString);
          end
          else
          if (RESTResponse1.StatusCode = 500) then
          begin
            MessageErro('Erro ao registrar lote.' + ttyObj.Values['message'].ToString);
          end;
        finally
          ttyObj.Free;
        end;
      end
    );
  end;
end;

procedure TfrmCadastroPessoa.actExcluirExecute(Sender: TObject);
var
  ttyObj: TJSONObject;
begin
  if (edIdPessoa.Text = EmptyStr) then
  begin
    MessageInfo('Pequise uma pessoa antes de excluir.');
    exit;
  end;

  if MessageQuestion('Deseja realmente excluir este registro?') = mrYes then
  begin
    RESTRequest.Params.AddItem('idpessoa', edIdPessoa.Text);
    RESTRequest.Method := TRESTRequestMethod.rmDELETE;
    RESTRequest.ExecuteAsync(
      procedure
      begin
        ttyObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
        if (RESTResponse1.StatusCode = 200) then
        begin
          MessageInfo(ttyObj.Values['message'].ToString);
          LimparCampos();
        end
        else
        if (RESTResponse1.StatusCode = 501) then
        begin
          MessageErro('Erro ao excluir o registro.' + ttyObj.Values['message'].ToString);
        end;
      end
    );
    RESTRequest.Params.Clear;
  end;
  LimparCampos;
end;

procedure TfrmCadastroPessoa.actIntegrarExecute(Sender: TObject);
var
  ttyObj: TJSONObject;
begin
  RESTRequestIntegrador.Method := TRESTRequestMethod.rmGET;
  RESTRequestIntegrador.ExecuteAsync(
    procedure
    begin
      ttyObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
      if (RESTResponse1.StatusCode = 200) then
      begin
        MessageInfo(ttyObj.Values['message'].ToString);
      end
      else
      if (RESTResponse1.StatusCode = 501) then
      begin
        MessageErro(ttyObj.Values['message'].ToString);
      end;
    end
  );
end;

procedure TfrmCadastroPessoa.actPesquisarExecute(Sender: TObject);
begin
  GetPessoa(edtPesquisar.Text);
end;

procedure TfrmCadastroPessoa.actSalvarExecute(Sender: TObject);
var
  ttyObj: TJSONObject;
begin
  if ValidaCampos then
    Exit;

  if ValidaCEP(edCep.Text) then
    exit;

  RESTRequest.Params.AddItem('flnatureza', edNatureza.Text);
  RESTRequest.Params.AddItem('dsdocumento', edDocumento.Text);
  RESTRequest.Params.AddItem('nmprimeiro', edNome.Text);
  RESTRequest.Params.AddItem('nmsegundo', edSobrenome.Text);
  RESTRequest.Params.AddItem('dscep', edCep.Text);

  if(edIdPessoa.Text <> EmptyStr) then
  begin
    RESTRequest.Params.AddItem('idpessoa', edIdPessoa.Text);
    RESTRequest.Method := TRESTRequestMethod.rmPATCH;
  end
  else
  begin
    RESTRequest.Method := TRESTRequestMethod.rmPOST;
  end;
  RESTRequest.Execute;
  RESTRequest.Params.Clear;

  ttyObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  try
    if Assigned(ttyObj) then
    begin
      MessageInfo(ttyObj.Values['message'].ToString);
    end;
  finally
     ttyObj.Free;
  end;

  LimparCampos();
end;

procedure TfrmCadastroPessoa.FormCreate(Sender: TObject);
begin
  frmCadastroPessoa.Height := 310;
  frmCadastroPessoa.Width := 380;
end;

procedure TfrmCadastroPessoa.GetPessoa(const AId: System.String);
var
  ttyObj: TJSONObject;
begin
  if AId = EmptyStr then
    exit;

  RESTRequest.Params.AddItem('idpessoa', AId);
  RESTRequest.Method := TRESTRequestMethod.rmGET;
  RESTRequest.Execute;
  RESTRequest.Params.Clear;
  ttyObj := TJSONObject.ParseJSONValue(RESTResponse1.Content) as TJSONObject;
  try
    if (RESTResponse1.StatusCode = 404) then
    begin
      MessageWarning('Cadastro não encontrado');
    end
    else
    begin
      edIdPessoa.Text := RemoveAspasDuplas(ttyObj.Values['idpessoa'].ToString);
      edNome.Text := RemoveAspasDuplas(ttyObj.Values['nmprimeiro'].ToString);
      edSobrenome.Text := RemoveAspasDuplas(ttyObj.Values['nmsegundo'].ToString);
      edDocumento.Text := RemoveAspasDuplas(ttyObj.Values['dsdocumento'].ToString);
      edNatureza.Text := RemoveAspasDuplas(ttyObj.Values['flnatureza'].ToString);
      edCep.Text := RemoveAspasDuplas(ttyObj.Values['dscep'].ToString);
    end;
  finally
    ttyObj.Free;
  end;
end;

procedure TfrmCadastroPessoa.LimparCampos;
var
  Contador: System.Integer;
begin
  for Contador := 0 to ComponentCount - 1 do
  begin
    if Components[Contador].ClassType = TEdit then
      if (TEdit(Components[Contador]).Text <> EmptyStr) then
      begin
        TEdit(Components[Contador]).Text := EmptyStr;
      end;
  end;
end;

function TfrmCadastroPessoa.RemoveAspasDuplas(const ATexto: System.String): System.String;
begin
  Result := StringReplace(ATexto , '"', EmptyStr, [rfReplaceAll]);
end;

function TfrmCadastroPessoa.ValidaCampos: System.Boolean;
var
  Contador: System.Integer;
begin
  Result := False;
  for Contador := 0 to ComponentCount - 1 do
  begin
    if (Components[Contador].ClassType = TEdit) then
    begin
      if ((TEdit(Components[Contador]).Text = EmptyStr) and (TEdit(Components[Contador]).Enabled) and
         (TEdit(Components[Contador]).Tag = 0)) then
      begin
        Result := True;
        TEdit(Components[Contador]).TextHint := 'Campo Obrigatório*';
      end
      else
      begin
        TEdit(Components[Contador]).TextHint := EmptyStr;
      end;
    end;
  end;
end;

function TfrmCadastroPessoa.ValidaCEP(ACEP: String): System.Boolean;
begin
  if (ACEP <> EmptyStr) and (edLogradouro.Text <> EmptyStr) then
    Result := False
  else
    Result := not ConsultarCEP(ACEP);
end;

function TfrmCadastroPessoa.ConsultarCEP(ACEP: string): System.Boolean;
var
  data: TJSONObject;
  RESTClient1: TRESTClient;
  RESTRequest1: TRESTRequest;
  RESTResponse1: TRESTResponse;
  bErro: Boolean;
begin
  bErro := False;

  ACEP := Trim(ACEP);
  ACEP := StringReplace(ACEP, '-', EmptyStr, [rfReplaceAll]);

  if Length(ACEP) <> 8 then
  begin
    Result := True;
    Exit;
  end;

  RESTClient1 := TRESTClient.Create(nil);
  RESTRequest1 := TRESTRequest.Create(nil);
  RESTResponse1 := TRESTResponse.Create(nil);
  RESTRequest1.Client := RESTClient1;
  RESTRequest1.Response := RESTResponse1;
  RESTClient1.BaseURL := 'https://viacep.com.br/ws/' + ACEP + '/json';
  RESTRequest1.Execute;
  data := RESTResponse1.JSONValue as TJSONObject;

  try
    if Assigned(data) then
    begin
        try
          edlogradouro.Text := data.Values['logradouro'].Value;
        except
          on Exception do
          begin
            edlogradouro.Clear;
            bErro := SameText(data.Values['erro'].Value, 'true');
          end;
        end;

        try
          edBairro.Text := data.Values['bairro'].Value;
        except
          on Exception do
          begin
            edBairro.Clear;
            bErro := SameText(data.Values['erro'].Value, 'true');
          end;
        end;

        try
          edCidade.Text := data.Values['localidade'].Value;
        except
          on Exception do
          begin
            edCidade.Clear;
            bErro := SameText(data.Values['erro'].Value, 'true');
          end;
        end;

        try
          edUF.Text := data.Values['uf'].Value;
        except
          on Exception do
          begin
             edUF.Clear;
             bErro := SameText(data.Values['erro'].Value, 'true');
          end;
        end;
      end;
  finally
    FreeAndNil(data);
  end;

  Result := bErro;
end;

procedure TfrmCadastroPessoa.edCepExit(Sender: TObject);
begin
  if edCep.Text <> EmptyStr then
  begin
      if ConsultarCEP(edCep.Text) then
      begin
        MessageWarning('CEP inválido!');
        if edCep.CanFocus then
          edCep.SetFocus;

        edCep.SelectAll;
      end;
  end;
end;

procedure TfrmCadastroPessoa.edCepKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    edCepExit(Sender);
  end;
end;

end.
