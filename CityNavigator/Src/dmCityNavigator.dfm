object DataMod: TDataMod
  OldCreateOrder = False
  Left = 484
  Top = 281
  Height = 356
  Width = 392
  object OracleSession: TOracleSession
    Left = 38
    Top = 20
  end
  object OracleDataSet: TOracleDataSet
    SQL.Strings = (
      '')
    Optimize = False
    QBEDefinition.QBEFieldDefs = {
      0400000005000000020000004944010000000000040000004349545901000000
      00000B000000524547494F4E5F434F444501000000000006000000524547494F
      4E01000000000007000000434F554E545259010000000000}
    Session = OracleSession
    Left = 38
    Top = 82
  end
  object OraclePackage: TOraclePackage
    Session = OracleSession
    Left = 138
    Top = 22
  end
  object IB_Connection: TIB_Connection
    DefaultTransaction = IB_Transaction
    Left = 38
    Top = 186
  end
  object IB_Transaction: TIB_Transaction
    IB_Connection = IB_Connection
    Isolation = tiConcurrency
    Left = 38
    Top = 246
  end
  object IB_Cursor: TIB_Cursor
    IB_Connection = IB_Connection
    SQL.Strings = (
      'select * from Services')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    Left = 136
    Top = 184
  end
  object OracleLogon: TOracleLogon
    Session = OracleSession
    Options = [ldDatabase, ldDatabaseList]
    Caption = 'City Navigator - '#1042#1093#1086#1076' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1091
    Left = 138
    Top = 82
  end
end
