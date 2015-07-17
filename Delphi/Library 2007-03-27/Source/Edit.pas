//Редактирование
unit Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DBCtrls, StdCtrls, Mask, DB, DBTables, ExtDlgs;

type
  TfmEdit = class(TForm)
    DBNavigator: TDBNavigator;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    btImage: TButton;
    OpenPictureDialog: TOpenPictureDialog;
    DBImage: TDBImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEdit: TfmEdit;

implementation

uses
	Main,
	dmLibU;

{$R *.dfm}

//Нажатие на кнопку "Добавить фото"
procedure TfmEdit.btImageClick(Sender: TObject);
var
	memStream: TMemoryStream;
	bmp:       TBitMap;
	Bookmark:  TBookmark;
begin
	Bookmark := dmLib.taBook.GetBookmark; //установить закладку
	if OpenPictureDialog.Execute then
	try
		//созжаём графический объект
		bmp := TBitMap.Create;
		//помещаем в него фото автора
		bmp.LoadFromFile(OpenPictureDialog.FileName);
		//создаём поток
		memStream := TMemoryStream.Create;
		//помещаем в него фото
		bmp.SaveToStream(memStream);
		with dmLib.quInputImg do
		begin
			Close;
			SQL.Clear;
			//объявляем параметр slctImg SQL-команды
			SQL.Add('UPDATE Book SET Image = :slctImg WHERE Code_B = :CODE_B');
			//присваеваем значение параметру slctImg, которое
			//интерпретируем как ftGraphic
			ParamByName('slctImg').LoadFromStream(memStream, ftGraphic);
			ExecSQL;
		end; //with
		bmp.Free;
		memStream.Free;
		//отображаем новое состояние таблицы Book
		//можно использовать dmLib.taBook.Refresh
		dmLib.taBook.Close;
		dmLib.taBook.Open;
	except
		ShowMessage('Ошибка!');
	end;
	//переходим на запись, которую указывает закладка
	dmLib.taBook.GotoBookmark(Bookmark);
	//освобождаем память, выделенную под закладку
	dmLib.taBook.FreeBookmark(Bookmark);
end;

//Закрытие формы
procedure TfmEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	fmMain.mnEdit.Checked := false;
	Action := caFree;
end;

end.
