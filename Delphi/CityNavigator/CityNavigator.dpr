//City Navigator
//Авторские права © 2009 ОАО "Челябинвестбанк"

program CityNavigator;

uses
  Forms,
  fMain in 'Src\fMain.pas' {frmMain},
  uCommon in 'Src\uCommon.pas',
  fAbout in 'Src\fAbout.pas' {frmAbout},
  dmCityNavigator in 'Src\dmCityNavigator.pas' {DataMod: TDataModule},
  fManualCity in 'Src\fManualCity.pas' {frmManualCity},
  uChild in 'Src\uChild.pas',
  fManualStreet in 'Src\fManualStreet.pas' {frmManualStreet},
  fProgress in 'Src\fProgress.pas' {frmProgress},
  fManualOrg in 'Src\fManualOrg.pas' {frmManualOrg},
  fManualService in 'Src\fManualService.pas' {frmManualService},
  fManualUser in 'Src\fManualUser.pas' {frmManualUser},
  fUnCorrectStreet in 'Src\fUnCorrectStreet.pas' {frmUnCorrectStreet},
  fDayEnd in 'Src\fDayEnd.pas' {frmDayEnd},
  fMailerTbl in 'Src\fMailerTbl.pas' {frmMailerTbl},
  fActiveCard in 'Src\fActiveCard.pas' {frmActiveCard},
  fTelephone in 'Src\fTelephone.pas' {frmTelephone},
  fLim in 'Src\fLim.pas' {frmLim},
  fCASHS04 in 'Src\fCASHS04.pas' {frmCASHS04},
  fReeSend in 'Src\fReeSend.pas' {frmReeSend},
  fManualAbonent in 'Src\fManualAbonent.pas' {frmManualAbonent},
  fReeArc in 'Src\fReeArc.pas' {frmReeArc},
  fOptions in 'Src\fOptions.pas' {frmOptions},
  fDataBaseEditor in 'Src\fDataBaseEditor.pas' {frmDataBaseEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Система ГОРОД - City Navigator';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDataMod, DataMod);
  Application.Run;
end.
