//������������� ��������
unit fSubSrvEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls;

type
  TfrmSubSrvEd = class(TForm)
    lblNum: TLabel;
    lblName: TLabel;
    edName: TDBEditEh;
    btnOK: TButton;
    btnCancel: TButton;
    edNum: TDBEditEh;
    edSubSrv_id: TDBEditEh;
    edService_id: TDBEditEh;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fForm_mode: string[10];
  public
    procedure AddSubSrv(ds: TDataSource; service_id: integer);
    procedure EditSubSrv(ds: TDataSource; service_id: integer);
  end;

var
  frmSubSrvEd: TfrmSubSrvEd;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmSubSrvEd.FormCreate(Sender: TObject);
begin
	edService_id.Visible := false;
	edSubSrv_id.Visible  := false;
end;

//�������� ������
procedure TfrmSubSrvEd.AddSubSrv(ds: TDataSource; service_id: integer);
var
	max_id, mr: integer;
begin
	fForm_mode  := 'add';
        edService_id.Text := IntToStr(service_id);
        edNum.Text  := '';
        edName.Text := '';

	Caption := Caption + ' (����������)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//��������� ������������� SUBSRV_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SUBSRV_ID) MAX_ID FROM SUBSRV';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� SUBSRV_ID.');
	                exit;
		end;

                //������� SUBSRV �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SUBSRV('
                	+ '  SUBSRV_ID'
                        + ', SERVICE_ID'
                        + ', SUB_SRV_PU'
                        + ', NAME)'
		+ ' VALUES('
                	//TODO: ����� ������������ GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',' + edService_id.Text
                        + ',''' + edNum.Text + ''''
                        + ',''' + edName.Text + ''')';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� ��������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ���� � �����
                ds.DataSet.Append;
                ds.DataSet.FieldByName('SUBSRV_ID').AsInteger  := max_id + 1;
                ds.DataSet.FieldByName('SERVICE_ID').AsString  := edService_id.Text;
                ds.DataSet.FieldByName('SUB_SRV_PU').AsString  := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString        := edName.Text;
                ds.DataSet.Post;
        end;
end;

//������������� ������

//TODO: � ���� ��������� ������� �������� service_id �� ������������,
//���� �� ����� ��� �������� ������������ �������� ���������!
procedure TfrmSubSrvEd.EditSubSrv(ds: TDataSource; service_id: integer);
var
	mr: integer;
begin
	fForm_mode        := 'edit';
        edSubSrv_id.Text  := ds.DataSet.FieldByName('SUBSRV_ID').AsString;
	edService_id.Text := IntToStr(service_id);
        edNum.Text        := ds.DataSet.FieldByName('SUB_SRV_PU').AsString;
        edName.Text       := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE SUBSRV SET'
                        + '  SUB_SRV_PU = ''' + edNum.Text + ''''
                        + ', NAME       = ''' + edName.Text + ''''
		+ ' WHERE SUBSRV_ID     = ' + edSubSrv_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� �������������� ������ � ������� ��������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //����������� ������ � ����
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('SUB_SRV_PU').AsString := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString       := edName.Text;
                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmSubSrvEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//�������� �� �������
	if (edNum.Text = '') then
		StopClose(self, '�� ������ ������� ����� ���������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edNum)
        else if (edName.Text = '') then
		StopClose(self, '�� ������ ������� �������� ���������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //��������, ��� �������� ��������� �������� 70 ��������
        else if (Length(edName.Text) > 70) then
        	StopClose(self, '�������� ��������� ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //�������� �� ����������� � ������ ��������� ����������� ��������
	else if (CheckCorrectString(edNum.Text, ch, pos)) then
		StopClose(self, format('� ������ ��������� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edNum)

        //�������� �� ����������� � �������� ��������� ����������� ��������
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('� �������� ��������� ���������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edName)

        else
        begin
        	//��������, ��� ����� ��������� ��������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NAME'
        	+ ' FROM SUBSRV'
                + ' WHERE SERVICE_ID = ' + edService_id.Text
                + ' AND UPPER(SUB_SRV_PU) = UPPER(''' + edNum.Text + ''')');

                //���� ��������� ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID <> ' + edSubSrv_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ ������ ���������.' + #13 +
                        '���������, ��� � ������ �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edNum);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('��������� ����� %s ��� ����������%s(%s).%s%s������� [��] ��� �������� � ����.', [edNum.Text, #13, DataMod.IB_Cursor.FieldByName('NAME').AsString, #13, #13]), edNum);
                        exit;
                end;

                DataMod.IB_Cursor.Close;

        	//��������, ��� �������� ��������� ���������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT SUB_SRV_PU'
        	+ ' FROM SUBSRV'
                + ' WHERE SERVICE_ID = ' + edService_id.Text
                + ' AND NAME = ''' + edName.Text + '''');

                //���� ��������� ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID <> ' + edSubSrv_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ �������� ���������.' + #13 +
                        '���������, ��� � �������� �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edName);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('��������� "%s"%s��� ���������� (����� %s).%s%s������� [��] ��� �������� � ����.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString, #13, #13]), edName);
                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;
end;

end.
