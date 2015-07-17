object frmSubSrvEd: TfrmSubSrvEd
  Left = 463
  Top = 353
  ActiveControl = edNum
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1087#1086#1076#1091#1089#1083#1091#1075
  ClientHeight = 96
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblNum: TLabel
    Left = 10
    Top = 15
    Width = 37
    Height = 13
    Caption = #1053#1086#1084#1077#1088':'
  end
  object lblName: TLabel
    Left = 100
    Top = 15
    Width = 56
    Height = 13
    Caption = #1055#1086#1076#1091#1089#1083#1091#1075#1072':'
  end
  object edName: TDBEditEh
    Left = 100
    Top = 30
    Width = 200
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 1
    Text = 'edName'
    Visible = True
  end
  object btnOK: TButton
    Left = 140
    Top = 60
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 225
    Top = 60
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 5
  end
  object edNum: TDBEditEh
    Left = 10
    Top = 30
    Width = 80
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 0
    Text = 'edNum'
    Visible = True
  end
  object edSubSrv_id: TDBEditEh
    Left = 10
    Top = 70
    Width = 80
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 3
    Text = 'edSubSrv_id'
    Visible = True
  end
  object edService_id: TDBEditEh
    Left = 10
    Top = 50
    Width = 80
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 2
    Text = 'edService_id'
    Visible = True
  end
end
