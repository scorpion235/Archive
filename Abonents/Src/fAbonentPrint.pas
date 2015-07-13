//Абоненты - печать
unit fAbonentPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PrnDbgeh, ExtCtrls;

type
  TfrmAbonentPrint = class(TForm)
    cbFIO: TCheckBox;
    cbCity: TCheckBox;
    cbStreet: TCheckBox;
    cbBuilding: TCheckBox;
    cbApartment: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    PrintGrid: TPrintDBGridEh;
    cbOpenTime: TCheckBox;
    cbCloseTime: TCheckBox;
    lblAccPu: TLabel;
    Bevel: TBevel;
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
  frmAbonentPrint: TfrmAbonentPrint;

implementation

uses
        fAbonent,
        uCommon;

{$R *.dfm}

procedure TfrmAbonentPrint.FormCreate(Sender: TObject);
begin
	LoadFromIni;
end;

procedure TfrmAbonentPrint.FormClose(Sender: TObject;
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
procedure TfrmAbonentPrint.LoadFromIni;
var
	sect: string;
begin
	sect := 'AbonentPrint';
        cbOpenTime.Checked  := OptionsIni.ReadBool(sect, 'OpenTime', false);
        cbCloseTime.Checked := OptionsIni.ReadBool(sect, 'CloseTime', false);
        cbFIO.Checked       := OptionsIni.ReadBool(sect, 'FIO', false);
        cbCity.Checked      := OptionsIni.ReadBool(sect, 'City', false);
        cbStreet.Checked    := OptionsIni.ReadBool(sect, 'Street', false);
        cbBuilding.Checked  := OptionsIni.ReadBool(sect, 'Building', false);
        cbApartment.Checked := OptionsIni.ReadBool(sect, 'Apartment', false);
end;

//сохранение параметров в ini-файл
procedure TfrmAbonentPrint.SaveToIni;
var
	sect: string;
begin
	sect := 'AbonentPrint';
        OptionsIni.WriteBool(sect, 'OpenTime', cbOpenTime.Checked);
        OptionsIni.WriteBool(sect, 'CloseTime', cbCloseTime.Checked);
        OptionsIni.WriteBool(sect, 'FIO', cbFIO.Checked);
        OptionsIni.WriteBool(sect, 'City', cbCity.Checked);
        OptionsIni.WriteBool(sect, 'Street', cbStreet.Checked);
        OptionsIni.WriteBool(sect, 'Building', cbBuilding.Checked);
        OptionsIni.WriteBool(sect, 'Apartment', cbApartment.Checked);
end;

//нажатие на кнопку OK
procedure TfrmAbonentPrint.btnOKClick(Sender: TObject);
var
	i: word;
        close_time_visible: boolean;
begin
	close_time_visible := false;

        for i := 0 to PrintGrid.DBGridEh.Columns.Count - 1 do
        begin
        	//создан (л/с)
                if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'OPEN_TIME') and (not cbOpenTime.Checked)) then
                	PrintGrid.DBGridEh.Columns.Items[i].Visible := false;

                //закрыт (л/с)
                if (PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'CLOSE_TIME') then
                begin
                        close_time_visible := PrintGrid.DBGridEh.Columns.Items[i].Visible;

                	if(not cbCloseTime.Checked) then
                		PrintGrid.DBGridEh.Columns.Items[i].Visible := false;
                end;

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
        end;


	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := 'Абоненты';
		PrintGrid.Preview;
	end;

        for i := 0 to PrintGrid.DBGridEh.Columns.Count - 1 do
                if (PrintGrid.DBGridEh.Columns.Items[i].FieldName = 'CLOSE_TIME') then
                        PrintGrid.DBGridEh.Columns.Items[i].Visible := close_time_visible

                else
		if ((PrintGrid.DBGridEh.Columns.Items[i].FieldName <> 'SERVICE_ID')
                and (PrintGrid.DBGridEh.Columns.Items[i].FieldName <> 'SUBSRV_ID')
                and (PrintGrid.DBGridEh.Columns.Items[i].FieldName <> 'SUB_SRV')) then
             		PrintGrid.DBGridEh.Columns.Items[i].Visible := true;
end;

end.
