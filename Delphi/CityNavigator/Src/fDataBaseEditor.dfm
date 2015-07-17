object frmDataBaseEditor: TfrmDataBaseEditor
  Left = 353
  Top = 248
  Width = 792
  Height = 535
  ActiveControl = edDataBasePath
  Caption = 'Abonents - '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlDataBase: TPanel
    Left = 0
    Top = 0
    Width = 220
    Height = 501
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    Constraints.MinWidth = 220
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnResize = pnlDataBaseResize
    object lblDataBasePath: TLabel
      Left = 10
      Top = 14
      Width = 141
      Height = 13
      Caption = #1055#1091#1090#1100' '#1082' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093' FireBird:'
    end
    object lblMainServiceNum: TLabel
      Left = 10
      Top = 225
      Width = 124
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1086#1089#1085#1086#1074#1085#1086#1081' '#1091#1089#1083#1091#1075#1080':'
    end
    object lblAddServiceNum: TLabel
      Left = 10
      Top = 360
      Width = 97
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1087'. '#1091#1089#1083#1091#1075#1080':'
    end
    object edDataBasePath: TLMDFileOpenEdit
      Left = 10
      Top = 30
      Width = 200
      Height = 21
      Bevel.Mode = bmWindows
      Caret.BlinkRate = 530
      Flat = True
      TabOrder = 0
      OnChange = edDataBasePathChange
      CustomButtonWidth = 18
      Options = [ofHideReadOnly, ofFileMustExist]
      Filter = #1092#1072#1081#1083' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' FireBird (*.fdb)|*.fdb'
      FilenameOnly = False
    end
    object btnConnect: TButton
      Left = 10
      Top = 60
      Width = 120
      Height = 25
      Hint = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103' '#1082' '#1073#1072#1079#1077' '#1076#1072#1085#1085#1099#1093' FireBird'
      Caption = #1055#1086#1076#1082#1083#1102#1095#1077#1085#1080#1077
      TabOrder = 1
      OnClick = btnConnectClick
    end
    object btnDisconnect: TButton
      Left = 10
      Top = 90
      Width = 120
      Height = 25
      Hint = #1054#1090#1089#1086#1077#1076#1080#1085#1080#1090#1100#1089#1103' '#1086#1090' '#1073#1072#1079#1099' '#1076#1072#1085#1085#1099#1093' FireBird'
      Caption = #1054#1090#1089#1086#1077#1076#1080#1085#1077#1085#1080#1077
      TabOrder = 2
      OnClick = btnDisconnectClick
    end
    object btnClearManualTable: TButton
      Left = 10
      Top = 160
      Width = 200
      Height = 25
      Hint = 
        #1054#1095#1080#1089#1090#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' '#1091#1083#1080#1094', '#1075#1086#1088#1086#1076#1086#1074', '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1081', '#1087#1086#1076#1091#1089#1083#1091#1075', '#1091#1089#1083#1091#1075', '#1090#1080 +
        #1087#1086#1074' '#1091#1089#1083#1091#1075', '#1090#1072#1073#1083#1080#1094#1091' '#1074#1077#1088#1089#1080#1081
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
      TabOrder = 4
      OnClick = btnClearManualTableClick
    end
    object btnFillManualTable: TButton
      Left = 10
      Top = 190
      Width = 200
      Height = 25
      Hint = 
        #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' '#1091#1083#1080#1094', '#1075#1086#1088#1086#1076#1086#1074', '#1086#1088#1075#1072#1085#1080#1079#1072#1094#1080#1081', '#1087#1086#1076#1091#1089#1083#1091#1075', '#1091#1089#1083#1091#1075', '#1090 +
        #1080#1087#1086#1074' '#1091#1089#1083#1091#1075', '#1090#1072#1073#1083#1080#1094#1091' '#1074#1077#1088#1089#1080#1081
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
      TabOrder = 5
      OnClick = btnFillManualTableClick
    end
    object btnClearBuhTable: TButton
      Left = 10
      Top = 130
      Width = 200
      Height = 25
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1099' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081', '#1087#1083#1072#1090#1077#1078#1077#1081', '#1072#1073#1086#1085#1077#1085#1090#1086#1074
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1077' '#1090#1072#1073#1083#1080#1094#1099
      TabOrder = 3
      OnClick = btnClearBuhTableClick
    end
    object btnFillAbonentTable: TButton
      Left = 10
      Top = 265
      Width = 200
      Height = 25
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1072#1073#1086#1085#1077#1085#1090#1086#1074
      TabOrder = 7
      OnClick = btnFillAbonentTableClick
    end
    object edMainServiceNum: TRxSpinEdit
      Left = 10
      Top = 240
      Width = 100
      Height = 21
      MaxValue = 100000
      TabOrder = 6
    end
    object btnFillMainPayTable: TButton
      Left = 12
      Top = 325
      Width = 200
      Height = 25
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1087#1083#1072#1090#1077#1078#1077#1081
      TabOrder = 9
      OnClick = btnFillMainPayTableClick
    end
    object btnFillSaldoTable: TButton
      Left = 10
      Top = 295
      Width = 200
      Height = 25
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
      TabOrder = 8
      OnClick = btnFillSaldoTableClick
    end
    object edAddServiceNum: TRxSpinEdit
      Left = 10
      Top = 374
      Width = 100
      Height = 21
      MaxValue = 100000
      TabOrder = 10
    end
    object btnFillAddPayTable: TButton
      Left = 10
      Top = 400
      Width = 200
      Height = 25
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1087#1083#1072#1090#1077#1078#1077#1081
      TabOrder = 11
      OnClick = btnFillAddPayTableClick
    end
  end
  object RxSplitter: TRxSplitter
    Left = 220
    Top = 0
    Width = 4
    Height = 501
    ControlFirst = pnlDataBase
    Align = alLeft
    BevelOuter = bvNone
  end
  object GridHistory: TDBGridEh
    Left = 224
    Top = 0
    Width = 560
    Height = 501
    Align = alClient
    DataSource = dsHistory
    Flat = True
    FooterColor = clInfoBk
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghDialogFind]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
    OnGetCellParams = GridHistoryGetCellParams
    Columns = <
      item
        EditButtons = <>
        FieldName = 'DATETIME'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103
        Width = 115
      end
      item
        EditButtons = <>
        FieldName = 'MSG'
        Footers = <>
        Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
        Width = 1000
      end>
  end
  object mdHistory: TRxMemoryData
    FieldDefs = <>
    Left = 408
    Top = 130
    object mdHistoryDATETIME: TDateTimeField
      FieldName = 'DATETIME'
    end
    object mdHistoryMSG: TStringField
      FieldName = 'MSG'
      Size = 500
    end
    object mdHistoryMSG_TYPE: TStringField
      FieldName = 'MSG_TYPE'
      Size = 3
    end
  end
  object dsHistory: TDataSource
    DataSet = mdHistory
    Left = 408
    Top = 164
  end
  object mdAbonent: TRxMemoryData
    FieldDefs = <>
    Left = 144
    Top = 232
    object mdAbonentABONENT_ID: TIntegerField
      FieldName = 'ABONENT_ID'
    end
    object mdAbonentACC_PU: TStringField
      FieldName = 'ACC_PU'
      Size = 40
    end
    object mdAbonentSUB_SRV_PU: TStringField
      FieldName = 'SUB_SRV_PU'
      Size = 70
    end
  end
  object dsAbonent: TDataSource
    DataSet = mdAbonent
    Left = 178
    Top = 232
  end
end
