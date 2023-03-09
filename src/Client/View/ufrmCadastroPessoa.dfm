object frmCadastroPessoa: TfrmCadastroPessoa
  Left = 0
  Top = 0
  Caption = 'WK - Cadastro de pessoas'
  ClientHeight = 482
  ClientWidth = 724
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 13
  object lblNome: TLabel
    Left = 90
    Top = 80
    Width = 34
    Height = 13
    Caption = 'Nome: '
  end
  object lblSobrenome: TLabel
    Left = 220
    Top = 80
    Width = 58
    Height = 13
    Caption = 'Sobrenome:'
  end
  object lblDocumento: TLabel
    Left = 10
    Top = 130
    Width = 58
    Height = 13
    Caption = 'Documento:'
  end
  object lblNatureza: TLabel
    Left = 145
    Top = 130
    Width = 48
    Height = 13
    Caption = 'Natureza:'
  end
  object lblCep: TLabel
    Left = 262
    Top = 130
    Width = 19
    Height = 13
    Caption = 'Cep'
  end
  object lblIdPessoa: TLabel
    Left = 10
    Top = 80
    Width = 40
    Height = 13
    Caption = 'C'#243'digo: '
  end
  object lblLogradouro: TLabel
    Left = 10
    Top = 180
    Width = 55
    Height = 13
    Caption = 'Logradouro'
  end
  object lblBairro: TLabel
    Left = 220
    Top = 180
    Width = 28
    Height = 13
    Caption = 'Bairro'
  end
  object lblCidade: TLabel
    Left = 10
    Top = 230
    Width = 33
    Height = 13
    Caption = 'Cidade'
  end
  object lblUF: TLabel
    Left = 310
    Top = 230
    Width = 13
    Height = 13
    Caption = 'UF'
  end
  object edNome: TEdit
    Left = 90
    Top = 95
    Width = 125
    Height = 21
    TabOrder = 3
  end
  object edSobrenome: TEdit
    Left = 220
    Top = 95
    Width = 140
    Height = 21
    TabOrder = 4
  end
  object edDocumento: TEdit
    Left = 10
    Top = 145
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edNatureza: TEdit
    Left = 135
    Top = 145
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object edCep: TEdit
    Left = 262
    Top = 145
    Width = 100
    Height = 21
    MaxLength = 9
    TabOrder = 7
    OnExit = edCepExit
    OnKeyDown = edCepKeyDown
  end
  object edIdPessoa: TEdit
    Left = 10
    Top = 95
    Width = 75
    Height = 21
    Color = clBtnFace
    Enabled = False
    NumbersOnly = True
    TabOrder = 2
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 724
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    ExplicitWidth = 720
    object btnSalvar: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Action = actSalvar
      TabOrder = 0
    end
    object ToolButton2: TToolButton
      Left = 75
      Top = 0
      Width = 8
      Caption = 'ToolButton2'
      ImageIndex = 0
      Style = tbsDivider
    end
    object btnExcluir: TButton
      Left = 83
      Top = 0
      Width = 75
      Height = 25
      Action = actExcluir
      TabOrder = 2
    end
    object ToolButton1: TToolButton
      Left = 158
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      Style = tbsDivider
    end
    object btnLote: TButton
      Left = 166
      Top = 0
      Width = 100
      Height = 25
      Action = actCarregarLote
      TabOrder = 1
    end
    object ToolButton3: TToolButton
      Left = 266
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 1
      Style = tbsDivider
    end
    object btnIntegrador: TButton
      Left = 274
      Top = 0
      Width = 75
      Height = 25
      Action = actIntegrar
      TabOrder = 3
    end
  end
  object pnlPesquisa: TPanel
    Left = 0
    Top = 29
    Width = 724
    Height = 40
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 720
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 86
      Height = 13
      Caption = 'Procurar por (ID):'
    end
    object edtPesquisar: TEdit
      Tag = 1
      Left = 110
      Top = 10
      Width = 150
      Height = 21
      Color = clWhite
      NumbersOnly = True
      TabOrder = 0
    end
    object btnPesquisar: TButton
      Left = 270
      Top = 10
      Width = 75
      Height = 25
      Action = actPesquisar
      TabOrder = 1
    end
  end
  object edLogradouro: TEdit
    Left = 10
    Top = 195
    Width = 200
    Height = 21
    Color = clBtnFace
    MaxLength = 9
    ReadOnly = True
    TabOrder = 8
  end
  object edBairro: TEdit
    Left = 220
    Top = 195
    Width = 140
    Height = 21
    ReadOnly = True
    TabOrder = 9
  end
  object edCidade: TEdit
    Left = 10
    Top = 245
    Width = 290
    Height = 21
    ReadOnly = True
    TabOrder = 10
  end
  object edUF: TEdit
    Left = 310
    Top = 245
    Width = 50
    Height = 21
    ReadOnly = True
    TabOrder = 11
  end
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8000'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <>
    SynchronizedEvents = False
    Left = 376
    Top = 344
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Resource = 'pessoa'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 312
    Top = 296
  end
  object RESTResponse1: TRESTResponse
    Left = 416
    Top = 248
  end
  object RESTRequestIntegrador: TRESTRequest
    AssignedValues = [rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'endereco_integracao'
    Response = RESTResponse1
    ReadTimeout = 3000000
    SynchronizedEvents = False
    Left = 576
    Top = 256
  end
  object RESTLote: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'pessoas'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 520
    Top = 336
  end
  object ActionList1: TActionList
    Left = 488
    Top = 160
    object actSalvar: TAction
      Caption = '&Salvar'
      OnExecute = actSalvarExecute
    end
    object actExcluir: TAction
      Caption = '&Excluir'
      OnExecute = actExcluirExecute
    end
    object actCarregarLote: TAction
      Caption = '&Carregar Lote'
      OnExecute = actCarregarLoteExecute
    end
    object actIntegrar: TAction
      Caption = '&Integrar'
      OnExecute = actIntegrarExecute
    end
    object actPesquisar: TAction
      Caption = '&Pesquisar'
      OnExecute = actPesquisarExecute
    end
  end
end
