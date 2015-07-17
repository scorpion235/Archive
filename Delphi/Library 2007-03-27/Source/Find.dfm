object fmFind: TfmFind
  Left = 202
  Top = 114
  Width = 783
  Height = 540
  ActiveControl = btFind
  Caption = #1055#1086#1080#1089#1082' '#1082#1085#1080#1075
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 775
    Height = 80
    Align = alTop
    TabOrder = 0
    object laAutor: TLabel
      Left = 10
      Top = 20
      Width = 33
      Height = 13
      Caption = #1040#1074#1090#1086#1088':'
    end
    object laTitl: TLabel
      Left = 10
      Top = 50
      Width = 53
      Height = 13
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edAuthor: TEdit
      Left = 66
      Top = 15
      Width = 121
      Height = 21
      TabOrder = 0
      Text = #1072#1074#1090#1086#1088'2'
    end
    object edTitl: TEdit
      Left = 66
      Top = 45
      Width = 180
      Height = 21
      TabOrder = 1
      Text = #1085#1072#1079#1074#1072#1085#1080#1077'2'
    end
    object btFind: TButton
      Left = 280
      Top = 45
      Width = 75
      Height = 25
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 2
      OnClick = btFindClick
    end
    object btPrint: TButton
      Left = 370
      Top = 45
      Width = 73
      Height = 23
      Caption = #1055#1077#1095#1072#1090#1100
      DragKind = dkDock
      TabOrder = 3
      Visible = False
      OnClick = btPrintClick
    end
  end
  object dbgFind: TDBGrid
    Left = 0
    Top = 80
    Width = 775
    Height = 426
    Align = alClient
    DataSource = dmLib.dsFind
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Author'
        Title.Caption = #1040#1074#1090#1086#1088
        Width = 150
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Title'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 200
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Avail'
        Title.Caption = #1053#1072#1083#1080#1095#1080#1077
        Width = 60
        Visible = True
      end>
  end
end
