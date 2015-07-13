//Архив реестров
unit fReeArc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmReeArc = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edService: TDBEditEh;
    pnlFilterTop: TPanel;
    mdReeArc: TRxMemoryData;
    dsReeArc: TDataSource;
    GridReeArc: TDBGridEh;
    lblService: TLabel;
    lblPeriod: TLabel;
    lblPeriodStart: TLabel;
    edPeriodBegin: TDBDateTimeEditEh;
    edPeriodEnd: TDBDateTimeEditEh;
    lblPeriodEnd: TLabel;
    lblError: TLabel;
    mdReeArcID: TIntegerField;
    mdReeArcREE_NUM: TIntegerField;
    mdReeArcORG: TStringField;
    mdReeArcGOTB: TDateTimeField;
    mdReeArcSERVICE: TStringField;
    mdReeArcDIRECT: TStringField;
    mdReeArcTYPE: TStringField;
    mdReeArcSTATUS: TStringField;
    mdReeArcRECCOUNT: TIntegerField;
    mdReeArcGOTREC: TIntegerField;
    mdReeArcSUMM: TFloatField;
    cbType: TDBComboBoxEh;
    lblType: TLabel;
    lblStatus: TLabel;
    cbStatus: TDBComboBoxEh;
    ImageList: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridReeArcSortMarkingChanged(Sender: TObject);
    procedure edServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridReeArcGetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure edServiceChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure SetTypeList(cb: TDBComboBoxEh);
    procedure SetStatusList(cb: TDBComboBoxEh);
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
  frmReeArc: TfrmReeArc;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmReeArc.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdReeArc.Active := true;
        fStartQuery     := false;

        SetTypeList(cbType);
        SetStatusList(cbStatus);

        LoadFromIni;
        
        edPeriodBegin.Text := DateToStr(Now) + ' 00:00:00';
        edPeriodEnd.Text   := DateToStr(Now) + ' 23:59:59';

        fStartQuery := true;
end;

procedure TfrmReeArc.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmReeArc.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdReeArc.Active := false;
	Action := caFree;
end;

//задание списка типов реестров
procedure TfrmReeArc.SetTypeList(cb: TDBComboBoxEh);
begin
	DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(NAME)'
	+ ' FROM KP.REE$TYPES'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fReeArc).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все типы]');
        cb.KeyItems.Add('[Все типы]');
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
end;

//задание списка статусов реестров
procedure TfrmReeArc.SetStatusList(cb: TDBComboBoxEh);
begin
	DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Text := 'SELECT DISTINCT(NAME)'
	+ ' FROM KP.REE$STATUS'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fReeArc).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[Все статусы]');
        cb.KeyItems.Add('[Все статусы]');
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	cb.Items.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.OracleDataSet.FieldByName('NAME').AsString);
                DataMod.OracleDataSet.Next;
        end;

        DataMod.OracleDataSet.Close;
end;
//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmReeArc.LoadFromIni;
var
	sect: String;
begin
	sect := 'ReeArc';
	pnlFilter.Width    := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edService.Text     := OptionsIni.ReadString(sect, 'Service', '');
        cbType.ItemIndex   := OptionsIni.ReadInteger(sect, 'TypeItem', 0);
        cbStatus.ItemIndex := OptionsIni.ReadInteger(sect, 'StatusItem', 0);

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmReeArc.SaveToIni;
var
	sect: String;
begin
	sect := 'ReeArc';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Service', edService.Text);
        OptionsIni.WriteInteger(sect, 'TypeItem', cbType.ItemIndex);
        OptionsIni.WriteInteger(sect, 'StatusItem', cbStatus.ItemIndex);
end;

//обновить
procedure TfrmReeArc.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridReeArc.Columns.Count - 1 do
        	GridReeArc.Columns[i].Title.SortMarker := smNoneEh;

	RunQuery;
end;

procedure TfrmReeArc.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmReeArc.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT a.ID'
     		+ ', a.NUM AS REE_NUM'
     		+ ', o.NAME AS ORG'
		+ ', a.GOTB'
                + ', serv.NUM||'' - ''||serv.NAME AS SERVICE'
     		+ ', t.DIRECT'
     		+ ', t.NAME AS TYPE'
                + ', a.STATUS AS REE_STATUS'
     		+ ', s.NAME AS STATUS'
     		+ ', a.RECCOUNT'
                + ', a.GOTREC'
     		+ ', a.SUMM'
	+ ' FROM KP.REE$REEARC a'
   		+ ', KP.ORGS o'
   		+ ', KP.REE$TYPES t'
   		+ ', KP.REE$STATUS s'
   		+ ', KP.AGRS agr'
   		+ ', KP.SERVICES serv'
	+ ' WHERE a.ORGID              = o.SUBJ_ID'
		+ ' AND a.STATUS       = s.ID'
		+ ' AND a.TYPE         = t.ID'
		+ ' AND a.AGRID        = agr.ID'
		+ ' AND agr.SERVICE_ID = serv.ID'
		+ ' AND a.GOTB BETWEEN TO_DATE(''' + edPeriodBegin.Text + ''', ''DD.MM.YYYY HH24:MI:SS'') AND TO_DATE(''' + edPeriodEnd.Text + ''', ''DD.MM.YYYY HH24:MI:SS'')');

        //выбрана услуга
        if (edService.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND serv.NUM||'' - ''||serv.NAME LIKE UPPER(''%' + edService.Text + '%'')');

        //выбран тип реестра
        if (cbType.ItemIndex <> 0) then
	        DataMod.OracleDataSet.SQL.Add(' AND t.NAME = ''' + cbType.Text + '''');

        //выбран статус реестра
        if (cbStatus.ItemIndex <> 0) then
	        DataMod.OracleDataSet.SQL.Add(' AND s.NAME = ''' + cbStatus.Text + '''');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY a.ID');

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fReeArc).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmReeArc.CopyToMemoryData;
var
	record_count,
        error_ree: integer;
begin
	GridReeArc.DataSource.DataSet.DisableControls;
        GridReeArc.Columns[2].Footer.Value := '';

   	mdReeArc.EmptyTable;
        record_count := 0;
        error_ree    := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdReeArc.Append;
                mdReeArc.FieldByName('ID').AsInteger       := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdReeArc.FieldByName('REE_NUM').AsInteger  := DataMod.OracleDataSet.FieldByName('REE_NUM').AsInteger;
                mdReeArc.FieldByName('ORG').AsString       := DataMod.OracleDataSet.FieldByName('ORG').AsString;
                mdReeArc.FieldByName('GOTB').AsDateTime    := DataMod.OracleDataSet.FieldByName('GOTB').AsDateTime;
                mdReeArc.FieldByName('SERVICE').AsString   := DataMod.OracleDataSet.FieldByName('SERVICE').AsString;
                mdReeArc.FieldByName('DIRECT').AsString    := DataMod.OracleDataSet.FieldByName('DIRECT').AsString;
                mdReeArc.FieldByName('TYPE').AsString      := DataMod.OracleDataSet.FieldByName('TYPE').AsString;
                mdReeArc.FieldByName('STATUS').AsString    := DataMod.OracleDataSet.FieldByName('STATUS').AsString;
                mdReeArc.FieldByName('RECCOUNT').AsInteger := DataMod.OracleDataSet.FieldByName('RECCOUNT').AsInteger;
                mdReeArc.FieldByName('GOTREC').AsInteger   := DataMod.OracleDataSet.FieldByName('GOTREC').AsInteger;
                mdReeArc.FieldByName('SUMM').AsFloat       := DataMod.OracleDataSet.FieldByName('SUMM').AsFloat;

                //разобран или разобран с ошибками
                if ((DataMod.OracleDataSet.FieldByName('REE_STATUS').AsInteger = 5) or (DataMod.OracleDataSet.FieldByName('REE_STATUS').AsInteger = 6)) then
                 	inc(error_ree);

                mdReeArc.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdReeArc.First;

        if (error_ree > 0) then
          	GridReeArc.Columns[2].Footer.Value := format('%d рестра(ов) в состоянии "разобран (с ошибками)"', [error_ree]);

        GridReeArc.Columns[0].Footer.Value := IntToStr(record_count);
        GridReeArc.DataSource.DataSet.EnableControls;
end;

procedure TfrmReeArc.pnlFilterResize(Sender: TObject);
begin
	edService.Width     := pnlFilter.Width - 20;
        cbType.Width        := pnlFilter.Width - 20;
        cbStatus.Width      := pnlFilter.Width - 20;
        edPeriodBegin.Width := pnlFilter.Width - 40;
        edPeriodEnd.Width   := pnlFilter.Width - 40;
end;

procedure TfrmReeArc.GridReeArcSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridReeArc = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridReeArc.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridReeArc.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridReeArc.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdReeArc.SortOnFields(fields, false, desc);
end;

procedure TfrmReeArc.edServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edService.Text) > 2) then
        	begin
                	//проверка корректности заполнения поля даты
        		if ((TryGetDateTime(edPeriodBegin.Text)) and (TryGetDateTime(edPeriodEnd.Text)))then
   				RunQuery

	        	else
        		begin
          			mdReeArc.EmptyTable;
	                	GridReeArc.Columns[0].Footer.Value := '0';
                        	lblError.Visible := true;
                	end;
        	end;
end;



procedure TfrmReeArc.GridReeArcGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if ((mdReeArc.FieldByName('STATUS').AsString = 'Разобран') or (mdReeArc.FieldByName('STATUS').AsString = 'Разобран с ошибками')) then
		Background := $00FFC4C4;
end;

procedure TfrmReeArc.edServiceChange(Sender: TObject);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
        begin
                //проверка корректности заполнения поля даты
        	if ((TryGetDateTime(edPeriodBegin.Text)) and (TryGetDateTime(edPeriodEnd.Text)))then
   			RunQuery

	        else
        	begin
          		mdReeArc.EmptyTable;
	                GridReeArc.Columns[0].Footer.Value := '0';
                        lblError.Visible := true;
                end;
        end;
end;

end.
