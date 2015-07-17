object frmMain: TfrmMain
  Left = 228
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'frmMain'
  ClientHeight = 119
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 105
    Height = 105
  end
  object CopyPuskBtn: TButton
    Left = 130
    Top = 10
    Width = 75
    Height = 25
    Caption = 'Copy'
    TabOrder = 0
    OnClick = CopyPuskBtnClick
  end
  object AnimateBtn: TButton
    Left = 130
    Top = 42
    Width = 75
    Height = 25
    Caption = 'Animate'
    Enabled = False
    TabOrder = 1
    OnClick = AnimateBtnClick
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 54
    Top = 58
  end
end
