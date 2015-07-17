//Справочник абонентов
unit fManualAbonent;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  RXSpin;

type
  TfrmManualAbonent = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    mdManualAbonent: TRxMemoryData;
    dsManualAbonent: TDataSource;
    GridManualAbonent: TDBGridEh;
    lblService: TLabel;
    mdManualAbonentID: TIntegerField;
    mdManualAbonentNUM: TIntegerField;
    mdManualAbonentSERVICE: TStringField;
    mdManualAbonentACC_PU: TStringField;
    mdManualAbonentFIO: TStringField;
    mdManualAbonentCITY: TStringField;
    mdManualAbonentSTREET: TStringField;
    edService: TRxSpinEdit;
    mdManualAbonentBUILDING: TStringField;
    mdManualAbonentAPARTMENT: TStringField;
    xlReport: TxlReport;
    PopupMenu: TPopupMenu;
    pmExcel: TMenuItem;
    ImageList: TImageList;
    mdManualAbonentOPEN_TIME: TDateTimeField;
    mdManualAbonentLAST_OPER_TIME: TDateTimeField;
    mdManualAbonentBALANCE_OUT: TFloatField;
    mdManualAbonentIS_ACC_CLOSE: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualAbonentSortMarkingChanged(Sender: TObject);
    procedure edServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbTypeChange(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure GridManualAbonentGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    fStartQuery: boolean;
    fColorMode : boolean;
  end;

var
  frmManualAbonent: TfrmManualAbonent;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualAbonent.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        mdManualAbonent.Active := true;
        fStartQuery            := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualAbonent.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmManualAbonent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualAbonent.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualAbonent.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualAbonet';
	pnlFilter.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edService.Value := OptionsIni.ReadFloat(sect, 'Service', 0);

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmManualAbonent.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualAbonet';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteFloat(sect, 'Service', edService.Value);
end;

//обновить
procedure TfrmManualAbonent.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualAbonent.Columns.Count - 1 do
        	GridManualAbonent.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualAbonent.AcToExcelExecute(Sender: TObject);
begin
	xlReport.Params.Items[0].AsString := edService.Text;
    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualAbonent.pmExcelClick(Sender: TObject);
begin
  	xlReport.Params.Items[0].AsString := edService.Text;
    	ProgressReport(xlReport);
end;

procedure TfrmManualAbonent.RunQuery;
begin
	if (edService.Text = '') then
        	exit;

	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmManualAbonent.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT A.ID'
       		+ ', S.NUM'
     		+ ', S.NAME AS SERVICE'
                + ', ACC.IS_ACC_CLOSE'
     		+ ', A.ACC_PU'
                + ', ACC.OPEN_TIME'
                + ', ACC.LAST_OPER_TIME'
     		+ ', A.FIO'
     		+ ', C.NAME AS CITY'
     		+ ', ST.NAME AS STREET'
                + ', A.BUILDING'
                + ', A.APARTMENT'
                + ', - ACC.BALANCE_OUT AS BALANCE_OUT'
	+ ' FROM KP.ABONENTS A'
   		+ ', KP.SERVICES S'
                + ', KP.ACCS ACC'
   		+ ', KP.CITY_LIST C'
   		+ ', KP.STREET_LIST ST'
	+ ' WHERE A.SERVICE_ID = S.ID'
        + ' AND   A.ACC_ID     = ACC.ID'
	+ ' AND   A.CITY_ID    = C.ID(+)'
	+ ' AND   A.STREET_ID  = ST.ID');

	//указан номер услуги
        if (edService.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND S.NUM = ' + edService.Text + '');

	//DataMod.OracleDataSet.SQL.Add(' ORDER BY A.FIO');
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

//копирование данных во временную таблицу
procedure TfrmManualAbonent.CopyToMemoryData;
var
	record_count: integer;
begin
	GridManualAbonent.DataSource.DataSet.DisableControls;

   	mdManualAbonent.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualAbonent.Append;
                
		if (not DataMod.OracleDataSet.FieldByName('ID').IsNull) then
                	mdManualAbonent.FieldByName('ID').AsInteger              := DataMod.OracleDataSet.FieldByName('ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('NUM').IsNull) then
                	mdManualAbonent.FieldByName('NUM').AsInteger             := DataMod.OracleDataSet.FieldByName('NUM').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('SERVICE').IsNull) then
                	mdManualAbonent.FieldByName('SERVICE').AsString          := DataMod.OracleDataSet.FieldByName('SERVICE').AsString;

                if (not DataMod.OracleDataSet.FieldByName('IS_ACC_CLOSE').IsNull) then
                	mdManualAbonent.FieldByName('IS_ACC_CLOSE').AsString     := DataMod.OracleDataSet.FieldByName('IS_ACC_CLOSE').AsString;

                if (not DataMod.OracleDataSet.FieldByName('OPEN_TIME').IsNull) then
                	mdManualAbonent.FieldByName('OPEN_TIME').AsDateTime      := DataMod.OracleDataSet.FieldByName('OPEN_TIME').AsDateTime;

                if (not DataMod.OracleDataSet.FieldByName('LAST_OPER_TIME').IsNull) then
                	mdManualAbonent.FieldByName('LAST_OPER_TIME').AsDateTime := DataMod.OracleDataSet.FieldByName('LAST_OPER_TIME').AsDateTime;

                if (not DataMod.OracleDataSet.FieldByName('ACC_PU').IsNull) then
                	mdManualAbonent.FieldByName('ACC_PU').AsString           := DataMod.OracleDataSet.FieldByName('ACC_PU').AsString;

                if (not DataMod.OracleDataSet.FieldByName('FIO').IsNull) then
                	mdManualAbonent.FieldByName('FIO').AsString              := DataMod.OracleDataSet.FieldByName('FIO').AsString;

                if (not DataMod.OracleDataSet.FieldByName('CITY').IsNull) then
                	mdManualAbonent.FieldByName('CITY').AsString             := DataMod.OracleDataSet.FieldByName('CITY').AsString;

                if (not DataMod.OracleDataSet.FieldByName('STREET').IsNull) then
                	mdManualAbonent.FieldByName('STREET').AsString           := DataMod.OracleDataSet.FieldByName('STREET').AsString;

                if (not DataMod.OracleDataSet.FieldByName('BUILDING').IsNull) then
                	mdManualAbonent.FieldByName('BUILDING').AsString         := DataMod.OracleDataSet.FieldByName('BUILDING').AsString;

                if (not DataMod.OracleDataSet.FieldByName('APARTMENT').IsNull) then
                	mdManualAbonent.FieldByName('APARTMENT').AsString        := DataMod.OracleDataSet.FieldByName('APARTMENT').AsString;

                if (not DataMod.OracleDataSet.FieldByName('BALANCE_OUT').IsNull) then
                	mdManualAbonent.FieldByName('BALANCE_OUT').AsFloat       := DataMod.OracleDataSet.FieldByName('BALANCE_OUT').AsFloat;

                mdManualAbonent.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualAbonent.First;
        GridManualAbonent.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualAbonent.DataSource.DataSet.EnableControls;
end;

procedure TfrmManualAbonent.pnlFilterResize(Sender: TObject);
begin
	edService.Width := pnlFilter.Width - 20;
end;

procedure TfrmManualAbonent.GridManualAbonentSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualAbonent = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualAbonent.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualAbonent.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualAbonent.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualAbonent.SortOnFields(fields, false, desc);
end;

procedure TfrmManualAbonent.cbTypeChange(Sender: TObject);
begin
	if (fStartQuery = true) then
     		RunQuery;
end;

procedure TfrmManualAbonent.edServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if ((fStartQuery = true) and (Key = VK_RETURN)) then
   		RunQuery;
end;

procedure TfrmManualAbonent.GridManualAbonentGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdManualAbonent.FieldByName('IS_ACC_CLOSE').AsString = 'yes') then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

end.
