//ћодуль с функци€ми
//јвтор: ƒюгуров —ергей ћихайлович
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
//выдаетс€ запрос с двум€ кнопками "ƒа" и "Ќет"
//возвращает IDYES или IDNO
function YesNoBox(msg: string; Flags: Cardinal = MB_ICONQUESTION): integer;
//показывает окно с сообщением об ошибке
//приостанавливает закрытие модальной формы frm
//при передаче control - выставл€ет на него фокус
procedure StopClose(frm: TForm; msg: String; Control: TWinControl);
//перемещает фокус на нужный контрол
function SetActiveControl(Control: TWinControl): boolean;
//задание значение в комбобокс
procedure SetComboBox(var cb: TComboBox; str: string);
//задание пути к ini-файлу
function GetDefaultIniFileName: string;
//пытаетс€ получить дату
function TryGetDate(str: String): boolean;
//пытаетс€ получить дату врем€
function TryGetDateTime(str: String): boolean;
//замен€ет decimalseparator на точку
function Sep2Dot(str: string): string;
//замен€ет точку на decimalseparator
function Dot2Sep(str: string): string;
//удал€ет пробелы в начале строки
function DelLeftSpace(str: string): string;

var
	OptionsIniFileName: string;
	OptionsIni: TCustomIniFile;

implementation

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

procedure StopClose(frm: TForm; msg: String; Control: TWinControl);
begin
	if (frm <> nil) then
		frm.ModalResult := mrNone;

	Application.MessageBox(PChar(msg), PChar(Application.Title),
		MB_OK+MB_ICONEXCLAMATION);

	if (Control <> nil) then
		SetActiveControl(Control);
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

//заполн€ет TDBComboBox параметрами из ini-файла
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

//пытаетс€ получить дату
function TryGetDate(str: String): boolean;
begin
	result := true;

	try
		StrToDate(str);
	except
		result := false;
	end;
end;

//замен€ет decimalseparator на точку
function Sep2Dot(str: string): string;
var
        i: word;
begin
        for i := 1 to length(str) do
        begin
                if (str[i] = DecimalSeparator) then
                        str[i] := '.';
	end;
        
	result := str;
end;

//замен€ет точку на decimalseparator
function Dot2Sep(str: string): string;
var
        i: word;
begin
        for i := 1 to length(str) do
        begin
                if (str[i] = '.') then
                        str[i] := DecimalSeparator;
	end;

	result := str;
end;

//пытаетс€ получить дату врем€
function TryGetDateTime(str: String): boolean;
begin
	result := true;

	try
		StrToDateTime(str);
	except
		result := false;
	end;
end;

//удал€ет пробелы в начале строки
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

initialization
	OptionsIniFileName := GetDefaultIniFileName;
        OptionsIni         := TIniFile.Create(OptionsIniFileName)
finalization
	OptionsIni.Free;

end.
