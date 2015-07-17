//������������� �������
unit fCityEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls;                    

type
  TfrmCityEd = class(TForm)
    lblName: TLabel;
    edName: TDBEditEh;
    btnOK: TButton;
    btnCancel: TButton;
    edCity_id: TDBEditEh;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    fForm_mode: string[10];
  public
    procedure AddCity(ds: TDataSource);
    procedure EditCity(ds: TDataSource);
  end;

var
  frmCityEd: TfrmCityEd;

implementation

uses
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmCityEd.FormCreate(Sender: TObject);
begin
	edCity_id.Visible := false;
end;

//�������� ������
procedure TfrmCityEd.AddCity(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode  := 'add';
        edName.Text := '';

	Caption := Caption + ' (����������)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//��������� ������������� SUBSRV_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(CITY_ID) MAX_ID FROM CITY_LIST';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� CITY_ID.');
	                exit;
		end;

                //������� CITY_LIST �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO CITY_LIST('
                	+ '  CITY_ID'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: ����� ������������ GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',''' + edName.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� �������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ����
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('CITY_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('NAME').AsString     := edName.Text;
                ds.DataSet.FieldByName('IS_EDIT').AsInteger := 1;
                ds.DataSet.Post;
        end;
end;

//������������� ������
procedure TfrmCityEd.EditCity(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode     := 'edit';
	edCity_id.Text := ds.DataSet.FieldByName('CITY_ID').AsString;
        edName.Text    := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE CITY_LIST SET'
                        + ' NAME  = ''' + edName.Text + ''''
		+ ' WHERE CITY_ID = ' + edCity_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� �������������� ������ � ������� �������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //����������� ������ � ����
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('NAME').AsString := edName.Text;
                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmCityEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//�������� �� �������
	if (edName.Text = '') then
		StopClose(self, '�� ������ ������� �������� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //��������, ��� �������� ������ �������� 70 ��������
        else if (Length(edName.Text) > 70) then
        	StopClose(self, '�������� ������ ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edName)

        //�������� �� ����������� � �������� ������ ����������� ��������
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('� �������� ������ ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edName)


        else
        begin
        	//��������, ��� �������� ������ ���������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT CITY_ID'
        	+ ' FROM CITY_LIST'
                + ' WHERE UPPER(NAME) = UPPER(''' + edName.Text + ''')');

                //���� ����� ������ �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND CITY_ID <> ' + edCity_id.Text);

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
                 	StopClose(self, format('����� "%s"%s��� ���������� (ID #%d).%s%s������� [��] ��� �������� � ����.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('CITY_ID').AsInteger, #13, #13]), edName);
                        exit;
                end;
                
                DataMod.IB_Cursor.Close;
        end;
end;

end.
