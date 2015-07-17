//�������� �������
unit fExportReestr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RtColorPicker, ComCtrls, ExtCtrls, RXSpin,
  LMDCustomControl, LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit,
  LMDCustomEdit, LMDCustomBrowseEdit, LMDBrowseEdit, Mask, DBCtrlsEh, DB,
  RxMemDS, LMDCustomMemo, LMDMemo, LMDCustomListBox, LMDExtListBox, RXCtrls;

type
  TfrmExportReestr = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    btnExport: TButton;
    btnClose: TButton;
    lblExportPath: TLabel;
    edExportPath: TDBEditEh;
    cbAccCloseImport: TCheckBox;
    cbService: TDBComboBoxEh;
    lblService: TLabel;
    mdExportReestr: TRxMemoryData;
    dsExportReestr: TDataSource;
    mdExportReestrFIO: TStringField;
    mdExportReestrBUILDING: TStringField;
    mdExportReestrAPARTMENT: TStringField;
    mdExportReestrACC_PU: TStringField;
    mdExportReestrSERVICE_NUM: TIntegerField;
    mdExportReestrSUB_SRV_PU: TStringField;
    mdExportReestrCITY: TStringField;
    mdExportReestrSTREET: TStringField;
    mdExportReestrSUMM: TFloatField;
    mdExportReestrPERIOD_BEGIN: TDateField;
    mdExportReestrPERIOD_END: TDateField;
    mdExportReestrIS_ACC_LOCK: TIntegerField;
    mdExportReestrSERVICE_NAME: TStringField;
    mdExportReestrABONENT_ID: TIntegerField;
    mdExportReestrSALDO_ID: TIntegerField;
    lbHistory: TTextListBox;
    mdExportReestrBALANCE: TFloatField;
    mdExportReestrIS_EXPORT: TSmallintField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExportClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
private
    fModalResult: TModalResult;
    procedure SetServiceList(cb: TDBComboBoxEh);
    //������� ����� ��� ���������� �����
    function SetFileName(file_type: word; export_path: string; service_num: integer): string;
    procedure LoadFromIni;
    procedure SaveToIni;
    //������ � ����� (������)
    function QueryFromOracleSaldo(service_id: integer): boolean;
    //����������� ������ �� ��������� ������� � ������� � ��������� ���� (������)
    procedure ExportSaldo(service_id: integer);
    //������ � ����� (����� �� ��������)
    function QueryFromOracleAccClose(service_id: integer): boolean;
    //����������� ������ �� ��������� ������� � ������� � ��������� ���� (����� �� ��������)
    procedure ExportAccClose(service_id: integer);
public
    { Public declarations }
end;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmExportReestr.FormCreate(Sender: TObject);
begin
	fModalResult := mrCancel;
	mdExportReestr.Active := true;
	SetServiceList(cbService);
   	LoadFromIni;
end;

procedure TfrmExportReestr.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	mdExportReestr.Active := false;
        //���� ���� ����������� �������� ��������, �� ���������� ModalResult = mrOk
        ModalResult := fModalResult;
	Action      := caFree;
end;

//������� ������ �����
procedure TfrmExportReestr.SetServiceList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT SERVICE_ID, NAME'
	+ ' FROM SERVICES'
        + ' WHERE VISIBLE = 1'
        + ' AND "TYPE" = ''MAIN''' //������������ ������ �������� ������
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ �����.');
                exit;
	end;

        cb.Items.Clear;
        cb.Items.Add('[��� ������]');
        cb.KeyItems.Add('[��� ������]');

        //���������� ����� = 0
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	WarningBox('�� ������� �� ���� �������� ������ ��� �����������.' + #13 +
                '�������� ������ ����������.' + #13 + #13 +
		'�������� ������(�) � ����������� �����.');
                btnExport.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//������� ����� ��� ���������� �����
//file_type = 7 - ������ ������
//file_type = 9 - ������ ������ �� ��������
function TfrmExportReestr.SetFileName(file_type: word; export_path: string; service_num: integer): string;
var
	year, month, day,
        hour, min, sec, msec: word;
        year_str, month_str, day_str,
        hour_str, min_str, sec_str: string;
begin
	result := '';

	DecodeDate(Now, Year, Month, Day);
    	DecodeTime(Now, Hour, Min, Sec, MSec);

        if (year < 10) then
            	year_str := '0' + IntToStr(year)
        else
                year_str := IntToStr(year);

        if (month < 10) then
            	month_str := '0' + IntToStr(month)
        else
                month_str := IntToStr(month);

        if (day < 10) then
            	day_str := '0' + IntToStr(day)
        else
                day_str := IntToStr(day);

        if (hour < 10) then
            	hour_str := '0' + IntToStr(hour)
        else
                hour_str := IntToStr(hour);

        if (min < 10) then
            	min_str := '0' + IntToStr(min)
        else
                min_str := IntToStr(min);

        if (sec < 10) then
            	sec_str := '0' + IntToStr(sec)
        else
                sec_str := IntToStr(sec);

        if (file_type = 7) then
		//result := format('%s\saldo_%d %s-%s-%s %s-%s-%s.txt', [export_path, service_num, year_str, month_str, day_str, hour_str, min_str, sec_str])
                result := format('%s\saldo_%d %s-%s-%s.txt', [export_path, service_num, year_str, month_str, day_str])
        else
        if (file_type = 9) then
                //result := format('%s\acc_close_%d %s-%s-%s %s-%s-%s.txt', [export_path, service_num, year_str, month_str, day_str, hour_str, min_str, sec_str]);
                result := format('%s\acc_close_%d %s-%s-%s.txt', [export_path, service_num, year_str, month_str, day_str]);

end;
//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//�������� ���������� �� ini-�����
procedure TfrmExportReestr.LoadFromIni;
var
	sect: String;
begin
	sect := 'Options';
        edExportPath.Text := OptionsIni.ReadString(sect, 'ExportPath', 'C:\Invest\Saldo');

        sect := 'ExportReestr';
        cbService.Text    := OptionsIni.ReadString(sect, 'Service', '[��� ������]');
        if (cbService.Text = '') then
         	cbService.ItemIndex := 0;
end;

//���������� ���������� � ini-����
procedure TfrmExportReestr.SaveToIni;
var
	sect: String;
begin
	sect := 'ExportReestr';
        OptionsIni.WriteString(sect, 'Service', cbService.Text);
end;

//------------------------------------------------------------------------------
//������� �� ������ ���������
procedure TfrmExportReestr.btnExportClick(Sender: TObject);
var
	i: integer;
begin
	//MsgBox('��������');
        lbHistory.Clear;

        //������� ������������ ������
        if (cbService.ItemIndex > 0) then
        begin
                if (QueryFromOracleSaldo(StrToInt(cbService.KeyItems.Strings[cbService.ItemIndex]))) then
    			ExportSaldo(StrToInt(cbService.KeyItems.Strings[cbService.ItemIndex]));

                if (cbAccCloseImport.Checked) then
                	if (QueryFromOracleAccClose(StrToInt(cbService.KeyItems.Strings[cbService.ItemIndex]))) then
    				ExportAccClose(StrToInt(cbService.KeyItems.Strings[cbService.ItemIndex]));
        end

        //��� ������
        else
        for i := 1 to cbService.Items.Count - 1 do
        begin
                if (QueryFromOracleSaldo(StrToInt(cbService.KeyItems.Strings[i]))) then
    			ExportSaldo(StrToInt(cbService.KeyItems.Strings[i]));

                if (cbAccCloseImport.Checked) then
                	if (QueryFromOracleAccClose(StrToInt(cbService.KeyItems.Strings[i]))) then
    				ExportAccClose(StrToInt(cbService.KeyItems.Strings[i]));
        end;

        MsgBox('�������� �������� ���������.');
end;

//������ � ����� (������)
function TfrmExportReestr.QueryFromOracleSaldo(service_id: integer): boolean;
begin
	result := false;

	DataMod.IB_Cursor.SQL.Text := 'SELECT A.ABONENT_ID'
        	+ ', A.FIO'
     		+ ', A.BUILDING'
     		+ ', A.APARTMENT'
     		+ ', A.ACC_PU'
                + ', A.IS_ACC_LOCK'
                + ', A.BALANCE'
     		+ ', SE.NUM  AS SERVICE_NUM'
                + ', SE.NAME AS SERVICE_NAME'
     		+ ', SU.SUB_SRV_PU'
     		+ ', C.NAME  AS CITY'
     		+ ', ST.NAME AS STREET'
                + ', SA.SALDO_ID'
     		+ ', SA.SUMM'
     		+ ', SA.PERIOD_BEGIN'
     		+ ', SA.PERIOD_END'
                + ', SA.IS_EXPORT'
	+ ' FROM ABONENTS A'
	+ ' INNER JOIN SERVICES SE    ON A.SERVICE_ID = SE.SERVICE_ID'
	+ ' LEFT  JOIN SUBSRV SU      ON A.SUBSRV_ID  = SU.SUBSRV_ID'
	+ ' LEFT  JOIN CITY_LIST C    ON A.CITY_ID    = C.CITY_ID'
	+ ' LEFT  JOIN STREET_LIST ST ON A.STREET_ID  = ST.STREET_ID'
	+ ' INNER JOIN SALDO SA       ON A.ABONENT_ID = SA.ABONENT_ID'
	+ ' AND SA.SALDO_ID    = (SELECT MAX(SALDO_ID) FROM SALDO WHERE ABONENT_ID = A.ABONENT_ID)'
        + ' WHERE A.SERVICE_ID = ' + IntToStr(service_id)
        + ' AND A.IS_ACC_LOCK  = 0'
	+ ' AND A.IS_ACC_CLOSE = 0'
	+ ' ORDER BY SE.NAME'
       		+ ', A.ACC_PU'
       		+ ', SU.NAME';
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ������������ ������� ������.');
                exit;
	end;

        result := true;
end;

//TODO: ������� ����������� �������!
//TODO: ������� �������� service_id ������������ ������ ��� �����������
//�������� � ������ ������, ���� �� ��� ��� ��������� ����������

//����������� ������ �� ��������� ������� � ������� ���������� � ��������� ���� (������)
procedure TfrmExportReestr.ExportSaldo(service_id: integer);
var
	f: TextFile;
        file_name: string;
        record_count: integer;
	file_sum, saldo: double;
begin
	//����������� ������ �� ��������� �������
	mdExportReestr.EmptyTable;
        record_count := 0;
        file_sum := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdExportReestr.Append;
                mdExportReestr.FieldByName('ABONENT_ID').AsInteger    := DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger;
                mdExportReestr.FieldByName('FIO').AsString            := DataMod.IB_Cursor.FieldByName('FIO').AsString;
                mdExportReestr.FieldByName('BUILDING').AsString       := DataMod.IB_Cursor.FieldByName('BUILDING').AsString;
                mdExportReestr.FieldByName('APARTMENT').AsString      := DataMod.IB_Cursor.FieldByName('APARTMENT').AsString;
                mdExportReestr.FieldByName('ACC_PU').AsString         := DataMod.IB_Cursor.FieldByName('ACC_PU').AsString;
                mdExportReestr.FieldByName('IS_ACC_LOCK').AsInteger   := DataMod.IB_Cursor.FieldByName('IS_ACC_LOCK').AsInteger;
                mdExportReestr.FieldByName('BALANCE').AsFloat         := DataMod.IB_Cursor.FieldByName('BALANCE').AsFloat;
                mdExportReestr.FieldByName('SERVICE_NUM').AsInteger   := DataMod.IB_Cursor.FieldByName('SERVICE_NUM').AsInteger;
                mdExportReestr.FieldByName('SERVICE_NAME').AsString   := DataMod.IB_Cursor.FieldByName('SERVICE_NAME').AsString;
                mdExportReestr.FieldByName('SUB_SRV_PU').AsString     := DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString;
                mdExportReestr.FieldByName('CITY').AsString           := DataMod.IB_Cursor.FieldByName('CITY').AsString;
                mdExportReestr.FieldByName('STREET').AsString         := DataMod.IB_Cursor.FieldByName('STREET').AsString;
                mdExportReestr.FieldByName('SALDO_ID').AsInteger      := DataMod.IB_Cursor.FieldByName('SALDO_ID').AsInteger;
		mdExportReestr.FieldByName('SUMM').AsFloat            := DataMod.IB_Cursor.FieldByName('SUMM').AsFloat;
        	mdExportReestr.FieldByName('PERIOD_BEGIN').AsDateTime := DataMod.IB_Cursor.FieldByName('PERIOD_BEGIN').AsDateTime;
        	mdExportReestr.FieldByName('PERIOD_END').AsDateTime   := DataMod.IB_Cursor.FieldByName('PERIOD_END').AsDateTime;
                mdExportReestr.FieldByName('IS_EXPORT').AsInteger     := DataMod.IB_Cursor.FieldByName('IS_EXPORT').AsInteger;
                mdExportReestr.Post;

                inc(record_count);

                //���� ���������� �����������, �� ��������� ������� ������
        	file_sum := file_sum +  mdExportReestr.FieldByName('BALANCE').AsFloat;

                //���� ���������� �� �����������, �� ���������
                //������� ������ + ������������ ����������
        	if (mdExportReestr.FieldByName('IS_EXPORT').AsInteger = 0) then
        		file_sum := file_sum + mdExportReestr.FieldByName('SUMM').AsFloat;

                DataMod.IB_Cursor.Next;
        end;
        DataMod.IB_Cursor.Close;

        //�� ������ ��� ���������� ����������
        if (record_count = 0) then
        begin
                DataMod.IB_Cursor.SQL.Text := 'SELECT NUM AS SERVICE_NUM'
                + ', NAME AS SERVICE_NAME'
		+ ' FROM SERVICES'
		+ ' WHERE SERVICE_ID = ' + IntToStr(service_id);

                //������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('������ ��� ����������� ������ � �������� ������' + #13 +
                        '��� ���������� ����������.');
                	exit;
		end;

                lbHistory.Items.Add(format('%d - %s', [DataMod.IB_Cursor.FieldByName('SERVICE_NUM').AsInteger, DataMod.IB_Cursor.FieldByName('SERVICE_NAME').AsString]));
        	lbHistory.Items.Add(format('������: ��� ���������� ����������.', []));
        	lbHistory.Items.Add('');
                lbHistory.Refresh;

                DataMod.IB_Cursor.Close;
        	exit;
        end;

        //----------------------------------------------------------------------
        //� ������� ABONENTS �������� �������� ���� BALANCE ������� ��������������
        mdExportReestr.First;
        while (not (mdExportReestr.Eof)) do
        begin
        	//���������� �����������
                if (mdExportReestr.FieldByName('IS_EXPORT').AsInteger = 1) then
                begin
                	mdExportReestr.Next;
                        continue;
                end;
                
                //������� ������������� ����� ������������ ������������� ���� ����������
                saldo := mdExportReestr.FieldByName('BALANCE').AsFloat + mdExportReestr.FieldByName('SUMM').AsFloat;

                DataMod.IB_Cursor.SQL.Text := 'UPDATE ABONENTS SET BALANCE = ' + Sep2Dot(FloatToStr(saldo))
                + ' WHERE ABONENT_ID = ' + mdExportReestr.FieldByName('ABONENT_ID').AsString;

                //������ �������
                try
                        DataMod.IB_Cursor.Open;
                except
                        WarningBox('������ ��� ���������� ������� ������������� ��������.');
                        exit;
                end;

                DataMod.IB_Cursor.Close;
                mdExportReestr.Next;
        end;

        //----------------------------------------------------------------------
        //� ������� SALDO �������� ���������� ��� ����������� (IS_EXPORT = 1)
        mdExportReestr.First;
        while (not (mdExportReestr.Eof)) do
        begin
        	//���������� �����������
        	if (mdExportReestr.FieldByName('IS_EXPORT').AsInteger = 1) then
                begin
                	mdExportReestr.Next;
                        continue;
                end;

        	DataMod.IB_Cursor.SQL.Text := 'UPDATE SALDO SET IS_EXPORT = 1'
                + ' WHERE SALDO_ID = ' + mdExportReestr.FieldByName('SALDO_ID').AsString;

                //������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('������ ��� ������� ���������� ��� �����������.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
           	mdExportReestr.Next;
        end;

        //----------------------------------------------------------------------
        //������� ���������� � ��������� ����
	file_name := SetFileName(7, edExportPath.Text, mdExportReestr.FieldByName('SERVICE_NUM').AsInteger);
        AssignFile(f, file_name);

        {$I-}
	ReWrite(f);
        {$I-}

        if IOResult <> 0 then
    	begin
            	WarningBox('������ ��� �������� ������� ������:' + #13 + file_name);
                exit;
        end;

        //TODO: ��� ���������� ������ ��������� ������� ������
        file_sum := round(file_sum * 100) / 100;

        WriteLn(f, format('#FILESUM %s', [Sep2Dot(FloatToStr(file_sum))]));
        WriteLn(f, format('#TYPE 7', []));
        WriteLn(f, format('#SERVICE %d', [mdExportReestr.FieldByName('SERVICE_NUM').AsInteger]));

        mdExportReestr.First;
        while (not (mdExportReestr.Eof)) do
        begin
        	//���� ���������� �����������, �� ��������� ������� ������
        	saldo := mdExportReestr.FieldByName('BALANCE').AsFloat;

                //���� ���������� �� �����������, �� ���������
                //������� ������ + ������������ ����������
        	if (mdExportReestr.FieldByName('IS_EXPORT').AsInteger = 0) then
        		saldo := saldo + mdExportReestr.FieldByName('SUMM').AsFloat;

        	if (mdExportReestr.FieldByName('IS_ACC_LOCK').AsInteger = 0) then
                WriteLn(f, format('%s;%s,%s,%s,%s;%s;%s;%s;%s;%s',
                	[mdExportReestr.FieldByName('FIO').AsString
        		, mdExportReestr.FieldByName('CITY').AsString
                        , mdExportReestr.FieldByName('STREET').AsString
                        , mdExportReestr.FieldByName('BUILDING').AsString
                        , mdExportReestr.FieldByName('APARTMENT').AsString
                        , mdExportReestr.FieldByName('ACC_PU').AsString
                        , Sep2Dot(FloatToStr(saldo))
                        , mdExportReestr.FieldByName('SUB_SRV_PU').AsString
                        , mdExportReestr.FieldByName('PERIOD_BEGIN').AsString
                        , mdExportReestr.FieldByName('PERIOD_END').AsString]));
           	mdExportReestr.Next;
        end;

        CloseFile(f);

        //���� ��� �������� ������� ���������, �� ��������� ����������
        DataMod.IB_Transaction.Commit;

        lbHistory.Items.Add(format('%d - %s', [mdExportReestr.FieldByName('SERVICE_NUM').AsInteger, mdExportReestr.FieldByName('SERVICE_NAME').AsString]));
        lbHistory.Items.Add(format('������: ��������� %d ������� (%s).', [record_count, file_name]));
        lbHistory.Items.Add('');
        lbHistory.Refresh;

        if (record_count > 0) then
        	fModalResult := mrOk;
end;

//������ � ����� (����� �� ��������)
function TfrmExportReestr.QueryFromOracleAccClose(service_id: integer): boolean;
begin
	result := false;

	DataMod.IB_Cursor.SQL.Text := 'SELECT A.ABONENT_ID'
        	+ ', A.FIO'
     		+ ', A.BUILDING'
     		+ ', A.APARTMENT'
     		+ ', A.ACC_PU'
                + ', A.IS_ACC_LOCK'
                + ', A.BALANCE'
     		+ ', SE.NUM  AS SERVICE_NUM'
                + ', SE.NAME AS SERVICE_NAME'
     		+ ', SU.SUB_SRV_PU'
     		+ ', C.NAME  AS CITY'
     		+ ', ST.NAME AS STREET'
	+ ' FROM ABONENTS A'
	+ ' INNER JOIN SERVICES SE    ON A.SERVICE_ID = SE.SERVICE_ID'
	+ ' LEFT  JOIN SUBSRV SU      ON A.SUBSRV_ID  = SU.SUBSRV_ID'
	+ ' LEFT  JOIN CITY_LIST C    ON A.CITY_ID    = C.CITY_ID'
	+ ' LEFT  JOIN STREET_LIST ST ON A.STREET_ID  = ST.STREET_ID'
        + ' WHERE A.SERVICE_ID = ' + IntToStr(service_id)
        + ' AND A.IS_ACC_LOCK  = 1'
	+ ' AND A.IS_ACC_CLOSE = 0'
	+ ' ORDER BY SE.NAME'
       		+ ', A.ACC_PU'
       		+ ', SU.NAME';
        //MsgBox(DataMod.IB_Cursor.SQL.Text);

        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ������������ ������� ������ �� ��������.');
                exit;
	end;

        result := true;
end;

//TODO: ������� �������� service_id ������������ ������ ��� �����������
//�������� � ������ ������, ���� �� ��� ��� ��������� � �/�, ����������� �� ��������

//����������� ������ �� ��������� ������� � ������� ���������� � ��������� ���� (����� �� ��������)
procedure TfrmExportReestr.ExportAccClose(service_id: integer);
var
	f: TextFile;
        file_name: string;
        record_count: integer;
begin
	//����������� ������ �� ��������� �������
	mdExportReestr.EmptyTable;
        record_count := 0;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	mdExportReestr.Append;
                mdExportReestr.FieldByName('ABONENT_ID').AsInteger    := DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger;
                mdExportReestr.FieldByName('FIO').AsString            := DataMod.IB_Cursor.FieldByName('FIO').AsString;
                mdExportReestr.FieldByName('BUILDING').AsString       := DataMod.IB_Cursor.FieldByName('BUILDING').AsString;
                mdExportReestr.FieldByName('APARTMENT').AsString      := DataMod.IB_Cursor.FieldByName('APARTMENT').AsString;
                mdExportReestr.FieldByName('ACC_PU').AsString         := DataMod.IB_Cursor.FieldByName('ACC_PU').AsString;
                mdExportReestr.FieldByName('SERVICE_NUM').AsInteger   := DataMod.IB_Cursor.FieldByName('SERVICE_NUM').AsInteger;
                mdExportReestr.FieldByName('SERVICE_NAME').AsString   := DataMod.IB_Cursor.FieldByName('SERVICE_NAME').AsString;
                mdExportReestr.FieldByName('SUB_SRV_PU').AsString     := DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString;
                mdExportReestr.FieldByName('CITY').AsString           := DataMod.IB_Cursor.FieldByName('CITY').AsString;
                mdExportReestr.FieldByName('STREET').AsString         := DataMod.IB_Cursor.FieldByName('STREET').AsString;
                mdExportReestr.Post;
                DataMod.IB_Cursor.Next;

                inc(record_count);
        end;
        DataMod.IB_Cursor.Close;

        //�� ������ ��� ��������� � �/�, ����������� �� ��������
        if (record_count = 0) then
        begin
                DataMod.IB_Cursor.SQL.Text := 'SELECT NUM AS SERVICE_NUM'
                + ', NAME AS SERVICE_NAME'
		+ ' FROM SERVICES'
		+ ' WHERE SERVICE_ID = ' + IntToStr(service_id);

                //������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('������ ��� ����������� ������ � �������� ������' + #13 +
                        '��� ��������� � �������� �������, ����������� �� ��������.');
                	exit;
		end;

                lbHistory.Items.Add(format('%d - %s', [DataMod.IB_Cursor.FieldByName('SERVICE_NUM').AsInteger, DataMod.IB_Cursor.FieldByName('SERVICE_NAME').AsString]));
        	lbHistory.Items.Add(format('����� �� ��������: ��� ��������� � �������� �������, ����������� �� ��������.', []));
        	lbHistory.Items.Add('');
                lbHistory.Refresh;

                DataMod.IB_Cursor.Close;
        	exit;
        end;

        //----------------------------------------------------------------------
        //� ������� ABONENTS �������� �/� �������� ��� �������� (IS_ACC_CLOSE = 1)
        //� ���������� ���� �������� (CLOSE_TIME)
        mdExportReestr.First;
        while (not (mdExportReestr.Eof)) do
        begin
        	DataMod.IB_Cursor.SQL.Text := 'UPDATE ABONENTS SET'
                + '  IS_ACC_CLOSE = 1'
                + ', CLOSE_TIME = ''' + DateTimeToStr(Now) + ''''
                + '  WHERE ABONENT_ID = ' + mdExportReestr.FieldByName('ABONENT_ID').AsString;

                //������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('������ ��� ������� �������� ��� ���������.');
                	exit;
		end;

                DataMod.IB_Cursor.Close;
           	mdExportReestr.Next;
        end;

        //----------------------------------------------------------------------
        //������� ������ �� �������� � ��������� ����
	file_name := SetFileName(9, edExportPath.Text, mdExportReestr.FieldByName('SERVICE_NUM').AsInteger);
        AssignFile(f, file_name);

        {$I-}
	ReWrite(f);
        {$I-}

        if IOResult <> 0 then
    	begin
            	WarningBox('������ ��� �������� ������� ������:' + #13 + file_name);
                exit;
        end;

        WriteLn(f, '#FILESUM 0.00');
        WriteLn(f, '#TYPE 9');
        WriteLn(f, format('#SERVICE %d', [mdExportReestr.FieldByName('SERVICE_NUM').AsInteger]));

        mdExportReestr.First;
        while (not (mdExportReestr.Eof)) do
        begin
        	if (mdExportReestr.FieldByName('IS_ACC_LOCK').AsInteger = 0) then
                WriteLn(f, format('%s;%s,%s,%s,%s;%s;%s;%s;%s;%s',
                	[mdExportReestr.FieldByName('FIO').AsString
        		, mdExportReestr.FieldByName('CITY').AsString
                        , mdExportReestr.FieldByName('STREET').AsString
                        , mdExportReestr.FieldByName('BUILDING').AsString
                        , mdExportReestr.FieldByName('APARTMENT').AsString
                        , mdExportReestr.FieldByName('ACC_PU').AsString
                        , '0.00' {mdExportReestr.FieldByName('SUMM').AsFloat}
                        , mdExportReestr.FieldByName('SUB_SRV_PU').AsString
                        , mdExportReestr.FieldByName('PERIOD_BEGIN').AsString
                        , mdExportReestr.FieldByName('PERIOD_END').AsString]));
           	mdExportReestr.Next;
        end;

        CloseFile(f);

        //���� ��� �������� ������� ���������, �� ��������� ����������
        DataMod.IB_Transaction.Commit;

        lbHistory.Items.Add(format('%d - %s', [mdExportReestr.FieldByName('SERVICE_NUM').AsInteger, mdExportReestr.FieldByName('SERVICE_NAME').AsString]));
        lbHistory.Items.Add(format('����� �� ��������: ��������� %d ������� (%s).', [record_count, file_name]));
        lbHistory.Items.Add('');
        lbHistory.Refresh;

        if (record_count > 0) then
        	fModalResult := mrOk;
end;

//�������
procedure TfrmExportReestr.btnCloseClick(Sender: TObject);
begin
	SaveToIni;
        Close;
end;

end.
