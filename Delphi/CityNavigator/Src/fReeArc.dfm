object frmReeArc: TfrmReeArc
  Left = 261
  Top = 185
  Width = 870
  Height = 640
  ActiveControl = edService
  Caption = #1040#1088#1093#1080#1074' '#1088#1077#1077#1089#1090#1088#1086#1074
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
    object lblService: TLabel
      Left = 10
      Top = 30
      Width = 39
      Height = 13
      Caption = #1059#1089#1083#1091#1075#1072':'
    end
    object lblPeriod: TLabel
      Left = 10
      Top = 150
      Width = 38
      Height = 13
      Caption = #1055#1077#1088#1080#1086#1076
    end
    object lblPeriodStart: TLabel
      Left = 10
      Top = 170
      Width = 9
      Height = 13
      Caption = 'c:'
    end
    object lblPeriodEnd: TLabel
      Left = 10
      Top = 195
      Width = 15
      Height = 13
      Caption = #1087#1086':'
    end
    object lblError: TLabel
      Left = 10
      Top = 215
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
    object lblType: TLabel
      Left = 10
      Top = 70
      Width = 66
      Height = 13
      Caption = #1058#1080#1087' '#1088#1077#1077#1089#1090#1088#1072':'
    end
    object lblStatus: TLabel
      Left = 10
      Top = 110
      Width = 101
      Height = 13
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1088#1077#1077#1089#1090#1088#1072':'
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
      Top = 165
      Width = 119
      Height = 19
      EditButtons = <>
      Flat = True
      Kind = dtkDateTimeEh
      TabOrder = 4
      Visible = True
      OnChange = edServiceChange
    end
    object edPeriodEnd: TDBDateTimeEditEh
      Left = 30
      Top = 190
      Width = 119
      Height = 19
      EditButtons = <>
      Flat = True
      Kind = dtkDateTimeEh
      TabOrder = 5
      Visible = True
      OnChange = edServiceChange
    end
    object cbType: TDBComboBoxEh
      Left = 10
      Top = 85
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 2
      Visible = True
      OnChange = edServiceChange
    end
    object cbStatus: TDBComboBoxEh
      Left = 10
      Top = 125
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 3
      Visible = True
      OnChange = edServiceChange
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
  object GridReeArc: TDBGridEh
    Left = 183
    Top = 0
    Width = 679
    Height = 606
    Align = alClient
    DataSource = dsReeArc
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
    OnGetCellParams = GridReeArcGetCellParams
    OnSortMarkingChanged = GridReeArcSortMarkingChanged
    Columns = <
      item
        EditButtons = <>
        FieldName = 'ID'
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = 'ID '#1088#1077#1077#1089#1090#1088#1072
        Title.TitleButton = True
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'REE_NUM'
        Footer.Alignment = taLeftJustify
        Footer.Value = #1079#1072#1087#1080#1089#1077#1081
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1053#1086#1084#1077#1088' '#1088#1077#1077#1089#1090#1088#1072
        Title.TitleButton = True
        Width = 70
      end
      item
        EditButtons = <>
        FieldName = 'ORG'
        Footer.Font.Charset = DEFAULT_CHARSET
        Footer.Font.Color = clRed
        Footer.Font.Height = -11
        Footer.Font.Name = 'MS Sans Serif'
        Footer.Font.Style = []
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1040#1075#1077#1085#1090' / '#1055#1059
        Title.TitleButton = True
        Width = 260
      end
      item
        EditButtons = <>
        FieldName = 'GOTB'
        Footers = <>
        Title.Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103' / '#1088#1072#1079#1073#1086#1088#1072
        Title.TitleButton = True
        Width = 110
      end
      item
        EditButtons = <>
        FieldName = 'SERVICE'
        Footers = <>
        Title.Caption = #1059#1089#1083#1091#1075#1072
        Title.TitleButton = True
        Width = 400
      end
      item
        EditButtons = <>
        FieldName = 'DIRECT'
        Footers = <>
        ImageList = ImageList
        KeyList.Strings = (
          'I'
          'O')
        ReadOnly = True
        Title.Caption = #1053#1072#1087#1088'.'
        Title.TitleButton = True
        Width = 35
      end
      item
        EditButtons = <>
        FieldName = 'TYPE'
        Footers = <>
        Title.Caption = #1058#1080#1087' '#1088#1077#1077#1089#1090#1088#1072
        Title.TitleButton = True
        Width = 120
      end
      item
        EditButtons = <>
        FieldName = 'STATUS'
        Footers = <>
        Title.Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1088#1077#1077#1089#1090#1088#1072
        Title.TitleButton = True
        Width = 130
      end
      item
        EditButtons = <>
        FieldName = 'RECCOUNT'
        Footers = <>
        Title.Caption = #1042#1089#1077#1075#1086' '#1079#1072#1087#1080#1089#1077#1081
        Title.TitleButton = True
        Width = 60
      end
      item
        EditButtons = <>
        FieldName = 'GOTREC'
        Footers = <>
        Title.Caption = #1055#1086#1083#1091#1095#1077#1085#1086' '#1079#1072#1087#1080#1089#1077#1081
        Title.TitleButton = True
        Width = 60
      end
      item
        DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
        EditButtons = <>
        FieldName = 'SUMM'
        Footers = <>
        Title.Caption = #1057#1091#1084#1084#1072
        Title.TitleButton = True
        Width = 100
      end>
  end
  object mdReeArc: TRxMemoryData
    FieldDefs = <>
    Left = 334
    Top = 200
    object mdReeArcID: TIntegerField
      FieldName = 'ID'
    end
    object mdReeArcREE_NUM: TIntegerField
      FieldName = 'REE_NUM'
    end
    object mdReeArcORG: TStringField
      FieldName = 'ORG'
      Size = 255
    end
    object mdReeArcGOTB: TDateTimeField
      FieldName = 'GOTB'
    end
    object mdReeArcSERVICE: TStringField
      FieldName = 'SERVICE'
      Size = 100
    end
    object mdReeArcDIRECT: TStringField
      FieldName = 'DIRECT'
      Size = 1
    end
    object mdReeArcTYPE: TStringField
      FieldName = 'TYPE'
      Size = 70
    end
    object mdReeArcSTATUS: TStringField
      FieldName = 'STATUS'
      Size = 50
    end
    object mdReeArcRECCOUNT: TIntegerField
      FieldName = 'RECCOUNT'
    end
    object mdReeArcGOTREC: TIntegerField
      FieldName = 'GOTREC'
    end
    object mdReeArcSUMM: TFloatField
      FieldName = 'SUMM'
    end
  end
  object dsReeArc: TDataSource
    DataSet = mdReeArc
    Left = 334
    Top = 240
  end
  object ImageList: TImageList
    Left = 376
    Top = 200
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000000000000000000000000000000000000000000000000000008000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000800000008080800000000000000000000000000000000000808080008000
      0000000000000000000000000000000000000000000080000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000008000000000000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000000000
      0000000000000000000080000000808080000000000000000000000000000000
      0000800000008080800000000000000000000000000000000000808080008000
      0000000000000000000000000000000000008080800080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008000000080000000800000008000
      0000808080000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000800000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFE7E7FF00000000
      C1F3CF8300000000C3FBDFC300000000C7FBDFE300000000CBFBDFD300000000
      DCF3CF3B00000000FE07E07F00000000FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
end