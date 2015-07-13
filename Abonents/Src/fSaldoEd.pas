//������������� ����������
unit fSaldoEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls, ToolEdit,
  CurrEdit, Buttons, ImgList;

type
  TfrmSaldoEd = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edAbonent_id: TDBEditEh;
    gbSaldoPeriod: TGroupBox;
    lblPeriodBegin: TLabel;
    edPeriodBegin: TDateEdit;
    lblPeriodEnd: TLabel;
    edPeriodEnd: TDateEdit;
    edSumm: TCurrencyEdit;
    lblSumm: TLabel;
    edSaldo_id: TDBEditEh;
    sbBPrevMonth: TSpeedButton;
    sbBPrevDay: TSpeedButton;
    sbBNextDay: TSpeedButton;
    sbBNextMonth: TSpeedButton;
    ImageList: TImageList;
    sbEPrevMonth: TSpeedButton;
    sbEPrevDay: TSpeedButton;
    sbENextDay: TSpeedButton;
    sbENextMonth: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure sbBPrevMonthClick(Sender: TObject);
    procedure sbBPrevDayClick(Sender: TObject);
    procedure sbBNextDayClick(Sender: TObject);
    procedure sbBNextMonthClick(Sender: TObject);
    procedure sbEPrevMonthClick(Sender: TObject);
    procedure sbEPrevDayClick(Sender: TObject);
    procedure sbENextDayClick(Sender: TObject);
    procedure sbENextMonthClick(Sender: TObject);
  private
    fForm_mode: string[10];
  public
    procedure AddSaldo(ds: TDataSource; abonent_id: integer);
    procedure EditSaldo(ds: TDataSource; abonent_id: integer);
  end;

var
  frmSaldoEd: TfrmSaldoEd;

implementation

uses
	dmAbonents,
        DateUtil,
        uCommon;

{$R *.dfm}

procedure TfrmSaldoEd.FormCreate(Sender: TObject);
begin
        edAbonent_id.Visible := false;
	edSaldo_id.Visible   := false;
end;

//�������� ������
procedure TfrmSaldoEd.AddSaldo(ds: TDataSource; abonent_id: integer);
var
	max_id, mr: integer;
begin
	fForm_mode := 'add';
        edAbonent_id.Text  := IntToStr(abonent_id);
        edPeriodBegin.Date := FirstDayOfPrevMonth;
        edPeriodEnd.Date   := LastDayOfPrevMonth;
        edSumm.Value       := 0;

	Caption := Caption + ' (����������)';

	mr := ShowModal;
	if (mr = mrOk) then
	begin
        	max_id := 0;
        	//��������� ������������� SERVICE_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SALDO_ID) MAX_ID FROM SALDO';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� SALDO_ID.');
	                exit;
		end;

                //������� SALDO �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SALDO('
                	+ '  SALDO_ID'
                        + ', ABONENT_ID'
                        + ', PERIOD_BEGIN'
                        + ', PERIOD_END'
                        + ', SUMM)'
		+ ' VALUES('
                	//TODO: ����� ������������ GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',' + edAbonent_id.Text
                        + ',''' + edPeriodBegin.Text + ''''
                        + ',''' + edPeriodEnd.Text + ''''
                        //edSumm.Text ��� �������� '0.00' ���������� nil
                        + ',' + Sep2Dot(FloatToStr(edSumm.Value)) + ')';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� ����������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ���� � �����
                ds.DataSet.Append;
                ds.DataSet.FieldByName('SALDO_ID').AsInteger    := max_id + 1;
                ds.DataSet.FieldByName('PERIOD_BEGIN').AsString := edPeriodBegin.Text;
                ds.DataSet.FieldByName('PERIOD_END').AsString   := edPeriodEnd.Text;
                //edSumm.Text ��� �������� '0.00' ���������� nil
                ds.DataSet.FieldByName('SUMM').AsFloat          := edSumm.Value;
                ds.DataSet.FieldByName('IS_EXPORT').AsInteger   := 0;
                ds.DataSet.Post;
        end;
end;

//������������� ������
procedure TfrmSaldoEd.EditSaldo(ds: TDataSource; abonent_id: integer);
var
	mr: integer;
begin
	fForm_mode         := 'edit';
        edAbonent_id.Text  := IntToStr(abonent_id);
        edSaldo_id.Text    := ds.DataSet.FieldByName('SALDO_ID').AsString;
	edPeriodBegin.Date := ds.DataSet.FieldByName('PERIOD_BEGIN').AsDateTime;
        edPeriodEnd.Date   := ds.DataSet.FieldByName('PERIOD_END').AsDateTime;
        edSumm.Value       := ds.DataSet.FieldByName('SUMM').AsFloat;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE SALDO SET'
                        + '  PERIOD_BEGIN = ''' + edPeriodBegin.Text + ''''
                        + ', PERIOD_END   = ''' + edPeriodEnd.Text + ''''
                        //edSumm.Text ��� �������� '0.00' ���������� nil
                        + ', SUMM   = ' + Sep2Dot(FloatToStr(edSumm.Value))
		+ ' WHERE SALDO_ID  = ' + edSaldo_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� �������������� ������ � ������� ����.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //����������� ������ � ����
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('PERIOD_BEGIN').AsString := edPeriodBegin.Text;
                ds.DataSet.FieldByName('PERIOD_END').AsString   := edPeriodEnd.Text;
                //edSumm.Text ��� �������� '0.00' ���������� nil
                ds.DataSet.FieldByName('SUMM').AsFloat          := edSumm.Value;
                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmSaldoEd.btnOKClick(Sender: TObject);
begin
	//�������� �� �������
        if (edPeriodBegin.Text = '  .  .    ') then
		StopClose(self, '�� ������ ������� ��������� ������ ����������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edPeriodBegin)
        else if (edPeriodEnd.Text = '  .  .    ') then
		StopClose(self, '�� ������ ������� �������� ������ ����������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edPeriodEnd)
        //else if (edSumm.Text = '') then
	//	StopClose(self, '�� ������ ������� ����� ����������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edSumm)

        //�������� �� ������������ ���������� ��� � ����� ����������
        else if (not (TryGetDate(edPeriodBegin.Text))) then
                StopClose(self, '�� ������� ������� ��������� ������ ����������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edPeriodBegin)
        else if (not (TryGetDate(edPeriodEnd.Text))) then
                StopClose(self, '�� ������� ������� �������� ������ ����������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edPeriodEnd)
        else if (edPeriodBegin.Date > edPeriodEnd.Date) then
                StopClose(self, '��������� ������ ���������� �� ����� ���� ������ ���������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edPeriodBegin);

        {else
        begin
        	//��������, ��� �� ��������� ������ ���������� �� �������������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT SALDO_ID, SUMM'
        	+ ' FROM SALDO WHERE PERIOD_BEGIN = ''' + edPeriodBegin.Text + ''''
                + ' AND PERIOD_END = ''' + edPeriodEnd.Text + ''''
                + ' AND ABONENT_ID = ' + edAbonent_id.Text);

                //���� ���������� ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SALDO_ID <> ' + edSaldo_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ ������� ����������.' + #13 +
                        '���������, ��� � �������� ���������� �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edPeriodBegin);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                	StopClose(self, format('���������� �� ������ [%s - %s]%s��� ������������� (�����: %f ���., ID #%d).%s%s������� [��] ��� �������� � ����.', [edPeriodBegin.Text, edPeriodEnd.Text, #13, DataMod.IB_Cursor.FieldByName('SUMM').AsFloat, DataMod.IB_Cursor.FieldByName('SALDO_ID').AsInteger, #13, #13]), edPeriodBegin);
                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;}
end;

//���������� ����� (������ ������� ����������)
procedure TfrmSaldoEd.sbBPrevMonthClick(Sender: TObject);
begin
	if (TryGetDate(edPeriodBegin.Text)) then
            	edPeriodBegin.Date := IncMonth(edPeriodBegin.Date, -1);
end;

//���������� ���� (������ ������� ����������)
procedure TfrmSaldoEd.sbBPrevDayClick(Sender: TObject);
begin
      	if (TryGetDate(edPeriodBegin.Text)) then
            	edPeriodBegin.Date := IncDay(edPeriodBegin.Date, -1);
end;

//��������� ���� (������ ������� ����������)
procedure TfrmSaldoEd.sbBNextDayClick(Sender: TObject);
begin
     	if (TryGetDate(edPeriodBegin.Text)) then
            	edPeriodBegin.Date := IncDay(edPeriodBegin.Date, 1);
end;

//��������� ����� (������ ������� ����������)
procedure TfrmSaldoEd.sbBNextMonthClick(Sender: TObject);
begin
      	if (TryGetDate(edPeriodBegin.Text)) then
            	edPeriodBegin.Date := IncMonth(edPeriodBegin.Date, 1);
end;

//���������� ����� (����� ������� ����������)
procedure TfrmSaldoEd.sbEPrevMonthClick(Sender: TObject);
begin
	if (TryGetDate(edPeriodEnd.Text)) then
            	edPeriodEnd.Date := IncMonth(edPeriodEnd.Date, -1);
end;

//���������� ���� (����� ������� ����������)
procedure TfrmSaldoEd.sbEPrevDayClick(Sender: TObject);
begin
      	if (TryGetDate(edPeriodEnd.Text)) then
            	edPeriodEnd.Date := IncDay(edPeriodEnd.Date, -1);
end;

//��������� ���� (����� ������� ����������)
procedure TfrmSaldoEd.sbENextDayClick(Sender: TObject);
begin
     	if (TryGetDate(edPeriodEnd.Text)) then
            	edPeriodEnd.Date := IncDay(edPeriodEnd.Date, 1);
end;

//��������� ����� (����� ������� ����������)
procedure TfrmSaldoEd.sbENextMonthClick(Sender: TObject);
begin
      	if (TryGetDate(edPeriodEnd.Text)) then
            	edPeriodEnd.Date := IncMonth(edPeriodEnd.Date, 1);
end;

end.
