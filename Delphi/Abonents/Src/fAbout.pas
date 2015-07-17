//О программе
unit fAbout;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, TeEngine, Series, TeeProcs, Chart, jpeg;

type

TfrmAbout = class(TForm)
    lblEMail: TLabel;
    lblPhone: TLabel;
    lblCopyright: TLabel;
    lblVersion: TLabel;
    lblEMail1: TLabel;
    lblHttp: TLabel;
    lblPhone1: TLabel;
    Bevel: TBevel;
    btnOk: TButton;
    pnlTop: TPanel;
    lblProductName: TLabel;
    lblProductComment: TLabel;
    Logo: TImage;
    lblManualCreate: TLabel;
    procedure lblHttpClick(Sender: TObject);
    procedure lblEMail1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
end;

implementation

uses
	dmAbonents,
	ShellApi,
        uCommon;

{$R *.dfm}

procedure TfrmAbout.FormShow(Sender: TObject);
var
	version, manual_create: string[20];
begin
        version       := '';
        manual_create := '';
	DataMod.IB_Cursor.SQL.Text := 'SELECT VERSION, MANUAL_CREATE FROM INFO';

        //MsgBox(DataMod.IB_Cursor.SQL.Text);
        //запуск запроса
        try
	        DataMod.IB_Cursor.Open;
        except
        	WarningBox('Ошибка при заполнении версии программы' + #13 +
                'и даты создания справочников.');
                exit;
	end;

        if (DataMod.IB_Cursor.RecordCount > 1) then
        	exit;

        lblVersion.Caption      := 'Версия: '      + DataMod.IB_Cursor.FieldByName('VERSION').AsString;
        lblManualCreate.Caption := 'Справочники: ' + DataMod.IB_Cursor.FieldByName('MANUAL_CREATE').AsString;
        DataMod.IB_Cursor.Close;
end;

procedure TfrmAbout.lblHttpClick(Sender: TObject);
begin
	ShellExecute (0, 'open', 'http://www.gorod74.ru', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.lblEMail1Click(Sender: TObject);
begin
	ShellExecute (0, 'open', 'mailto:pay_supp@chelinvest.ru', nil, nil, SW_SHOWNORMAL);
end;

end.

