program TypingSpeed;

uses
  Forms,
  fMain in 'Src\fMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Скорость набора';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
