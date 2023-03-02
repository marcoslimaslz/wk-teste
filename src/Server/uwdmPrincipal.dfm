object wdmPrincipal: TwdmPrincipal
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = wdmPrincipalDefaultHandlerAction
    end
    item
      MethodType = mtPost
      Name = 'POSTPessoa'
      PathInfo = '/pessoa'
      OnAction = wdmPrincipalPOSTPessoaAction
    end
    item
      MethodType = mtGet
      Name = 'GETPessoa'
      PathInfo = '/pessoa'
      OnAction = wdmPrincipalGETPessoaAction
    end
    item
      MethodType = mtDelete
      Name = 'DELETEPessoa'
      PathInfo = '/pessoa'
      OnAction = wdmPrincipalDELETEPessoaAction
    end
    item
      MethodType = mtPatch
      Name = 'PATCHPessoa'
      PathInfo = '/pessoa'
      OnAction = wdmPrincipalPATCHPessoaAction
    end
    item
      MethodType = mtGet
      Name = 'ExecutaIntegrador'
      PathInfo = '/endereco_integracao'
      OnAction = wdmPrincipalExecutaIntegradorAction
    end
    item
      MethodType = mtPost
      Name = 'PessoasLote'
      PathInfo = '/pessoas'
      OnAction = wdmPrincipalPessoasLoteAction
    end>
  Height = 230
  Width = 415
  object fdcConexao: TFDConnection
    Params.Strings = (
      'Database=wk'
      'User_Name=postgres'
      'Server=localhost'
      'Password=postgres'
      'DriverID=PG')
    LoginPrompt = False
    Left = 72
    Top = 40
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Console'
    Left = 112
    Top = 136
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 240
    Top = 64
  end
end
