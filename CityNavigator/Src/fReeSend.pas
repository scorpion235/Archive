//Посылка реестров
unit fReeSend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList;

type
  TfrmReeSend = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    pnlFilterTop: TPanel;
    mdReeSend: TRxMemoryData;
    dsReeSend: TDataSource;
    GridReeSend: TDBGridEh;
    lblService: TLabel;
    mdReeSendID: TIntegerField;
    mdReeSendNUM: TIntegerField;
    mdReeSendNAME: TStringField;
    mdReeSendTYPE: TStringField;
    edService: TDBEditEh;
    lblPeriod: TLabel;
    lblPeriodStart: TLabel;
    edPeriodBegin: TDBDateTimeEditEh;
    lblPeriodEnd: TLabel;
    edPeriodEnd: TDBDateTimeEditEh;
    lblError: TLabel;
    btnExecute: TButton;
    lblResult: TLabel;
    cbService: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridReeSendSortMarkingChanged(Sender: TObject);
    procedure edServiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPeriodBeginChange(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure cbServiceClick(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //запрос в Оракл
    function QueryFromOracle: boolean;
    //копирование данных во временную таблицу
    procedure CopyToMemoryData;
    //отправка реестров
    procedure ReeSend;
  public
    fStartQuery: boolean;
  end;

var
  frmReeSend: TfrmReeSend;

implementation

uses
	dmCityNavigator,
        uCommon,
        fProgress;

{$R *.dfm}

procedure TfrmReeSend.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdReeSend.Active := true;
        fStartQuery      := false;

        LoadFromIni;
        lblResult.Visible  := false;
        //edPeriodBegin.Text := DateToStr(Now - 1);
        //edPeriodEnd.Text   := DateToStr(Now);

        fStartQuery := true;
end;

procedure TfrmReeSend.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmReeSend.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdReeSend.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmReeSend.LoadFromIni;
var
	sect: String;
begin
	sect := 'ReeSend';
	pnlFilter.Width    := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edService.Text     := OptionsIni.ReadString(sect, 'Service', '');
        edPeriodBegin.Text := OptionsIni.ReadString(sect, 'PeriodBegin', DateToStr(Now - 1));
        edPeriodEnd.Text   := OptionsIni.ReadString(sect, 'PeriodEnd',  DateToStr(Now));
        cbService.Checked  := OptionsIni.ReadBool(sect, 'AllService', false);
end;

//сохранение параметров в ini-файл
procedure TfrmReeSend.SaveToIni;
var
	sect: String;
begin
	sect := 'ReeSend';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Service', edService.Text);
        OptionsIni.WriteString(sect, 'PeriodBegin', edPeriodBegin.Text);
        OptionsIni.WriteString(sect, 'PeriodEnd', edPeriodEnd.Text);
        OptionsIni.WriteBool(sect, 'AllService', cbService.Checked);
end;

//обновить
procedure TfrmReeSend.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridReeSend.Columns.Count - 1 do
        	GridReeSend.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

procedure TfrmReeSend.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmReeSend.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT S.ID'
     		+ ', S.NUM'
     		+ ', S.NAME'
     		+ ', T.NAME AS TYPE'
	+ ' FROM KP.SERVICES S'
   		+ ', KP.SERV_TYPES T'
	+ ' WHERE S.TYPE = T.TYPE');

	//указан шаблон названия услуги
        if (edService.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(S.NAME) LIKE UPPER(''%' + edService.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY S.ID');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fReeSend).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmReeSend.CopyToMemoryData;
var
	record_count: integer;
begin
	GridReeSend.DataSource.DataSet.DisableControls;

   	mdReeSend.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdReeSend.Append;
                mdReeSend.FieldByName('ID').AsInteger  := DataMod.OracleDataSet.FieldByName('ID').AsInteger;
                mdReeSend.FieldByName('NUM').AsInteger := DataMod.OracleDataSet.FieldByName('NUM').AsInteger;
                mdReeSend.FieldByName('NAME').AsString := DataMod.OracleDataSet.FieldByName('NAME').AsString;
                mdReeSend.FieldByName('TYPE').AsString := DataMod.OracleDataSet.FieldByName('TYPE').AsString;
                mdReeSend.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdReeSend.First;

        if (record_count > 0) then
        	btnExecute.Enabled := true
        else
          	btnExecute.Enabled := false;

        GridReeSend.Columns[0].Footer.Value := IntToStr(record_count);
        GridReeSend.DataSource.DataSet.EnableControls;
end;

procedure TfrmReeSend.pnlFilterResize(Sender: TObject);
begin
	edService.Width     := pnlFilter.Width - 20;
        edPeriodBegin.Width := pnlFilter.Width - 40;
        edPeriodEnd.Width   := pnlFilter.Width - 40;
end;

procedure TfrmReeSend.GridReeSendSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridReeSend = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridReeSend.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridReeSend.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridReeSend.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdReeSend.SortOnFields(fields, false, desc);
end;

procedure TfrmReeSend.edServiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edService.Text) > 2) then
        	begin
                	//проверка корректности заполнения поля даты
        		if ((TryGetDate(edPeriodBegin.Text)) and (TryGetDate(edPeriodEnd.Text)))then
   				RunQuery

	        	else
        		begin
          			mdReeSend.EmptyTable;
	                	GridReeSend.Columns[0].Footer.Value := '0';
                        	lblError.Visible   := true;
                        	btnExecute.Enabled := false;
                	end;
        	end;
end;

procedure TfrmReeSend.edPeriodBeginChange(Sender: TObject);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
        begin
                //проверка корректности заполнения поля даты
        	if ((TryGetDate(edPeriodBegin.Text)) and (TryGetDate(edPeriodEnd.Text)))then
   			RunQuery

	        else
        	begin
          		mdReeSend.EmptyTable;
	                GridReeSend.Columns[0].Footer.Value := '0';
                        lblError.Visible   := true;
                        btnExecute.Enabled := false;
                end;
        end;
end;

//отправить
procedure TfrmReeSend.btnExecuteClick(Sender: TObject);
var
	msg: string;
begin
	msg := format('Отправить реестры%sc %s по %s%s', [#13, edPeriodBegin.Text, edPeriodEnd.Text, #13]);

        if (cbService.Checked) then
        	msg := msg + 'по всем услугам?'
        else msg := msg + format('по услуге "%s" (%d)?', [mdReeSend.FieldByName('NAME').AsString, mdReeSend.FieldByName('NUM').AsInteger]);

        msg := msg + format('%s%sВнимание, оправляются ТОЛЬКО реестры%sбез подтверждения получения!', [#13, #13, #13]);

	if (YesNoBox(msg) = mrYes) then
		ReeSend;
end;

//отправка реестров
procedure TfrmReeSend.ReeSend;
var
	service_num: double;
begin
	//MsgBox('ReeSend');
	Screen.Cursor := crHourGlass;
        lblResult.Visible := true;
        lblResult.Caption := 'Отправка реестров...' + #13 +  'Пожалуйста, подождите...';
        lblResult.Refresh;

        if (cbService.Checked) then
         	service_num := -0.5
        else
	        service_num := mdReeSend.FieldByName('NUM').AsInteger;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('DECLARE'
        + ' n NUMBER;'
	+ ' BEGIN'
        + ' n := INV_KPADM.PK_REE.REE_SEND(''' + edPeriodBegin.Text + ''',''' + edPeriodEnd.Text + ''', ' + FloatToStr(service_num) + ');'
	+ ' END;');

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fReeSend).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        lblResult.Visible := false;
        Screen.Cursor     := crDefault;

        MsgBox('Реестры успешно отправлены.')
end;

procedure TfrmReeSend.cbServiceClick(Sender: TObject);
begin
	edService.Enabled := not cbService.Checked;
end;

end.
