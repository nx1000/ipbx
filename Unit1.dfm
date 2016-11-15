object fmPhoneCharge: TfmPhoneCharge
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Emerald - Starsys v2.1'
  ClientHeight = 269
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 18
    Top = 228
    Width = 32
    Height = 13
    Caption = 'Server'
  end
  object Button1: TButton
    Left = 320
    Top = 223
    Width = 75
    Height = 25
    Caption = 'START'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 408
    Top = 223
    Width = 75
    Height = 25
    Caption = 'STOP'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Memo1: TMemo
    Left = 18
    Top = 24
    Width = 473
    Height = 185
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 64
    Top = 225
    Width = 153
    Height = 21
    Enabled = False
    TabOrder = 3
  end
end
