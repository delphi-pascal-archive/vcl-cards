object Form1: TForm1
  Left = 230
  Top = 123
  Width = 433
  Height = 232
  Caption = #1055#1088#1080#1084#1077#1088' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1072' "TColoda"'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Card1: TCard
    Left = 24
    Top = 16
    Width = 71
    Height = 96
    Suit = cChervi
    CardValue = 1
    Invert = False
    Mask = False
    CardStyle = scNone
    Pile = False
    Rotation = orVertical
    MaskColor = clGray
  end
  object Label1: TLabel
    Left = 88
    Top = 128
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 24
    Top = 128
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Button1: TButton
    Left = 8
    Top = 168
    Width = 75
    Height = 25
    Caption = #1055#1088#1077#1076'.'#1082#1072#1088#1090#1072
    Enabled = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 88
    Top = 168
    Width = 75
    Height = 25
    Caption = #1057#1083#1077#1076'. '#1082#1072#1088#1090#1072
    Enabled = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 320
    Top = 48
    Width = 99
    Height = 25
    Caption = #1058#1072#1089#1086#1074#1072#1090#1100' '#1082#1086#1083#1086#1076#1091
    Enabled = False
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 320
    Top = 16
    Width = 97
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1083#1086#1076#1091
    TabOrder = 3
    OnClick = Button4Click
  end
  object RadioGroup1: TRadioGroup
    Left = 176
    Top = 8
    Width = 137
    Height = 105
    Caption = #1050#1086#1083#1086#1076#1072
    ItemIndex = 0
    Items.Strings = (
      #1054#1073#1099#1095#1085#1072#1103' '#1082#1086#1083#1086#1076#1072
      #1044#1074#1086#1081#1085#1072#1103' '#1082#1086#1083#1086#1076#1072
      #1055#1080#1082#1077#1090#1085#1072#1103' '#1082#1086#1083#1086#1076#1072)
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 176
    Top = 120
    Width = 241
    Height = 65
    BevelInner = bvLowered
    TabOrder = 5
    object EdSuit: TComboBox
      Left = 8
      Top = 8
      Width = 121
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = #1063#1077#1088#1074#1099
      Items.Strings = (
        #1063#1077#1088#1074#1099
        #1041#1091#1073#1085#1099
        #1058#1088#1077#1092#1099
        #1055#1080#1082#1080
        #1044#1078#1086#1082#1077#1088)
    end
    object EdValue: TSpinEdit
      Left = 8
      Top = 32
      Width = 121
      Height = 22
      MaxValue = 13
      MinValue = 0
      TabOrder = 1
      Value = 1
    end
    object Button5: TButton
      Left = 136
      Top = 8
      Width = 97
      Height = 25
      Caption = #1053#1072#1081#1090#1080' '#1082#1072#1088#1090#1091
      Enabled = False
      TabOrder = 2
      OnClick = Button5Click
    end
  end
  object Coloda1: TColoda
    ColodType = tcPicket
    UseJoker = True
    Left = 112
    Top = 16
  end
end
