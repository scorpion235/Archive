//Корректировка подуслуг
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

//добавить запись
procedure TfrmSubSrvEd.AddSubSrv(ds: TDataSource; service_id: integer);
var
	max_id, mr: integer;
begin
	fForm_mode  := 'add';
        edService_id.Text := IntToStr(service_id);
        edNum.Text  := '';
        edName.Text := '';

	Caption := Caption + ' (добавление)';

	mr := ShowModal;
        if (mr = mrOk) then
	begin
        	max_id := 0;
        	//получение максимального SUBSRV_ID
        	DataMod.IB_Cursor.SQL.Text := 'SELECT MAX(SUBSRV_ID) MAX_ID FROM SUBSRV';
                //MsgBox(DataMod.IB_Cursor.SQL.Text);
                
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при нахождении максимального SUBSRV_ID.');
	                exit;
		end;

                //таблица SUBSRV непуста
                if (DataMod.IB_Cursor.RecordCount > 0) then
                	max_id := DataMod.IB_Cursor.FieldByName('MAX_ID').AsInteger;

                DataMod.IB_Cursor.Close;

                //добавляем запись в базу данных
                DataMod.IB_Cursor.SQL.Text := 'INSERT INTO SUBSRV('
                	+ '  SUBSRV_ID'
                        + ', SERVICE_ID'
                        + ', SUB_SRV_PU'
                        + ', NAME)'
		+ ' VALUES('
                	//TODO: можно использовать GEN_ID
                	//+ '     GEN_ID(GEN_AB, 1)'
                        + IntToStr(max_id + 1)
                        + ',' + edService_id.Text
                        + ',''' + edNum.Text + ''''
                        + ',''' + edName.Text + ''')';

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при добавлении записи в таблицу подуслуг.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //добавляем запись в грид в конец
                ds.DataSet.Append;
                ds.DataSet.FieldByName('SUBSRV_ID').AsInteger  := max_id + 1;
                ds.DataSet.FieldByName('SERVICE_ID').AsString  := edService_id.Text;
                ds.DataSet.FieldByName('SUB_SRV_PU').AsString  := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString        := edName.Text;
                ds.DataSet.Post;
        end;
end;

//редактировать запись

//TODO: в этой процедуре входной параметр service_id не используется,
//зато он нужен при проверке уникальности названия подуслуги!
procedure TfrmSubSrvEd.EditSubSrv(ds: TDataSource; service_id: integer);
var
	mr: integer;
begin
	fForm_mode        := 'edit';
        edSubSrv_id.Text  := ds.DataSet.FieldByName('SUBSRV_ID').AsString;
	edService_id.Text := IntToStr(service_id);
        edNum.Text        := ds.DataSet.FieldByName('SUB_SRV_PU').AsString;
        edName.Text       := ds.DataSet.FieldByName('NAME').AsString;

	Caption := Caption + ' (редактирование)';
	mr := ShowModal;
        if (mr = mrOk) then
	begin
                DataMod.IB_Cursor.SQL.Text := 'UPDATE SUBSRV SET'
                        + '  SUB_SRV_PU = ''' + edNum.Text + ''''
                        + ', NAME       = ''' + edName.Text + ''''
		+ ' WHERE SUBSRV_ID     = ' + edSubSrv_id.Text;

                //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		WarningBox('Ошибка при редактировании записи в таблице подуслуг.');
	                exit;
		end;

                DataMod.IB_Cursor.Close;
                DataMod.IB_Transaction.Commit;

                //редактируем запись в грид
                ds.DataSet.Edit;
                ds.DataSet.FieldByName('SUB_SRV_PU').AsString := edNum.Text;
                ds.DataSet.FieldByName('NAME').AsString       := edName.Text;
                ds.DataSet.Post;
	end;
end;

//нажатие на кнопку OK
procedure TfrmSubSrvEd.btnOKClick(Sender: TObject);
var
	ch: string;
        pos: word;
begin
	//проверка на пустоту
	if (edNum.Text = '') then
		StopClose(self, 'Вы забыли указать номер подуслуги.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edNum)
        else if (edName.Text = '') then
		StopClose(self, 'Вы забыли указать название подуслуги.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка, что название подуслуги небольше 70 символов
        else if (Length(edName.Text) > 70) then
        	StopClose(self, 'Название подуслуги должно быть небольше 70 символов.' + #13 + #13 + 'Нажмите [ОК] для перехода к полю.', edName)

        //проверка на присутствие в номере подуслуги запрещенных символов
	else if (CheckCorrectString(edNum.Text, ch, pos)) then
		StopClose(self, format('В номере подуслуги использован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edNum)

        //проверка на присутствие в названии подуслуги запрещенных символов
	else if (CheckCorrectString(edName.Text, ch, pos)) then
		StopClose(self, format('В названии подуслуги спользован недопустимый символ: %s (позиция: %d)%s%sНажмите [ОК] для перехода к полю.',[ch, pos, #13, #13]), edName)

        else
        begin
        	//проверка, что номер подуслуги уникален
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT NAME'
        	+ ' FROM SUBSRV'
                + ' WHERE SERVICE_ID = ' + edService_id.Text
                + ' AND UPPER(SUB_SRV_PU) = UPPER(''' + edNum.Text + ''')');

                //если подуслуга открыта на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID <> ' + edSubSrv_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности номера подуслуги.' + #13 +
                        'Убедитесь, что в номере не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edNum);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Подуслуга номер %s уже существует%s(%s).%s%sНажмите [ОК] для перехода к полю.', [edNum.Text, #13, DataMod.IB_Cursor.FieldByName('NAME').AsString, #13, #13]), edNum);
                        exit;
                end;

                DataMod.IB_Cursor.Close;

        	//проверка, что название подуслуги уникально
                DataMod.IB_Cursor.SQL.Clear;
	        DataMod.IB_Cursor.SQL.Add('SELECT SUB_SRV_PU'
        	+ ' FROM SUBSRV'
                + ' WHERE SERVICE_ID = ' + edService_id.Text
                + ' AND NAME = ''' + edName.Text + '''');

                //если подуслуга открыта на редактирование
                if (fForm_mode = 'edit') then
                	DataMod.IB_Cursor.SQL.Add(' AND SUBSRV_ID <> ' + edSubSrv_id.Text);

	        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        	//запуск запроса
	        try
		        DataMod.IB_Cursor.Open;
	        except
        		StopClose(self, 'Ошибка при проверке уникальности названия подуслуги.' + #13 +
                        'Убедитесь, что в названии не присутствуют спецсимволы.' + #13 + #13 +
                        'Нажмите [ОК] для перехода к полю.', edName);
	                exit;
		end;

                if (DataMod.IB_Cursor.RecordCount > 0) then
                begin
                 	StopClose(self, format('Подуслуга "%s"%sуже существует (номер %s).%s%sНажмите [ОК] для перехода к полю.', [edName.Text, #13, DataMod.IB_Cursor.FieldByName('SUB_SRV_PU').AsString, #13, #13]), edName);
                        exit;
                end;

                DataMod.IB_Cursor.Close;
        end;
end;

end.
