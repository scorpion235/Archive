object frmMailerTbl: TfrmMailerTbl
  Left = 264
  Top = 114
  Width = 870
  Height = 640
  ActiveControl = edDescription
  Caption = #1056#1072#1089#1089#1099#1083#1082#1072' '#1085#1072' '#1087#1086#1095#1090#1091' (KP.INV$MAILER_TBL)'
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
    object lblDescription: TLabel
      Left = 10
      Top = 30
      Width = 115
      Height = 13
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' (Description):'
    end
    object lblSender: TLabel
      Left = 10
      Top = 70
      Width = 115
      Height = 13
      Caption = #1055#1086#1089#1099#1083#1072#1102#1097#1080#1081' (Sender):'
    end
    object lblReceiver: TLabel
      Left = 10
      Top = 108
      Width = 130
      Height = 13
      Caption = #1055#1088#1080#1085#1080#1084#1072#1102#1097#1080#1081' (Receiver):'
    end
    object edDescription: TDBEditEh
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
      OnKeyUp = edDescriptionKeyUp
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
    object edSender: TDBEditEh
      Left = 10
      Top = 83
      Width = 157
      Height = 19
      Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Visible = True
      OnKeyUp = edSenderKeyUp
    end
    object edReceiver: TDBEditEh
      Left = 10
      Top = 121
      Width = 157
      Height = 19
      Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
      EditButtons = <>
      Flat = True
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Visible = True
      OnKeyUp = edReceiverKeyUp
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
  object GridMailerTbl: TDBGridEh
    Left = 183
    Top = 0
    Width = 679
    Height = 606
    Align = alClient
    DataSource = dsMailerTbl
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
    OnGetCellParams = GridMailerTblGetCellParams
    OnSortMarkingChanged = GridMailerTblSortMarkingChanged
    Columns = <
      item
        EditButtons = <>
        FieldName = 'DESCRIPTION'
        Footer.Alignment = taRightJustify
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.TitleButton = True
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'SENDER'
        Footer.Value = #1079#1072#1087#1080#1089#1077#1081
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.TitleButton = True
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'RECEIVER'
        Footers = <>
        Title.TitleButton = True
        Width = 150
      end
      item
        EditButtons = <>
        FieldName = 'SUBJECT'
        Footers = <>
        Title.TitleButton = True
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'ATTACH_NAME'
        Footers = <>
        Title.TitleButton = True
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'ATT_SAMPLE_NAME'
        Footers = <>
        Title.TitleButton = True
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'BODY_SAMPLE_NAME'
        Footers = <>
        Title.TitleButton = True
        Width = 200
      end
      item
        EditButtons = <>
        FieldName = 'ENC'
        Footers = <>
        Title.TitleButton = True
        Width = 50
      end
      item
        EditButtons = <>
        FieldName = 'MAIN'
        Footers = <>
        Title.TitleButton = True
        Width = 50
      end
      item
        EditButtons = <>
        FieldName = 'KEY_FIELDS'
        Footers = <>
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'KEY_VALUES'
        Footers = <>
        Title.TitleButton = True
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'CONST_FIELDS'
        Footers = <>
        Title.TitleButton = True
        Width = 250
      end
      item
        EditButtons = <>
        FieldName = 'CONST_VALUES'
        Footers = <>
        Title.TitleButton = True
        Width = 300
      end
      item
        EditButtons = <>
        FieldName = 'LASTTIME'
        Footers = <>
        Title.TitleButton = True
        Width = 100
      end
      item
        EditButtons = <>
        FieldName = 'INTERVAL'
        Footers = <>
        Title.TitleButton = True
        Width = 60
      end
      item
        Checkboxes = True
        EditButtons = <>
        FieldName = 'SEND_EMPTY'
        Footers = <>
        KeyList.Strings = (
          'Y'
          'N')
        ReadOnly = True
        Title.TitleButton = True
        Width = 80
      end
      item
        EditButtons = <>
        FieldName = 'POSTEXEC'
        Footers = <>
        Title.TitleButton = True
        Width = 70
      end
      item
        Checkboxes = True
        EditButtons = <>
        FieldName = 'LOCKED'
        Footers = <>
        KeyList.Strings = (
          'Y'
          'N')
        ReadOnly = True
        Title.TitleButton = True
        Width = 50
      end
      item
        EditButtons = <>
        FieldName = 'ORD'
        Footers = <>
        Title.TitleButton = True
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'NOTE'
        Footers = <>
        Title.TitleButton = True
        Width = 40
      end
      item
        EditButtons = <>
        FieldName = 'THREAD'
        Footers = <>
        Title.TitleButton = True
        Width = 50
      end>
  end
  object mdMailerTbl: TRxMemoryData
    FieldDefs = <>
    Left = 334
    Top = 200
    object mdMailerTblDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Size = 2000
    end
    object mdMailerTblSENDER: TStringField
      FieldName = 'SENDER'
      Size = 200
    end
    object mdMailerTblRECEIVER: TStringField
      FieldName = 'RECEIVER'
      Size = 200
    end
    object mdMailerTblSUBJECT: TStringField
      FieldName = 'SUBJECT'
      Size = 200
    end
    object mdMailerTblATTACH_NAME: TStringField
      FieldName = 'ATTACH_NAME'
      Size = 2000
    end
    object mdMailerTblATT_SAMPLE_NAME: TStringField
      FieldName = 'ATT_SAMPLE_NAME'
      Size = 200
    end
    object mdMailerTblBODY_SAMPLE_NAME: TStringField
      FieldName = 'BODY_SAMPLE_NAME'
      Size = 200
    end
    object mdMailerTblENC: TStringField
      FieldName = 'ENC'
      Size = 10
    end
    object mdMailerTblMAIN: TStringField
      FieldName = 'MAIN'
      Size = 10
    end
    object mdMailerTblKEY_FIELDS: TStringField
      FieldName = 'KEY_FIELDS'
      Size = 100
    end
    object mdMailerTblKEY_VALUES: TStringField
      FieldName = 'KEY_VALUES'
      Size = 2000
    end
    object mdMailerTblCONST_FIELDS: TStringField
      FieldName = 'CONST_FIELDS'
      Size = 100
    end
    object mdMailerTblCONST_VALUES: TStringField
      FieldName = 'CONST_VALUES'
      Size = 2000
    end
    object mdMailerTblLASTTIME: TDateTimeField
      FieldName = 'LASTTIME'
    end
    object mdMailerTblINTERVAL: TIntegerField
      FieldName = 'INTERVAL'
    end
    object mdMailerTblSEND_EMPTY: TStringField
      FieldName = 'SEND_EMPTY'
      Size = 1
    end
    object mdMailerTblPOSTEXEC: TStringField
      FieldName = 'POSTEXEC'
      Size = 2000
    end
    object mdMailerTblLOCKED: TStringField
      FieldName = 'LOCKED'
      Size = 1
    end
    object mdMailerTblORD: TIntegerField
      FieldName = 'ORD'
    end
    object mdMailerTblNOTE: TStringField
      FieldName = 'NOTE'
      Size = 30
    end
    object mdMailerTblTHREAD: TIntegerField
      FieldName = 'THREAD'
    end
  end
  object dsMailerTbl: TDataSource
    DataSet = mdMailerTbl
    Left = 334
    Top = 240
  end
end
