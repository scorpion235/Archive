//Справочник агентов
unit fAgent;

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
  TfrmAgent = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    mdAgent: TRxMemoryData;
    dsAgent: TDataSource;
    lblAgent: TLabel;
    edAgent: TDBEditEh;
    pnlGrid: TPanel;
    GridAgent: TDBGridEh;
    RxSplitter2: TRxSplitter;
    mdAgentAGENT_ID: TIntegerField;
    mdAgentNAME: TStringField;
    pmAgent: TPopupMenu;
    pmCityAdd: TMenuItem;
    pmCityEdit: TMenuItem;
    pmCityDelete: TMenuItem;
    N1: TMenuItem;
    pmCityRefresh: TMenuItem;
    PrintGrid: TPrintDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcFilterPanelExecute(Sender: TObject);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridAgentSortMarkingChanged(Sender: TObject);
    procedure edAgentChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    fGetAgentList: boolean;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure GetAgentList;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
  public
    //выводим содержимое сетки на принтер
    procedure Print;
  end;

var
  frmAgent: TfrmAgent;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmAgent.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
        fChildInfo.Actions[childFilterPanel] := AcFilterPanelExecute;
        fChildInfo.Actions[childAdd]         := nil;
        fChildInfo.Actions[childEdit]        := nil;
        fChildInfo.Actions[childDelete]      := nil;
	fChildInfo.Actions[childRefresh]     := AcRefreshExecute;

        mdAgent.Active := true;
        fGetAgentList  := false;

        LoadFromIni;

        pnlFilter.Visible  := fChildInfo.abFilterPanelOn;
	RxSplitter.Visible := fChildInfo.abFilterPanelOn;

        fGetAgentList := true;
end;

procedure TfrmAgent.FormShow(Sender: TObject);
begin
	GetAgentList;
end;

procedure TfrmAgent.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdAgent.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmAgent.LoadFromIni;
var
	sect: string;
begin
	sect := 'Agent';
	fChildInfo.abFilterPanelOn := OptionsIni.ReadBool(sect, 'FilterPanelOn', true);
	pnlFilter.Width            := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 160);
        edAgent.Text               := OptionsIni.ReadString(sect, 'Agent', '');
end;

//сохранение параметров в ini-файл
procedure TfrmAgent.SaveToIni;
var
	sect: string;
begin
	sect := 'Agent';
	OptionsIni.WriteBool(sect, 'FilterPanelOn', fChildInfo.abFilterPanelOn);
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Agent', edAgent.Text);
end;

//панель фильтрации
procedure TfrmAgent.AcFilterPanelExecute(Sender: TObject);
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

//обновить данные
procedure TfrmAgent.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        //LoadFromIni;

        for i := 0 to GridAgent.Columns.Count - 1 do
        	GridAgent.Columns[i].Title.SortMarker := smNoneEh;

	GetAgentList;
end;

//------------------------------------------------------------------------------
//получение списка агентов
procedure TfrmAgent.GetAgentList;
begin
	//MsgBox('GetAgentList');
        if (QueryFromOracle) then
	        CopyToMemoryData;
end;

//запрос в Оракл
function TfrmAgent.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.IB_Cursor.SQL.Clear;
        DataMod.IB_Cursor.SQL.Add('SELECT AGENT_ID'
     		+ ', NAME'
	+ ' FROM AGENT_LIST'
        + ' WHERE NAME NOT LIKE ''%#%''');

	//указан шаблон названия агента
        if (edAgent.Text <> '') then
        	DataMod.IB_Cursor.SQL.Add(' AND UPPER(NAME) LIKE UPPER(''%' + edAgent.Text + '%'')');

	DataMod.IB_Cursor.SQL.Add(' ORDER BY AGENT_ID');
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении таблицы агентов.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmAgent.CopyToMemoryData;
var
	i, record_count: integer;
begin
	GridAgent.DataSource.DataSet.DisableControls;

   	mdAgent.EmptyTable;
        record_count := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdAgent.Append;
                mdAgent.FieldByName('AGENT_ID').AsInteger := DataMod.IB_Cursor.FieldByName('AGENT_ID').AsInteger;
                mdAgent.FieldByName('NAME').AsString      := DataMod.IB_Cursor.FieldByName('NAME').AsString;
                mdAgent.Post;
                DataMod.IB_Cursor.Next;
                
                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;
        mdAgent.First;

        for i := 0 to GridAgent.Columns.Count - 1 do
                if (GridAgent.Columns.Items[i].FieldName = 'AGENT_ID') then
                 	GridAgent.Columns[i].Footer.Value := IntToStr(record_count);

        GridAgent.DataSource.DataSet.EnableControls;
end;

procedure TfrmAgent.pnlFilterResize(Sender: TObject);
begin
	edAgent.Width := pnlFilter.Width - 20;
end;

procedure TfrmAgent.GridAgentSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridAgent = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridAgent.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridAgent.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridAgent.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdAgent.SortOnFields(fields, false, desc);
end;

procedure TfrmAgent.edAgentChange(Sender: TObject);
begin
	if (fGetAgentList) then
   		GetAgentList;
end;

//выводим содержимое сетки на принтер
procedure TfrmAgent.Print;
begin
	if PrintGrid.PrinterSetupDialog then
        begin
		PrintGrid.BeforeGridText.Clear;
		PrintGrid.BeforeGridText[0] := 'Агенты';
		PrintGrid.Preview;
	end;
end;

end.
