object frmLim: TfrmLim
  Left = 264
  Top = 114
  Width = 870
  Height = 640
  ActiveControl = edOrg
  Caption = #1051#1080#1084#1080#1090#1099
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
    Height = 606
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pnlFilterResize
    object lblOrg: TLabel
      Left = 10
      Top = 30
      Width = 32
      Height = 13
      Caption = #1040#1075#1077#1085#1090':'
    end
    object edOrg: TDBEditEh
      Left = 10
      Top = 45
      Width = 157
      Height = 19
      Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Visible = True
      OnKeyUp = edOrgKeyUp
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
  end
  object RxSplitter: TRxSplitter
    Left = 179
    Top = 0
    Width = 4
    Height = 606
    ControlFirst = pnlFilter
    Align = alLeft
    BevelOuter = bvNone
  end
  object GridLim: TDBGridEh
    Left = 183
    Top = 0
    Width = 679
    Height = 606
    Align = alClient
    DataSource = dsLim
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
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
    OnGetCellParams = GridLimGetCellParams
    OnSortMarkingChanged = GridLimSortMarkingChanged
    Columns = <
      item
        Checkboxes = True
        EditButtons = <>
        FieldName = 'IS_ACTIVE'
        Footer.Alignment = taRightJustify
        Footer.ValueType = fvtStaticText
        Footers = <>
        KeyList.Strings = (
          'yes'
          'no')
        Title.Caption = #1044#1077#1081#1089#1090#1074'.'
        Title.TitleButton = True
        Width = 45
      end
      item
        EditButtons = <>
        FieldName = 'LIM_NAME'
        Footer.Value = #1079#1072#1087#1080#1089#1077#1081
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Title.TitleButton = True
        Width = 90
      end
      item
        EditButtons = <>
        FieldName = 'AGENT_NAME'
        Footers = <>
        Title.Caption = #1040#1075#1077#1085#1090
        Title.TitleButton = True
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'SUBAGENT_NAME'
        Footers = <>
        Title.Caption = #1057#1091#1073#1072#1075#1077#1085#1090
        Title.TitleButton = True
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'DEL_PERIOD'
        Footers = <>
        Title.Caption = #1055#1077#1088#1080#1086#1076' '#1074#1086#1079#1086#1073#1085#1086#1074#1083'.'
        Title.TitleButton = True
        Width = 80
      end
      item
        DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
        EditButtons = <>
        FieldName = 'LIMIT'
        Footers = <>
        Title.Caption = #1042#1099#1073#1088#1072#1085#1099#1081' '#1083#1080#1084#1080#1090
        Title.TitleButton = True
        Width = 100
      end
      item
        DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
        EditButtons = <>
        FieldName = 'VALUE'
        Footers = <>
        Title.Caption = #1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
        Title.TitleButton = True
        Width = 100
      end
      item
        DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
        EditButtons = <>
        FieldName = 'POSSIBLE_PAY'
        Footers = <>
        Title.Caption = #1042#1086#1079#1084#1086#1078#1085#1099#1081' '#1087#1083#1072#1090#1077#1078
        Title.TitleButton = True
        Width = 100
      end
      item
        Checkboxes = True
        EditButtons = <>
        FieldName = 'COMMISS'
        Footers = <>
        KeyList.Strings = (
          'yes'
          'no')
        Title.Caption = #1050#1086#1084#1080#1089#1089'.'
        Title.TitleButton = True
        Width = 50
      end>
  end
  object mdLim: TRxMemoryData
    FieldDefs = <>
    Left = 334
    Top = 200
    object mdLimIS_ACTIVE: TStringField
      FieldName = 'IS_ACTIVE'
      Size = 3
    end
    object mdLimLIM_NAME: TStringField
      FieldName = 'LIM_NAME'
      Size = 100
    end
    object mdLimAGENT_NAME: TStringField
      FieldName = 'AGENT_NAME'
      Size = 100
    end
    object mdLimSUBAGENT_NAME: TStringField
      FieldName = 'SUBAGENT_NAME'
      Size = 100
    end
    object mdLimDEL_PERIOD: TStringField
      FieldName = 'DEL_PERIOD'
      Size = 10
    end
    object mdLimLIMIT: TFloatField
      FieldName = 'LIMIT'
    end
    object mdLimVALUE: TFloatField
      FieldName = 'VALUE'
    end
    object mdLimPOSSIBLE_PAY: TFloatField
      FieldName = 'POSSIBLE_PAY'
    end
    object mdLimCOMMISS: TStringField
      FieldName = 'COMMISS'
      Size = 3
    end
  end
  object dsLim: TDataSource
    DataSet = mdLim
    Left = 334
    Top = 240
  end
end
