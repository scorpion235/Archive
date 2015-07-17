//Платежи - печать
unit fPayPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PrnDbgeh;

type
  TfrmPayPrint = class(TForm)
    cbFIO: TCheckBox;
    cbCity: TCheckBox;
    cbStreet: TCheckBox;
    cbBuilding: TCheckBox;
    cbApartment: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    PrintGrid: TPrintDBGridEh;
    cbAgent: TCheckBox;
    cbUNO: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    { Public declarations }
  end;

var
  frmPayPrint: TfrmPayPrint;

implementation

uses
        fPay,
        uCommon;

{$R *.dfm}

procedure TfrmPayPrint.FormCreate(Sender: TObject);
begin
	LoadFromIni;
end;

procedure TfrmPayPrint.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	SaveToIni;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmPayPrint.LoadFromIni;
var
	sect: string;
begin
	sect := 'PayPrint';
        cbFIO.Checked       := OptionsIni.ReadBool(sect, 'FIO', false);
        cbCity.Checked      := OptionsIni.ReadBool(sect, 'City', false);
        cbStreet.Checked    := OptionsIni.ReadBool(sect, 'Street', false);
        cbBuilding.Checked  := OptionsIni.ReadBool(sect, 'Building', false);
        cbApartment.Checked := OptionsIni.ReadBool(sect, 'Apartment', false);
        cbAgent.Checked     := OptionsIni.ReadBool(sect, 'Agent', false);
        cbUNO.Checked       := OptionsIni.ReadBool(sect, 'UNO', false);
end;

//сохранение параметров в ini-файл
procedure TfrmPayPrint.SaveToIni;
var
	sect: string;
begin
	sect := 'PayPrint';
        OptionsIni.WriteBool(sect, 'FIO', cbFIO.Checked);
        OptionsIni.WriteBool(sect, 'City', cbCity.Checked);
        OptionsIni.WriteBool(sect, 'Street', cbStreet.Checked);
        OptionsIni.WriteBool(sect, 'Building', cbBuilding.Checked);
        OptionsIni.WriteBool(sect, 'Apartment', cbApartment.Checked);
        OptionsIni.WriteBool(sect, 'Agent', cbAgent.Checked);
        OptionsIni.WriteBool(sect, 'UNO', cbUNO.Checked);
end;

//нажатие на кнопку OK
procedure TfrmPayPrint.btnOKClick(Sender: TObject);
var
	i: word;
begin
        for i := 0 to PrintGrid.DBGridEh.Columns.Count - 1 do
        begin
        	//ФИО
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'FIO') and (not cbFIO.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //город
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'CITY') and (not cbCity.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //улица
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'STREET') and (not cbStreet.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //дом
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'BUILDING') and (not cbBuilding.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //квартира
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'APARTMENT') and (not cbApartment.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //агент
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'AGENT') and (not cbAgent.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //квитанция
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'UNO') and (not cbUNO.Checked)) then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := false;
        end;


	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := 'Платежи без лицевых счетов';
		PrintGrid.Preview;
	end;

        for i := 0 to PrintGrid.DBGridEh.Columns.Count - 1 do
		if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName <> 'AGENT_ID') and (PrintGrid.DBGridEh.Columns.Items[i].FieldName <> 'SERVICE_ID')) then
             		PrintGrid.DBGridEh.Columns.Items[i].Visible := true;


end;

end.
