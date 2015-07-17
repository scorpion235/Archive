object Form1: TForm1
  Left = 386
  Top = 211
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1086#1089#1090#1088#1086#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1092#1091#1085#1082#1094#1080#1081
  ClientHeight = 167
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 110
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1092#1091#1085#1082#1094#1080#1102' f(x):'
  end
  object Label2: TLabel
    Left = 8
    Top = 64
    Width = 229
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1076#1083#1080#1085#1091' '#1076#1080#1072#1087#1072#1079#1086#1085#1072' '#1082#1086#1086#1088#1076#1080#1085#1072#1090' (2..100):'
  end
  object Button1: TButton
    Left = 8
    Top = 136
    Width = 75
    Height = 25
    Caption = #1043#1088#1072#1092#1080#1082
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 136
    Width = 75
    Height = 25
    Caption = #1057#1087#1088#1072#1074#1082#1072
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 256
    Top = 136
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 32
    Width = 321
    Height = 21
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 8
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 4
    Text = '20'
  end
end
