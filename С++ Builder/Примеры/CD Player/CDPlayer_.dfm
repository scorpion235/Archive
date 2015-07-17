object Form1: TForm1
  Left = 321
  Top = 306
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CD Player'
  ClientHeight = 102
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000008888800000000088777AA880000008F7777AABB800008FF
    7777ABBEE800087FF777ABEE78008777FF7FABE7778087777F808E7777808777
    7A0F077777808777AE8087777780877AAEB77F77778008AAEBB77FF7780008AE
    EBB777FFF800008EBBB7777F800000088BB7778800000000088888000000FFFF
    0000F83F0000E00F0000C0070000800300008003000000010000000100000001
    000000010000000100008003000080030000C0070000E00F0000F83F0000}
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 257
    Height = 57
    Brush.Color = clBtnFace
    Shape = stRoundRect
  end
  object Label2: TLabel
    Left = 112
    Top = 32
    Width = 29
    Height = 16
    Alignment = taCenter
    Caption = '0:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 241
    Height = 17
    Alignment = taCenter
    AutoSize = False
    Caption = 'Track 0'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object MediaPlayer: TMediaPlayer
    Left = 8
    Top = 152
    Width = 253
    Height = 30
    AutoOpen = True
    DeviceType = dtCDAudio
    Visible = False
    TabOrder = 3
    OnNotify = MediaPlayerNotify
  end
  object Button1: TButton
    Left = 96
    Top = 72
    Width = 65
    Height = 25
    Hint = #1042#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077
    Caption = '4'
    Enabled = False
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 168
    Top = 72
    Width = 65
    Height = 25
    Hint = #1057#1083#1077#1076#1091#1102#1097#1080#1081' '#1090#1088#1077#1082
    Caption = ':'
    Enabled = False
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button2: TButton
    Left = 24
    Top = 72
    Width = 65
    Height = 25
    Hint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1090#1088#1077#1082
    Caption = '9'
    Enabled = False
    Font.Charset = SYMBOL_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Webdings'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object Timer: TTimer
    Interval = 500
    OnTimer = TimerTimer
    Left = 8
    Top = 8
  end
end
