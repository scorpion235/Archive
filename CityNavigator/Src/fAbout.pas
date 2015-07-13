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
    procedure lblHttpClick(Sender: TObject);
    procedure lblEMail1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
end;

implementation

uses
	ShellApi,
        SysUtils;

{$R *.dfm}

procedure TfrmAbout.lblHttpClick(Sender: TObject);
begin
	ShellExecute (0, 'open', 'http://www.gorod74.ru', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmAbout.lblEMail1Click(Sender: TObject);
begin
	ShellExecute (0, 'open', 'mailto:dsm@chelinvest.ru', nil, nil, SW_SHOWNORMAL);
end;

end.

