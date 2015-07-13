object frmAbonent: TfrmAbonent
  Left = 318
  Top = 134
  Width = 868
  Height = 645
  ActiveControl = cbService
  Caption = #1040#1073#1086#1085#1077#1085#1090#1099
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
    Height = 618
    Align = alLeft
    BevelInner = bvLowered
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = pnlFilterResize
    object lblFIO: TLabel
      Left = 10
      Top = 110
      Width = 30
      Height = 13
      Caption = #1060#1048#1054':'
    end
    object lblService: TLabel
      Left = 10
      Top = 30
      Width = 39
      Height = 13
      Caption = #1059#1089#1083#1091#1075#1072':'
    end
    object lblSubSrv: TLabel
      Left = 10
      Top = 70
      Width = 56
      Height = 13
      Caption = #1055#1086#1076#1091#1089#1083#1091#1075#1072':'
    end
    object lblCity: TLabel
      Left = 10
      Top = 150
      Width = 33
      Height = 13
      Caption = #1043#1086#1088#1086#1076':'
    end
    object lblStreet: TLabel
      Left = 10
      Top = 190
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
    object edFIO: TDBEditEh
      Left = 10
      Top = 125
      Width = 161
      Height = 19
      CharCase = ecUpperCase
      EditButtons = <>
      Flat = True
      TabOrder = 3
      Visible = True
      OnChange = cbSubSrvChange
    end
    object cbVisibleBuhInfo: TCheckBox
      Left = 10
      Top = 230
      Width = 170
      Height = 17
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1080' '#1087#1083#1072#1090#1077#1078#1080
      TabOrder = 6
      OnClick = cbVisibleBuhInfoClick
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
    object cbCity: TDBComboBoxEh
      Left = 10
      Top = 165
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 4
      Visible = True
      OnChange = cbSubSrvChange
    end
    object cbSubSrv: TDBComboBoxEh
      Left = 10
      Top = 85
      Width = 161
      Height = 19
      DropDownBox.Rows = 12
      EditButtons = <>
      Flat = True
      TabOrder = 2
      Visible = True
      OnChange = cbSubSrvChange
    end
    object edStreet: TDBEditEh
      Left = 10
      Top = 205
      Width = 161
      Height = 19
      CharCase = ecUpperCase
      EditButtons = <>
      Flat = True
      TabOrder = 5
      Visible = True
      OnChange = cbSubSrvChange
    end
  end
  object SplitterVertical: TRxSplitter
    Left = 179
    Top = 0
    Width = 4
    Height = 618
    ControlFirst = pnlFilter
    Align = alLeft
    BevelOuter = bvNone
  end
  object pnlGrid: TPanel
    Left = 183
    Top = 0
    Width = 677
    Height = 618
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object GridAbonent: TDBGridEh
      Left = 0
      Top = 0
      Width = 677
      Height = 364
      Align = alClient
      DataSource = dsAbonent
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
      PopupMenu = pmAbonent
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      UseMultiTitle = True
      OnCellClick = GridAbonentCellClick
      OnDblClick = AcEditExecute
      OnGetCellParams = GridAbonentGetCellParams
      OnSortMarkingChanged = GridAbonentSortMarkingChanged
      Columns = <
        item
          Checkboxes = True
          EditButtons = <>
          FieldName = 'IS_ACC_LOCK'
          Footer.ValueType = fvtStaticText
          Footers = <>
          KeyList.Strings = (
            '1'
            '0')
          ReadOnly = True
          Title.Caption = #1053#1072' '#1079#1072#1082#1088'.'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'MS Sans Serif'
          Title.Font.Style = [fsBold]
          Title.TitleButton = True
          Width = 45
        end
        item
          Checkboxes = True
          EditButtons = <>
          FieldName = 'IS_ACC_CLOSE'
          Footer.Alignment = taLeftJustify
          Footer.Value = #1079#1072#1087#1080#1089#1077#1081
          Footer.ValueType = fvtStaticText
          Footers = <>
          KeyList.Strings = (
            '1'
            '0')
          ReadOnly = True
          Title.Caption = #1047#1072#1082#1088'.'
          Title.TitleButton = True
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'SERVICE_ID'
          Footers = <>
          Visible = False
          Width = 70
        end
        item
          EditButtons = <>
          FieldName = 'SUBSRV_ID'
          Footers = <>
          Visible = False
          Width = 70
        end
        item
          EditButtons = <>
          FieldName = 'ABONENT_ID'
          Footers = <>
          Title.Caption = 'ID'
          Title.TitleButton = True
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'SERVICE'
          Footer.Font.Charset = DEFAULT_CHARSET
          Footer.Font.Color = clRed
          Footer.Font.Height = -11
          Footer.Font.Name = 'MS Sans Serif'
          Footer.Font.Style = []
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = #1059#1089#1083#1091#1075#1072
          Title.TitleButton = True
          Width = 300
        end
        item
          EditButtons = <>
          FieldName = 'SUB_SRV'
          Footers = <>
          Title.Caption = #1055#1086#1076#1091#1089#1083#1091#1075#1072
          Title.TitleButton = True
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'ACC_PU'
          Footers = <>
          Title.Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090'|'#1053#1086#1084#1077#1088
          Title.TitleButton = True
          Width = 150
        end
        item
          EditButtons = <>
          FieldName = 'OPEN_TIME'
          Footers = <>
          Title.Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090'|'#1057#1086#1079#1076#1072#1085
          Title.TitleButton = True
          Width = 120
        end
        item
          EditButtons = <>
          FieldName = 'CLOSE_TIME'
          Footers = <>
          Title.Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090'|'#1047#1072#1082#1088#1099#1090
          Title.TitleButton = True
          Width = 120
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
          DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
          EditButtons = <>
          FieldName = 'BALANCE'
          Footer.EndEllipsis = True
          Footer.ValueType = fvtStaticText
          Footer.WordWrap = True
          Footers = <>
          Title.Caption = #1057#1072#1083#1100#1076#1086
          Title.TitleButton = True
          Width = 100
        end>
    end
    object pnlBuhInfo: TPanel
      Left = 0
      Top = 368
      Width = 677
      Height = 250
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object PageControl: TPageControl
        Left = 0
        Top = 0
        Width = 677
        Height = 250
        ActivePage = tsSaldo
        Align = alClient
        Style = tsFlatButtons
        TabIndex = 0
        TabOrder = 0
        object tsSaldo: TTabSheet
          Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
          object GridSaldo: TDBGridEh
            Left = 0
            Top = 25
            Width = 669
            Height = 194
            Align = alClient
            DataSource = dsSaldo
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
            PopupMenu = pmSaldo
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            UseMultiTitle = True
            OnDblClick = AcEditSaldoExecute
            OnSortMarkingChanged = GridSaldoSortMarkingChanged
            Columns = <
              item
                EditButtons = <>
                FieldName = 'SALDO_ID'
                Footer.FieldName = 'SALDO_ID'
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = 'ID'
                Title.TitleButton = True
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'PERIOD_BEGIN'
                Footer.Value = #1079#1072#1087#1080#1089#1077#1081
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = #1055#1077#1088#1080#1086#1076' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081'|'#1053#1072#1095#1072#1083#1086
                Title.TitleButton = True
                Width = 70
              end
              item
                EditButtons = <>
                FieldName = 'PERIOD_END'
                Footers = <>
                Title.Caption = #1055#1077#1088#1080#1086#1076' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081'|'#1050#1086#1085#1077#1094
                Title.TitleButton = True
                Width = 70
              end
              item
                DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
                EditButtons = <>
                FieldName = 'SUMM'
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 100
              end
              item
                Checkboxes = True
                EditButtons = <>
                FieldName = 'IS_EXPORT'
                Footers = <>
                KeyList.Strings = (
                  '1'
                  '0')
                ReadOnly = True
                Title.Caption = #1042#1099#1075#1088#1091#1078'.'
                Visible = False
                Width = 45
              end
              item
                EditButtons = <>
                FieldName = 'EXPORT_DATE'
                Footers = <>
                ReadOnly = True
                Title.Caption = #1044#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
                Title.TitleButton = True
                Width = 75
              end>
          end
          object pnlSaldoControl: TPanel
            Left = 0
            Top = 0
            Width = 669
            Height = 25
            Align = alTop
            BevelOuter = bvNone
            Caption = 'pnlSaldoControl'
            TabOrder = 1
            object DockSaldo: TDock97
              Left = 0
              Top = 0
              Width = 669
              Height = 28
              BoundLines = [blTop, blBottom, blLeft, blRight]
              object SaldoToolbar: TToolbar97
                Left = 0
                Top = 0
                Hint = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1087#1086#1076#1091#1089#1083#1091#1075
                Caption = #1055#1072#1085#1077#1083#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1103' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
                CloseButton = False
                DockMode = dmCannotFloatOrChangeDocks
                DockPos = 0
                DragHandleStyle = dhNone
                FullSize = True
                ParentShowHint = False
                ShowCaption = False
                ShowHint = True
                TabOrder = 0
                object btnRefresh: TToolbarButton97
                  Left = 69
                  Top = 0
                  Width = 23
                  Height = 22
                  Action = AcRefreshSaldo
                  DisplayMode = dmGlyphOnly
                  Glyph.Data = {00000000}
                  GlyphMask.Data = {00000000}
                  Images = ImageList
                end
                object btnAdd: TToolbarButton97
                  Left = 0
                  Top = 0
                  Width = 23
                  Height = 22
                  Action = AcAddSaldo
                  DisplayMode = dmGlyphOnly
                  Glyph.Data = {00000000}
                  GlyphMask.Data = {00000000}
                  Images = ImageList
                end
                object btnEdit: TToolbarButton97
                  Left = 23
                  Top = 0
                  Width = 23
                  Height = 22
                  Action = AcEditSaldo
                  DisplayMode = dmGlyphOnly
                  Glyph.Data = {00000000}
                  GlyphMask.Data = {00000000}
                  Images = ImageList
                end
                object btnDelete: TToolbarButton97
                  Left = 46
                  Top = 0
                  Width = 23
                  Height = 22
                  Action = AcDeleteSaldo
                  DisplayMode = dmGlyphOnly
                  Glyph.Data = {00000000}
                  GlyphMask.Data = {00000000}
                  Images = ImageList
                end
              end
            end
          end
        end
        object tsPay: TTabSheet
          Caption = #1055#1083#1072#1090#1077#1078#1080
          ImageIndex = 1
          object GridPay: TDBGridEh
            Left = 0
            Top = 0
            Width = 669
            Height = 219
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
            TabOrder = 0
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
                Footer.FieldName = 'PAY_ID'
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
                FieldName = 'DATE_PAY'
                Footer.Alignment = taRightJustify
                Footers = <>
                Title.Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
                Title.TitleButton = True
                Width = 75
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
              end
              item
                DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
                EditButtons = <>
                FieldName = 'SUMM'
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = #1057#1091#1084#1084#1072
                Title.TitleButton = True
                Width = 100
              end
              item
                DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
                EditButtons = <>
                FieldName = 'BALANCE'
                Footers = <>
                Title.Caption = #1057#1072#1083#1100#1076#1086' '#1074' '#1089#1080#1089#1090#1077#1084#1077' '#1043#1054#1056#1054#1044
                Width = 100
              end>
          end
        end
        object tbGraph: TTabSheet
          Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072
          ImageIndex = 2
          object pnlEGraph: TPanel
            Left = 0
            Top = 0
            Width = 669
            Height = 219
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 0
          end
        end
      end
    end
    object SplitterHorizontal: TRxSplitter
      Left = 0
      Top = 364
      Width = 677
      Height = 4
      ControlFirst = pnlBuhInfo
      Align = alBottom
      BevelOuter = bvNone
    end
  end
  object mdAbonent: TRxMemoryData
    FieldDefs = <>
    AfterScroll = mdAbonentAfterScroll
    Left = 366
    Top = 126
    object mdAbonentABONENT_ID: TStringField
      FieldName = 'ABONENT_ID'
    end
    object mdAbonentSERVICE_ID: TIntegerField
      FieldName = 'SERVICE_ID'
    end
    object mdAbonentSUB_SRV_ID: TIntegerField
      FieldName = 'SUBSRV_ID'
    end
    object mdAbonentSERVICE: TStringField
      FieldName = 'SERVICE'
      Size = 70
    end
    object mdAbonentSUB_SRV: TStringField
      FieldName = 'SUB_SRV'
      Size = 70
    end
    object mdAbonentFIO: TStringField
      FieldName = 'FIO'
      Size = 70
    end
    object mdAbonentCITY: TStringField
      FieldName = 'CITY'
      Size = 70
    end
    object mdAbonentSTREET: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object mdAbonentBUILDING: TStringField
      FieldName = 'BUILDING'
      Size = 10
    end
    object mdAbonentAPARTMENT: TStringField
      FieldName = 'APARTMENT'
      Size = 7
    end
    object mdAbonentACC_PU: TStringField
      FieldName = 'ACC_PU'
      Size = 40
    end
    object mdAbonentOPEN_TIME: TDateTimeField
      FieldName = 'OPEN_TIME'
    end
    object mdAbonentCLOSE_TIME: TDateTimeField
      FieldName = 'CLOSE_TIME'
    end
    object mdAbonentIS_ACC_LOCK: TSmallintField
      FieldName = 'IS_ACC_LOCK'
    end
    object mdAbonentIS_ACC_CLOSE: TSmallintField
      FieldName = 'IS_ACC_CLOSE'
    end
    object mdAbonentBALANCE: TFloatField
      FieldName = 'BALANCE'
    end
  end
  object dsAbonent: TDataSource
    DataSet = mdAbonent
    Left = 364
    Top = 164
  end
  object mdSaldo: TRxMemoryData
    FieldDefs = <>
    AfterScroll = mdSaldoAfterScroll
    Left = 254
    Top = 482
    object ID: TIntegerField
      FieldName = 'SALDO_ID'
    end
    object mdSaldoPERIOD_BEGIN: TDateField
      FieldName = 'PERIOD_BEGIN'
    end
    object mdSaldoPERIOD_END: TDateField
      FieldName = 'PERIOD_END'
    end
    object mdSaldoSUMM: TFloatField
      FieldName = 'SUMM'
    end
    object mdSaldoIS_EXPORT: TSmallintField
      FieldName = 'IS_EXPORT'
    end
    object mdSaldoEXPORT_DATE: TDateField
      FieldName = 'EXPORT_DATE'
    end
  end
  object dsSaldo: TDataSource
    DataSet = mdSaldo
    Left = 254
    Top = 522
  end
  object pmAbonent: TPopupMenu
    Images = frmMain.ImageList
    OnPopup = pmAbonentPopup
    Left = 410
    Top = 126
    object pmAbonentAdd: TMenuItem
      Action = frmMain.AcAdd
    end
    object pmAbonentEdit: TMenuItem
      Action = frmMain.AcEdit
    end
    object pmAbonentDelete: TMenuItem
      Action = frmMain.AcDelete
    end
    object pmAccountStatement: TMenuItem
      Caption = #1042#1099#1087#1080#1089#1082#1072' '#1087#1086' '#1089#1095#1077#1090#1091
      OnClick = pmAccountStatementClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pmAbonentRefresh: TMenuItem
      Action = frmMain.AcRefresh
    end
  end
  object ImageList: TImageList
    Left = 378
    Top = 482
    Bitmap = {
      494C010104000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
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
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000CECE
      CE00F7F7F700F7F7F700E7E7E700E7E7E700DEDEDE00D6D6D600A5A5A5000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00F7F7F700F7F7F700E7E7E700E7E7E700DEDEDE00D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000084848400FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00F7F7F700F7F7F700E7E7E700E7E7E700D6D6D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000F7F7F700FFFFFF0084848400FFFFFF00000000000000000084848400A5A5
      A50000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00F7F7F700D6D6D600BDBDBD00BDBDBD00BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000E7E7
      E700E7E7E700BDBDBD000000000000000000000000000000000000000000BDBD
      BD00A5A5A500000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000BDBDBD00BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000CECECE00E7E7
      E700BDBDBD00000000000000000000000000000000000000000000000000CECE
      CE00BDBDBD00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000F7F7F700BDBDBD0000000000BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000CECECE00D6D6
      D60000000000000000000000000000000000000000000000000000000000D6D6
      D600CECECE00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF00F7F7F700BDBDBD00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000BDBDBD00CECE
      CE00000000000000000000000000000000000000000000000000BDBDBD00E7E7
      E700CECECE00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00CECECE0000000000FFFFFF00F7F7F700BDBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF0000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000A5A5A500BDBD
      BD000000000000000000000000000000000000000000BDBDBD00E7E7E700E7E7
      E70000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      000000000000000000000000000000000000000000000000000000000000BDBD
      BD00FFFFFF00FFFFFF00DEDEDE00CECECE0000000000FFFFFF00F7F7F700BDBD
      BD00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000A5A5
      A500848484000000000000000000FFFFFF0084848400FFFFFF00F7F7F7000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00F7F7
      F700BDBDBD000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF0084848400000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00000000000000
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
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFF80FFFFFFFFFFFFFF007FFFF
      C007C00FF007F07FC007C00FF007F07FC007C00FF007E007C007C00FF007C003
      C007C00FF0078003C007C00FF00781C3C007C00FF0078383C007C00FF0078703
      C007C00FF0078003C007C007E0038007C00FC003E003C00FC01FFFC3F007FC1F
      C03FFFE7FE3FFC1FFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object SaldoActions: TActionList
    Images = ImageList
    Left = 342
    Top = 482
    object AcAddSaldo: TAction
      Category = 'Data'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      ImageIndex = 0
      OnExecute = AcAddSaldoExecute
    end
    object AcEditSaldo: TAction
      Category = 'Data'
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100
      Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1079#1072#1087#1080#1089#1100
      ImageIndex = 1
      OnExecute = AcEditSaldoExecute
    end
    object AcDeleteSaldo: TAction
      Category = 'Data'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1079#1072#1087#1080#1089#1100
      ImageIndex = 2
      OnExecute = AcDeleteSaldoExecute
    end
    object AcRefreshSaldo: TAction
      Category = 'Data'
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 3
      OnExecute = AcRefreshSaldoExecute
    end
  end
  object pmSaldo: TPopupMenu
    Images = ImageList
    Left = 292
    Top = 482
    object pmSaldoAdd: TMenuItem
      Action = AcAddSaldo
    end
    object pmSaldoEdit: TMenuItem
      Action = AcEditSaldo
    end
    object pmSaldoDelete: TMenuItem
      Action = AcDeleteSaldo
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object pmSaldoRefresh: TMenuItem
      Action = AcRefreshSaldo
    end
  end
  object dsPay: TDataSource
    DataSet = mdPay
    Left = 480
    Top = 524
  end
  object mdPay: TRxMemoryData
    FieldDefs = <>
    Left = 480
    Top = 484
    object mdPayPAY_ID: TIntegerField
      FieldName = 'PAY_ID'
    end
    object mdPayREE_ID: TIntegerField
      FieldName = 'REE_ID'
    end
    object mdPayDATE_PAY: TDateField
      FieldName = 'DATE_PAY'
    end
    object mdPayAGENT: TStringField
      FieldName = 'AGENT'
      Size = 255
    end
    object mdPayUNO: TStringField
      FieldName = 'UNO'
      Size = 15
    end
    object mdPaySUMM: TFloatField
      FieldName = 'SUMM'
    end
    object mdPayBALANCE: TFloatField
      FieldName = 'BALANCE'
    end
  end
  object xlAccStatement: TxlReport
    DataExportMode = xdmDDE
    Options = [xroDisplayAlerts, xroAutoOpen]
    XLSTemplate = '.\Reports\AccountStatement.xlt'
    DataSources = <
      item
        DataSet = mdAccStatement
        Alias = 'mdAccStatement'
        Range = 'SourceRange'
        Options = [xrgoAutoOpen, xrgoPreserveRowHeight]
        Tag = 0
      end>
    Preview = False
    Params = <
      item
        Name = 'ACC_PU'
        Value = ''
      end
      item
        Name = 'FIO'
        Value = ''
      end
      item
        Name = 'BALANCE'
        Value = 0
      end>
    Left = 554
    Top = 168
  end
  object mdAccStatement: TRxMemoryData
    FieldDefs = <>
    Left = 500
    Top = 126
    object mdAccStatementTXT: TStringField
      DisplayWidth = 100
      FieldName = 'TXT'
      Size = 100
    end
    object mdAccStatementREG_DATE: TDateField
      FieldName = 'REG_DATE'
    end
    object mdAccStatementSUMM_SALDO: TFloatField
      FieldName = 'SUMM_SALDO'
    end
    object mdAccStatementSUMM_PAY: TFloatField
      FieldName = 'SUMM_PAY'
    end
    object mdAccStatementNOTE: TStringField
      DisplayWidth = 100
      FieldName = 'NOTE'
      Size = 100
    end
  end
  object xlExcel: TxlReport
    DataExportMode = xdmDDE
    Options = [xroDisplayAlerts, xroAutoOpen]
    XLSTemplate = '.\Reports\Abonents.xlt'
    DataSources = <
      item
        DataSet = mdAbonent
        Alias = 'mdAbonent'
        Range = 'SourceRange'
        Options = [xrgoAutoOpen, xrgoPreserveRowHeight]
        Tag = 0
      end>
    Preview = False
    Params = <>
    Left = 554
    Top = 128
  end
end
