object Form1: TForm1
  Left = 247
  Top = 229
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1057#1080#1083#1072' '#1090#1086#1082#1072
  ClientHeight = 231
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 297
    Height = 33
    AutoSize = False
    Caption = 
      #1042#1074#1077#1076#1080#1090#1077' '#1085#1072#1087#1088#1103#1078#1077#1085#1080#1077' '#1080' '#1074#1077#1083#1080#1095#1080#1085#1091' '#1089#1086#1087#1088#1086#1090#1080#1074#1083#1077#1085#1080#1103', '#1079#1072#1090#1077#1084' '#1097#1077#1083#1082#1085#1080#1090#1077' '#1085#1072' '#1082 +
      #1085#1086#1087#1082#1077' '#1042#1099#1095#1080#1089#1083#1080#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 119
    Height = 14
    Caption = #1053#1072#1087#1088#1103#1078#1077#1085#1080#1077' ('#1074#1086#1083#1100#1090')'
  end
  object Label3: TLabel
    Left = 8
    Top = 131
    Width = 120
    Height = 14
    Caption = #1057#1086#1087#1088#1086#1090#1080#1074#1083#1077#1085#1080#1077' ('#1054#1084')'
  end
  object Label4: TLabel
    Left = 8
    Top = 160
    Width = 201
    Height = 17
    AutoSize = False
  end
  object Label5: TLabel
    Left = 8
    Top = 8
    Width = 257
    Height = 33
    AutoSize = False
    Caption = #1044#1083#1103' '#1074#1074#1086#1076#1072' '#1080#1089#1093#1086#1076#1085#1099#1093' '#1076#1072#1085#1085#1099#1093' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1080#1089#1087#1086#1083#1100#1079#1091#1077#1090' '#1082#1086#1084#1087#1086#1085#1077#1085#1090' NkEdit'
    WordWrap = True
  end
  object Button1: TButton
    Left = 16
    Top = 192
    Width = 75
    Height = 25
    Caption = #1042#1099#1095#1080#1089#1083#1080#1090#1100
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 104
    Top = 192
    Width = 75
    Height = 25
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100
    TabOrder = 1
    OnClick = Button2Click
  end
  object NkEdit1: TNkEdit
    Left = 144
    Top = 104
    Width = 73
    Height = 22
    AutoSelect = False
    TabOrder = 2
    Text = '0'
    OnKeyPress = NkEdit1KeyPress
    EnableFloat = True
    Max = 100
  end
  object NkEdit2: TNkEdit
    Left = 144
    Top = 128
    Width = 73
    Height = 22
    AutoSelect = False
    TabOrder = 3
    Text = '0'
    OnKeyPress = NkEdit2KeyPress
    EnableFloat = True
    Max = 100
  end
end
