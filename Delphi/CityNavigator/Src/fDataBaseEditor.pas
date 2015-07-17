//Abonents - редактирование базы данных
unit fDataBaseEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RtColorPicker, ComCtrls, ExtCtrls, RXSpin, Buttons,
  RXSplit, DB, RxMemDS, Grids, DBGridEh, Mask, ToolEdit, CurrEdit, DBGrids,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDCustomFileEdit, LMDFileOpenEdit,
  LMDControl, LMDBaseControl, LMDBaseGraphicControl, LMDGraphicControl,
  LMDBaseMeter, LMDCustomProgress, LMDProgress, LMDDBProgress, Gauges;

type
  TfrmDataBaseEditor = class(TForm)
    pnlDataBase: TPanel;
    edDataBasePath: TLMDFileOpenEdit;
    lblDataBasePath: TLabel;
    RxSplitter: TRxSplitter;
    btnConnect: TButton;
    btnDisconnect: TButton;
    btnClearManualTable: TButton;
    btnFillManualTable: TButton;
    mdHistory: TRxMemoryData;
    dsHistory: TDataSource;
    mdHistoryDATETIME: TDateTimeField;
    mdHistoryMSG_TYPE: TStringField;
    mdHistoryMSG: TStringField;
    GridHistory: TDBGridEh;
    btnClearBuhTable: TButton;
    btnFillAbonentTable: TButton;
    lblMainServiceNum: TLabel;
    edMainServiceNum: TRxSpinEdit;
    btnFillMainPayTable: TButton;
    btnFillSaldoTable: TButton;
    mdAbonent: TRxMemoryData;
    dsAbonent: TDataSource;
    mdAbonentABONENT_ID: TIntegerField;
    mdAbonentACC_PU: TStringField;
    mdAbonentSUB_SRV_PU: TStringField;
    lblAddServiceNum: TLabel;
    edAddServiceNum: TRxSpinEdit;
    btnFillAddPayTable: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edDataBasePathChange(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure pnlDataBaseResize(Sender: TObject);
    procedure btnClearManualTableClick(Sender: TObject);
    procedure GridHistoryGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure btnFillManualTableClick(Sender: TObject);
    procedure btnClearBuhTableClick(Sender: TObject);
    procedure btnFillAbonentTableClick(Sender: TObject);
    procedure btnFillMainPayTableClick(Sender: TObject);
    procedure btnFillSaldoTableClick(Sender: TObject);
    procedure btnFillAddPayTableClick(Sender: TObject);
private
    ProgressBar: TProgressBar;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure HistoryVoid;
    function ClearTable(table_name: string): word;
    procedure HistoryMsg(msg: string);
    procedure HistoryErr(err: string);
public
    fColorMode : boolean;
    
end;

implementation

uses
	dmCityNavigator,
        uCommon,
        fMain;

{$R *.dfm}


procedure TfrmDataBaseEditor.FormCreate(Sender: TObject);
begin
	btnConnect.Enabled          := Length(edDataBasePath.FileName) > 0;
        btnDisconnect.Enabled       := false;
        btnClearBuhTable.Enabled    := false;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := false;
        btnFillAbonentTable.Enabled := false;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;
        edAddServiceNum.Enabled     := false;
        btnFillAddPayTable.Enabled  := false;

        mdHistory.Active := true;

	LoadFromIni;
end;

procedure TfrmDataBaseEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	SaveToIni;
        mdHistory.Active := false;
        DataMod.IB_Connection.Disconnect;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmDataBaseEditor.LoadFromIni;
var
	sect: String;
begin
	sect := 'DataBaseEditor';
        pnlDataBase.Width          := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 220);
        edDataBasePath.Filename    := OptionsIni.ReadString(sect, 'DataBasePath', 'C:\Invest\DataBase\Abonents.fdb');
        edMainServiceNum.AsInteger := OptionsIni.ReadInteger(sect, 'MainServiceNum', 0);
        edAddServiceNum.AsInteger  := OptionsIni.ReadInteger(sect, 'AddServiceNum', 0);

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmDataBaseEditor.SaveToIni;
var
	sect: String;
begin
	sect := 'DataBaseEditor';
        OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlDataBase.Width);
	OptionsIni.WriteString(sect, 'DataBasePath', edDataBasePath.Filename);
        OptionsIni.WriteInteger(sect, 'MainServiceNum', edMainServiceNum.AsInteger);
        OptionsIni.WriteInteger(sect, 'AddServiceNum', edAddServiceNum.AsInteger);
end;

//измениние пути к базе данных FireBird
procedure TfrmDataBaseEditor.edDataBasePathChange(Sender: TObject);
begin
	btnConnect.Enabled := Length(edDataBasePath.Filename) > 0;
end;

//подключение к базе данных
procedure TfrmDataBaseEditor.btnConnectClick(Sender: TObject);
begin
	with (DataMod.IB_Connection) do
	begin
        	Path     := edDataBasePath.Filename;
        	Username := 'SYSDBA';
        	Password := 'masterkey'
     	end;

     	//подключение к базе данных
     	try
     	   	DataMod.IB_Connection.Connect;

     	//обработчик исключений
     	except
                HistoryErr('Не удалось подключиться к базе данных');

           	ErrorBox('Не удалось подключиться к базе данных.' + #13 + #13 +
                         'Причины:' + #13 +
                         '1. Не установлен или не запущен Firebird Server.' + #13 +
                         '2. Файл "' + DataMod.IB_Connection.Path + '" не был найден.');
           	exit;
     	end;

        HistoryMsg('Подключение к базе данных "' + DataMod.IB_Connection.Path + '"');

        btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := true;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := false;
        btnFillAbonentTable.Enabled := false;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;
        edAddServiceNum.Enabled     := false;
        btnFillAddPayTable.Enabled  := false;
end;

//отсоединение от базы данных
procedure TfrmDataBaseEditor.btnDisconnectClick(Sender: TObject);
begin
	HistoryMsg('Отсоединение от базы данных "' + DataMod.IB_Connection.Path + '"');

	DataMod.IB_Connection.Disconnect;
	btnConnect.Enabled          := true;
        btnDisconnect.Enabled       := false;
        btnClearBuhTable.Enabled    := false;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := false;
        btnFillAbonentTable.Enabled := false;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;
        edAddServiceNum.Enabled     := false;
        btnFillAddPayTable.Enabled  := false;
end;

procedure TfrmDataBaseEditor.pnlDataBaseResize(Sender: TObject);
begin
	edDataBasePath.Width := pnlDataBase.Width - 20;
end;

//очистить бухгалтерские таблицы
procedure TfrmDataBaseEditor.btnClearBuhTableClick(Sender: TObject);
var
	flag: word;
begin
	if (YesNoBox('Будут удалены все записи таблиц:' + #13 +
                'SALDO, '  +
                'PAYS, '   +
                'ABONENTS' + #13 +
                'Продолжить?'
        	, MB_ICONWARNING) = mrNo)
        then
        	exit;

        HistoryVoid;

        //TODO: с логическим умножением (AND) не получилось
        flag := ClearTable('SALDO') *
        	ClearTable('PAYS')  *
                ClearTable('ABONENTS');

        if (flag = 1) then
        begin
                btnConnect.Enabled          := false;
        	btnDisconnect.Enabled       := true;
        	btnClearBuhTable.Enabled    := false;
        	btnClearManualTable.Enabled := true;
        	btnFillManualTable.Enabled  := false;
        	edMainServiceNum.Enabled    := false;
        	btnFillAbonentTable.Enabled := false;
        	btnFillSaldoTable.Enabled   := false;
        	btnFillMainPayTable.Enabled := false;
                edAddServiceNum.Enabled     := false;
        	btnFillAddPayTable.Enabled  := false;
        end;
end;

//очистить таблицы справочников
procedure TfrmDataBaseEditor.btnClearManualTableClick(Sender: TObject);
var
	flag: word;
begin
	if (YesNoBox('Будут удалены все записи таблиц:' + #13 +
        	'STREET_LIST, ' +
                'CITY_LIST, '   +
                'AGENT_LIST, '  +
                'SUBSRV, '      +
                'SERVICES, '    +
                'SERV_TYPES, '  +
                'INFO'          + #13 +
                'Продолжить?'
        	, MB_ICONWARNING) = mrNo)
        then
        	exit;

        HistoryVoid;

        //TODO: с логическим умножением (AND) не получилось
        flag := ClearTable('STREET_LIST') *
		ClearTable('CITY_LIST')   *
        	ClearTable('AGENT_LIST')  *
        	ClearTable('SUBSRV')      *
        	ClearTable('SERVICES')    *
        	ClearTable('SERV_TYPES')  *
                ClearTable('INFO');

        if (flag = 1) then
        begin
                btnConnect.Enabled          := false;
        	btnDisconnect.Enabled       := true;
        	btnClearBuhTable.Enabled    := false;
        	btnClearManualTable.Enabled := false;
        	btnFillManualTable.Enabled  := true;
        	edMainServiceNum.Enabled    := false;
        	btnFillAbonentTable.Enabled := false;
        	btnFillSaldoTable.Enabled   := false;
        	btnFillMainPayTable.Enabled := false;
                edAddServiceNum.Enabled     := false;
        	btnFillAddPayTable.Enabled  := false;
        end;
end;

//напечатать информационное сообщение
procedure TfrmDataBaseEditor.HistoryMsg(msg: string);
begin
	mdHistory.Append;
	mdHistory.FieldByName('DATETIME').AsDateTime := Now;
	mdHistory.FieldByName('MSG').AsString        := msg;
	mdHistory.FieldByName('MSG_TYPE').AsString   := 'msg';
	mdHistory.Post;

        GridHistory.Refresh;
end;

//напечатать сообщение об ошибке
procedure TfrmDataBaseEditor.HistoryErr(err: string);
begin
	mdHistory.Append;
	mdHistory.FieldByName('DATETIME').AsDateTime := Now;
	mdHistory.FieldByName('MSG').AsString        := err;
	mdHistory.FieldByName('MSG_TYPE').AsString   := 'err';
	mdHistory.Post;

        GridHistory.Refresh;
end;

//напечатать пустую строку
procedure TfrmDataBaseEditor.HistoryVoid;
begin
   	mdHistory.Append;
	mdHistory.FieldByName('MSG_TYPE').AsString   := '';
	mdHistory.Post;
end;

procedure TfrmDataBaseEditor.GridHistoryGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdHistory.FieldByName('MSG_TYPE').AsString = 'msg') then
		Background := $00FFDDDD
	else if (mdHistory.FieldByName('MSG_TYPE').AsString = 'err') then
		Background := $00FFC4C4
        else if (mdHistory.FieldByName('MSG_TYPE').AsString = '') then
		Background := $FFFFFF;
end;

//удаление записей таблицы
function TfrmDataBaseEditor.ClearTable(table_name: string): word;
var
	record_count: longint;
begin
	result := 0;

        //подсчет количества записей в таблице
        DataMod.IB_Cursor.SQL.Text := 'SELECT COUNT(*) FROM ' + table_name;

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                HistoryErr(format('%s: Не удалось удалить записи таблицы (%s)', [table_name, DataMod.IB_Cursor.SQL.Text]));
                exit;
	end;

        record_count := DataMod.IB_Cursor.Fields[0].AsInteger;

        //таблица пуста
        if (record_count = 0) then
        begin
            	HistoryMsg(table_name + ': Таблица пуста');
                result := 1;
                exit;
        end;

        //удаление всех записей в таблице
        DataMod.IB_Cursor.SQL.Text := 'DELETE FROM ' + table_name;

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                HistoryErr(format('%s: Не удалось удалить записи таблицы (%s)', [table_name, DataMod.IB_Cursor.SQL.Text]));
                exit;
	end;

        HistoryMsg(format('%s: Удалено %d записей', [table_name, record_count]));
        DataMod.IB_Transaction.Commit;

        result := 1;
end;

//TODO: очень длинная процедура
//заполнение таблицы из FireBird данными таблицы Oracle (справочники)
procedure TfrmDataBaseEditor.btnFillManualTableClick(Sender: TObject);
var
	rec_count, added_rec_count, err_rec_count: longint;
begin
        HistoryVoid;

        ProgressBar       := TProgressBar.Create(frmMain.StatusBar);
        ProgressBar.Min   := 0;
        ProgressBar.Max   := 100;
	ProgressBar.Step  := 1;
	ProgressBar.Align := alClient;
	frmMain.StatusBar.InsertControl(ProgressBar);

        //----------------------------------------------------------------------
	//				CITY_LIST
        //----------------------------------------------------------------------
        HistoryMsg('CITY_LIST: Добавление записей...');
        ProgressBar.Position := 0;

        //TODO: если убрать ProgressBar, то переменная record_count не нужна
        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(ID) FROM KP.CITY_LIST';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('CITY_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT ID'
     		+ ', NAME'
	+ ' FROM KP.CITY_LIST';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('CITY_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO CITY_LIST(CITY_ID, NAME) VALUES('
                	+ DataMod.OracleDataSet.FieldByName('ID').AsString + ','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('CITY_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('CITY_LIST: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				STREET_LIST
        //----------------------------------------------------------------------
        HistoryMsg('STREET_LIST: Добавление записей...');
        ProgressBar.Position := 0;

        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(ID)'
	+ ' FROM KP.STREET_LIST';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('STREET_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT ID'
     		+ ', CITY_ID'
                + ', NAME'
	+ ' FROM KP.STREET_LIST';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('STREET_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO STREET_LIST(STREET_ID, CITY_ID, NAME) VALUES('
                	+ DataMod.OracleDataSet.FieldByName('ID').AsString + ','
                        + DataMod.OracleDataSet.FieldByName('CITY_ID').AsString + ','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('STREET_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('STREET_LIST: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				AGENT_LIST
        //----------------------------------------------------------------------
        HistoryMsg('AGENT_LIST: Добавление записей (агенты с открытыми ДАО)...');
        ProgressBar.Position := 0;

        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(o.SUBJ_ID)'
	+ ' FROM KP.ORGS o'
   		+ ', KP.AGRS a'
	+ ' WHERE O.SUBJ_ID = A.OWNER_ID'
		+ ' AND A.AGR_TYPE = ''DAO'''
                + ' AND A.IS_LOCK  = ''no'''
		+ ' AND A.IS_CLOSE = ''no''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('AGENT_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT o.SUBJ_ID'
                + ', o.NAME'
	+ ' FROM KP.ORGS o'
   		+ ', KP.AGRS a'
	+ ' WHERE O.SUBJ_ID = A.OWNER_ID'
		+ ' AND A.AGR_TYPE = ''DAO'''
                + ' AND A.IS_LOCK  = ''no'''
		+ ' AND A.IS_CLOSE = ''no''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('AGENT_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO AGENT_LIST(AGENT_ID, NAME) VALUES('
                	+ DataMod.OracleDataSet.FieldByName('SUBJ_ID').AsString + ','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('AGENT_LIST: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('AGENT_LIST: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				SERV_TYPES
        //----------------------------------------------------------------------
        HistoryMsg('SERV_TYPES: Добавление записей...');
        ProgressBar.Position := 0;

        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(TYPE) FROM KP.SERV_TYPES';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('SERV_TYPES: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT TYPE'
                + ', NAME'
	+ ' FROM KP.SERV_TYPES';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('SERV_TYPES: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SERV_TYPES("TYPE", NAME) VALUES('
                	+ '''' + DataMod.OracleDataSet.FieldByName('TYPE').AsString + ''','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('SERV_TYPES: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('SERV_TYPES: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				SERVICES
        //----------------------------------------------------------------------
        HistoryMsg('SERVICES: Добавление записей (услуги с открытыми ДПУ/ДПДУ)...');
        ProgressBar.Position := 0;

        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(s.ID)'
        + ' FROM KP.SERVICES s'
   		+ ', KP.AGRS a'
	+ ' WHERE S.ID = A.SERVICE_ID'
		+ ' AND A.AGR_TYPE IN (''DPU'', ''DPDU'')'
		+ ' AND A.IS_LOCK  = ''no'''
		+ ' AND A.IS_CLOSE = ''no'''
		+ ' AND s.NAME NOT LIKE ''%ЧЕЛЯБИНВЕСТБАНК%''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('SERVICES: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT s.ID'
                + ', s.TYPE'
                + ', s.NUM'
                + ', s.NAME'
	+ ' FROM KP.SERVICES s'
   		+ ', KP.AGRS a'
	+ ' WHERE S.ID = A.SERVICE_ID'
		+ ' AND A.AGR_TYPE IN (''DPU'', ''DPDU'')'
		+ ' AND A.IS_LOCK  = ''no'''
		+ ' AND A.IS_CLOSE = ''no'''
		+ ' AND s.NAME NOT LIKE ''%ЧЕЛЯБИНВЕСТБАНК%''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('SERVICES: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SERVICES(SERVICE_ID, "TYPE", NUM, NAME) VALUES('
                        + DataMod.OracleDataSet.FieldByName('ID').AsString + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('TYPE').AsString + ''','
                        + DataMod.OracleDataSet.FieldByName('NUM').AsString + ','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('SERVICES: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('SERVICES: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				SUBSRV
        //----------------------------------------------------------------------
        HistoryMsg('SUBSRV: Добавление записей (подуслуги для услуг с открытыми ДПУ/ДПДУ)...');
        ProgressBar.Position := 0;

        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(su.ID)'
        + ' FROM KP.SUB$SRV su'
   		+ ', KP.SERVICES s'
   		+ ', KP.AGRS a'
	+ ' WHERE SU.SERVICE_ID = S.ID'
		+ ' AND S.ID = A.SERVICE_ID'
		+ ' AND A.AGR_TYPE  IN (''DPU'', ''DPDU'')'
		+ ' AND A.IS_LOCK   = ''no'''
		+ ' AND A.IS_CLOSE  = ''no'''
		+ ' AND s.NAME NOT LIKE ''%ЧЕЛЯБИНВЕСТБАНК%''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.Fields[0].AsInteger;
        except
        	HistoryErr(format('SUBSRV: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //выборка всех записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT su.ID'
                + ', su.SERVICE_ID'
                + ', su.SUB_SRV_PU'
                + ', su.NAME'
	+ ' FROM KP.SUB$SRV su'
   		+ ', KP.SERVICES s'
   		+ ', KP.AGRS a'
	+ ' WHERE SU.SERVICE_ID = S.ID'
		+ ' AND S.ID = A.SERVICE_ID'
		+ ' AND A.AGR_TYPE  IN (''DPU'', ''DPDU'')'
		+ ' AND A.IS_LOCK   = ''no'''
		+ ' AND A.IS_CLOSE  = ''no'''
		+ ' AND s.NAME NOT LIKE ''%ЧЕЛЯБИНВЕСТБАНК%''';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('SUBSRV: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        added_rec_count := 0;
        err_rec_count   := 0;
        //заполняем таблицу FireBird данными таблицы Oracle
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SUBSRV(SUBSRV_ID, SERVICE_ID, SUB_SRV_PU, NAME) VALUES('
                        + DataMod.OracleDataSet.FieldByName('ID').AsString + ','
                        + DataMod.OracleDataSet.FieldByName('SERVICE_ID').AsString + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('SUB_SRV_PU').AsString + ''','
                	+ '''' + DataMod.OracleDataSet.FieldByName('NAME').AsString + ''')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('SUBSRV: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        HistoryMsg(format('SUBSRV: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
	//				INFO
        //----------------------------------------------------------------------
	DataMod.IB_Cursor.SQL.Text := 'INSERT INTO INFO(INFO_ID, VERSION, MANUAL_CREATE) VALUES('
        	+ '1,'
                + '''1.2.2''' + ',' //май 2010
                + '''' + DateTimeToStr(Now) + ''')';
        //запуск запроса
        try
        	DataMod.IB_Cursor.Open;
        except
        	HistoryErr(format('INFO: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
        end;

        HistoryMsg('INFO: Добавлено 1 записей');
        //----------------------------------------------------------------------

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;

        ProgressBar.Free;

        btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := false;
        btnClearManualTable.Enabled := true;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := true;
        btnFillAbonentTable.Enabled := true;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;
        edAddServiceNum.Enabled     := true;
        btnFillAddPayTable.Enabled  := true;
end;

//заполнение таблицы из FireBird данными таблицы Oracle (абоненты)
procedure TfrmDataBaseEditor.btnFillAbonentTableClick(Sender: TObject);
var
	rec_count, added_rec_count, err_rec_count: longint;
        subsrv, city, fio, building, apartment: string;
        max_id: integer;
begin
	HistoryVoid;

        ProgressBar       := TProgressBar.Create(frmMain.StatusBar);
        ProgressBar.Min   := 0;
        ProgressBar.Max   := 100;
	ProgressBar.Step  := 1;
	ProgressBar.Align := alClient;
	frmMain.StatusBar.InsertControl(ProgressBar);

        //----------------------------------------------------------------------
	//поиск услуги
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM SERVICES'
        + ' WHERE NUM = ' + edMainServiceNum.Text
        + ' AND "TYPE" = ''MAIN''';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске услуги.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                WarningBox('Услуга номер ' + edMainServiceNum.Text + ' не найдена' + #13 +
                'или не является основной.');
            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        //поиск записей по выбранной услуге
        DataMod.IB_Cursor.SQL.Text := 'SELECT S.NAME AS SERVICE'
        	+ ', COUNT(A.ABONENT_ID) AS ABONENT_COUNT'
	+ ' FROM ABONENTS a'
        	+ ', SERVICES s'
	+ ' WHERE A.SERVICE_ID = S.SERVICE_ID'
        	+ ' AND  S.NUM = ' + edMainServiceNum.Text
	+ ' GROUP BY S.NAME';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске записей по выбранной услуге.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.FieldByName('ABONENT_COUNT').AsInteger > 0) then
        begin
                WarningBox(edMainServiceNum.Text + ' - ' + DataMod.IB_Cursor.FieldByName('SERVICE').AsString + #13 +
                'В таблице абонентов обнаружено ' + DataMod.IB_Cursor.FieldByName('ABONENT_COUNT').AsString + ' записей.' + #13 + #13 +
                'Очистите таблицу абонентов.');

            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

        HistoryMsg('ABONENTS: Добавление записей...');
        ProgressBar.Position := 0;

        //----------------------------------------------------------------------
        //TODO: если убрать ProgressBar, то переменная record_count не нужна
        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(AB.ID) AS ABONENT_COUNT'
	+ ' FROM KP.ABONENTS ab'
   		+ ', KP.SERVICES se'
   		+ ', KP.ACCS ac'
   		+ ', KP.SUB$ACC su'
	+ ' WHERE AB.SERVICE_ID         = SE.ID'
		+ ' AND AB.ACC_ID       = AC.ID'
		+ ' AND AB.ACC_ID       = SU.ACC_ID(+)'
		+ ' AND AC.IS_ACC_LOCK  = ''no'''
		+ ' AND AC.IS_ACC_CLOSE = ''no'''
		+ ' AND SE.NUM = ' + edMainServiceNum.Text;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.FieldByName('ABONENT_COUNT').AsInteger;
        except
        	HistoryErr(format('ABONENTS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        max_id := 0;
        //получение максимального ABONENT_ID
	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(ABONENT_ID) MAX_ID FROM ABONENTS';

        //запуск запроса
        try
               DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении максимального ABONENT_ID.');
                ProgressBar.Free;
                exit;
        end;

        //таблица ABONENTS непуста
        if (DataMod.IB_Cursor.RecordCount > 0) then
                max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

        DataMod.IB_Cursor.Close;
        
        //----------------------------------------------------------------------
        //выборка записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT AB.SERVICE_ID'
     		+ ', SU.SUB_SRV_ID AS SUBSRV_ID'
     		+ ', AB.CITY_ID'
     		+ ', AB.STREET_ID'
     		+ ', AB.FIO'
     		+ ', AB.BUILDING'
     		+ ', AB.APARTMENT'
     		+ ', AB.ACC_PU'
     		+ ', AC.OPEN_TIME'
     		+ ', NVL(-SU.SALDO, - AC.BALANCE_OUT) AS BALANCE'
        + ' FROM KP.ABONENTS ab'
   		+ ', KP.SERVICES se'
   		+ ', KP.ACCS ac'
   		+ ', KP.SUB$ACC su'
	+ ' WHERE AB.SERVICE_ID         = SE.ID'
		+ ' AND AB.ACC_ID       = AC.ID'
		+ ' AND AB.ACC_ID       = SU.ACC_ID(+)'
		+ ' AND AC.IS_ACC_LOCK  = ''no'''
		+ ' AND AC.IS_ACC_CLOSE = ''no'''
		+ ' AND SE.NUM = ' + edMainServiceNum.Text
	+ ' ORDER BY FIO'
       		+ ', SUB_SRV_ID';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('ABONENTS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        //----------------------------------------------------------------------
        //заполняем таблицу FireBird данными таблицы Oracle
        added_rec_count := 0;
        err_rec_count   := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	//подуслуга, город, фио, дом, квартира могут принимать значение NULL

        	//подуслуга
		if (DataMod.OracleDataSet.FieldByName('SUBSRV_ID').IsNull) then
                  	subsrv := 'NULL'
                else
                        subsrv := DataMod.OracleDataSet.FieldByName('SUBSRV_ID').AsString;

        	//город
                if (DataMod.OracleDataSet.FieldByName('CITY_ID').IsNull) then
                  	city := 'NULL'
                else
                        city := DataMod.OracleDataSet.FieldByName('CITY_ID').AsString;

                //фио
                if (DataMod.OracleDataSet.FieldByName('FIO').IsNull) then
                  	fio := 'NULL'
                else
                        fio := '''' + DataMod.OracleDataSet.FieldByName('FIO').AsString + '''';

                //дом
                if (DataMod.OracleDataSet.FieldByName('BUILDING').IsNull) then
                  	building := 'NULL'
                else
                        building := '''' + DataMod.OracleDataSet.FieldByName('BUILDING').AsString + '''';

                //квартира
                if (DataMod.OracleDataSet.FieldByName('APARTMENT').IsNull) then
                  	apartment := 'NULL'
                else
                        apartment := '''' + DataMod.OracleDataSet.FieldByName('APARTMENT').AsString + '''';

		DataMod.IB_Cursor.SQL.Text := 'INSERT INTO ABONENTS('
                	+ '  ABONENT_ID'
                        + ', SERVICE_ID'
                        + ', SUBSRV_ID'
                	+ ', CITY_ID'
                        + ', STREET_ID'
                        + ', FIO'
                        + ', BUILDING'
                        + ', APARTMENT'
                        + ', ACC_PU'
                        + ', OPEN_TIME'
                        + ', BALANCE)'
		+ ' VALUES('
                	+ IntToStr(max_id + 1) + ','
                        + DataMod.OracleDataSet.FieldByName('SERVICE_ID').AsString + ','
                        + subsrv + ','
                        + city + ','
                        + DataMod.OracleDataSet.FieldByName('STREET_ID').AsString + ','
                        + fio + ','
                        + building + ','
                        + apartment + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('ACC_PU').AsString + ''','
                        + '''' + DataMod.OracleDataSet.FieldByName('OPEN_TIME').AsString + ''','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('BALANCE').AsString) + ')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('ABONENTS: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
		inc(max_id);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        HistoryMsg(format('ABONENTS: Добавлено %d записей', [rec_count - err_rec_count]));

        //----------------------------------------------------------------------
        //не найден ни один абонент
        if (rec_count - err_rec_count = 0) then
        begin
	        WarningBox('По услуге номер ' + edMainServiceNum.Text + ' не найден ни один абонент.');
                exit;
        end;

        //----------------------------------------------------------------------
        //услугу делаем открытой для отображения
        DataMod.IB_Cursor.SQL.Text := 'UPDATE SERVICES'
	+ ' SET VISIBLE = 1'
	+ ' WHERE NUM = ' + edMainServiceNum.Text;

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
                HistoryErr(format('SERVICE: Не удалось обновить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;

        ProgressBar.Free;

        btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := true;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := false;
        btnFillAbonentTable.Enabled := false;
        btnFillSaldoTable.Enabled   := true;
        btnFillMainPayTable.Enabled := false;

        //TODO: после заполнения таблиц справочников
        //добавлять платежи по доп. услуга можно всегда
end;

//заполнение таблицы из FireBird данными таблицы Oracle (начисления)
procedure TfrmDataBaseEditor.btnFillSaldoTableClick(Sender: TObject);
var
	rec_count, added_rec_count, err_rec_count: longint;
        max_id: integer;
        acc_pu, sub_srv_pu: string;
begin
        HistoryVoid;

        ProgressBar       := TProgressBar.Create(frmMain.StatusBar);
        ProgressBar.Min   := 0;
        ProgressBar.Max   := 100;
	ProgressBar.Step  := 1;
	ProgressBar.Align := alClient;
	frmMain.StatusBar.InsertControl(ProgressBar);

        //----------------------------------------------------------------------
	//поиск услуги
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM SERVICES'
        + ' WHERE NUM = ' + edMainServiceNum.Text
        + ' AND "TYPE" = ''MAIN''';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске услуги.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                WarningBox('Услуга номер ' + edMainServiceNum.Text + ' не найдена' + #13 +
                'или не является основной.');
            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        //поиск записей по выбранной услуге
        DataMod.IB_Cursor.SQL.Text := 'SELECT SE.NAME AS SERVICE'
     		+ ', COUNT(SA.SALDO_ID) AS SALDO_COUNT'
	+ ' FROM ABONENTS a'
   		+ ', SALDO sa'
   		+ ', SERVICES se'
	+ ' WHERE A.ABONENT_ID       = SA.ABONENT_ID'
		+ ' AND A.SERVICE_ID = SE.SERVICE_ID'
		+ ' AND SE.NUM       = ' + edMainServiceNum.Text
	+ ' GROUP BY SE.NAME';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске записей по выбранной услуге.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.FieldByName('SALDO_COUNT').AsInteger > 0) then
        begin
                WarningBox(edMainServiceNum.Text + ' - ' + DataMod.IB_Cursor.FieldByName('SERVICE').AsString + #13 +
                'В таблице начислений обнаружено ' + DataMod.IB_Cursor.FieldByName('SALDO_COUNT').AsString + ' записей.' + #13 + #13 +
                'Очистите таблицу начислений.');

            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

	HistoryMsg('SALDO: Добавление записей...');
        ProgressBar.Position := 0;

        //----------------------------------------------------------------------
        //TODO: если убрать ProgressBar, то переменная record_count не нужна
        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(REC.ID) SALDO_COUNT'
	+ ' FROM KP.REE$REEARC ree'
   		+ ', KP.REE$RECINPARC rec'
   		+ ', KP.AGRS agr'
   		+ ', KP.SERVICES se'
	+ ' WHERE REE.TYPE             = 7'
        	+ ' AND REE.ID         = REC.REEID'
		+ ' AND REE.AGRID      = AGR.ID'
		+ ' AND AGR.SERVICE_ID = SE.ID'
		+ ' AND REC.STATUS     = 14'
		+ ' AND SE.NUM         = ' + edMainServiceNum.Text;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.FieldByName('SALDO_COUNT').AsInteger;
        except
        	HistoryErr(format('SALDO: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        //выборка записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT REC.ACC_PU'
     		+ ', REC.SUB_SRV_PU'
     		+ ', NVL(REC.DATEB, TRUNC(REC.DONE)) PERIOD_BEGIN'
     		+ ', NVL(REC.DATEE, TRUNC(REC.DONE)) PERIOD_END'
     		+ ', REC.SUMM'
        + ' FROM KP.REE$REEARC ree'
   		+ ', KP.REE$RECINPARC rec'
   		+ ', KP.AGRS agr'
   		+ ', KP.SERVICES se'
	+ ' WHERE REE.TYPE             = 7'
        	+ ' AND REE.ID         = REC.REEID'
		+ ' AND REE.AGRID      = AGR.ID'
		+ ' AND AGR.SERVICE_ID = SE.ID'
		+ ' AND REC.STATUS     = 14'
		+ ' AND SE.NUM         = ' + edMainServiceNum.Text
        + ' ORDER BY REC.ACC_PU'
       		+ ', REC.SUB_SRV_PU'
       		+ ', REC.DONE';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('SALDO: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        //----------------------------------------------------------------------
        max_id := 0;
        //получение максимального SALDO_ID
	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SALDO_ID) MAX_ID FROM SALDO';

        //запуск запроса
        try
               DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении максимального SALDO_ID.');
                ProgressBar.Free;
                exit;
        end;

        //таблица SALDO непуста
        if (DataMod.IB_Cursor.RecordCount > 0) then
                max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

        DataMod.IB_Cursor.Close;

        //----------------------------------------------------------------------
        //получение списка абонентов по выбранной услуге
        DataMod.IB_Cursor.SQL.Text := 'SELECT A.ABONENT_ID'
     		+ ', A.ACC_PU'
     		+ ', SU.SUB_SRV_PU'
	+ ' FROM ABONENTS a'
	+ ' LEFT JOIN SUBSRV su'
	+ ' ON A.SUBSRV_ID = SU.SUBSRV_ID'
		+ ', SERVICES se'
	+ ' WHERE A.SERVICE_ID = SE.SERVICE_ID'
		+ ' AND SE.NUM = ' + edMainServiceNum.Text;

        //сортировка "ORDER BY ACC_PU, SUB_SRV_PU" в Oracle и Firebird
	//+ ' ORDER BY A.ACC_PU'
       	//	+ ', SU.SUB_SRV_PU';

        //запуск запроса
        try
               DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении списка абонентов.');
                ProgressBar.Free;
                exit;
        end;

        //не найден ни один абонент
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                WarningBox('По услуге номер ' + edMainServiceNum.Text + ' не найден ни один абонент.');
            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;

                edMainServiceNum.Enabled    := true;
                btnFillAbonentTable.Enabled := true;
                btnFillSaldoTable.Enabled   := false;

                exit;
        end;

        //DataMod.IB_Cursor не закрываем пока не скопируем данные во временную таблицу

        //----------------------------------------------------------------------
        //копирование списка абонентов в временную таблицу
        mdAbonent.Active := true;

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdAbonent.Append;
                mdAbonent.FieldByName('ABONENT_ID').AsInteger := DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger;
                mdAbonent.FieldByName('ACC_PU').AsString      := DataMod.IB_Cursor.FieldByName('ACC_PU').AsString;
                mdAbonent.FieldByName('SUB_SRV_PU').AsString  := DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString;

                mdAbonent.Post;
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
        
        //----------------------------------------------------------------------
        //заполняем таблицу FireBird данными таблицы Oracle
        added_rec_count := 0;
        err_rec_count   := 0;
        mdAbonent.First;

        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	//сортировка "ORDER BY ACC_PU, SUB_SRV_PU" в Oracle и Firebird
                //отрабатывает по разному (при наличии спецсимволов или английских букв),
                //поэтому приходится каждый раз возвращаться в начало списка
        	mdAbonent.First;

        	acc_pu     := DataMod.OracleDataSet.FieldByName('ACC_PU').AsString;
                sub_srv_pu := DataMod.OracleDataSet.FieldByName('SUB_SRV_PU').AsString;

                //TODO: желательно переделать цикл без оспользования BREAK
                while (not (mdAbonent.Eof)) do
                begin
                	if (mdAbonent.FieldByName('ACC_PU').AsString = acc_pu) then
                        begin
                        	if (mdAbonent.FieldByName('SUB_SRV_PU').IsNull) then
                        		break

                        	else
                        	if (mdAbonent.FieldByName('SUB_SRV_PU').AsString = sub_srv_pu) then
                        		break;
                        end;

                        mdAbonent.Next;
                end;

                if (mdAbonent.Eof) then
                begin
                	inc(err_rec_count);
                        HistoryErr(format('SALDO: Не удалось найти абонента (ACC_PU = %s, SUB_SRV_PU = %s)', [acc_pu, sub_srv_pu]));
                        DataMod.OracleDataSet.Next;
                  	mdAbonent.First;
                        continue;
                end;

		DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SALDO('
                	+ '  SALDO_ID'
                        + ', ABONENT_ID'
                        + ', PERIOD_BEGIN'
                	+ ', PERIOD_END'
                        + ', SUMM'
                        + ', IS_EXPORT)'
		+ ' VALUES('
                	+ IntToStr(max_id + 1) + ','
                        + mdAbonent.FieldByName('ABONENT_ID').AsString + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('PERIOD_BEGIN').AsString + ''','
                        + '''' + DataMod.OracleDataSet.FieldByName('PERIOD_END').AsString + ''','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('SUMM').AsString)
                        + ', 1)';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('SALDO: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
		inc(max_id);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        mdAbonent.Active := false;
	DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('SALDO: Добавлено %d записей', [rec_count - err_rec_count]));

        ProgressBar.Free;

	btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := true;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := false;
        btnFillAbonentTable.Enabled := false;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := true;

        //TODO: после заполнения таблиц справочников
        //добавлять платежи по доп. услуга можно всегда
end;

//заполнение таблицы из FireBird данными таблицы Oracle (платежи по основной услуге)
procedure TfrmDataBaseEditor.btnFillMainPayTableClick(Sender: TObject);
var
	rec_count, added_rec_count, err_rec_count: longint;
        max_id: integer;
        agent_id, sub_srv_pu, fio, city, street,
        building, apartment, acc_pu: string;
begin
	HistoryVoid;

        ProgressBar       := TProgressBar.Create(frmMain.StatusBar);
        ProgressBar.Min   := 0;
        ProgressBar.Max   := 100;
	ProgressBar.Step  := 1;
	ProgressBar.Align := alClient;
	frmMain.StatusBar.InsertControl(ProgressBar);

        //----------------------------------------------------------------------
	//поиск услуги
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM SERVICES'
        + ' WHERE NUM = ' + edMainServiceNum.Text
        + ' AND "TYPE" = ''MAIN''';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске услуги.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                WarningBox('Услуга номер ' + edMainServiceNum.Text + ' не найдена' + #13 +
                'или не является основной.');
            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;
        
        //----------------------------------------------------------------------
        //поиск записей по выбранной услуге
        DataMod.IB_Cursor.SQL.Text := 'SELECT S.NAME AS SERVICE'
        	+ ', COUNT(P.PAY_ID) AS PAY_COUNT'
	+ ' FROM PAYS p'
        	+ ', SERVICES s'
	+ ' WHERE P.SERVICE_ID = S.SERVICE_ID'
        	+ ' AND S.NUM  = ' + edMainServiceNum.Text
	+ ' GROUP BY S.NAME';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске записей по выбранной услуге.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.FieldByName('PAY_COUNT').AsInteger > 0) then
        begin
                WarningBox(edMainServiceNum.Text + ' - ' + DataMod.IB_Cursor.FieldByName('SERVICE').AsString + #13 +
                'В таблице платежей обнаружено ' + DataMod.IB_Cursor.FieldByName('PAY_COUNT').AsString + ' записей.' + #13 + #13 +
                'Очистите таблицу платежей.');

            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

        HistoryMsg('PAYS: Добавление записей...');
        ProgressBar.Position := 0;

        //----------------------------------------------------------------------
        //TODO: если убрать ProgressBar, то переменная record_count не нужна
        //подсчет количества записей в таблице Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(REC.ID) AS PAY_COUNT'
	+ ' FROM KP.REE$REESTERS ree'
   		+ ', KP.REE$RECORDS rec'
   		+ ', KP.AGRS ag'
   		+ ', KP.SERVICES se'
	+ ' WHERE REE.TYPE IN (2,4)'
        	+ ' AND REE.ID        = REC.REEID'
		+ ' AND REE.AGRID     = AG.ID'
		+ ' AND AG.SERVICE_ID = SE.ID'
		+ ' AND SE.NUM = ' + edMainServiceNum.Text;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.FieldByName('PAY_COUNT').AsInteger;
        except
        	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        max_id := 0;
        //получение максимального PAYS_ID
	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(PAY_ID) MAX_ID FROM PAYS';

        //запуск запроса
        try
               DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении максимального PAY_ID.');
                ProgressBar.Free;
                exit;
        end;

        //таблица PAY непуста
        if (DataMod.IB_Cursor.RecordCount > 0) then
                max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

        DataMod.IB_Cursor.Close;
        
        //----------------------------------------------------------------------
        //выборка записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT REE.ID AS REE_ID'
     		+ ', REE.AGENTID AS AGENT_ID'
     		+ ', AB.SERVICE_ID'
     		+ ', REC.SUB_SRV_PU'
     		+ ', AB.FIO'
     		+ ', CI.NAME AS CITY'
     		+ ', ST.NAME AS STREET'
     		+ ', AB.BUILDING'
     		+ ', AB.APARTMENT'
     		+ ', AB.ACC_PU'
     		+ ', REC.SUMM'
     		+ ', TRUNC(REE.CREATED) AS DATE_PAY'
     		+ ', REC.BALANCE AS BALANCE'
     		+ ', REC.UNO'
	+ ' FROM KP.REE$REESTERS ree'
   		+ ', KP.REE$RECORDS rec'
   		+ ', KP.ABONENTS ab'
   		+ ', KP.AGRS ag'
   		+ ', KP.SERVICES se'
   		+ ', KP.CITY_LIST ci'
   		+ ', KP.STREET_LIST st'
	+ ' WHERE REE.TYPE IN (2,4)'
        	+ ' AND REE.ID        = REC.REEID'
		+ ' AND REC.ABNID     = AB.ID'
		+ ' AND AB.CITY_ID    = CI.ID'
		+ ' AND AB.STREET_ID  = ST.ID'
		+ ' AND REE.AGRID     = AG.ID'
		+ ' AND AG.SERVICE_ID = SE.ID'
		+ ' AND SE.NUM = ' + edMainServiceNum.Text
        //сортировка необходима только для сложной услуги
        + ' ORDER BY REE.ID'
        	+ ', REC.UNO';

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        //----------------------------------------------------------------------
        //заполняем таблицу FireBird данными таблицы Oracle
        added_rec_count := 0;
        err_rec_count   := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	//подуслуга, фио, город, улица, дом, квартира, л/с могут принимать значение NULL

        	//TODO: как ни странно, но по некоторым платежам
                //не заполнено поле AGENT_ID
        	if (DataMod.OracleDataSet.FieldByName('AGENT_ID').IsNull) then
                  	agent_id := '0'
                else
                        agent_id := DataMod.OracleDataSet.FieldByName('AGENT_ID').AsString;

                //подуслуга
		if (DataMod.OracleDataSet.FieldByName('SUB_SRV_PU').IsNull) then
                  	sub_srv_pu := 'NULL'
                else
                        sub_srv_pu := '''' + DataMod.OracleDataSet.FieldByName('SUB_SRV_PU').AsString + '''';

                //фио
                if (DataMod.OracleDataSet.FieldByName('FIO').IsNull) then
                  	fio := 'NULL'
                else
                        fio := '''' + DataMod.OracleDataSet.FieldByName('FIO').AsString + '''';

        	//город
                if (DataMod.OracleDataSet.FieldByName('CITY').IsNull) then
                  	city := 'NULL'
                else
                        city := '''' + DataMod.OracleDataSet.FieldByName('CITY').AsString + '''';

                //улица
                if (DataMod.OracleDataSet.FieldByName('STREET').IsNull) then
                  	street := 'NULL'
                else
                        street := '''' + DataMod.OracleDataSet.FieldByName('STREET').AsString + '''';

                //дом
                if (DataMod.OracleDataSet.FieldByName('BUILDING').IsNull) then
                  	building := 'NULL'
                else
                        building := '''' + DataMod.OracleDataSet.FieldByName('BUILDING').AsString + '''';

                //квартира
                if (DataMod.OracleDataSet.FieldByName('APARTMENT').IsNull) then
                  	apartment := 'NULL'
                else
                        apartment := '''' + DataMod.OracleDataSet.FieldByName('APARTMENT').AsString + '''';

                //лицевой счет
                if (DataMod.OracleDataSet.FieldByName('ACC_PU').IsNull) then
                  	acc_pu := 'NULL'
                else
                        acc_pu := '''' + DataMod.OracleDataSet.FieldByName('ACC_PU').AsString + '''';

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
                        + ', SUMM'
                        + ', DATE_PAY'
                        + ', BALANCE'
                        + ', UNO)'
		+ ' VALUES('
                	+ IntToStr(max_id + 1) + ','
                        + DataMod.OracleDataSet.FieldByName('REE_ID').AsString + ','
                        + agent_id + ','
                        + DataMod.OracleDataSet.FieldByName('SERVICE_ID').AsString + ','
                        + sub_srv_pu + ','
                        + fio + ','
                        + city + ','
                        + street + ','
                        + building + ','
                        + apartment + ','
                        + acc_pu + ','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('SUMM').AsString) + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('DATE_PAY').AsString + ''','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('BALANCE').AsString) + ','
                        + DataMod.OracleDataSet.FieldByName('UNO').AsString + ')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
		inc(max_id);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('PAYS: Добавлено %d записей', [rec_count - err_rec_count]));

        ProgressBar.Free;

        btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := true;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        edMainServiceNum.Enabled    := true;
        btnFillAbonentTable.Enabled := true;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;

	//TODO: после заполнения таблиц справочников
        //добавлять платежи по доп. услуга можно всегда
end;

procedure TfrmDataBaseEditor.btnFillAddPayTableClick(Sender: TObject);
var
	rec_count, added_rec_count, err_rec_count: longint;
        max_id: integer;
        i, field: word;
        s, str, agent_id, fio, city,
        street, building, apartment: string;
begin
	HistoryVoid;

        ProgressBar       := TProgressBar.Create(frmMain.StatusBar);
        ProgressBar.Min   := 0;
        ProgressBar.Max   := 100;
	ProgressBar.Step  := 1;
	ProgressBar.Align := alClient;
	frmMain.StatusBar.InsertControl(ProgressBar);

        //----------------------------------------------------------------------
	//поиск услуги
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME FROM SERVICES'
        + ' WHERE NUM = ' + edAddServiceNum.Text
        + ' AND "TYPE" = ''ADD''';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске услуги.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
                WarningBox('Услуга номер ' + edAddServiceNum.Text + ' не найдена' + #13 +
                'или не является дополнительной.');
            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;
        
        //----------------------------------------------------------------------
        //поиск записей по выбранной услуге
        DataMod.IB_Cursor.SQL.Text := 'SELECT S.NAME AS SERVICE'
        	+ ', COUNT(P.PAY_ID) AS PAY_COUNT'
	+ ' FROM PAYS p'
        	+ ', SERVICES s'
	+ ' WHERE P.SERVICE_ID = S.SERVICE_ID'
        	+ ' AND S.NUM = ' + edAddServiceNum.Text
	+ ' GROUP BY S.NAME';

	//запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при поиске записей по выбранной услуге.');
                ProgressBar.Free;
                exit;
	end;

        if (DataMod.IB_Cursor.FieldByName('PAY_COUNT').AsInteger > 0) then
        begin
                WarningBox(edAddServiceNum.Text + ' - ' + DataMod.IB_Cursor.FieldByName('SERVICE').AsString + #13 +
                'В таблице платежей обнаружено ' + DataMod.IB_Cursor.FieldByName('PAY_COUNT').AsString + ' записей.' + #13 + #13 +
                'Очистите таблицу платежей.');

            	DataMod.OracleDataSet.Close;
                ProgressBar.Free;
                exit;
        end;

        DataMod.OracleDataSet.Close;

        HistoryMsg('PAYS: Добавление записей...');
        ProgressBar.Position := 0;

        //----------------------------------------------------------------------
        //TODO: если убрать ProgressBar, то переменная record_count не нужна
        //подсчет количества записей в таблице Oracle
	DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(REC.ID) AS PAY_COUNT'
        + ' FROM KP.REE$REESTERS ree'
   		+ ', KP.REE$RECORDS rec'
   		+ ', KP.AGRS ag'
   		+ ', KP.SERVICES se'
	+ ' WHERE REE.TYPE IN (2,4)'
        	+ ' AND REE.ID        = REC.REEID'
		+ ' AND REE.AGRID     = AG.ID'
		+ ' AND AG.SERVICE_ID = SE.ID'
		+ ' AND SE.NUM = ' + edAddServiceNum.Text;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
                rec_count := DataMod.OracleDataSet.FieldByName('PAY_COUNT').AsInteger;
        except
        	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
                rec_count := 0;
	end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        max_id := 0;
        //получение максимального PAYS_ID
	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(PAY_ID) MAX_ID FROM PAYS';

        //запуск запроса
        try
               DataMod.IB_Cursor.Open;
        except
                WarningBox('Ошибка при нахождении максимального PAY_ID.');
                ProgressBar.Free;
                exit;
        end;

        //таблица PAY непуста
        if (DataMod.IB_Cursor.RecordCount > 0) then
                max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

        DataMod.IB_Cursor.Close;
        
        //----------------------------------------------------------------------
        //выборка записей из Oracle
        DataMod.OracleDataSet.SQL.Text := 'SELECT REE.ID AS REE_ID'
     		+ ', REE.AGENTID AS AGENT_ID'
     		+ ', SE.ID AS SERVICE_ID'
     		+ ', REC.FIO'
     		+ ', REC.ADDRESS'
     		+ ', REC.SUMM'
     		+ ', TRUNC(REE.CREATED) AS DATE_PAY'
     		+ ', REC.BALANCE AS BALANCE'
     		+ ', REC.UNO'
	+ ' FROM KP.REE$REESTERS ree'
   		+ ', KP.REE$RECORDS rec'
   		+ ', KP.AGRS ag'
   		+ ', KP.SERVICES se'
	+ ' WHERE REE.TYPE IN (2,4)'
        	+ ' AND REE.ID        = REC.REEID'
		+ ' AND REE.AGRID     = AG.ID'
		+ ' AND AG.SERVICE_ID = SE.ID'
		+ ' AND SE.NUM = ' + edAddServiceNum.Text;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.OracleDataSet.SQL.Text]));
	end;

        //----------------------------------------------------------------------
        //заполняем таблицу FireBird данными таблицы Oracle
        added_rec_count := 0;
        err_rec_count   := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	city       := '';
  		street     := '';
        	building   := '';
  		apartment  := '';

                str   := DataMod.OracleDataSet.FieldByName('ADDRESS').AsString;
        	s     := '';
        	field := 1;

        	for i := 1 to length(str) + 1 do
        	begin
            		if ((str[i] = ',') or (i = length(str) + 1)) then
                	begin
                		case (field) of
                                	1:  city       := s;
                                	2:  street     := s;
                                	3:  building   := s;
                                	4:  apartment  := s;
                		end;

                        	s := '';
                        	inc(field);
                	end

                	else
                		s := s + str[i];
        	end;

                //фио, город, улица, дом, квартира могут принимать значение NULL
                //подуслуг и лицевых счетов у доп. услуг нет

        	//TODO: как ни странно, но по некоторым платежам
                //не заполнено поле AGENT_ID
        	if (DataMod.OracleDataSet.FieldByName('AGENT_ID').IsNull) then
                  	agent_id := '0'
                else
                        agent_id := DataMod.OracleDataSet.FieldByName('AGENT_ID').AsString;

                //фио
                if (DataMod.OracleDataSet.FieldByName('FIO').IsNull) then
                  	fio := 'NULL'
                else
                        fio := '''' + DataMod.OracleDataSet.FieldByName('FIO').AsString + '''';

        	//город
                if (DelLeftSpace(city) = '') then
                  	city := 'NULL'
                else
                        city := '''' + DelLeftSpace(city) + '''';

                //улица
                if (DelLeftSpace(street) = '') then
                  	street := 'NULL'
                else
                        street := '''' + DelLeftSpace(street) + '''';

                //дом
                if (DelLeftSpace(building) = '') then
                  	building := 'NULL'
                else
                        building := '''' + DelLeftSpace(building) + '''';

                //квартира
                if (DelLeftSpace(apartment) = '') then
                  	apartment := 'NULL'
                else
                        apartment := '''' + DelLeftSpace(apartment) + '''';

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
                        + ', SUMM'
                        + ', DATE_PAY'
                        + ', BALANCE'
                        + ', UNO)'
		+ ' VALUES('
                	+ IntToStr(max_id + 1) + ','
                        + DataMod.OracleDataSet.FieldByName('REE_ID').AsString + ','
                        + agent_id + ','
                        + DataMod.OracleDataSet.FieldByName('SERVICE_ID').AsString + ','
                        + fio + ','
                        + city + ','
                        + street + ','
                        + building + ','
                        + apartment + ','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('SUMM').AsString) + ','
                        + '''' + DataMod.OracleDataSet.FieldByName('DATE_PAY').AsString + ''','
                        + Sep2Dot(DataMod.OracleDataSet.FieldByName('BALANCE').AsString) + ','
                        + DataMod.OracleDataSet.FieldByName('UNO').AsString + ')';

                //запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	inc(err_rec_count);
                	HistoryErr(format('PAYS: Не удалось заполнить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
		end;

                inc(added_rec_count);
		inc(max_id);
                ProgressBar.Position := round(100 * added_rec_count / rec_count);
                DataMod.IB_Cursor.Close;
        	DataMod.OracleDataSet.Next;
        end;

        //----------------------------------------------------------------------
        //услугу делаем открытой для отображения
        DataMod.IB_Cursor.SQL.Text := 'UPDATE SERVICES'
	+ ' SET VISIBLE = 1'
	+ ' WHERE NUM = ' + edAddServiceNum.Text;

        //запуск запроса
        try
                DataMod.IB_Cursor.Open;
        except
                HistoryErr(format('SERVICE: Не удалось обновить запись таблицы (%s)', [DataMod.IB_Cursor.SQL.Text]));
        end;

        DataMod.OracleDataSet.Close;
        DataMod.IB_Transaction.Commit;
        HistoryMsg(format('PAYS: Добавлено %d записей', [rec_count - err_rec_count]));

        ProgressBar.Free;

        btnConnect.Enabled          := false;
        btnDisconnect.Enabled       := true;
        btnClearBuhTable.Enabled    := true;
        btnClearManualTable.Enabled := false;
        btnFillManualTable.Enabled  := false;
        btnFillSaldoTable.Enabled   := false;
        btnFillMainPayTable.Enabled := false;

        //TODO: после заполнения таблиц справочников
        //добавлять платежи по доп. услуга можно всегда
end;

end.

