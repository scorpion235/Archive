object frmActiveCard: TfrmActiveCard
  Left = 452
  Top = 343
  ActiveControl = edCardNum1
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1055#1077#1088#1089#1086#1085#1072#1083#1080#1079#1072#1094#1080#1103' '#1082#1072#1088#1090
  ClientHeight = 106
  ClientWidth = 187
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblCardNum: TLabel
    Left = 10
    Top = 15
    Width = 114
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1082#1072#1088#1090#1099':'
  end
  object edCardNum1: TEdit
    Left = 10
    Top = 30
    Width = 45
    Height = 21
    TabOrder = 0
    Text = '990002'
  end
  object bthOK: TButton
    Left = 10
    Top = 70
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 3
    OnClick = bthOKClick
  end
  object btnCancel: TButton
    Left = 100
    Top = 70
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 4
  end
  object edCardNum2: TEdit
    Left = 60
    Top = 30
    Width = 35
    Height = 21
    TabOrder = 1
    Text = '0000'
    OnKeyDown = edCardNum2KeyDown
    OnKeyUp = edCardNum2KeyUp
  end
  object edCardNum3: TEdit
    Left = 100
    Top = 30
    Width = 45
    Height = 21
    TabOrder = 2
    Text = '000000'
    OnKeyDown = edCardNum3KeyDown
    OnKeyUp = edCardNum3KeyUp
  end
end
