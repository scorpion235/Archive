object fmEdit: TfmEdit
  Left = 306
  Top = 239
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 176
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 45
    Width = 22
    Height = 13
    Caption = #1050#1086#1076':'
  end
  object Label2: TLabel
    Left = 110
    Top = 44
    Width = 33
    Height = 13
    Caption = #1040#1074#1090#1086#1088':'
  end
  object Label3: TLabel
    Left = 10
    Top = 80
    Width = 53
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label4: TLabel
    Left = 10
    Top = 115
    Width = 46
    Height = 13
    Caption = #1053#1072#1083#1080#1095#1080#1077':'
  end
  object Label5: TLabel
    Left = 150
    Top = 115
    Width = 61
    Height = 13
    Caption = #1061#1088#1072#1085#1080#1083#1080#1097#1077':'
  end
  object Label6: TLabel
    Left = 10
    Top = 150
    Width = 47
    Height = 13
    Caption = #1057#1090#1077#1083#1083#1072#1078':'
  end
  object Label7: TLabel
    Left = 150
    Top = 150
    Width = 35
    Height = 13
    Caption = #1055#1086#1083#1082#1072':'
  end
  object DBNavigator: TDBNavigator
    Left = 0
    Top = 0
    Width = 240
    Height = 25
    DataSource = dmLib.dsBook
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
  object DBEdit1: TDBEdit
    Left = 40
    Top = 40
    Width = 50
    Height = 21
    DataField = 'Code_B'
    DataSource = dmLib.dsBook
    TabOrder = 1
  end
  object DBEdit2: TDBEdit
    Left = 150
    Top = 40
    Width = 121
    Height = 21
    DataField = 'Author'
    DataSource = dmLib.dsBook
    TabOrder = 2
  end
  object DBEdit3: TDBEdit
    Left = 70
    Top = 75
    Width = 200
    Height = 21
    DataField = 'Title'
    DataSource = dmLib.dsBook
    TabOrder = 3
  end
  object DBEdit4: TDBEdit
    Left = 70
    Top = 110
    Width = 50
    Height = 21
    DataField = 'Avail'
    DataSource = dmLib.dsBook
    TabOrder = 4
  end
  object DBEdit5: TDBEdit
    Left = 220
    Top = 110
    Width = 50
    Height = 21
    DataField = 'Repost'
    DataSource = dmLib.dsLocality
    TabOrder = 5
  end
  object DBEdit6: TDBEdit
    Left = 70
    Top = 145
    Width = 50
    Height = 21
    DataField = 'Stel'
    DataSource = dmLib.dsLocality
    TabOrder = 6
  end
  object DBEdit7: TDBEdit
    Left = 220
    Top = 145
    Width = 50
    Height = 21
    DataField = 'Shelf'
    DataSource = dmLib.dsLocality
    TabOrder = 7
  end
  object btImage: TButton
    Left = 290
    Top = 145
    Width = 100
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1092#1086#1090#1086
    TabOrder = 8
    OnClick = btImageClick
  end
  object DBImage: TDBImage
    Left = 290
    Top = 25
    Width = 100
    Height = 105
    DataField = 'Image'
    DataSource = dmLib.dsBook
    TabOrder = 9
  end
  object OpenPictureDialog: TOpenPictureDialog
    Left = 254
    Top = 2
  end
end
