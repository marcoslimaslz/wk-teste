program WKClient;
uses
  Vcl.Forms,
  ufrmCadastroPessoa in 'View\ufrmCadastroPessoa.pas' {frmCadastroPessoa},
  uFuncoes in '..\Util\uFuncoes.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmCadastroPessoa, frmCadastroPessoa);
  Application.Run;
end.
