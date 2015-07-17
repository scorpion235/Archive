//��������������
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

//������� �� ������ "�������� ����"
procedure TfmEdit.btImageClick(Sender: TObject);
var
	memStream: TMemoryStream;
	bmp:       TBitMap;
	Bookmark:  TBookmark;
begin
	Bookmark := dmLib.taBook.GetBookmark; //���������� ��������
	if OpenPictureDialog.Execute then
	try
		//������ ����������� ������
		bmp := TBitMap.Create;
		//�������� � ���� ���� ������
		bmp.LoadFromFile(OpenPictureDialog.FileName);
		//������ �����
		memStream := TMemoryStream.Create;
		//�������� � ���� ����
		bmp.SaveToStream(memStream);
		with dmLib.quInputImg do
		begin
			Close;
			SQL.Clear;
			//��������� �������� slctImg SQL-�������
			SQL.Add('UPDATE Book SET Image = :slctImg WHERE Code_B = :CODE_B');
			//����������� �������� ��������� slctImg, �������
			//�������������� ��� ftGraphic
			ParamByName('slctImg').LoadFromStream(memStream, ftGraphic);
			ExecSQL;
		end; //with
		bmp.Free;
		memStream.Free;
		//���������� ����� ��������� ������� Book
		//����� ������������ dmLib.taBook.Refresh
		dmLib.taBook.Close;
		dmLib.taBook.Open;
	except
		ShowMessage('������!');
	end;
	//��������� �� ������, ������� ��������� ��������
	dmLib.taBook.GotoBookmark(Bookmark);
	//����������� ������, ���������� ��� ��������
	dmLib.taBook.FreeBookmark(Bookmark);
end;

//�������� �����
procedure TfmEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	fmMain.mnEdit.Checked := false;
	Action := caFree;
end;

end.
