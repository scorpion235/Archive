//О програиме
unit fAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls;

type
  TfrmAbout = class(TForm)
    btnOk: TButton;
    pnlTop: TPanel;
    Image1: TImage;
    lblCaption: TLabel;
    lblVersion: TLabel;
    lblAutor: TLabel;
    Bevel: TBevel;
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.btnOkClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

end.
