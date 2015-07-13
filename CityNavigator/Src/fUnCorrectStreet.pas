//Непривязанные улицы
unit fUnCorrectStreet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  ComCtrls, Buttons, LMDCustomButton, LMDButton, FR_Combo, ActnList,
  DBCtrls;

type
  TfrmUnCorrectStreet = class(TForm)
    mdUnCorrectStreet: TRxMemoryData;
    dsUnCorrectStreet: TDataSource;
    mdUnCorrectStreetORG: TStringField;
    mdUnCorrectStreetCITY: TStringField;
    mdUnCorrectStreetSTREET: TStringField;
    pcGreeds: TPageControl;
    tsUnCorrectStreet: TTabSheet;
    pnlFilterUnCorrectStreet: TPanel;
    lblOrg: TLabel;
    lblCity: TLabel;
    lblStreet: TLabel;
    edOrg: TDBEditEh;
    pnlFilterTop: TPanel;
    edCity: TDBEditEh;
    edStreet: TDBEditEh;
    RxSplitter: TRxSplitter;
    GridUnCorrectStreet: TDBGridEh;
    tsHandAttachedStreet: TTabSheet;
    pnlFilterHandAttachedStreet: TPanel;
    lblOrg2: TLabel;
    cbOrg: TDBComboBoxEh;
    lblCity2: TLabel;
    cbCity: TDBComboBoxEh;
    mdUnAttachedStreetHand: TRxMemoryData;
    dsUnAttachedStreetHand: TDataSource;
    mdStreetListHand: TRxMemoryData;
    dsStreetListHand: TDataSource;
    mdUnAttachedStreetHandID: TIntegerField;
    mdUnAttachedStreetHandSTREET: TStringField;
    mdStreetListHandID: TIntegerField;
    mdStreetListHandSTREET: TStringField;
    pnlGreedHand: TPanel;
    pnlStreetListHand: TPanel;
    GridStreetListHand: TDBGridEh;
    pnlStreetListFilter: TPanel;
    edStreetListFilter: TDBEditEh;
    pnlUnAttachedStreetHand: TPanel;
    pnlUnAttachedStreetFilter: TPanel;
    edUnAttachedStreetFilter: TDBEditEh;
    pnlSeparatorHand: TPanel;
    mdUnAttachedStreetHandCITY: TStringField;
    mdStreetListHandCITY: TStringField;
    mdUnAttachedStreetHandORG: TStringField;
    mdUnAttachedStreetHandCITY_ID: TIntegerField;
    btnAttachTop: TLMDButton;
    ActionList: TActionList;
    AcAttach: TAction;
    mdStreetListHandCITY_ID: TIntegerField;
    GridUnAttachedStreetHand: TDBGridEh;
    btnAttachBottom: TLMDButton;
    lblError: TLabel;
    mdStreetListHandFLAG: TWordField;
    tsAutoAttachedStreet: TTabSheet;
    pnlGreedAuto: TPanel;
    Panel2: TPanel;
    pnlStreetListAuto: TPanel;
    GridStreetListAuto: TDBGridEh;
    pnlUnAttachedStreetAuto: TPanel;
    GridUnAttachedStreetAuto: TDBGridEh;
    pnlSeparatorAuto: TPanel;
    mdUnAttachedStreetAuto: TRxMemoryData;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    dsUnAttachedStreetAuto: TDataSource;
    mdStreetListAuto: TRxMemoryData;
    IntegerField3: TIntegerField;
    StringField4: TStringField;
    StringField5: TStringField;
    dsStreetListAuto: TDataSource;
    btnStart: TLMDButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterUnCorrectStreetResize(Sender: TObject);
    procedure GridUnCorrectStreetSortMarkingChanged(Sender: TObject);
    procedure edOrgKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edCityKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStreetKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure cbOrgChange(Sender: TObject);
    procedure GridUnAttachedStreetHandSortMarkingChanged(Sender: TObject);
    procedure GridStreetListHandSortMarkingChanged(Sender: TObject);
    procedure pcGreedsChange(Sender: TObject);
    procedure edUnAttachedStreetFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edStreetListFilterKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbCityChange(Sender: TObject);
    procedure mdUnAttachedStreetHandAfterScroll(DataSet: TDataSet);
    procedure AcAttachExecute(Sender: TObject);
    procedure mdStreetListHandAfterScroll(DataSet: TDataSet);
    procedure GridStreetListHandGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure mdUnAttachedStreetHandBeforeScroll(DataSet: TDataSet);
    procedure btnStartClick(Sender: TObject);
  private
    //TODO: выделяется много памяти под указанные массивы
    org_id:  array[0..200] of integer;
    city_id: array[0..200] of integer;
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetOrgList(cb: TDBComboBoxEh);
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure SetControlPosition;

    //список непривязанных улиц (Список улиц)
    procedure GetUnCorrectStreet;
    //запрос в Оракл (Список улиц)
    function QueryFromOracleUnCorrectStreet: boolean;
    //копирование данных во временную таблицу (Список улиц)
    procedure CopyToMemoryDataUnCorrectStreet;

    //непривязанные улицы (Ручная привязка > Непривязанные улицы)
    procedure GetUnAttachedStreet;
    //запрос в Оракл (Ручная привязка > Непривязанные улицы)
    function QueryFromOracleUnAttachedStreet: boolean;
    //копирование данных во временную таблицу (Ручная привязка > Непривязанные улицы)
    procedure CopyToMemoryDataUnAttachedStreet;

    //список улиц (Ручная привязка > Список улиц)
    procedure GetStreetList;
    //запрос в Оракл (Ручная привязка > Список улиц)
    function QueryFromOracleStreetList: boolean;
    //копирование данных во временную таблицу (Ручная привязка > Список улиц)
    procedure CopyToMemoryDataStreetList;
  public
    fGetUnCorrectStreet : boolean;
    fGetUnAttachedStreet: boolean;
    fGetStreetList      : boolean;
    fColorMode          : boolean;
    fCity               : string;
  end;

var
  frmUnCorrectStreet: TfrmUnCorrectStreet;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmUnCorrectStreet.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        fCity := '';
        pcGreeds.ActivePageIndex      := 0;
        lblError.Visible              := false;
        mdUnCorrectStreet.Active      := true;
        mdUnAttachedStreetHand.Active := true;
        mdStreetListHand.Active       := true;
        mdUnAttachedStreetAuto.Active := true;
        mdStreetListAuto.Active       := true;

        fGetUnCorrectStreet := false;
        LoadFromIni;
        fGetUnCorrectStreet := true;
end;

procedure TfrmUnCorrectStreet.FormShow(Sender: TObject);
begin
	SetControlPosition;
	GetUnCorrectStreet;

        //проверка на наличие прав для привязки улиц
        DataMod.OracleDataSet.SQL.Text := 'SELECT ID FROM KP.V$UNATTACHED_STREETS_PU';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	lblError.Visible             := true;
        	pcGreeds.Pages[1].TabVisible := false;
                exit;
	end;

        DataMod.OracleDataSet.Close;
end;

procedure TfrmUnCorrectStreet.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdUnCorrectStreet.Active      := false;
        mdUnAttachedStreetHand.Active := false;
        mdStreetListHand.Active       := false;
        mdUnAttachedStreetAuto.Active := false;
        mdStreetListAuto.Active       := false;
	Action := caFree;
end;

//задание списка поставщиков в комбобокс
procedure TfrmUnCorrectStreet.SetOrgList(cb: TDBComboBoxEh);
var
	i: word;
begin
	for i := 0 to 200 do
        	org_id[i] := 0;

	DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(O.SUBJ_ID) AS ORG_ID, O.NAME'
	+ ' FROM KP.V$UNATTACHED_STREETS_PU u'
   		+ ', KP.STREET_PU s'
   		+ ', KP.ORGS o'
	+ ' WHERE U.ID = S.ID'
        	+ ' AND S.ORG_ID = O.SUBJ_ID'
	+ ' ORDER BY O.NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка при заполнении списка поставщиков.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все поставщики] (' + IntToStr(DataMod.OracleDataSet.RecordCount) + ')');
        cb.KeyItems.Add('[Все поставщики] (' + IntToStr(DataMod.OracleDataSet.RecordCount) + ')');

        //количество поставщиков > 200
        if (DataMod.OracleDataSet.RecordCount > 200) then
        begin
        	WarningBox('Количество поставщиков более 200.'  + #13 +
                'Поле фильтрации "Поставщик" будет недоступно.');
                cb.Enabled := false;
           	DataMod.OracleDataSet.Close;
                exit;
        end;

        i := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                org_id[i] := DataMod.OracleDataSet.FieldByName('ORG_ID').AsInteger;
                inc(i);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        cb.ItemIndex := 0;
end;

//задание списка городов в комбобокс
procedure TfrmUnCorrectStreet.SetCityList(cb: TDBComboBoxEh);
var
	i: word;
begin
	for i := 0 to 200 do
        	city_id[i] := 0;

        DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(C.ID) AS CITY_ID, C.NAME'
	+ ' FROM KP.V$UNATTACHED_STREETS_PU u'
   		+ ', KP.STREET_PU s'
   		+ ', KP.CITY_LIST c'
	+ ' WHERE U.ID = S.ID'
        	+ ' AND S.CITY_ID = C.ID'
	+ ' ORDER BY C.NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка при заполнении списка городов.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все города] (' + IntToStr(DataMod.OracleDataSet.RecordCount) + ')');
        cb.KeyItems.Add('[Все города] (' + IntToStr(DataMod.OracleDataSet.RecordCount) + ')');

        //количество городов > 200
        if (DataMod.OracleDataSet.RecordCount > 200) then
        begin
        	WarningBox('Количество городов более 200.'  + #13 +
                'Поле фильтрации "Город" будет недоступно.');
                cb.Enabled := false;
           	DataMod.OracleDataSet.Close;
                exit;
        end;

        i := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                city_id[i] := DataMod.OracleDataSet.FieldByName('CITY_ID').AsInteger;
                inc(i);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
        cb.ItemIndex := 0;
end;

//задание месторасположения компонент на форме (Ручная и автоматическая привязка улиц)
procedure TfrmUnCorrectStreet.SetControlPosition;
begin
        pnlUnattachedStreetHand.Width  := round(Width / 2) - 58;
        pnlUnattachedStreetAuto.Width  := round(Width / 2) - 58;

        cbOrg.Width                    := GridUnAttachedStreetHand.Width;
        cbCity.Width                   := GridStreetListHand.Width;

        edStreetListFilter.Width       := GridStreetListHand.Width;
        edUnAttachedStreetFilter.Width := GridUnAttachedStreetHand.Width;

        btnAttachBottom.Top            := pnlSeparatorHand.Height - 50;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmUnCorrectStreet.LoadFromIni;
var
	sect: String;
begin
	sect := 'UnCorrectStreet';
	pnlFilterUnCorrectStreet.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edOrg.Text      := OptionsIni.ReadString(sect, 'Org', '');
        edCity.Text     := OptionsIni.ReadString(sect, 'City', '');
        edStreet.Text   := OptionsIni.ReadString(sect, 'Street', '');

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmUnCorrectStreet.SaveToIni;
var
	sect: String;
begin
	sect := 'UnCorrectStreet';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilterUnCorrectStreet.Width);
        OptionsIni.WriteString(sect, 'Org', edOrg.Text);
        OptionsIni.WriteString(sect, 'City', edCity.Text);
        OptionsIni.WriteString(sect, 'Street', edStreet.Text);
end;

//------------------------------------------------------------------------------
//обновить
procedure TfrmUnCorrectStreet.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        //список улиц
	if (pcGreeds.ActivePageIndex = 0) then
        begin
        	//убираем отметку о сортировке по полю
                for i := 0 to GridUnCorrectStreet.Columns.Count - 1 do
        		GridUnCorrectStreet.Columns[i].Title.SortMarker := smNoneEh;

        	GetUnCorrectStreet;
        end

        //ручная привязка
        else
        if (pcGreeds.ActivePageIndex = 1) then
        begin
        	//отображаем все колонки
        	for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
                	if (GridUnAttachedStreetHand.Columns.Items[i].FieldName = 'CITY') then
                        	GridUnAttachedStreetHand.Columns.Items[i].Visible := true;

        	for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
                	if (GridUnAttachedStreetHand.Columns.Items[i].FieldName = 'ORG') then
                        	GridUnAttachedStreetHand.Columns.Items[i].Visible := true;

                //--------------------------------------------------------------
                //убираем отметку о сортировке по полю
                for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
        		GridUnAttachedStreetHand.Columns[i].Title.SortMarker := smNoneEh;

        	for i := 0 to GridStreetListHand.Columns.Count - 1 do
        		GridStreetListHand.Columns[i].Title.SortMarker := smNoneEh;

                fGetUnAttachedStreet := false;
    		fGetStreetList       := false;

        	SetOrgList(cbOrg);
        	SetCityList(cbCity);

        	fGetUnAttachedStreet := true;
		fGetStreetList       := true;

                GetUnAttachedStreet;

    		//таблица непривязанных улиц пуста
        	if (mdUnAttachedStreetHand.IsEmpty) then
        	begin
                	mdStreetListHand.EmptyTable;
                	GridStreetListHand.Columns[0].Footer.Value := '0';
        	end

       	 	//таблица непривязанных улиц непуста
        	else
        		GetStreetList;
        end

        //автоматическая привязка
        else
	if (pcGreeds.ActivePageIndex = 0) then
        begin
        	//очищаем содержимое таблиц
                mdUnAttachedStreetAuto.EmptyTable;
                GridUnAttachedStreetAuto.Columns[0].Footer.Value := '0';

        	mdStreetListAuto.EmptyTable;
                GridStreetListAuto.Columns[0].Footer.Value := '0';

        	//убираем отметку о сортировке по полю
                for i := 0 to GridUnAttachedStreetAuto.Columns.Count - 1 do
        		GridUnAttachedStreetAuto.Columns[i].Title.SortMarker := smNoneEh;

        	for i := 0 to GridStreetListAuto.Columns.Count - 1 do
        		GridStreetListAuto.Columns[i].Title.SortMarker := smNoneEh;
        end
end;

//список непривязанных улиц (Список улиц)
procedure TfrmUnCorrectStreet.GetUnCorrectStreet;
begin
        //MsgBox('список непривязанных улиц (Список улиц)');
	Screen.Cursor := crHourGlass;

        if (QueryFromOracleUnCorrectStreet) then
                CopyToMemoryDataUnCorrectStreet;

        Screen.Cursor := crDefault;
end;

//запрос в Оракл (Список улиц)
function TfrmUnCorrectStreet.QueryFromOracleUnCorrectStreet: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT O.NAME AS ORG'
        	+ ', C.NAME AS CITY'
                + ', S.NAME AS STREET'
	+ ' FROM KP.STREET_PU S'
        	+ ', KP.ORGS O'
                + ', KP.CITY_LIST C'
	+ ' WHERE S.STREET_ID IS NULL'
    		+ ' AND O.SUBJ_ID = S.ORG_ID'
    		+ ' AND C.ID      = S.CITY_ID'
    		+ ' AND S.STATUS  = ''NEW''');

        //выбран поставщик
        if (edOrg.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(O.NAME) LIKE UPPER(''%' + edOrg.Text + '%'')');

        //выбран город
        if (edCity.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(C.NAME) LIKE UPPER(''%' + edCity.Text + '%'')');

        //выбрана улица
        if (edStreet.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edStreet.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY O.NAME');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка при заполнении таблицы улиц' + #13 + '(Список улиц).');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (Список улиц)
procedure TfrmUnCorrectStreet.CopyToMemoryDataUnCorrectStreet;
var
	record_count: integer;
begin
	GridUnCorrectStreet.DataSource.DataSet.DisableControls;

   	mdUnCorrectStreet.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdUnCorrectStreet.Append;
                mdUnCorrectStreet.FieldByName('ORG').AsString    := DataMod.OracleDataSet.FieldByName('ORG').AsString;
                mdUnCorrectStreet.FieldByName('CITY').AsString   := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdUnCorrectStreet.FieldByName('STREET').AsString := DataMod.OracleDataSet.FieldByName('STREET').AsString;
                mdUnCorrectStreet.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdUnCorrectStreet.First;
        GridUnCorrectStreet.Columns[0].Footer.Value := IntToStr(record_count);
        GridUnCorrectStreet.DataSource.DataSet.EnableControls;
end;

//непривязанные улицы (Ручная привязка > Непривязанные улицы)
procedure TfrmUnCorrectStreet.GetUnAttachedStreet;
begin
        //MsgBox('непривязанные улицы (Ручная привязка > Непривязанные улицы)');
	Screen.Cursor  := crHourGlass;

        fGetStreetList := false;

        if (QueryFromOracleUnAttachedStreet) then
        	CopyToMemoryDataUnAttachedStreet;

        GridUnAttachedStreetHand.Refresh;

        fGetStreetList := true;
        Screen.Cursor  := crDefault;
end;

//запрос в Оракл (Ручная привязка > Непривязанные улицы)
function TfrmUnCorrectStreet.QueryFromOracleUnAttachedStreet: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT U.ID'
                + ', C.ID      AS CITY_ID'
                + ', O.SUBJ_ID AS ORG_ID'
     		+ ', S.NAME    AS STREET'
		+ ', C.NAME    AS CITY'
                + ', O.NAME    AS ORG'
	+ ' FROM KP.V$UNATTACHED_STREETS_PU u'
	   	+ ', KP.STREET_PU s'
                + ', KP.ORGS o'
   		+ ', KP.CITY_LIST c'
	+ ' WHERE U.ID = S.ID'
        	+ ' AND S.ORG_ID  = O.SUBJ_ID'
		+ ' AND S.CITY_ID = C.ID');

        //выбран поставщиков
        if (cbOrg.ItemIndex <> 0) then
        	DataMod.OracleDataSet.SQL.Add(' AND O.SUBJ_ID = ' + IntToStr(org_id[cbOrg.ItemIndex - 1]));

        //выбран город
        if (cbCity.ItemIndex <> 0) then
        	DataMod.OracleDataSet.SQL.Add(' AND C.ID = ' + IntToStr(city_id[cbCity.ItemIndex - 1]));

        //указан шаблон названия улицы
        if (edUnAttachedStreetFilter.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edUnAttachedStreetFilter.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY S.NAME');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка при заполнении таблицы улиц' + #13 + '(Ручная привязка > Непривязанные улицы).');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (Ручная привязка > Непривязанные улицы)
procedure TfrmUnCorrectStreet.CopyToMemoryDataUnAttachedStreet;
var
	record_count: integer;
begin
	GridUnAttachedStreetHand.DataSource.DataSet.DisableControls;

   	mdUnAttachedStreetHand.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdUnAttachedStreetHand.Append;
                mdUnAttachedStreetHand.FieldByName('ID').AsString       := DataMod.OracleDataSet.FieldByName('ID').AsString;
                mdUnAttachedStreetHand.FieldByName('CITY_ID').AsInteger := DataMod.OracleDataSet.FieldByName('CITY_ID').AsInteger;
                mdUnAttachedStreetHand.FieldByName('STREET').AsString   := DataMod.OracleDataSet.FieldByName('STREET').AsString;
                mdUnAttachedStreetHand.FieldByName('CITY').AsString     := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdUnAttachedStreetHand.FieldByName('ORG').AsString      := DataMod.OracleDataSet.FieldByName('ORG').AsString;
                mdUnAttachedStreetHand.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdUnAttachedStreetHand.First;
        GridUnAttachedStreetHand.Columns[0].Footer.Value := IntToStr(record_count);
        GridUnAttachedStreetHand.DataSource.DataSet.EnableControls;
end;

//список улиц (Ручная привязка > Список улиц)
procedure TfrmUnCorrectStreet.GetStreetList;
begin
        //MsgBox('список улиц (Ручная привязка > Список улиц)');
	Screen.Cursor := crHourGlass;

        if (QueryFromOracleStreetList) then
        	CopyToMemoryDataStreetList;

        Screen.Cursor := crDefault;
end;

//запрос в Оракл (Ручная привязка > Список улиц)
function TfrmUnCorrectStreet.QueryFromOracleStreetList: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT S.ID'
        	+ ', C.ID   AS CITY_ID'
		+ ', S.NAME AS STREET'
		+ ', C.NAME AS CITY'
	+ ' FROM KP.STREET_LIST s'
		+ ', KP.CITY_LIST c'
	+ ' WHERE S.CITY_ID = C.ID'
        + ' AND S.STATUS  = ''OLD''');

        //выбран город
        if (cbCity.ItemIndex <> 0) then
        	DataMod.OracleDataSet.SQL.Add(' AND C.ID = ' + IntToStr(city_id[cbCity.ItemIndex - 1]))

        //все города
        else
		DataMod.OracleDataSet.SQL.Add(' AND C.ID = ' + mdUnAttachedStreetHand.FieldByName('CITY_ID').AsString);

        //указан шаблон названия улицы
        if (edStreetListFilter.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edStreetListFilter.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY S.NAME');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка при заполнении таблицы улиц' + #13 + '(Ручная привязка > Список улиц).');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (Ручная привязка > Список улиц)
procedure TfrmUnCorrectStreet.CopyToMemoryDataStreetList;
var
	record_count,
        rec_no: integer;
begin
	GridStreetListHand.DataSource.DataSet.DisableControls;

   	mdStreetListHand.EmptyTable;
        record_count := 0;
        rec_no       := 1;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdStreetListHand.Append;
                mdStreetListHand.FieldByName('ID').AsString       := DataMod.OracleDataSet.FieldByName('ID').AsString;
                mdStreetListHand.FieldByName('CITY_ID').AsInteger := DataMod.OracleDataSet.FieldByName('CITY_ID').AsInteger;
                mdStreetListHand.FieldByName('STREET').AsString   := DataMod.OracleDataSet.FieldByName('STREET').AsString;
                mdStreetListHand.FieldByName('CITY').AsString     := DataMod.OracleDataSet.FieldByName('CITY').AsString;

                if (Pos(mdUnAttachedStreetHand.FieldByName('STREET').AsString, mdStreetListHand.FieldByName('STREET').AsString) > 0) then
                begin

                        mdStreetListHand.FieldByName('FLAG').AsInteger := 1;
                        rec_no := mdStreetListHand.RecNo;
                end

                else
                        mdStreetListHand.FieldByName('FLAG').AsInteger := 0;

                mdStreetListHand.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;

        if (rec_no > 1) then
		mdStreetListHand.SortOnFields('FLAG', true, true);

	mdStreetListHand.First;
        GridStreetListHand.Columns[0].Footer.Value := IntToStr(record_count);
        GridStreetListHand.DataSource.DataSet.EnableControls;
end;

procedure TfrmUnCorrectStreet.pnlFilterUnCorrectStreetResize(Sender: TObject);
begin
	edOrg.Width     := pnlFilterUnCorrectStreet.Width - 20;
        edCity.Width    := pnlFilterUnCorrectStreet.Width - 20;
        edStreet.Width  := pnlFilterUnCorrectStreet.Width - 20;
end;

procedure TfrmUnCorrectStreet.GridUnCorrectStreetSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridUnCorrectStreet = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridUnCorrectStreet.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridUnCorrectStreet.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridUnCorrectStreet.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdUnCorrectStreet.SortOnFields(fields, false, desc);
end;

//поставщик (список улиц)
procedure TfrmUnCorrectStreet.edOrgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    	if (fGetUnCorrectStreet) then
		if (Key = VK_RETURN) or (Length(edOrg.Text) > 2) then
                	GetUnCorrectStreet;
end;

//город (список улиц)
procedure TfrmUnCorrectStreet.edCityKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fGetUnCorrectStreet) then
		if (Key = VK_RETURN) or (Length(edCity.Text) > 2) then
                	GetUnCorrectStreet;
end;

//улица (список улиц)
procedure TfrmUnCorrectStreet.edStreetKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fGetUnCorrectStreet) then
		if (Key = VK_RETURN) or (Length(edStreet.Text) > 2) then
                	GetUnCorrectStreet;
end;

//изменение поставщика
procedure TfrmUnCorrectStreet.cbOrgChange(Sender: TObject);
var
	i: word;
begin
	if (not fGetUnAttachedStreet) then
        	exit;

        //убираем отметку о сортировке по полю
        for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
        		GridUnAttachedStreetHand.Columns[i].Title.SortMarker := smNoneEh;

        //отобразить/скрыть поле "Поставщик"
        for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
                if (GridUnAttachedStreetHand.Columns.Items[i].FieldName = 'ORG') then
                        GridUnAttachedStreetHand.Columns.Items[i].Visible := cbOrg.ItemIndex = 0;

        GetUnAttachedStreet;

        //таблица непривязанных улиц пуста
        if (mdUnAttachedStreetHand.IsEmpty) then
        begin
        	mdStreetListHand.EmptyTable;
                GridStreetListHand.Columns[0].Footer.Value := '0';
                exit;
        end;

        //все города
        if (fGetStreetList) then
		GetStreetList;

        //отображение кнопки "Привязать"
        btnAttachTop.Enabled    := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
        btnAttachBottom.Enabled := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
end;

//изменение города
procedure TfrmUnCorrectStreet.cbCityChange(Sender: TObject);
var
	i: word;
begin
        if (not fGetUnAttachedStreet) then
        	exit;

        //убираем отметку о сортировке по полю
        for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
        	GridUnAttachedStreetHand.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridStreetListHand.Columns.Count - 1 do
        	GridStreetListHand.Columns[i].Title.SortMarker := smNoneEh;

        //отобразить/скрыть поле "Город"
        for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
                if (GridUnAttachedStreetHand.Columns.Items[i].FieldName = 'CITY') then
                        GridUnAttachedStreetHand.Columns.Items[i].Visible := cbCity.ItemIndex = 0;

        GetUnAttachedStreet;

        //отобразить/скрыть поле "Поставщик"
        for i := 0 to GridStreetListHand.Columns.Count - 1 do
                if (GridStreetListHand.Columns.Items[i].FieldName = 'CITY') then
                        GridStreetListHand.Columns.Items[i].Visible := cbCity.ItemIndex = 0;

        //таблица непривязанных улиц пуста
        if (mdUnAttachedStreetHand.IsEmpty) then
        begin
                mdStreetListHand.EmptyTable;
                GridStreetListHand.Columns[0].Footer.Value := '0';
        end

        //таблица непривязанных улиц непуста
        else
        	GetStreetList;

        //отображение кнопки "Привязать"
        btnAttachTop.Enabled    := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
        btnAttachBottom.Enabled := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
end;

procedure TfrmUnCorrectStreet.FormResize(Sender: TObject);
begin
	SetControlPosition;
end;

procedure TfrmUnCorrectStreet.GridUnAttachedStreetHandSortMarkingChanged(
  Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridUnAttachedStreetHand = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridUnAttachedStreetHand.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridUnAttachedStreetHand.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridUnAttachedStreetHand.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdUnAttachedStreetHand.SortOnFields(fields, false, desc);
end;

procedure TfrmUnCorrectStreet.GridStreetListHandSortMarkingChanged(
  Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridStreetListHand = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridStreetListHand.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridStreetListHand.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridStreetListHand.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdStreetListHand.SortOnFields(fields, false, desc);
end;

//перекдючение закладки
procedure TfrmUnCorrectStreet.pcGreedsChange(Sender: TObject);
begin
	pcGreeds.ActivePage.Refresh;

	//список улиц
	if (pcGreeds.ActivePageIndex = 0) then
        	GetUnCorrectStreet

        //привязка улиц
        else
        if (pcGreeds.ActivePageIndex = 1) then
        begin
        	SetControlPosition;

    		fGetUnAttachedStreet := false;
    		fGetStreetList       := false;

        	SetOrgList(cbOrg);
        	SetCityList(cbCity);

        	fGetUnAttachedStreet := true;
    		fGetStreetList       := true;

        	GetUnAttachedStreet;

		//таблица непривязанных улиц пуста
        	if (mdUnAttachedStreetHand.IsEmpty) then
        	begin
                	mdStreetListHand.EmptyTable;
                	GridStreetListHand.Columns[0].Footer.Value := '0';
        	end

       	 	//таблица непривязанных улиц непуста
        	else
        		GetStreetList;
        end;
end;

procedure TfrmUnCorrectStreet.edUnAttachedStreetFilterKeyUp(
  Sender: TObject; var Key: Word; Shift: TShiftState);
var
	i: word;
begin
        if ((Key = 16) or (Key = VK_CONTROL) or (Key = VK_MENU) //SHIFT, CTRL, ALT
	or (Key = VK_LEFT) or (Key = VK_RIGHT) //стрелочка влево, стрелочка вправо
        or (Key = VK_HOME) or (Key = VK_END))  //HOME, END
        then
        	exit;

	//стрелочка вверх
        if (Key = VK_UP) then
         	mdUnAttachedStreetHand.Prior

        //стрелочка вниз
        else
        if (Key = VK_DOWN) then
         	mdUnAttachedStreetHand.Next

        //Enter или длина строки больше 2-х символов
        else
        if (Key = VK_RETURN) or (Length(edUnAttachedStreetFilter.Text) > 2) then
        begin
        	GetUnAttachedStreet;

                //убираем отметку о сортировке по полю
                for i := 0 to GridUnAttachedStreetHand.Columns.Count - 1 do
        		GridUnAttachedStreetHand.Columns[i].Title.SortMarker := smNoneEh;

	        //таблица непривязанных улиц пуста
        	if (mdUnAttachedStreetHand.IsEmpty) then
	        begin
        		mdStreetListHand.EmptyTable;
                	GridStreetListHand.Columns[0].Footer.Value := '0';
	                exit;
        	end;

        	//все города
        	if (fGetStreetList) then
			GetStreetList;

                //убираем отметку о сортировке по полю
                for i := 0 to GridStreetListHand.Columns.Count - 1 do
        		GridStreetListHand.Columns[i].Title.SortMarker := smNoneEh;
        end;
end;

procedure TfrmUnCorrectStreet.edStreetListFilterKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
	i: word;
begin
	if ((Key = 16) or (Key = VK_CONTROL) or (Key = VK_MENU) //SHIFT, CTRL, ALT
	or (Key = VK_LEFT) or (Key = VK_RIGHT) //стрелочка влево, стрелочка вправо
        or (Key = VK_HOME) or (Key = VK_END))  //HOME, END
        then
        	exit;

	//стрелочка вверх
        if (Key = VK_UP) then
         	mdStreetListHand.Prior

        //стрелочка вниз
        else
        if (Key = VK_DOWN) then
         	mdStreetListHand.Next

        else
        //список непривязанных улиц непуст
	if (not mdUnAttachedStreetHand.IsEmpty) then
        	//Enter или длина строки больше 2-х символов
        	if (Key = VK_RETURN) or (Length(edStreetListFilter.Text) > 2) then
        		GetStreetList;

        //убираем отметку о сортировке по полю
        for i := 0 to GridStreetListHand.Columns.Count - 1 do
        	GridStreetListHand.Columns[i].Title.SortMarker := smNoneEh;
end;

procedure TfrmUnCorrectStreet.mdUnAttachedStreetHandBeforeScroll(
  DataSet: TDataSet);
begin
	//запоминаем предыдущий город с таблице непривязанных улиц
	fCity := mdUnAttachedStreetHand.FieldByName('CITY').AsString;
end;

procedure TfrmUnCorrectStreet.mdUnAttachedStreetHandAfterScroll(
  DataSet: TDataSet);
var
	i: word;
begin
        if (not fGetStreetList) then
        	exit;

        //город в таблице непривязанных улиц не изменился
	if (mdUnAttachedStreetHand.FieldByName('CITY').AsString = fCity) then
        	exit;

        //таблица непривязанных улиц непуста
        if (not mdUnAttachedStreetHand.IsEmpty) then
		GetStreetList;

        //убираем отметку о сортировке по полю
        for i := 0 to GridStreetListHand.Columns.Count - 1 do
                GridStreetListHand.Columns[i].Title.SortMarker := smNoneEh;

        //отображение кнопки "Привязать"
        btnAttachTop.Enabled    := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
        btnAttachBottom.Enabled := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
end;

procedure TfrmUnCorrectStreet.mdStreetListHandAfterScroll(DataSet: TDataSet);
begin
	//отображение кнопки "Привязать"
        btnAttachTop.Enabled    := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
        btnAttachBottom.Enabled := (not mdUnAttachedStreetHand.IsEmpty) and (not mdStreetListHand.IsEmpty);
end;

//нажатие на кнопку "Привязать" или CTRL + A
procedure TfrmUnCorrectStreet.AcAttachExecute(Sender: TObject);
var
	msg: string;
begin
	if ((mdUnAttachedStreetHand.IsEmpty) or (mdStreetListHand.IsEmpty)) then
        	exit;

        //----------------------------------------------------------------------
        //проверка на совпадение городов привязываемых улиц
        if (mdUnAttachedStreetHand.FieldByName('CITY_ID').AsInteger <> mdStreetListHand.FieldByName('CITY_ID').AsInteger) then
        begin
        	WarningBox('Улицы относятся к разным городам:' + #13 +
                mdUnAttachedStreetHand.FieldByName('STREET').AsString + ' (' + mdUnAttachedStreetHand.FieldByName('CITY').AsString + ')' + #13 +
                mdStreetListHand.FieldByName('STREET').AsString       + ' (' + mdStreetListHand.FieldByName('CITY').AsString       + ')' + #13 + #13 +
                'Привязка улиц невозможна.');
                exit;
        end;

        //----------------------------------------------------------------------
        //проверка на непривязанность улицы
        DataMod.OracleDataSet.SQL.Text := 'SELECT l.NAME AS STREET'
	+ ' FROM KP.STREET_PU p'
   		+ ', KP.STREET_LIST l'
	+ ' WHERE P.STREET_ID = L.ID'
		+ ' AND P.ID = ' + mdUnAttachedStreetHand.FieldByName('ID').AsString;

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	WarningBox('Ошибка при проверке на непривязанность улицы.');
                exit;
	end;

        //улица уже привязана
        if (DataMod.OracleDataSet.RecordCount > 0) then
        begin
                WarningBox('Улица "' + mdUnAttachedStreetHand.FieldByName('STREET').AsString + '"' + #13 + 'уже привязана у улице' + #13 + '"' + DataMod.OracleDataSet.FieldByName('STREET').AsString + '".' + #13 + #13 + 'Обновите список непривязанных улиц.');
           	DataMod.OracleDataSet.Close;

                mdUnAttachedStreetHand.Delete;
        	GridUnAttachedStreetHand.Columns[0].Footer.Value := IntToStr(mdUnAttachedStreetHand.RecordCount);

        	//таблица непривязанных улиц пуста
        	if (mdUnAttachedStreetHand.IsEmpty) then
        	begin
        		mdStreetListHand.EmptyTable;
                	GridStreetListHand.Columns[0].Footer.Value := '0';
	        end;

                exit;
        end;

        DataMod.OracleDataSet.Close;

        //----------------------------------------------------------------------
        //диалоговое окно для подтверждения привязки
        msg := format('Привязать улицу%s"%s"%sк улице%s"%s"?', [#13, mdUnAttachedStreetHand.FieldByName('STREET').AsString, #13, #13, mdStreetListHand.FieldByName('STREET').AsString]);
	if (YesNoBox(msg) = IDNO) then
        	exit;

        DataMod.OracleDataSet.SQL.Text := 'UPDATE KP.V$UNATTACHED_STREETS_PU'
	+ ' SET STREET_ID   = ' + mdStreetListHand.FieldByName('ID').AsString
  		+ ', STATUS = ''OLD'''
	+ ' WHERE ID = ' + mdUnAttachedStreetHand.FieldByName('ID').AsString;

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	WarningBox('Ошибка при привязке улиц.' + #13 + #13 + 'Возможно, улица уже привязана.' + #13 + 'Обновите список непривязанных улиц.');
                exit;
	end;

        DataMod.OracleDataSet.Close;
        DataMod.OracleSession.Commit;

	//----------------------------------------------------------------------
        //запоминаем предыдущий город с таблице непривязанных улиц
	fCity := mdUnAttachedStreetHand.FieldByName('CITY').AsString;

        //если город в следующей (предыдущей) записи совпадает с привязываемым,
        //то заново не формируем список улиц
        GridUnAttachedStreetHand.DataSource.DataSet.DisableControls;

        //привязываемая улица последняя в списке
        if (mdUnAttachedStreetHand.RecNo = mdUnAttachedStreetHand.RecordCount) then
	begin
        	mdUnAttachedStreetHand.Prior;
        	if (mdUnAttachedStreetHand.FieldByName('CITY').AsString = fCity) then
        		fGetUnAttachedStreet := false;
        	mdUnAttachedStreetHand.Next;
        end

        //привязываемая улица непоследняя в списке
        else
        begin
        	mdUnAttachedStreetHand.Next;
        	if (mdUnAttachedStreetHand.FieldByName('CITY').AsString = fCity) then
        		fGetUnAttachedStreet := false;
        	mdUnAttachedStreetHand.Prior;
        end;

        GridUnAttachedStreetHand.DataSource.DataSet.EnableControls;

        mdUnAttachedStreetHand.Delete;
        fGetUnAttachedStreet := true;
        GridUnAttachedStreetHand.Columns[0].Footer.Value := IntToStr(mdUnAttachedStreetHand.RecordCount);

        //таблица непривязанных улиц пуста
        if (mdUnAttachedStreetHand.IsEmpty) then
        begin
        	mdStreetListHand.EmptyTable;
                GridStreetListHand.Columns[0].Footer.Value := '0';
                exit;
        end;
end;

procedure TfrmUnCorrectStreet.GridStreetListHandGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

   	if (mdStreetListHand.FieldByName('FLAG').AsInteger > 0) then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD; 
end;

//Автоматическая привязка > Старт
procedure TfrmUnCorrectStreet.btnStartClick(Sender: TObject);
var
	record_count: integer;
begin
	Screen.Cursor := crHourGlass;

        //---------------------------------------------------------------------- (1)
        // [Улица] > [Улица] + УЛ
        //----------------------------------------------------------------------
	//запрос в Оракл
        DataMod.OracleDataSet.SQL.Text := 'SELECT U.ID'
     		+ ', S.NAME AS STREET'
     		+ ', C.NAME AS CITY'
     		+ ', O.NAME AS ORG'
     		+ ', L.ID   AS ID2'
     		+ ', L.NAME AS STREET2'
	+ ' FROM KP.V$UNATTACHED_STREETS_PU u'
   		+ ', KP.STREET_PU s'
   		+ ', KP.STREET_LIST l'
   		+ ', KP.ORGS o'
   		+ ', KP.CITY_LIST c'
	+ ' WHERE U.ID = S.ID'
		+ ' AND S.CITY_ID = C.ID'
		+ ' AND S.CITY_ID = L.CITY_ID'
                + ' AND L.STATUS  = ''OLD'''
		+ ' AND L.NAME    = S.NAME ||'' УЛ'''
		+ ' AND S.ORG_ID  = O.SUBJ_ID'
        + ' ORDER BY S.NAME'
       		+ ', C.NAME';
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
                WarningBox('Ошибка при формировании списка улиц' + #13 + '(Автоматическая привязка).');
                exit;
	end;

        //----------------------------------------------------------------------
        //копирование данных во временные таблицы
	GridUnAttachedStreetAuto.DataSource.DataSet.DisableControls;
        GridStreetListAuto.DataSource.DataSet.DisableControls;

   	mdUnAttachedStreetAuto.EmptyTable;
        mdStreetListAuto.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdUnAttachedStreetAuto.Append;
                mdUnAttachedStreetAuto.FieldByName('ID').AsString     := DataMod.OracleDataSet.FieldByName('ID').AsString;
                mdUnAttachedStreetAuto.FieldByName('STREET').AsString := DataMod.OracleDataSet.FieldByName('STREET').AsString;
                mdUnAttachedStreetAuto.FieldByName('CITY').AsString   := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdUnAttachedStreetAuto.FieldByName('ORG').AsString    := DataMod.OracleDataSet.FieldByName('ORG').AsString;
                mdUnAttachedStreetAuto.Post;

                mdStreetListAuto.Append;
                mdStreetListAuto.FieldByName('ID').AsString     := DataMod.OracleDataSet.FieldByName('ID2').AsString;
                mdStreetListAuto.FieldByName('STREET').AsString := DataMod.OracleDataSet.FieldByName('STREET2').AsString;
                mdStreetListAuto.FieldByName('CITY').AsString   := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdStreetListAuto.Post;

                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;

        mdUnAttachedStreetAuto.First;
        GridUnAttachedStreetAuto.Columns[0].Footer.Value := IntToStr(record_count);
        GridUnAttachedStreetAuto.DataSource.DataSet.EnableControls;

        mdStreetListAuto.First;
        GridStreetListAuto.Columns[0].Footer.Value := IntToStr(record_count);
        GridStreetListAuto.DataSource.DataSet.EnableControls;

        GridStreetListHand.DataSource.DataSet.DisableControls;
        GridStreetListAuto.DataSource.DataSet.EnableControls;

        //----------------------------------------------------------------------
        //список автоматически привязываемых улиц непуст
        if (mdUnAttachedStreetAuto.RecordCount > 0) then
	begin
        	//запрос в Оракл
        	DataMod.OracleDataSet.SQL.Text := 'UPDATE KP.V$UNATTACHED_STREETS_PU u'
		+ ' SET U.STREET_ID ='
		+ '('
    			+ ' SELECT L.ID'
    			+ ' FROM KP.STREET_PU s'
       				+ ', KP.STREET_LIST l'
    			+ ' WHERE U.ID = S.ID'
    				+ ' AND S.CITY_ID = L.CITY_ID'
    				+ ' AND L.STATUS  = ''OLD'''
    				+ ' AND L.NAME    = S.NAME ||'' УЛ'''
		+ ')'
		+ ', U.STATUS = ''OLD'''
		+ ' WHERE U.ID IN'
		+ '('
    			+ ' SELECT U2.ID'
    			+ ' FROM KP.V$UNATTACHED_STREETS_PU u2'
       				+ ', KP.STREET_PU s'
       				+ ', KP.STREET_LIST l'
    			+ ' WHERE U2.ID   = S.ID'
    				+ ' AND S.CITY_ID = L.CITY_ID'
    				+ ' AND L.STATUS  = ''OLD'''
    				+ ' AND L.NAME    = S.NAME ||'' УЛ'''
		+ ')';

                //запуск запроса
        	try
	        	DataMod.OracleDataSet.Open;
        	except
        		Screen.Cursor := crDefault;
                	WarningBox('Ошибка при автоматической привязке улиц.');
                	exit;
		end;

                DataMod.OracleDataSet.Close;
                DataMod.OracleSession.Commit;
        end;

        //---------------------------------------------------------------------- (2)
        // [Улица] > [Улица] + ПЕР
        //----------------------------------------------------------------------
	//запрос в Оракл
        DataMod.OracleDataSet.SQL.Text := 'SELECT U.ID'
     		+ ', S.NAME AS STREET'
     		+ ', C.NAME AS CITY'
     		+ ', O.NAME AS ORG'
     		+ ', L.ID   AS ID2'
     		+ ', L.NAME AS STREET2'
	+ ' FROM KP.V$UNATTACHED_STREETS_PU u'
   		+ ', KP.STREET_PU s'
   		+ ', KP.STREET_LIST l'
   		+ ', KP.ORGS o'
   		+ ', KP.CITY_LIST c'
	+ ' WHERE U.ID = S.ID'
		+ ' AND S.CITY_ID = C.ID'
		+ ' AND S.CITY_ID = L.CITY_ID'
                + ' AND L.STATUS  = ''OLD'''
		+ ' AND L.NAME    = S.NAME ||'' ПЕР'''
		+ ' AND S.ORG_ID  = O.SUBJ_ID'
        + ' ORDER BY S.NAME'
       		+ ', C.NAME';
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
                WarningBox('Ошибка при формировании списка улиц' + #13 + '(Автоматическая привязка).');
                exit;
	end;

        //----------------------------------------------------------------------
        //копирование данных во временные таблицы
	GridUnAttachedStreetAuto.DataSource.DataSet.DisableControls;
        GridStreetListAuto.DataSource.DataSet.DisableControls;

        //record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdUnAttachedStreetAuto.Append;
                mdUnAttachedStreetAuto.FieldByName('ID').AsString     := DataMod.OracleDataSet.FieldByName('ID').AsString;
                mdUnAttachedStreetAuto.FieldByName('STREET').AsString := DataMod.OracleDataSet.FieldByName('STREET').AsString;
                mdUnAttachedStreetAuto.FieldByName('CITY').AsString   := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdUnAttachedStreetAuto.FieldByName('ORG').AsString    := DataMod.OracleDataSet.FieldByName('ORG').AsString;
                mdUnAttachedStreetAuto.Post;

                mdStreetListAuto.Append;
                mdStreetListAuto.FieldByName('ID').AsString     := DataMod.OracleDataSet.FieldByName('ID2').AsString;
                mdStreetListAuto.FieldByName('STREET').AsString := DataMod.OracleDataSet.FieldByName('STREET2').AsString;
                mdStreetListAuto.FieldByName('CITY').AsString   := DataMod.OracleDataSet.FieldByName('CITY').AsString;
                mdStreetListAuto.Post;

                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;

        mdUnAttachedStreetAuto.First;
        GridUnAttachedStreetAuto.Columns[0].Footer.Value := IntToStr(record_count);
        GridUnAttachedStreetAuto.DataSource.DataSet.EnableControls;

        mdStreetListAuto.First;
        GridStreetListAuto.Columns[0].Footer.Value := IntToStr(record_count);
        GridStreetListAuto.DataSource.DataSet.EnableControls;

        GridStreetListHand.DataSource.DataSet.DisableControls;
        GridStreetListAuto.DataSource.DataSet.EnableControls;

        //----------------------------------------------------------------------
        //список автоматически привязываемых улиц непуст
        if (mdUnAttachedStreetAuto.RecordCount > 0) then
	begin
        	//запрос в Оракл
        	DataMod.OracleDataSet.SQL.Text := 'UPDATE KP.V$UNATTACHED_STREETS_PU u'
		+ ' SET U.STREET_ID ='
		+ '('
    			+ ' SELECT L.ID'
    			+ ' FROM KP.STREET_PU s'
       				+ ', KP.STREET_LIST l'
    			+ ' WHERE U.ID = S.ID'
    				+ ' AND S.CITY_ID = L.CITY_ID'
    				+ ' AND L.STATUS  = ''OLD'''
    				+ ' AND L.NAME    = S.NAME ||'' ПЕР'''
		+ ')'
		+ ', U.STATUS = ''OLD'''
		+ ' WHERE U.ID IN'
		+ '('
    			+ ' SELECT U2.ID'
    			+ ' FROM KP.V$UNATTACHED_STREETS_PU u2'
       				+ ', KP.STREET_PU s'
       				+ ', KP.STREET_LIST l'
    			+ ' WHERE U2.ID   = S.ID'
    				+ ' AND S.CITY_ID = L.CITY_ID'
    				+ ' AND L.STATUS  = ''OLD'''
    				+ ' AND L.NAME    = S.NAME ||'' ПЕР'''
		+ ')';

                //запуск запроса
        	try
	        	DataMod.OracleDataSet.Open;
        	except
        		Screen.Cursor := crDefault;
                	WarningBox('Ошибка при автоматической привязке улиц.');
                	exit;
		end;

                DataMod.OracleDataSet.Close;
                DataMod.OracleSession.Commit;
        end;

        Screen.Cursor := crDefault;

        if (record_count = 0) then
        	MsgBox('Не найдено ни одной улицы для автоматической привязки.'); 
end;

end.
