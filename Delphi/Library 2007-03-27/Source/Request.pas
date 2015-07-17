//Заявка
unit Request;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, QuickRpt, QRCtrls;

type
  TrpRequest = class(TForm)
    QuickRep: TQuickRep;
    QRBand1: TQRBand;
    QRBand2: TQRBand;
    lblRequest: TQRLabel;
    lblAuthor: TQRLabel;
    lblTitle: TQRLabel;
    lblRepost: TQRLabel;
    lblStel: TQRLabel;
    lblShelf: TQRLabel;
    Author: TQRDBText;
    Title: TQRDBText;
    Repost: TQRDBText;
    Stel: TQRDBText;
    Shelf: TQRDBText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  rpRequest: TrpRequest;

implementation

uses
	dmLibU;

{$R *.dfm}

//закрытие
procedure TrpRequest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
end;

end.
