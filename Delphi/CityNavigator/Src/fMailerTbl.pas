//Рассылка на почту
unit fMailerTbl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  RtColorPicker;

type
  TfrmMailerTbl = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edDescription: TDBEditEh;
    pnlFilterTop: TPanel;
    mdMailerTbl: TRxMemoryData;
    dsMailerTbl: TDataSource;
    GridMailerTbl: TDBGridEh;
    lblDescription: TLabel;
    mdMailerTblDESCRIPTION: TStringField;
    mdMailerTblSENDER: TStringField;
    mdMailerTblRECEIVER: TStringField;
    mdMailerTblSUBJECT: TStringField;
    mdMailerTblATTACH_NAME: TStringField;
    mdMailerTblATT_SAMPLE_NAME: TStringField;
    mdMailerTblBODY_SAMPLE_NAME: TStringField;
    mdMailerTblENC: TStringField;
    mdMailerTblMAIN: TStringField;
    mdMailerTblKEY_FIELDS: TStringField;
    mdMailerTblKEY_VALUES: TStringField;
    mdMailerTblCONST_FIELDS: TStringField;
    mdMailerTblCONST_VALUES: TStringField;
    mdMailerTblINTERVAL: TIntegerField;
    mdMailerTblSEND_EMPTY: TStringField;
    mdMailerTblPOSTEXEC: TStringField;
    mdMailerTblLOCKED: TStringField;
    mdMailerTblORD: TIntegerField;
    mdMailerTblNOTE: TStringField;
    mdMailerTblTHREAD: TIntegerField;
    lblSender: TLabel;
    edSender: TDBEditEh;
    lblReceiver: TLabel;
    edReceiver: TDBEditEh;
    mdMailerTblLASTTIME: TDateTimeField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridMailerTblSortMarkingChanged(Sender: TObject);
    procedure GridMailerTblGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure edDescriptionChange(Sender: TObject);
    procedure edDescriptionKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSenderKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edReceiverKeyUp(Sender: TObject; var Key: Word;
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
    fColorMode : boolean;
  end;

var
  frmMailerTbl: TfrmMailerTbl;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmMailerTbl.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdMailerTbl.Active := true;
        fStartQuery        := false;

        LoadFromIni;

        fStartQuery := true;
end;

procedure TfrmMailerTbl.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmMailerTbl.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdMailerTbl.Active := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmMailerTbl.LoadFromIni;
var
	sect: String;
begin
	sect := 'MailerTbl';
	pnlFilter.Width    := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edDescription.Text := OptionsIni.ReadString(sect, 'Description', '');
        edSender.Text      := OptionsIni.ReadString(sect, 'Sender', '');
        edReceiver.Text    := OptionsIni.ReadString(sect, 'Receiver', '');

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmMailerTbl.SaveToIni;
var
	sect: String;
begin
	sect := 'MailerTbl';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Description', edDescription.Text);
	OptionsIni.WriteString(sect, 'Sender', edSender.Text);
        OptionsIni.WriteString(sect, 'Receiver', edReceiver.Text);
end;

//обновить
procedure TfrmMailerTbl.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridMailerTbl.Columns.Count - 1 do
        	GridMailerTbl.Columns[i].Title.SortMarker := smNoneEh;
                
	RunQuery;
end;

procedure TfrmMailerTbl.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;
        if (QueryFromOracle) then
	        CopyToMemoryData;
        Screen.Cursor := crDefault;
end;

//запрос в Оракл
function TfrmMailerTbl.QueryFromOracle: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;

        DataMod.OracleDataSet.SQL.Add('SELECT DESCRIPTION'
     		+ ', SENDER'
     		+ ', RECEIVER'
     		+ ', SUBJECT'
     		+ ', ATTACH_NAME'
     		+ ', ATT_SAMPLE_NAME'
     		+ ', BODY_SAMPLE_NAME'
     		+ ', ENC'
     		+ ', MAIN'
     		+ ', KEY_FIELDS'
     		+ ', KEY_VALUES'
     		+ ', CONST_FIELDS'
     		+ ', CONST_VALUES'
     		+ ', LASTTIME'
     		+ ', INTERVAL'
     		+ ', SEND_EMPTY'
     		+ ', POSTEXEC'
     		+ ', LOCKED'
     		+ ', ORD'
     		+ ', NOTE'
     		+ ', THREAD'
	+ ' FROM KP.INV$MAILER_TBL'
        + ' WHERE RECEIVER IS NOT NULL'); // <-- выполняется всегда

        //выбрано Description
        if (edDescription.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(DESCRIPTION) LIKE UPPER(''%' + edDescription.Text + '%'')');

        //выбрано Sender
        if (edSender.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(SENDER) LIKE UPPER(''%' + edSender.Text + '%'')');

        //выбрано Receiver
        if (edReceiver.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND UPPER(RECEIVER) LIKE UPPER(''%' + edReceiver.Text + '%'')');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY DESCRIPTION');
        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fMailerTbl).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        result := true;
end;

//копирование данных во временную таблицу
procedure TfrmMailerTbl.CopyToMemoryData;
var
	record_count: integer;
begin
	GridMailerTbl.DataSource.DataSet.DisableControls;

   	mdMailerTbl.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdMailerTbl.Append;

                if (not DataMod.OracleDataSet.FieldByName('DESCRIPTION').IsNull) then
                	mdMailerTbl.FieldByName('DESCRIPTION').AsString       := DataMod.OracleDataSet.FieldByName('DESCRIPTION').AsString;

                if (not DataMod.OracleDataSet.FieldByName('SENDER').IsNull) then
                	mdMailerTbl.FieldByName('SENDER').AsString            := DataMod.OracleDataSet.FieldByName('SENDER').AsString;

                if (not DataMod.OracleDataSet.FieldByName('RECEIVER').IsNull) then
                	mdMailerTbl.FieldByName('RECEIVER').AsString          := DataMod.OracleDataSet.FieldByName('RECEIVER').AsString;

                if (not DataMod.OracleDataSet.FieldByName('SUBJECT').IsNull) then
                	mdMailerTbl.FieldByName('SUBJECT').AsString           := DataMod.OracleDataSet.FieldByName('SUBJECT').AsString;

                if (not DataMod.OracleDataSet.FieldByName('ATTACH_NAME').IsNull) then
                	mdMailerTbl.FieldByName('ATTACH_NAME').AsString       := DataMod.OracleDataSet.FieldByName('ATTACH_NAME').AsString;

                if (not DataMod.OracleDataSet.FieldByName('ATT_SAMPLE_NAME').IsNull) then
                	mdMailerTbl.FieldByName('ATT_SAMPLE_NAME').AsString   := DataMod.OracleDataSet.FieldByName('ATT_SAMPLE_NAME').AsString;

                if (not DataMod.OracleDataSet.FieldByName('BODY_SAMPLE_NAME').IsNull) then
                	mdMailerTbl.FieldByName('BODY_SAMPLE_NAME').AsString  := DataMod.OracleDataSet.FieldByName('BODY_SAMPLE_NAME').AsString;

                if (not DataMod.OracleDataSet.FieldByName('ENC').IsNull) then
                	mdMailerTbl.FieldByName('ENC').AsString               := DataMod.OracleDataSet.FieldByName('ENC').AsString;

                if (not DataMod.OracleDataSet.FieldByName('MAIN').IsNull) then
                	mdMailerTbl.FieldByName('MAIN').AsString              := DataMod.OracleDataSet.FieldByName('MAIN').AsString;

                if (not DataMod.OracleDataSet.FieldByName('KEY_FIELDS').IsNull) then
                	mdMailerTbl.FieldByName('KEY_FIELDS').AsString        := DataMod.OracleDataSet.FieldByName('KEY_FIELDS').AsString;

                if (not DataMod.OracleDataSet.FieldByName('KEY_VALUES').IsNull) then
                	mdMailerTbl.FieldByName('KEY_VALUES').AsString        := DataMod.OracleDataSet.FieldByName('KEY_VALUES').AsString;

                if (not DataMod.OracleDataSet.FieldByName('CONST_FIELDS').IsNull) then
     			mdMailerTbl.FieldByName('CONST_FIELDS').AsString      := DataMod.OracleDataSet.FieldByName('CONST_FIELDS').AsString;

                if (not DataMod.OracleDataSet.FieldByName('CONST_VALUES').IsNull) then
     			mdMailerTbl.FieldByName('CONST_VALUES').AsString      := DataMod.OracleDataSet.FieldByName('CONST_VALUES').AsString;

                if (not DataMod.OracleDataSet.FieldByName('LASTTIME').IsNull) then
     			mdMailerTbl.FieldByName('LASTTIME').AsDateTime        := DataMod.OracleDataSet.FieldByName('LASTTIME').AsDateTime;

                if (not DataMod.OracleDataSet.FieldByName('INTERVAL').IsNull) then
     			mdMailerTbl.FieldByName('INTERVAL').AsInteger         := DataMod.OracleDataSet.FieldByName('INTERVAL').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('SEND_EMPTY').IsNull) then
     			mdMailerTbl.FieldByName('SEND_EMPTY').AsString        := DataMod.OracleDataSet.FieldByName('SEND_EMPTY').AsString;

                if (not DataMod.OracleDataSet.FieldByName('POSTEXEC').IsNull) then
     			mdMailerTbl.FieldByName('POSTEXEC').AsString          := DataMod.OracleDataSet.FieldByName('POSTEXEC').AsString;

                if (not DataMod.OracleDataSet.FieldByName('LOCKED').IsNull) then
     			mdMailerTbl.FieldByName('LOCKED').AsString            := DataMod.OracleDataSet.FieldByName('LOCKED').AsString;

                if (not DataMod.OracleDataSet.FieldByName('ORD').IsNull) then
     			mdMailerTbl.FieldByName('ORD').AsInteger              := DataMod.OracleDataSet.FieldByName('ORD').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('NOTE').IsNull) then
     			mdMailerTbl.FieldByName('NOTE').AsString              := DataMod.OracleDataSet.FieldByName('NOTE').AsString;

                if (not DataMod.OracleDataSet.FieldByName('THREAD').IsNull) then
     			mdMailerTbl.FieldByName('THREAD').AsInteger           := DataMod.OracleDataSet.FieldByName('THREAD').AsInteger;

                mdMailerTbl.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdMailerTbl.First;
        GridMailerTbl.Columns[0].Footer.Value := IntToStr(record_count);
        GridMailerTbl.DataSource.DataSet.EnableControls;
end;

procedure TfrmMailerTbl.pnlFilterResize(Sender: TObject);
begin
	edDescription.Width := pnlFilter.Width - 20;
        edSender.Width      := pnlFilter.Width - 20;
        edReceiver.Width    := pnlFilter.Width - 20;
end;

procedure TfrmMailerTbl.GridMailerTblSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridMailerTbl = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridMailerTbl.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridMailerTbl.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridMailerTbl.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdMailerTbl.SortOnFields(fields, false, desc);
end;

procedure TfrmMailerTbl.GridMailerTblGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if (mdMailerTbl.FieldByName('LOCKED').AsString = 'Y') then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmMailerTbl.edDescriptionChange(Sender: TObject);
begin
	if (fStartQuery = true) then
   		RunQuery;
end;

procedure TfrmMailerTbl.edDescriptionKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edDescription.Text) > 2) then
                	RunQuery;
end;

procedure TfrmMailerTbl.edSenderKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edSender.Text) > 2) then
                	RunQuery;
end;

procedure TfrmMailerTbl.edReceiverKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	if (fStartQuery = true) then
		if (Key = VK_RETURN) or (Length(edReceiver.Text) > 2) then
                	RunQuery;
end;

end.
