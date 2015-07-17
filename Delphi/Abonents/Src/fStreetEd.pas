//Корректировка улиц
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

//задание списка типов улиц
procedure TfrmStreetEd.SetCityList(cb: TDBComboBoxEh);
begin
        DataMod.IB_Cursor.SQL.Text := 'SELECT CITY_ID, NAME'
	+ ' FROM CITY_LIST'
	+ ' ORDER BY NAME';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении списка городов.');
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

//добавить запись
procedure TfrmStreetEd.AddStreet(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode       := 'add';
        cbCity.ItemIndex := 0;
        edStreet.Text    := '';

	Caption := Caption + ' (добавление)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//получение максимального SERVICE_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(STREET_ID) MAX_ID FROM STREET_LIST';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при нахождении максимального STREET_ID.');
	                exit;
		end;

                //таблица SERVICES непуста
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //добавляем запись в базу данных
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO STREET_LIST('
                	+ '  STREET_ID'
                        + ', CITY_ID'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: можно использовать GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + InttoStr(max_id + 1)
                        + ',' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
                        + ',''' + edStreet.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при добавлении записи в таблицу улиц.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //добавляем запись в грид
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('STREET_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('CITY').AsString       := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString     := edStreet.Text;
                ds.DataSet.FieldByName('IS_EDIT').AsInteger   := 1;
                ds.DataSet.Post;
        end;
end;

//редактировать запись
procedure TfrmStreetEd.EditStreet(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode       := 'edit';
	edStreet_id.Text := ds.DataSet.FieldByName('STREET_ID').AsString;
        cbCity.Text      := ds.DataSet.FieldByName('CITY').AsString;
        edStreet.Text    := ds.DataSet.FieldByName('STREET').AsString;

	Caption := Caption + ' (редактирование)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE STREET_LIST SET'
                	+ '  CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]
                        + ', NAME    = ''' + edStreet.Text + ''''
		+ ' WHERE STREET_ID  = ' + edStreet_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при редактировании записи в таблице улиц.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //редактируем запись в грид
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('CITY').AsString   := cbCity.Text;
                ds.DataSet.FieldByName('STREET').AsString := edStreet.Text;
                ds.DataSet.Post;
	end;
end;

//нажатие на кнопку OK
procedure TfrmStreetEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//проверка на пустоту
        if (cbCity.Text = '') then
		StopClose(self, 'Вы забыли указать город.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', cbCity)
        else if (edStreet.Text = '') then
		StopClose(self, 'Вы забыли указать название улицы.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edStreet)

        //проверка, что название услуги небольше 70 символов
        else if (Length(edStreet.Text) > 70) then
        	StopClose(self, 'Название улицы должно быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edStreet)

        //проверка на присутствие в названии улицы запрещенных символов
	else if (CheckCorrectString(edStreet.Text, ch, pos)) then
		StopClose(self, format('В названии улицы использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edStreet)


        else
        begin
        	//проверка, что название услуги уникально (в рамках города)
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT STREET_ID'
        	+ ' FROM STREET_LIST WHERE UPPER(NAME) = UPPER(''' + edStreet.Text + ''')'
                + ' AND CITY_ID = ' + cbCity.KeyItems.Strings[cbCity.ItemIndex]);
                //если услуга открыта на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND STREET_ID <> ' + edStreet_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности названия улицы.' + #13 +
                        'Убедитесь, что в названии не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edStreet);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Улица "%s"%sуже существует в городе "%s" (ID #%d).%s%sНажмите [ОК] для перехода к полю.', [edStreet.Text, #13, cbCity.Text, DataMod.IB_Cursor.FieldByName('STREET_ID').AsInteger, #13, #13]), edStreet);
                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;
end;

end.
