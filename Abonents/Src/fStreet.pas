//—правочник улиц
unit fStreet;

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
  TfrmStreet = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    mdStreet: TRxMemoryData;
    dsStreet: TDataSource;
    lblStreet: TLabel;
    edStreet: TDBEditEh;
    pnlGrid: TPanel;
    GridStreet: TDBGridEh;
    pmStreet: TPopupMenu;
    pmStreetAdd: TMenuItem;
    pmStreetEdit: TMenuItem;
    pmStreetDelete: TMenuItem;
    N1: TMenuItem;
    RxSplitter2: TRxSplitter;
    pmStreetRefresh: TMenuItem;
    mdStreetSTREET: TStringField;
    mdStreetCITY: TStringField;
    mdStreetIS_EDIT: TSmallintField;
    mdStreetSTREET_ID: TIntegerField;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
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
    procedure GridStreetSortMarkingChanged(Sender: TObject);
    procedure mdStreetAfterScroll(DataSet: TDataSet);
    procedure GridStreetGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure cbCityChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    fGetStreetList: boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure GetStreetList;
    //запрос в ќракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    //выводим содержимое сетки на принтер
    procedure Print;
  end;

var
  frmStreet: TfrmStreet;

implementation

uses
	dmAbonents,
        fMain,
        fStreetEd,
        uCommon;

{$R *.dfm}

procedure TfrmStreet.FormCreate(Sender: TObject);
begin
	//cтруктуру дл€ обслуживани€ из главной формы
	NewChildInfo(fChildInfo, self);
        fChildInfo.Actions[childFilterPanel] := AcFilterPanelExecute;
        fChildInfo.Actions[childAdd]         := AcAddExecute;
        fChildInfo.Actions[childEdit]        := AcEditExecute;
        fChildInfo.Actions[childDelete]      := AcDeleteExecute;
	fChildInfo.Actions[childRefresh]     := AcRefreshExecute;
        fChildInfo.abAdd     := true;
        fChildInfo.abRefresh := true;

        mdStreet.Active := true;
        fGetStreetList  := false;

        SetCityList(cbCity);
        LoadFromIni;

        pnlFilter.Visible  := fChildInfo.abFilterPanelOn;
	RxSplitter.Visible := fChildInfo.abFilterPanelOn;

        fGetStreetList := true;
end;

procedure TfrmStreet.FormShow(Sender: TObject);
begin
	GetStreetList;
end;

procedure TfrmStreet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdStreet.Active := false;
	Action := caFree;
end;

//задание списка городов в комбобокс
procedure TfrmStreet.SetCityList(cb: TDBComboBoxEh);
begin
	DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Text := 'SELECT CITY_ID, NAME'
	+ ' FROM CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('ќшибка при заполнении списка городов.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[¬се города]');
        cb.KeyItems.Add('[¬се города]');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('CITY_ID').AsString);
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
procedure TfrmStreet.LoadFromIni;
var
	sect: string;
begin
	sect := 'Street';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);

        cbCity.Text                := OptionsIni.ReadString(sect, 'City', '[¬се города]');
        if (cbCity.Text = '') then
         	cbCity.ItemIndex := 0;

        edStreet.Text              := OptionsIni.ReadString(sect, 'Street', '');
end;

//сохранение параметров в ini-файл
procedure TfrmStreet.SaveToIni;
var
	sect: string;
begin
	sect := 'Street';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'City', cbCity.Text);
        OptionsIni.WriteString(sect, 'Street', edStreet.Text);
end;

//панель фильтрации
procedure TfrmStreet.AcFilterPanelExecute(Sender: TObject);
begin
        fChildInfo.abFilterPanelOn := not fChildInfo.abFilterPanelOn;
	RxSplitter.Visible   	   := fChildInfo.abFilterPanelOn;
	pnlFilter.Visible 	   := fChildInfo.abFilterPanelOn;
end;

//------------------------------------------------------------------------------
//
//	”правление запис€ми
//
//------------------------------------------------------------------------------

//добавить запись
procedure TfrmStreet.AcAddExecute(Sender: TObject);
var
	i:word;
	StreetEd: TfrmStreetEd;
begin
	StreetEd := TfrmStreetEd.Create(Application);
	if StreetEd = nil then
		exit;

	StreetEd.AddStreet(dsStreet);
	StreetEd.Free;

        for i := 0 to GridStreet.Columns.Count - 1 do
                if (GridStreet.Columns.Items[i].FieldName = 'IS_EDIT') then
                 	GridStreet.Columns[i].Footer.Value := IntToStr(mdStreet.RecordCount);
        
        //после добавлени€ новой улицы необходимо
        //открыть доступ на редактирование и удаление
        fChildInfo.abEdit   := true;
        fChildInfo.abDelete := true;
end;

//редактировать запись
procedure TfrmStreet.AcEditExecute(Sender: TObject);
var
	StreetEd: TfrmStreetEd;
begin
	//редактирование недоступно
	if ((mdStreet.IsEmpty) or (mdStreet.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	StreetEd := TfrmStreetEd.Create(Application);
	if StreetEd = nil then
		exit;

	StreetEd.EditStreet(dsStreet);
	StreetEd.Free;
end;

//удалить запись
procedure TfrmStreet.AcDeleteExecute(Sender: TObject);
var
	i: word;
begin
	//удаление недоступно
	if ((mdStreet.IsEmpty) or (mdStreet.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	//диалог подтверждени€ удалени€
        if (YesNoBox(format('”далить улицу "%s" (ID #%d)?', [mdStreet.FieldByName('STREET').AsString, mdStreet.FieldByName('STREET_ID').AsInteger])) = IDYES) then
	begin
          	//удаление
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM STREET_LIST WHERE STREET_ID = ' + mdStreet.FieldByName('STREET_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                	ErrorBox('Ќе удалось удалить запись таблицы.' + #13 +
                	'¬озможно, выбранна€ улица используетс€ в других таблицах.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdStreet.Delete;

                for i := 0 to GridStreet.Columns.Count - 1 do
                	if (GridStreet.Columns.Items[i].FieldName = 'IS_EDIT') then
                 		GridStreet.Columns[i].Footer.Value := IntToStr(mdStreet.RecordCount);
        end;
end;

//обновить данные
procedure TfrmStreet.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        //LoadFromIni;

        for i := 0 to GridStreet.Columns.Count - 1 do
        	GridStreet.Columns[i].Title.SortMarker := smNoneEh;

	GetStreetList;
end;

//------------------------------------------------------------------------------
//получение списка улиц
procedure TfrmStreet.GetStreetList;
begin
	//MsgBox('GetStreetList');
        if (QueryFromOracle) then
	        CopyToMemoryData;
end;

//запрос в ќракл
function TfrmStreet.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT S.STREET_ID'
        	+ ', S.CITY_ID'
     		+ ', C.NAME AS CITY'
                + ', S.NAME AS STREET'
                + ', S.IS_EDIT'
	+ ' FROM STREET_LIST S'
        	+ ', CITY_LIST C'
	+ ' WHERE S.CITY_ID = C.CITY_ID');

        //выбран город
        if (cbCity.ItemIndex <> 0) then
                DataMod.IB_Cursor.SQL.Add(' AND S.CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);

	//указан шаблон названи€ улицы
        if (edStreet.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edStreet.Text + '%'')');

	DataMod.IB_Cursor.SQL.Add(' ORDER BY S.STREET_ID');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('ќшибка при заполнении таблицы улиц.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmStreet.CopyToMemoryData;
var
	i, record_count,
        step: integer;
begin
	GridStreet.DataSource.DataSet.DisableControls;

   	mdStreet.EmptyTable;
        record_count := 0;
        step         := 1000;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdStreet.Append;
                mdStreet.FieldByName('STREET_ID').AsInteger := DataMod.IB_Cursor.FieldByName('STREET_ID').AsInteger;
                mdStreet.FieldByName('CITY').AsString       := DataMod.IB_Cursor.FieldByName('CITY').AsString;
                mdStreet.FieldByName('STREET').AsString     := DataMod.IB_Cursor.FieldByName('STREET').AsString;
                mdStreet.FieldByName('IS_EDIT').AsInteger   := DataMod.IB_Cursor.FieldByName('IS_EDIT').AsInteger;
                mdStreet.Post;
                DataMod.IB_Cursor.Next;

                if (record_count = step) then
                begin
                	frmMain.StatusBar.Panels[0].Text := format('«агружено: %d записей', [record_count]);
                        frmMain.StatusBar.Refresh;
                    	step := step + 1000;
                end;

                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;
        mdStreet.First;
        frmMain.StatusBar.Panels[0].Text   := '';

        for i := 0 to GridStreet.Columns.Count - 1 do
                if (GridStreet.Columns.Items[i].FieldName = 'IS_EDIT') then
                 	GridStreet.Columns[i].Footer.Value := IntToStr(record_count);
 
        GridStreet.DataSource.DataSet.EnableControls;
end;

procedure TfrmStreet.pnlFilterResize(Sender: TObject);
begin
	cbCity.Width   := pnlFilter.Width - 20;
	edStreet.Width := pnlFilter.Width - 20;
end;

procedure TfrmStreet.GridStreetSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridStreet = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridStreet.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridStreet.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridStreet.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdStreet.SortOnFields(fields, false, desc);
end;

procedure TfrmStreet.mdStreetAfterScroll(DataSet: TDataSet);
begin
	//редактирование не доступно
	if (mdStreet.FieldByName('IS_EDIT').AsInteger = 0) then
        begin
        	fChildInfo.abEdit   := false;
	        fChildInfo.abDelete := false;
        end

        //редактирование доступно
        else
        begin
        	fChildInfo.abEdit   := true;
	        fChildInfo.abDelete := true;
        end;
end;

procedure TfrmStreet.GridStreetGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (mdStreet.FieldByName('IS_EDIT').AsInteger = 0) then
		Background := $00FFDDDD
        else if (mdStreet.FieldByName('IS_EDIT').AsInteger = 1) then
		Background := $00FFC4C4;
end;

procedure TfrmStreet.cbCityChange(Sender: TObject);
begin
        if (fGetStreetList) then
   		GetStreetList;
end;

//выводим содержимое сетки на принтер
procedure TfrmStreet.Print;
begin
	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := '”лицы';
		PrintGrid.Preview;
	end;
end;

end.
