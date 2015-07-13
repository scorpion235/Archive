program BackUp;

uses
  Forms,
  fMain in 'Source\fMain.pas' {frmMain},
  fAbout in 'Source\fAbout.pas' {frmAbout},
  fOptions in 'Source\fOptions.pas' {frmOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BackUp системы';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
