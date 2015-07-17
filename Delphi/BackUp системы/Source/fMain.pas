//Основной модуль
//BuckUp системы

//Среда разработки: Delphi 6.0
//Дата: 2007-05-10
//Дополнительные библиотеки:
//	VCLZip, ElTree, RxLib, ToolBar97, LMD

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, kpSFXCfg, VCLZip, VCLUnZip, StdCtrls, ElTree, ImgList, Menus,
  TB97Ctls, TB97, TB97Tlbr, ActnList, ComCtrls, Placemnt, TB97Tlwn,
  ExtCtrls, RXClock;

type
  TfrmMain = class(TForm)
    Zip: TVCLZip;
    ImageList: TImageList;
    Dock1: TDock97;
    Dock2: TDock97;
    MainToolbar: TToolbar97;
    btnOptions: TToolbarButton97;
    MainMenu: TMainMenu;
    mnmFile: TMenuItem;
    mnmBackUp: TMenuItem;
    mnmUnBackUp: TMenuItem;
    mnmOptions: TMenuItem;
    N2: TMenuItem;
    mnmExit: TMenuItem;
    N1: TMenuItem;
    mnmInformation: TMenuItem;
    mnmAbout: TMenuItem;
    btnBackUp: TToolbarButton97;
    btnUnBackUp: TToolbarButton97;
    ActionList: TActionList;
    AcBackUp: TAction;
    AcUnBackUp: TAction;
    AcOptions: TAction;
    AcExit: TAction;
    ToolbarSep971: TToolbarSep97;
    acAbout: TAction;
    fProgress: TToolWindow97;
    FileProgressBar: TProgressBar;
    TotalProgressBar: TProgressBar;
    Storage: TFormStorage;
    btnCancel: TButton;
    lblWait: TLabel;
    UnZip: TVCLUnZip;
    lblRemainding: TLabel;
    procedure AcBackUpExecute(Sender: TObject);
    procedure AcUnBackUpExecute(Sender: TObject);
    procedure AcOptionsExecute(Sender: TObject);
    procedure AcExitExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ZipFilePercentDone(Sender: TObject; Percent: Integer);
    procedure ZipTotalPercentDone(Sender: TObject; Percent: Integer);
    procedure btnCancelClick(Sender: TObject);
    procedure UnZipFilePercentDone(Sender: TObject; Percent: Integer);
    procedure UnZipTotalPercentDone(Sender: TObject; Percent: Integer);
  private
    fStartZipping,
    fStartUnZipping: TDateTime;
    fFlag: boolean;
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
	kpZipObj,
	fOptions,
	fAbout;

{$R *.dfm}

procedure TfrmMain.AcBackUpExecute(Sender: TObject);
var
	files, format_files,
	name, path: string;
	i: integer;
begin
	Storage.StoredValues.RestoreValues;

	name := Storage.StoredValues.Values['Name'].Value;
	if (name = '') then
	begin
		Application.MessageBox('Не указано имя архива.', 'Предупреждение', MB_OK);
		exit;
	end;

	path := Storage.StoredValues.Values['ZipPath'].Value;
	if (path = '') then
	begin
		Application.MessageBox('Не указано расположение архива.', 'Предупреждение', MB_OK);
		exit;
	end;
	Zip.ZipName := path + name + '.zip';

	//TODO: При использовании FilesList.Items.Text
	//отображается только первая запись в списке
	files := Storage.StoredValues.Values['FilesList'].Value;
	if (files = '') then
	begin
		Application.MessageBox('Не выбрано ниодного файла для архивирования.', 'Предупреждение', MB_OK);
		exit;
	end;

	//формирование FilesList
	format_files := '';
	for i := 1 to length(files) do
	begin
		if (files[i] <> '|') then
			format_files := format_files + files[i]
		else
		begin
			Zip.FilesList.Add(format_files);
			format_files := '';
		end;
	end;

	//формирование ExcludeList
	files        := Storage.StoredValues.Values['ExcludeList'].Value;
	format_files := '';
	for i := 1 to length(files) do
	begin
		if (files[i] <> '|') then
			format_files := format_files + files[i]
		else
		begin
			Zip.ExcludeList.Add(format_files);
			format_files := '';
		end;
	end;

	fFlag := true;
	//архивирование
	With Zip do
	begin
		Recurse    := True;
		StorePaths := True;
		PackLevel  := 10;
		fProgress.Top  := Top + (Height - fProgress.Height) div 2;
		fProgress.Left := Left + (Width - fProgress.Width) div 2;
		fProgress.Caption := 'Создание архива';
		frmMain.Enabled   := false;
		Screen.Cursor     := crHourGlass;
		fProgress.Visible := true;
		fStartZipping := now;
		Zip;
		fProgress.Visible := false;
		Screen.Cursor     := crDefault;
		frmMain.Enabled   := true;
	end;
	Application.MessageBox('Архивирование завершено.', 'Сообщение', MB_OK);
end;

procedure TfrmMain.AcUnBackUpExecute(Sender: TObject);
begin
	Storage.StoredValues.RestoreValues;

	UnZip.ZipName := Storage.StoredValues.Values['UnZipPath'].Value;
	if (UnZip.ZipName = '') then
	begin
		Application.MessageBox('Не указано расположение архива.', 'Предупреждение', MB_OK);
		exit;
	end;

	UnZip.DestDir := Storage.StoredValues.Values['UnZipDestDir'].Value;
        if (UnZip.DestDir = '') then
	begin
		Application.MessageBox('Не указана директория извлечения архива.', 'Предупреждение', MB_OK);
		exit;
	end;

	fFlag := true;
	//разархивирование
	with UnZip do
	begin
		DoAll := true;
		RecreateDirs := False;
		RetainAttributes := True;
		fProgress.Top  := Top + (Height - fProgress.Height) div 2;
		fProgress.Left := Left + (Width - fProgress.Width) div 2;
		fProgress.Caption := 'Извлечение файлов из архива';
		frmMain.Enabled   := false;
		Screen.Cursor     := crHourGlass;
		fProgress.Visible := true;
		fStartUnZipping := now;
		Unzip;                        
		fProgress.Visible := false;
		Screen.Cursor     := crDefault;
		frmMain.Enabled   := true;
	end;
end;

procedure TfrmMain.AcOptionsExecute(Sender: TObject);
var
	frm: TfrmOptions;
begin
	frm := TfrmOptions.Create(self);
	frm.ShowModal;
end;

procedure TfrmMain.AcExitExecute(Sender: TObject);
begin
	Close;
end;

procedure TfrmMain.acAboutExecute(Sender: TObject);
var
	frm: TfrmAbout;
begin
	frm := TfrmAbout.Create(self);
	frm.ShowModal;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	fProgress.Visible := false;
end;

procedure TfrmMain.ZipFilePercentDone(Sender: TObject; Percent: Integer);
begin
	FileProgressBar.Position := Percent;
end;

procedure TfrmMain.ZipTotalPercentDone(Sender: TObject; Percent: Integer);
begin
	Application.ProcessMessages;
	if (fFlag = false) then
	begin
		if (Application.MessageBox('Архивирование не завершено.'#10#13'Завершить работу программы?', 'Подтверждение', MB_OKCANCEL) = IDOK) then
			halt(0)
		else
			fFlag := true;
	end;
	if (Percent > 0) then
		lblRemainding.Caption := 'Длительность: ' + TimeToStr(now - fStartZipping) + #10#13 + 'Завершение:    ' + TimeToStr(now - fStartZipping -(100 * (now - fStartZipping) / percent));
	TotalProgressBar.Position := Percent;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
	fFlag := false;
end;

procedure TfrmMain.UnZipFilePercentDone(Sender: TObject; Percent: Integer);
begin
	FileProgressBar.Position := Percent;
end;

procedure TfrmMain.UnZipTotalPercentDone(Sender: TObject;
  Percent: Integer);
begin
	Application.ProcessMessages;
	if (fFlag = false) then
	begin
		if (Application.MessageBox('Разархивирование не завершено.'#10#13'Завершить работу программы?', 'Подтверждение', MB_OKCANCEL) = IDOK) then
			halt(0)
		else
			fFlag := true;
	end;
	if (Percent > 0) then
		lblRemainding.Caption := 'Длительность: ' + TimeToStr(now - fStartUnZipping) + #10#13 + 'Завершение:    ' + TimeToStr(now - fStartUnZipping -(100 * (now - fStartUnZipping) / percent));
	TotalProgressBar.Position := Percent;
end;

end.
