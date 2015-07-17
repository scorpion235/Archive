//������������� ����
unit fStreetEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls;

type
  TfrmStreetEd = class(TForm)
    lblStreet: TLabel;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
    edStreet: TDBEditEh;
    btnOK: TButton;
    btnCancel: TButton;
    edStreet_id: TDBEditEh;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fForm_mode: string[10];
    procedure SetCityList(cb: TDBComboBoxEh);
  public
    procedure AddStreet(ds: TDataSource);
    procedure EditStreet(ds: TDataSource);
  end;

var
  frmStreetEd: TfrmStreetEd;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmStreetEd.FormCreate(Sender: TObject);
begin
	edStreet_id.Visible := false;
	SetCityList(cbCity);
end;

//������� ������ ����� ����
procedure TfrmStreetEd.SetCityList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT CITY_ID, NAME'
	+ ' FROM CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ �������.');
                exit;
	end;

        cb.Items.Clear;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('CITY_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//�������� ������
procedure TfrmStreetEd.AddStreet(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode       := 'add';
        cbCity.ItemIndex := 0;
        edStreet.Text    := '';

	Caption := Caption + ' (����������)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//��������� ������������� SERVICE_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(STREET_ID) MAX_ID FROM STREET_LIST';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� STREET_ID.');
	                exit;
		end;

                //������� SERVICES �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO STREET_LIST('
                	+ '  STREET_ID'
                        + ', CITY_ID'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: ����� ������������ GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + InttoStr(max_id + 1)
                        + ',' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
                        + ',''' + edStreet.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� ����.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ����
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('STREET_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('CITY').AsString       := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString     := edStreet.Text;
                ds.DataSet.FieldByName('IS_EDIT').AsInteger   := 1;
                ds.DataSet.Post;
        end;
end;

//������������� ������
procedure TfrmStreetEd.EditStreet(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode       := 'edit';
	edStreet_id.Text := ds.DataSet.FieldByName('STREET_ID').AsString;
        cbCity.Text      := ds.DataSet.FieldByName('CITY').AsString;
        edStreet.Text    := ds.DataSet.FieldByName('STREET').AsString;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE STREET_LIST SET'
                	+ '  CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
                        + ', NAME    = ''' + edStreet.Text + ''''
		+ ' WHERE STREET_ID  = ' + edStreet_id.Text;

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
                ds.DataSet.FieldByName('CITY').AsString   := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := edStreet.Text;
                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmStreetEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//�������� �� �������
        if (cbCity.Text = '') then
		StopClose(self, '�� ������ ������� �����.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbCity)
        else if (edStreet.Text = '') then
		StopClose(self, '�� ������ ������� �������� �����.' + #13 + #13 + '������� [��] ��� �������� � ����.', edStreet)

        //��������, ��� �������� ������ �������� 70 ��������
        else if (Length(edStreet.Text) > 70) then
        	StopClose(self, '�������� ����� ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edStreet)

        //�������� �� ����������� � �������� ����� ����������� ��������
	else if (CheckCorrectString(edStreet.Text, ch, pos)) then
		StopClose(self, format('� �������� ����� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edStreet)


        else
        begin
        	//��������, ��� �������� ������ ��������� (� ������ ������)
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT STREET_ID'
        	+ ' FROM STREET_LIST WHERE UPPER(NAME) = UPPER(''' + edStreet.Text + ''')'
                + ' AND CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);
                //���� ������ ������� �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND STREET_ID <> ' + edStreet_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ �������� �����.' + #13 +
                        '���������, ��� � �������� �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edStreet);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('����� "%s"%s��� ���������� � ������ "%s" (ID #%d).%s%s������� [��] ��� �������� � ����.', [edStreet.Text, #13, cbCity.Text, DataMod.IB_Cursor.FieldByName('STREET_ID').AsInteger, #13, #13]), edStreet);
                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;
end;

end.
