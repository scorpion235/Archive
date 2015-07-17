//Платежи
unit fPay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  DBCtrls, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDCustomParentPanel, LMDCustomPanelFill,
  LMDWndButtonShape, IB_UpdateBar, IB_TransactionBar, IB_SearchBar,
  IB_NavigationBar, IB_Controls, ComCtrls, LMDControl, LMDBaseControl,
  LMDBaseGraphicControl, LMDGraphicControl, LMDBaseMeter,
  LMDCustomProgress, LMDDBProgress, LMDDBBtn, TB97Ctls, TB97, TB97Tlbr,
  ActnList, PrnDbgeh;

type
  TfrmPay = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    dsPay: TDataSource;
    pnlGrid: TPanel;
    RxSplitter2: TRxSplitter;
    pmPays: TPopupMenu;
    pmCityAdd: TMenuItem;
    pmCityEdit: TMenuItem;
    pmCityDelete: TMenuItem;
    N1: TMenuItem;
    pmCityRefresh: TMenuItem;
    GridPay: TDBGridEh;
    mdPay: TRxMemoryData;
    mdPayPAY_ID: TIntegerField;
    mdPayREE_ID: TIntegerField;
    mdPayAGENT_ID: TIntegerField;
    mdPaySERVICE_ID: TIntegerField;
    mdPayAGENT: TStringField;
    mdPaySERVICE: TStringField;
    mdPayFIO: TStringField;
    mdPayCITY: TStringField;
    mdPaySTREET: TStringField;
    mdPayBUILDING: TStringField;
    mdPayAPARTMENT: TStringField;
    mdPayDATE_PAY: TDateField;
    mdPaySUMM: TFloatField;
    lblService: TLabel;
    cbService: TDBComboBoxEh;
    lblFIO: TLabel;
    edFIO: TDBEditEh;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
    lblStreet: TLabel;
    edStreet: TDBEditEh;
    PrintGrid: TPrintDBGridEh;
    mdPayUNO: TStringField;
    xlExcel: TxlReport;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcFilterPanelExecute(Sender: TObject);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcel(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridPaySortMarkingChanged(Sender: TObject);
    procedure edAgentChange(Sender: TObject);
    procedure cbServiceChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    fGetPayList: boolean;
    procedure SetServiceList(cb: TDBComboBoxEh);
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GetPayList;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    //выводим содержимое сетки на принтер
    procedure Print;
  end;

var
  frmPay: TfrmPay;

implementation

uses
	dmAbonents,
        fMain,
        fPayPrint,
        fProgress,
        uCommon;

{$R *.dfm}

procedure TfrmPay.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
        fChildInfo.Actions[childFilterPanel] := AcFilterPanelExecute;
        fChildInfo.Actions[childAdd]         := nil;
        fChildInfo.Actions[childEdit]        := nil;
        fChildInfo.Actions[childDelete]      := nil;
	fChildInfo.Actions[childRefresh]     := AcRefreshExecute;
        fChildInfo.Actions[childToExcel]     := AcToExcel;

        mdPay.Active := true;
        fGetPayList  := false;

        SetServiceList(cbService);
        SetCityList(cbCity);
        LoadFromIni;

        pnlFilter.Visible  := fChildInfo.abFilterPanelOn;
	RxSplitter.Visible := fChildInfo.abFilterPanelOn;

        fGetPayList := true;
end;

procedure TfrmPay.FormShow(Sender: TObject);
begin
	GetPayList;
end;

procedure TfrmPay.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdPay.Active := false;
	Action := caFree;
end;

//задание списка услуг
procedure TfrmPay.SetServiceList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT SERVICE_ID, NAME'
	+ ' FROM SERVICES'
        + ' WHERE VISIBLE = 1'
        + ' AND "TYPE" = ''MAIN''' //отображаются только дополнительные услуги
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка услуг.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все услуги]');
        cb.KeyItems.Add('[Все услуги]');

        //количество услуг = 0
        {if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	WarningBox('Не выбрана ни одна основная услуга для отображения.' + #13 +
                'Поле фильтрации "Услуга" будет недоступно.' + #13 + #13 +
		'Выберите услигу(и) в справочнике услуг.');
                cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;}

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//задание списка городов
procedure TfrmPay.SetCityList(cb: TDBComboBoxEh);
begin
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
        cb.Items.Add('[Все города]');
        cb.KeyItems.Add('[Все города]');

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmPay.LoadFromIni;
var
	sect: string;
begin
	sect := 'Pay';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);

        cbService.Text             := OptionsIni.ReadString(sect, 'Service', '[Все услуги]');
        if (cbService.Text = '') then
         	cbService.ItemIndex := 0;

        edFIO.Text                 := OptionsIni.ReadString(sect, 'FIO', '');

        cbCity.Text                := OptionsIni.ReadString(sect, 'City', '[Все города]');
        if (cbCity.Text = '') then
         	cbCity.ItemIndex := 0;

        edStreet.Text              := OptionsIni.ReadString(sect, 'Street', '');
end;

//сохранение параметров в ini-файл
procedure TfrmPay.SaveToIni;
var
	sect: string;
begin
	sect := 'Pay';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Service', cbService.Text);
        OptionsIni.WriteString(sect, 'FIO', edFIO.Text);
        OptionsIni.WriteString(sect, 'City', cbCity.Text);
        OptionsIni.WriteString(sect, 'Street', edStreet.Text);
end;

//панель фильтрации
procedure TfrmPay.AcFilterPanelExecute(Sender: TObject);
begin
        fChildInfo.abFilterPanelOn := not fChildInfo.abFilterPanelOn;
	RxSplitter.Visible   	   := fChildInfo.abFilterPanelOn;
	pnlFilter.Visible 	   := fChildInfo.abFilterPanelOn;
end;

//------------------------------------------------------------------------------
//
//	Управление записями
//
//------------------------------------------------------------------------------

//обновить данные
procedure TfrmPay.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        //LoadFromIni;

        for i := 0 to GridPay.Columns.Count - 1 do
        	GridPay.Columns[i].Title.SortMarker := smNoneEh;

	GetPayList;
end;

//экспортировать в Excel
procedure TfrmPay.AcToExcel(Sender: TObject);
begin
        xlExcel.Params.Items[0].AsString := edFIO.Text;
        xlExcel.Params.Items[1].AsString := cbCity.Text;
        xlExcel.Params.Items[2].AsString := edStreet.Text;
        ProgressReport(xlExcel);
end;

//------------------------------------------------------------------------------
//получение списка агентов
procedure TfrmPay.GetPayList;
begin
	//MsgBox('GetPayList');
        if (QueryFromOracle) then
	        CopyToMemoryData;
end;

//запрос в Оракл
function TfrmPay.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT P.PAY_ID'
     		+ ', P.REE_ID'
     		+ ', P.AGENT_ID'
     		+ ', P.SERVICE_ID'
     		+ ', A.NAME  AS AGENT'
     		+ ', SE.NAME AS SERVICE'
     		+ ', P.FIO'
     		+ ', P.CITY'
     		+ ', P.STREET'
     		+ ', P.BUILDING'
     		+ ', P.APARTMENT'
     		+ ', P.DATE_PAY'
     		+ ', P.UNO'
     		+ ', P.SUMM'
	+ ' FROM PAYS P'
	+ ' LEFT JOIN  AGENT_LIST A ON P.AGENT_ID   = A.AGENT_ID'
        + ' INNER JOIN SERVICES SE  ON P.SERVICE_ID = SE.SERVICE_ID'
        + ' WHERE P.ACC_PU IS NOT NULL');

	//выбрана услуга
        if (cbService.ItemIndex <> 0) then
                DataMod.IB_Cursor.SQL.Add(' AND P.SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]);

	//указан шаблон ФИО абонента
        if (edFIO.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(P.FIO) LIKE UPPER(''%' + edFIO.Text + '%'')');

        //выбран город
        if (cbCity.ItemIndex <> 0) then
                DataMod.IB_Cursor.SQL.Add(' AND P.CITY = ''' + cbCity.Text + '''');

        //указан шаблон названия улицы
        if (edStreet.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(P.STREET) LIKE UPPER(''%' + edStreet.Text + '%'')');


	DataMod.IB_Cursor.SQL.Add(' ORDER BY P.DATE_PAY'
       		+ ', SE.NAME'
       		+ ', A.NAME');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении таблицы платежей.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmPay.CopyToMemoryData;
var
	i, record_count,
        step: integer;
        summ: double;
begin
	GridPay.DataSource.DataSet.DisableControls;

   	mdPay.EmptyTable;
        record_count := 0;
        step         := 1000;
        summ         := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdPay.Append;
                mdPay.FieldByName('PAY_ID').AsInteger     := DataMod.IB_Cursor.FieldByName('PAY_ID').AsInteger;
                mdPay.FieldByName('REE_ID').AsInteger     := DataMod.IB_Cursor.FieldByName('REE_ID').AsInteger;
                mdPay.FieldByName('AGENT_ID').AsInteger   := DataMod.IB_Cursor.FieldByName('AGENT_ID').AsInteger;
                mdPay.FieldByName('SERVICE_ID').AsInteger := DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsInteger;

                if (DataMod.IB_Cursor.FieldByName('NAME').IsNotNull) then
                	mdPay.FieldByName('AGENT').AsString := DataMod.IB_Cursor.FieldByName('AGENT').AsString
        	else
                	mdPay.FieldByName('AGENT').AsString := 'Агент #' + DataMod.IB_Cursor.FieldByName('AGENT_ID').AsString;

                mdPay.FieldByName('SERVICE').AsString     := DataMod.IB_Cursor.FieldByName('SERVICE').AsString;

                if (DataMod.IB_Cursor.FieldByName('FIO').IsNotNull) then
                	mdPay.FieldByName('FIO').AsString := DataMod.IB_Cursor.FieldByName('FIO').AsString;

                if (DataMod.IB_Cursor.FieldByName('CITY').IsNotNull) then
                	mdPay.FieldByName('CITY').AsString := DataMod.IB_Cursor.FieldByName('CITY').AsString;

                if (DataMod.IB_Cursor.FieldByName('STREET').IsNotNull) then
                	mdPay.FieldByName('STREET').AsString := DataMod.IB_Cursor.FieldByName('STREET').AsString;

                if (DataMod.IB_Cursor.FieldByName('BUILDING').IsNotNull) then
                	mdPay.FieldByName('BUILDING').AsString := DataMod.IB_Cursor.FieldByName('BUILDING').AsString;

                if (DataMod.IB_Cursor.FieldByName('APARTMENT').IsNotNull) then
                	mdPay.FieldByName('APARTMENT').AsString := DataMod.IB_Cursor.FieldByName('APARTMENT').AsString;
                
                mdPay.FieldByName('DATE_PAY').AsDateTime  := DataMod.IB_Cursor.FieldByName('DATE_PAY').AsDateTime;
                mdPay.FieldByName('UNO').AsString         := DataMod.IB_Cursor.FieldByName('UNO').AsString;
                mdPay.FieldByName('SUMM').AsFloat         := DataMod.IB_Cursor.FieldByName('SUMM').AsFloat;
                mdPay.Post;
                DataMod.IB_Cursor.Next;

                if (record_count = step) then
                begin
                	frmMain.StatusBar.Panels[0].Text := format('Загружено: %d записей', [record_count]);
                        frmMain.StatusBar.Refresh;
                    	step := step + 1000;
                end;

                inc(record_count);
                summ := summ + mdPay.FieldByName('SUMM').AsFloat;
        end;
        DataMod.IB_Cursor.Close;
        mdPay.First;

        for i := 0 to GridPay.Columns.Count - 1 do
        begin
                if (GridPay.Columns.Items[i].FieldName = 'PAY_ID') then
                 	GridPay.Columns[i].Footer.Value := IntToStr(record_count);
                if (GridPay.Columns.Items[i].FieldName = 'SUMM') then
        		GridPay.Columns.Items[i].Footer.Value := format('%f руб.', [summ]);
        end;

        GridPay.DataSource.DataSet.EnableControls;
end;

procedure TfrmPay.pnlFilterResize(Sender: TObject);
begin
	cbService.Width := pnlFilter.Width - 20;
        cbCity.Width    := pnlFilter.Width - 20;
        edStreet.Width  := pnlFilter.Width - 20;
	edFIO.Width     := pnlFilter.Width - 20;
end;

procedure TfrmPay.GridPaySortMarkingChanged(Sender: TObject);
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

procedure TfrmPay.edAgentChange(Sender: TObject);
begin
	if (fGetPaylist) then
   		GetPayList;
end;

procedure TfrmPay.cbServiceChange(Sender: TObject);
begin
	if (fGetPayList) then
   		GetPayList;
end;

//выводим содержимое сетки на принтер
procedure TfrmPay.Print;
var
	frm: TfrmPayPrint;
begin
  	frm := TfrmPayPrint.Create(self);
        frm.ShowModal;
end;

end.
