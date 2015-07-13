//������ � ���������
//�����: ������� ������ ����������
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

//���������� ��������� �� ������
procedure ErrorBox(msg: string);
//���������� ��������������
procedure WarningBox(msg: string);
//���������� ��������� � �����������
procedure MsgBox(msg: string);
//�������� ������ � ����� �������� "��" � "���"
//���������� IDYES ��� IDNO
function YesNoBox(msg: string; Flags: Cardinal = MB_ICONQUESTION): integer;
//���������� ���� � ���������� �� ������
//���������������� �������� ��������� ����� frm
//��� �������� control - ���������� �� ���� �����
procedure StopClose(frm: TForm; msg: string; Control: TWinControl);
//���������� ����� �� ������ �������
function SetActiveControl(Control: TWinControl): boolean;
//������� �������� � ���������
procedure SetComboBox(var cb: TComboBox; str: string);
//������� ���� � ini-�����
function GetDefaultIniFileName: string;
//�������� �� ������ �������� ����
function TryGetDate(str: string): boolean;
//�������� �� ������ �������� ���� �����
function TryGetDateTime(str: string): boolean;
//�������� �� ������ �������� ����� �����
function TryGetInt(str: string): boolean;
//�������� �� ������ �������� ����� � ��������� ������
function TryGetDouble(str: string): boolean;
//�������� �� ����������� � ������ ����������� ��������
function CheckCorrectString(str: string; var ch: string; var pos: word): boolean;
//�������� �� ������, ����������� �� �����, �������� ����� �����
function FileStrToInt(str: String): integer;
//�������� �� ������, ����������� �� �����, �������� ����� � ��������� ������
function FileStrToDouble(str: String): double;
//�������� decimalseparator �� �����
function Sep2Dot(str: string): string;
//�������� ����� �� decimalseparator
function Dot2Sep(str: string): string;
//������� ������� � ������ ������
function DelLeftSpace(str: string): string;
//����������� ���� �� ������� dd/mm/yyyy � dd.mm.yyyy
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
        	//TODO: ������-�� ������� SetActiveControl �� ������������
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

//��������� TDBComboBox ����������� �� ini-�����
//������ ���������� ����� ";"
//��������: 1,25;1,26;1,29
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

//������� ���� � ini-�����
function GetDefaultIniFileName: string;
var
	path: string;
begin
	path   := ExpandFileName (ParamStr(0));
	result := ChangeFileExt(path, '.ini');
end;

//�������� �� ������ �������� ����
function TryGetDate(str: String): boolean;
begin
	result := true;

	try
		StrToDate(str);
	except on EConvertError do
		result := false;
	end;
end;

//�������� �� ������ �������� ���� �����
function TryGetDateTime(str: String): boolean;
begin
	result := true;

	try
		StrToDateTime(str);
	except on EConvertError do
		result := false;
	end;
end;

//�������� �� ������ �������� ����� �����
function TryGetInt(str: String): boolean;
begin
   	result := true;

	try
		StrToInt(str);
	except on EConvertError do
		result := false;
	end;
end;

//�������� �� ������ �������� ����� � ��������� ������
function TryGetDouble(str: String): boolean;
begin
    	result := true;

	try
		StrToFloat(str);
	except on EConvertError do
		result := false;
	end;
end;

//�������� �� ����������� � ������ ����������� ��������
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

//�������� �� ������, ����������� �� �����, �������� ����� �����
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

//�������� �� ������, ����������� �� �����, �������� ����� � ��������� ������
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

                //�� ������ ���� ����������� ����� � ������� ����� �� �����
                else if (str[i] = '.') then
                        str_double := str_double + DecimalSeparator;
        end;

        try
		result := StrToFloat(str_double);
	except on EConvertError do
		result := 0;
	end;
end;

//�������� decimalseparator �� �����
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

//�������� ����� �� decimalseparator
function Dot2Sep(str: string): string;
var
        i: word;
begin
        for i := 1 to length(str) do
                if (str[i] = '.') then
                        str[i] := DecimalSeparator;

	result := str;
end;

//������� ������� � ������ ������
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

//����������� ���� �� ������� dd/mm/yyyy � dd.mm.yyyy
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
