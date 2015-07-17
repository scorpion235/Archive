object frmOptions: TfrmOptions
  Left = 527
  Top = 292
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 267
  ClientWidth = 352
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
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 352
    Height = 236
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object PageOption: TPageControl
      Left = 10
      Top = 10
      Width = 332
      Height = 216
      ActivePage = TabSheetInfo
      Align = alClient
      TabIndex = 0
      TabOrder = 0
      TabStop = False
      object TabSheetInfo: TTabSheet
        Caption = #1048#1085#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077
        object Bevel1: TBevel
          Left = 140
          Top = 15
          Width = 170
          Height = 5
          Shape = bsBottomLine
        end
        object lblValue1: TLabel
          Left = 10
          Top = 35
          Width = 39
          Height = 13
          Caption = #1041#1086#1083#1100#1096#1077
        end
        object lblTimeOut1: TLabel
          Left = 10
          Top = 60
          Width = 41
          Height = 13
          Caption = #1050#1072#1078#1076#1099#1077
        end
        object lblValue2: TLabel
          Left = 145
          Top = 35
          Width = 99
          Height = 13
          Caption = #1085#1077#1087#1088#1080#1074#1103#1079#1072#1085#1099#1093' '#1091#1083#1080#1094
        end
        object lblTimeOut2: TLabel
          Left = 145
          Top = 60
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
        end
        object Bevel2: TBevel
          Left = 140
          Top = 95
          Width = 170
          Height = 5
          Shape = bsBottomLine
        end
        object lblValue3: TLabel
          Left = 10
          Top = 115
          Width = 39
          Height = 13
          Caption = #1041#1086#1083#1100#1096#1077
        end
        object lblTimeOut3: TLabel
          Left = 10
          Top = 140
          Width = 41
          Height = 13
          Caption = #1050#1072#1078#1076#1099#1077
        end
        object lblValue4: TLabel
          Left = 145
          Top = 115
          Width = 134
          Height = 13
          Caption = #1085#1077#1086#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1093' '#1088#1077#1077#1089#1090#1088#1086#1074
        end
        object lblTimeOut4: TLabel
          Left = 145
          Top = 140
          Width = 21
          Height = 13
          Caption = #1089#1077#1082'.'
        end
        object cbUnCorrectStreet: TCheckBox
          Left = 10
          Top = 10
          Width = 140
          Height = 17
          Caption = #1053#1077#1087#1088#1080#1074#1103#1079#1072#1085#1085#1099#1077' '#1091#1083#1080#1094#1099
          TabOrder = 0
          OnClick = cbUnCorrectStreetClick
        end
        object edUnCorrectStreetTimeOut: TRxSpinEdit
          Left = 60
          Top = 55
          Width = 80
          Height = 21
          MaxValue = 100000
          MinValue = 10
          TabOrder = 1
        end
        object edUnCorrectStreetValue: TRxSpinEdit
          Left = 60
          Top = 30
          Width = 80
          Height = 21
          MaxValue = 100000
          MinValue = 10
          TabOrder = 2
        end
        object cbReeArc: TCheckBox
          Left = 10
          Top = 90
          Width = 155
          Height = 17
          Caption = #1053#1077#1086#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1077' '#1088#1077#1077#1089#1090#1088#1099
          TabOrder = 3
          OnClick = cbReeArcClick
        end
        object edReeArcValue: TRxSpinEdit
          Left = 60
          Top = 110
          Width = 80
          Height = 21
          MaxValue = 100000
          TabOrder = 4
        end
        object edReeArcTimeOut: TRxSpinEdit
          Left = 60
          Top = 135
          Width = 80
          Height = 21
          MaxValue = 100000
          MinValue = 10
          TabOrder = 5
        end
      end
      object TabSheetInterface: TTabSheet
        Caption = #1048#1085#1090#1077#1088#1092#1077#1081#1089
        ImageIndex = 1
        object cbUseColorMode: TCheckBox
          Left = 10
          Top = 10
          Width = 250
          Height = 17
          Caption = #1062#1074#1077#1090#1086#1074#1086#1077' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1072#1073#1083#1080#1094#1072#1093
          TabOrder = 0
          OnClick = cbUnCorrectStreetClick
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 236
    Width = 352
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 180
      Top = 0
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 265
      Top = 0
      Width = 75
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
end
