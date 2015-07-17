//«авершение дн€
unit fDayEnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmDayEnd = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edName: TDBEditEh;
    pnlFilterTop: TPanel;
    mdDayEnd: TRxMemoryData;
    dsDayEnd: TDataSource;
    GridDayEnd: TDBGridEh;
    lblName: TLabel;
    mdDayEndNAME: TStringField;
    mdDayEndTEXT: TStringField;
    lblPeriod: TLabel;
    lblPeriodStart: TLabel;
    edPeriodBegin: TDBDateTimeEditEh;
    edPeriodEnd: TDBDateTimeEditEh;
    lblPeriodEnd: TLabel;
    mdDayEndTIME: TDateTimeField;
    lblError: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridDayEndSortMarkingChanged(Sender: TObject);
    procedure edNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPeriodBeginChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //запрос в ќракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    fStartQuery: boolean;
  end;

var
  frmDayEnd: TfrmDayEnd;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmDayEnd.FormCreate(Sender: TObject);
begin
	//cтруктуру дл€ обслуживани€ из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdDayEnd.Active := true;
        fStartQuery     := false;

        LoadFromIni;
        edPeriodBegin.Text := DateToStr(Now);
        edPeriodEnd.Text   := DateToStr(Now + 1);

        fStartQuery := true;
end;

procedure TfrmDayEnd.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmDayEnd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdDayEnd.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmDayEnd.LoadFromIni;
var
	sect: String;
begin
	sect := 'DayEnd';
	pnlFilter.Width  := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edName.Text      := OptionsIni.ReadString(sect, 'Name', '');
end;

//сохранение параметров в ini-файл
procedure TfrmDayEnd.SaveToIni;
var
	sect: String;
begin
	sect := 'DayEnd';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Name', edName.Text);
end;

//обновить
procedure TfrmDayEnd.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridDayEnd.Columns.Count - 1 do
        	GridDayEnd.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

procedure TfrmDayEnd.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в ќракл
function TfrmDayEnd.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT U.NAME'
        	+ ', T.TIME'
     		+ ', T.TEXT'
	+ ' FROM KP.MSGLOG T'
   		+ ' , KP.USERS$ U'
	+ ' WHERE T.TIME BETWEEN ''' + edPeriodBegin.Text + '''  AND ''' + edPeriodEnd.Text + ''''
		+ ' AND U.ID = T.USER_ID'
		+ ' AND T.TEXT = ''«авершение операционного дн€ совершено успешно''');

        //выбрано им€ пользовател€
        if (edName.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(U.NAME) LIKE UPPER(''%' + edName.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY T.TIME');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('ќшибка выполнени€ запроса (fDayEnd).'
                + #13 + '¬озможно, у вас нет требуемых прав дл€ запуска запроса.'
                + #13 + #13 + 'ќбратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmDayEnd.CopyToMemoryData;
var
	record_count: integer;
begin
	GridDayEnd.DataSource.DataSet.DisableControls;

   	mdDayEnd.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdDayEnd.Append;
                mdDayEnd.FieldByName('NAME').AsString   := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdDayEnd.FieldByName('TIME').AsDateTime := DataMod.OracleDataSet.FieldByName('TIME').AsDateTime;
                mdDayEnd.FieldByName('TEXT').AsString   := DataMod.OracleDataSet.FieldByName('TEXT').AsString;
                mdDayEnd.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdDayEnd.First;
        GridDayEnd.Columns[0].Footer.Value := IntToStr(record_count);
        GridDayEnd.DataSource.DataSet.EnableControls;
end;

procedure TfrmDayEnd.pnlFilterResize(Sender: TObject);
begin
	edName.Width        := pnlFilter.Width - 20;
        edPeriodBegin.Width := pnlFilter.Width - 40;
        edPeriodEnd.Width   := pnlFilter.Width - 40;
end;

procedure TfrmDayEnd.GridDayEndSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridDayEnd = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridDayEnd.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridDayEnd.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridDayEnd.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdDayEnd.SortOnFields(fields, false, desc);
end;

procedure TfrmDayEnd.edNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edName.Text) > 2) then
        	begin
                	//проверка корректности заполнени€ пол€ даты
        		if ((TryGetDate(edPeriodBegin.Text)) and (TryGetDate(edPeriodEnd.Text)))then
   				RunQuery

	        	else
        		begin
          			mdDayEnd.EmptyTable;
	                	GridDayEnd.Columns[0].Footer.Value := '0';
                        	lblError.Visible := true;
                	end;
        	end;
end;

procedure TfrmDayEnd.edPeriodBeginChange(Sender: TObject);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
        begin
                //проверка корректности заполнени€ пол€ даты
        	if ((TryGetDate(edPeriodBegin.Text)) and (TryGetDate(edPeriodEnd.Text)))then
   			RunQuery

	        else
        	begin
          		mdDayEnd.EmptyTable;
	                GridDayEnd.Columns[0].Footer.Value := '0';
                        lblError.Visible := true;
                end;
        end;
end;

end.
