program TypingSpeed;

uses
  Forms,
  fMain in 'Src\fMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�������� ������';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
