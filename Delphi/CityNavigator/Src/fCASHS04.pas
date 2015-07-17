//Справка по платежам, принятым в системе ГОРОД (CASHS04)
unit fCASHS04;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  TB97, TB97Tlwn, DBGrids;

type
  TfrmCASHS04 = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edOrg: TDBEditEh;
    pnlFilterTop: TPanel;
    mdOrg: TRxMemoryData;
    dsOrg: TDataSource;
    GridOrg: TDBGridEh;
    lblOrg: TLabel;
    mdOrgID: TIntegerField;
    mdOrgNAME: TStringField;
    lblPeriod: TLabel;
    lblPeriodStart: TLabel;
    edPeriodBegin: TDBDateTimeEditEh;
    lblPeriodEnd: TLabel;
    edPeriodEnd: TDBDateTimeEditEh;
    lblError: TLabel;
    btnExecute: TButton;
    mdReport: TRxMemoryData;
    dsReport: TDataSource;
    mdReportUSERNAME: TStringField;
    mdReportORANAME: TStringField;
    mdReportPAYES: TIntegerField;
    mdReportSUM_PAY: TFloatField;
    mdReportSUM_KOMISS: TFloatField;
    mdReportSUM_TOTAL: TFloatField;
    xlReport: TxlReport;
    lblResult: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridOrgSortMarkingChanged(Sender: TObject);
    procedure edOrgKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPeriodBeginChange(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;

    //получение списка организаций
    procedure GetOrgList;
    //запрос в Оракл (организации)
    function QueryFromOracleOrg: boolean;
    //копирование данных во временную таблицу (организации)
    procedure CopyToMemoryDataOrg;

    //формирование отчета
    procedure RunReport;
    //запрос в Оракл (отчет)
    function QueryFromOracleReport: boolean;
    //копирование данных во временную таблицу (отчет)
    procedure CopyToMemoryDataReport;
  public
    fStartQuery: boolean;
  end;

var
  frmCASHS04: TfrmCASHS04;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress,
        DateUtil;

{$R *.dfm}

procedure TfrmCASHS04.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdOrg.Active    := true;
        mdReport.Active := true;
        fStartQuery     := false;

        LoadFromIni;
        lblResult.Visible  := false;
        edPeriodBegin.Text := DateToStr(Now) + ' 00:00:00';
        edPeriodEnd.Text   := DateToStr(Now) + ' 23:59:59';

        fStartQuery := true;
end;

procedure TfrmCASHS04.FormShow(Sender: TObject);
begin
	GetOrgList;
end;

procedure TfrmCASHS04.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdOrg.Active    := false;
        mdReport.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmCASHS04.LoadFromIni;
var
	sect: String;
begin
	sect := 'CASHS04';
	pnlFilter.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edOrg.Text      := OptionsIni.ReadString(sect, 'Org', '');
end;

//сохранение параметров в ini-файл
procedure TfrmCASHS04.SaveToIni;
var
	sect: String;
begin
	sect := 'CASHS04';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Org', edOrg.Text);
end;

//обновить
procedure TfrmCASHS04.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridOrg.Columns.Count - 1 do
        	GridOrg.Columns[i].Title.SortMarker := smNoneEh;
                
	GetOrgList;
end;

//получение списка организаций
procedure TfrmCASHS04.GetOrgList;
begin
	//MsgBox('GetOrgList');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracleOrg) then
	        CopyToMemoryDataOrg;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл (организации)
function TfrmCASHS04.QueryFromOracleOrg: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT SUBJ_ID'
      		+ ', NAME'
	+ ' FROM KP.ORGS');

	//указан шаблон названия организации
        if (edOrg.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' WHERE UPPER(NAME) LIKE UPPER(''%' + edOrg.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY SUBJ_ID');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fCASHS04).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (организации)
procedure TfrmCASHS04.CopyToMemoryDataOrg;
var
	record_count: integer;
begin
	GridOrg.DataSource.DataSet.DisableControls;

   	mdOrg.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdOrg.Append;
                mdOrg.FieldByName('ID').AsInteger  := DataMod.OracleDataSet.FieldByName('SUBJ_ID').AsInteger;
                mdOrg.FieldByName('NAME').AsString := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdOrg.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdOrg.First;

        if (record_count > 0) then
        	btnExecute.Enabled := true
        else
          	btnExecute.Enabled := false;

        GridOrg.Columns[0].Footer.Value := IntToStr(record_count);
        GridOrg.DataSource.DataSet.EnableControls;
end;

procedure TfrmCASHS04.pnlFilterResize(Sender: TObject);
begin
	edOrg.Width         := pnlFilter.Width - 20;
        edPeriodBegin.Width := pnlFilter.Width - 40;
        edPeriodEnd.Width   := pnlFilter.Width - 40;
end;

procedure TfrmCASHS04.GridOrgSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridOrg = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridOrg.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridOrg.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridOrg.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdOrg.SortOnFields(fields, false, desc);
end;

procedure TfrmCASHS04.edOrgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	lblError.Visible   := false;
        btnExecute.Enabled := true;

	if (fStartQuery = true) then
        	if (Key = VK_RETURN) or (Length(edOrg.Text) > 2) then
        	begin
                	//проверка корректности заполнения поля даты
        		if ((TryGetDateTime(edPeriodBegin.Text)) and (TryGetDateTime(edPeriodEnd.Text)))then
   				GetOrgList

	        	else
        		begin
          			mdOrg.EmptyTable;
	                	GridOrg.Columns[0].Footer.Value := '0';
                        	lblError.Visible   := true;
                        	btnExecute.Enabled := false;
                	end;
        	end;
end;

procedure TfrmCASHS04.edPeriodBeginChange(Sender: TObject);
begin
	lblError.Visible   := false;
        btnExecute.Enabled := true;

        //проверка корректности заполнения поля даты
        if (not (TryGetDateTime(edPeriodBegin.Text)) or not (TryGetDateTime(edPeriodEnd.Text)))then
        begin
        	lblError.Visible   := true;
                btnExecute.Enabled := false;
        end;
end;

//сформировать
procedure TfrmCASHS04.btnExecuteClick(Sender: TObject);
begin
	RunReport;
end;

//формирование отчета
procedure TfrmCASHS04.RunReport;
begin
	//MsgBox('RunReport');
	Screen.Cursor := crHourGlass;
        lblResult.Visible := true;
        lblResult.Caption := 'Формирование отчета...' + #13 +  'Пожалуйста, подождите...';
        lblResult.Refresh;

        if (QueryFromOracleReport) then
        begin
	        CopyToMemoryDataReport;
                xlReport.Params.Items[0].AsString := edPeriodBegin.Text + ' - ' + edPeriodEnd.Text;
                xlReport.Params.Items[1].AsString := mdOrg.FieldByName('NAME').AsString;
	    	ProgressReport(xlReport);
        end;

        lblResult.Visible := false;
        Screen.Cursor     := crDefault;
end;

//запрос в Оракл (отчет)
function TfrmCASHS04.QueryFromOracleReport: boolean;
var
	ppp_id: string;
begin
	result := false;

        ppp_id := mdOrg.FieldByName('ID').AsString;

        DataMod.OracleDataSet.SQL.Text := 'SELECT USERCRE_NAME'
     		+ ', ORANAME'
                + ', COUNT(SUMM) PAYS'
     		+ ', SUM(DECODE(KO, 57, 0, SUMM)) SUM_PAY'
                + ', SUM(DECODE(KO, 57, SUMM, 0)) SUM_KOMISS'
     		+ ', SUM(summ) SUM_TOTAL'
	+ ' FROM KP_REPORT.VR$CASHS02F'
	+ ' WHERE ENTRIED BETWEEN TO_DATE(''' + edPeriodBegin.Text + ''', ''DD.MM.YYYY HH24:MI:SS'') AND TO_DATE(''' + edPeriodEnd.Text + ''', ''DD.MM.YYYY HH24:MI:SS'')'
		+ ' AND OTDEL = ' + ppp_id + ''
	+ ' GROUP BY USERCRE_NAME'
       		+ ', ORANAME'
	+ ' ORDER BY USERCRE_NAME';
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fCASHS04).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу (отчет)
procedure TfrmCASHS04.CopyToMemoryDataReport;
begin
   	mdReport.EmptyTable;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdReport.Append;
                mdReport.FieldByName('USERNAME').AsString  := DataMod.OracleDataSet.FieldByName('USERCRE_NAME').AsString;
                mdReport.FieldByName('ORANAME').AsString   := DataMod.OracleDataSet.FieldByName('ORANAME').AsString;
                mdReport.FieldByName('PAYS').AsInteger     := DataMod.OracleDataSet.FieldByName('PAYS').AsInteger;
                mdReport.FieldByName('SUM_PAY').AsFloat    := DataMod.OracleDataSet.FieldByName('SUM_PAY').AsFloat;
                mdReport.FieldByName('SUM_KOMISS').AsFloat := DataMod.OracleDataSet.FieldByName('SUM_KOMISS').AsFloat;
                mdReport.FieldByName('SUM_TOTAL').AsFloat  := DataMod.OracleDataSet.FieldByName('SUM_TOTAL').AsFloat;
                mdReport.Post;
                DataMod.OracleDataSet.Next;
        end;
        DataMod.OracleDataSet.Close;
end;

end.
