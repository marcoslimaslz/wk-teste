object wdmPrincipal: TwdmPrincipal
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
    end
    item
      MethodType = mtPost
      Name = 'POSTPessoa'
      PathInfo = '/pessoa'
    end
    item
      MethodType = mtGet
      Name = 'GETPessoa'
      PathInfo = '/pessoa'
    end
    item
      MethodType = mtDelete
      Name = 'DELETEPessoa'
      PathInfo = '/pessoa'
    end
    item
      MethodType = mtPatch
      Name = 'PATCHPessoa'
      PathInfo = '/pessoa'
    end
    item
      MethodType = mtGet
      Name = 'ExecutaIntegrador'
      PathInfo = '/endereco_integracao'
    end
    item
      MethodType = mtPost
      Name = 'PessoasLote'
      PathInfo = '/pessoas'
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
