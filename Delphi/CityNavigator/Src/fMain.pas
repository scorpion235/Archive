//City Navigator - основная форма
//Авторские права © 2009-2010 ОАО "Челябинвестбанк"

//Автор: Дюгуров Сергей Михайлович
//E-mail: scorpion235@mail.ru
//Среда разработки: Delphi 6.0 Service Pack 2
//Начало разработки:    2009-01-22
//Окончание разработки: 2010-07-06
//Дополнительные библиотеки: RxLib, EhLib, xlReport, ElTree, DOA, Toolbar97

//Написание хороших программ требует
//ума, вкуса и терпения
//                        Страуструп

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, TB97Ctls, TB97, TB97Tlbr, ComCtrls, StdActns, ActnList,
  ImgList, TB97Tlwn, uChild, CoolTrayIcon, Oracle, ElTree, StdCtrls, ExtCtrls;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    mnmManual: TMenuItem;
    mnmSearch: TMenuItem;
    mnmHelp: TMenuItem;
    mnmWindow: TMenuItem;
    DockTop: TDock97;
    DockLeft: TDock97;
    MailToolbar: TToolbar97;
    btnManualStreet: TToolbarButton97;
    btnManualCity: TToolbarButton97;
    StatusBar: TStatusBar;
    ImageList: TImageList;
    StandartActions: TActionList;
    AcWindowClose: TWindowClose;
    AcWindowCascade: TWindowCascade;
    AcWindowTileHorizontal: TWindowTileHorizontal;
    AcWindowTileVertical: TWindowTileVertical;
    AcWindowMinimizeAll: TWindowMinimizeAll;
    AcWindowArrange: TWindowArrange;
    mnmCascade: TMenuItem;
    mnmHorizontal: TMenuItem;
    mnmVertical: TMenuItem;
    mnmMinimizeAll: TMenuItem;
    mnmArrange: TMenuItem;
    mnmClose: TMenuItem;
    mnmWork: TMenuItem;
    mnmOptions: TMenuItem;
    mnmSplitter1: TMenuItem;
    mnmExit: TMenuItem;
    AcOptions: TAction;
    AcExit: TAction;
    AcAbout: TAction;
    mnmAbout: TMenuItem;
    AcManualCity: TAction;
    AcManualStreet: TAction;
    mnmManualCity: TMenuItem;
    mnmManualStreet: TMenuItem;
    ChildActions: TActionList;
    AcAdd: TAction;
    AcEdit: TAction;
    AcDelete: TAction;
    AcRefresh: TAction;
    ToolbarSep1: TToolbarSep97;
    btnRefresh: TToolbarButton97;
    bthAdd: TToolbarButton97;
    bthEdit: TToolbarButton97;
    ToolbarSep3: TToolbarSep97;
    btnDelete: TToolbarButton97;
    mnmReport: TMenuItem;
    mnmExcel: TMenuItem;
    AcToExcel: TAction;
    mnmData: TMenuItem;
    mnmAdd: TMenuItem;
    mnmEdit: TMenuItem;
    mnmDelete: TMenuItem;
    AcManualOrg: TAction;
    btnManualOrg: TToolbarButton97;
    mnmSplitter2: TMenuItem;
    mnmManualOrg: TMenuItem;
    AcManualService: TAction;
    mnmManualService: TMenuItem;
    mnmSplitter4: TMenuItem;
    btnManualUser: TToolbarButton97;
    AcManualUser: TAction;
    btnService: TToolbarButton97;
    mnmSplitter3: TMenuItem;
    mnmManualUser: TMenuItem;
    AcUnCorrectStreet: TAction;
    btnUnCorrectStreet: TToolbarButton97;
    mnmUnCorrectStreet: TMenuItem;
    AcEndDay: TAction;
    btnMailerTbl: TToolbarButton97;
    mnmEndDay: TMenuItem;
    AcMailerTbl: TAction;
    btnDayEnd: TToolbarButton97;
    mnmMailerTbl: TMenuItem;
    CoolTrayIcon: TCoolTrayIcon;
    pmTrayIcon: TPopupMenu;
    mnmHideToTray: TMenuItem;
    AcShowHideWindow: TAction;
    pmShowHideWindow: TMenuItem;
    pmAbout: TMenuItem;
    pmExit: TMenuItem;
    AcActiveCard: TAction;
    mnmActiveCard: TMenuItem;
    btnActiveCard: TToolbarButton97;
    ToolbarSep2: TToolbarSep97;
    AcTelephone: TAction;
    btnTelefone: TToolbarButton97;
    mnmTelephone: TMenuItem;
    AcLim: TAction;
    btnLim: TToolbarButton97;
    mnmLim: TMenuItem;
    AcCASHS04: TAction;
    mnmCASHS04: TMenuItem;
    AcReeSend: TAction;
    mnmReeSend: TMenuItem;
    btnReeSend: TToolbarButton97;
    AcManualAbonent: TAction;
    mnmManualAbonent: TMenuItem;
    btnManualAbonent: TToolbarButton97;
    AcReeArc: TAction;
    mnmReeArc: TMenuItem;
    btnReeArc: TToolbarButton97;
    TimerUnCorrectStreet: TTimer;
    TimerReeArc: TTimer;
    mnmAbonents: TMenuItem;
    AcDataBaseEditor: TAction;
    mnmDataBaseEditor: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure AcOptionsExecute(Sender: TObject);
    procedure AcExitExecute(Sender: TObject);
    procedure AcAboutExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure AcManualCityExecute(Sender: TObject);
    procedure AcManualStreetExecute(Sender: TObject);
    procedure ChildActionsUpdate(Action: TBasicAction;
      var Handled: Boolean);
    //универсальный обработчик событий для дочерних окон
    procedure AcChildActionExecute (Sender: TObject);
    procedure AcManualOrgExecute(Sender: TObject);
    procedure AcManualServiceExecute(Sender: TObject);
    procedure AcManualUserExecute(Sender: TObject);
    procedure AcUnCorrectStreetExecute(Sender: TObject);
    procedure AcEndDayExecute(Sender: TObject);
    procedure AcMailerTblExecute(Sender: TObject);
    procedure AcShowShowHideWindowExecute(Sender: TObject);
    procedure AcActiveCardExecute(Sender: TObject);
    procedure AcTelephoneExecute(Sender: TObject);
    procedure AcLimExecute(Sender: TObject);
    procedure AcCASHS04Execute(Sender: TObject);
    procedure AcReeSendExecute(Sender: TObject);
    procedure AcManualAbonentExecute(Sender: TObject);
    procedure AcReeArcExecute(Sender: TObject);
    procedure TimerUnCorrectStreetTimer(Sender: TObject);
    procedure TimerReeArcTimer(Sender: TObject);
    procedure AcDataBaseEditorExecute(Sender: TObject);
  private
    procedure ExecuteChildAction(Sender: TObject; ac: TChildActions);
    procedure DisplayHint(Sender: TObject);
    procedure LogOn;
    procedure LoadFromIni;
    procedure SaveToIni;
  public
    fFirstActiveWindow: boolean;

    fUnCorrectStreet: boolean;
    fUnCorrectStreetValue: double;

    fReeArc: boolean;
    fReeArcValue: double;
  end;

var
  frmMain: TfrmMain;

implementation

uses
        dmCityNavigator,
        uCommon,
	fAbout,
        fManualCity,
        fManualStreet,
        fManualOrg,
        fManualService,
        fManualUser,
        fUnCorrectStreet,
        fDayEnd,
        fMailerTbl,
        fActiveCard,
        fTelephone,
        fLim,
        fCASHS04,
        fReeSend,
        fManualAbonent,
        fReeArc,
        fOptions,
        fDataBaseEditor;

{$R *.dfm}

//создание формы
procedure TfrmMain.FormCreate(Sender: TObject);
begin
	Application.OnHint := DisplayHint;
        fFirstActiveWindow := true;

	AcAdd.Tag     := integer(childAdd);
	AcEdit.Tag    := integer(childEdit);
	AcDelete.Tag  := integer(childDelete);
        AcRefresh.Tag := integer(childRefresh);
	AcToExcel.Tag := integer(childToExcel);
end;

//отображение формы
procedure TfrmMain.FormShow(Sender: TObject);
var
	f: TextFile;

        info,
        prog_version,
        update_version: string;
begin
	LoadFromIni;

	if (fFirstActiveWindow) then
        begin
	  	LogOn;
        	CoolTrayIcon.IconVisible := true;
        end;

        fFirstActiveWindow := false;

        //проверка обновления программы
        prog_version := '1.5.3';
        if FileExists('Q:\COMMON\dsm\CityNavigator\Update.txt') then
        begin
		AssignFile(f, 'Q:\COMMON\dsm\CityNavigator\Update.txt');
		Reset(f);
		Readln(f, update_version);

                if (prog_version <> update_version) then
                begin
                	Readln(f, info);
                	MsgBox('Доступна новая версия: ' + update_version + #13 + info);
                end;
        end;

        //TfrmUnCorrectStreet.Create(self).Show;
end;

//закрытие формы
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	SaveToIni;
	DataMod.OracleSession.LogOff;
        Action := caFree;
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
begin
	StatusBar.Panels[1].Text := GetLongHint(Application.Hint);
end;

//------------------------------------------------------------------------------
//
//	Actions
//
//------------------------------------------------------------------------------

procedure TfrmMain.ExecuteChildAction(Sender: TObject; ac: TChildActions);
var
	info: PChildInfo;
begin
	if ActiveMDIChild = nil then
		exit;

	info := PChildInfo(ActiveMDIChild.Tag);
	if Assigned (info.Actions[ac]) then
	if (info <> nil) then
		info.Actions[ac](Sender);
end;

//универсальный обработчик событий для дочерних окон
procedure TfrmMain.AcChildActionExecute(Sender: TObject);
var
	child_action: TChildActions;
	action: TAction;
begin
	if not (Sender is TAction) then
		exit;

	Action       := TAction (Sender);
	child_action := TChildActions(action.Tag);
	ExecuteChildAction(action, child_action);
end;

procedure TfrmMain.ChildActionsUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
	info: PChildInfo;
	b: boolean;
begin
	Handled := true;

	info := nil;
	if (ActiveMDIChild <> nil) then
		info := PChildInfo (ActiveMDIChild.Tag);
	b := info <> nil;
	if (b) then
	begin
		AcAdd.Enabled	  := Assigned (info.Actions[childAdd]);
		AcEdit.Enabled	  := Assigned (info.Actions[childEdit]);
		AcDelete.Enabled  := Assigned (info.Actions[childDelete]);
		AcRefresh.Enabled := Assigned (info.Actions[childRefresh]);
                AcToExcel.Enabled := Assigned (info.Actions[childToExcel]);
	end

        else
        begin
		AcAdd.Enabled	  := false;
		AcEdit.Enabled	  := false;
		AcDelete.Enabled  := false;
		AcRefresh.Enabled := false;
                AcToExcel.Enabled := false;
	end;
end;

//------------------------------------------------------------------------------
//
//	INI
//
//------------------------------------------------------------------------------

//загрузка параметров из ini-файла
procedure TfrmMain.LoadFromIni;
var
	sect: String;
begin
	sect  := 'DataBase';
	DataMod.OracleSession.LogonDatabase := OptionsIni.ReadString(sect, 'DataBase', '');
        DataMod.OracleSession.LogonUsername := OptionsIni.ReadString(sect, 'UserName', '');

	sect := 'Options';
	fUnCorrectStreet              := OptionsIni.ReadBool(sect, 'UnCorrectStreet', false);
        fUnCorrectStreetValue         := OptionsIni.ReadFloat(sect, 'UnCorrectStreetValue', 1000);
        TimerUnCorrectStreet.Interval := 1000 * OptionsIni.ReadInteger(sect, 'UnCorrectStreetTimeOut', 60); //мс > сек

        fReeArc                       := OptionsIni.ReadBool(sect, 'ReeArc', false);
        fReeArcValue                  := OptionsIni.ReadFloat(sect, 'ReeArcValue', 0);
        TimerReeArc.Interval          := 1000 * OptionsIni.ReadInteger(sect, 'ReeArcTimeOut', 60); //мс > сек
end;

//сохранение параметров в ini-файл
procedure TfrmMain.SaveToIni;
var
	sect: String;
begin
	sect  := 'DataBase';
        OptionsIni.WriteString(sect, 'DataBase', DataMod.OracleSession.LogonDatabase);
        OptionsIni.WriteString(sect, 'UserName', DataMod.OracleSession.LogonUsername);
end;

//настройки
procedure TfrmMain.AcOptionsExecute(Sender: TObject);
var
	frm: TfrmOptions;
        mr: integer;
begin
	frm := TfrmOptions.Create(self);
        mr := frm.ShowModal;

        if (mr = mrOK) then
        	LoadFromIni;
end;

//выход
procedure TfrmMain.AcExitExecute(Sender: TObject);
begin
	Close;
end;

//о программе
procedure TfrmMain.AcAboutExecute(Sender: TObject);
var
	frm: TfrmAbout;
begin
	frm := TfrmAbout.Create(self);
        frm.ShowModal;
end;

//вход в программу
procedure TfrmMain.LogOn;
begin
	//DataMod.OracleSession.LogonPassword := 'scorpion235';

        if (not DataMod.OracleLogon.Execute) then
        	Close;

        StatusBar.Panels[0].Text := DataMod.OracleSession.LogonUsername + '@' + DataMod.OracleSession.LogonDatabase
end;

//справочник городов
procedure TfrmMain.AcManualCityExecute(Sender: TObject);
var
        frm: TfrmManualCity;
begin
	frm := TfrmManualCity.Create(self);
        frm.Show;
end;

//справочник улиц
procedure TfrmMain.AcManualStreetExecute(Sender: TObject);
var
        frm: TfrmManualStreet;
begin
	frm := TfrmManualStreet.Create(self);
        frm.Show;
end;

//справочник организаций
procedure TfrmMain.AcManualOrgExecute(Sender: TObject);
var
        frm: TfrmManualOrg;
begin
  	frm := TfrmManualOrg.Create(self);
        frm.Show;
end;

//справочник услуг
procedure TfrmMain.AcManualServiceExecute(Sender: TObject);
var
        frm: TfrmManualService;
begin
  	frm := TfrmManualService.Create(self);
        frm.Show;
end;

//справочник пользователей
procedure TfrmMain.AcManualUserExecute(Sender: TObject);
var
        frm: TfrmManualUser;
begin
  	frm := TfrmManualUser.Create(self);
        frm.Show;
end;

//непривязаные улицы
procedure TfrmMain.AcUnCorrectStreetExecute(Sender: TObject);
var
        frm: TfrmUnCorrectStreet;
begin
  	frm := TfrmUnCorrectStreet.Create(self);
        frm.Show;
end;

//завершение дня
procedure TfrmMain.AcEndDayExecute(Sender: TObject);
var
        frm: TfrmDayEnd;
begin
  	frm := TfrmDayEnd.Create(self);
        frm.Show;
end;

//рассылка на почту
procedure TfrmMain.AcMailerTblExecute(Sender: TObject);
var
        frm: TfrmMailerTbl;
begin
  	frm := TfrmMailerTbl.Create(self);
        frm.Show;
end;

//свернуть/восстановить основное окно
procedure TfrmMain.AcShowShowHideWindowExecute(Sender: TObject);
begin
	//TODO: сложноватая проверка, но пока ничего лучше не придумал

	//Восстановить окно
        if (pmShowHideWindow.Caption = 'Восстановить окно') then
        begin
		CoolTrayIcon.ShowMainForm;
                pmShowHideWindow.Caption := 'Свернуть в трей';
        end

        //Свернуть в трей
        else if (pmShowHideWindow.Caption = 'Свернуть в трей') then
        begin
  		CoolTrayIcon.HideMainForm;
                pmShowHideWindow.Caption := 'Восстановить окно';
        end;
end;

//персонализация карт
procedure TfrmMain.AcActiveCardExecute(Sender: TObject);
var
        frm: TfrmActiveCard;
begin
  	frm := TfrmActiveCard.Create(self);
        frm.ShowModal;
end;

//оплата за сотовый телефон
procedure TfrmMain.AcTelephoneExecute(Sender: TObject);
var
        frm: TfrmTelephone;
begin
  	frm := TfrmTelephone.Create(self);
        frm.Show;
end;

//лимиты
procedure TfrmMain.AcLimExecute(Sender: TObject);
var
        frm: TfrmLim;
begin
  	frm := TfrmLim.Create(self);
        frm.Show;
end;

//CASHS04
procedure TfrmMain.AcCASHS04Execute(Sender: TObject);
var
        frm: TfrmCASHS04;
begin
  	frm := TfrmCASHS04.Create(self);
        frm.Show;
end;

//посылка реестров
procedure TfrmMain.AcReeSendExecute(Sender: TObject);
var
        frm: TfrmReeSend;
begin
  	frm := TfrmReeSend.Create(self);
        frm.Show;
end;

//абоненты
procedure TfrmMain.AcManualAbonentExecute(Sender: TObject);
var
        frm: TfrmManualAbonent;
begin
  	frm := TfrmManualAbonent.Create(self);
        frm.Show;
end;

//архив реестров
procedure TfrmMain.AcReeArcExecute(Sender: TObject);
var
        frm: TfrmReeArc;
begin
  	frm := TfrmReeArc.Create(self);
        frm.Show;
end;

//непривязанные улицы (таймер)
procedure TfrmMain.TimerUnCorrectStreetTimer(Sender: TObject);
var
	street_count: integer;
begin
	//не закрыто окно "Вход в программу"
	if fFirstActiveWindow then
        	exit;

        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(ID)'
        + ' FROM KP.STREET_PU'
        + ' WHERE STREET_ID IS NULL'
        + ' AND STATUS <> ''DEL''';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        street_count := 0;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fMain)'
                + #13 + '(информирование о непривязанный улицах).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        if (not DataMod.OracleDataSet.IsEmpty) then
        	street_count := DataMod.OracleDataSet.Fields[0].AsInteger;

        if ((fUnCorrectStreet) and (street_count > fUnCorrectStreetValue)) then
        	CoolTrayIcon.ShowBalloonHint('Предупреждение', 'Обнаружено ' + IntToStr(street_count) + ' непривязанных улиц.', bitWarning, 10);

        DataMod.OracleDataSet.Close;
end;

//необработанные реестры (таймер)
procedure TfrmMain.TimerReeArcTimer(Sender: TObject);
var
	error_ree: integer;
        reg_date: string;
begin
	//не закрыто окно "Вход в программу"
	if fFirstActiveWindow then
        	exit;

        reg_date := DateToStr(Now) + ' 00:00:00';

        DataMod.OracleDataSet.SQL.Text := 'SELECT COUNT(ID) FROM KP.REE$REEARC'
	+ ' WHERE (STATUS = 5 OR STATUS = 6)'
        + ' AND GOTB >= TO_DATE(''' + reg_date + ''', ''DD.MM.YYYY HH24:MI:SS'')';

        //MsgBox(DataMod.OracleDataSet.SQL.Text);
        error_ree := 0;

        //запуск запроса
        try
	        DataMod.OracleDataSet.Open;
        except
        	Screen.Cursor := crDefault;
        	WarningBox('Ошибка выполнения запроса (fMain)'
                + #13 + '(информирование о необработанных реестрах).'
                + #13 + 'Возможно, у вас нет требуемых прав для запуска запроса.'
                + #13 + #13 + 'Обратитесь к разработчику.');
                exit;
	end;

        if (not DataMod.OracleDataSet.IsEmpty) then
        	error_ree := DataMod.OracleDataSet.Fields[0].AsInteger;

        if ((fReeArc) and (error_ree > fReeArcValue)) then
        	CoolTrayIcon.ShowBalloonHint('Предупреждение', 'Обнаружено ' + IntToStr(error_ree) + ' реестра(ов) в архиве' + #13 + 'в состоянии разобран (с ошибками).', bitWarning, 10);

        DataMod.OracleDataSet.Close;
end;

//Abonents > Редактировать БД
procedure TfrmMain.AcDataBaseEditorExecute(Sender: TObject);
var
        frm: TfrmDataBaseEditor;
begin
  	frm := TfrmDataBaseEditor.Create(self);
        frm.Show;
end;

end.
