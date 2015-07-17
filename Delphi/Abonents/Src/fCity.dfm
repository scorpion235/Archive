object frmCity: TfrmCity
  Left = 278
  Top = 140
  Width = 870
  Height = 640
  ActiveControl = edCity
  Caption = #1043#1086#1088#1086#1076#1072
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
    object lblCity: TLabel
      Left = 10
      Top = 30
      Width = 33
      Height = 13
      Caption = #1043#1086#1088#1086#1076':'
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
      Top = 45
      Width = 157
      Height = 19
      EditButtons = <>
      Flat = True
      TabOrder = 1
      Visible = True
      OnChange = edCityChange
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
  object pnlGrid: TPanel
    Left = 183
    Top = 0
    Width = 679
    Height = 606
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object GridCity: TDBGridEh
      Left = 0
      Top = 0
      Width = 679
      Height = 602
      Align = alClient
      DataSource = dsCity
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
      PopupMenu = pmCity
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      UseMultiTitle = True
      OnDblClick = AcEditExecute
      OnGetCellParams = GridCityGetCellParams
      OnSortMarkingChanged = GridCitySortMarkingChanged
      Columns = <
        item
          Checkboxes = True
          EditButtons = <>
          FieldName = 'IS_EDIT'
          Footer.ValueType = fvtStaticText
          Footers = <>
          KeyList.Strings = (
            '1'
            '0')
          ReadOnly = True
          Title.Caption = #1056#1077#1076#1072#1082#1090'.'
          Title.TitleButton = True
          Width = 45
        end
        item
          EditButtons = <>
          FieldName = 'CITY_ID'
          Footer.Alignment = taLeftJustify
          Footer.Value = #1079#1072#1087#1080#1089#1077#1081
          Footer.ValueType = fvtStaticText
          Footers = <>
          Title.Caption = 'ID'
          Title.TitleButton = True
          Width = 60
        end
        item
          EditButtons = <>
          FieldName = 'NAME'
          Footers = <>
          Title.Caption = #1043#1086#1088#1086#1076
          Title.TitleButton = True
          Width = 300
        end>
    end
    object RxSplitter2: TRxSplitter
      Left = 0
      Top = 602
      Width = 679
      Height = 4
      Align = alBottom
      BevelOuter = bvNone
    end
  end
  object mdCity: TRxMemoryData
    FieldDefs = <>
    AfterScroll = mdCityAfterScroll
    Left = 352
    Top = 114
    object mdCityCITY_ID: TIntegerField
      FieldName = 'CITY_ID'
    end
    object mdCityNAME: TStringField
      FieldName = 'NAME'
      Size = 70
    end
    object mdCityIS_EDIT: TSmallintField
      FieldName = 'IS_EDIT'
    end
  end
  object dsCity: TDataSource
    DataSet = mdCity
    Left = 352
    Top = 154
  end
  object pmCity: TPopupMenu
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
  object PrintGrid: TPrintDBGridEh
    DBGridEh = GridCity
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
    PrintFontName = 'Times New Roman'
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
end
