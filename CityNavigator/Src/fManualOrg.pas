//Справочник организаций
unit fManualOrg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmManualOrg = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edOrg: TDBEditEh;
    pnlFilterTop: TPanel;
    mdManualOrg: TRxMemoryData;
    dsManualOrg: TDataSource;
    GridManualOrg: TDBGridEh;
    lblOrg: TLabel;
    xlReport: TxlReport;
    PopupMenu: TPopupMenu;
    ImageList: TImageList;
    pmExcel: TMenuItem;
    mdManualOrgID: TIntegerField;
    mdManualOrgPOST_ID: TStringField;
    mdManualOrgPOST_VER: TStringField;
    mdManualOrgNAME: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure AcToExcelExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridManualOrgSortMarkingChanged(Sender: TObject);
    procedure pmExcelClick(Sender: TObject);
    procedure edOrgKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
  end;

var
  frmManualOrg: TfrmManualOrg;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmManualOrg.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;
        fChildInfo.Actions[childToExcel] := AcToExcelExecute;

        mdManualOrg.Active := true;
        fStartQuery        := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmManualOrg.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmManualOrg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdManualOrg.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmManualOrg.LoadFromIni;
var
	sect: String;
begin
	sect := 'ManualOrg';
	pnlFilter.Width := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edOrg.Text      := OptionsIni.ReadString(sect, 'Org', '');
end;

//сохранение параметров в ini-файл
procedure TfrmManualOrg.SaveToIni;
var
	sect: String;
begin
	sect := 'ManualOrg';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Org', edOrg.Text);
end;

//обновить
procedure TfrmManualOrg.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridManualOrg.Columns.Count - 1 do
        	GridManualOrg.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

//экспорт в Excel (Отчет > Экспорт в Excel)
procedure TfrmManualOrg.AcToExcelExecute(Sender: TObject);
begin
	xlReport.Params.Items[0].AsString := edOrg.Text;
    	ProgressReport(xlReport);
end;

//экспорт в Excel (из меню грида)
procedure TfrmManualOrg.pmExcelClick(Sender: TObject);
begin
  	xlReport.Params.Items[0].AsString := edOrg.Text;
    	ProgressReport(xlReport);
end;

procedure TfrmManualOrg.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmManualOrg.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT SUBJ_ID'
     		+ ', POST_ID'
        	+ ', POST_VER'
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
        	WarningBox('Ошибка выполнения запроса (fManualOrg).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmManualOrg.CopyToMemoryData;
var
	record_count: integer;
begin
	GridManualOrg.DataSource.DataSet.DisableControls;

   	mdManualOrg.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdManualOrg.Append;
                mdManualOrg.FieldByName('ID').AsInteger      := DataMod.OracleDataSet.FieldByName('SUBJ_ID').AsInteger;
                mdManualOrg.FieldByName('POST_ID').AsString  := DataMod.OracleDataSet.FieldByName('POST_ID').AsString;
                mdManualOrg.FieldByName('POST_VER').AsString := DataMod.OracleDataSet.FieldByName('POST_VER').AsString;
                mdManualOrg.FieldByName('NAME').AsString     := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdManualOrg.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdManualOrg.First;
        GridManualOrg.Columns[0].Footer.Value := IntToStr(record_count);
        GridManualOrg.DataSource.DataSet.EnableControls;
end;

procedure TfrmManualOrg.pnlFilterResize(Sender: TObject);
begin
	edOrg.Width := pnlFilter.Width - 20;
end;

procedure TfrmManualOrg.GridManualOrgSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridManualOrg = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridManualOrg.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridManualOrg.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridManualOrg.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdManualOrg.SortOnFields(fields, false, desc);
end;

procedure TfrmManualOrg.edOrgKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edOrg.Text) > 2) then
                	RunQuery;
end;

end.
