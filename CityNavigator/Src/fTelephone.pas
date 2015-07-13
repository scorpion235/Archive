//Оплаты за сотовый телефон
unit fTelephone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrlsEh, Grids, DBGridEh, RXSplit, ExtCtrls,
  DB, RxMemDS, uChild, Menus, xlcClasses, xlEngine, xlReport, ImgList,
  ComCtrls;

type
  TfrmTelephone = class(TForm)
    pnlFilter: TPanel;
    RxSplitter: TRxSplitter;
    edTelephone: TDBEditEh;
    pnlFilterTop: TPanel;
    dsTelephoneINV_BILLING: TDataSource;
    lblTelephone: TLabel;
    lblPeriod: TLabel;
    lblPeriodStart: TLabel;
    edPeriodBegin: TDBDateTimeEditEh;
    lblPeriodEnd: TLabel;
    edPeriodEnd: TDBDateTimeEditEh;
    lblError: TLabel;
    pcGreeds: TPageControl;
    tsINV_BILLING: TTabSheet;
    tsBM: TTabSheet;
    GridTelephoneBM: TDBGridEh;
    mdTelephoneBM: TRxMemoryData;
    dsTelephoneBM: TDataSource;
    mdTelephoneBMREQ_ID: TIntegerField;
    mdTelephoneBMREQ_STATE: TIntegerField;
    mdTelephoneBMREQ_STAMP: TIntegerField;
    mdTelephoneBMANS_STAMP: TIntegerField;
    mdTelephoneBMUNO_STAMP: TIntegerField;
    mdTelephoneBMLSID: TIntegerField;
    mdTelephoneBMREQ_TYPE: TIntegerField;
    mdTelephoneBMRESULT: TIntegerField;
    mdTelephoneBMERRMSG: TStringField;
    mdTelephoneBMOPER_TYPE: TIntegerField;
    mdTelephoneBMPPP_ID: TIntegerField;
    mdTelephoneBMUSER_ID: TIntegerField;
    mdTelephoneBMPROG_ID: TIntegerField;
    mdTelephoneBMAGENT_ID: TIntegerField;
    mdTelephoneBMPRV_ID: TIntegerField;
    mdTelephoneBMUNO: TFloatField;
    mdTelephoneBMSRVNUM: TIntegerField;
    mdTelephoneBMACC_PU: TStringField;
    mdTelephoneBMSUMM: TFloatField;
    mdTelephoneBMOUTP: TStringField;
    mdTelephoneBMINP: TStringField;
    mdTelephoneBMREQ_DATE: TDateTimeField;
    mdTelephoneINV_BILLING: TRxMemoryData;
    IntegerField1: TIntegerField;
    IntegerField2: TIntegerField;
    DateTimeField1: TDateTimeField;
    IntegerField6: TIntegerField;
    IntegerField7: TIntegerField;
    IntegerField8: TIntegerField;
    StringField1: TStringField;
    IntegerField9: TIntegerField;
    FloatField1: TFloatField;
    IntegerField10: TIntegerField;
    IntegerField11: TIntegerField;
    IntegerField12: TIntegerField;
    IntegerField13: TIntegerField;
    IntegerField14: TIntegerField;
    IntegerField15: TIntegerField;
    StringField2: TStringField;
    FloatField2: TFloatField;
    StringField3: TStringField;
    StringField4: TStringField;
    mdTelephoneINV_BILLINGREQ_AG_ID: TStringField;
    mdTelephoneINV_BILLINGAG_UNO: TStringField;
    mdTelephoneINV_BILLINGREQ_PR_ID: TStringField;
    mdTelephoneINV_BILLINGPR_UNO: TStringField;
    mdTelephoneINV_BILLINGBILLING_AGENT_ID: TFloatField;
    mdTelephoneINV_BILLINGPARTNER_AG_ID: TFloatField;
    mdTelephoneINV_BILLINGINNER_ERR_ID: TFloatField;
    mdTelephoneINV_BILLINGBILLING_ERR_CODE: TStringField;
    mdTelephoneINV_BILLINGSUMM_COMISS: TFloatField;
    mdTelephoneINV_BILLINGPAY_SYSTEM_ID: TFloatField;
    GridTelephoneINV_BILLING: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcRefreshExecute(Sender: TObject);
    procedure pnlFilterResize(Sender: TObject);
    procedure GridTelephoneINV_BILLINGSortMarkingChanged(Sender: TObject);
    procedure GridTelephoneBMSortMarkingChanged(Sender: TObject);
    procedure GridTelephoneBMGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure GridTelephoneINV_BILLINGGetCellParams(Sender: TObject;
      Column: TColumnEh; AFont: TFont; var Background: TColor;
      State: TGridDrawState);
    procedure edTelephoneKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPeriodBeginChange(Sender: TObject);
    procedure pcGreedsChange(Sender: TObject);
  private
    fChildInfo: PChildInfo;
    procedure LoadFromIni;
    procedure SaveToIni;
    procedure RunQuery;
    //запрос в Оракл (INV_BILLING)
    function QueryFromOracleINV_BILLING: boolean;
    //копирование данных во временную таблицу (INV_BILLING)
    procedure CopyToMemoryDataINV_BILLING;
    //запрос в Оракл (BM)
    function QueryFromOracleBM: boolean;
    //копирование данных во временную таблицу (BM)
    procedure CopyToMemoryDataBM;
  public
    fStartQuery: boolean;
    fColorMode : boolean;
  end;

var
  frmTelephone: TfrmTelephone;

implementation

uses
	dmCityNavigator,
        uCommon;

{$R *.dfm}

procedure TfrmTelephone.FormCreate(Sender: TObject);
begin
	//cтруктуру для обслуживания из главной формы
	NewChildInfo(fChildInfo, self);
	fChildInfo.Actions[childRefresh] := AcRefreshExecute;

        mdTelephoneINV_BILLING.Active := true;
        mdTelephoneBM.Active          := true;
	fStartQuery                   := false;

        LoadFromIni;
        edPeriodBegin.Text := DateToStr(Now) + ' 00:00:00';
        edPeriodEnd.Text   := DateToStr(Now) + ' 23:59:59';

        fStartQuery := true;
end;

procedure TfrmTelephone.FormShow(Sender: TObject);
begin
	RunQuery;
end;

procedure TfrmTelephone.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        SaveToIni;
	mdTelephoneINV_BILLING.Active := false;
        mdTelephoneBM.Active          := false;
	Action := caFree;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmTelephone.LoadFromIni;
var
	sect: String;
begin
	sect := 'Telephone';
	pnlFilter.Width          := OptionsIni.ReadInteger(sect, 'FilterPanelWidth', 150);
        edTelephone.Text         := OptionsIni.ReadString(sect, 'Telephone', '');
        pcGreeds.ActivePageIndex := OptionsIni.ReadInteger(sect, 'PayType', 0);

        sect := 'Options';
        fColorMode := OptionsIni.ReadBool(sect, 'UseColorMode', true);
end;

//сохранение параметров в ini-файл
procedure TfrmTelephone.SaveToIni;
var
	sect: String;
begin
	sect := 'Telephone';
	OptionsIni.WriteInteger(sect, 'FilterPanelWidth', pnlFilter.Width);
        OptionsIni.WriteString(sect, 'Telephone', edTelephone.Text);
	OptionsIni.WriteInteger(sect, 'PayType', pcGreeds.ActivePageIndex);
end;

//обновить
procedure TfrmTelephone.AcRefreshExecute(Sender: TObject);
var
	i: word;
begin
        for i := 0 to GridTelephoneINV_BILLING.Columns.Count - 1 do
        	GridTelephoneINV_BILLING.Columns[i].Title.SortMarker := smNoneEh;

        for i := 0 to GridTelephoneBM.Columns.Count - 1 do
        	GridTelephoneBM.Columns[i].Title.SortMarker := smNoneEh;

	RunQuery;
end;

procedure TfrmTelephone.RunQuery;
begin
	//MsgBox('RunQuery');
	Screen.Cursor := crHourGlass;

        //вкладка "Счет"
        if (pcGreeds.ActivePageIndex = 0) then
        begin
	        if (QueryFromOracleINV_BILLING) then
		        CopyToMemoryDataINV_BILLING;
	end

        //Вкладка "Прочие (РНКО)"
	else if (pcGreeds.ActivePageIndex = 1) then
        begin
	        if (QueryFromOracleBM) then
		        CopyToMemoryDataBM;
	end;

        Screen.Cursor := crDefault;
end;

//запрос в Оракл (INV_BILLING)
function TfrmTelephone.QueryFromOracleINV_BILLING: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT REQ_ID'
     		+ ', REQ_STATE'
     		+ ', REQ_DATE'
                + ', LSID'
                + ', REQ_TYPE'
                + ', RESULT'
                + ', ERRMSG'
                + ', OPER_TYPE'
                + ', UNO'
                + ', PPP_ID'
                + ', USER_ID'
                + ', PROG_ID'
                + ', AGENT_ID'
                + ', PRV_ID'
                + ', SRVNUM'
                + ', ACC_PU'
                + ', SUMM'
                + ', OUTP'
     		+ ', INP'
                + ', REQ_AG_ID'
                + ', AG_UNO'
                + ', REQ_PR_ID'
                + ', PR_UNO'
                + ', BILLING_AGENT_ID'
                + ', PARTNER_AG_ID'
                + ', INNER_ERR_ID'
                + ', BILLING_ERR_CODE'
                + ', SUMM_COMISS'
                + ', PAY_SYSTEM_ID'
        + ' FROM INV_BILLING.REQS'
        + ' WHERE REQ_DATE BETWEEN TO_DATE(''' + edPeriodBegin.Text + ''', ''DD.MM.YYYY HH24:MI:SS'') AND TO_DATE(''' + edPeriodEnd.Text + ''', ''DD.MM.YYYY HH24:MI:SS'')');

	//указан номер телефона
        if (edTelephone.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND ACC_PU = ''' + edTelephone.Text + '''');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY REQ_ID');

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fTelephone).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        //MsgBox(IntToStr(DataMod.OracleDataSet.RecordCount));
        result := true;
end;

//копирование данных во временную таблицу (INV_BILLING)
procedure TfrmTelephone.CopyToMemoryDataINV_BILLING;
var
	record_count: integer;
begin
	GridTelephoneINV_BILLING.DataSource.DataSet.DisableControls;

   	mdTelephoneINV_BILLING.EmptyTable;
        record_count := 0;
        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdTelephoneINV_BILLING.Append;

                if (not DataMod.OracleDataSet.FieldByName('REQ_ID').IsNull) then
                	mdTelephoneINV_BILLING.FieldByName('REQ_ID').AsInteger          := DataMod.OracleDataSet.FieldByName('REQ_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_STATE').IsNull) then
	                mdTelephoneINV_BILLING.FieldByName('REQ_STATE').AsInteger       := DataMod.OracleDataSet.FieldByName('REQ_STATE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_DATE').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('REQ_DATE').AsDateTime       := DataMod.OracleDataSet.FieldByName('REQ_DATE').AsDateTime;

                if (not DataMod.OracleDataSet.FieldByName('LSID').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('LSID').AsInteger            := DataMod.OracleDataSet.FieldByName('LSID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_TYPE').IsNull) then
	     		mdTelephoneINV_BILLING.FieldByName('REQ_TYPE').AsInteger        := DataMod.OracleDataSet.FieldByName('REQ_TYPE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('RESULT').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('RESULT').AsInteger          := DataMod.OracleDataSet.FieldByName('RESULT').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('ERRMSG').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('ERRMSG').AsString           := DataMod.OracleDataSet.FieldByName('ERRMSG').AsString;

                if (not DataMod.OracleDataSet.FieldByName('OPER_TYPE').IsNull) then
	      		mdTelephoneINV_BILLING.FieldByName('OPER_TYPE').AsInteger       := DataMod.OracleDataSet.FieldByName('OPER_TYPE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('UNO').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('UNO').AsInteger             := DataMod.OracleDataSet.FieldByName('UNO').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PPP_ID').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('PPP_ID').AsInteger          := DataMod.OracleDataSet.FieldByName('PPP_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('USER_ID').IsNull) then
	     		mdTelephoneINV_BILLING.FieldByName('USER_ID').AsInteger         := DataMod.OracleDataSet.FieldByName('USER_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PROG_ID').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('PROG_ID').AsInteger         := DataMod.OracleDataSet.FieldByName('PROG_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('AGENT_ID').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('AGENT_ID').AsInteger        := DataMod.OracleDataSet.FieldByName('AGENT_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PRV_ID').IsNull) then
	     		mdTelephoneINV_BILLING.FieldByName('PRV_ID').AsInteger          := DataMod.OracleDataSet.FieldByName('PRV_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('SRVNUM').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('SRVNUM').AsInteger          := DataMod.OracleDataSet.FieldByName('SRVNUM').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('ACC_PU').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('ACC_PU').AsString           := DataMod.OracleDataSet.FieldByName('ACC_PU').AsString;

                if (not DataMod.OracleDataSet.FieldByName('SUMM').IsNull) then
	     		mdTelephoneINV_BILLING.FieldByName('SUMM').AsFloat              := DataMod.OracleDataSet.FieldByName('SUMM').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('OUTP').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('OUTP').AsString             := DataMod.OracleDataSet.FieldByName('OUTP').AsString;

                if (not DataMod.OracleDataSet.FieldByName('INP').IsNull) then
     			mdTelephoneINV_BILLING.FieldByName('INP').AsString              := DataMod.OracleDataSet.FieldByName('INP').AsString;

                if (not DataMod.OracleDataSet.FieldByName('REQ_AG_ID').IsNull) then
	                mdTelephoneINV_BILLING.FieldByName('REQ_AG_ID').AsString        := DataMod.OracleDataSet.FieldByName('REQ_AG_ID').AsString;

                if (not DataMod.OracleDataSet.FieldByName('AG_UNO').IsNull) then
        	        mdTelephoneINV_BILLING.FieldByName('AG_UNO').AsString           := DataMod.OracleDataSet.FieldByName('AG_UNO').AsString;

                if (not DataMod.OracleDataSet.FieldByName('REQ_PR_ID').IsNull) then
                	mdTelephoneINV_BILLING.FieldByName('REQ_PR_ID').AsString        := DataMod.OracleDataSet.FieldByName('REQ_PR_ID').AsString;

                if (not DataMod.OracleDataSet.FieldByName('PR_UNO').IsNull) then
	                mdTelephoneINV_BILLING.FieldByName('PR_UNO').AsString           := DataMod.OracleDataSet.FieldByName('PR_UNO').AsString;

                if (not DataMod.OracleDataSet.FieldByName('BILLING_AGENT_ID').IsNull) then
        	        mdTelephoneINV_BILLING.FieldByName('BILLING_AGENT_ID').AsFloat  := DataMod.OracleDataSet.FieldByName('BILLING_AGENT_ID').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('PARTNER_AG_ID').IsNull) then
                	mdTelephoneINV_BILLING.FieldByName('PARTNER_AG_ID').AsFloat     := DataMod.OracleDataSet.FieldByName('PARTNER_AG_ID').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('INNER_ERR_ID').IsNull) then
	                mdTelephoneINV_BILLING.FieldByName('INNER_ERR_ID').AsFloat      := DataMod.OracleDataSet.FieldByName('INNER_ERR_ID').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('BILLING_ERR_CODE').IsNull) then
        	        mdTelephoneINV_BILLING.FieldByName('BILLING_ERR_CODE').AsString := DataMod.OracleDataSet.FieldByName('BILLING_ERR_CODE').AsString;

                if (not DataMod.OracleDataSet.FieldByName('SUMM_COMISS').IsNull) then
                	mdTelephoneINV_BILLING.FieldByName('SUMM_COMISS').AsFloat       := DataMod.OracleDataSet.FieldByName('SUMM_COMISS').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('PAY_SYSTEM_ID').IsNull) then
	        	mdTelephoneINV_BILLING.FieldByName('PAY_SYSTEM_ID').AsFloat     := DataMod.OracleDataSet.FieldByName('PAY_SYSTEM_ID').AsFloat;

                mdTelephoneINV_BILLING.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdTelephoneINV_BILLING.First;
        GridTelephoneINV_BILLING.Columns[0].Footer.Value := IntToStr(record_count);
        GridTelephoneINV_BILLING.DataSource.DataSet.EnableControls;
end;

//запрос в Оракл (BM)
function TfrmTelephone.QueryFromOracleBM: boolean;
begin
	result := false;

        DataMod.OracleDataSet.SQL.Clear;
        DataMod.OracleDataSet.SQL.Add('SELECT REQ_ID'
     		+ ', REQ_STATE'
     		+ ', REQ_DATE'
        	+ ', REQ_STAMP'
     		+ ', ANS_STAMP'
     		+ ', UNDO_STAMP'
     		+ ', LSID'
     		+ ', REQ_TYPE'
     		+ ', RESULT'
     		+ ', ERRMSG'
     		+ ', OPER_TYPE'
     		+ ', UNO'
     		+ ', PPP_ID'
     		+ ', USER_ID'
     		+ ', PROG_ID'
     		+ ', AGENT_ID'
     		+ ', PRV_ID'
     		+ ', SRVNUM'
     		+ ', ACC_PU'
     		+ ', SUMM'
     		+ ', OUTP'
     		+ ', INP'
        + ' FROM BM.REQS'
        + ' WHERE REQ_DATE BETWEEN TO_DATE(''' + edPeriodBegin.Text + ''', ''DD.MM.YYYY HH24:MI:SS'') AND TO_DATE(''' + edPeriodEnd.Text + ''', ''DD.MM.YYYY HH24:MI:SS'')');

	//указан номер телефона
        if (edTelephone.Text <> '') then
        	DataMod.OracleDataSet.SQL.Add(' AND ACC_PU = ''' + edTelephone.Text + '''');

	DataMod.OracleDataSet.SQL.Add(' ORDER BY REQ_ID');

        //MsgBox(DataMod.OracleDataSet.SQL.Text);

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fTelephone).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        //MsgBox(IntToStr(DataMod.OracleDataSet.RecordCount));
        result := true;
end;

//копирование данных во временную таблицу (BM)
procedure TfrmTelephone.CopyToMemoryDataBM;
var
	record_count: integer;
begin
	GridTelephoneBM.DataSource.DataSet.DisableControls;

   	mdTelephoneBM.EmptyTable;
        record_count := 0;

        while (not (DataMod.OracleDataSet.Eof)) do
        begin
        	mdTelephoneBM.Append;

                if (not DataMod.OracleDataSet.FieldByName('REQ_ID').IsNull) then
                	mdTelephoneBM.FieldByName('REQ_ID').AsInteger     := DataMod.OracleDataSet.FieldByName('REQ_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_STATE').IsNull) then
	                mdTelephoneBM.FieldByName('REQ_STATE').AsInteger  := DataMod.OracleDataSet.FieldByName('REQ_STATE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_DATE').IsNull) then
     			mdTelephoneBM.FieldByName('REQ_DATE').AsDateTime  := DataMod.OracleDataSet.FieldByName('REQ_DATE').AsDateTime;

                if (not DataMod.OracleDataSet.FieldByName('REQ_STAMP').IsNull) then
        		mdTelephoneBM.FieldByName('REQ_STAMP').AsInteger  := DataMod.OracleDataSet.FieldByName('REQ_STAMP').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('ANS_STAMP').IsNull) then
	     		mdTelephoneBM.FieldByName('ANS_STAMP').AsInteger  := DataMod.OracleDataSet.FieldByName('ANS_STAMP').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('UNDO_STAMP').IsNull) then
     			mdTelephoneBM.FieldByName('UNDO_STAMP').AsInteger := DataMod.OracleDataSet.FieldByName('UNDO_STAMP').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('LSID').IsNull) then
     			mdTelephoneBM.FieldByName('LSID').AsInteger       := DataMod.OracleDataSet.FieldByName('LSID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('REQ_TYPE').IsNull) then
	     		mdTelephoneBM.FieldByName('REQ_TYPE').AsInteger   := DataMod.OracleDataSet.FieldByName('REQ_TYPE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('RESULT').IsNull) then
     			mdTelephoneBM.FieldByName('RESULT').AsInteger     := DataMod.OracleDataSet.FieldByName('RESULT').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('ERRMSG').IsNull) then
     			mdTelephoneBM.FieldByName('ERRMSG').AsString      := DataMod.OracleDataSet.FieldByName('ERRMSG').AsString;

                if (not DataMod.OracleDataSet.FieldByName('OPER_TYPE').IsNull) then
	     		mdTelephoneBM.FieldByName('OPER_TYPE').AsInteger  := DataMod.OracleDataSet.FieldByName('OPER_TYPE').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('UNO').IsNull) then
     			mdTelephoneBM.FieldByName('UNO').AsInteger        := DataMod.OracleDataSet.FieldByName('UNO').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PPP_ID').IsNull) then
     			mdTelephoneBM.FieldByName('PPP_ID').AsInteger     := DataMod.OracleDataSet.FieldByName('PPP_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('USER_ID').IsNull) then
	     		mdTelephoneBM.FieldByName('USER_ID').AsInteger    := DataMod.OracleDataSet.FieldByName('USER_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PROG_ID').IsNull) then
     			mdTelephoneBM.FieldByName('PROG_ID').AsInteger    := DataMod.OracleDataSet.FieldByName('PROG_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('AGENT_ID').IsNull) then
     			mdTelephoneBM.FieldByName('AGENT_ID').AsInteger   := DataMod.OracleDataSet.FieldByName('AGENT_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('PRV_ID').IsNull) then
	     		mdTelephoneBM.FieldByName('PRV_ID').AsInteger     := DataMod.OracleDataSet.FieldByName('PRV_ID').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('SRVNUM').IsNull) then
     			mdTelephoneBM.FieldByName('SRVNUM').AsInteger     := DataMod.OracleDataSet.FieldByName('SRVNUM').AsInteger;

                if (not DataMod.OracleDataSet.FieldByName('ACC_PU').IsNull) then
     			mdTelephoneBM.FieldByName('ACC_PU').AsString      := DataMod.OracleDataSet.FieldByName('ACC_PU').AsString;

                if (not DataMod.OracleDataSet.FieldByName('SUMM').IsNull) then
	     		mdTelephoneBM.FieldByName('SUMM').AsFloat         := DataMod.OracleDataSet.FieldByName('SUMM').AsFloat;

                if (not DataMod.OracleDataSet.FieldByName('OUTP').IsNull) then
     			mdTelephoneBM.FieldByName('OUTP').AsString        := DataMod.OracleDataSet.FieldByName('OUTP').AsString;

                if (not DataMod.OracleDataSet.FieldByName('INP').IsNull) then
     			mdTelephoneBM.FieldByName('INP').AsString         := DataMod.OracleDataSet.FieldByName('INP').AsString;

                mdTelephoneBM.Post;
                DataMod.OracleDataSet.Next;
                inc(record_count);
        end;
        DataMod.OracleDataSet.Close;
        mdTelephoneBM.First;
        GridTelephoneBM.Columns[0].Footer.Value := IntToStr(record_count);
        GridTelephoneBM.DataSource.DataSet.EnableControls;
end;

procedure TfrmTelephone.pnlFilterResize(Sender: TObject);
begin
	edTelephone.Width := pnlFilter.Width - 20;
        edPeriodBegin.Width := pnlFilter.Width - 40;
        edPeriodEnd.Width   := pnlFilter.Width - 40;
end;

procedure TfrmTelephone.GridTelephoneINV_BILLINGSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridTelephoneINV_BILLING = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridTelephoneINV_BILLING.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridTelephoneINV_BILLING.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridTelephoneINV_BILLING.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdTelephoneINV_BILLING.SortOnFields(fields, false, desc);
end;

procedure TfrmTelephone.GridTelephoneBMSortMarkingChanged(Sender: TObject);
var
	fields: String;
	i, count: Integer;
	desc: Boolean;
begin
	if GridTelephoneBM = nil then
		exit;

	desc   := false;
	fields := '';
	count  := GridTelephoneBM.SortMarkedColumns.Count;
	for i  := 0 to count - 1 do
	begin
		if Length(fields) > 0 then
			fields := fields + '; ';
		fields := fields + GridTelephoneBM.SortMarkedColumns.Items[i].FieldName;
		if (i = 0) then
			desc := smUpEh = GridTelephoneBM.SortMarkedColumns.Items[i].Title.SortMarker;
	end;
	mdTelephoneBM.SortOnFields(fields, false, desc);
end;

procedure TfrmTelephone.GridTelephoneINV_BILLINGGetCellParams(
  Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

    	if ((mdTelephoneINV_BILLING.FieldByName('RESULT').AsInteger <> 0) or (mdTelephoneINV_BILLING.FieldByName('ERRMSG').AsString <> '')
        or ((mdTelephoneINV_BILLING.FieldByName('REQ_TYPE').AsInteger <> 1) and (mdTelephoneINV_BILLING.FieldByName('REQ_TYPE').AsInteger <> 2))) then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmTelephone.GridTelephoneBMGetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
	if (not fColorMode) then
        	exit;

	if ((mdTelephoneBM.FieldByName('RESULT').AsInteger <> 0) or (mdTelephoneBM.FieldByName('ERRMSG').AsString <> '')
        or ((mdTelephoneBM.FieldByName('REQ_TYPE').AsInteger <> 1) and (mdTelephoneBM.FieldByName('REQ_TYPE').AsInteger <> 2))) then
		Background := $00FFC4C4
	else
		Background := $00FFDDDD;
end;

procedure TfrmTelephone.edTelephoneKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	lblError.Visible := false;

	if (fStartQuery = true) then
        begin
                //проверка корректности заполнения поля даты
        	if ((TryGetDateTime(edPeriodBegin.Text)) and (TryGetDateTime(edPeriodEnd.Text)))then
                begin
                	//нажата клавиша ENTER
                	if (Key = VK_RETURN) then
	   			RunQuery;
                end

	        else
        	begin
          		mdTelephoneINV_BILLING.EmptyTable;
                        mdTelephoneBM.EmptyTable;
	                GridTelephoneINV_BILLING.Columns[0].Footer.Value := '0';
                        GridTelephoneBM.Columns[0].Footer.Value := '0';
                        lblError.Visible := true;
                end;
        end;
end;

procedure TfrmTelephone.edPeriodBeginChange(Sender: TObject);
begin
   	lblError.Visible := false;

	if (fStartQuery = true) then
        begin
                //проверка корректности заполнения поля даты
        	if ((TryGetDateTime(edPeriodBegin.Text)) and (TryGetDateTime(edPeriodEnd.Text)))then
   			RunQuery

	        else
        	begin
          		mdTelephoneINV_BILLING.EmptyTable;
                        mdTelephoneBM.EmptyTable;
	                GridTelephoneINV_BILLING.Columns[0].Footer.Value := '0';
                        GridTelephoneBM.Columns[0].Footer.Value := '0';
                        lblError.Visible := true;
                end;
        end;

end;

procedure TfrmTelephone.pcGreedsChange(Sender: TObject);
begin
	RunQuery;
end;

end.
