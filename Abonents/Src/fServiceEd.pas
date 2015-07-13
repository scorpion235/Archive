//������������� �����
unit fServiceEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls;

type
  TfrmServiceEd = class(TForm)
    lblNum: TLabel;
    lblName: TLabel;
    lblType: TLabel;
    cbType: TDBComboBoxEh;
    edName: TDBEditEh;
    btnOK: TButton;
    btnCancel: TButton;
    edNum: TDBEditEh;
    edService_id: TDBEditEh;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fForm_mode: string[10];
    procedure SetTypeList(cb: TDBComboBoxEh);
  public
    procedure AddService(ds: TDataSource);
    procedure EditService(ds: TDataSource);
  end;

var
  frmServiceEd: TfrmServiceEd;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmServiceEd.FormCreate(Sender: TObject);
begin
	edService_id.Visible := false;
	SetTypeList(cbType);
end;

//������� ������ ����� �����
procedure TfrmServiceEd.SetTypeList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT "TYPE", NAME'
	+ ' FROM SERV_TYPES'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ ����� �����.');
                exit;
	end;

        cb.Items.Clear;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('TYPE').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//�������� ������
procedure TfrmServiceEd.AddService(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode       := 'add';
        cbType.ItemIndex := 0;
        edNum.Text       := '';
        edName.Text      := '';

	Caption := Caption + ' (����������)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//��������� ������������� SERVICE_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SERVICE_ID) MAX_ID FROM SERVICES';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� SERVICE_ID.');
	                exit;
		end;

                //������� SERVICES �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SERVICES('
                	+ '  SERVICE_ID'
                        + ', "TYPE"'
                        + ', NUM'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: ����� ������������ GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',''' + cbType.KeyItems.Strings[cbType.ItemIndex] + ''''
                        + ',' + edNum.Text
                        + ',''' + edName.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� �����.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ����
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('SERVICE_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('TYPE').AsString        := cbType.Text;
                ds.DataSet.FieldByName('NUM').AsString         := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString        := edName.Text;
                ds.DataSet.FieldByName('VISIBLE').AsInteger    := 0;
                ds.DataSet.FieldByName('IS_EDIT').AsInteger    := 1;
                ds.DataSet.Post;
        end;
end;

//������������� ������
procedure TfrmServiceEd.EditService(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode        := 'edit';
	edService_id.Text := ds.DataSet.FieldByName('SERVICE_ID').AsString;
        cbType.Text       := ds.DataSet.FieldByName('TYPE').AsString;
        edNum.Text        := ds.DataSet.FieldByName('NUM').AsString;
        edName.Text       := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE SERVICES SET'
                	+ '  "TYPE"  = ''' + cbType.KeyItems.Strings[cbType.ItemIndex] + ''''
                        + ', NUM     = ' + edNum.Text
                        + ', NAME    = ''' + edName.Text + ''''
		+ ' WHERE SERVICE_ID = ' + edService_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� �������������� ������ � ������� �����.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //����������� ������ � ����
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('TYPE').AsString := cbType.Text;
                ds.DataSet.FieldByName('NUM').AsString  := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString := edName.Text;
                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmServiceEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//�������� �� �������
	if (edNum.Text = '') then
		StopClose(self, '�� ������ ������� ����� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edNum)
        else if (cbType.Text = '') then
		StopClose(self, '�� ������ ������� ��� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbType)
        else if (edName.Text = '') then
		StopClose(self, '�� ������ ������� �������� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //��������, ��� ����� ������ ����� �����
        else if (not TryGetInt(edNum.Text)) then
		StopClose(self, '����� ������ ������ ���� ����� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edNum)

        //��������, ��� ����� ������ ��������������� �����
        else if (StrToInt(edNum.Text) < 0) then
		StopClose(self, '����� ������ ������ ���� ���������������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edNum)

        //��������, ��� �������� ������ �������� 70 ��������
        else if (Length(edName.Text) > 70) then
        	StopClose(self, '�������� ������ ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //�������� �� ����������� � �������� ������ ����������� ��������
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('� �������� ������ ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edName)

        else
        begin
        	//��������, ��� ����� ������ ��������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NAME'
        	+ ' FROM SERVICES WHERE NUM = ' + edNum.Text);

                //���� ������ ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SERVICE_ID <> ' + edService_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ ������ ������.' + #13 +
                        '���������, ��� � ������ �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edNum);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('������ ����� %s ��� ����������%s(%s).%s%s������� [��] ��� �������� � ����.', [edNum.Text, #13, DataMod.IB_Cursor.FieldByName('NAME').AsString, #13, #13]), edNum);
                        exit;
                end;

                DataMod.IB_Cursor.Close;

        	//��������, ��� �������� ������ ���������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NUM'
        	+ ' FROM SERVICES WHERE UPPER(NAME) = UPPER(''' + edName.Text + ''')');

                //���� ������ ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SERVICE_ID <> ' + edService_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ �������� ������.' + #13 +
                        '���������, ��� � �������� �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edName);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('������ "%s"%s��� ���������� (����� %d).%s%s������� [��] ��� �������� � ����.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('NUM').AsInteger, #13, #13]), edName);
                        exit;
                end;
                
                DataMod.IB_Cursor.Close;
        end;
end;

end.
