//Настройки
unit fOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, DBCtrlsEh, ToolEdit, FileCtrl,
  LMDCustomFileEdit, LMDFileOpenEdit, LMDColorEdit, LMDCustomControl,
  LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit,
  LMDCustomBrowseEdit, LMDBrowseEdit, LMDEdit, LMDCustomButton, LMDButton,
  LMDCustomListBox, LMDExtListBox, LMDCustomComponent, LMDBrowseDlg,
  LMDCustomScrollBox, LMDScrollBox, LMDCustomImageListBox,
  LMDCustomCheckListBox, LMDCheckListBox, LMDListBox, Placemnt,
  PropFilerEh, PropStorageEh, ActnList, Menus, ImgList;

type
  TfrmOptions = class(TForm)
    PageControl: TPageControl;
    btnOK: TButton;
    btnCancel: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lblName: TLabel;
    lblPath: TLabel;
    edZipPath: TLMDBrowseEdit;
    edName: TLMDEdit;
    btnAddFile1: TButton;
    OpenDialog: TOpenDialog;
    BrowseDlg: TLMDBrowseDlg;
    btnAddDirectory: TButton;
    btnDeleteFile1: TButton;
    FilesList: TLMDExtListBox;
    lblFilePath1: TLabel;
    Storage: TFormStorage;
    lblFilesList1: TLabel;
    ExcludeList: TLMDExtListBox;
    lblExcludeList: TLabel;
    btnDeleteFile2: TButton;
    btnAddFile2: TButton;
    lblFilePath2: TLabel;
    ActionList: TActionList;
    AcAddFile1: TAction;
    AcAddFile2: TAction;
    AcAddDirectory: TAction;
    AcDeleteFile1: TAction;
    AcDeleteFile2: TAction;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    pmAddFile1: TMenuItem;
    pmAddDir1: TMenuItem;
    pmDeleteFile1: TMenuItem;
    pmAddFile2: TMenuItem;
    pmDeleteFile2: TMenuItem;
    ImageList: TImageList;
    edUnZipPath: TLMDFileOpenEdit;
    lblPath2: TLabel;
    edUnZipDestDir: TLMDBrowseEdit;
    lblUnZipDestDir: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FilesListSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ExcludeListSelect(Sender: TObject);
    procedure AcAddFile1Execute(Sender: TObject);
    procedure AcAddFile2Execute(Sender: TObject);
    procedure AcAddDirectoryExecute(Sender: TObject);
    procedure AcDeleteFile1Execute(Sender: TObject);
    procedure AcDeleteFile2Execute(Sender: TObject);
    procedure edUnZipPathClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

procedure TfrmOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

procedure TfrmOptions.FilesListSelect(Sender: TObject);
const max_length = 77;
var
	i: integer;
	path, format_path: string;
begin
	if (FilesList.ItemIndex = -1) then
		exit;
	btnDeleteFile1.Enabled := true;
	pmDeleteFile1.Enabled  := true;
	lblFilePath1.Visible   := true;
	path := FilesList.Items.Strings[FilesList.ItemIndex];
	for i:=0 to trunc(length(path)/max_length) do
	begin
		format_path := format_path + copy(path, 1, max_length)+ #10#13;
		delete(path, 1, max_length);
	end;
	lblFilePath1.Caption := format_path;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
var
	i: integer;
	files, format_files: string;
begin
	Storage.StoredValues.RestoreValues;
	edName.Text    := 'BackUp - ' + DateToStr(now);
	edZipPath.Text := Storage.StoredValues.Values['ZipPath'].Value;

	//TODO: При использовании FilesList.Items.Text
	//отображается только первая запись в списке
	FilesList.Clear;
	files        := Storage.StoredValues.Values['FilesList'].Value;
	format_files := '';
	for i := 1 to length(files) do
	begin
		if (files[i] <> '|') then
			format_files := format_files + files[i]
		else
		begin
			FilesList.Items.Add(format_files);
			format_files := '';
		end;
	end;

	ExcludeList.Clear;
	files        := Storage.StoredValues.Values['ExcludeList'].Value;
	format_files := '';
	for i := 1 to length(files) do
	begin
		if (files[i] <> '|') then
			format_files := format_files + files[i]
		else
		begin
			ExcludeList.Items.Add(format_files);
			format_files := '';
		end;
	end;

	edUnZipPath.Text    := Storage.StoredValues.Values['UnZipPath'].Value;
	edUnZipDestDir.Text := Storage.StoredValues.Values['UnZipDestDir'].Value;

	lblFilePath1.Caption   := '';
	lblFilePath2.Caption   := '';
	lblFilePath1.Visible   := false;
	lblFilePath2.Visible   := false;
	btnDeleteFile1.Enabled := false;
	btnDeleteFile2.Enabled := false;
	pmDeleteFile1.Enabled  := false;
	pmDeleteFile2.Enabled  := false;
	PageControl.ActivePage := TabSheet1;
end;

procedure TfrmOptions.btnCancelClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmOptions.btnOKClick(Sender: TObject);
var
	i: integer;
	files: string;
begin
	Storage.StoredValues.Values['Name'].Value      := edName.Text;
	Storage.StoredValues.Values['ZipPath'].Value      := edZipPath.Text;

	files := '';
	for i := 0 to FilesList.Items.Count-1 do
		files := files + FilesList.Items.Strings[i] + '|';
	Storage.StoredValues.Values['FilesList'].Value := files;

	files := '';
	for i := 0 to ExcludeList.Items.Count-1 do
		files := files + ExcludeList.Items.Strings[i] + '|';
	Storage.StoredValues.Values['ExcludeList'].Value := files;

	Storage.StoredValues.Values['UnZipPath'].Value:=edUnZipPath.Text;
	Storage.StoredValues.Values['UnZipDestDir'].Value:=edUnZipDestDir.Text;

	Storage.StoredValues.SaveValues;
	Close;
end;

procedure TfrmOptions.ExcludeListSelect(Sender: TObject);
const max_length = 77;
var
	i: integer;
	path, format_path: string;
begin
	if (ExcludeList.ItemIndex = -1) then
		exit;
	btnDeleteFile2.Enabled := true;
	pmDeleteFile2.Enabled  := true;
	lblFilePath2.Visible   := true;
	path := ExcludeList.Items.Strings[ExcludeList.ItemIndex];
	for i:=0 to trunc(length(path)/max_length) do
	begin
		format_path := format_path + copy(path, 1, max_length)+ #10#13;
		delete(path, 1, max_length);
	end;
	lblFilePath2.Caption := format_path;
end;

procedure TfrmOptions.AcAddFile1Execute(Sender: TObject);
begin
  	OpenDialog.Execute;
	if (OpenDialog.FileName <> '') then
	begin
		FilesList.Items.Add(OpenDialog.FileName);
		btnDeleteFile1.Enabled := true;
		pmDeleteFile1.Enabled  := true;
		lblFilePath1.Visible   := true;
	end;
end;

procedure TfrmOptions.AcAddFile2Execute(Sender: TObject);
begin
     	OpenDialog.Execute;
	if (OpenDialog.FileName <> '') then
	begin
		ExcludeList.Items.Add(OpenDialog.FileName);
		btnDeleteFile2.Enabled := true;
		pmDeleteFile2.Enabled  := false;
		lblFilePath2.Visible   := true;
	end;
end;

procedure TfrmOptions.AcAddDirectoryExecute(Sender: TObject);
begin
	BrowseDlg.Execute;
	if (BrowseDlg.SelectedFolder <> '') then
	begin
		FilesList.Items.Add(BrowseDlg.SelectedFolder + '\*.*');
		btnDeleteFile1.Enabled := true;
		pmDeleteFile1.Enabled  := true;
		lblFilePath1.Visible   := true;
	end;
end;

procedure TfrmOptions.AcDeleteFile1Execute(Sender: TObject);
begin
	FilesList.DeleteSelected;
	if (FilesList.Items.Count = 0) then
	begin
		btnDeleteFile1.Enabled := false;
		pmDeleteFile1.Enabled  := false;
		lblFilePath1.Visible   := false;
	end;
end;

procedure TfrmOptions.AcDeleteFile2Execute(Sender: TObject);
begin
	ExcludeList.DeleteSelected;
	if (ExcludeList.Items.Count = 0) then
	begin
		btnDeleteFile2.Enabled := false;
		pmDeleteFile2.Enabled  := false;
		lblFilePath2.Visible   := false;
	end;
end;

procedure TfrmOptions.edUnZipPathClick(Sender: TObject);
begin
	edUnZipPath.Show;
end;

end.
