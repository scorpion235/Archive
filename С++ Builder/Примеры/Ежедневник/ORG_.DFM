object Form1: TForm1
  Left = 224
  Top = 176
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1045#1078#1077#1076#1085#1077#1074#1085#1080#1082
  ClientHeight = 330
  ClientWidth = 534
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000F000000000000000000000000000000FF00F0000000000
    0000000000000000FFF08F0000000BB3333333333333330FFFF08F0333300B70
    00000000000000FFF7F08F0000300B7FF6FFFFFFFFF807FF77F08F0880300B7F
    F6FFFFFFFFF0B0F7D7F08F0880300B7666666666666807FD7DF08F0280300B7F
    F6FFFFFFFFF807F7D7F08F0280300B7FF6FFFFFFFFF0B0FD7DF08F0280300B76
    66666666666807F7DFF08F0280300B7FF6FFFFFFFFF807FDFFF08F0280300B7F
    F6FFFFFFFFF0B0FFAFF04F0280300B7666666666666807FA2FF04F0880300B7F
    F6FFFFFFFFF807F2AFF04F0880300B7FF6FFFFFFFFF0B0FA2FF04F0880300B76
    66666666666807F2AFF08F0180300B7FF6FFFFFFFFF807FAFFF08F0180300B7F
    F6FFFFFFFFF0B0FFFFF08F0880300B7666666666666807FFFF078F0880300B7F
    F6FFFFFFFFF807FFF078F00880300B7FF6FFFFFFFFF0B0FF07800788F0300B7F
    F6888888888807F0700788FFF0300B7F00000000007807000888FFFFF0300B77
    0FF88887700000000000000000B00BBBB0FF88770BB303BBBBBBBBBBBBB00000
    000FF870000B3B00000000000000000000FF8887000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FEFFFFFFFCFFFFFFF89FFFFFF01F800000010000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000080000001F8063FFFFC0FFFFFFFFFFFFF}
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 16
    Top = 32
    Width = 55
    Height = 20
    Caption = 'Label2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 56
    Width = 505
    Height = 225
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Date_F'
        Title.Caption = #1050#1086#1075#1076#1072
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsItalic]
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Task_F'
        Title.Caption = #1063#1090#1086
        Title.Font.Charset = DEFAULT_CHARSET
        Title.Font.Color = clWindowText
        Title.Font.Height = -11
        Title.Font.Name = 'MS Sans Serif'
        Title.Font.Style = [fsItalic]
        Width = 434
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 272
    Top = 16
    Width = 240
    Height = 25
    DataSource = DataSource1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 8
    Top = 296
    Width = 75
    Height = 25
    Caption = #1057#1077#1075#1086#1076#1085#1103
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 296
    Width = 75
    Height = 25
    Caption = #1047#1072#1074#1090#1088#1072
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 184
    Top = 296
    Width = 75
    Height = 25
    Caption = #1069#1090#1072' '#1085#1077#1076#1077#1083#1103
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 272
    Top = 296
    Width = 75
    Height = 25
    Caption = #1042#1089#1077
    TabOrder = 5
    OnClick = Button4Click
  end
  object Table1: TTable
    DatabaseName = 'organizer'
    TableName = 'org.db'
    Left = 440
    Top = 296
  end
  object DataSource1: TDataSource
    DataSet = Table1
    Left = 480
    Top = 296
  end
  object Query1: TQuery
    SQL.Strings = (
      'SELECT Date_F, Task_F'
      'FROM '#39':organizer:org.db'#39
      'WHERE'
      '( Date_F = '#39'09.02.2003'#39' )'
      'ORDER BY Date_F')
    Left = 400
    Top = 296
  end
end
