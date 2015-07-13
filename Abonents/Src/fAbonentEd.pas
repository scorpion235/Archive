//Корректировка абонентов
unit fAbonentEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls, ToolEdit,
  CurrEdit;

type
  TfrmAbonentEd = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edAbonent_id: TDBEditEh;
    lblService: TLabel;
    cbService: TDBComboBoxEh;
    lblSubSrv: TLabel;
    cbSubSrv: TDBComboBoxEh;                                       
    lblFIO: TLabel;
    edFIO: TDBEditEh;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
    lblStreet: TLabel;
    cbStreet: TDBComboBoxEh;
    lblBuilding: TLabel;
    edBuilding: TDBEditEh;
    lblApartment: TLabel;
    edApartment: TDBEditEh;
    lblBalance: TLabel;
    lblAcc_pu: TLabel;
    edAcc_pu: TDBEditEh;
    cbAllSubSrv: TCheckBox;
    edBalance: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbServiceChange(Sender: TObject);
    procedure cbCityChange(Sender: TObject);
    procedure cbAllSubSrvClick(Sender: TObject);
  private
    fForm_mode: string[10];
    fSetSubSrvList: boolean;
    fSetStreetList: boolean;
    procedure SetServiceList(cb: TDBComboBoxEh);
    procedure SetSubSrvList(cb: TDBComboBoxEh);
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure SetStreetList(cb: TDBComboBoxEh);
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    procedure AddAbonent(ds: TDataSource);
    //функция возвращает количество записей из таблицы
    //абоненентов с таким же л/с по выбранной услуге
    function EditAbonent(ds: TDataSource): word;
  end;

var
  frmAbonentEd: TfrmAbonentEd;

implementation

uses
        fAllSubSrvWarning,
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmAbonentEd.FormCreate(Sender: TObject);
begin
	edAbonent_id.Visible := false;
        edBalance.Enabled    := false;
        fSetSubSrvList       := false;
        fSetStreetList       := false;

        fForm_mode := 'add';
	SetServiceList(cbService);
        SetCityList(cbCity);
        //SetSubSrvList и SetStreetList вызывается в LoadFromIni

        LoadFromIni;

        fSetSubSrvList := true;
        fSetStreetList := true;
end;

//задание списка услуг
procedure TfrmAbonentEd.SetServiceList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT SERVICE_ID, NAME'
	+ ' FROM SERVICES'
        + ' WHERE VISIBLE = 1'
        + ' AND "TYPE" = ''MAIN''' //отображаются только основные услуги
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка услуг.');
                exit;
	end;

        //количество услуг = 0
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	WarningBox('Не выбрана ни одна основная услуга для отображения.' + #13 +
                'Добавление абонентов невозможно.' + #13 + #13 +
		'Выберите услигу(и) в справочнике услуг.');
                btnOK.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        cb.Items.Clear;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//задание списка подуслуг
procedure TfrmAbonentEd.SetSubSrvList(cb: TDBComboBoxEh);
begin
        cb.Items.Clear;
        cb.Enabled := false;
        lblSubSrv.Font.Color := clBlack;
        cbAllSubSrv.Visible  := false;
        cbAllSubSrv.Checked  := false;

        DataMod.IB_Cursor.SQL.Text := 'SELECT SUBSRV_ID, NAME'
        + ' FROM SUBSRV'
	+ ' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
	+ ' ORDER BY NAME';
        
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка подуслуг.');
                exit;
	end;

	//у услуги нет подуслуг
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	cb.Items.Add('нет подуслуг');
                cb.KeyItems.Add('нет подуслуг');
                cb.ItemIndex := 0;
        	cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        //отобразить чек-бокс "Все подуслуги"
        if (fForm_mode = 'add') then
        begin
        	cb.Enabled := false;
                cbAllSubSrv.Visible := true;
                cbAllSubSrv.Checked := true;
        end;

        lblSubSrv.Font.Color := clRed;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SUBSRV_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        cb.ItemIndex := 0;
        DataMod.IB_Cursor.Close;
end;

//задание списка городов
procedure TfrmAbonentEd.SetCityList(cb: TDBComboBoxEh);
begin
	DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Text := 'SELECT CITY_ID, NAME'
	+ ' FROM CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка городов.');
                exit;
	end;

        cb.Items.Clear;
        //cb.Items.Add('');
        //cb.KeyItems.Add('');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('CITY_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//задание списка улиц
procedure TfrmAbonentEd.SetStreetList(cb: TDBComboBoxEh);
begin
        cb.Items.Clear;
        cb.Enabled := false;

        DataMod.IB_Cursor.SQL.Text := 'SELECT STREET_ID, NAME'
        + ' FROM STREET_LIST'
	+ ' WHERE CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
	+ ' ORDER BY NAME';
        
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка улиц.');
                exit;
	end;

	//у города нет улиц
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	cb.Items.Add('нет улиц');
                cb.KeyItems.Add('нет улиц');
                cb.ItemIndex := 0;
        	cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        cb.Enabled := true;
        //cb.Items.Add('');
        //cb.KeyItems.Add('');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('STREET_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        cb.ItemIndex := 0;
        DataMod.IB_Cursor.Close;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmAbonentEd.LoadFromIni;
var
	sect: string;
begin
	sect := 'AbonentEd';

        if (cbService.Items.Count > 0) then
        	cbService.Text := OptionsIni.ReadString(sect, 'Service', '');

        if (cbService.Text = '') then
         	cbService.ItemIndex := 0;

        SetSubSrvList(cbSubSrv);

        cbSubSrv.Text    := OptionsIni.ReadString(sect, 'SubSrv', '[Все подуслуги]');
        if (cbSubSrv.Text = '') then
         	cbSubSrv.ItemIndex := 0;

        edAcc_pu.Text    := OptionsIni.ReadString(sect, 'Acc_pu', '');
        edFIO.Text       := OptionsIni.ReadString(sect, 'FIO', '');
        cbCity.Text      := OptionsIni.ReadString(sect, 'City', 'Челябинск');

        SetStreetList(cbStreet);

        cbStreet.Text    := OptionsIni.ReadString(sect, 'Street', '');
        edBuilding.Text  := OptionsIni.ReadString(sect, 'Building', '');
        edApartment.Text := OptionsIni.ReadString(sect, 'Apartment', '');
end;

//сохранение параметров в ini-файл
procedure TfrmAbonentEd.SaveToIni;
var
	sect: string;
begin
	sect := 'AbonentEd';
	OptionsIni.WriteString(sect, 'Service', cbService.Text);
        OptionsIni.WriteString(sect, 'SubSrv', cbSubSrv.Text);
        OptionsIni.WriteString(sect, 'Acc_pu', edAcc_pu.Text);
        OptionsIni.WriteString(sect, 'FIO', edFIO.Text);
        OptionsIni.WriteString(sect, 'City', cbCity.Text);
        OptionsIni.WriteString(sect, 'Street', cbStreet.Text);
        OptionsIni.WriteString(sect, 'Building', edBuilding.Text);
        OptionsIni.WriteString(sect, 'Apartment', edApartment.Text);
end;

//------------------------------------------------------------------------------
//добавить запись
procedure TfrmAbonentEd.AddAbonent(ds: TDataSource);
var
	i
        , max_id
        , sub_srv_count
        , mr: integer;
        open_time: string;
begin
	fForm_mode := 'add';
	Caption := Caption + ' (добавление)';

	mr := ShowModal;
        if (mr = mrCancel) then
        	exit;

        sub_srv_count := 1;
        if (cbAllSubSrv.Checked) then
        	sub_srv_count := cbSubSrv.Items.Count;

        //если у услуги нет подуслуг, то цикл все равно выполнится 1 раз
        for i := 1 to sub_srv_count do
	begin
        	max_id    := 0;
                open_time := DateTimeToStr(Now);

        	//получение максимального ABONENT_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(ABONENT_ID) MAX_ID FROM ABONENTS';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);

        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при нахождении максимального ABONENT_ID.');
	                exit;
		end;

                //таблица ABONENTS непуста
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //добавляем запись в базу данных
                DataMod.IB_Cursor.SQL.Clear;
                DataMod.IB_Cursor.SQL.Add('INSERT INTO ABONENTS('
                	+ '  ABONENT_ID'
                        + ', SERVICE_ID'
                        + ', SUBSRV_ID'
                	+ ', CITY_ID'
                        + ', STREET_ID'
                        + ', FIO'
                        + ', BUILDING'
                        + ', APARTMENT'
                        + ', ACC_PU'
                        + ', OPEN_TIME)'
		+ ' VALUES('
                //TODO: можно использовать GEN_ID
                //+ '     GEN_ID(GEN_AB, 1)'
                + IntToStr(max_id + 1)

                //--------------------------------------------------------------
                //услуга
                + ', ' + cbService.KeyItems.Strings[cbService.ItemIndex]);
                //--------------------------------------------------------------
                //подуслуга
                if (cbSubSrv.Enabled) then
                	DataMod.IB_Cursor.SQL.Add(', ' + cbSubSrv.KeyItems.Strings[cbSubSrv.ItemIndex])
                //выбраны все подуслуги
                else if ((cbAllSubSrv.Visible) and (cbAllSubSrv.Checked)) then
                	DataMod.IB_Cursor.SQL.Add(', ' + cbSubSrv.KeyItems.Strings[i - 1])
                //у услуги нет подуслуг
                else
                    	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //город
                if (cbCity.Text <> '') then
                        DataMod.IB_Cursor.SQL.Add(', ' + cbCity.KeyItems.Strings[cbCity.ItemIndex])
                else
                    	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
        	//улица
                DataMod.IB_Cursor.SQL.Add(', ' + cbStreet.KeyItems.Strings[cbStreet.ItemIndex]);
                //--------------------------------------------------------------
                //ФИО абонента
                if (edFIO.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', ''' + edFIO.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //дом
                DataMod.IB_Cursor.SQL.Add(', ''' + edBuilding.Text + '''');
                //--------------------------------------------------------------
                //квартира
                if (edApartment.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', ''' + edApartment.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //лицевой счет
                DataMod.IB_Cursor.SQL.Add(', ''' + edAcc_pu.Text + '''');
                //--------------------------------------------------------------
                //дата создания абонента
                DataMod.IB_Cursor.SQL.Add(', ''' + open_time + ''')');
                //--------------------------------------------------------------
	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при добавлении записи в таблицу абонентов.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //добавляем запись в грид
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('ABONENT_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('SERVICE').AsString     := cbService.Text;

                //выбрана подуслуга
                if (cbSubSrv.Enabled) then
                	ds.DataSet.FieldByName('SUB_SRV').AsString := cbSubSrv.Text
                //выбраны все подуслуги
                else if (cbAllSubSrv.Checked) then
                        ds.DataSet.FieldByName('SUB_SRV').AsString := cbSubSrv.Items[i - 1]
                //у услуги нет подуслуг
                else
                        ds.DataSet.FieldByName('SUB_SRV').AsString := '';

                ds.DataSet.FieldByName('CITY').AsString := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := cbStreet.Text;

                if (edFIO.Text <> '') then
	                ds.DataSet.FieldByName('FIO').AsString := edFIO.Text;

                ds.DataSet.FieldByName('BUILDING').AsString := edBuilding.Text;

                if (edApartment.Text <> '') then
	                ds.DataSet.FieldByName('APARTMENT').AsString := edApartment.Text;

                ds.DataSet.FieldByName('ACC_PU').AsString        := edAcc_pu.Text;
                ds.DataSet.FieldByName('OPEN_TIME').AsString     := open_time;
                ds.DataSet.FieldByName('IS_ACC_LOCK').AsInteger  := 0;
                ds.DataSet.FieldByName('IS_ACC_CLOSE').AsInteger := 0;
                ds.DataSet.FieldByName('BALANCE').AsInteger      := 0;
                ds.DataSet.Post;
        end;
end;

//редактировать запись
function TfrmAbonentEd.EditAbonent(ds: TDataSource): word;
var
	mr: integer;
begin
	result := 1;

	fForm_mode          := 'edit';
        edAbonent_id.Text   := ds.DataSet.FieldByName('ABONENT_ID').AsString;
        cbService.Text      := ds.DataSet.FieldByName('SERVICE').AsString;
        cbSubSrv.Text       := ds.DataSet.FieldByName('SUB_SRV').AsString;
        edAcc_pu.Text       := ds.DataSet.FieldByName('ACC_PU').AsString;
        edFIO.Text          := ds.DataSet.FieldByName('FIO').AsString;
        cbCity.Text         := ds.DataSet.FieldByName('CITY').AsString;
        cbStreet.Text       := ds.DataSet.FieldByName('STREET').AsString;
        edBuilding.Text     := ds.DataSet.FieldByName('BUILDING').AsString;
        edApartment.Text    := ds.DataSet.FieldByName('APARTMENT').AsString;
        edBalance.Text      := ds.DataSet.FieldByName('BALANCE').AsString;

        cbService.Enabled   := false;
        cbSubSrv.Enabled    := false;
        edAcc_pu.Enabled    := false;

        cbAllSubSrv.Visible := false;
        cbAllSubSrv.Checked := false;

	Caption := Caption + ' (редактирование)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	DataMod.IB_Cursor.SQL.Text := 'SELECT ABONENT_ID'
        	+ ' FROM ABONENTS'
                + ' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
		+ ' AND ACC_PU       = ''' + edAcc_pu.Text + '''';
        
        	//MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('Ошибка при определении количества записей абонентов с таким же л/с по выбранной услуге.');
                	exit;
		end;

        	if ((DataMod.IB_Cursor.RecordCount > 1) and (YesNoBox(format('В таблице абонентов обнаружено %d записи(ей).%sУслуга: %s%sЛицевой счет: %s%s%sИзменения распространятся на все %d записи(ей).%sПродолжить?', [DataMod.IB_Cursor.RecordCount, #13, cbService.Text, #13, edAcc_pu.Text, #13, #13, DataMod.IB_Cursor.RecordCount, #13])) = mrNo)) then
                	exit;

                //функция возвращает количество записей из таблицы абоненентов с таким же л/с
                result := DataMod.IB_Cursor.RecordCount;

        	DataMod.IB_Cursor.SQL.Clear;
                DataMod.IB_Cursor.SQL.Add('UPDATE ABONENTS SET');
                //--------------------------------------------------------------
                //TODO: услуга, подуслуга, лицевой счет не доступны для редактирования
                //город
                DataMod.IB_Cursor.SQL.Add(' CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);
                //--------------------------------------------------------------
                //улица
                DataMod.IB_Cursor.SQL.Add(', STREET_ID = ' + cbStreet.KeyItems.Strings[cbStreet.ItemIndex]);
                //--------------------------------------------------------------
                //ФИО абонента
                if (edFIO.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', FIO = ''' + edFIO.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', FIO = NULL');
                //--------------------------------------------------------------
                //дом
                DataMod.IB_Cursor.SQL.Add(', BUILDING = ''' + edBuilding.Text + '''');
                //--------------------------------------------------------------
                //квартира
                if (edApartment.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', APARTMENT = ''' + edApartment.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', APARTMENT = NULL');
                //--------------------------------------------------------------
                DataMod.IB_Cursor.SQL.Add(' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]);
		DataMod.IB_Cursor.SQL.Add(' AND ACC_PU       = ''' + edAcc_pu.Text + '''');
                //--------------------------------------------------------------
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при редактировании записи в таблице абонентов.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //редактируем запись в грид
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('CITY').AsString   := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := cbStreet.Text;

                if (edFIO.Text <> '') then
	                ds.DataSet.FieldByName('FIO').AsString := edFIO.Text;

                ds.DataSet.FieldByName('BUILDING').AsString := edBuilding.Text;

                if (edApartment.Text <> '') then
	                ds.DataSet.FieldByName('APARTMENT').AsString := edApartment.Text;


                ds.DataSet.Post;
	end;
end;

//нажатие на кнопку OK
procedure TfrmAbonentEd.btnOKClick(Sender: TObject);
var
	ch, msg: string;
        pos: word;
begin
	//проверка на пустоту
	if (cbService.Text = '') then
        try
        	//поле "Услуга" может быть недоступно, если не выбрано ни одной услуги для отображения
		StopClose(self, 'Вы забыли указать услугу.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbService)
        except
        	edAcc_pu.SetFocus;
        end

        else if ((cbSubSrv.Enabled) and (cbSubSrv.Text = '')) then
		StopClose(self, 'Вы забыли указать подуслугу.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbSubSrv)
        else if (edAcc_pu.Text = '') then
		StopClose(self, 'Вы забыли указать лицевой счет.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edAcc_pu)
        else if (cbCity.Text = '') then
		StopClose(self, 'Вы забыли указать город.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbCity)
        else if ((cbStreet.Enabled) and (cbStreet.Text = '')) then
		StopClose(self, 'Вы забыли указать улицу.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbStreet)
        else if (edBuilding.Text = '') then
		StopClose(self, 'Вы забыли указать номер дома.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edBuilding)

        //проверка, что лицевой счет небольше 70 символов
        else if (Length(edAcc_pu.Text) > 70) then
        	StopClose(self, 'Лицевой счет должен быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edAcc_pu)

        //проверка, что номер дома небольше 10 символов
        else if (Length(edBuilding.Text) > 10) then
        	StopClose(self, 'Номер дома должен быть небольше 10 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edBuilding)

        //проверка, что номер квартиры небольше 7 символов
        else if (Length(edApartment.Text) > 7) then
        	StopClose(self, 'Номер квартиры должен быть небольше 7 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edApartment)

        //проверка, что ФИО небольше 70 символов
        else if (Length(edFIO.Text) > 70) then
        	StopClose(self, 'ФИО абонента должно быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edFIO)

        //проверка на присутствие в лицевом счете запрещенных символов
	else if (CheckCorrectString(edAcc_pu.Text, ch, pos)) then
		StopClose(self, format('В лицевом счете использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edAcc_pu)

        //проверка на присутствие в ФИО абонента запрещенных символов
	else if (CheckCorrectString(edFIO.Text, ch, pos)) then
		StopClose(self, format('В ФИО абонента использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edFIO)

        //проверка на присутствие в номере дома запрещенных символов
	else if (CheckCorrectString(edBuilding.Text, ch, pos)) then
		StopClose(self, format('В номере дома использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edBuilding)

        //проверка на присутствие в номере квартиры запрещенных символов
	else if (CheckCorrectString(edApartment.Text, ch, pos)) then
		StopClose(self, format('В номере квартиры использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edBuilding)

        else
        begin
        	//проверка, что л/с абонента в рамках услуги уникален
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT ABONENT_ID, ACC_PU'
        	+ ' FROM ABONENTS WHERE ACC_PU = ''' + edAcc_pu.Text + ''''
                + ' AND SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
                + ' AND IS_ACC_CLOSE = 0');

                //выбрана подуслуга
                if (cbSubSrv.Enabled) then
			DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID = ' + cbSubSrv.KeyItems.Strings[cbSubSrv.ItemIndex]);

                //если абонент открыт на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND ACC_PU <> ''' + edAcc_pu.Text + '''');

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности лицевого счета.' + #13 +
                        'Убедитесь, что в лицевом счете не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edAcc_pu);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                        msg := format('Абонент уже существует (ID #%d):%sУслуга: %s', [DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger, #13, cbService.Text]);

                        if (cbSubSrv.Enabled) then
                         	msg := msg + format('%sПодуслуга: %s', [#13, cbSubSrv.Text]);

                        msg := msg + format('%sЛицевой счет: %s%s%sНажмите [ОК] для перехода к полю.', [#13, edAcc_pu.Text, #13, #13]);
                 	StopClose(self, msg, edAcc_pu);

                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;

        SaveToIni;
end;

procedure TfrmAbonentEd.cbServiceChange(Sender: TObject);
begin
	if (fSetSubSrvList) then
		SetSubSrvList(cbSubSrv);
end;

procedure TfrmAbonentEd.cbCityChange(Sender: TObject);
begin
        if (fSetStreetList) then
		SetStreetList(cbStreet);
end;

procedure TfrmAbonentEd.cbAllSubSrvClick(Sender: TObject);
var
        frm: TfrmAllSubSrvWarning;
        flag: boolean;
        sect: string;
begin
	if (not (cbAllSubSrv.Visible) or (fForm_mode = 'edit')) then
        	exit;

	if (not (cbAllSubSrv.Checked)) then
        begin
        	sect := 'AllSubSrvWarning';
        	flag := OptionsIni.ReadBool(sect, 'AllVisibleSubSrvWarning', false);

                //выводим окно с предупреждением
                if (not (flag)) then
                begin
		  	frm := TfrmAllSubSrvWarning.Create(self);
        		frm.ShowModal;
                end;
        end;

	cbSubSrv.Enabled := not cbAllSubSrv.Checked;
end;

end.
