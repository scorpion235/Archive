//������������� ���������
unit fAbonentEd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, Mask, DB, DBCtrlsEh, IB_Controls, ToolEdit,
  CurrEdit;

type
  TfrmAbonentEd = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    edAbonent_id: TDBEditEh;
    lblService: TLabel;
    cbService: TDBComboBoxEh;
    lblSubSrv: TLabel;
    cbSubSrv: TDBComboBoxEh;                                       
    lblFIO: TLabel;
    edFIO: TDBEditEh;
    lblCity: TLabel;
    cbCity: TDBComboBoxEh;
    lblStreet: TLabel;
    cbStreet: TDBComboBoxEh;
    lblBuilding: TLabel;
    edBuilding: TDBEditEh;
    lblApartment: TLabel;
    edApartment: TDBEditEh;
    lblBalance: TLabel;
    lblAcc_pu: TLabel;
    edAcc_pu: TDBEditEh;
    cbAllSubSrv: TCheckBox;
    edBalance: TCurrencyEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbServiceChange(Sender: TObject);
    procedure cbCityChange(Sender: TObject);
    procedure cbAllSubSrvClick(Sender: TObject);
  private
    fForm_mode: string[10];
    fSetSubSrvList: boolean;
    fSetStreetList: boolean;
    procedure SetServiceList(cb: TDBComboBoxEh);
    procedure SetSubSrvList(cb: TDBComboBoxEh);
    procedure SetCityList(cb: TDBComboBoxEh);
    procedure SetStreetList(cb: TDBComboBoxEh);
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    procedure AddAbonent(ds: TDataSource);
    //������� ���������� ���������� ������� �� �������
    //����������� � ����� �� �/� �� ��������� ������
    function EditAbonent(ds: TDataSource): word;
  end;

var
  frmAbonentEd: TfrmAbonentEd;

implementation

uses
        fAllSubSrvWarning,
	dmAbonents,
        uCommon;

{$R *.dfm}

procedure TfrmAbonentEd.FormCreate(Sender: TObject);
begin
	edAbonent_id.Visible := false;
        edBalance.Enabled    := false;
        fSetSubSrvList       := false;
        fSetStreetList       := false;

        fForm_mode := 'add';
	SetServiceList(cbService);
        SetCityList(cbCity);
        //SetSubSrvList � SetStreetList ���������� � LoadFromIni

        LoadFromIni;

        fSetSubSrvList := true;
        fSetStreetList := true;
end;

//������� ������ �����
procedure TfrmAbonentEd.SetServiceList(cb: TDBComboBoxEh);
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

        //���������� ����� = 0
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	WarningBox('�� ������� �� ���� �������� ������ ��� �����������.' + #13 +
                '���������� ��������� ����������.' + #13 + #13 +
		'�������� ������(�) � ����������� �����.');
                btnOK.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        cb.Items.Clear;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SERVICE_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//������� ������ ��������
procedure TfrmAbonentEd.SetSubSrvList(cb: TDBComboBoxEh);
begin
        cb.Items.Clear;
        cb.Enabled := false;
        lblSubSrv.Font.Color := clBlack;
        cbAllSubSrv.Visible  := false;
        cbAllSubSrv.Checked  := false;

        DataMod.IB_Cursor.SQL.Text := 'SELECT SUBSRV_ID, NAME'
        + ' FROM SUBSRV'
	+ ' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
	+ ' ORDER BY NAME';
        
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ ��������.');
                exit;
	end;

	//� ������ ��� ��������
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	cb.Items.Add('��� ��������');
                cb.KeyItems.Add('��� ��������');
                cb.ItemIndex := 0;
        	cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        //���������� ���-���� "��� ���������"
        if (fForm_mode = 'add') then
        begin
        	cb.Enabled := false;
                cbAllSubSrv.Visible := true;
                cbAllSubSrv.Checked := true;
        end;

        lblSubSrv.Font.Color := clRed;
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('SUBSRV_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        cb.ItemIndex := 0;
        DataMod.IB_Cursor.Close;
end;

//������� ������ �������
procedure TfrmAbonentEd.SetCityList(cb: TDBComboBoxEh);
begin
	DataMod.IB_Cursor.SQL.Clear;
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
        //cb.Items.Add('');
        //cb.KeyItems.Add('');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('CITY_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        DataMod.IB_Cursor.Close;
end;

//������� ������ ����
procedure TfrmAbonentEd.SetStreetList(cb: TDBComboBoxEh);
begin
        cb.Items.Clear;
        cb.Enabled := false;

        DataMod.IB_Cursor.SQL.Text := 'SELECT STREET_ID, NAME'
        + ' FROM STREET_LIST'
	+ ' WHERE CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
	+ ' ORDER BY NAME';
        
        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //������ �������
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('������ ��� ���������� ������ ����.');
                exit;
	end;

	//� ������ ��� ����
        if (DataMod.IB_Cursor.RecordCount = 0) then
        begin
        	cb.Items.Add('��� ����');
                cb.KeyItems.Add('��� ����');
                cb.ItemIndex := 0;
        	cb.Enabled := false;
           	DataMod.IB_Cursor.Close;
                exit;
        end;

        cb.Enabled := true;
        //cb.Items.Add('');
        //cb.KeyItems.Add('');
        while (not (DataMod.IB_Cursor.Eof)) do
        begin
        	cb.Items.Add(DataMod.IB_Cursor.FieldByName('NAME').AsString);
                cb.KeyItems.Add(DataMod.IB_Cursor.FieldByName('STREET_ID').AsString);
                DataMod.IB_Cursor.Next;
        end;

        cb.ItemIndex := 0;
        DataMod.IB_Cursor.Close;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//�������� ���������� �� ini-�����
procedure TfrmAbonentEd.LoadFromIni;
var
	sect: string;
begin
	sect := 'AbonentEd';

        if (cbService.Items.Count > 0) then
        	cbService.Text := OptionsIni.ReadString(sect, 'Service', '');

        if (cbService.Text = '') then
         	cbService.ItemIndex := 0;

        SetSubSrvList(cbSubSrv);

        cbSubSrv.Text    := OptionsIni.ReadString(sect, 'SubSrv', '[��� ���������]');
        if (cbSubSrv.Text = '') then
         	cbSubSrv.ItemIndex := 0;

        edAcc_pu.Text    := OptionsIni.ReadString(sect, 'Acc_pu', '');
        edFIO.Text       := OptionsIni.ReadString(sect, 'FIO', '');
        cbCity.Text      := OptionsIni.ReadString(sect, 'City', '���������');

        SetStreetList(cbStreet);

        cbStreet.Text    := OptionsIni.ReadString(sect, 'Street', '');
        edBuilding.Text  := OptionsIni.ReadString(sect, 'Building', '');
        edApartment.Text := OptionsIni.ReadString(sect, 'Apartment', '');
end;

//���������� ���������� � ini-����
procedure TfrmAbonentEd.SaveToIni;
var
	sect: string;
begin
	sect := 'AbonentEd';
	OptionsIni.WriteString(sect, 'Service', cbService.Text);
        OptionsIni.WriteString(sect, 'SubSrv', cbSubSrv.Text);
        OptionsIni.WriteString(sect, 'Acc_pu', edAcc_pu.Text);
        OptionsIni.WriteString(sect, 'FIO', edFIO.Text);
        OptionsIni.WriteString(sect, 'City', cbCity.Text);
        OptionsIni.WriteString(sect, 'Street', cbStreet.Text);
        OptionsIni.WriteString(sect, 'Building', edBuilding.Text);
        OptionsIni.WriteString(sect, 'Apartment', edApartment.Text);
end;

//------------------------------------------------------------------------------
//�������� ������
procedure TfrmAbonentEd.AddAbonent(ds: TDataSource);
var
	i
        , max_id
        , sub_srv_count
        , mr: integer;
        open_time: string;
begin
	fForm_mode := 'add';
	Caption := Caption + ' (����������)';

	mr := ShowModal;
        if (mr = mrCancel) then
        	exit;

        sub_srv_count := 1;
        if (cbAllSubSrv.Checked) then
        	sub_srv_count := cbSubSrv.Items.Count;

        //���� � ������ ��� ��������, �� ���� ��� ����� ���������� 1 ���
        for i := 1 to sub_srv_count do
	begin
        	max_id    := 0;
                open_time := DateTimeToStr(Now);

        	//��������� ������������� ABONENT_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(ABONENT_ID) MAX_ID FROM ABONENTS';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);

        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������������� ABONENT_ID.');
	                exit;
		end;

                //������� ABONENTS �������
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //��������� ������ � ���� ������
                DataMod.IB_Cursor.SQL.Clear;
                DataMod.IB_Cursor.SQL.Add('INSERT INTO ABONENTS('
                	+ '  ABONENT_ID'
                        + ', SERVICE_ID'
                        + ', SUBSRV_ID'
                	+ ', CITY_ID'
                        + ', STREET_ID'
                        + ', FIO'
                        + ', BUILDING'
                        + ', APARTMENT'
                        + ', ACC_PU'
                        + ', OPEN_TIME)'
		+ ' VALUES('
                //TODO: ����� ������������ GEN_ID
                //+ '     GEN_ID(GEN_AB, 1)'
                + IntToStr(max_id + 1)

                //--------------------------------------------------------------
                //������
                + ', ' + cbService.KeyItems.Strings[cbService.ItemIndex]);
                //--------------------------------------------------------------
                //���������
                if (cbSubSrv.Enabled) then
                	DataMod.IB_Cursor.SQL.Add(', ' + cbSubSrv.KeyItems.Strings[cbSubSrv.ItemIndex])
                //������� ��� ���������
                else if ((cbAllSubSrv.Visible) and (cbAllSubSrv.Checked)) then
                	DataMod.IB_Cursor.SQL.Add(', ' + cbSubSrv.KeyItems.Strings[i - 1])
                //� ������ ��� ��������
                else
                    	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //�����
                if (cbCity.Text <> '') then
                        DataMod.IB_Cursor.SQL.Add(', ' + cbCity.KeyItems.Strings[cbCity.ItemIndex])
                else
                    	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
        	//�����
                DataMod.IB_Cursor.SQL.Add(', ' + cbStreet.KeyItems.Strings[cbStreet.ItemIndex]);
                //--------------------------------------------------------------
                //��� ��������
                if (edFIO.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', ''' + edFIO.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //���
                DataMod.IB_Cursor.SQL.Add(', ''' + edBuilding.Text + '''');
                //--------------------------------------------------------------
                //��������
                if (edApartment.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', ''' + edApartment.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', NULL');
                //--------------------------------------------------------------
                //������� ����
                DataMod.IB_Cursor.SQL.Add(', ''' + edAcc_pu.Text + '''');
                //--------------------------------------------------------------
                //���� �������� ��������
                DataMod.IB_Cursor.SQL.Add(', ''' + open_time + ''')');
                //--------------------------------------------------------------
	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� ���������� ������ � ������� ���������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //��������� ������ � ����
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('ABONENT_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('SERVICE').AsString     := cbService.Text;

                //������� ���������
                if (cbSubSrv.Enabled) then
                	ds.DataSet.FieldByName('SUB_SRV').AsString := cbSubSrv.Text
                //������� ��� ���������
                else if (cbAllSubSrv.Checked) then
                        ds.DataSet.FieldByName('SUB_SRV').AsString := cbSubSrv.Items[i - 1]
                //� ������ ��� ��������
                else
                        ds.DataSet.FieldByName('SUB_SRV').AsString := '';

                ds.DataSet.FieldByName('CITY').AsString := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := cbStreet.Text;

                if (edFIO.Text <> '') then
	                ds.DataSet.FieldByName('FIO').AsString := edFIO.Text;

                ds.DataSet.FieldByName('BUILDING').AsString := edBuilding.Text;

                if (edApartment.Text <> '') then
	                ds.DataSet.FieldByName('APARTMENT').AsString := edApartment.Text;

                ds.DataSet.FieldByName('ACC_PU').AsString        := edAcc_pu.Text;
                ds.DataSet.FieldByName('OPEN_TIME').AsString     := open_time;
                ds.DataSet.FieldByName('IS_ACC_LOCK').AsInteger  := 0;
                ds.DataSet.FieldByName('IS_ACC_CLOSE').AsInteger := 0;
                ds.DataSet.FieldByName('BALANCE').AsInteger      := 0;
                ds.DataSet.Post;
        end;
end;

//������������� ������
function TfrmAbonentEd.EditAbonent(ds: TDataSource): word;
var
	mr: integer;
begin
	result := 1;

	fForm_mode          := 'edit';
        edAbonent_id.Text   := ds.DataSet.FieldByName('ABONENT_ID').AsString;
        cbService.Text      := ds.DataSet.FieldByName('SERVICE').AsString;
        cbSubSrv.Text       := ds.DataSet.FieldByName('SUB_SRV').AsString;
        edAcc_pu.Text       := ds.DataSet.FieldByName('ACC_PU').AsString;
        edFIO.Text          := ds.DataSet.FieldByName('FIO').AsString;
        cbCity.Text         := ds.DataSet.FieldByName('CITY').AsString;
        cbStreet.Text       := ds.DataSet.FieldByName('STREET').AsString;
        edBuilding.Text     := ds.DataSet.FieldByName('BUILDING').AsString;
        edApartment.Text    := ds.DataSet.FieldByName('APARTMENT').AsString;
        edBalance.Text      := ds.DataSet.FieldByName('BALANCE').AsString;

        cbService.Enabled   := false;
        cbSubSrv.Enabled    := false;
        edAcc_pu.Enabled    := false;

        cbAllSubSrv.Visible := false;
        cbAllSubSrv.Checked := false;

	Caption := Caption + ' (��������������)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	DataMod.IB_Cursor.SQL.Text := 'SELECT ABONENT_ID'
        	+ ' FROM ABONENTS'
                + ' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
		+ ' AND ACC_PU       = ''' + edAcc_pu.Text + '''';
        
        	//MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
        	try
	        	DataMod.IB_Cursor.Open;
        	except
        		WarningBox('������ ��� ����������� ���������� ������� ��������� � ����� �� �/� �� ��������� ������.');
                	exit;
		end;

        	if ((DataMod.IB_Cursor.RecordCount > 1) and (YesNoBox(format('� ������� ��������� ���������� %d ������(��).%s������: %s%s������� ����: %s%s%s��������� ��������������� �� ��� %d ������(��).%s����������?', [DataMod.IB_Cursor.RecordCount, #13, cbService.Text, #13, edAcc_pu.Text, #13, #13, DataMod.IB_Cursor.RecordCount, #13])) = mrNo)) then
                	exit;

                //������� ���������� ���������� ������� �� ������� ����������� � ����� �� �/�
                result := DataMod.IB_Cursor.RecordCount;

        	DataMod.IB_Cursor.SQL.Clear;
                DataMod.IB_Cursor.SQL.Add('UPDATE ABONENTS SET');
                //--------------------------------------------------------------
                //TODO: ������, ���������, ������� ���� �� �������� ��� ��������������
                //�����
                DataMod.IB_Cursor.SQL.Add(' CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);
                //--------------------------------------------------------------
                //�����
                DataMod.IB_Cursor.SQL.Add(', STREET_ID = ' + cbStreet.KeyItems.Strings[cbStreet.ItemIndex]);
                //--------------------------------------------------------------
                //��� ��������
                if (edFIO.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', FIO = ''' + edFIO.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', FIO = NULL');
                //--------------------------------------------------------------
                //���
                DataMod.IB_Cursor.SQL.Add(', BUILDING = ''' + edBuilding.Text + '''');
                //--------------------------------------------------------------
                //��������
                if (edApartment.Text <> '') then
                	DataMod.IB_Cursor.SQL.Add(', APARTMENT = ''' + edApartment.Text + '''')
                else
                	DataMod.IB_Cursor.SQL.Add(', APARTMENT = NULL');
                //--------------------------------------------------------------
                DataMod.IB_Cursor.SQL.Add(' WHERE SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]);
		DataMod.IB_Cursor.SQL.Add(' AND ACC_PU       = ''' + edAcc_pu.Text + '''');
                //--------------------------------------------------------------
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('������ ��� �������������� ������ � ������� ���������.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //����������� ������ � ����
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('CITY').AsString   := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := cbStreet.Text;

                if (edFIO.Text <> '') then
	                ds.DataSet.FieldByName('FIO').AsString := edFIO.Text;

                ds.DataSet.FieldByName('BUILDING').AsString := edBuilding.Text;

                if (edApartment.Text <> '') then
	                ds.DataSet.FieldByName('APARTMENT').AsString := edApartment.Text;


                ds.DataSet.Post;
	end;
end;

//������� �� ������ OK
procedure TfrmAbonentEd.btnOKClick(Sender: TObject);
var
	ch, msg: string;
        pos: word;
begin
	//�������� �� �������
	if (cbService.Text = '') then
        try
        	//���� "������" ����� ���� ����������, ���� �� ������� �� ����� ������ ��� �����������
		StopClose(self, '�� ������ ������� ������.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbService)
        except
        	edAcc_pu.SetFocus;
        end

        else if ((cbSubSrv.Enabled) and (cbSubSrv.Text = '')) then
		StopClose(self, '�� ������ ������� ���������.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbSubSrv)
        else if (edAcc_pu.Text = '') then
		StopClose(self, '�� ������ ������� ������� ����.' + #13 + #13 + '������� [��] ��� �������� � ����.', edAcc_pu)
        else if (cbCity.Text = '') then
		StopClose(self, '�� ������ ������� �����.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbCity)
        else if ((cbStreet.Enabled) and (cbStreet.Text = '')) then
		StopClose(self, '�� ������ ������� �����.' + #13 + #13 + '������� [��] ��� �������� � ����.', cbStreet)
        else if (edBuilding.Text = '') then
		StopClose(self, '�� ������ ������� ����� ����.' + #13 + #13 + '������� [��] ��� �������� � ����.', edBuilding)

        //��������, ��� ������� ���� �������� 70 ��������
        else if (Length(edAcc_pu.Text) > 70) then
        	StopClose(self, '������� ���� ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edAcc_pu)

        //��������, ��� ����� ���� �������� 10 ��������
        else if (Length(edBuilding.Text) > 10) then
        	StopClose(self, '����� ���� ������ ���� �������� 10 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edBuilding)

        //��������, ��� ����� �������� �������� 7 ��������
        else if (Length(edApartment.Text) > 7) then
        	StopClose(self, '����� �������� ������ ���� �������� 7 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edApartment)

        //��������, ��� ��� �������� 70 ��������
        else if (Length(edFIO.Text) > 70) then
        	StopClose(self, '��� �������� ������ ���� �������� 70 ��������.' + #13 + #13 + '������� [��] ��� �������� � ����.', edFIO)

        //�������� �� ����������� � ������� ����� ����������� ��������
	else if (CheckCorrectString(edAcc_pu.Text, ch, pos)) then
		StopClose(self, format('� ������� ����� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edAcc_pu)

        //�������� �� ����������� � ��� �������� ����������� ��������
	else if (CheckCorrectString(edFIO.Text, ch, pos)) then
		StopClose(self, format('� ��� �������� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edFIO)

        //�������� �� ����������� � ������ ���� ����������� ��������
	else if (CheckCorrectString(edBuilding.Text, ch, pos)) then
		StopClose(self, format('� ������ ���� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edBuilding)

        //�������� �� ����������� � ������ �������� ����������� ��������
	else if (CheckCorrectString(edApartment.Text, ch, pos)) then
		StopClose(self, format('� ������ �������� ����������� ������������ ������: %s (�������: %d)%s%s������� [��] ��� �������� � ����.',[ch, pos, #13, #13]), edBuilding)

        else
        begin
        	//��������, ��� �/� �������� � ������ ������ ��������
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT ABONENT_ID, ACC_PU'
        	+ ' FROM ABONENTS WHERE ACC_PU = ''' + edAcc_pu.Text + ''''
                + ' AND SERVICE_ID = ' + cbService.KeyItems.Strings[cbService.ItemIndex]
                + ' AND IS_ACC_CLOSE = 0');

                //������� ���������
                if (cbSubSrv.Enabled) then
			DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID = ' + cbSubSrv.KeyItems.Strings[cbSubSrv.ItemIndex]);

                //���� ������� ������ �� ��������������
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND ACC_PU <> ''' + edAcc_pu.Text + '''');

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//������ �������
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, '������ ��� �������� ������������ �������� �����.' + #13 +
                        '���������, ��� � ������� ����� �� ������������ �����������.' + #13 + #13 +
                        '������� [��] ��� �������� � ����.', edAcc_pu);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                        msg := format('������� ��� ���������� (ID #%d):%s������: %s', [DataMod.IB_Cursor.FieldByName('ABONENT_ID').AsInteger, #13, cbService.Text]);

                        if (cbSubSrv.Enabled) then
                         	msg := msg + format('%s���������: %s', [#13, cbSubSrv.Text]);

                        msg := msg + format('%s������� ����: %s%s%s������� [��] ��� �������� � ����.', [#13, edAcc_pu.Text, #13, #13]);
                 	StopClose(self, msg, edAcc_pu);

                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;

        SaveToIni;
end;

procedure TfrmAbonentEd.cbServiceChange(Sender: TObject);
begin
	if (fSetSubSrvList) then
		SetSubSrvList(cbSubSrv);
end;

procedure TfrmAbonentEd.cbCityChange(Sender: TObject);
begin
        if (fSetStreetList) then
		SetStreetList(cbStreet);
end;

procedure TfrmAbonentEd.cbAllSubSrvClick(Sender: TObject);
var
        frm: TfrmAllSubSrvWarning;
        flag: boolean;
        sect: string;
begin
	if (not (cbAllSubSrv.Visible) or (fForm_mode = 'edit')) then
        	exit;

	if (not (cbAllSubSrv.Checked)) then
        begin
        	sect := 'AllSubSrvWarning';
        	flag := OptionsIni.ReadBool(sect, 'AllVisibleSubSrvWarning', false);

                //������� ���� � ���������������
                if (not (flag)) then
                begin
		  	frm := TfrmAllSubSrvWarning.Create(self);
        		frm.ShowModal;
                end;
        end;

	cbSubSrv.Enabled := not cbAllSubSrv.Checked;
end;

end.
