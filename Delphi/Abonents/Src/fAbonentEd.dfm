object frmAbonentEd: TfrmAbonentEd
  Left = 459
  Top = 314
  ActiveControl = cbService
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1072#1073#1086#1085#1077#1085#1090#1086#1074
  ClientHeight = 256
  ClientWidth = 392
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
  object lblService: TLabel
    Left = 10
    Top = 15
    Width = 39
    Height = 13
    Caption = #1059#1089#1083#1091#1075#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSubSrv: TLabel
    Left = 220
    Top = 15
    Width = 56
    Height = 13
    Caption = #1055#1086#1076#1091#1089#1083#1091#1075#1072':'
  end
  object lblFIO: TLabel
    Left = 10
    Top = 95
    Width = 30
    Height = 13
    Caption = #1060#1048#1054':'
  end
  object lblCity: TLabel
    Left = 10
    Top = 135
    Width = 33
    Height = 13
    Caption = #1043#1086#1088#1086#1076':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblStreet: TLabel
    Left = 180
    Top = 135
    Width = 35
    Height = 13
    Caption = #1059#1083#1080#1094#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblBuilding: TLabel
    Left = 10
    Top = 175
    Width = 26
    Height = 13
    Caption = #1044#1086#1084':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblApartment: TLabel
    Left = 90
    Top = 175
    Width = 51
    Height = 13
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072':'
  end
  object lblBalance: TLabel
    Left = 170
    Top = 175
    Width = 40
    Height = 13
    Caption = #1057#1072#1083#1100#1076#1086':'
  end
  object lblAcc_pu: TLabel
    Left = 10
    Top = 55
    Width = 72
    Height = 13
    Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 220
    Top = 220
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 10
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 305
    Top = 220
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 11
  end
  object edAbonent_id: TDBEditEh
    Left = 10
    Top = 220
    Width = 80
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 6
    Text = 'edAbonent_id'
    Visible = True
  end
  object cbService: TDBComboBoxEh
    Left = 10
    Top = 30
    Width = 200
    Height = 19
    DropDownBox.Rows = 12
    EditButtons = <>
    Flat = True
    TabOrder = 0
    Visible = True
    OnChange = cbServiceChange
  end
  object cbSubSrv: TDBComboBoxEh
    Left = 220
    Top = 30
    Width = 160
    Height = 19
    DropDownBox.Rows = 12
    EditButtons = <>
    Flat = True
    TabOrder = 2
    Visible = True
  end
  object edFIO: TDBEditEh
    Left = 10
    Top = 110
    Width = 370
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 4
    Visible = True
  end
  object cbCity: TDBComboBoxEh
    Left = 10
    Top = 150
    Width = 161
    Height = 19
    DropDownBox.Rows = 12
    EditButtons = <>
    Flat = True
    TabOrder = 5
    Visible = True
    OnChange = cbCityChange
  end
  object cbStreet: TDBComboBoxEh
    Left = 180
    Top = 150
    Width = 200
    Height = 19
    DropDownBox.Rows = 12
    EditButtons = <>
    Flat = True
    TabOrder = 7
    Visible = True
  end
  object edBuilding: TDBEditEh
    Left = 10
    Top = 190
    Width = 70
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 8
    Visible = True
  end
  object edApartment: TDBEditEh
    Left = 90
    Top = 190
    Width = 70
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 9
    Visible = True
  end
  object edAcc_pu: TDBEditEh
    Left = 10
    Top = 70
    Width = 370
    Height = 19
    EditButtons = <>
    Flat = True
    TabOrder = 3
    Visible = True
  end
  object cbAllSubSrv: TCheckBox
    Left = 220
    Top = 50
    Width = 97
    Height = 17
    Caption = #1042#1089#1077' '#1087#1086#1076#1091#1089#1083#1091#1075#1080
    TabOrder = 1
    OnClick = cbAllSubSrvClick
  end
  object edBalance: TCurrencyEdit
    Left = 170
    Top = 190
    Width = 100
    Height = 18
    AutoSize = False
    BorderStyle = bsNone
    DisplayFormat = ',0.00 '#1088#1091#1073#39'.'#39';-,0.00 '#1088#1091#1073#39'.'#39
    TabOrder = 12
  end
end
