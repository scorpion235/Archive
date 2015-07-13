object frmCityEd: TfrmCityEd
  Left = 463
  Top = 353
  ActiveControl = edName
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1075#1086#1088#1086#1076#1086#1074
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
  object lblName: TLabel
    Left = 10
    Top = 15
    Width = 33
    Height = 13
    Caption = #1043#1086#1088#1086#1076':'
  end
  object edName: TDBEditEh
    Left = 10
    Top = 30
    Width = 290
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 0
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
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 225
    Top = 60
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object edCity_id: TDBEditEh
    Left = 10
    Top = 60
    Width = 80
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 1
    Text = 'edCity_id'
    Visible = True
  end
end
