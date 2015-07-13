//Корректировка городов
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

//добавить запись
procedure TfrmCityEd.AddCity(ds: TDataSource);
var
	max_id, mr: integer;
begin
	fForm_mode  := 'add';
        edName.Text := '';

	Caption := Caption + ' (добавление)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//получение максимального SUBSRV_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(CITY_ID) MAX_ID FROM CITY_LIST';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при нахождении максимального CITY_ID.');
	                exit;
		end;

                //таблица CITY_LIST непуста
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //добавляем запись в базу данных
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO CITY_LIST('
                	+ '  CITY_ID'
                        + ', NAME'
                        + ', IS_EDIT)'
		+ ' VALUES('
                	//TODO: можно использовать GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',''' + edName.Text + ''''
                        + ',' + '1)';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при добавлении записи в таблицу городов.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //добавляем запись в грид
                ds.DataSet.Insert;
                ds.DataSet.FieldByName('CITY_ID').AsInteger := max_id + 1;
                ds.DataSet.FieldByName('NAME').AsString     := edName.Text;
                ds.DataSet.FieldByName('IS_EDIT').AsInteger := 1;
                ds.DataSet.Post;
        end;
end;

//редактировать запись
procedure TfrmCityEd.EditCity(ds: TDataSource);
var
	mr: integer;
begin
	fForm_mode     := 'edit';
	edCity_id.Text := ds.DataSet.FieldByName('CITY_ID').AsString;
        edName.Text    := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (редактирование)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE CITY_LIST SET'
                        + ' NAME  = ''' + edName.Text + ''''
		+ ' WHERE CITY_ID = ' + edCity_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при редактировании записи в таблице городов.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //редактируем запись в грид
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('NAME').AsString := edName.Text;
                ds.DataSet.Post;
	end;
end;

//нажатие на кнопку OK
procedure TfrmCityEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//проверка на пустоту
	if (edName.Text = '') then
		StopClose(self, 'Вы забыли указать название города.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка, что название города небольше 70 символов
        else if (Length(edName.Text) > 70) then
        	StopClose(self, 'Название города должно быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка на присутствие в названии города запрещенных символов
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('В названии города использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edName)


        else
        begin
        	//проверка, что название города уникально
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT CITY_ID'
        	+ ' FROM CITY_LIST'
                + ' WHERE UPPER(NAME) = UPPER(''' + edName.Text + ''')');

                //если город открыт на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND CITY_ID <> ' + edCity_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности названия города.' + #13 +
                        'Убедитесь, что в названии не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edName);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Город "%s"%sуже существует (ID #%d).%s%sНажмите [ОК] для перехода к полю.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('CITY_ID').AsInteger, #13, #13]), edName);
                        exit;
                end;
                
                DataMod.IB_Cursor.Close;
        end;
end;

end.
