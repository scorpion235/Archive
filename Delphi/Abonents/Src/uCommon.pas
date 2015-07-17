//Модуль с функциями
//Автор: Дюгуров Сергей Михайлович
//2009 - 2010
unit uCommon;

interface

uses
	Forms,
        StdCtrls,
        Controls,
        SysUtils,
        Windows,
        IniFiles,
        ComCtrls,
        ExtCtrls,
        elTree;

//показывает сообщение об ошибке
procedure ErrorBox(msg: string);
//показывает предупреждение
procedure WarningBox(msg: string);
//показывает сообщение с информацией
procedure MsgBox(msg: string);
//выдается запрос с двумя кнопками "Да" и "Нет"
//возвращает IDYES или IDNO
function YesNoBox(msg: string; Flags: Cardinal = MB_ICONQUESTION): integer;
//показывает окно с сообщением об ошибке
//приостанавливает закрытие модальной формы frm
//при передаче control - выставляет на него фокус
procedure StopClose(frm: TForm; msg: string; Control: TWinControl);
//перемещает фокус на нужный контрол
function SetActiveControl(Control: TWinControl): boolean;
//задание значение в комбобокс
procedure SetComboBox(var cb: TComboBox; str: string);
//задание пути к ini-файлу
function GetDefaultIniFileName: string;
//пытается из строки получить дату
function TryGetDate(str: string): boolean;
//пытается из строки получить дату время
function TryGetDateTime(str: string): boolean;
//пытается из строки получить целое число
function TryGetInt(str: string): boolean;
//пытается из строки получить число с правающей точкой
function TryGetDouble(str: string): boolean;
//проверка на присутствие в строке запрещенных символов
function CheckCorrectString(str: string; var ch: string; var pos: word): boolean;
//пытается из строки, прочитанной из файла, получить целое число
function FileStrToInt(str: String): integer;
//пытается из строки, прочитанной из файла, получить число с плавающей точкой
function FileStrToDouble(str: String): double;
//заменяет decimalseparator на точку
function Sep2Dot(str: string): string;
//заменяет точку на decimalseparator
function Dot2Sep(str: string): string;
//удаляет пробелы в начале строки
function DelLeftSpace(str: string): string;
//преобразует дату из формата dd/mm/yyyy в dd.mm.yyyy
function CorrectDate(str: string): string;

var
	OptionsIniFileName: string;
	OptionsIni: TCustomIniFile;

implementation

uses
	StrUtils;

procedure ErrorBox(msg: string);
begin
	Application.MessageBox(PChar (msg), PChar(Application.Title),
		MB_ICONERROR or MB_OK);
end;

procedure WarningBox(msg: string);
begin
	Application.MessageBox(PChar(msg), PChar(Application.Title),
		MB_ICONWARNING or MB_OK);
end;

procedure MsgBox(msg: string);
begin
	Application.MessageBox (PChar(msg), PChar(Application.Title),
		MB_ICONINFORMATION);
end;

function YesNoBox(msg: string; Flags: Cardinal = MB_ICONQUESTION): integer;
begin
	Result := Application.MessageBox(PChar(msg), PChar(Application.Title),
		MB_YESNO + Flags);
end;

procedure StopClose(frm: TForm; msg: string; Control: TWinControl);
begin
	if (frm <> nil) then
		frm.ModalResult := mrNone;

	Application.MessageBox(PChar(msg), PChar(Application.Title),
		MB_OK+MB_ICONEXCLAMATION);

	if (Control <> nil) then
        	//TODO: почему-то команда SetActiveControl не отрабатывает
		//SetActiveControl(Control);
                Control.SetFocus;
end;

function SetActiveControl(Control: TWinControl): boolean;
var
	Page: TPageControl;
begin
	result := false;
	try
		if (Control  = nil) or (Control.Parent = nil) or (Control.Parent is TForm) then
			exit;

		Control.Parent.Visible := true;
		SetActiveControl(Control.Parent);

		if (Control is TTabSheet) then
		begin
			Page := TPageControl(Control.Parent);
			Page.ActivePage := TTabSheet(Control);
		end;

		if (Control.Parent is TPage) then
			if (Control.Parent.Parent is TNotebook) then
                        	TNotebook(Control.Parent.Parent).ActivePage := TPage(Control.Parent).Caption;

		if Control.Enabled and Control.Visible then
		begin
			Control.SetFocus;
			result := true;
		end;
	finally
	end;
end;

//заполняет TDBComboBox параметрами из ini-файла
//запись параметров через ";"
//например: 1,25;1,26;1,29
procedure SetComboBox(var cb: TComboBox; str: string);
var
	i: integer;
        item: string;
begin
	if (str = '') then
        	exit;

        item := '';
        cb.Items.Clear;

	for i := 1 to length(str) do
		if (str[i] <> ';') then
                	item := item + str[i]
                        
                else
                 	if (item <> '') then
                        begin
                        	cb.Items.Add(item);
	                        item := '';
                        end;

	if (item <> '') then
        	cb.Items.Add(item);
end;

//задание пути к ini-файлу
function GetDefaultIniFileName: string;
var
	path: string;
begin
	path   := ExpandFileName (ParamStr(0));
	result := ChangeFileExt(path, '.ini');
end;

//пытается из строки получить дату
function TryGetDate(str: String): boolean;
begin
	result := true;

	try
		StrToDate(str);
	except on EConvertError do
		result := false;
	end;
end;

//пытается из строки получить дату время
function TryGetDateTime(str: String): boolean;
begin
	result := true;

	try
		StrToDateTime(str);
	except on EConvertError do
		result := false;
	end;
end;

//пытается из строки получить целое число
function TryGetInt(str: String): boolean;
begin
   	result := true;

	try
		StrToInt(str);
	except on EConvertError do
		result := false;
	end;
end;

//пытается из строки получить число с правающей точкой
function TryGetDouble(str: String): boolean;
begin
    	result := true;

	try
		StrToFloat(str);
	except on EConvertError do
		result := false;
	end;
end;

//проверка на присутствие в строке запрещенных символов
function CheckCorrectString(str: String; var ch: string; var pos: word): boolean;
var
	i: word;
begin
        result := false;
        ch  := '';
        pos := 0;
        
	for i := 1 to length(str) do
        if ( (str[i] = '"') or (str[i] = '''') or (str[i] = '|')
        or   (str[i] = '[') or (str[i] = ']')
        or   (str[i] = '{') or (str[i] = '}')
        or   (str[i] = '\') or (str[i] = '/')
        or   (str[i] = ';') or (str[i] = ',') ) then
        begin
        	result := true;
        	ch     := str[i];
                pos    := i;
                break;
        end;
end;

//пытается из строки, прочитанной из файла, получить целое число
function FileStrToInt(str: String): integer;
var
	i: word;
        str_int: string;
begin
	str_int := '';

	for i := 1 to length(str) do
        begin
        	if (((str[i] >= '0') and (str[i] <= '9')) or (str[i] = '-')) then
                 	str_int := str_int + str[i];
        end;

        try
		result := StrToInt(str_int);
	except on EConvertError do
		result := 0;
	end;
end;

//пытается из строки, прочитанной из файла, получить число с плавающей точкой
function FileStrToDouble(str: String): double;
var
	i: word;
        str_double: string;
begin
	str_double := '';

	for i := 1 to length(str) do
        begin
        	if (((str[i] >= '0') and (str[i] <= '9')) or (str[i] = '-')) then
                 	str_double := str_double + str[i]

                //на случай если разделитель целой и дробной части на точка
                else if (str[i] = '.') then
                        str_double := str_double + DecimalSeparator;
        end;

        try
		result := StrToFloat(str_double);
	except on EConvertError do
		result := 0;
	end;
end;

//заменяет decimalseparator на точку
function Sep2Dot(str: string): string;
var
        i, count, prec: word;
begin
	count := 0;
        for i := 1 to length(str) do
        begin
                if (str[i] = DecimalSeparator) then
                begin
                        str[i] := '.';
                    	inc(count);
                end;
	end;

        if (count = 0) then
        	str := str + '.00';

	result := str;
end;

//заменяет точку на decimalseparator
function Dot2Sep(str: string): string;
var
        i: word;
begin
        for i := 1 to length(str) do
                if (str[i] = '.') then
                        str[i] := DecimalSeparator;

	result := str;
end;

//удаляет пробелы в начале строки
function DelLeftSpace(str: string): string;
var
	i: word;
        str_result: string;
        flag: boolean;
begin
	str_result := '';
        flag := false;

    	for i := 1 to length(str) do
        begin
        	if (str[i] <> ' ') then
                	flag := true;

                if (flag) then
                	str_result := str_result + str[i];
        end;

	result := str_result;
end;

//преобразует дату из формата dd/mm/yyyy в dd.mm.yyyy
function CorrectDate(str: string): string;
var
	i: word;
begin
    	for i := 1 to length(str) do
        	if (str[i] = '/') then
                	str[i] := '.';

        result := str;
end;

initialization
	OptionsIniFileName := GetDefaultIniFileName;
        OptionsIni         := TIniFile.Create(OptionsIniFileName)
finalization
	OptionsIni.Free;

end.
