//Поиск книг
unit Find;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, DB, DBTables;

type
  TfmFind = class(TForm)
    Panel1: TPanel;
    dbgFind: TDBGrid;
    laAutor: TLabel;
    laTitl: TLabel;
    edAuthor: TEdit;
    edTitl: TEdit;
    btFind: TButton;
    btPrint: TButton;
    procedure btFindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btPrintClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //Печать
    procedure PrintRequest(Preview: boolean);
  end;

var
  fmFind: TfmFind;

implementation

uses
	Main,
	dmLibU,
	Request;

{$R *.dfm}

//Нажатие кнопки "Поиск"
procedure TfmFind.btFindClick(Sender: TObject);
begin
	//dmLib.quFind.Active := true;
	dmLib.quFind.Close;
	dmLib.quFind.ParamByName('xAut').AsString  := edAuthor.Text;
	dmLib.quFind.ParamByName('xTitl').AsString := edTitl.Text;
	dmLib.quFind.Open;

	//можно использовать (dmLib.quFind.IsEmpty = true)
	if (dmLib.quFind.Bof = true) and (dmLib.quFind.Eof = true) then
	begin
		ShowMessage('Искомой книги нет');
		exit;
	end;

	if (dmLib.quFind.FieldByName('Avail').AsInteger > 0) then
		btPrint.Visible := true
	else
		btPrint.Visible := false;
end;

//Нажатие кнопки "Печать"
procedure TfmFind.btPrintClick(Sender: TObject);
begin
	PrintRequest(true);
end;

//Печать
procedure TfmFind.PrintRequest(Preview: boolean);
begin
	if Preview then
		rpRequest.QuickRep.Preview
	else
		rpRequest.QuickRep.Print;

	//книга выдана, уменьшить её наличие в хранилище
	dmLib.quUpDat.Prepare;
	dmLib.quUpDat.ExecSQL;

	//отобразить в окне поиска новое количество книг
	//можно использовать dmLib.quFind.Refresh
	dmLib.quFind.Close;
	dmLib.quFind.Open
end;

//Закрытие формы
procedure TfmFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	fmMain.mnFind.Checked := false;
	Action := caFree;
end;

end.
