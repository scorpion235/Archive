object frmPay: TfrmPay
  Left = 322
  Top = 91
  Width = 870
  Height = 640
  ActiveControl = cbService
  Caption = #1055#1083#1072#1090#1077#1078#1080
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFilter: TPanel
    Left = 0
    Top = 0
    Width = 179
    Height = 613
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pnlFilterResize
    object lblService: TLabel
      Left = 10
      Top = 30
      Width = 39
      Height = 13
      Caption = #1059#1089#1083#1091#1075#1072':'
    end
    object lblFIO: TLabel
      Left = 10
      Top = 70
      Width = 30
      Height = 13
      Caption = #1060#1048#1054':'
    end
    object lblCity: TLabel
      Left = 10
      Top = 110
      Width = 33
      Height = 13
      Caption = #1043#1086#1088#1086#1076':'
    end
    object lblStreet: TLabel
      Left = 10
      Top = 150
      Width = 35
      Height = 13
      Caption = #1059#1083#1080#1094#1072':'
    end
    object pnlFilterTop: TPanel
      Left = 1
      Top = 1
      Width = 177
      Height = 19
      Align = alTop
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080
      TabOrder = 0
    end
    object cbService: TDBComboBoxEh
      Left = 10
      Top = 45
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 1
      Visible = True
      OnChange = cbServiceChange
    end
    object edFIO: TDBEditEh
      Left = 10
      Top = 85
      Width = 161
      Height = 19
      CharCase = ecUpperCase
      EditButtons = <>
      Flat = True
      TabOrder = 2
      Visible = True
      OnChange = cbServiceChange
    end
    object cbCity: TDBComboBoxEh
      Left = 10
      Top = 125
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 3
      Visible = True
      OnChange = cbServiceChange
    end
    object edStreet: TDBEditEh
      Left = 10
      Top = 165
      Width = 161
      Height = 19
      CharCase = ecUpperCase
      EditButtons = <>
      Flat = True
      TabOrder = 4
      Visible = True
      OnChange = cbServiceChange
    end
  end
  object RxSplitter: TRxSplitter
    Left = 179
    Top = 0
    Width = 4
    Height = 613
    ControlFirst = pnlFilter
    Align = alLeft
    BevelOuter = bvNone
  end
  object pnlGrid: TPanel
    Left = 183
    Top = 0
    Width = 679
    Height = 613
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object RxSplitter2: TRxSplitter
      Left = 0
      Top = 609
      Width = 679
      Height = 4
      Align = alBottom
      BevelOuter = bvNone
    end
    object GridPay: TDBGridEh
      Left = 0
      Top = 0
      Width = 679
      Height = 609
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
      PopupMenu = pmPays
      RowHeight = 2
      RowLines = 1
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      UseMultiTitle = True
      OnSortMarkingChanged = GridPaySortMarkingChanged
      Columns = <
        item
          EditButtons = <>
          FieldName = 'PAY_ID'
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = 'ID'
          Title.TitleButton = True
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'REE_ID'
          Footer.Alignment = taLeftJustify
          Footer.Value = #1079#1072#1087#1080#1089#1077#1081
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = 'ID '#1088#1077#1077#1089#1090#1088#1072
          Title.TitleButton = True
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'AGENT_ID'
          Footers = <>
          Title.TitleButton = True
          Visible = False
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'SERVICE_ID'
          Footers = <>
          Title.TitleButton = True
          Visible = False
          Width = 70
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
          FieldName = 'SERVICE'
          Footers = <>
          Title.Caption = #1059#1089#1083#1091#1075#1072
          Title.TitleButton = True
          Width = 300
        end
        item
          EditButtons = <>
          FieldName = 'FIO'
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
          FieldName = 'AGENT'
          Footers = <>
          Title.Caption = #1040#1075#1077#1085#1090
          Title.TitleButton = True
          Width = 300
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
          DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
          EditButtons = <>
          FieldName = 'SUMM'
          Footer.DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = #1057#1091#1084#1084#1072
          Title.TitleButton = True
          Width = 100
        end>
    end
  end
  object dsPay: TDataSource
    DataSet = mdPay
    Left = 352
    Top = 154
  end
  object pmPays: TPopupMenu
    Images = frmMain.ImageList
    Left = 392
    Top = 114
    object pmCityAdd: TMenuItem
      Action = frmMain.AcAdd
    end
    object pmCityEdit: TMenuItem
      Action = frmMain.AcEdit
    end
    object pmCityDelete: TMenuItem
      Action = frmMain.AcDelete
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmCityRefresh: TMenuItem
      Action = frmMain.AcRefresh
    end
  end
  object mdPay: TRxMemoryData
    FieldDefs = <>
    Left = 352
    Top = 114
    object mdPayPAY_ID: TIntegerField
      FieldName = 'PAY_ID'
    end
    object mdPayREE_ID: TIntegerField
      FieldName = 'REE_ID'
    end
    object mdPayAGENT_ID: TIntegerField
      FieldName = 'AGENT_ID'
    end
    object mdPaySERVICE_ID: TIntegerField
      FieldName = 'SERVICE_ID'
    end
    object mdPayAGENT: TStringField
      FieldName = 'AGENT'
      Size = 255
    end
    object mdPaySERVICE: TStringField
      FieldName = 'SERVICE'
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
    object mdPayDATE_PAY: TDateField
      FieldName = 'DATE_PAY'
    end
    object mdPayUNO: TStringField
      FieldName = 'UNO'
    end
    object mdPaySUMM: TFloatField
      FieldName = 'SUMM'
    end
  end
  object PrintGrid: TPrintDBGridEh
    DBGridEh = GridPay
    Options = [pghFitGridToPageWidth, pghFitingByColWidths]
    PageFooter.Font.Charset = DEFAULT_CHARSET
    PageFooter.Font.Color = clWindowText
    PageFooter.Font.Height = -11
    PageFooter.Font.Name = 'MS Sans Serif'
    PageFooter.Font.Style = []
    PageFooter.RightText.Strings = (
      '&[Page]/&[Pages]')
    PageHeader.Font.Charset = DEFAULT_CHARSET
    PageHeader.Font.Color = clWindowText
    PageHeader.Font.Height = -11
    PageHeader.Font.Name = 'MS Sans Serif'
    PageHeader.Font.Style = []
    Units = MM
    Left = 466
    Top = 115
    BeforeGridText_Data = {
      7B5C727466315C616E73695C616E7369637067313235315C64656666305C6465
      666C616E67313034397B5C666F6E7474626C7B5C66305C666E696C5C66636861
      727365743230347B5C2A5C666E616D652054696D6573204E657720526F6D616E
      3B7D54696D6573204E657720526F6D616E204359523B7D7D0D0A5C766965776B
      696E64345C7563315C706172645C71635C6C616E67313033335C625C66305C66
      73323420315C6C616E6731303439200D0A5C706172207D0D0A00}
  end
  object xlExcel: TxlReport
    DataExportMode = xdmDDE
    Options = [xroDisplayAlerts, xroAutoOpen]
    XLSTemplate = '.\Reports\Pays.xlt'
    DataSources = <
      item
        DataSet = mdPay
        Alias = 'mdPay'
        Range = 'SourceRange'
        Options = [xrgoAutoOpen, xrgoPreserveRowHeight]
        Tag = 0
      end>
    Preview = False
    Params = <
      item
        Name = 'FIO'
        Value = ''
      end
      item
        Name = 'CITY'
        Value = ''
      end
      item
        Name = 'STREET'
        Value = ''
      end>
    Left = 468
    Top = 156
  end
end
