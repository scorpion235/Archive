//Информационное сообщение

//Во избежании ошибок настоятельно
//рекомендуем не вносить данные по
//по каждой подуслуге в отдельности!
unit fAllSubSrvWarning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmAllSubSrvWarning = class(TForm)
    btnOk: TButton;
    lblWarning: TLabel;
    Image: TImage;
    cbVisibleAllSubSrvWarning: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAllSubSrvWarning: TfrmAllSubSrvWarning;

implementation

uses
	uCommon;

{$R *.dfm}

procedure TfrmAllSubSrvWarning.FormCreate(Sender: TObject);
var
	sect: string;
begin
	sect := 'AllSubSrvWarning';
	Caption := PChar(Application.Title);
        //cbVisibleAllSubSrvWarning.Checked := OptionsIni.ReadBool(sect, 'AllVisibleSubSrvWarning', false);
end;

procedure TfrmAllSubSrvWarning.btnOkClick(Sender: TObject);
var
	sect: string;
begin
	sect := 'AllSubSrvWarning';
	OptionsIni.WriteBool(sect, 'AllVisibleSubSrvWarning', cbVisibleAllSubSrvWarning.Checked);
end;

procedure TfrmAllSubSrvWarning.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	Action := caFree;
end;

end.
