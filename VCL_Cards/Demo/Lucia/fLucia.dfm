object FormLucia: TFormLucia
  Left = 178
  Top = 120
  Width = 694
  Height = 567
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1055#1072#1089#1100#1103#1085#1089' "'#1055#1088#1077#1082#1088#1072#1089#1085#1072#1103' '#1051#1102#1094#1080#1103'" (V 1.0)'
  Color = clGreen
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Card1: TCard
    Tag = 1
    Left = 8
    Top = 416
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
    OnClick = BazaClick
  end
  object Card2: TCard
    Tag = 2
    Left = 88
    Top = 416
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
    OnClick = BazaClick
  end
  object Card3: TCard
    Tag = 3
    Left = 168
    Top = 416
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
    OnClick = BazaClick
  end
  object Card4: TCard
    Tag = 4
    Left = 248
    Top = 416
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
    OnClick = BazaClick
  end
  object Coloda1: TColoda
    ColodType = tcFull
    Left = 8
    Top = 8
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 8
    object N1: TMenuItem
      Caption = '&'#1048#1075#1088#1072
      object NewGame1: TMenuItem
        Caption = #1053#1072#1095#1072#1090#1100' '#1080#1075#1088#1091
        ShortCut = 16462
        OnClick = NewGame1Click
      end
      object Setting1: TMenuItem
        Caption = #1055#1077#1088#1077#1083#1086#1078#1080#1090#1100
        Enabled = False
        ShortCut = 16449
        OnClick = Setting1Click
      end
      object Exit1: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        ShortCut = 32856
        OnClick = Exit1Click
      end
    end
  end
end
