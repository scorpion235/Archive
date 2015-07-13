object frmTelephone: TfrmTelephone
  Left = 264
  Top = 114
  Width = 870
  Height = 640
  ActiveControl = edTelephone
  Caption = #1054#1087#1083#1072#1090#1099' '#1079#1072' '#1089#1086#1090#1086#1074#1099#1081' '#1090#1077#1083#1077#1092#1086#1085
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
    object lblTelephone: TLabel
      Left = 10
      Top = 30
      Width = 89
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072':'
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
      Width = 134
      Height = 26
      Caption = #1055#1088#1086#1074#1077#1088#1100#1090#1077' '#1082#1086#1088#1088#1077#1082#1090#1085#1086#1089#1090#1100' '#13#10#1079#1085#1072#1095#1077#1085#1080#1081' '#1076#1072#1090#1099' '#1080' '#1074#1088#1077#1084#1077#1085#1080'!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edTelephone: TDBEditEh
      Left = 10
      Top = 45
      Width = 157
      Height = 19
      Hint = 
        #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1085#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072' (10 '#1094#1080#1092#1088') '#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Ent' +
        'er>'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Visible = True
      OnKeyUp = edTelephoneKeyUp
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
    object edPeriodBegin: TDBDateTimeEditEh
      Left = 30
      Top = 85
      Width = 117
      Height = 19
      EditButtons = <>
      Flat = True
      Kind = dtkDateTimeEh
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
      Kind = dtkDateTimeEh
      TabOrder = 3
      Visible = True
      OnChange = edPeriodBeginChange
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
  object pcGreeds: TPageControl
    Left = 183
    Top = 0
    Width = 679
    Height = 606
    ActivePage = tsINV_BILLING
    Align = alClient
    Style = tsFlatButtons
    TabIndex = 0
    TabOrder = 2
    OnChange = pcGreedsChange
    object tsINV_BILLING: TTabSheet
      Caption = #1057#1095#1077#1090
      object GridTelephoneINV_BILLING: TDBGridEh
        Left = 0
        Top = 0
        Width = 671
        Height = 575
        Align = alClient
        DataSource = dsTelephoneINV_BILLING
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
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        OnGetCellParams = GridTelephoneINV_BILLINGGetCellParams
        OnSortMarkingChanged = GridTelephoneINV_BILLINGSortMarkingChanged
        Columns = <
          item
            EditButtons = <>
            FieldName = 'REQ_ID'
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Hint = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'REQ_STATE'
            Footer.Alignment = taLeftJustify
            Footer.Value = #1079#1072#1087#1080#1089#1077#1081
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'REQ_DATE'
            Footers = <>
            Title.Hint = #1044#1072#1090#1072' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'LSID'
            Footers = <>
            Title.Hint = #1057#1077#1089#1089#1080#1103' '#1083#1080#1089#1090#1077#1085#1077#1088#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'REQ_TYPE'
            Footers = <>
            Title.Hint = #1058#1080#1087' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'RESULT'
            Footers = <>
            Title.Hint = #1050#1086#1076' '#1074#1086#1079#1074#1072#1090#1072' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'ERRMSG'
            Footers = <>
            Title.Hint = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1086#1073' '#1086#1096#1080#1073#1082#1077
            Title.TitleButton = True
            Width = 250
          end
          item
            EditButtons = <>
            FieldName = 'OPER_TYPE'
            Footers = <>
            Title.Hint = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'UNO'
            Footers = <>
            Title.Hint = 'UNO '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1085#1072' '#1086#1087#1083#1072#1090#1091
            Title.TitleButton = True
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'PPP_ID'
            Footers = <>
            Title.Hint = #1055#1055#1055', '#1075#1076#1077' '#1089#1086#1074#1077#1088#1096#1072#1077#1090#1089#1103' '#1086#1087#1077#1088#1072#1094#1080#1103
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'USER_ID'
            Footers = <>
            Title.Hint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100', '#1089#1086#1074#1077#1088#1096#1072#1102#1097#1080#1081' '#1086#1087#1077#1088#1072#1094#1080#1102
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'PROG_ID'
            Footers = <>
            Title.Hint = #1040#1056#1052' '#1080#1079' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1072' '#1086#1087#1077#1088#1072#1094#1080#1103
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'AGENT_ID'
            Footers = <>
            Title.Hint = ' ('#1074' '#1089#1093#1077#1084#1077' '#1062#1060#1058')'
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'PRV_ID'
            Footers = <>
            Title.Hint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'SRVNUM'
            Footers = <>
            Title.Hint = #1053#1086#1084#1077#1088' '#1091#1089#1083#1091#1075#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'ACC_PU'
            Footers = <>
            Title.Hint = #1057#1095#1077#1090' '#1072#1073#1086#1085#1077#1085#1090#1072' '#1074' '#1089#1080#1089#1090#1077#1084#1077' '#1055#1059
            Title.TitleButton = True
            Width = 130
          end
          item
            EditButtons = <>
            FieldName = 'SUMM'
            Footers = <>
            Title.Hint = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            Title.TitleButton = True
            Width = 50
          end
          item
            EditButtons = <>
            FieldName = 'OUTP'
            Footers = <>
            Title.Hint = #1048#1089#1093#1086#1076#1103#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
            Title.TitleButton = True
            Width = 400
          end
          item
            EditButtons = <>
            FieldName = 'INP'
            Footers = <>
            Title.Hint = #1042#1093#1086#1076#1103#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
            Title.TitleButton = True
            Width = 400
          end
          item
            EditButtons = <>
            FieldName = 'REQ_AG_ID'
            Footers = <>
            Title.Hint = 'ID '#1079#1072#1087#1088#1086#1089#1072' '#1091' '#1072#1075#1077#1085#1090#1072
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'AG_UNO'
            Footers = <>
            Title.Hint = 'ID '#1087#1083#1072#1090#1077#1078#1072' '#1091' '#1072#1075#1077#1085#1090#1072
            Width = 150
          end
          item
            EditButtons = <>
            FieldName = 'REQ_PR_ID'
            Footers = <>
            Title.Hint = 'ID '#1079#1072#1087#1088#1086#1089#1072' '#1091' '#1087#1088#1086#1074#1072#1081#1076#1077#1088#1072
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'PR_UNO'
            Footers = <>
            Title.Hint = 'ID '#1087#1083#1072#1090#1077#1078#1072' '#1091' '#1087#1088#1086#1074#1072#1081#1076#1077#1088#1072
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'BILLING_AGENT_ID'
            Footers = <>
            Title.Hint = 'ID '#1072#1075#1077#1085#1090#1072' ('#1074' '#1089#1093#1077#1084#1077' '#1063#1048#1041')'
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'PARTNER_AG_ID'
            Footers = <>
            Title.Hint = 'ID '#1072#1075#1077#1085#1090#1072' ('#1074' '#1089#1093#1077#1084#1077' '#1063#1048#1041')'
            Width = 100
          end
          item
            EditButtons = <>
            FieldName = 'INNER_ERR_ID'
            Footers = <>
            Title.Hint = 'ID '#1074#1085#1091#1090#1088#1077#1085#1085#1077#1081' '#1086#1096#1080#1073#1082#1080
            Width = 90
          end
          item
            EditButtons = <>
            FieldName = 'BILLING_ERR_CODE'
            Footers = <>
            Title.Hint = #1082#1086#1076' '#1086#1096#1080#1073#1082#1080' '#1086#1090' '#1074#1085#1077#1096#1085#1077#1081' '#1073#1080#1083#1083#1080#1085#1075#1086#1074#1086#1081' '#1089#1080#1089#1090#1077#1084#1099
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'SUMM_COMISS'
            Footers = <>
            Title.Hint = 
              #1057#1091#1084#1084#1072' '#1082#1086#1084#1080#1089#1089#1080#1080' '#1089#1074#1077#1088#1093#1091', '#1087#1086#1083#1091#1095#1072#1077#1084#1086#1081' '#1089#1090#1086#1088#1086#1085#1085#1080#1084#1080' '#1072#1075#1077#1085#1090#1072#1084#1080' ('#1085#1077' '#1080#1079' '#1043#1086#1088 +
              #1086#1076#1072')'
            Width = 90
          end
          item
            EditButtons = <>
            FieldName = 'PAY_SYSTEM_ID'
            Footers = <>
            Title.Hint = #1055#1083#1072#1090#1077#1078#1085#1072#1103' '#1089#1080#1089#1090#1077#1084#1072', '#1087#1086' '#1082#1086#1090#1086#1088#1086#1081' '#1087#1088#1086#1074#1086#1076#1080#1090#1089#1103' '#1087#1083#1072#1090#1077#1078
            Width = 100
          end>
      end
    end
    object tsBM: TTabSheet
      Caption = #1055#1088#1086#1095#1080#1077' ('#1056#1053#1050#1054')'
      ImageIndex = 1
      object GridTelephoneBM: TDBGridEh
        Left = 0
        Top = 0
        Width = 671
        Height = 575
        Align = alClient
        DataSource = dsTelephoneBM
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
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        UseMultiTitle = True
        OnGetCellParams = GridTelephoneBMGetCellParams
        OnSortMarkingChanged = GridTelephoneBMSortMarkingChanged
        Columns = <
          item
            EditButtons = <>
            FieldName = 'REQ_ID'
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Hint = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'REQ_STATE'
            Footer.Alignment = taLeftJustify
            Footer.Value = #1079#1072#1087#1080#1089#1077#1081
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Hint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'REQ_DATE'
            Footers = <>
            Title.Hint = #1044#1072#1090#1072' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 110
          end
          item
            EditButtons = <>
            FieldName = 'REQ_STAMP'
            Footers = <>
            Title.Hint = #1042#1088#1077#1084#1103' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'ANS_STAMP'
            Footers = <>
            Title.Hint = #1042#1088#1077#1084#1103' '#1086#1090#1074#1077#1090#1072
            Title.TitleButton = True
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'UNDO_STAMP'
            Footers = <>
            Title.Hint = #1042#1088#1077#1084#1103' '#1086#1090#1084#1077#1085#1099' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'LSID'
            Footers = <>
            Title.Hint = #1057#1077#1089#1089#1080#1103' '#1083#1080#1089#1090#1077#1085#1077#1088#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'REQ_TYPE'
            Footers = <>
            Title.Hint = #1058#1080#1087' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'RESULT'
            Footers = <>
            Title.Hint = #1050#1086#1076' '#1074#1086#1079#1074#1072#1090#1072' '#1079#1072#1087#1088#1086#1089#1072
            Title.TitleButton = True
            Width = 60
          end
          item
            EditButtons = <>
            FieldName = 'ERRMSG'
            Footers = <>
            Title.Hint = #1057#1086#1086#1073#1097#1077#1085#1080#1077' '#1086#1073' '#1086#1096#1080#1073#1082#1077
            Title.TitleButton = True
            Width = 250
          end
          item
            EditButtons = <>
            FieldName = 'OPER_TYPE'
            Footers = <>
            Title.Hint = #1058#1080#1087' '#1086#1087#1077#1088#1072#1094#1080#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'UNO'
            Footers = <>
            Title.Hint = 'UNO '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1085#1072' '#1086#1087#1083#1072#1090#1091
            Title.TitleButton = True
            Width = 80
          end
          item
            EditButtons = <>
            FieldName = 'PPP_ID'
            Footers = <>
            Title.Hint = #1055#1055#1055', '#1075#1076#1077' '#1089#1086#1074#1077#1088#1096#1072#1077#1090#1089#1103' '#1086#1087#1077#1088#1072#1094#1080#1103
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'USER_ID'
            Footers = <>
            Title.Hint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100', '#1089#1086#1074#1077#1088#1096#1072#1102#1097#1080#1081' '#1086#1087#1077#1088#1072#1094#1080#1102
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'PROG_ID'
            Footers = <>
            Title.Hint = #1040#1056#1052' '#1080#1079' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1072' '#1086#1087#1077#1088#1072#1094#1080#1103
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'AGENT_ID'
            Footers = <>
            Title.Hint = #1040#1075#1077#1085#1090', '#1074' '#1082#1086#1090#1086#1088#1086#1084' '#1089#1086#1074#1077#1088#1096#1077#1085#1072' '#1086#1087#1077#1088#1072#1094#1080#1103
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'PRV_ID'
            Footers = <>
            Title.Hint = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'SRVNUM'
            Footers = <>
            Title.Hint = #1053#1086#1084#1077#1088' '#1091#1089#1083#1091#1075#1080
            Title.TitleButton = True
            Width = 70
          end
          item
            EditButtons = <>
            FieldName = 'ACC_PU'
            Footers = <>
            Title.Hint = #1057#1095#1077#1090' '#1072#1073#1086#1085#1077#1085#1090#1072' '#1074' '#1089#1080#1089#1090#1077#1084#1077' '#1055#1059
            Title.TitleButton = True
            Width = 130
          end
          item
            EditButtons = <>
            FieldName = 'SUMM'
            Footers = <>
            Title.Hint = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            Title.TitleButton = True
            Width = 50
          end
          item
            EditButtons = <>
            FieldName = 'OUTP'
            Footers = <>
            Title.Hint = #1048#1089#1093#1086#1076#1103#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
            Title.TitleButton = True
            Width = 400
          end
          item
            EditButtons = <>
            FieldName = 'INP'
            Footers = <>
            Title.Hint = #1042#1093#1086#1076#1103#1097#1080#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
            Title.TitleButton = True
            Width = 400
          end>
      end
    end
  end
  object dsTelephoneINV_BILLING: TDataSource
    DataSet = mdTelephoneINV_BILLING
    Left = 294
    Top = 232
  end
  object mdTelephoneBM: TRxMemoryData
    FieldDefs = <>
    Left = 334
    Top = 200
    object mdTelephoneBMREQ_ID: TIntegerField
      FieldName = 'REQ_ID'
    end
    object mdTelephoneBMREQ_STATE: TIntegerField
      FieldName = 'REQ_STATE'
    end
    object mdTelephoneBMREQ_DATE: TDateTimeField
      FieldName = 'REQ_DATE'
    end
    object mdTelephoneBMREQ_STAMP: TIntegerField
      FieldName = 'REQ_STAMP'
    end
    object mdTelephoneBMANS_STAMP: TIntegerField
      FieldName = 'ANS_STAMP'
    end
    object mdTelephoneBMUNO_STAMP: TIntegerField
      FieldName = 'UNDO_STAMP'
    end
    object mdTelephoneBMLSID: TIntegerField
      FieldName = 'LSID'
    end
    object mdTelephoneBMREQ_TYPE: TIntegerField
      FieldName = 'REQ_TYPE'
    end
    object mdTelephoneBMRESULT: TIntegerField
      FieldName = 'RESULT'
    end
    object mdTelephoneBMERRMSG: TStringField
      FieldName = 'ERRMSG'
      Size = 100
    end
    object mdTelephoneBMOPER_TYPE: TIntegerField
      FieldName = 'OPER_TYPE'
    end
    object mdTelephoneBMUNO: TFloatField
      FieldName = 'UNO'
    end
    object mdTelephoneBMPPP_ID: TIntegerField
      FieldName = 'PPP_ID'
    end
    object mdTelephoneBMUSER_ID: TIntegerField
      FieldName = 'USER_ID'
    end
    object mdTelephoneBMPROG_ID: TIntegerField
      FieldName = 'PROG_ID'
    end
    object mdTelephoneBMAGENT_ID: TIntegerField
      FieldName = 'AGENT_ID'
    end
    object mdTelephoneBMPRV_ID: TIntegerField
      FieldName = 'PRV_ID'
    end
    object mdTelephoneBMSRVNUM: TIntegerField
      FieldName = 'SRVNUM'
    end
    object mdTelephoneBMACC_PU: TStringField
      FieldName = 'ACC_PU'
      Size = 200
    end
    object mdTelephoneBMSUMM: TFloatField
      FieldName = 'SUMM'
    end
    object mdTelephoneBMOUTP: TStringField
      FieldName = 'OUTP'
      Size = 2000
    end
    object mdTelephoneBMINP: TStringField
      FieldName = 'INP'
      Size = 2000
    end
  end
  object dsTelephoneBM: TDataSource
    DataSet = mdTelephoneBM
    Left = 334
    Top = 232
  end
  object mdTelephoneINV_BILLING: TRxMemoryData
    FieldDefs = <>
    Left = 294
    Top = 200
    object IntegerField1: TIntegerField
      FieldName = 'REQ_ID'
    end
    object IntegerField2: TIntegerField
      FieldName = 'REQ_STATE'
    end
    object DateTimeField1: TDateTimeField
      FieldName = 'REQ_DATE'
    end
    object IntegerField6: TIntegerField
      FieldName = 'LSID'
    end
    object IntegerField7: TIntegerField
      FieldName = 'REQ_TYPE'
    end
    object IntegerField8: TIntegerField
      FieldName = 'RESULT'
    end
    object StringField1: TStringField
      FieldName = 'ERRMSG'
      Size = 100
    end
    object IntegerField9: TIntegerField
      FieldName = 'OPER_TYPE'
    end
    object FloatField1: TFloatField
      FieldName = 'UNO'
    end
    object IntegerField10: TIntegerField
      FieldName = 'PPP_ID'
    end
    object IntegerField11: TIntegerField
      FieldName = 'USER_ID'
    end
    object IntegerField12: TIntegerField
      FieldName = 'PROG_ID'
    end
    object IntegerField13: TIntegerField
      FieldName = 'AGENT_ID'
    end
    object IntegerField14: TIntegerField
      FieldName = 'PRV_ID'
    end
    object IntegerField15: TIntegerField
      FieldName = 'SRVNUM'
    end
    object StringField2: TStringField
      FieldName = 'ACC_PU'
      Size = 200
    end
    object FloatField2: TFloatField
      FieldName = 'SUMM'
    end
    object StringField3: TStringField
      FieldName = 'OUTP'
      Size = 2000
    end
    object StringField4: TStringField
      FieldName = 'INP'
      Size = 2000
    end
    object mdTelephoneINV_BILLINGREQ_AG_ID: TStringField
      FieldName = 'REQ_AG_ID'
      Size = 50
    end
    object mdTelephoneINV_BILLINGAG_UNO: TStringField
      FieldName = 'AG_UNO'
      Size = 50
    end
    object mdTelephoneINV_BILLINGREQ_PR_ID: TStringField
      FieldName = 'REQ_PR_ID'
      Size = 50
    end
    object mdTelephoneINV_BILLINGPR_UNO: TStringField
      FieldName = 'PR_UNO'
      Size = 50
    end
    object mdTelephoneINV_BILLINGBILLING_AGENT_ID: TFloatField
      FieldName = 'BILLING_AGENT_ID'
    end
    object mdTelephoneINV_BILLINGPARTNER_AG_ID: TFloatField
      FieldName = 'PARTNER_AG_ID'
    end
    object mdTelephoneINV_BILLINGINNER_ERR_ID: TFloatField
      FieldName = 'INNER_ERR_ID'
    end
    object mdTelephoneINV_BILLINGBILLING_ERR_CODE: TStringField
      FieldName = 'BILLING_ERR_CODE'
      Size = 100
    end
    object mdTelephoneINV_BILLINGSUMM_COMISS: TFloatField
      FieldName = 'SUMM_COMISS'
    end
    object mdTelephoneINV_BILLINGPAY_SYSTEM_ID: TFloatField
      FieldName = 'PAY_SYSTEM_ID'
    end
  end
end
