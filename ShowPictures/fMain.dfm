object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1080#1083#1083#1102#1089#1090#1088#1072#1094#1080#1081
  ClientHeight = 473
  ClientWidth = 792
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 170
    Top = 0
    Height = 454
    ExplicitLeft = 288
    ExplicitTop = 140
    ExplicitHeight = 100
  end
  object TreeView: TTreeView
    Left = 0
    Top = 0
    Width = 170
    Height = 454
    Align = alLeft
    Indent = 19
    ShowButtons = False
    ShowLines = False
    TabOrder = 0
    OnChange = TreeViewChange
    OnExpanding = TreeViewExpanding
  end
  object pnlImages: TPanel
    Left = 173
    Top = 0
    Width = 619
    Height = 454
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 372
    ExplicitTop = 240
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 454
    Width = 792
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitLeft = 400
    ExplicitTop = 242
    ExplicitWidth = 0
  end
end
