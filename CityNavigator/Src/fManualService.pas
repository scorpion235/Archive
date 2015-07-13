//Справочник услуг
unit fManualService;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  CheckLst;

type
  TfrmManualService = class(TForm)
    pnlFilter: TPanel;
    RxSplitterVertical: TRxSplitter;
    pnlFilterTop: TPanel;
    mdManualService: TRxMemoryData;
    dsManualService: TDataSource;
    lblService: TLabel;
    xlReport: TxlReport;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    pmExcel: TMenuItem;
    mdManualServiceID: TIntegerField;
    mdManualServiceNUM: TIntegerField;
    mdManualServiceNAME: TStringField;
    mdManualServiceTYPE: TStringField;
    lblType: TLabel;
    cbType: TDBComboBoxEh;
    edService: TDBEditEh;
    pnlGrid: TPanel;
    GridManualService: TDBGridEh;
    RxSplitterHorizontal: TRxSplitter;
    GridDogovory: TDBGridEh;
    btnDogovory: TButton;
    dsDogovory: TDataSource;
    mdDogovory: TRxMemoryData;
    IntegerField1: TIntegerField;
    mdDogovoryAGR_TYPE: TStringField;
    mdDogovoryAGENT: TStringField;
    mdDogovoryOPEN_TIME: TDateTimeField;
    mdManualServiceIS_CLOSE: TStringField;
    mdManualServiceSUB_SRV: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualServiceSortMarkingChanged(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure btnDogovoryClick(Sender: TObject);
    procedure GridDogovorySortMarkingChanged(Sender: TObject);
    procedure mdManualServiceAfterScroll(DataSet: TDataSet);
    procedure GridManualServiceGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure edServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fChildInfo: PChildInfo;   
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetTypeList(cb: TDBComboBoxEh);
    procedure RunQuery;
    //запрос в Оракл (услуги)
    function QueryFromOracleService: boolean;
    //копирование данных во временную таблицу (услуги)
    procedure CopyToMemoryDataService;
    //запрос в Оракл (договоры)
    function QueryFromOracleDogovory: boolean;
    //копирование данных во временную таблицу (договоры)
    procedure CopyToMemoryDataDogovory;
  public
    fStartQuery: boolean;
    fColorMode : boolean;
  end;

var
  frmManualService: TfrmManualService;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualService.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        GridDogovory.Visible         := false;
        RxSplitterHorizontal.Visible := false;

        mdManualService.Active := true;
        mdDogovory.Active      := true;
        fStartQuery            := false;

        SetTypeList(cbType);
        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualService.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmManualService.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualService.Active := false;
        mdDogovory.Active      := false;
	Action := caFree;
end;

//задание списка типов услуг
procedure TfrmManualService.SetTypeList(cb: TDBComboBoxEh);
begin
        DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(NAME)'
	+ ' FROM KP.SERV_TYPES'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualService).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все типы]');
        cb.KeyItems.Add('[Все типы]');
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualService.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualService';
	pnlFilter.Width  := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        cbType.ItemIndex := OptionsIni.ReadInteger(sect, 'TypeItem', 0);
        edService.Text   := OptionsIni.ReadString(sect, 'Service', '');

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmManualService.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualService';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteInteger(sect, 'TypeItem', cbType.ItemIndex);
        OptionsIni.WriteString(sect, 'Service', edService.Text);
end;

//обновить
procedure TfrmManualService.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualService.Columns.Count - 1 do
        	GridManualService.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualService.AcToExcelExecute(Sender: TObject);
begin
	xlReport.Params.Items[0].AsString := cbType.Text;
        xlReport.Params.Items[1].AsString := edService.Text;
    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualService.pmExcelClick(Sender: TObject);
begin
  	xlReport.Params.Items[0].AsString := cbType.Text;
        xlReport.Params.Items[1].AsString := edService.Text;
    	ProgressReport(xlReport);
end;

procedure TfrmManualService.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracleService) then
	        CopyToMemoryDataService;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл (услуги)
function TfrmManualService.QueryFromOracleService: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        {DataMod.OracleDataSet.SQL.Add('SELECT S.ID'
     		+ ', S.NUM'
     		+ ', S.NAME'
     		+ ', T.NAME AS TYPE'
	+ ' FROM KP.SERVICES S'
   		+ ', KP.SERV_TYPES T'
	+ ' WHERE S.TYPE = T.TYPE');}

        //----------------------------------------------------------------------
        DataMod.OracleDataSet.SQL.Add('select s.id'
     		+ ', s.num'
     		+ ', s.name'
     		+ ', st.name type'
     		+ ', pu.is_close is_close'
     		+ ', decode(ss.total, null, ''no'', ''yes'') sub_srv'
	+ ' from kp.services s'
        + ', kp.serv_types st'
        	+ ', (select id'
           		+ ', decode(is_lock, ''yes'', ''yes'',is_close) is_close'
           		+ ', owner_id'
           		+ ', service_id'
      		+ ' from kp.agrs'
      		+ ' where agr_type in (''DPU'', ''DPDU'')'
     		+ ') pu'
   	+ ', kp.orgs b'
   		+ ', (select service_id'
           		+ ', count(id) total'
      		+ ' from kp.sub$srv'
                + ' group by service_id'
     		+ ') ss'
        + ' where (nvl(s.systype,-1) in (-1,2))'
	+ ' and s.id        = pu.service_id(+)'
	+ ' and pu.owner_id = b.subj_id(+)'
	+ ' and s.id        = ss.service_id(+)'
        + ' and s.type      = st.type'
	+ ' and pu.owner_id > 0');

        //выбран тип
        if (cbType.ItemIndex <> 0) then
	        DataMod.OracleDataSet.SQL.Add(' and st.name = ''' + cbType.Text + '''');

	//указан шаблон названия услуги
        if (edService.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' and upper(s.name) like upper(''%' + edService.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' order by s.id');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualService).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (услуги)
procedure TfrmManualService.CopyToMemoryDataService;
var
	record_count: integer;
begin
	GridManualService.DataSource.DataSet.DisableControls;

   	mdManualService.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualService.Append;
                mdManualService.FieldByName('ID').AsInteger      := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdManualService.FieldByName('NUM').AsInteger     := DataMod.OracleDataSet.FieldByName('NUM').AsInteger;
                mdManualService.FieldByName('NAME').AsString     := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdManualService.FieldByName('TYPE').AsString     := DataMod.OracleDataSet.FieldByName('TYPE').AsString;
                mdManualService.FieldByName('IS_CLOSE').AsString := DataMod.OracleDataSet.FieldByName('IS_CLOSE').AsString;
                mdManualService.FieldByName('SUB_SRV').AsString  := DataMod.OracleDataSet.FieldByName('SUB_SRV').AsString;
                mdManualService.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualService.First;
        GridManualService.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualService.DataSource.DataSet.EnableControls;

        btnDogovory.Enabled := record_count > 0;
end;

//запрос в Оракл (договоры)
function TfrmManualService.QueryFromOracleDogovory: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Text := 'SELECT A.ID'
     		+ ', DECODE(A.AGR_TYPE, ''DPPU'', ''ДППУ Договор приема платежей по услуге'', ''DPBPU'', ''ДПБПУ Договор приема безналичных платежей по услуге'') AGR_TYPE'
     		+ ', O.NAME AGENT'
     		+ ', A.OPEN_TIME'
	+ ' FROM KP.AGRS a'
   		+ ', KP.SERVICES s'
   		+ ', KP.ORGS o'
	+ ' WHERE A.SERVICE_ID = S.ID'
        	+ ' AND A.AGR_TYPE IN (''DPPU'', ''DPBPU'')'
		+ ' AND A.OWNER_ID = O.SUBJ_ID'
		+ ' AND A.IS_LOCK  = ''no'''
		+ ' AND A.IS_CLOSE = ''no'''
		+ ' AND S.NUM      = ' + mdManualService.FieldByName('NUM').AsString
	+ ' ORDER BY O.NAME';
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualService).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (договоры)
procedure TfrmManualService.CopyToMemoryDataDogovory;
var
	record_count: integer;
begin
	GridDogovory.DataSource.DataSet.DisableControls;

   	mdDogovory.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdDogovory.Append;
                mdDogovory.FieldByName('ID').AsInteger         := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdDogovory.FieldByName('AGR_TYPE').AsString    := DataMod.OracleDataSet.FieldByName('AGR_TYPE').AsString;
                mdDogovory.FieldByName('AGENT').AsString       := DataMod.OracleDataSet.FieldByName('AGENT').AsString;
                mdDogovory.FieldByName('OPEN_TIME').AsDateTime := DataMod.OracleDataSet.FieldByName('OPEN_TIME').AsDateTime;
                mdDogovory.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdDogovory.First;
        GridDogovory.Columns[0].Footer.Value := IntToStr(record_count);
        GridDogovory.DataSource.DataSet.EnableControls;

        btnDogovory.Enabled := false;
end;

procedure TfrmManualService.pnlFilterResize(Sender: TObject);
begin
	cbType.Width    := pnlFilter.Width - 20;
	edService.Width := pnlFilter.Width - 20;
end;

procedure TfrmManualService.GridManualServiceSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualService = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualService.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualService.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualService.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualService.SortOnFields(fields, false, desc);
end;

procedure TfrmManualService.GridDogovorySortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridDogovory = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridDogovory.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridDogovory.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridDogovory.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdDogovory.SortOnFields(fields, false, desc);
end;

procedure TfrmManualService.cbTypeChange(Sender: TObject);
begin
	if (fStartQuery = true) then
     		RunQuery;
end;

procedure TfrmManualService.btnDogovoryClick(Sender: TObject);
begin
	//MsgBox('Dogovory');
	Screen.Cursor := crHourGlass;

        if (QueryFromOracleDogovory) then
        begin
	        CopyToMemoryDataDogovory;
                GridDogovory.Visible         := true;
        	RxSplitterHorizontal.Visible := true;
        end;

        Screen.Cursor := crDefault;
end;

procedure TfrmManualService.mdManualServiceAfterScroll(DataSet: TDataSet);
begin
        GridDogovory.Visible         := false;
        RxSplitterHorizontal.Visible := false;

        btnDogovory.Enabled := true;
end;

procedure TfrmManualService.GridManualServiceGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdManualService.FieldByName('IS_CLOSE').AsString = 'yes') then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmManualService.edServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edService.Text) > 2) then
                	RunQuery;
end;

end.
