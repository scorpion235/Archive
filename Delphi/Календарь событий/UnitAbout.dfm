object FormAbout: TFormAbout
  Left = 366
  Top = 241
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 133
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 6
    Width = 171
    Height = 20
    Caption = #1050#1072#1083#1077#1085#1076#1072#1088#1100' '#1089#1086#1073#1099#1090#1080#1081
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 12
    Top = 30
    Width = 103
    Height = 13
    Caption = #1040#1074#1090#1086#1088': '#1044#1102#1075#1091#1088#1086#1074' '#1057' '#1052
  end
  object Label3: TLabel
    Left = 12
    Top = 44
    Width = 147
    Height = 13
    Caption = #1057#1088#1077#1076#1072' '#1088#1072#1079#1088#1072#1073#1086#1090#1082#1080': Delphi 7.0'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 96
    Width = 195
    Height = 2
  end
  object Label4: TLabel
    Left = 12
    Top = 58
    Width = 86
    Height = 13
    Caption = #1044#1072#1090#1072': 16.10.2006'
  end
  object Label5: TLabel
    Left = 12
    Top = 72
    Width = 67
    Height = 13
    Caption = #1042#1077#1088#1089#1080#1103': 1.0.0'
  end
  object Button1: TButton
    Left = 60
    Top = 104
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
end
