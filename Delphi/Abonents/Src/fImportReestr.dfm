object frmImportReestr: TfrmImportReestr
  Left = 338
  Top = 202
  ActiveControl = edImportPath
  BorderStyle = bsDialog
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1088#1077#1077#1089#1090#1088#1072
  ClientHeight = 416
  ClientWidth = 692
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
    Width = 692
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object lblImportPath: TLabel
      Left = 10
      Top = 15
      Width = 97
      Height = 13
      Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080':'
    end
    object lblReestr: TLabel
      Left = 10
      Top = 55
      Width = 39
      Height = 13
      Caption = #1056#1077#1077#1089#1090#1088':'
    end
    object edImportPath: TDBEditEh
      Left = 10
      Top = 31
      Width = 670
      Height = 19
      Hint = #1055#1091#1090#1100' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1084#1086#1078#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1074' '#1084#1077#1085#1102' "'#1053#1072#1089#1090#1088#1086#1081#1082#1080'"'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 0
      Visible = True
    end
    object edReestr: TDBEditEh
      Left = 10
      Top = 70
      Width = 565
      Height = 19
      EditButtons = <>
      Flat = True
      ReadOnly = True
      TabOrder = 1
      Visible = True
    end
    object btnReestr: TButton
      Left = 580
      Top = 68
      Width = 100
      Height = 21
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1088#1077#1077#1089#1090#1088
      Default = True
      TabOrder = 2
      OnClick = btnReestrClick
    end
    object PageControl: TPageControl
      Left = 10
      Top = 100
      Width = 670
      Height = 280
      ActivePage = tsPay
      TabIndex = 1
      TabOrder = 3
      object tsHeader: TTabSheet
        Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
        object lbHistory: TTextListBox
          Left = 0
          Top = 0
          Width = 662
          Height = 252
          Align = alClient
          ItemHeight = 13
          TabOrder = 0
        end
      end
      object tsPay: TTabSheet
        Caption = #1055#1083#1072#1090#1077#1078#1080
        ImageIndex = 1
        object GridPay: TDBGridEh
          Left = 0
          Top = 0
          Width = 662
          Height = 252
          Align = alClient
          DataSource = dsPay
          Flat = True
          FooterColor = clInfoBk
          FooterFont.Charset = DEFAULT_CHARSET
          FooterFont.Color = clWindowText
          FooterFont.Height = -11
          FooterFont.Name = 'MS Sans Serif'
          FooterFont.Style = []
          FooterRowCount = 1
          Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          OptionsEh = [dghFixed3D, dghHighlightFocus, dghClearSelection, dghAutoSortMarking, dghMultiSortMarking, dghDialogFind]
          RowHeight = 2
          RowLines = 1
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          UseMultiTitle = True
          OnGetCellParams = GridPayGetCellParams
          OnSortMarkingChanged = GridPaySortMarkingChanged
          Columns = <
            item
              EditButtons = <>
              FieldName = 'MSG'
              Footer.Alignment = taRightJustify
              Footer.ValueType = fvtStaticText
              Footers = <>
              Title.Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
              Title.TitleButton = True
              Width = 200
            end
            item
              EditButtons = <>
              FieldName = 'SUB_SRV_PU'
              Footer.Value = #1079#1072#1087#1080#1089#1077#1081
              Footer.ValueType = fvtStaticText
              Footers = <>
              Title.Caption = #1055#1086#1076#1091#1089#1083#1091#1075#1072
              Title.TitleButton = True
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'FIO'
              Footer.ValueType = fvtStaticText
              Footers = <>
              Title.Caption = #1060#1048#1054
              Title.TitleButton = True
              Width = 200
            end
            item
              EditButtons = <>
              FieldName = 'CITY'
              Footers = <>
              Title.Caption = #1043#1086#1088#1086#1076
              Title.TitleButton = True
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'STREET'
              Footers = <>
              Title.Caption = #1059#1083#1080#1094#1072
              Title.TitleButton = True
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'BUILDING'
              Footers = <>
              Title.Caption = #1044#1086#1084
              Title.TitleButton = True
              Width = 40
            end
            item
              EditButtons = <>
              FieldName = 'APARTMENT'
              Footers = <>
              Title.Caption = #1050#1074#1072#1088#1090'.'
              Title.TitleButton = True
              Width = 40
            end
            item
              EditButtons = <>
              FieldName = 'ACC_PU'
              Footers = <>
              Title.Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090
              Title.TitleButton = True
              Width = 150
            end
            item
              EditButtons = <>
              FieldName = 'DATE_PAY'
              Footers = <>
              Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
              Title.TitleButton = True
              Width = 75
            end
            item
              EditButtons = <>
              FieldName = 'UNO'
              Footers = <>
              Title.Caption = #1050#1074#1080#1090#1072#1085#1094#1080#1103
              Title.TitleButton = True
              Width = 70
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'SUMM'
              Footers = <>
              Title.Caption = #1057#1091#1084#1084#1072
              Title.TitleButton = True
              Width = 100
            end
            item
              Alignment = taRightJustify
              EditButtons = <>
              FieldName = 'BALANCE'
              Footers = <>
              Title.Caption = '  '#1057#1072#1083#1100#1076#1086'   ('#1057#1080#1089#1090#1072#1084#1072' '#1043#1086#1088#1086#1076')'
              Title.TitleButton = True
              Width = 100
            end>
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 385
    Width = 692
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnImport: TButton
      Left = 520
      Top = 0
      Width = 75
      Height = 25
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Default = True
      TabOrder = 0
      OnClick = btnImportClick
    end
    object btnClose: TButton
      Left = 605
      Top = 0
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = #1090#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083' (*.txt)|*.txt'
    Left = 180
    Top = 188
  end
  object dsPay: TDataSource
    DataSet = mdPay
    Left = 134
    Top = 218
  end
  object mdPay: TRxMemoryData
    FieldDefs = <>
    Left = 134
    Top = 186
    object mdPayMSG: TStringField
      FieldName = 'MSG'
      Size = 100
    end
    object mdPaySUB_SRV_PU: TStringField
      FieldName = 'SUB_SRV_PU'
      Size = 70
    end
    object mdPayFIO: TStringField
      FieldName = 'FIO'
      Size = 70
    end
    object mdPayCITY: TStringField
      FieldName = 'CITY'
      Size = 40
    end
    object mdPaySTREET: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object mdPayBUILDING: TStringField
      FieldName = 'BUILDING'
      Size = 10
    end
    object mdPayAPARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 7
    end
    object mdPayACC_PU: TStringField
      FieldName = 'ACC_PU'
      Size = 40
    end
    object mdPayDATE_PAY: TDateField
      FieldName = 'DATE_PAY'
    end
    object mdPayUNO: TStringField
      FieldName = 'UNO'
      Size = 15
    end
    object mdPaySUMM: TStringField
      FieldName = 'SUMM'
    end
    object mdPayBALANCE: TStringField
      FieldName = 'BALANCE'
    end
  end
end
