object frmCadastroPessoa: TfrmCadastroPessoa
  Left = 0
  Top = 0
  Caption = 'WK - Cadastro de pessoas'
  ClientHeight = 185
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
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
    Left = 8
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
    Left = 8
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
    TabOrder = 7
  end
  object edIdPessoa: TEdit
    Left = 8
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
    Width = 387
    Height = 29
    ButtonHeight = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    ExplicitWidth = 383
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
    Width = 387
    Height = 40
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 383
    object Label1: TLabel
      Left = 10
      Top = 10
      Width = 86
      Height = 13
      Caption = 'Procurar por (ID):'
    end
    object edtPesquisar: TEdit
      Left = 110
      Top = 10
      Width = 150
      Height = 21
      Color = clBtnFace
      NumbersOnly = True
      TabOrder = 0
      OnKeyPress = edtPesquisarKeyPress
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
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8000'
    Params = <>
    SynchronizedEvents = False
    Left = 496
    Top = 368
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Resource = 'pessoa'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 552
    Top = 248
  end
  object RESTResponse1: TRESTResponse
    Left = 504
    Top = 320
  end
  object RESTRequestIntegrador: TRESTRequest
    AssignedValues = [rvReadTimeout]
    Client = RESTClient
    Params = <>
    Resource = 'endereco_integracao'
    Response = RESTResponse1
    ReadTimeout = 3000000
    SynchronizedEvents = False
    Left = 592
    Top = 320
  end
  object RESTLote: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'pessoas'
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 608
    Top = 368
  end
  object ActionList1: TActionList
    Left = 544
    Top = 200
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
