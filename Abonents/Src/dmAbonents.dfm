object DataMod: TDataMod
  OldCreateOrder = False
  Left = 481
  Top = 292
  Height = 262
  Width = 382
  object IB_Connection: TIB_Connection
    DefaultTransaction = IB_Transaction
    Left = 52
    Top = 26
  end
  object IB_Transaction: TIB_Transaction
    IB_Connection = IB_Connection
    Isolation = tiConcurrency
    Left = 52
    Top = 84
  end
  object IB_Cursor: TIB_Cursor
    IB_Connection = IB_Connection
    SQL.Strings = (
      'select * from Services')
    ColorScheme = False
    MasterSearchFlags = [msfOpenMasterOnOpen, msfSearchAppliesToMasterOnly]
    Left = 150
    Top = 26
  end
end
