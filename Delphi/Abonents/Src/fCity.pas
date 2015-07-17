//Справочник городов
unit fCity;

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
  TfrmCity = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    mdCity: TRxMemoryData;
    dsCity: TDataSource;
    lblCity: TLabel;
    edCity: TDBEditEh;
    pnlGrid: TPanel;
    GridCity: TDBGridEh;
    pmCity: TPopupMenu;
    pmCityAdd: TMenuItem;
    pmCityEdit: TMenuItem;
    pmCityDelete: TMenuItem;
    N1: TMenuItem;
    RxSplitter2: TRxSplitter;
    mdCityCITY_ID: TIntegerField;
    mdCityNAME: TStringField;
    mdCityIS_EDIT: TSmallintField;
    pmCityRefresh: TMenuItem;
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
    procedure GridCitySortMarkingChanged(Sender: TObject);
    procedure mdCityAfterScroll(DataSet: TDataSet);
    procedure GridCityGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure edCityChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    fGetCityList: boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GetCityList;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    //выводим содержимое сетки на принтер
    procedure Print;
  end;

var
  frmCity: TfrmCity;

implementation

uses
	dmAbonents,
        fCityEd,
        uCommon;

{$R *.dfm}

procedure TfrmCity.FormCreate(Sender: TObject);
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

        mdCity.Active := true;
        fGetCityList  := false;

        LoadFromIni;

        pnlFilter.Visible   := fChildInfo.abFilterPanelOn;
	RxSplitter.Visible := fChildInfo.abFilterPanelOn;

        fGetCityList := true;
end;

procedure TfrmCity.FormShow(Sender: TObject);
begin
	GetCityList;
end;

procedure TfrmCity.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdCity.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmCity.LoadFromIni;
var
	sect: string;
begin
	sect := 'City';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);
        edCity.Text                := OptionsIni.ReadString(sect, 'City', '');
end;

//сохранение параметров в ini-файл
procedure TfrmCity.SaveToIni;
var
	sect: string;
begin
	sect := 'City';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'City', edCity.Text);
end;

//панель фильтрации
procedure TfrmCity.AcFilterPanelExecute(Sender: TObject);
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

//добавить запись
procedure TfrmCity.AcAddExecute(Sender: TObject);
var
	i: word;
	CityEd: TfrmCityEd;
begin
	CityEd := TfrmCityEd.Create(Application);
	if CityEd = nil then
		exit;

	CityEd.AddCity(dsCity);
	CityEd.Free;

        for i := 0 to GridCity.Columns.Count - 1 do
                if (GridCity.Columns.Items[i].FieldName = 'IS_EDIT') then
                 	GridCity.Columns[i].Footer.Value := IntToStr(mdCity.RecordCount);

        //после добавления нового города необходимо
        //открыть доступ на редактирование и удаление
        fChildInfo.abEdit   := true;
        fChildInfo.abDelete := true;
end;

//редактировать запись
procedure TfrmCity.AcEditExecute(Sender: TObject);
var
	CityEd: TfrmCityEd;
begin
	//редактирование недоступно
	if ((mdCity.IsEmpty) or (mdCity.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	CityEd := TfrmCityEd.Create(Application);
	if CityEd = nil then
		exit;

	CityEd.EditCity(dsCity);
	CityEd.Free;
end;

//удалить запись
procedure TfrmCity.AcDeleteExecute(Sender: TObject);
var
	i: word;
begin
        //удаление недоступно
	if ((mdCity.IsEmpty) or (mdCity.FieldByName('IS_EDIT').AsInteger = 0)) then
        	exit;

	//диалог подтверждения удаления
        if (YesNoBox(format('Удалить город "%s" (ID #%d)?', [mdCity.FieldByName('NAME').AsString, mdCity.FieldByName('CITY_ID').AsInteger])) = IDYES) then
	begin
          	//удаление
        	DataMod.IB_Cursor.SQL.Text := 'DELETE FROM CITY_LIST WHERE CITY_ID = ' + mdCity.FieldByName('CITY_ID').AsString;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
        	try
	        	DataMod.IB_Cursor.Open;
        	except
                        ErrorBox('Не удалось удалить запись таблицы.' + #13 +
                	'Возможно, выбранный город используется в других таблицах.' + #13 +
                        'Если у выбранного города существует улицы, то удалите все улицы.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
	        DataMod.IB_Transaction.Commit;

                mdCity.Delete;

        	for i := 0 to GridCity.Columns.Count - 1 do
                	if (GridCity.Columns.Items[i].FieldName = 'IS_EDIT') then
                 		GridCity.Columns[i].Footer.Value := IntToStr(mdCity.RecordCount);
        end;
end;

//обновить данные
procedure TfrmCity.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        //LoadFromIni;

        for i := 0 to GridCity.Columns.Count - 1 do
        	GridCity.Columns[i].Title.SortMarker := smNoneEh;

	GetCityList;
end;

//------------------------------------------------------------------------------
//получение списка городов
procedure TfrmCity.GetCityList;
begin
	//MsgBox('GetCityList');
        if (QueryFromOracle) then
	        CopyToMemoryData;
end;

//запрос в Оракл
function TfrmCity.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT CITY_ID'
     		+ ', NAME'
     		+ ', IS_EDIT'
	+ ' FROM CITY_LIST');

	//указан шаблон названия города
        if (edCity.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' WHERE UPPER(NAME) LIKE UPPER(''%' + edCity.Text + '%'')');

	DataMod.IB_Cursor.SQL.Add(' ORDER BY CITY_ID');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении таблицы городов.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmCity.CopyToMemoryData;
var
	i, record_count: integer;
begin
	GridCity.DataSource.DataSet.DisableControls;

   	mdCity.EmptyTable;
        record_count := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdCity.Append;
                mdCity.FieldByName('CITY_ID').AsInteger := DataMod.IB_Cursor.FieldByName('CITY_ID').AsInteger;
                mdCity.FieldByName('NAME').AsString     := DataMod.IB_Cursor.FieldByName('NAME').AsString;
                mdCity.FieldByName('IS_EDIT').AsInteger := DataMod.IB_Cursor.FieldByName('IS_EDIT').AsInteger;
                mdCity.Post;
                DataMod.IB_Cursor.Next;
                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;
        mdCity.First;

        for i := 0 to GridCity.Columns.Count - 1 do
                if (GridCity.Columns.Items[i].FieldName = 'IS_EDIT') then
                 	GridCity.Columns[i].Footer.Value := IntToStr(record_count);

        GridCity.DataSource.DataSet.EnableControls;
end;

procedure TfrmCity.pnlFilterResize(Sender: TObject);
begin
	edCity.Width := pnlFilter.Width - 20;
end;

procedure TfrmCity.GridCitySortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridCity = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridCity.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridCity.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridCity.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdCity.SortOnFields(fields, false, desc);
end;

procedure TfrmCity.mdCityAfterScroll(DataSet: TDataSet);
begin
	//редактирование не доступно
	if (mdCity.FieldByName('IS_EDIT').AsInteger = 0) then
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

procedure TfrmCity.GridCityGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (mdCity.FieldByName('IS_EDIT').AsInteger = 0) then
		Background := $00FFDDDD
        else if (mdCity.FieldByName('IS_EDIT').AsInteger = 1) then
		Background := $00FFC4C4;
end;

procedure TfrmCity.edCityChange(Sender: TObject);
begin
	if (fGetCityList) then
   		GetCityList;
end;

//выводим содержимое сетки на принтер
procedure TfrmCity.Print;
begin
	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := 'Города';
		PrintGrid.Preview;
	end;
end;

end.
