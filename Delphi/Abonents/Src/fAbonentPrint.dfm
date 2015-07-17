object frmAbonentPrint: TfrmAbonentPrint
  Left = 436
  Top = 289
  BorderStyle = bsDialog
  Caption = #1040#1073#1086#1085#1077#1085#1090#1099' - '#1087#1077#1095#1072#1090#1100
  ClientHeight = 226
  ClientWidth = 207
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblAccPu: TLabel
    Left = 10
    Top = 15
    Width = 72
    Height = 13
    Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090':'
  end
  object Bevel: TBevel
    Left = 10
    Top = 77
    Width = 185
    Height = 2
    Shape = bsFrame
  end
  object cbFIO: TCheckBox
    Left = 10
    Top = 85
    Width = 97
    Height = 17
    Caption = #1060#1048#1054
    TabOrder = 0
  end
  object cbCity: TCheckBox
    Left = 10
    Top = 105
    Width = 97
    Height = 17
    Caption = #1043#1086#1088#1086#1076
    TabOrder = 1
  end
  object cbStreet: TCheckBox
    Left = 10
    Top = 125
    Width = 97
    Height = 17
    Caption = #1059#1083#1080#1094#1072
    TabOrder = 2
  end
  object cbBuilding: TCheckBox
    Left = 10
    Top = 145
    Width = 97
    Height = 17
    Caption = #1044#1086#1084
    TabOrder = 3
  end
  object cbApartment: TCheckBox
    Left = 10
    Top = 165
    Width = 97
    Height = 17
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072
    TabOrder = 4
  end
  object btnOK: TButton
    Left = 20
    Top = 190
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 5
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 110
    Top = 190
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 6
  end
  object cbOpenTime: TCheckBox
    Left = 10
    Top = 35
    Width = 97
    Height = 17
    Caption = #1057#1086#1079#1076#1072#1085
    TabOrder = 7
  end
  object cbCloseTime: TCheckBox
    Left = 10
    Top = 55
    Width = 97
    Height = 17
    Caption = #1047#1072#1082#1088#1099#1090
    TabOrder = 8
  end
  object PrintGrid: TPrintDBGridEh
    DBGridEh = frmAbonent.GridAbonent
    Options = [pghFitGridToPageWidth, pghFitingByColWidths]
    PageFooter.Font.Charset = DEFAULT_CHARSET
    PageFooter.Font.Color = clWindowText
    PageFooter.Font.Height = -11
    PageFooter.Font.Name = 'MS Sans Serif'
    PageFooter.Font.Style = []
    PageFooter.RightText.Strings = (
      '&[Page]/&[Pages]')
    PageHeader.Font.Charset = DEFAULT_CHARSET
    PageHeader.Font.Color = clWindowText
    PageHeader.Font.Height = -11
    PageHeader.Font.Name = 'MS Sans Serif'
    PageHeader.Font.Style = []
    PrintFontName = 'Times New Roman'
    Units = MM
    Left = 130
    Top = 111
    BeforeGridText_Data = {
      7B5C727466315C616E73695C616E7369637067313235315C64656666305C6465
      666C616E67313034397B5C666F6E7474626C7B5C66305C666E696C5C66636861
      727365743230347B5C2A5C666E616D652054696D6573204E657720526F6D616E
      3B7D54696D6573204E657720526F6D616E204359523B7D7D0D0A5C766965776B
      696E64345C7563315C706172645C71635C6C616E67313033335C625C66305C66
      73323420315C6C616E6731303439200D0A5C706172207D0D0A00}
  end
end
