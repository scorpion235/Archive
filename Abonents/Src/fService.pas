//Справочник услуг
unit fService;

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
  TfrmService = class(TForm)
    pnlFilter: TPanel;
    SplitterVertical: TRxSplitter;
    pnlFilterTop: TPanel;
    mdService: TRxMemoryData;
    dsService: TDataSource;
    mdServiceNUM: TIntegerField;
    mdServiceSERVISE_ID: TIntegerField;
    mdServiceVISIBLE: TSmallintField;
    mdServiceNAME: TStringField;
    mdServiceTYPE: TStringField;
    lblType: TLabel;
    cbType: TDBComboBoxEh;
    lblService: TLabel;
    edService: TDBEditEh;
    pnlGrid: TPanel;
    GridService: TDBGridEh;
    mdSubSrv: TRxMemoryData;
    dsSubSrv: TDataSource;
    mdSubSrvSUBSRV_ID: TIntegerField;
    mdSubSrvSUB_SRV_PU: TStringField;
    mdSubSrvNAME: TStringField;
    cbVisibleSubSrv: TCheckBox;
    mdServiceIS_EDIT: TSmallintField;
    pmService: TPopupMenu;
    pmServiceAdd: TMenuItem;
    pmServiceEdit: TMenuItem;
    pmServiceDelete: TMenuItem;
    N1: TMenuItem;
    pmServiceRefresh: TMenuItem;
    pnlSubSrv: TPanel;
    GridSubSrv: TDBGridEh;
    SplitterHorizontal: TRxSplitter;
    pnlSubSrvControl: TPanel;
    DockSubSrv: TDock97;
    SubSrvToolbar: TToolbar97;
    btnRefresh: TToolbarButton97;
    btnAdd: TToolbarButton97;
    btnEdit: TToolbarButton97;
    btnDelete: TToolbarButton97;
    ImageList: TImageList;
    SubSrvActions: TActionList;
    AcAddSubSrv: TAction;
    AcEditSubSrv: TAction;
    AcDeleteSubSrv: TAction;
    AcRefreshSubSrv: TAction;
    pmSubSrv: TPopupMenu;
    pmSubSrvAdd: TMenuItem;
    pmSubSrvEdit: TMenuItem;
    pmSubSrvDelete: TMenuItem;
    N2: TMenuItem;
    pmSubSrvRefresh: TMenuItem;
    mdSubSrvSERVICE_ID: TIntegerField;
    PrintGrid: TPrintDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcFilterPanelExecute(Sender: TObject);
    procedure AcAddExecute(Sender: TObject);
    procedure AcEditExecute(Sender: TObject);
    procedure AcDeleteExecute(Sender: TObject);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridServiceSortMarkingChanged(Sender: TObject);
    procedure mdServiceAfterScroll(DataSet: TDataSet);
    procedure cbVisibleSubSrvClick(Sender: TObject);
    procedure GridSubSrvSortMarkingChanged(Sender: TObject);
    procedure GridServiceGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure AcAddSubSrvExecute(Sender: TObject);
    procedure AcEditSubSrvExecute(Sender: TObject);
    procedure AcDeleteSubSrvExecute(Sender: TObject);
    procedure AcRefreshSubSrvExecute(Sender: TObject);
    procedure mdSubSrvAfterScroll(DataSet: TDataSet);
    procedure cbTypeChange(Sender: TObject);
    procedure GridServiceCellClick(Column: TColumnEh);
  private
    fChildInfo: PChildInfo;
    fGetServiceList: boolean;
    fGetSubSrvList: boolean;
    procedure SetTypeList(cb: TDBComboBoxEh);
    procedure SetEnableServiceEditor;
    procedure SetEnableSubSrvEditor;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GetServiceList;
    procedure GetSubSrvList;
    //запрос в Оракл (услуги)
    function QueryFromOracleService: boolean;
    //копирование данных во временную таблицу (услуги)
    procedure CopyToMemoryDataService;
    //запрос в Оракл (подуслуги)
    function QueryFromOracleSubSrv: boolean;
    //копирование данных во временную таблицу (подуслуги)
    procedure CopyToMemoryDataSubSrv;
  public
    //выводим содержимое сетки на принтер
    procedure Print;
  end;

var
  frmService: TfrmService;

implementation

uses
	dmAbonents,
        fServiceEd,
        fSubSrvEd,
        uCommon;

{$R *.dfm}

procedure TfrmService.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
        fChildInfo.Actions[childFilterPanel] := AcFilterPanelExecute;
        fChildInfo.Actions[childAdd]         := AcAddExecute;
        fChildInfo.Actions[childEdit]        := AcEditExecute;
        fChildInfo.Actions[childDelete]      := AcDeleteExecute;
	fChildInfo.Actions[childRefresh]     := AcRefreshExecute;
        fChildInfo.abAdd     := true;
        fChildInfo.abRefresh := true;

        mdService.Active := true;
        mdSubSrv.Active  := true;
        fGetServiceList  := false;

        SetTypeList(cbType);
        LoadFromIni;

        pnlFilter.Visible        := fChildInfo.abFilterPanelOn;
	SplitterVertical.Visible := fChildInfo.abFilterPanelOn;

        //TODO: процедура "cbVisibleSubSrvClick" не срабатыевает при загрузке формы
        pnlSubSrv.Visible          := cbVisibleSubSrv.Checked;
        SplitterHorizontal.Visible := cbVisibleSubSrv.Checked;

        fGetServiceList := true;
end;

procedure TfrmService.FormShow(Sender: TObject);
begin
	GetServiceList;
end;

procedure TfrmService.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdService.Active := false;
        mdSubSrv.Active  := false;
	Action := caFree;
end;

//задание списка типов услуг
procedure TfrmService.SetTypeList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT NAME'
	+ ' FROM SERV_TYPES'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка типов услуг.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все типы]');
        cb.KeyItems.Add('[Все типы]');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//доступности манипулировать данными таблицы услуг
procedure TfrmService.SetEnableServiceEditor;
begin
	//редактирование и удаление недоступно
	if (mdService.FieldByName('IS_EDIT').AsInteger = 0) then
        begin
        	fChildInfo.abEdit   := false;
	        fChildInfo.abDelete := false;
        end

        //редактирование доступно
        //удаление доступно, если нет подуслуг
        else
        begin
        	fChildInfo.abEdit   := true;
	        fChildInfo.abDelete := mdSubSrv.IsEmpty;
        end;
end;

//доступности манипулировать данными таблицы подуслуг
procedure TfrmService.SetEnableSubSrvEditor;
begin
	btnAdd.Enabled          := not mdService.IsEmpty and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        btnEdit.Enabled         := not mdSubSrv.IsEmpty  and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        btnDelete.Enabled       := not mdSubSrv.IsEmpty  and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        btnRefresh.Enabled      := not mdService.IsEmpty and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');

        pmSubSrvAdd.Enabled     := not mdService.IsEmpty and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        pmSubSrvEdit.Enabled    := not mdSubSrv.IsEmpty  and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        pmSubSrvDelete.Enabled  := not mdSubSrv.IsEmpty  and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
        pmSubSrvRefresh.Enabled := not mdService.IsEmpty and (mdService.FieldByName('TYPE').AsString = 'Основная услуга');
end;

//получение списка услуг
procedure TfrmService.GetServiceList;
begin
	//MsgBox('GetServiceList');

        //запрещаем вызов GetSubSrvList при формировании списка услуг
        fGetSubSrvList := false;

        if (QueryFromOracleService) then
	        CopyToMemoryDataService;

        fGetSubSrvList := true;
        GetSubSrvList;

        SetEnableServiceEditor
end;

//получение списка подуслуг
procedure TfrmService.GetSubSrvList;
begin
    	//MsgBox('GetSubSrvList');

        if (QueryFromOracleSubSrv) then
	        CopyToMemoryDataSubSrv;

        SetEnableSubSrvEditor;
end;

//------------------------------------------------------------------------------
//запрос в Оракл (услуги)
function TfrmService.QueryFromOracleService: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT S.SERVICE_ID'
     		+ ', S.NUM'
     		+ ', S.NAME'
                + ', S.VISIBLE'
                + ', S.IS_EDIT'
     		+ ', T.NAME AS "TYPE"'
	+ ' FROM SERVICES S'
   		+ ', SERV_TYPES T'
	+ ' WHERE S."TYPE" = T."TYPE"');

        //выбран тип
        if (cbType.ItemIndex <> 0) then
	        DataMod.IB_Cursor.SQL.Add(' AND T.NAME = ''' + cbType.Text + '''');

	//указан шаблон названия услуги
        if (edService.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edService.Text + '%'')');

	DataMod.IB_Cursor.SQL.Add(' ORDER BY SERVICE_ID');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении таблицы услуг.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (услуги)
procedure TfrmService.CopyToMemoryDataService;
var
	i, record_count: integer;
begin
	GridService.DataSource.DataSet.DisableControls;

   	mdService.EmptyTable;
        record_count := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdService.Append;
                mdService.FieldByName('SERVICE_ID').AsInteger := DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsInteger;
                mdService.FieldByName('NUM').AsInteger        := DataMod.IB_Cursor.FieldByName('NUM').AsInteger;
                mdService.FieldByName('NAME').AsString        := DataMod.IB_Cursor.FieldByName('NAME').AsString;
                mdService.FieldByName('VISIBLE').AsInteger    := DataMod.IB_Cursor.FieldByName('VISIBLE').AsInteger;
                mdService.FieldByName('IS_EDIT').AsInteger    := DataMod.IB_Cursor.FieldByName('IS_EDIT').AsInteger;
                mdService.FieldByName('TYPE').AsString        := DataMod.IB_Cursor.FieldByName('TYPE').AsString;
                mdService.Post;
                DataMod.IB_Cursor.Next;
                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;
        mdService.First;

        for i := 0 to GridService.Columns.Count - 1 do
        begin
                if (GridService.Columns.Items[i].FieldName = 'VISIBLE') then
                	GridService.Columns[i].Footer.Value := IntToStr(record_count);
        end;

        GridService.DataSource.DataSet.EnableControls;
end;

//запрос в Оракл (подуслуги)
function TfrmService.QueryFromOracleSubSrv: boolean;
var
	i: word;
begin
	result := false;

        //список услуг пуст
        if (mdService.IsEmpty) then
        begin
        	mdService.EmptyTable;

                for i := 0 to GridSubSrv.Columns.Count - 1 do
        	begin
                	if (GridSubSrv.Columns.Items[i].FieldName = 'SUBSRV_ID') then
                		GridSubSrv.Columns[i].Footer.Value := '0';
        	end;

        	exit;
        end;

        DataMod.IB_Cursor.SQL.Text := 'SELECT SUBSRV_ID'
        	+ ', SERVICE_ID'
        	+ ', SUB_SRV_PU'
                + ', NAME'
        + ' FROM SUBSRV'
        + ' WHERE SERVICE_ID = ' + mdService.FieldByName('SERVICE_ID').AsString
        + ' ORDER BY SUBSRV_ID';
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении таблицы подуслуг.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (подуслуги)
procedure TfrmService.CopyToMemoryDataSubSrv;
var
	i, record_count: integer;
begin
	GridSubSrv.DataSource.DataSet.DisableControls;

   	mdSubSrv.EmptyTable;
        record_count := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdSubSrv.Append;
                mdSubSrv.FieldByName('SUBSRV_ID').AsInteger  := DataMod.IB_Cursor.FieldByName('SUBSRV_ID').AsInteger;
                mdSubSrv.FieldByName('SERVICE_ID').AsInteger := DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsInteger;
                mdSubSrv.FieldByName('SUB_SRV_PU').AsString  := DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString;
                mdSubSrv.FieldByName('NAME').AsString        := DataMod.IB_Cursor.FieldByName('NAME').AsString;
                mdSubSrv.Post;
                DataMod.IB_Cursor.Next;
                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;
        mdSubSrv.First;

        for i := 0 to GridSubSrv.Columns.Count - 1 do
                if (GridSubSrv.Columns.Items[i].FieldName = 'SUBSRV_ID') then
                        GridSubSrv.Columns[i].Footer.Value := IntToStr(record_count);

        GridSubSrv.DataSource.DataSet.EnableControls;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmService.LoadFromIni;
var
	sect: string;
begin
	sect := 'Service';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);
        pnlSubSrv.Height           := OptionsIni.ReadInteger(sect, 'pnlSubSrvHeight', 200);

        cbType.Text                := OptionsIni.ReadString(sect, 'Type', '[Все типы]');
        if (cbType.Text = '') then
         	cbType.ItemIndex := 0;

        edService.Text             := OptionsIni.ReadString(sect, 'Service', '');
        cbVisibleSubSrv.Checked    := OptionsIni.ReadBool(sect, 'VisibleSubSrv', false);
end;

//сохранение параметров в ini-файл
procedure TfrmService.SaveToIni;
var
	sect: string;
begin
	sect := 'Service';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteInteger(sect, 'pnlSubSrvHeight', pnlSubSrv.Height);
        OptionsIni.WriteString(sect, 'Type', cbType.Text);
        OptionsIni.WriteString(sect, 'Service', edService.Text);
        OptionsIni.WriteBool(sect, 'VisibleSubSrv', cbVisibleSubSrv.Checked);
end;

//панель фильтрации
procedure TfrmService.AcFilterPanelExecute(Sender: TObject);
begin
        fChildInfo.abFilterPanelOn := not fChildInfo.abFilterPanelOn;
	SplitterVertical.Visible   := fChildInfo.abFilterPanelOn;
	pnlFilter.Visible 	   := fChildInfo.abFilterPanelOn;
end;

//------------------------------------------------------------------------------
//
//	Управление записями (услуги)
//
//------------------------------------------------------------------------------

//добавить запись
procedure TfrmService.AcAddExecute(Sender: TObject);
var
	i: word;
	ServiceEd: TfrmServiceEd;
begin
	ServiceEd := TfrmServiceEd.Create(Application);
	if ServiceEd = nil then
		exit;

	fGetSubSrvList := false;

	ServiceEd.AddService(dsService);
	ServiceEd.Free;

        fGetSubSrvList := true;

        for i := 0 to GridService.Columns.Count - 1 do
                if (GridService.Columns.Items[i].FieldName = 'VISIBLE') then
                 	GridService.Columns[i].Footer.Value := IntToStr(mdService.RecordCount);

        //после добавления новой услуги необходимо открыть доступ на редактирование и удаление
        //и заново сформировать список подуслуг
        fChildInfo.abEdit   := true;
        fChildInfo.abDelete := true;
        GetSubSrvList;
end;

//редактировать запись
procedure TfrmService.AcEditExecute(Sender: TObject);
var
	ServiceEd: TfrmServiceEd;
begin
	//редактирование недоступно
	if ((mdService.IsEmpty) or (mdService.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	ServiceEd := TfrmServiceEd.Create(Application);
	if ServiceEd = nil then
		exit;

	ServiceEd.EditService(dsService);
	ServiceEd.Free;

        //если изменен тип услуги
        SetEnableSubSrvEditor;
end;

//удалить запись
procedure TfrmService.AcDeleteExecute(Sender: TObject);
var
	i: word;
begin
        //удаление недоступно
	if ((mdService.IsEmpty) or (mdService.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	//диалог подтверждения удаления
        if (YesNoBox(format('Удалить услугу "%s" (номер %d)?', [mdService.FieldByName('NAME').AsString, mdService.FieldByName('NUM').AsInteger])) = IDYES) then
	begin
          	//удаление
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM SERVICES WHERE SERVICE_ID = ' + mdService.FieldByName('SERVICE_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	ErrorBox('Не удалось удалить запись таблицы.' + #13 +
                	'Возможно, выбранная услуга используется в других таблицах.' + #13 +
                        'Если у выбранной услуги существует подуслуги, то удалите все подуслуги.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdService.Delete;
        	for i := 0 to GridService.Columns.Count - 1 do
                	if (GridService.Columns.Items[i].FieldName = 'VISIBLE') then
                 		GridService.Columns[i].Footer.Value := IntToStr(mdService.RecordCount);
        end;
end;

//обновить данные
procedure TfrmService.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
	//SetTypeList(cbType);
        //LoadFromIni;

        for i := 0 to GridService.Columns.Count - 1 do
        	GridService.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridSubSrv.Columns.Count - 1 do
        	GridSubSrv.Columns[i].Title.SortMarker := smNoneEh;
                
	GetServiceList;
end;

//------------------------------------------------------------------------------
//
//	Управление записями (подуслуги)
//
//------------------------------------------------------------------------------

//добавить запись
procedure TfrmService.AcAddSubSrvExecute(Sender: TObject);
var
	i: word;
	SubSrvEd: TfrmSubSrvEd;
begin
	//добавление недоступно
	if (mdService.IsEmpty) then
        	exit;

	SubSrvEd := TfrmSubSrvEd.Create(Application);
	if SubSrvEd = nil then
		exit;

	SubSrvEd.AddSubSrv(dsSubSrv, mdService.FieldByName('SERVICE_ID').AsInteger);
	SubSrvEd.Free;

        //после добавления первой подуслуги необходимо закрыть доступ
        //на удаление услуги
        SetEnableServiceEditor;
        SetEnableSubSrvEditor;

        for i := 0 to GridSubSrv.Columns.Count - 1 do
                if (GridSubSrv.Columns.Items[i].FieldName = 'SUBSRV_ID') then
                	GridSubSrv.Columns[i].Footer.Value := IntToStr(mdSubSrv.RecordCount);
end;

//редактировать запись
procedure TfrmService.AcEditSubSrvExecute(Sender: TObject);
var
	SubSrvEd: TfrmSubSrvEd;
begin
	//редактирование недоступно
	if (mdSubSrv.IsEmpty) then
        	exit;

	SubSrvEd := TfrmSubSrvEd.Create(Application);
	if SubSrvEd = nil then
		exit;

	SubSrvEd.EditSubSrv(dsSubSrv, mdService.FieldByName('SERVICE_ID').AsInteger);
	SubSrvEd.Free;
end;

//удалить запись
procedure TfrmService.AcDeleteSubSrvExecute(Sender: TObject);
var
	i: word;
begin
	//удаление недоступно
	if (mdSubSrv.IsEmpty) then
        	exit;

	//диалог подтверждения удаления
        if (YesNoBox(format('Удалить подуслугу "%s" (номер %s)?', [mdSubSrv.FieldByName('NAME').AsString, mdSubSrv.FieldByName('SUB_SRV_PU').AsString])) = IDYES) then
	begin
          	//удаление
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM SUBSRV WHERE SUBSRV_ID = ' + mdSubSrv.FieldByName('SUBSRV_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	ErrorBox('Не удалось удалить запись таблицы.' + #13 +
                	'Возможно, выбранная подуслуга используется в других таблицах.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdSubSrv.Delete;
                //после удаления последней подуслуги необходимо открыть доступ
        	//на удаление услуги
                SetEnableServiceEditor;

                for i := 0 to GridSubSrv.Columns.Count - 1 do
                	if (GridSubSrv.Columns.Items[i].FieldName = 'SUBSRV_ID') then
                		GridSubSrv.Columns[i].Footer.Value := IntToStr(mdSubSrv.RecordCount);
        end;
end;

//обновить данные
procedure TfrmService.AcRefreshSubSrvExecute(Sender: TObject);
var
	i: word;
begin
	//обновление недоступно
	if (mdService.IsEmpty) then
        	exit;

        for i := 0 to GridSubSrv.Columns.Count - 1 do
        	GridSubSrv.Columns[i].Title.SortMarker := smNoneEh;

	GetSubSrvList;
end;

//------------------------------------------------------------------------------
procedure TfrmService.pnlFilterResize(Sender: TObject);
begin
	cbType.Width    := pnlFilter.Width - 20;
	edService.Width := pnlFilter.Width - 20;
end;

procedure TfrmService.GridServiceSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridService = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridService.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridService.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridService.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdService.SortOnFields(fields, false, desc);
end;

procedure TfrmService.GridSubSrvSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridSubSrv = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridSubSrv.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridSubSrv.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridSubSrv.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdSubSrv.SortOnFields(fields, false, desc);
end;

procedure TfrmService.mdServiceAfterScroll(DataSet: TDataSet);
var
	i: word;
begin
	if (not fGetSubSrvList) then
        	exit;

        for i := 0 to GridSubSrv.Columns.Count - 1 do
        	GridSubSrv.Columns[i].Title.SortMarker := smNoneEh;

        GetSubSrvList;

        SetEnableServiceEditor;
end;

procedure TfrmService.mdSubSrvAfterScroll(DataSet: TDataSet);
begin
	SetEnableSubSrvEditor;
end;

procedure TfrmService.cbVisibleSubSrvClick(Sender: TObject);
begin
        pnlSubSrv.Visible          := cbVisibleSubSrv.Checked;
        SplitterHorizontal.Visible := cbVisibleSubSrv.Checked;
end;

procedure TfrmService.GridServiceGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (mdService.FieldByName('IS_EDIT').AsInteger = 0) then
		Background := $00FFDDDD
        else if (mdService.FieldByName('IS_EDIT').AsInteger = 1) then
		Background := $00FFC4C4;
end;

procedure TfrmService.cbTypeChange(Sender: TObject);
begin
	if (fGetServiceList) then
   		GetServiceList;
end;

//TODO: пока нет возможность активировать услугу для отображения с клавиатуры
procedure TfrmService.GridServiceCellClick(Column: TColumnEh);
var
	visible: word;
begin
	if (Column.FieldName <> 'VISIBLE') then
        	exit;

        visible := 1 - mdService.FieldByName('VISIBLE').AsInteger;
	DataMod.IB_Cursor.SQL.Text := 'UPDATE SERVICES SET VISIBLE = ' + IntToStr(visible)
        + ' WHERE SERVICE_ID = ' + mdService.FieldByName('SERVICE_ID').AsString;
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при редактировании таблицы услуг.');
                exit;
	end;

        DataMod.IB_Cursor.Close;
        DataMod.IB_Transaction.Commit;
end;

//выводим содержимое сетки на принтер
procedure TfrmService.Print;
begin
	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := 'Услуги';
		PrintGrid.Preview;
	end;
end;

end.
