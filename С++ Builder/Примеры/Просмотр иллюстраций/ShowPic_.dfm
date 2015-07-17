object Form1: TForm1
  Left = 262
  Top = 156
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1083#1083#1102#1089#1090#1088#1072#1094#1080#1081
  ClientHeight = 381
  ClientWidth = 521
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Image1: TImage
    Left = 8
    Top = 40
    Width = 505
    Height = 289
    Center = True
    Proportional = True
  end
  object Button1: TButton
    Left = 8
    Top = 344
    Width = 75
    Height = 25
    Caption = #1050#1072#1090#1072#1083#1086#1075
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 96
    Top = 344
    Width = 75
    Height = 25
    Caption = #1044#1072#1083#1100#1096#1077
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
end
