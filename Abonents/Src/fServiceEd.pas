//Корректировка услуг
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

//задание списка типов услуг
procedure TfrmServiceEd.SetTypeList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT "TYPE", NAME'
	+ ' FROM SERV_TYPES'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка типов услуг.');
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

//добавить запись
procedure TfrmServiceEd.AddService(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode       := 'add';
        cbType.ItemIndex := 0;
        edNum.Text       := '';
        edName.Text      := '';

	Caption := Caption + ' (добавление)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//получение максимального SERVICE_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SERVICE_ID) MAX_ID FROM SERVICES';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при нахождении максимального SERVICE_ID.');
	                exit;
		end;

                //таблица SERVICES непуста
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //добавляем запись в базу данных
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SERVICES('
                	+ '  SERVICE_ID'
                        + ', "TYPE"'
                        + ', NUM'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: можно использовать GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',''' + cbType.KeyItems.Strings[cbType.ItemIndex] + ''''
                        + ',' + edNum.Text
                        + ',''' + edName.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при добавлении записи в таблицу услуг.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //добавляем запись в грид
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

//редактировать запись
procedure TfrmServiceEd.EditService(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode        := 'edit';
	edService_id.Text := ds.DataSet.FieldByName('SERVICE_ID').AsString;
        cbType.Text       := ds.DataSet.FieldByName('TYPE').AsString;
        edNum.Text        := ds.DataSet.FieldByName('NUM').AsString;
        edName.Text       := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (редактирование)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE SERVICES SET'
                	+ '  "TYPE"  = ''' + cbType.KeyItems.Strings[cbType.ItemIndex] + ''''
                        + ', NUM     = ' + edNum.Text
                        + ', NAME    = ''' + edName.Text + ''''
		+ ' WHERE SERVICE_ID = ' + edService_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при редактировании записи в таблице услуг.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //редактируем запись в грид
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('TYPE').AsString := cbType.Text;
                ds.DataSet.FieldByName('NUM').AsString  := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString := edName.Text;
                ds.DataSet.Post;
	end;
end;

//нажатие на кнопку OK
procedure TfrmServiceEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//проверка на пустоту
	if (edNum.Text = '') then
		StopClose(self, 'Вы забыли указать номер услуги.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edNum)
        else if (cbType.Text = '') then
		StopClose(self, 'Вы забыли указать тип услуги.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbType)
        else if (edName.Text = '') then
		StopClose(self, 'Вы забыли указать название услуги.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка, что номер услуги целое число
        else if (not TryGetInt(edNum.Text)) then
		StopClose(self, 'Номер услуги должен быть целым числом.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edNum)

        //проверка, что номер услуги неотрицательное число
        else if (StrToInt(edNum.Text) < 0) then
		StopClose(self, 'Номер услуги должен быть неотрицательным.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edNum)

        //проверка, что название услуги небольше 70 символов
        else if (Length(edName.Text) > 70) then
        	StopClose(self, 'Название услуги должно быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка на присутствие в названии услуги запрещенных символов
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('В названии услуги использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edName)

        else
        begin
        	//проверка, что номер услуги уникален
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NAME'
        	+ ' FROM SERVICES WHERE NUM = ' + edNum.Text);

                //если услуга открыта на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SERVICE_ID <> ' + edService_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности номера услуги.' + #13 +
                        'Убедитесь, что в номере не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edNum);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Услуга номер %s уже существует%s(%s).%s%sНажмите [ОК] для перехода к полю.', [edNum.Text, #13, DataMod.IB_Cursor.FieldByName('NAME').AsString, #13, #13]), edNum);
                        exit;
                end;

                DataMod.IB_Cursor.Close;

        	//проверка, что название услуги уникально
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NUM'
        	+ ' FROM SERVICES WHERE UPPER(NAME) = UPPER(''' + edName.Text + ''')');

                //если услуга открыта на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SERVICE_ID <> ' + edService_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности названия услуги.' + #13 +
                        'Убедитесь, что в названии не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edName);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Услуга "%s"%sуже существует (номер %d).%s%sНажмите [ОК] для перехода к полю.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('NUM').AsInteger, #13, #13]), edName);
                        exit;
                end;
                
                DataMod.IB_Cursor.Close;
        end;
end;

end.
