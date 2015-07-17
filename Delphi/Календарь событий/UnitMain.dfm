object FormMain: TFormMain
  Left = 230
  Top = 115
  Width = 788
  Height = 582
  Caption = #1057#1086#1073#1099#1090#1080#1103
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Navigator: TDBNavigator
    Left = 0
    Top = 0
    Width = 240
    Height = 25
    DataSource = DataSource
    Flat = True
    Hints.Strings = (
      #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
      #1055#1088#1077#1076#1099#1076#1091#1097#1103#1103' '#1079#1072#1087#1080#1089#1100
      #1057#1083#1077#1076#1091#1102#1097#1103#1103' '#1079#1072#1087#1080#1089#1100
      #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
      #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
      #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
      #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1080#1079#1084#1077#1085#1077#1085#1080#1103)
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
  object Grid: TDBGridEh
    Left = 0
    Top = 24
    Width = 777
    Height = 503
    DataSource = DataSource
    FooterColor = clInfoBk
    FooterFont.Charset = DEFAULT_CHARSET
    FooterFont.Color = clWindowText
    FooterFont.Height = -11
    FooterFont.Name = 'MS Sans Serif'
    FooterFont.Style = []
    FooterRowCount = 1
    SumList.Active = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    UseMultiTitle = True
    Columns = <
      item
        EditButtons = <>
        FieldName = 'Data'
        Footer.Value = #1048#1090#1086#1075#1086':'
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1044#1072#1090#1072
      end
      item
        EditButtons = <>
        FieldName = 'Vremya'
        Footer.Alignment = taRightJustify
        Footer.ValueType = fvtCount
        Footers = <>
        Title.Caption = #1042#1088#1077#1084#1103
      end
      item
        EditButtons = <>
        FieldName = 'Sobutie'
        Footer.Value = #1079#1072#1087#1080#1089#1077#1081
        Footer.ValueType = fvtStaticText
        Footers = <>
        Title.Caption = #1057#1086#1073#1099#1090#1080#1077
        Width = 603
      end>
  end
  object Database: TDatabase
    SessionName = 'Default'
    Left = 492
    Top = 46
  end
  object DataSource: TDataSource
    DataSet = Table
    Left = 464
    Top = 46
  end
  object MainMenu: TMainMenu
    Left = 440
    Top = 90
    object events: TMenuItem
      Caption = #1057#1086#1073#1099#1090#1080#1077
      object events1: TMenuItem
        Caption = #1085#1072' '#1089#1077#1075#1086#1076#1085#1103
        ShortCut = 16433
        OnClick = events1Click
      end
      object events2: TMenuItem
        Caption = #1085#1072' '#1085#1077#1076#1077#1083#1102
        Enabled = False
        ShortCut = 16434
        OnClick = events2Click
      end
      object events3: TMenuItem
        Caption = #1085#1072' '#1084#1077#1089#1103#1094
        Enabled = False
        ShortCut = 16435
        OnClick = events3Click
      end
      object all_events: TMenuItem
        Caption = #1074#1089#1077
        ShortCut = 16436
        OnClick = all_eventsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object add_event: TMenuItem
        Caption = #1076#1086#1073#1072#1074#1080#1090#1100
        ShortCut = 16449
        OnClick = add_eventClick
      end
    end
    object spravra: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object about: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
        ShortCut = 112
        OnClick = aboutClick
      end
    end
  end
  object XPManifest1: TXPManifest
    Left = 466
    Top = 90
  end
  object Table: TTable
    TableName = 'sobutiya.db'
    Left = 438
    Top = 46
  end
  object Query: TQuery
    AfterOpen = QueryAfterOpen
    AfterClose = QueryAfterClose
    SQL.Strings = (
      'select * from "sobutiya.db" where (Data='#39'01.01.2006'#39#39')')
    Left = 520
    Top = 46
  end
end
