//Справочник городов
unit fManualCity;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmManualCity = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edCity: TDBEditEh;
    pnlFilterTop: TPanel;
    mdManualCity: TRxMemoryData;
    dsManualCity: TDataSource;
    mdManualCityID: TFloatField;
    mdManualCityCITY: TStringField;
    mdManualCityREGION_CODE: TIntegerField;
    mdManualCityREGION: TStringField;
    mdManualCityCOUNTRY: TStringField;
    GridManualCity: TDBGridEh;
    lblCity: TLabel;
    xlReport: TxlReport;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    pmExcel: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualCitySortMarkingChanged(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure edCityKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    fStartQuery: boolean;
  end;

var
  frmManualCity: TfrmManualCity;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualCity.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        mdManualCity.Active := true;
        fStartQuery         := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualCity.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmManualCity.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualCity.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualCity.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualCity';
	pnlFilter.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edCity.Text     := OptionsIni.ReadString(sect, 'City', '');
end;

//сохранение параметров в ini-файл
procedure TfrmManualCity.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualCity';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'City', edCity.Text);
end;

//обновить
procedure TfrmManualCity.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualCity.Columns.Count - 1 do
        	GridManualCity.Columns[i].Title.SortMarker := smNoneEh;

	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualCity.AcToExcelExecute(Sender: TObject);
begin
	xlReport.Params.Items[0].AsString := edCity.Text;
    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualCity.pmExcelClick(Sender: TObject);
begin
  	xlReport.Params.Items[0].AsString := edCity.Text;
    	ProgressReport(xlReport);
end;

procedure TfrmManualCity.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmManualCity.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT CITY.ID'
        	+ ', CITY.NAME AS CITY'
     		+ ', CITY.CODE AS REGION_CODE'
     		+ ', REGION.NAME AS REGION'
     		+ ', COUNTRY.NAME AS COUNTRY'
	+ ' FROM KP.CITY_LIST CITY'
   		+ ', KP.COUNTRY_LIST COUNTRY'
   		+ ', KP.REGION_LIST REGION'
	+ ' WHERE CITY.COUNTRY_ID = COUNTRY.ID'
		+ ' AND CITY.REGION_ID = REGION.ID');

	//указан шаблон названия города
        if (edCity.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(CITY.NAME) LIKE UPPER(''%' + edCity.Text + '%'')');


	DataMod.OracleDataSet.SQL.Add(' ORDER BY CITY.ID');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualCity).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmManualCity.CopyToMemoryData;
var
	record_count: integer;
begin
	GridManualCity.DataSource.DataSet.DisableControls;

   	mdManualCity.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualCity.Append;
                mdManualCity.FieldByName('ID').AsInteger         := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdManualCity.FieldByName('CITY').AsString        := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdManualCity.FieldByName('REGION_CODE').AsString := DataMod.OracleDataSet.FieldByName('REGION_CODE').AsString;
                mdManualCity.FieldByName('REGION').AsString      := DataMod.OracleDataSet.FieldByName('REGION').AsString;
                mdManualCity.FieldByName('COUNTRY').AsString     := DataMod.OracleDataSet.FieldByName('COUNTRY').AsString;
                mdManualCity.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualCity.First;
        GridManualCity.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualCity.DataSource.DataSet.EnableControls;
end;

procedure TfrmManualCity.pnlFilterResize(Sender: TObject);
begin
	edCity.Width := pnlFilter.Width - 20;
end;

procedure TfrmManualCity.GridManualCitySortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualCity = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualCity.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualCity.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualCity.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualCity.SortOnFields(fields, false, desc);
end;

procedure TfrmManualCity.edCityKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
        	if (Key = VK_RETURN) or (Length(edCity.Text) > 2) then
			RunQuery;
end;

end.
