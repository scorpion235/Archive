program Lib;

uses
  ExceptionLog,
  Forms,
  Main in 'Source\Main.pas' {fmMain},
  Find in 'Source\Find.pas' {fmFind},
  dmLibU in 'Source\dmLibU.pas' {dmLib: TDataModule},
  Request in 'Source\Request.pas' {rpRequest},
  Edit in 'Source\Edit.pas' {fmEdit},
  About in 'Source\About.pas' {fmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Библиотека';
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TdmLib, dmLib);
  Application.Run;
end.
