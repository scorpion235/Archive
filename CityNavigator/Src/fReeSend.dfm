object frmReeSend: TfrmReeSend
  Left = 264
  Top = 114
  Width = 870
  Height = 640
  Caption = #1055#1086#1089#1099#1083#1082#1072' '#1088#1077#1077#1089#1090#1088#1086#1074
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
    object lblPeriod: TLabel
      Left = 10
      Top = 70
      Width = 38
      Height = 13
      Caption = #1055#1077#1088#1080#1086#1076
    end
    object lblPeriodStart: TLabel
      Left = 10
      Top = 90
      Width = 9
      Height = 13
      Caption = 'c:'
    end
    object lblPeriodEnd: TLabel
      Left = 10
      Top = 115
      Width = 15
      Height = 13
      Caption = #1087#1086':'
    end
    object lblError: TLabel
      Left = 10
      Top = 135
      Width = 131
      Height = 26
      Caption = #1055#1088#1086#1074#1077#1088#1100#1090#1077' '#1082#1086#1088#1088#1077#1082#1090#1085#1086#1089#1090#1100' '#13#10#1079#1085#1072#1095#1077#1085#1080#1081' '#1076#1072#1090'!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblResult: TLabel
      Left = 10
      Top = 225
      Width = 161
      Height = 13
      Caption = #1069#1090#1072#1087#1099' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1088#1077#1077#1089#1090#1088#1086#1074
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
    object edService: TDBEditEh
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
      OnKeyUp = edServiceKeyUp
    end
    object edPeriodBegin: TDBDateTimeEditEh
      Left = 30
      Top = 85
      Width = 117
      Height = 19
      EditButtons = <>
      Flat = True
      Kind = dtkDateEh
      TabOrder = 2
      Visible = True
      OnChange = edPeriodBeginChange
    end
    object edPeriodEnd: TDBDateTimeEditEh
      Left = 30
      Top = 110
      Width = 117
      Height = 19
      EditButtons = <>
      Flat = True
      Kind = dtkDateEh
      TabOrder = 3
      Visible = True
      OnChange = edPeriodBeginChange
    end
    object btnExecute: TButton
      Left = 10
      Top = 190
      Width = 90
      Height = 25
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1088#1072#1074#1082#1091' '#1087#1086' '#1087#1083#1072#1090#1077#1078#1072#1084
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = btnExecuteClick
    end
    object cbService: TCheckBox
      Left = 12
      Top = 166
      Width = 97
      Height = 17
      Caption = #1042#1089#1077' '#1091#1089#1083#1091#1075#1080
      TabOrder = 4
      OnClick = cbServiceClick
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
  object GridReeSend: TDBGridEh
    Left = 183
    Top = 0
    Width = 679
    Height = 613
    Align = alClient
    DataSource = dsReeSend
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
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
    OnSortMarkingChanged = GridReeSendSortMarkingChanged
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ID'
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.TitleButton = True
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'NUM'
        Footer.Alignment = taLeftJustify
        Footer.Value = #1079#1072#1087#1080#1089#1077#1081
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1053#1086#1084#1077#1088
        Title.TitleButton = True
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'NAME'
        Footers = <>
        Title.Caption = #1059#1089#1083#1091#1075#1072
        Title.TitleButton = True
        Width = 500
      end
      item
        EditButtons = <>
        FieldName = 'TYPE'
        Footers = <>
        Title.Caption = #1058#1080#1087' '#1091#1089#1083#1091#1075#1080
        Title.TitleButton = True
        Width = 250
      end>
  end
  object mdReeSend: TRxMemoryData
    FieldDefs = <>
    Left = 334
    Top = 200
    object mdReeSendID: TIntegerField
      FieldName = 'ID'
    end
    object mdReeSendNUM: TIntegerField
      FieldName = 'NUM'
    end
    object mdReeSendNAME: TStringField
      FieldName = 'NAME'
      Size = 200
    end
    object mdReeSendTYPE: TStringField
      FieldName = 'TYPE'
      Size = 100
    end
  end
  object dsReeSend: TDataSource
    DataSet = mdReeSend
    Left = 334
    Top = 240
  end
end
