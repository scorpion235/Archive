object frmOptions: TfrmOptions
  Left = 527
  Top = 292
  ActiveControl = edExportPath
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
  ClientHeight = 266
  ClientWidth = 362
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
    Width = 362
    Height = 235
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 0
    object PageControl: TPageControl
      Left = 10
      Top = 10
      Width = 342
      Height = 215
      ActivePage = tsReestr
      Align = alClient
      MultiLine = True
      TabIndex = 0
      TabOrder = 0
      TabStop = False
      object tsReestr: TTabSheet
        Caption = #1056#1077#1077#1089#1090#1088
        object lblExportPath: TLabel
          Left = 10
          Top = 15
          Width = 99
          Height = 13
          Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1074#1099#1075#1088#1091#1079#1082#1080':'
        end
        object lblImportPath: TLabel
          Left = 10
          Top = 55
          Width = 97
          Height = 13
          Caption = #1055#1091#1090#1100' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080':'
        end
        object edExportPath: TLMDBrowseEdit
          Left = 10
          Top = 30
          Width = 300
          Height = 21
          Bevel.Mode = bmWindows
          Caret.BlinkRate = 530
          TabOrder = 0
          CustomButtonsStyle = ubsFlat
          CustomButtonWidth = 18
        end
        object edImportPath: TLMDBrowseEdit
          Left = 10
          Top = 70
          Width = 300
          Height = 21
          Bevel.Mode = bmWindows
          Caret.BlinkRate = 530
          TabOrder = 1
          CustomButtonsStyle = ubsFlat
          CustomButtonWidth = 18
        end
      end
      object tsAbonent: TTabSheet
        Caption = #1040#1073#1086#1085#1077#1085#1090#1099
        ImageIndex = 1
        object cbVisibleAccClose: TCheckBox
          Left = 10
          Top = 15
          Width = 310
          Height = 17
          Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1072#1073#1086#1085#1077#1085#1090#1086#1074' '#1089' '#1079#1072#1082#1088#1099#1090#1099#1084#1080' '#1083#1080#1094#1077#1074#1099#1084#1080' '#1089#1095#1077#1090#1072#1084#1080
          TabOrder = 0
        end
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 235
    Width = 362
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOK: TButton
      Left = 190
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
      Left = 275
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
