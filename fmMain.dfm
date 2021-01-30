object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Colour Palette'
  ClientHeight = 517
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = chkShowCodeClick
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFunction: TPanel
    Left = 0
    Top = 0
    Width = 1030
    Height = 36
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 710
    object lblCodeGap: TLabel
      Left = 21
      Top = 11
      Width = 117
      Height = 13
      Caption = 'Colour Code Gap (2^N):'
    end
    object edtColourCount: TLabeledEdit
      Left = 296
      Top = 9
      Width = 65
      Height = 21
      EditLabel.Width = 67
      EditLabel.Height = 13
      EditLabel.Caption = 'Total Colours:'
      LabelPosition = lpLeft
      TabOrder = 0
      OnClick = edtColourCountClick
    end
    object cboCodeGap: TComboBox
      Left = 144
      Top = 9
      Width = 57
      Height = 21
      TabOrder = 1
      OnCloseUp = cboCodeGapCloseUp
      Items.Strings = (
        '128'
        '64'
        '32'
        '16'
        '8'
        '4'
        '2'
        '1')
    end
    object rdgFormat: TRadioGroup
      Left = 392
      Top = -6
      Width = 209
      Height = 38
      Columns = 3
      Ctl3D = True
      Items.Strings = (
        'Delphi'
        'C++'
        'HTML')
      ParentCtl3D = False
      TabOrder = 2
      OnClick = rdgFormatClick
    end
    object edtColourCode: TLabeledEdit
      Left = 683
      Top = 9
      Width = 65
      Height = 21
      EditLabel.Width = 63
      EditLabel.Height = 13
      EditLabel.Caption = 'Colour Code:'
      LabelPosition = lpLeft
      TabOrder = 3
    end
    object chkShowCode: TCheckBox
      Left = 779
      Top = 10
      Width = 78
      Height = 17
      Caption = 'Show Code'
      TabOrder = 4
      OnClick = chkShowCodeClick
    end
    object chkShowGrids: TCheckBox
      Left = 875
      Top = 10
      Width = 78
      Height = 17
      Caption = 'Show Grids'
      TabOrder = 5
      OnClick = chkShowGridsClick
    end
  end
  object dbgColour: TDBGrid
    Left = 0
    Top = 36
    Width = 1030
    Height = 481
    Align = alClient
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = dbgColourCellClick
    OnDrawColumnCell = dbgColourDrawColumnCell
  end
  object mtbColour: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 440
    Top = 112
  end
  object dsrColour: TDataSource
    DataSet = mtbColour
    Left = 440
    Top = 176
  end
end
