object frmUnCorrectStreet: TfrmUnCorrectStreet
  Left = 265
  Top = 115
  Width = 858
  Height = 645
  Caption = #1053#1077#1087#1088#1080#1074#1103#1079#1085#1085#1099#1077' '#1091#1083#1080#1094#1099
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
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pcGreeds: TPageControl
    Left = 0
    Top = 0
    Width = 850
    Height = 618
    ActivePage = tsAutoAttachedStreet
    Align = alClient
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Style = tsFlatButtons
    TabIndex = 2
    TabOrder = 0
    OnChange = pcGreedsChange
    object tsUnCorrectStreet: TTabSheet
      Caption = #1057#1087#1080#1089#1086#1082' '#1091#1083#1080#1094
      object pnlFilterUnCorrectStreet: TPanel
        Left = 0
        Top = 0
        Width = 179
        Height = 587
        Align = alLeft
        BevelInner = bvLowered
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = pnlFilterUnCorrectStreetResize
        object lblOrg: TLabel
          Left = 10
          Top = 30
          Width = 61
          Height = 13
          Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
        end
        object lblCity: TLabel
          Left = 10
          Top = 70
          Width = 33
          Height = 13
          Caption = #1043#1086#1088#1086#1076':'
        end
        object lblStreet: TLabel
          Left = 12
          Top = 110
          Width = 35
          Height = 13
          Caption = #1059#1083#1080#1094#1072':'
        end
        object lblError: TLabel
          Left = 10
          Top = 150
          Width = 137
          Height = 13
          Caption = #1053#1077#1090' '#1087#1088#1072#1074' '#1085#1072' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1091#1083#1080#1094
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
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
        object edCity: TDBEditEh
          Left = 10
          Top = 85
          Width = 157
          Height = 19
          Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
          EditButtons = <>
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          Visible = True
          OnKeyUp = edCityKeyUp
        end
        object edStreet: TDBEditEh
          Left = 10
          Top = 127
          Width = 157
          Height = 19
          Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
          EditButtons = <>
          Flat = True
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          Visible = True
          OnKeyUp = edStreetKeyUp
        end
      end
      object RxSplitter: TRxSplitter
        Left = 179
        Top = 0
        Width = 4
        Height = 587
        ControlFirst = pnlFilterUnCorrectStreet
        Align = alLeft
        BevelOuter = bvNone
      end
      object GridUnCorrectStreet: TDBGridEh
        Left = 183
        Top = 0
        Width = 659
        Height = 587
        Align = alClient
        DataSource = dsUnCorrectStreet
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
        OnSortMarkingChanged = GridUnCorrectStreetSortMarkingChanged
        Columns = <
          item
            EditButtons = <>
            FieldName = 'ORG'
            Footer.Alignment = taRightJustify
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            Title.TitleButton = True
            Width = 300
          end
          item
            EditButtons = <>
            FieldName = 'CITY'
            Footer.Value = #1079#1072#1087#1080#1089#1077#1081
            Footer.ValueType = fvtStaticText
            Footers = <>
            Title.Caption = #1043#1086#1088#1086#1076
            Title.TitleButton = True
            Width = 200
          end
          item
            EditButtons = <>
            FieldName = 'STREET'
            Footers = <>
            Title.Caption = #1059#1083#1080#1094#1072
            Title.TitleButton = True
            Width = 200
          end>
      end
    end
    object tsHandAttachedStreet: TTabSheet
      Caption = #1056#1091#1095#1085#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072
      ImageIndex = 1
      object pnlFilterHandAttachedStreet: TPanel
        Left = 0
        Top = 0
        Width = 842
        Height = 90
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        OnResize = pnlFilterUnCorrectStreetResize
        object lblOrg2: TLabel
          Left = 5
          Top = 5
          Width = 61
          Height = 13
          Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
        end
        object lblCity2: TLabel
          Left = 5
          Top = 45
          Width = 33
          Height = 13
          Caption = #1043#1086#1088#1086#1076':'
        end
        object cbOrg: TDBComboBoxEh
          Left = 5
          Top = 20
          Width = 370
          Height = 19
          DropDownBox.Rows = 12
          EditButtons = <>
          Flat = True
          TabOrder = 0
          Visible = True
          OnChange = cbOrgChange
        end
        object cbCity: TDBComboBoxEh
          Left = 5
          Top = 60
          Width = 370
          Height = 19
          DropDownBox.Rows = 10
          EditButtons = <>
          Flat = True
          TabOrder = 1
          Visible = True
          OnChange = cbCityChange
        end
      end
      object pnlGreedHand: TPanel
        Left = 0
        Top = 90
        Width = 842
        Height = 497
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object pnlStreetListHand: TPanel
          Left = 472
          Top = 0
          Width = 370
          Height = 497
          Align = alClient
          TabOrder = 2
          object GridStreetListHand: TDBGridEh
            Left = 1
            Top = 1
            Width = 368
            Height = 469
            Align = alClient
            DataSource = dsStreetListHand
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
            OnGetCellParams = GridStreetListHandGetCellParams
            OnSortMarkingChanged = GridStreetListHandSortMarkingChanged
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
                FieldName = 'CITY_ID'
                Footers = <>
                Title.TitleButton = True
                Visible = False
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'STREET'
                Footer.Value = #1079#1072#1087#1080#1089#1077#1081
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = #1059#1083#1080#1094#1072
                Title.TitleButton = True
                Width = 230
              end
              item
                EditButtons = <>
                FieldName = 'CITY'
                Footers = <>
                Title.Caption = #1043#1086#1088#1086#1076
                Title.TitleButton = True
                Width = 130
              end
              item
                EditButtons = <>
                FieldName = 'FLAG'
                Footers = <>
                Title.TitleButton = True
                Visible = False
                Width = 40
              end>
          end
          object pnlStreetListFilter: TPanel
            Left = 1
            Top = 470
            Width = 368
            Height = 26
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object edStreetListFilter: TDBEditEh
              Left = 0
              Top = 0
              Width = 375
              Height = 21
              Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
              EditButtons = <>
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Flat = True
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Visible = True
              OnKeyUp = edStreetListFilterKeyUp
            end
          end
        end
        object pnlUnAttachedStreetHand: TPanel
          Left = 0
          Top = 0
          Width = 372
          Height = 497
          Align = alLeft
          TabOrder = 0
          object pnlUnAttachedStreetFilter: TPanel
            Left = 1
            Top = 470
            Width = 370
            Height = 26
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object edUnAttachedStreetFilter: TDBEditEh
              Left = 0
              Top = 0
              Width = 375
              Height = 21
              Hint = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1086' '#1074#1074#1077#1089#1090#1080' '#1084#1080#1085#1080#1084#1091#1084' 3 '#1089#1080#1084#1074#1086#1083#1072' '#1080#1083#1080' '#1085#1072#1078#1072#1090#1100' '#1082#1083#1072#1074#1080#1096#1091' <Enter>'
              EditButtons = <>
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Flat = True
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              Visible = True
              OnKeyUp = edUnAttachedStreetFilterKeyUp
            end
          end
          object GridUnAttachedStreetHand: TDBGridEh
            Left = 1
            Top = 1
            Width = 370
            Height = 469
            Align = alClient
            DataSource = dsUnAttachedStreetHand
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
            OnSortMarkingChanged = GridUnAttachedStreetHandSortMarkingChanged
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
                FieldName = 'CITY_ID'
                Footer.Alignment = taLeftJustify
                Footers = <>
                Title.TitleButton = True
                Visible = False
                Width = 60
              end
              item
                EditButtons = <>
                FieldName = 'STREET'
                Footer.Value = #1079#1072#1087#1080#1089#1077#1081
                Footer.ValueType = fvtStaticText
                Footers = <>
                Title.Caption = #1059#1083#1080#1094#1072
                Title.TitleButton = True
                Width = 230
              end
              item
                EditButtons = <>
                FieldName = 'CITY'
                Footers = <>
                Title.Caption = #1043#1086#1088#1086#1076
                Title.TitleButton = True
                Width = 130
              end
              item
                EditButtons = <>
                FieldName = 'ORG'
                Footers = <>
                Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
                Title.TitleButton = True
                Width = 500
              end>
          end
        end
        object pnlSeparatorHand: TPanel
          Left = 372
          Top = 0
          Width = 100
          Height = 497
          Align = alLeft
          BevelOuter = bvNone
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          TabOrder = 1
          object btnAttachTop: TLMDButton
            Left = 0
            Top = 0
            Width = 100
            Height = 50
            Action = AcAttach
            BiDiMode = bdLeftToRight
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentBiDiMode = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            ButtonStyle = ubsIntegrated
            FontFX.Style = tdExtrude
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A004A4A4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A004A4A
              4A004A4A4A004A4A4A004A4A4A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A004A4A
              4A004A4A4A004A4A4A004A4A4A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A004A4A4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          end
          object btnAttachBottom: TLMDButton
            Left = 0
            Top = 439
            Width = 100
            Height = 50
            Action = AcAttach
            BiDiMode = bdLeftToRight
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentBiDiMode = False
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            ButtonStyle = ubsIntegrated
            FontFX.Style = tdExtrude
            Glyph.Data = {
              36040000424D3604000000000000360000002800000010000000100000000100
              2000000000000004000000000000000000000000000000000000FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A004A4A4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A004A4A
              4A004A4A4A004A4A4A004A4A4A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A00A5A54A00A5A5
              4A00A5A54A00A5A54A00A5A54A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A00A5A54A004A4A
              4A004A4A4A004A4A4A004A4A4A004A4A4A00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A00A5A54A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00A5A54A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A4A004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A004A4A4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF004A4A
              4A00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
              FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
          end
        end
      end
    end
    object tsAutoAttachedStreet: TTabSheet
      Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1072#1103' '#1087#1088#1080#1074#1103#1079#1082#1072
      ImageIndex = 2
      object pnlGreedAuto: TPanel
        Left = 0
        Top = 0
        Width = 842
        Height = 587
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 842
          Height = 587
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          object pnlStreetListAuto: TPanel
            Left = 472
            Top = 0
            Width = 370
            Height = 587
            Align = alClient
            TabOrder = 2
            object GridStreetListAuto: TDBGridEh
              Left = 1
              Top = 1
              Width = 368
              Height = 585
              Align = alClient
              DataSource = dsStreetListAuto
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
              Columns = <
                item
                  EditButtons = <>
                  FieldName = 'ID'
                  Footer.ValueType = fvtStaticText
                  Footers = <>
                  Width = 60
                end
                item
                  EditButtons = <>
                  FieldName = 'STREET'
                  Footer.Value = #1079#1072#1087#1080#1089#1077#1081
                  Footer.ValueType = fvtStaticText
                  Footers = <>
                  Title.Caption = #1059#1083#1080#1094#1072
                  Width = 230
                end
                item
                  EditButtons = <>
                  FieldName = 'CITY'
                  Footers = <>
                  Title.Caption = #1043#1086#1088#1086#1076
                  Width = 130
                end>
            end
          end
          object pnlUnAttachedStreetAuto: TPanel
            Left = 0
            Top = 0
            Width = 372
            Height = 587
            Align = alLeft
            TabOrder = 0
            object GridUnAttachedStreetAuto: TDBGridEh
              Left = 1
              Top = 1
              Width = 370
              Height = 585
              Align = alClient
              DataSource = dsUnAttachedStreetAuto
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
              Columns = <
                item
                  EditButtons = <>
                  FieldName = 'ID'
                  Footer.ValueType = fvtStaticText
                  Footers = <>
                  Width = 60
                end
                item
                  EditButtons = <>
                  FieldName = 'STREET'
                  Footer.Value = #1079#1072#1087#1080#1089#1077#1081
                  Footer.ValueType = fvtStaticText
                  Footers = <>
                  Title.Caption = #1059#1083#1080#1094#1072
                  Width = 230
                end
                item
                  EditButtons = <>
                  FieldName = 'CITY'
                  Footers = <>
                  Title.Caption = #1043#1086#1088#1086#1076
                  Width = 130
                end
                item
                  EditButtons = <>
                  FieldName = 'ORG'
                  Footers = <>
                  Title.Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
                  Width = 500
                end>
            end
          end
          object pnlSeparatorAuto: TPanel
            Left = 372
            Top = 0
            Width = 100
            Height = 587
            Align = alLeft
            BevelOuter = bvNone
            BiDiMode = bdLeftToRight
            ParentBiDiMode = False
            TabOrder = 1
            object btnStart: TLMDButton
              Left = 0
              Top = 0
              Width = 100
              Height = 50
              Hint = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1091#1083#1080#1094#1099
              BiDiMode = bdLeftToRight
              Caption = #1057#1090#1072#1088#1090
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentBiDiMode = False
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = btnStartClick
              ButtonStyle = ubsIntegrated
              FontFX.Style = tdExtrude
            end
          end
        end
      end
    end
  end
  object mdUnCorrectStreet: TRxMemoryData
    FieldDefs = <>
    Left = 14
    Top = 210
    object mdUnCorrectStreetORG: TStringField
      FieldName = 'ORG'
      Size = 100
    end
    object mdUnCorrectStreetCITY: TStringField
      FieldName = 'CITY'
      Size = 100
    end
    object mdUnCorrectStreetSTREET: TStringField
      FieldName = 'STREET'
      Size = 100
    end
  end
  object dsUnCorrectStreet: TDataSource
    DataSet = mdUnCorrectStreet
    Left = 14
    Top = 242
  end
  object mdUnAttachedStreetHand: TRxMemoryData
    FieldDefs = <>
    BeforeScroll = mdUnAttachedStreetHandBeforeScroll
    AfterScroll = mdUnAttachedStreetHandAfterScroll
    Left = 346
    Top = 142
    object mdUnAttachedStreetHandID: TIntegerField
      FieldName = 'ID'
    end
    object mdUnAttachedStreetHandCITY_ID: TIntegerField
      FieldName = 'CITY_ID'
    end
    object mdUnAttachedStreetHandSTREET: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object mdUnAttachedStreetHandCITY: TStringField
      FieldName = 'CITY'
      Size = 70
    end
    object mdUnAttachedStreetHandORG: TStringField
      FieldName = 'ORG'
      Size = 255
    end
  end
  object dsUnAttachedStreetHand: TDataSource
    DataSet = mdUnAttachedStreetHand
    Left = 346
    Top = 174
  end
  object mdStreetListHand: TRxMemoryData
    FieldDefs = <>
    AfterScroll = mdStreetListHandAfterScroll
    Left = 816
    Top = 142
    object mdStreetListHandID: TIntegerField
      FieldName = 'ID'
    end
    object mdStreetListHandCITY_ID: TIntegerField
      FieldName = 'CITY_ID'
    end
    object mdStreetListHandSTREET: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object mdStreetListHandCITY: TStringField
      FieldName = 'CITY'
      Size = 70
    end
    object mdStreetListHandFLAG: TWordField
      FieldName = 'FLAG'
    end
  end
  object dsStreetListHand: TDataSource
    DataSet = mdStreetListHand
    Left = 816
    Top = 174
  end
  object ActionList: TActionList
    Left = 448
    Top = 168
    object AcAttach: TAction
      Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100#13#10'(CTRL+A)'
      Hint = #1055#1088#1080#1074#1103#1079#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1091#1083#1080#1094#1099
      ShortCut = 16449
      OnExecute = AcAttachExecute
    end
  end
  object mdUnAttachedStreetAuto: TRxMemoryData
    FieldDefs = <>
    Left = 346
    Top = 274
    object IntegerField1: TIntegerField
      FieldName = 'ID'
    end
    object StringField1: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object StringField2: TStringField
      FieldName = 'CITY'
      Size = 70
    end
    object StringField3: TStringField
      FieldName = 'ORG'
      Size = 255
    end
  end
  object dsUnAttachedStreetAuto: TDataSource
    DataSet = mdUnAttachedStreetAuto
    Left = 346
    Top = 306
  end
  object mdStreetListAuto: TRxMemoryData
    FieldDefs = <>
    Left = 816
    Top = 282
    object IntegerField3: TIntegerField
      FieldName = 'ID'
    end
    object StringField4: TStringField
      FieldName = 'STREET'
      Size = 70
    end
    object StringField5: TStringField
      FieldName = 'CITY'
      Size = 70
    end
  end
  object dsStreetListAuto: TDataSource
    DataSet = mdStreetListAuto
    Left = 816
    Top = 314
  end
end
