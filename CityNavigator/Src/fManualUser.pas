//Справочник пользователей
unit fManualUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmManualUser = class(TForm)
    pnlFilter: TPanel;
    RxSplitter1: TRxSplitter;
    edOraName: TDBEditEh;
    pnlFilterTop: TPanel;
    mdManualUser: TRxMemoryData;
    dsManualUser: TDataSource;
    lblOraName: TLabel;
    xlReport: TxlReport;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    pmExcel: TMenuItem;
    mdManualUserID: TIntegerField;
    mdManualUserORANAME: TStringField;
    mdManualUserNAME: TStringField;
    mdManualUserIS_ACTIVE: TStringField;
    mdManualUserIS_DEL: TStringField;
    mdManualUserSUBJ: TStringField;
    lblName: TLabel;
    edFIO: TDBEditEh;
    lblSubj: TLabel;
    pnlGrid: TPanel;
    GridManualUser: TDBGridEh;
    GridGrant: TDBGridEh;
    RxSplitter2: TRxSplitter;
    mdGrant: TRxMemoryData;
    dsGrant: TDataSource;
    mdGrantID: TIntegerField;
    mdGrantOBJECT: TStringField;
    mdGrantNAME: TStringField;
    lblError: TLabel;
    mdGrantGRANT_PYPE: TStringField;
    edSubj: TDBEditEh;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualUserSortMarkingChanged(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure GridGrantSortMarkingChanged(Sender: TObject);
    procedure mdManualUserAfterScroll(DataSet: TDataSet);
    procedure GridGrantGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure edOraNameChange(Sender: TObject);
    procedure GridManualUserGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure edOraNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFIOKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSubjKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GetGrants;
    procedure RunQuery;

    //запрос в Оракл
    function QueryFromOracleUser: boolean;
    function QueryFromOracleBasicGrant: boolean;
    function QueryFromOracleExtendGrant: boolean;

    //копирование данных во временную таблицу
    procedure CopyToMemoryDataUser;
    procedure CopyToMemoryDataBasicGrant;
    procedure CopyToMemoryDataExtendGrant;
  public
    fStartQuery: boolean;
    fGetBasicGrants: boolean;
    fGetExtendGrants: boolean;
    fColorMode: boolean;
  end;

var
  frmManualUser: TfrmManualUser;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualUser.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        lblError.Visible    := false;
        mdManualUser.Active := true;
        mdGrant.Active      := true;
	fStartQuery         := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualUser.FormShow(Sender: TObject);
begin
	//выполнение процедуры для доступа к представления
        //для вывода расширенных прав пользователей
        try
                DataMod.OraclePackage.PackageName := 'INV_ADM.PK_LOGIN';
           	DataMod.OraclePackage.CallProcedure('LOGIN', [1521]);
        except
        	lblError.Visible := true;
	end;

	RunQuery;
end;

procedure TfrmManualUser.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualUser.Active := false;
        mdGrant.Active      := false;
	Action := caFree;
end;

//получение прав пользователя
procedure TfrmManualUser.GetGrants;
begin
   	//MsgBox('GetGrants');
	Screen.Cursor := crHourGlass;

        if (QueryFromOracleBasicGrant) then
	        CopyToMemoryDataBasicGrant;

        if (QueryFromOracleExtendGrant) then
	        CopyToMemoryDataExtendGrant;

        Screen.Cursor := crDefault;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualUser.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualUser';
	pnlFilter.Width  := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        GridGrant.Height := OptionsIni.ReadInteger(sect, 'GridGrantHeight', 200);
        edOraName.Text   := OptionsIni.ReadString(sect, 'OraName', '');
        edFIO.Text       := OptionsIni.ReadString(sect, 'FIO', '');
        edSubj.Text      := OptionsIni.ReadString(sect, 'Subj', '');

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmManualUser.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualUser';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteInteger(sect, 'GridGrantHeight', GridGrant.Height);
        OptionsIni.WriteString(sect, 'OraName', edOraName.Text);
        OptionsIni.WriteString(sect, 'FIO', edFIO.Text);
        OptionsIni.WriteString(sect, 'Subj', edSubj.Text);
end;

//обновить
procedure TfrmManualUser.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualUser.Columns.Count - 1 do
        	GridManualUser.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridGrant.Columns.Count - 1 do
        	GridGrant.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualUser.AcToExcelExecute(Sender: TObject);
begin
	xlReport.Params.Items[0].AsString := edOraName.Text;
        xlReport.Params.Items[1].AsString := edFIO.Text;
        xlReport.Params.Items[2].AsString := edSubj.Text;
    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualUser.pmExcelClick(Sender: TObject);
begin
  	xlReport.Params.Items[0].AsString := edOraName.Text;
        xlReport.Params.Items[1].AsString := edFIO.Text;
        xlReport.Params.Items[2].AsString := edSubj.Text;
    	ProgressReport(xlReport);
end;

procedure TfrmManualUser.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;

        //запрещаем вызов GetGrants при формировании списка пользователей
        fGetBasicGrants  := false;
        fGetExtendGrants := false;

        if (QueryFromOracleUser) then
	        CopyToMemoryDataUser;

        fGetBasicGrants  := true;
        fGetExtendGrants := true;

        if (QueryFromOracleBasicGrant) then
	        CopyToMemoryDataBasicGrant;

        if (QueryFromOracleExtendGrant) then
	        CopyToMemoryDataExtendGrant;

        Screen.Cursor := crDefault;
end;

//запрос в Оракл (пользователи)
function TfrmManualUser.QueryFromOracleUser: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT U.ID'
     		+ ', U.ORANAME'
       		+ ', U.NAME'
     		+ ', U.IS_ACTIVE'
     		+ ', U.IS_DEL'
     		+ ', S.NAME AS SUBJ'
	+ ' FROM KP.USERS$ U'
   		+ ', KP.SUBJ S'
	+ ' WHERE U.TYPE = ''USER'''
	+ ' AND U.WHERE_ID = S.ID');

        //выбрано сетевое имя
        if (edOraName.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(U.ORANAME) LIKE UPPER(''%' + edOraName.Text + '%'')');

        //выбрано ФИО пользователя
        if (edFIO.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(U.NAME) LIKE UPPER(''%' + edFIO.Text + '%'')');

        //выбран офис
        if (edSubj.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edSubj.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY U.ID');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualUser).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (пользователи)
procedure TfrmManualUser.CopyToMemoryDataUser;
var
	record_count: integer;
begin
	GridManualUser.DataSource.DataSet.DisableControls;

   	mdManualUser.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualUser.Append;
                mdManualUser.FieldByName('ID').AsInteger       := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdManualUser.FieldByName('ORANAME').AsString   := DataMod.OracleDataSet.FieldByName('ORANAME').AsString;
                mdManualUser.FieldByName('NAME').AsString      := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdManualUser.FieldByName('IS_ACTIVE').AsString := DataMod.OracleDataSet.FieldByName('IS_ACTIVE').AsString;
                mdManualUser.FieldByName('IS_DEL').AsString    := DataMod.OracleDataSet.FieldByName('IS_DEL').AsString;
                mdManualUser.FieldByName('SUBJ').AsString      := DataMod.OracleDataSet.FieldByName('SUBJ').AsString;
                mdManualUser.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualUser.First;
        GridManualUser.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualUser.DataSource.DataSet.EnableControls;
end;

//запрос в Оракл (стандартные права)
function TfrmManualUser.QueryFromOracleBasicGrant: boolean;
begin
	result := false;

        //список пользователей пуст
        if (mdManualUser.IsEmpty) then
        begin
        	mdGrant.EmptyTable;
                GridGrant.Columns[0].Footer.Value := '0';
        	exit;
        end;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Text := 'SELECT R.ID'
     		+ ', R.OBJECT'
     		+ ', R.NAME'
	+ ' FROM KP.RIGHTS$ R'
   		+ ', KP.GRANTS$ G'
	+ ' WHERE G.USER$_ID = ' + mdManualUser.FieldByName('ID').AsString
	+ ' AND G.RIGHT_ID = R.ID'
 	+ ' ORDER BY R.ID';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fManualUser).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (стандартные права)
procedure TfrmManualUser.CopyToMemoryDataBasicGrant;
var
	record_count: integer;
begin
	GridGrant.DataSource.DataSet.DisableControls;

   	mdGrant.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdGrant.Append;
                mdGrant.FieldByName('ID').AsInteger        := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdGrant.FieldByName('OBJECT').AsString     := DataMod.OracleDataSet.FieldByName('OBJECT').AsString;
                mdGrant.FieldByName('NAME').AsString       := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdGrant.FieldByName('GRANT_TYPE').AsString := 'BASIC';
                mdGrant.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdGrant.First;
        GridGrant.Columns[0].Footer.Value := IntToStr(record_count);
        GridGrant.DataSource.DataSet.EnableControls;
end;

//запрос в Оракл (расширенные права)
function TfrmManualUser.QueryFromOracleExtendGrant: boolean;
begin
	result := false;

        //список пользователей пуст
        if (mdManualUser.IsEmpty) then
        begin
        	mdGrant.EmptyTable;
                GridGrant.Columns[0].Footer.Value := '0';
        	exit;
        end;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Text := 'SELECT PERMIS_ID AS ID'
     		+ ', NAME AS OBJECT'
     		+ ', NOTE AS NAME'
	+ ' FROM INV_ADM.VA$ADPERM_USER_GROUP'
	+ ' WHERE ORANAME = ''' + mdManualUser.FieldByName('ORANAME').AsString + ''''
        + ' ORDER BY ID';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	lblError.Visible := true;
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (расширенные права)
procedure TfrmManualUser.CopyToMemoryDataExtendGrant;
var
	record_count: integer;
begin
	GridGrant.DataSource.DataSet.DisableControls;

        //к количеству стандартных прав будем добавлять количество рассширенных
        try
	        record_count := StrToInt(GridGrant.Columns[0].Footer.Value);
        except
		record_count := 0;
        end;


        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdGrant.Append;
                mdGrant.FieldByName('ID').AsInteger        := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdGrant.FieldByName('OBJECT').AsString     := DataMod.OracleDataSet.FieldByName('OBJECT').AsString;
                mdGrant.FieldByName('NAME').AsString       := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdGrant.FieldByName('GRANT_TYPE').AsString := 'EXTEND';
                mdGrant.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdGrant.First;
        GridGrant.Columns[0].Footer.Value := IntToStr(record_count);
        GridGrant.DataSource.DataSet.EnableControls;
end;

procedure TfrmManualUser.pnlFilterResize(Sender: TObject);
begin
	edOraName.Width := pnlFilter.Width - 20;
        edFIO.Width     := pnlFilter.Width - 20;
        edSubj.Width    := pnlFilter.Width - 20;
end;

procedure TfrmManualUser.GridManualUserSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualUser = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualUser.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualUser.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualUser.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualUser.SortOnFields(fields, false, desc);
end;

procedure TfrmManualUser.GridGrantSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridGrant = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridGrant.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridGrant.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridGrant.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdGrant.SortOnFields(fields, false, desc);
end;

procedure TfrmManualUser.mdManualUserAfterScroll(DataSet: TDataSet);
begin
	if (fGetBasicGrants and fGetExtendGrants) then
        	GetGrants;
end;

procedure TfrmManualUser.GridManualUserGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdManualUser.FieldByName('IS_ACTIVE').AsString = 'no') then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmManualUser.GridGrantGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdGrant.FieldByName('GRANT_TYPE').AsString = 'EXTEND') then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmManualUser.edOraNameChange(Sender: TObject);
begin
      	if (fStartQuery = true) then
      		RunQuery;
end;

procedure TfrmManualUser.edOraNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edOraName.Text) > 2) then
                	RunQuery;
end;

procedure TfrmManualUser.edFIOKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edFIO.Text) > 2) then
                	RunQuery;
end;

procedure TfrmManualUser.edSubjKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edSubj.Text) > 2) then
                	RunQuery;
end;

end.
