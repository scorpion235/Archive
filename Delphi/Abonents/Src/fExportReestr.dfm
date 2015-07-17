object frmExportReestr: TfrmExportReestr
  Left = 371
  Top = 319
  ActiveControl = edExportPath
  BorderStyle = bsDialog
  Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1088#1077#1077#1089#1090#1088#1072
  ClientHeight = 266
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object lblExportPath: TLabel
      Left = 10
      Top = 15
      Width = 99
      Height = 13
      Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080':'
    end
    object lblService: TLabel
      Left = 10
      Top = 55
      Width = 39
      Height = 13
      Caption = #1059#1089#1083#1091#1075#1072':'
    end
    object edExportPath: TDBEditEh
      Left = 10
      Top = 31
      Width = 470
      Height = 19
      Hint = #1055#1091#1090#1100' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1084#1086#1078#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1074' '#1084#1077#1085#1102' "'#1053#1072#1089#1090#1088#1086#1081#1082#1080'"'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      Visible = True
    end
    object cbAccCloseImport: TCheckBox
      Left = 10
      Top = 95
      Width = 400
      Height = 17
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1072#1073#1086#1085#1077#1085#1090#1086#1074' '#1089' '#1083#1080#1094#1077#1074#1099#1084#1080' '#1089#1095#1077#1090#1072#1084#1080', '#1087#1086#1084#1077#1095#1077#1085#1085#1099#1084#1080' '#1085#1072' '#1079#1072#1082#1088#1099#1090#1080#1077
      TabOrder = 2
    end
    object cbService: TDBComboBoxEh
      Left = 10
      Top = 70
      Width = 470
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 1
      Visible = True
    end
    object lbHistory: TTextListBox
      Left = 10
      Top = 115
      Width = 470
      Height = 110
      ItemHeight = 13
      TabOrder = 3
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 235
    Width = 492
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnExport: TButton
      Left = 320
      Top = 0
      Width = 75
      Height = 25
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      Default = True
      TabOrder = 0
      OnClick = btnExportClick
    end
    object btnClose: TButton
      Left = 405
      Top = 0
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object mdExportReestr: TRxMemoryData
    FieldDefs = <>
    Left = 408
    Top = 134
    object mdExportReestrABONENT_ID: TIntegerField
      FieldName = 'ABONENT_ID'
    end
    object mdExportReestrFIO: TStringField
      FieldName = 'FIO'
      Size = 70
    end
    object mdExportReestrBUILDING: TStringField
      FieldName = 'BUILDING'
      Size = 10
    end
    object mdExportReestrAPARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 7
    end
    object mdExportReestrACC_PU: TStringField
      FieldName = 'ACC_PU'
      Size = 40
    end
    object mdExportReestrIS_ACC_LOCK: TIntegerField
      FieldName = 'IS_ACC_LOCK'
    end
    object mdExportReestrBALANCE: TFloatField
      FieldName = 'BALANCE'
    end
    object mdExportReestrSERVICE_NUM: TIntegerField
      FieldName = 'SERVICE_NUM'
    end
    object mdExportReestrSERVICE_NAME: TStringField
      FieldName = 'SERVICE_NAME'
      Size = 70
    end
    object mdExportReestrSUB_SRV_PU: TStringField
      FieldName = 'SUB_SRV_PU'
      Size = 70
    end
    object mdExportReestrCITY: TStringField
      FieldName = 'CITY'
      Size = 70
    end
    object mdExportReestrSTREET: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object mdExportReestrSALDO_ID: TIntegerField
      FieldName = 'SALDO_ID'
    end
    object mdExportReestrSUMM: TFloatField
      FieldName = 'SUMM'
    end
    object mdExportReestrPERIOD_BEGIN: TDateField
      FieldName = 'PERIOD_BEGIN'
    end
    object mdExportReestrPERIOD_END: TDateField
      FieldName = 'PERIOD_END'
    end
    object mdExportReestrIS_EXPORT: TSmallintField
      FieldName = 'IS_EXPORT'
    end
  end
  object dsExportReestr: TDataSource
    DataSet = mdExportReestr
    Left = 408
    Top = 174
  end
end
