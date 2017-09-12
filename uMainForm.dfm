object Form1: TForm1
  Left = 603
  Top = 167
  Width = 414
  Height = 522
  Caption = 'JAVA '#21161#25163
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 17
  object pgc1: TPageControl
    Left = 8
    Top = 8
    Width = 385
    Height = 473
    ActivePage = ts1
    TabOrder = 0
    object ts1: TTabSheet
      Caption = #29615#22659#21464#37327
      object lbl1: TLabel
        Left = 16
        Top = 19
        Width = 50
        Height = 17
        Caption = 'JDK '#30446#24405
      end
      object btnSelectDirectory: TSpeedButton
        Left = 328
        Top = 16
        Width = 24
        Height = 22
        Caption = '...'
        OnClick = btnSelectDirectoryClick
      end
      object lbl2: TLabel
        Left = 16
        Top = 50
        Width = 71
        Height = 17
        Caption = 'Tomcat '#30446#24405
      end
      object btnTomcat: TSpeedButton
        Left = 328
        Top = 48
        Width = 24
        Height = 22
        Caption = '...'
        OnClick = btnTomcatClick
      end
      object lbl3: TLabel
        Left = 16
        Top = 81
        Width = 73
        Height = 17
        Caption = 'MAVEN '#30446#24405
      end
      object btnMaven: TSpeedButton
        Left = 328
        Top = 79
        Width = 24
        Height = 22
        Caption = '...'
        OnClick = btnMavenClick
      end
      object edtJDK: TEdit
        Left = 112
        Top = 15
        Width = 209
        Height = 25
        TabOrder = 0
        Text = 'C:\Program files(x86)\'
      end
      object btn1: TBitBtn
        Left = 277
        Top = 400
        Width = 75
        Height = 25
        Caption = #24212#29992
        TabOrder = 1
        OnClick = btn1Click
      end
      object lst1: TListBox
        Left = 19
        Top = 110
        Width = 332
        Height = 283
        ItemHeight = 17
        TabOrder = 2
      end
      object edtTomcat: TEdit
        Left = 112
        Top = 46
        Width = 209
        Height = 25
        TabOrder = 3
      end
      object edtMaven: TEdit
        Left = 112
        Top = 77
        Width = 209
        Height = 25
        TabOrder = 4
      end
    end
  end
end
