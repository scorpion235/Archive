object Form1: TForm1
  Left = 312
  Top = 206
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1047#1074#1091#1082#1080' Windows'
  ClientHeight = 313
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000307000000000000308870007000000377FF7007000000
    3B08FF7070000003BF08FF700000037BFB00FF7000003B8FBF070F7077773B8B
    FB080F7000003F8FBF00FF700000033BFB08FF7070000003BF08FF7007000000
    3B77FF700070000003B0FF00000000000037070000000000000000000000FE7F
    0000FC3F0000F81D0000F01B0000E0170000801F0000001F000000100000001F
    0000001F000080170000E01B0000F01D0000F83F0000FC3F0000FE7F0000}
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 233
    Height = 33
    AutoSize = False
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1079#1074#1091#1082#1086#1074#1086#1081' '#1092#1072#1081#1083' '#1080' '#1097#1077#1083#1082#1085#1080#1090#1077' '#1085#1072' '#1082#1085#1086#1087#1082#1077' Play'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 14
    Top = 56
    Width = 234
    Height = 16
    AutoSize = False
  end
  object ListBox1: TListBox
    Left = 8
    Top = 80
    Width = 241
    Height = 177
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object MediaPlayer1: TMediaPlayer
    Left = 8
    Top = 272
    Width = 57
    Height = 30
    VisibleButtons = [btPlay, btStop]
    TabOrder = 1
  end
end
