//Справочник улиц
unit fManualStreet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, xlcClasses, xlEngine, xlReport, Menus, ImgList;

type
  TfrmManualStreet = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edStreet: TDBEditEh;
    pnlFilterTop: TPanel;
    mdManualStreet: TRxMemoryData;
    dsManualStreet: TDataSource;
    mdManualStreetID: TFloatField;
    GridManualStreet: TDBGridEh;
    lblStreet: TLabel;
    mdManualStreetSTATUS: TStringField;
    mdManualStreetSTREET_NAME: TStringField;
    mdManualStreetCITY_NAME: TStringField;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
    xlReport: TxlReport;
    lblStatus: TLabel;
    PopupMenu: TPopupMenu;
    pmExcel: TMenuItem;
    ImageList: TImageList;
    cbStatus: TDBComboBoxEh;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualStreetSortMarkingChanged(Sender: TObject);
    procedure cbCityChange(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure edStreetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure SetStatusList(cb: TDBComboBoxEh);
    procedure RunQuery;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    fStartQuery: boolean;
  end;

var
  frmManualStreet: TfrmManualStreet;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualStreet.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        mdManualStreet.Active := true;
        fStartQuery           := false;

        SetCityList(cbCity);
        SetStatusList(cbStatus);

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualStreet.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmManualStreet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualStreet.Active := false;
	Action := caFree;
end;

//задание списка городов в комбобокс
procedure TfrmManualStreet.SetCityList(cb: TDBComboBoxEh);
begin
	DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(NAME)'
	+ ' FROM KP.CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualStreet).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все города]');
        cb.KeyItems.Add('[Все города]');
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
end;

//задание списка статусов в комбобокс
procedure TfrmManualStreet.SetStatusList(cb: TDBComboBoxEh);
begin
        cb.Items.Clear;

	cb.Items.Add('[Все статусы]');
        cb.Items.Add('Новая');
        cb.Items.Add('Подтвержденная');
        cb.Items.Add('Удаленная');

	cb.KeyItems.Add('[Все статусы]');
        cb.KeyItems.Add('Новая');
        cb.KeyItems.Add('Подтвержденная');
        cb.KeyItems.Add('Удаленная');
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualStreet.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualStreet';
	pnlFilter.Width    := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        cbStatus.ItemIndex := OptionsIni.ReadInteger(sect, 'StatusItem', 0);
        cbCity.ItemIndex   := OptionsIni.ReadInteger(sect, 'CityItem', 0);
        edStreet.Text      := OptionsIni.ReadString(sect, 'Street', '');
end;

//сохранение параметров в ini-файл
procedure TfrmManualStreet.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualStreet';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteInteger(sect, 'StatusItem', cbStatus.ItemIndex);
        OptionsIni.WriteInteger(sect, 'CityItem', cbCity.ItemIndex);
        OptionsIni.WriteString(sect, 'Street', edStreet.Text );
end;

//обновить
procedure TfrmManualStreet.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualStreet.Columns.Count - 1 do
        	GridManualStreet.Columns[i].Title.SortMarker := smNoneEh;

	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualStreet.AcToExcelExecute(Sender: TObject);
begin
        xlReport.Params.Items[0].AsString := cbCity.Text;
        xlReport.Params.Items[1].AsString := cbStatus.Text;
        xlReport.Params.Items[2].AsString := edStreet.Text;

    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualStreet.pmExcelClick(Sender: TObject);
begin
    	xlReport.Params.Items[0].AsString := cbCity.Text;
        xlReport.Params.Items[1].AsString := cbStatus.Text;
        xlReport.Params.Items[2].AsString := edStreet.Text;

    	ProgressReport(xlReport);
end;

procedure TfrmManualStreet.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmManualStreet.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT S.ID'
        	+ ', S.STATUS'
     		+ ', S.NAME AS STREET_NAME'
     		+ ', C.NAME AS CITY_NAME'
	+ ' FROM KP.CITY_LIST C'
   		+ ', KP.COUNTRY_LIST COUNTRY'
   		+ ', KP.STREET_LIST S'
	+ ' WHERE S.CITY_ID = C.ID');

        //выбран город
        if (cbCity.ItemIndex <> 0) then
	        DataMod.OracleDataSet.SQL.Add(' AND C.NAME = ''' + cbCity.Text + '''');

        //выбран статус
        if (cbStatus.ItemIndex = 1) then
	        DataMod.OracleDataSet.SQL.Add(' AND S.STATUS = ''NEW''')
        else
        if (cbStatus.ItemIndex = 2) then
	        DataMod.OracleDataSet.SQL.Add(' AND S.STATUS = ''OLD''')
        else
        if (cbStatus.ItemIndex = 3) then
	        DataMod.OracleDataSet.SQL.Add(' AND S.STATUS = ''DEL''');

	//указан шаблон названия улицы
        if (edStreet.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edStreet.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY C.ID');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualStreet).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmManualStreet.CopyToMemoryData;
var
	record_count: integer;
begin
	GridManualStreet.DataSource.DataSet.DisableControls;
   	mdManualStreet.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualStreet.Append;
                mdManualStreet.FieldByName('ID').AsInteger := DataMod.OracleDataSet.FieldByName('ID').AsInteger;

                if (DataMod.OracleDataSet.FieldByName('STATUS').AsString = 'OLD') then
                	mdManualStreet.FieldByName('STATUS').AsString := 'Подтвержденная'
                else
                if (DataMod.OracleDataSet.FieldByName('STATUS').AsString = 'NEW') then
                	mdManualStreet.FieldByName('STATUS').AsString := 'Новая'
                else
                if (DataMod.OracleDataSet.FieldByName('STATUS').AsString = 'DEL') then
        	        mdManualStreet.FieldByName('STATUS').AsString := 'Удаденная'
                else
                        mdManualStreet.FieldByName('STATUS').AsString := 'Неопознанный статус';

                mdManualStreet.FieldByName('STREET_NAME').AsString := DataMod.OracleDataSet.FieldByName('STREET_NAME').AsString;
                mdManualStreet.FieldByName('CITY_NAME').AsString   := DataMod.OracleDataSet.FieldByName('CITY_NAME').AsString;
                mdManualStreet.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualStreet.First;
        GridManualStreet.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualStreet.DataSource.DataSet.EnableControls;
end;

procedure TfrmManualStreet.pnlFilterResize(Sender: TObject);
begin
	cbCity.Width   := pnlFilter.Width - 20;
	cbStatus.Width := pnlFilter.Width - 20;
	edStreet.Width := pnlFilter.Width - 20;
end;

procedure TfrmManualStreet.GridManualStreetSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualStreet = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualStreet.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualStreet.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualStreet.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualStreet.SortOnFields(fields, false, desc);
end;

procedure TfrmManualStreet.cbCityChange(Sender: TObject);
begin
	if (fStartQuery = true) then
     		RunQuery;
end;

procedure TfrmManualStreet.edStreetKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edStreet.Text) > 2) then
                	RunQuery;
end;

end.
