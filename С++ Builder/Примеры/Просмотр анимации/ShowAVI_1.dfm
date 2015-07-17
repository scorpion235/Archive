object Form1: TForm1
  Left = 340
  Top = 237
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1072#1085#1080#1084#1072#1094#1080#1080
  ClientHeight = 281
  ClientWidth = 274
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
    Top = 19
    Width = 32
    Height = 13
    Caption = #1060#1072#1081#1083':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Animate1: TAnimate
    Left = 8
    Top = 56
    Width = 233
    Height = 145
    Active = False
    AutoSize = False
    CommonAVI = aviFindFile
    StopFrame = 8
    Transparent = False
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 216
    Width = 105
    Height = 17
    Caption = #1085#1077#1087#1088#1077#1088#1099#1074#1085#1086
    Checked = True
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 248
    Width = 97
    Height = 17
    Caption = #1087#1086' '#1082#1072#1076#1088#1072#1084
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = RadioButton2Click
  end
  object Button1: TButton
    Left = 136
    Top = 216
    Width = 97
    Height = 25
    Caption = #1055#1091#1089#1082
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 184
    Top = 248
    Width = 49
    Height = 25
    Caption = '>>'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 136
    Top = 248
    Width = 49
    Height = 25
    Caption = '<<'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 48
    Top = 16
    Width = 105
    Height = 21
    TabOrder = 6
  end
  object Button4: TButton
    Left = 160
    Top = 15
    Width = 75
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100'...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 240
    Top = 16
  end
end
