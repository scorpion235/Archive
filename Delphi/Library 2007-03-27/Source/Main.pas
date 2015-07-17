//���� ������ "����������"
//����� ����������: Borland Delphi 6.0
//����: 27.03.2007

//�������� �����
unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ImgList, ActnList, ComCtrls, ToolWin;

type
  TfmMain = class(TForm)
    MainMenu: TMainMenu;
    ImageList: TImageList;
    mnBook: TMenuItem;
    mnFind: TMenuItem;
    mnEdit: TMenuItem;
    mnAbout: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActionList: TActionList;
    acFind: TAction;
    acEdit: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mnAboutClick(Sender: TObject);
    procedure acEditExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

implementation

uses
	Find,
	Edit,
	About;

{$R *.dfm}

//�����
procedure TfmMain.acFindExecute(Sender: TObject);
var
	frm: TfmFind;
begin
	//����� ��� �������
	if (mnFind.Checked = true) then
		exit;
	mnFind.Checked := true;
	frm := TfmFind.Create(self);
	frm.Show;
end;

//��������������
procedure TfmMain.acEditExecute(Sender: TObject);
var
	frm: TfmEdit;
begin
	//����� ��� �������
	if (mnEdit.Checked = true) then
		exit;
	mnEdit.Checked := true;
	frm := TfmEdit.Create(self);
	frm.Show;
end;

//� ���������
procedure TfmMain.mnAboutClick(Sender: TObject);
var
	frm: TfmAbout;
begin
	frm := TfmAbout.Create(self);
	frm.ShowModal;
end;

//�������� �����
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

end.
