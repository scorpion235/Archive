program ShowPictures;

uses
  Forms,
  fMain in 'fMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Просмотр иллюстраций';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
