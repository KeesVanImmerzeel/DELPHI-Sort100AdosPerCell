object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Sort100AdosPerCell'
  ClientHeight = 456
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 32
    Top = 208
    Width = 481
    Height = 73
    Lines.Strings = (
      
        '100 ado sets  worden op celbasis gesorteerd. Van de 1, 5, 10, 15' +
        ', 50, 75, 90, 95, 100 '
      
        'percentages wordt een ado-set gemaakt en samen in een nieuwe ado' +
        '-file weggeschreven. '
      ''
      'Voor Hans de Boer dec 2017')
    TabOrder = 0
  end
  object LabeledEditFileNamePrefix: TLabeledEdit
    Left = 32
    Top = 96
    Width = 145
    Height = 21
    EditLabel.Width = 163
    EditLabel.Height = 13
    EditLabel.Caption = 'FileName format  (bijv. Flairs*.flo)'
    TabOrder = 1
    Text = 'Flairs*.flo'
    OnChange = LabeledEditFileNamePrefixChange
  end
  object LabeledEditInputDir: TLabeledEdit
    Left = 32
    Top = 40
    Width = 731
    Height = 21
    EditLabel.Width = 190
    EditLabel.Height = 13
    EditLabel.Caption = 'Input folder with 100 ado (or *.flo) files'
    TabOrder = 2
    OnClick = LabeledEditInputDirClick
  end
  object LabeledEditSetName: TLabeledEdit
    Left = 32
    Top = 152
    Width = 145
    Height = 21
    EditLabel.Width = 71
    EditLabel.Height = 13
    EditLabel.Caption = 'Input Setname'
    TabOrder = 3
    Text = 'PHIT, STEADY-STATE=='
    OnChange = LabeledEditSetNameChange
  end
  object Button1: TButton
    Left = 640
    Top = 376
    Width = 75
    Height = 25
    Caption = 'Go'
    TabOrder = 4
    OnClick = Button1Click
  end
  object LargeRealArray1: TLargeRealArray
    Left = 568
    Top = 288
  end
  object SaveDialog1: TSaveDialog
    FileName = 'p.ado'
    Filter = '*.ado|*.ado'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Specify output ado-file'
    Left = 544
    Top = 368
  end
end
