unit fmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Math, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    mtbColour: TFDMemTable;
    dsrColour: TDataSource;
    pnlFunction: TPanel;
    dbgColour: TDBGrid;
    edtColourCount: TLabeledEdit;
    cboCodeGap: TComboBox;
    lblCodeGap: TLabel;
    rdgFormat: TRadioGroup;
    edtColourCode: TLabeledEdit;
    chkShowCode: TCheckBox;
    chkShowGrids: TCheckBox;
    procedure dbgColourDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure edtColourCountClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cboCodeGapCloseUp(Sender: TObject);
    procedure rdgFormatClick(Sender: TObject);
    procedure dbgColourCellClick(Column: TColumn);
    procedure chkShowCodeClick(Sender: TObject);
    procedure chkShowGridsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  PreFix_Delphi = '$';
  PreFix_CPP    = '0x';
  PreFix_HTML   = '#';
  N_Grid_Width  = 2;

var
  frmMain: TfrmMain;
  aryFieldColour: Array of TField;

function udfIntToStrWithComma(ANumber: Integer): String;
procedure udpCreateColours(ACodeGap: Integer);

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  with cboCodeGap do begin
    Style := csDropDownList;
  end;

  with edtColourCount do begin
    Alignment := taRightJustify;
    Text := '0';
  end;

  with dbgColour do begin
    DataSource := dsrColour;
    Options := Options - [dgTitles, dgColLines, dgRowLines];
    ReadOnly := True;
  end;

  rdgFormat.ItemIndex := 0;
end;

procedure TfrmMain.rdgFormatClick(Sender: TObject);
begin
  cboCodeGap.OnCloseUp(Sender);
end;

procedure TfrmMain.cboCodeGapCloseUp(Sender: TObject);
begin
  if Length(cboCodeGap.Text) = 0 then exit;

  udpCreateColours(StrToInt(cboCodeGap.Text));
  edtColourCount.OnClick(Sender);
end;

procedure TfrmMain.chkShowCodeClick(Sender: TObject);
var
  k: Integer;
  bShowCode: Boolean;
  nColWidth, nScrollWidth: Integer;
begin
  nScrollWidth := GetSystemMetrics(SM_CXVSCROLL) + 12;   // DBGrid indicator column width

  bShowCode := chkShowCode.Checked;

  with dbgColour do
  if bShowCode then
    nColWidth := (Width - nScrollWidth) div Columns.Count
  else
    nColWidth := (Width - nScrollWidth) * 2 div Columns.Count;

  if chkShowGrids.Checked then  nColWidth := nColWidth - N_Grid_Width;

  with dbgColour do
  for k := 0 to (Columns.Count - 1) do begin
    Columns[k].Visible := bShowCode OR (k MOD 2 = 1);
    Columns[k].Width := nColWidth;
  end;
end;

procedure TfrmMain.chkShowGridsClick(Sender: TObject);
var
  k: Integer;
  nColWidth: Integer;
begin
  with dbgColour do begin
    if chkShowGrids.Checked then begin
      Options := Options + [dgColLines, dgRowLines];
      nColWidth := Columns[1].Width - N_Grid_Width;
    end else begin
      Options := Options - [dgColLines, dgRowLines];
      nColWidth := Columns[1].Width + N_Grid_Width;
    end;

    for k := 0 to (Columns.Count - 1) do Columns[k].Width := nColWidth;
  end;
end;

procedure TfrmMain.dbgColourCellClick(Column: TColumn);
var
  nFieldNo: Integer;
begin
  if NOT mtbColour.Active then exit;

  // Set colour for one cell
  nFieldNo := StrToInt(Copy(Column.FieldName, 2));
  if nFieldNo MOD 2 = 0 then
    edtColourCode.Text := aryFieldColour[nFieldNo - 2].AsString
  else
    edtColourCode.Text := aryFieldColour[nFieldNo - 1].AsString;
end;

procedure TfrmMain.dbgColourDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  nFieldNo: Integer;

  function udfGetColourCode(AOption: Integer; AColourCode: String): String;
  var
    sCodeA, sCodeB, sCodeC: String;
    nLen: Integer;
  begin
    nLen := Length(AColourCode);
    sCodeA := Copy(AColourCode, nLen - 6 + 1, 2);
    sCodeB := Copy(AColourCode, nLen - 4 + 1, 2);
    sCodeC := Copy(AColourCode, nLen - 2 + 1, 2);

    case AOption of
      0: Result := PreFix_Delphi + sCodeA + sCodeB + sCodeC;
      1: Result := PreFix_Delphi + sCodeA + sCodeB + sCodeC;
      2: Result := PreFix_Delphi + sCodeC + sCodeB + sCodeA;
    end;
  end;

begin
  if NOT TDBGrid(Sender).DataSource.DataSet.Active then exit;

  // Set colour for one cell
  nFieldNo := StrToInt(Copy(Column.FieldName, 2));
  if (nFieldNo MOD 2) = 0 then begin
    if Length(aryFieldColour[nFieldNo - 2].AsString) > 0 then begin
      TDBGrid(Sender).Canvas.Brush.Color :=
        TColor(StrToInt(udfGetColourCode(rdgFormat.ItemIndex, aryFieldColour[nFieldNo - 2].AsString)));
      TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  end;
end;

procedure TfrmMain.edtColourCountClick(Sender: TObject);
begin
  with mtbColour do edtColourCount.Text := udfIntToStrWithComma(RecordCount * FieldCount);
end;

function udfIntToStrWithComma(ANumber: Integer): String;
var
  sNumber: String;
begin
  sNumber := Format('%n', [Double(ANumber)]);
  Result := Copy(sNumber, 1, Pos('.', sNumber) - 1);
end;

// Delphi colour code format is $BBGGRR
procedure udpCreateColours(ACodeGap: Integer);
var
  R, G, B: Integer;
  Row, Column: Integer;
  k: Integer;
  bBof: Boolean;
  sPreFixCode: String;
begin
  case frmMain.rdgFormat.ItemIndex of
    0: sPreFixCode := PreFix_Delphi;
    1: sPreFixCode := PreFix_CPP;
    2: sPreFixCode := PreFix_HTML;
  end;

  with frmMain.mtbColour do begin
    DisableControls;

    if Active then begin
      EmptyDataSet;
      for k := (FieldCount - 1) downto 0 do FieldDefs.Delete(k);
      Close;
    end;
    for k := 1 to ((Ceil(256 div ACodeGap) + 1) * 2) do
      FieldDefs.Add('F' + Format('%.3d', [k]), ftString, 8);
    Open;

    SetLength(aryFieldColour, FieldCount);
    for k := 0 to (Length(aryFieldColour) - 1) do aryFieldColour[k] := Fields[k];

    Row := 0;
    B := 0;
    while B <= 255 do begin
      Column := 0;
      G := 0;
      while G <= 255 do begin
        if Row > 0 then begin
          for k := 0 to Row - 1 do Prior;
          bBof := BOF;
        end;

        Row := 0;
        R := 0;
        while R <= 255 do begin
          if Column = 0 then begin
            Append;
          end else begin
            if bBof then
              bBof := False
            else
              Next;
            Edit;
          end;

          aryFieldColour[Column * 2].Value := sPreFixCode + IntToHex(B, 2) + IntToHex(G, 2) + IntToHex(R, 2);

          INC(Row);
          if (R < 255) AND ((R + ACodeGap) > 255) then R := 255 else R := R + ACodeGap;
        end;

        INC(Column);
        if (G < 255) AND ((G + ACodeGap) > 255) then G := 255 else G := G + ACodeGap;
      end;

      if (B < 255) AND ((B + ACodeGap) > 255) then B := 255 else B := B + ACodeGap;
    end;

    First;
    EnableControls;
  end;

  frmMain.chkShowCode.OnClick(frmMain.chkShowCode);
end;

end.
