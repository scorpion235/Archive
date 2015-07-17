//Загрузка реестра
unit fImportReestr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RtColorPicker, ComCtrls, ExtCtrls, RXSpin,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDBrowseEdit, Mask, DBCtrlsEh, DB,
  RxMemDS, LMDCustomMemo, LMDMemo, LMDCustomListBox, LMDExtListBox, RXCtrls,
  Grids, DBGridEh;

type
  TfrmImportReestr = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnImport: TButton;
    btnClose: TButton;
    lblImportPath: TLabel;
    edImportPath: TDBEditEh;
    lblReestr: TLabel;
    edReestr: TDBEditEh;
    OpenDialog: TOpenDialog;
    btnReestr: TButton;
    PageControl: TPageControl;
    tsHeader: TTabSheet;
    tsPay: TTabSheet;
    GridPay: TDBGridEh;
    lbHistory: TTextListBox;
    dsPay: TDataSource;
    mdPay: TRxMemoryData;
    mdPayFIO: TStringField;
    mdPayCITY: TStringField;
    mdPaySTREET: TStringField;
    mdPayBUILDING: TStringField;
    mdPayAPARTMENT: TStringField;
    mdPayACC_PU: TStringField;
    mdPaySUB_SRV_PU: TStringField;
    mdPayDATE_PAY: TDateField;
    mdPayMSG: TStringField;
    mdPayBALANCE: TStringField;
    mdPaySUMM: TStringField;
    mdPayUNO: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnImportClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnReestrClick(Sender: TObject);
    procedure GridPayGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure GridPaySortMarkingChanged(Sender: TObject);
private
    fModalResult: TModalResult;
    fRee_id,
    fAgent_id,
    fService_num,
    fService_id: integer;
    procedure LoadFromIni;
    procedure SaveToIni;
    //получение информации из заголовка реестра платежей
    function GetReestrHeadInfo: boolean;
    //проверка на существование, пометку на закрытие, закрытие абонента (основная услуга)
    function CheckAbonent(acc_pu, sub_srv_pu: string): boolean;
    //проверка уникальности оплаты
    function UniquePay(acc_pu, sub_srv_pu, uno: string): boolean;
    //получение информации об оплате
    procedure GetPayInfo(
    	str: string;
    var
	fio,
    	city,
    	street,
    	building,
    	apartment,
    	acc_pu,
    	summ,
    	sub_srv_pu,
    	date_pay,
    	balance,
    	uno: string
    );

    //загрузка оплаты в базу данных
    procedure ImportPay(
	fio,
    	city,
    	street,
    	building,
    	apartment,
    	acc_pu,
    	summ,
    	sub_srv_pu,
    	date_pay,
    	balance,
    	uno: string
    );

public
    { Public declarations }
end;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmImportReestr.FormCreate(Sender: TObject);
begin
	fRee_id       := 0;
    	fAgent_id     := 0;
    	fService_num  := 0;
        fService_id   := 0;
	fModalResult  := mrCancel;

        GridPay.Columns[0].Footer.Value := '0';
        mdPay.Active           := true;
        PageControl.ActivePage := tsHeader;
        btnImport.Enabled      := false;
   	LoadFromIni;
end;

procedure TfrmImportReestr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	mdPay.Active := false;
        //если была произведена загрузка реестров, то возвращаем ModalResult = mrOk
        ModalResult  := fModalResult;
	Action       := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmImportReestr.LoadFromIni;
var
	sect: String;
begin
	sect := 'Options';
        edImportPath.Text := OptionsIni.ReadString(sect, 'ImportPath', 'C:\Invest\Pays');
end;

//сохранение параметров в ini-файл
procedure TfrmImportReestr.SaveToIni;
var
	sect: String;
begin
	sect := 'ExportReestr';
end;

//закрыть
procedure TfrmImportReestr.btnCloseClick(Sender: TObject);
begin
	SaveToIni;
	Close;
end;

//получение информации из заголовка реестра платежей
function TfrmImportReestr.GetReestrHeadInfo: boolean;
var
        f: TextFile;
        str,
        file_name,
        agent_name,
        service_name: string;
        record_count: integer;
        ree_summ: double;
begin
	result := false;

	file_name := edReestr.Text;
        AssignFile(f, file_name);

        {$I-}
	Reset(f);
        {$I-}

        if IOResult <> 0 then
    	begin
            	WarningBox('Ошибка открытия реестра платежей:' + #13 + file_name);
                exit;
        end;

        try
	        //номер реестра
        	ReadLn(f, str);
	        fRee_id := FileStrToInt(str);

        	//сумма реестра
	        ReadLn(f, str);
        	ree_summ := FileStrToDouble(str);

	        ReadLn(f, str); //в том числе пеня
        	ReadLn(f, str); //удержанная сумма
	        ReadLn(f, str); //сумма к перечислению

        	//число записей
	        ReadLn(f, str);
        	record_count := FileStrToInt(str);

	        //код агента
        	ReadLn(f, str);
	        fAgent_id := FileStrToInt(str);

        	//номер услуги
	        ReadLn(f, str);
        	fService_num := FileStrToInt(str);

                //id услуги
                DataMod.IB_Cursor.SQL.Text := 'SELECT SERVICE_ID FROM SERVICES'
                + ' WHERE NUM = ' + IntToStr(fService_num);

                //запуск запроса
        	try
                	DataMod.IB_Cursor.Open;
        	except
                	WarningBox('Ошибка при нахождении SERVICE_ID.');
                	exit;
        	end;

                fService_id := DataMod.IB_Cursor.fieldByName('SERVICE_ID').AsInteger;
                DataMod.IB_Cursor.Close;

	        //ReadLn(f, str); //дата формирования реестра
        	//ReadLn(f, str); //начало диапазона дат документов, входящих в реестр
	        //ReadLn(f, str); //конец диапазона дат документов, входящих в реестр
        	//ReadLn(f, str); //примечание

                CloseFile(f);

        except
        	WarningBox('Ошибка при чтении заголовка реестра платежей.');
                CloseFile(f);
                exit;
        end;

        //----------------------------------------------------------------------
        //наименование агента
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM AGENT_LIST'
        + ' WHERE AGENT_ID = ' + IntToStr(fAgent_id);

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении наименования агента.');
                exit;
        end;

        if (DataMod.IB_Cursor.FieldByName('NAME').IsNotNull) then
                agent_name := DataMod.IB_Cursor.FieldByName('NAME').AsString
        else
                agent_name := 'Неизвестный агент';
        
        DataMod.IB_Cursor.Close;

        //----------------------------------------------------------------------
        //наименование услуги
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME, VISIBLE FROM SERVICES'
        + ' WHERE SERVICE_ID = ' + IntToStr(fService_id);

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении наименования услуги.');
                exit;
        end;

        if (DataMod.IB_Cursor.FieldByName('NAME').IsNotNull) then
                service_name := DataMod.IB_Cursor.FieldByName('NAME').AsString
        else
                service_name := 'Неизвестная услуга';

        //----------------------------------------------------------------------
        //выводим информацию о заголовке реестра на экран
        lbHistory.Clear;
        lbHistory.Items.Add(format('Номер реестра: %d', [fRee_id]));
        lbHistory.Items.Add(format('Сумма реестра: %f', [ree_summ]));
        lbHistory.Items.Add(format('Число записей: %d', [record_count]));
        lbHistory.Items.Add(format('Агент: %d - %s',    [fAgent_id, agent_name]));
        lbHistory.Items.Add(format('Услуга: %d - %s',   [fService_num, service_name]));

        //услуга не найдена в справочнике услуг
        if (service_name = 'Неизвестная услуга') then
        begin
                WarningBox('Неизвестная услуга номер ' + IntToStr(fService_num) + '.' + #13 +
                'Загрузка реестра невозможна.' + #13 + #13 +
                'Добавьте услигу в справочник услуг.');
                btnImport.Enabled := false;
                DataMod.IB_Cursor.Close;
                exit;
        end;

        //услуга не помечена для отображения
        if (DataMod.IB_Cursor.FieldByName('VISIBLE').AsInteger = 0) then
        begin
                WarningBox('Услуга "' + service_name + '"' + #13 +
                'не выбрана  для отображения.' + #13 +
                'Загрузка реестра невозможна.' + #13 + #13 +
                'Выберите услигу в справочнике услуг.');
                btnImport.Enabled := false;
                DataMod.IB_Cursor.Close;
                exit;
        end;

        DataMod.IB_Cursor.Close;

        result := true;
end;

//нажатие на кнопку Загрузить
procedure TfrmImportReestr.btnReestrClick(Sender: TObject);
var
	i: word;
begin
        OpenDialog.InitialDir := edImportPath.Text;
	OpenDialog.Execute;

        if (OpenDialog.FileName = '') then
        	exit;

        edReestr.Text := OpenDialog.FileName;
        PageControl.ActivePage := tsHeader;

        mdPay.EmptyTable;
        for i := 0 to GridPay.Columns.Count - 1 do
        	if (GridPay.Columns.Items[i].FieldName = 'MSG') then
                        GridPay.Columns[i].Footer.Value := '0';

	if (GetReestrHeadInfo) then
        	btnImport.Enabled := true;
end;

//проверка на существование, пометку на закрытие, закрытие абонента (основная услуга)
function TfrmImportReestr.CheckAbonent(acc_pu, sub_srv_pu: string): boolean;
begin
	if (acc_pu = '') then
        begin
        	result := true;
                exit;
        end;

        result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT IS_ACC_LOCK, IS_ACC_CLOSE FROM ABONENTS'
        + ' WHERE ACC_PU   = ''' + acc_pu + ''''
        + ' AND SERVICE_ID = ' + IntToStr(fService_id));

        //указана подуслуга
        if (sub_srv_pu <> '') then
                DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID = (SELECT SUBSRV_ID FROM SUBSRV WHERE SERVICE_ID = ' + IntToStr(fService_id) + ' AND SUB_SRV_PU = ''' + sub_srv_pu + ''')');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при проверке существования абонента.');
                exit;
        end;

        //абонент не найден
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                mdPay.Edit;
                mdPay.FieldByName('MSG').AsString := 'Абонент не найден';
                mdPay.Post;

                DataMod.IB_Cursor.Close;
                exit;
        end

        //л/с абонента помечен на закрытие
        else if ((DataMod.IB_Cursor.FieldByName('IS_ACC_LOCK').AsInteger = 1) and (DataMod.IB_Cursor.FieldByName('IS_ACC_CLOSE').AsInteger = 0)) then
        begin
        	mdPay.Edit;
                mdPay.FieldByName('MSG').AsString := 'Л/с абонента помечен на закрытие';
                mdPay.Post;

                DataMod.IB_Cursor.Close;
                exit;
        end

        //л/с абонента закрыт
        else if ((DataMod.IB_Cursor.FieldByName('IS_ACC_LOCK').AsInteger = 1) and (DataMod.IB_Cursor.FieldByName('IS_ACC_CLOSE').AsInteger = 1)) then
        begin
                mdPay.Edit;
                mdPay.FieldByName('MSG').AsString := 'Л/с абонента закрыт';
                mdPay.Post;

                DataMod.IB_Cursor.Close;
                exit;
        end;

        DataMod.IB_Cursor.Close;

        result := true;
end;

//проверка уникальности оплаты
function TfrmImportReestr.UniquePay(acc_pu, sub_srv_pu, uno: string): boolean;
begin
        result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT REE_ID FROM PAYS'
        + ' WHERE REE_ID    = '   + IntToStr(fRee_id)
        + ' AND AGENT_ID    = '   + IntToStr(fAgent_id)
        + ' AND SERVICE_ID  = '   + IntToStr(fService_id)
        + ' AND UNO         = '   + uno);

        //основная услуга
        if (acc_pu <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND ACC_PU = ''' + acc_pu + ''''
        	+ ' AND COALESCE(SUB_SRV_PU, '''')  = ''' + sub_srv_pu + '''');

        //запуск запроса
        try
        	DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при проверке уникальности оплаты абонента.');
                exit;
        end;

        if (DataMod.IB_Cursor.RecordCount > 0) then
        begin
        	mdPay.Edit;
                mdPay.FieldByName('MSG').AsString := 'Оплата уже разнесена';
                mdPay.Post;

           	DataMod.IB_Cursor.Close;
                exit;
        end;

        DataMod.IB_Cursor.Close;

        result := true;
end;

//получение информации об оплате
procedure TfrmImportReestr.GetPayInfo(
	str: string;
var
	fio,
    	city,
    	street,
    	building,
    	apartment,
    	acc_pu,
    	summ,
    	sub_srv_pu,
    	date_pay,
    	balance,
    	uno: string
);

var
	i, field: word;
    	s: string;

begin
	date_pay   := '';
        sub_srv_pu := '';
	fio        := '';
        city       := '';
  	street     := '';
        building   := '';
  	apartment  := '';
  	acc_pu     := '';
  	uno        := '';
  	summ       := '';
        balance    := '';

        s     := '';
        field := 1;

        for i := 1 to length(str) + 1 do
        begin
            	if ((str[i] = ',') or (str[i] = ';') or (i = length(str) + 1)) then
                begin
                	//TODO: пока не обрабатываются поля дополнений
                	case (field) of
                		1:  fio        := s;
                                2:  city       := s;
                                3:  street     := s;
                                4:  building   := s;
                                5:  apartment  := s;
                                6:  acc_pu     := s;
                                7:  summ       := s;
                                8:  sub_srv_pu := s;
                                12: date_pay   := CorrectDate(s);
                                13: balance    := s;
                                14: uno        := s;
                	end;

                        s := '';
                        inc(field);
                end

                else
                	s := s + str[i];
        end;

        //доп. услуга
        if (acc_pu = '') then
        begin
        	fio       := DelLeftSpace(fio);
                building  := DelLeftSpace(building);
                apartment := DelLeftSpace(apartment);
        end;
end;

//загрузка оплаты в базу данных
procedure TfrmImportReestr.ImportPay(
	fio,
    	city,
    	street,
    	building,
    	apartment,
    	acc_pu,
    	summ,
    	sub_srv_pu,
    	date_pay,
    	balance,
    	uno: string
);

var
	max_id: integer;
        sub_srv_name: string;
        summ_before: double;
begin
        sub_srv_name := '';

        //у услуги есть подуслуга
        if (sub_srv_pu <> '') then
        begin
		//название подуслуги
		DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM SUBSRV'
        	+ ' WHERE SERVICE_ID = ' + IntToStr(fService_id)
        	+ ' AND SUB_SRV_PU  = ''' + sub_srv_pu + '''';

        	//запуск запроса
        	try
        		DataMod.IB_Cursor.Open;
        	except
                	WarningBox('Ошибка при определении названия подуслуги.');
                	exit;
       	 	end;

                if (DataMod.IB_Cursor.FieldByName('NAME').IsNotNull) then
                	sub_srv_name := DataMod.IB_Cursor.FieldByName('NAME').AsString;

                DataMod.IB_Cursor.Close;
        end;

        //----------------------------------------------------------------------
	//добавляем запись в Grid
        mdPay.Append;

        if (sub_srv_name <> '') then
	        mdPay.FieldByName('SUB_SRV_PU').AsString := sub_srv_name;

        if (fio <> '') then
        	mdPay.FieldByName('FIO').AsString := fio;

        if (city <> '') then
        	mdPay.FieldByName('CITY').AsString := city;

        if (street <> '') then
        	mdPay.FieldByName('STREET').AsString := street;

        if (building <> '') then
        	mdPay.FieldByName('BUILDING').AsString := building;

        if (apartment <> '') then
        	mdPay.FieldByName('APARTMENT').AsString := apartment;

        mdPay.FieldByName('ACC_PU').AsString   := acc_pu;
        mdPay.FieldByName('DATE_PAY').AsString := date_pay;
        mdPay.FieldByName('UNO').AsString      := uno;

        mdPay.FieldByName('SUMM').AsString     := Dot2Sep(summ);
        mdPay.FieldByName('BALANCE').AsString  := Dot2Sep(balance);
        mdPay.Post;
        //----------------------------------------------------------------------
        //подуслуга не найдена
        if ((sub_srv_pu <> '') and (sub_srv_name = '')) then
        begin
        	mdPay.Edit;
                mdPay.FieldByName('MSG').AsString := format('Подуслуга "%s" не найдена', [sub_srv_pu]);
                mdPay.Post;

                exit;
        end;

        //проверка на существование, пометку на закрытие, закрытие абонента (основная услуга)
        if (not (CheckAbonent(acc_pu, sub_srv_pu))) then
        	exit;

        //проверка уникальности оплаты абонента
        if (not (UniquePay(acc_pu, sub_srv_pu, uno))) then
        	exit;

        //----------------------------------------------------------------------
        //поуслуга
        if (sub_srv_pu = '') then
        	sub_srv_pu := 'NULL'
        else
        	sub_srv_pu := '''' + sub_srv_pu + '''';

        //фио
        if (fio = '') then
        	fio := 'NULL'
        else
        	fio := '''' + fio + '''';

        //город
        if (city = '') then
        	city := 'NULL'
        else
        	city := '''' + city + '''';

        //улица
        if (street = '') then
        	street := 'NULL'
        else
        	street := '''' + street + '''';

        //дом
        if (building = '') then
        	building := 'NULL'
        else
        	building := '''' + building + '''';

        //квартира
        if (apartment = '') then
        	apartment := 'NULL'
        else
        	apartment := '''' + apartment + '''';

        //----------------------------------------------------------------------
        max_id := 0;

        //получение максимального PAY_ID
        DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(PAY_ID) MAX_ID FROM PAYS';
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при нахождении максимального PAY_ID.');
                exit;
        end;

        //таблица PAYS непуста
        if (DataMod.IB_Cursor.RecordCount > 0) then
                max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

        DataMod.IB_Cursor.Close;

        //----------------------------------------------------------------------
        //добавляем запись об оплате в таблицу PAYS

        //оплата по доп. услуге
        if ((sub_srv_pu = 'NULL') and (acc_pu = '')) then
        begin
        	DataMod.IB_Cursor.SQL.Text := 'INSERT INTO PAYS('
        		+ '  PAY_ID'
        		+ ', REE_ID'
                	+ ', AGENT_ID'
                	+ ', SERVICE_ID'
                	+ ', FIO'
                	+ ', CITY'
                	+ ', STREET'
                	+ ', BUILDING'
                	+ ', APARTMENT'
                	+ ', DATE_PAY'
                	+ ', UNO'
                	+ ', SUMM'
                	+ ', BALANCE)'
        	+ ' VALUES('
        		//TODO: можно использовать GEN_ID
        		//+ 'GEN_ID(GEN_AB, 1)'
        		+ IntToStr(max_id + 1)
        		+ ', ' + IntToStr(fRee_id)
        		+ ', ' + IntToStr(fAgent_id)
        		+ ', ' + IntToStr(fService_id)
        		+ ', ' + fio
        		+ ', ' + city
        		+ ', ' + street
        		+ ', ' + building
        		+ ', ' + apartment
        		+ ', ''' + date_pay + ''''
                	+ ', ' + uno
                	+ ', ' + summ
                	+ ', ' + balance + ')';
        end

        //оплата по основной услуге
        else
        begin
          	DataMod.IB_Cursor.SQL.Text := 'INSERT INTO PAYS('
        		+ '  PAY_ID'
        		+ ', REE_ID'
                	+ ', AGENT_ID'
                	+ ', SERVICE_ID'
                	+ ', SUB_SRV_PU'
                	+ ', FIO'
                	+ ', CITY'
                	+ ', STREET'
                	+ ', BUILDING'
                	+ ', APARTMENT'
                	+ ', ACC_PU'
                	+ ', DATE_PAY'
                	+ ', UNO'
                	+ ', SUMM'
                	+ ', BALANCE)'
        	+ ' VALUES('
        		//TODO: можно использовать GEN_ID
        		//+ 'GEN_ID(GEN_AB, 1)'
        		+ IntToStr(max_id + 1)
        		+ ', ' + IntToStr(fRee_id)
        		+ ', ' + IntToStr(fAgent_id)
        		+ ', ' + IntToStr(fService_id)
                	+ ', ' + sub_srv_pu
        		+ ', ' + fio
        		+ ', ' + city
        		+ ', ' + street
        		+ ', ' + building
        		+ ', ' + apartment
        		+ ', ''' + acc_pu + ''''
        		+ ', ''' + date_pay + ''''
                	+ ', ' + uno
                	+ ', ' + summ
                	+ ', ' + balance + ')';
        end;

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
        	DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при добавлении записи в таблицу платежей.');
                exit;
        end;

        DataMod.IB_Cursor.Close;

        //----------------------------------------------------------------------
        //в таблице ABONENTS обновляем поле BALANCE текущей задолженностью (основная услуга)
        if (acc_pu <> '') then
        begin
        	//получаем текущее значение поля BALANCE
        	DataMod.IB_Cursor.SQL.Clear;

        	DataMod.IB_Cursor.SQL.Add('SELECT BALANCE'
		+ ' FROM ABONENTS'
                + ' WHERE ACC_PU   = ''' + acc_pu + ''''
		+ ' AND SERVICE_ID = ' + IntToStr(fService_id));

                //указана подуслуга
                if (sub_srv_pu <> 'NULL') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID = (SELECT SUBSRV_ID FROM SUBSRV WHERE SERVICE_ID = ' + IntToStr(fService_id) + ' AND SUB_SRV_PU = ' + sub_srv_pu + ')');
                //MsgBox(DataMod.IB_Cursor.SQL.Text);

        	//запуск запроса
        	try
        		DataMod.IB_Cursor.Open;
        	except
                	WarningBox('Ошибка получения текущей задолженности абонента.');
                	exit;
        	end;

                summ_before := DataMod.IB_Cursor.FieldByName('BALANCE').AsFloat;
        	DataMod.IB_Cursor.Close;

                //--------------------------------------------------------------
                //текущая задолженность РАВНА выставленная задолженность МИНУС сумма оплаты
        	DataMod.IB_Cursor.SQL.Clear;

        	DataMod.IB_Cursor.SQL.Add('UPDATE ABONENTS'
                //TODO: очень сложные преобразования
		+ ' SET BALANCE    = ' + Sep2Dot(FloatToStr(summ_before - StrToFloat(Dot2Sep(summ))))
                + ' WHERE ACC_PU   = ''' + acc_pu + ''''
		+ ' AND SERVICE_ID = ' + IntToStr(fService_id));

                //указана подуслуга
                if (sub_srv_pu <> 'NULL') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID = (SELECT SUBSRV_ID FROM SUBSRV WHERE SERVICE_ID = ' + IntToStr(fService_id) + ' AND SUB_SRV_PU = ' + sub_srv_pu + ')');

        	//запуск запроса
        	try
        		DataMod.IB_Cursor.Open;
        	except
                	WarningBox('Ошибка обновления текущей задолженности абонента.');
                	exit;
        	end;

        	DataMod.IB_Cursor.Close;
        end;

        //если все операции успешно завершены, то завершаем транзакцию
        DataMod.IB_Transaction.Commit;

        mdPay.Edit;
        mdPay.FieldByName('MSG').AsString := 'Оплата учтена';
	mdPay.Post;

        fModalResult := mrOk;
end;

//------------------------------------------------------------------------------
//загрузить
procedure TfrmImportReestr.btnImportClick(Sender: TObject);
var
        f: TextFile;
        i: word;
        record_count,
        sub_srv_count: integer;

        str,
        file_name,
        fio,
    	city,
    	street,
    	building,
    	apartment,
    	acc_pu,
    	summ,
    	sub_srv_pu,
    	date_pay,
    	balance,
    	uno: string;
begin
	//MsgBox('Загрузка');
        file_name := edReestr.Text;

        //проверка на существование файла
        if (not (FileExists(file_name))) then
        begin
        	WarningBox('Реестр платежей не найден:' + #13 + file_name);
                exit;
        end;

        for i := 0 to GridPay.Columns.Count - 1 do
        	GridPay.Columns[i].Title.SortMarker := smNoneEh;

        AssignFile(f, file_name);

        {$I-}
	Reset(f);
        {$I-}

        if IOResult <> 0 then
    	begin
            	WarningBox('Ошибка открытия реестра платежей:' + #13 + file_name);
                exit;
        end;

        //"перескакиваем" заголовок реестра
        for i := 0 to 11 do
                ReadLn(f, str);

        mdPay.EmptyTable;
        record_count  := 0;
        sub_srv_count := 0;
        while(not eof(f)) do
        begin
        	//считываем очередную строку из файла
                ReadLn(f, str);

                //получение информации об оплате
                try
                	GetPayInfo(str, fio, city, street, building, apartment, acc_pu, summ, sub_srv_pu, date_pay, balance, uno);
                except
        		WarningBox('Ошибка при получении информации об оплате абонента.'
                        + #13'Неверный формат файла.'
                        + #13 + #13 + str + #13
                        + #13 + 'ФИО: '                   + fio
                        + #13 + 'Город: '                 + city
                        + #13 + 'Улица: '                 + street
                        + #13 + 'Дом: '                   + building
                        + #13 + 'Квартира: '              + apartment
                        + #13 + 'Лицевой счет: '          + acc_pu
                        + #13 + 'Сумма: '                 + summ
                        + #13 + 'Подуслуга: '             + sub_srv_pu
                        + #13 + 'Дата оплаты: '           + date_pay
                        + #13 + 'Текущая задолженность: ' + balance
                        + #13 + 'Квитанция: '             + uno);

                	CloseFile(f);
                	exit;
                end;

                //загрузка оплаты в базу данных
                try
                	ImportPay(fio, city, street, building, apartment, acc_pu, summ, sub_srv_pu, date_pay, balance, uno);
                except
        		WarningBox('Ошибка при загрузке оплаты абонента в базу данных.'
                        + #13 + 'Неверный формат файла.'
                        + #13 + #13 + str + #13
                        + #13 + 'ФИО: '                    + fio
                        + #13 + 'Город: '                  + city
                        + #13 + 'Улица: '                  + street
                        + #13 + 'Дом: '                    + building
                        + #13 + 'Квартира: '               + apartment
                        + #13 + 'Лицевой счет: '           + acc_pu
                        + #13 + 'Сумма: '                  + summ
                        + #13 + 'Подуслуга: '              + sub_srv_pu
                        + #13 + 'Дата оплаты: '            + date_pay
                        + #13 + 'Сальдо (Систама Город): ' + balance
                        + #13 + 'Квитанция: '              + uno);

                	exit;
                end;

                inc(record_count);

                if (mdPay.FieldByName('SUB_SRV_PU').AsString <> '') then
                	inc(sub_srv_count);
        end;
        CloseFile(f);
        mdPay.First;

        //----------------------------------------------------------------------
        for i := 0 to GridPay.Columns.Count - 1 do
        begin
        	if (GridPay.Columns.Items[i].FieldName = 'MSG') then
                        GridPay.Columns[i].Footer.Value := IntToStr(record_count);
                if (GridPay.Columns.Items[i].FieldName = 'SUB_SRV_PU') then
                        GridPay.Columns[i].Visible := sub_srv_count > 0;
                if (GridPay.Columns.Items[i].FieldName = 'FIO') then
                begin
                	if (sub_srv_count = 0) then
                		GridPay.Columns[i].Footer.Value := 'записей'
			else
        			GridPay.Columns[i].Footer.Value := '';
                end;
        end;

        //удаляем файл
        if (FileExists(file_name)) then
		DeleteFile(file_name)
        else
            	WarningBox('Ошибка удаления реестра платежей:' + #13 + file_name);

        PageControl.ActivePage := tsPay;
        MsgBox('Загрузка реестров завершена.');
end;

procedure TfrmImportReestr.GridPayGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (mdPay.FieldByName('MSG').AsString = 'Оплата учтена.') then
		Background := $00FFDDDD
        else 
		Background := $00FFC4C4;
end;

procedure TfrmImportReestr.GridPaySortMarkingChanged(Sender: TObject);
	var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridPay = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridPay.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridPay.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridPay.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdPay.SortOnFields(fields, false, desc);
end;

end.
