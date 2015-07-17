program Events;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitAbout in 'UnitAbout.pas' {FormAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'События';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
