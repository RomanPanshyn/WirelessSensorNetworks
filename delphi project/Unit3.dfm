object Form3: TForm3
  Left = 415
  Top = 258
  Width = 459
  Height = 623
  Caption = #1042#1099#1074#1086#1076' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1089#1077#1085#1089#1086#1088#1086#1074
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 17
  object Label1: TLabel
    Left = 96
    Top = 8
    Width = 210
    Height = 17
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1079#1083#1086#1074' '#1089#1077#1085#1089#1086#1088#1085#1086#1081' '#1089#1077#1090#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 32
    Width = 433
    Height = 497
    ColCount = 4
    DefaultColWidth = 100
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 50
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
  end
  object Button1: TButton
    Left = 88
    Top = 544
    Width = 75
    Height = 25
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 256
    Top = 544
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = Button2Click
  end
end
