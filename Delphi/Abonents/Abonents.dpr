//Abonents
//Авторские права © 2010-2012 ОАО "Челябинвестбанк"

program Abonents;

uses
  Forms,
  fMain in 'Src\fMain.pas' {frmMain},
  fAbout in 'Src\fAbout.pas' {frmAbout},
  uChild in 'Src\uChild.pas',
  uCommon in 'Src\uCommon.pas',
  dmAbonents in 'Src\dmAbonents.pas' {DataMod: TDataModule},
  fOptions in 'Src\fOptions.pas' {frmOptions},
  fService in 'Src\fService.pas' {frmService},
  fServiceEd in 'Src\fServiceEd.pas' {frmServiceEd},
  fSubSrvEd in 'Src\fSubSrvEd.pas' {frmSubSrvEd},
  fCity in 'Src\fCity.pas' {frmCity},
  fCityEd in 'Src\fCityEd.pas' {frmCityEd},
  fAgent in 'Src\fAgent.pas' {frmAgent},
  fStreet in 'Src\fStreet.pas' {frmStreet},
  fStreetEd in 'Src\fStreetEd.pas' {frmStreetEd},
  fAbonent in 'Src\fAbonent.pas' {frmAbonent},
  fAbonentEd in 'Src\fAbonentEd.pas' {frmAbonentEd},
  fAllSubSrvWarning in 'Src\fAllSubSrvWarning.pas' {frmAllSubSrvWarning},
  fSaldoEd in 'Src\fSaldoEd.pas' {frmSaldoEd},
  fExportReestr in 'Src\fExportReestr.pas' {frmExportReestr},
  fImportReestr in 'Src\fImportReestr.pas' {frmImportReestr},
  fPay in 'Src\fPay.pas' {frmPay},
  fAbonentPrint in 'Src\fAbonentPrint.pas' {frmAbonentPrint},
  fPayPrint in 'Src\fPayPrint.pas' {frmPayPrint},
  EasyGraph in 'Src\EasyGraph.pas',
  fProgress in 'Src\fProgress.pas' {frmProgress};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Система ГОРОД - Abonents';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDataMod, DataMod);
  Application.Run;
end.
