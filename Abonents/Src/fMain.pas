//Abonents - основная форма
//Авторские права © 2010-212 ОАО "Челябинвестбанк"

//Автор: Дюгуров Сергей Михайлович
//E-mail: scorpion235@mail.ru
//Среда разработки: Delphi 6.0 Service Pack 2
//Начало разработки:    2009-10-18
//Окончание разработки: 2012-11-11
//Дополнительные библиотеки: RxLib, EhLib, xlReport, ElTree, IBO, Toolbar97, IBO, EasyGraph

//Написание хороших программ требует
//ума, вкуса и терпения
//                        Страуструп

unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdActns, ActnList, Menus, elTree, uChild, TB97Tlbr, TB97Ctls,
  TB97, ImgList, ComCtrls, LMDCustomControl, LMDCustomPanel,
  LMDCustomBevelPanel, LMDBaseEdit, LMDCustomEdit, LMDCustomMaskEdit,
  LMDCalculatorEdit, LMDCustomBrowseEdit, LMDColorEdit, LMDCustomExtCombo,
  LMDCalendarComboBox, LMDControl, LMDBaseControl, LMDBaseGraphicControl,
  LMDGraphicControl, LMDBaseMeter, LMDCustomProgress, LMDProgress,
  ExtCtrls, IB_ConnectionBar, StdCtrls;

type
  TfrmMain = class(TForm)
    StandartActions: TActionList;
    AcShowHideWindow: TAction;
    AcWindowCascade: TWindowCascade;
    AcWindowTileHorizontal: TWindowTileHorizontal;
    AcWindowTileVertical: TWindowTileVertical;
    AcWindowArrange: TWindowArrange;
    AcWindowMinimizeAll: TWindowMinimizeAll;
    AcWindowClose: TWindowClose;
    AcOptions: TAction;
    AcExit: TAction;
    AcAbout: TAction;
    AcService: TAction;
    ChildActions: TActionList;
    AcAdd: TAction;
    AcEdit: TAction;
    AcDelete: TAction;
    AcRefresh: TAction;
    AcToExcel: TAction;
    StatusBar: TStatusBar;
    ImageList: TImageList;
    MainMenu: TMainMenu;
    mnmWork: TMenuItem;
    mnmOptions: TMenuItem;
    mnmSplitter1: TMenuItem;
    mnmExit: TMenuItem;
    mnmManual: TMenuItem;
    mnmServices: TMenuItem;
    mnmData: TMenuItem;
    mnmAdd: TMenuItem;
    mnmEdit: TMenuItem;
    mnmDelete: TMenuItem;
    mnmSplitter3: TMenuItem;
    mnmRefresh: TMenuItem;
    mnmReport: TMenuItem;
    mnmExcel: TMenuItem;
    mnmWindow: TMenuItem;
    mnmCascade: TMenuItem;
    mnmHorizontal: TMenuItem;
    mnmVertical: TMenuItem;
    mnmMinimizeAll: TMenuItem;
    mnmArrange: TMenuItem;
    mnmClose: TMenuItem;
    mnmHelp: TMenuItem;
    mnmAbout: TMenuItem;
    DockTop: TDock97;
    MainToolbar: TToolbar97;
    btnRefresh: TToolbarButton97;
    btnAdd: TToolbarButton97;
    btnEdit: TToolbarButton97;
    ToolbarSep2: TToolbarSep97;
    btnDelete: TToolbarButton97;
    btnMailerTbl: TToolbarButton97;
    AcFilterPanel: TAction;
    ToolbarSep1: TToolbarSep97;
    mnmView: TMenuItem;
    mnmFilterPanel: TMenuItem;
    btnFilterBar: TToolbarButton97;
    AcCity: TAction;
    AcStreet: TAction;
    AcAgent: TAction;
    mnmStreet: TMenuItem;
    mnmAgent: TMenuItem;
    mnmService: TMenuItem;
    mnmSplitter2: TMenuItem;
    ToolbarButton971: TToolbarButton97;
    ToolbarButton972: TToolbarButton97;
    ToolbarButton973: TToolbarButton97;
    AcAbonent: TAction;
    AcPays: TAction;
    mnmPays: TMenuItem;
    mnmAbonent: TMenuItem;
    ToolbarButton974: TToolbarButton97;
    ToolbarButton975: TToolbarButton97;
    ToolbarSep3: TToolbarSep97;
    AcExport: TAction;
    AcImport: TAction;
    mnmReestr: TMenuItem;
    mnmExportReestr: TMenuItem;
    mnmImportReestr: TMenuItem;
    N1: TMenuItem;
    AcPrint: TAction;
    procedure ChildActionsUpdate(Action: TBasicAction;
      var Handled: Boolean);
    //универсальный обработчик событий для дочерних окон
    procedure AcChildActionExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AcOptionsExecute(Sender: TObject);
    procedure AcExitExecute(Sender: TObject);
    procedure AcAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AcServiceExecute(Sender: TObject);
    procedure AcCityExecute(Sender: TObject);
    procedure AcStreetExecute(Sender: TObject);
    procedure AcAgentExecute(Sender: TObject);
    procedure AcAbonentExecute(Sender: TObject);
    procedure AcPaysExecute(Sender: TObject);
    procedure AcExportExecute(Sender: TObject);
    procedure AcImportExecute(Sender: TObject);
    procedure AcPrintExecute(Sender: TObject);
  private
    procedure ExecuteChildAction(Sender: TObject; ac: TChildActions);
    procedure DisplayHint(Sender: TObject);
    function Connection: boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
        dmAbonents,
        uCommon,
        fAbonent,
        fPay,
        fOptions,
        fCity,
        fStreet,
        fAgent,
        fService,
        fExportReestr,
        fImportReestr,
        fAbout;

{$R *.dfm}

//создание формы
procedure TfrmMain.FormCreate(Sender: TObject);
begin
	StatusBar.Panels[1].Text := 'База данных: ' + GetCurrentDir + '\DataBase\Abonents.fdb';
	Application.OnHint := DisplayHint;

        AcFilterPanel.Tag  := integer(childFilterPanel);
	AcAdd.Tag          := integer(childAdd);
	AcEdit.Tag         := integer(childEdit);
	AcDelete.Tag       := integer(childDelete);
	AcRefresh.Tag      := integer(childRefresh);
	AcToExcel.Tag      := integer(childToExcel);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
	if (not Connection) then
         	Close;

        //TfrmImportReestr.Create(self).ShowModal;
        //TfrmAbonent.Create(self).Show;
end;

//закрытие формы
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	DataMod.IB_Connection.Disconnect;
        Action := caFree;
end;

procedure TfrmMain.DisplayHint(Sender: TObject);
begin
        StatusBar.Panels[1].Text := 'База данных: ' + GetCurrentDir + '\DataBase\Abonents.fdb';
	StatusBar.Panels[0].Text := GetLongHint(Application.Hint);
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

	Action       := TAction(Sender);
	child_action := TChildActions(action.Tag);
	ExecuteChildAction(action, child_action);
end;

procedure TfrmMain.ChildActionsUpdate(Action: TBasicAction; var Handled: Boolean);
var
	info: PChildInfo;
	b: boolean;
begin
	Handled := true;

	info := nil;
	if (ActiveMDIChild <> nil) then
		info := PChildInfo(ActiveMDIChild.Tag);
	b := info <> nil;
	if (b) then
	begin
        	AcFilterPanel.Enabled := Assigned(info.Actions[childFilterPanel]);
		AcFilterPanel.Checked := info.abFilterPanelOn;
		AcAdd.Enabled	      := Assigned(info.Actions[childAdd])    and info.abAdd;
		AcEdit.Enabled	      := Assigned(info.Actions[childEdit])   and info.abEdit;
		AcDelete.Enabled      := Assigned(info.Actions[childDelete]) and info.abDelete;
		AcRefresh.Enabled     := Assigned(info.Actions[childRefresh]);
                AcToExcel.Enabled     := Assigned(info.Actions[childToExcel]);
	end

        else
        begin
        	AcFilterPanel.Enabled := false;
		AcFilterPanel.Checked := false;
            	AcAdd.Enabled	      := false;
		AcEdit.Enabled	      := false;
		AcDelete.Enabled      := false;
		AcRefresh.Enabled     := false;
                AcToExcel.Enabled     := false;
        end;

        AcPrint.Enabled :=  MDIChildCount > 0;
end;

//настройки
procedure TfrmMain.AcOptionsExecute(Sender: TObject);
var
	frm: TfrmOptions;
begin
	frm := TfrmOptions.Create(self);
        frm.ShowModal;
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

//подключение к базе данных
function TfrmMain.Connection: boolean;
begin
	result := false;

	with (DataMod.IB_Connection) do
	begin
        	Path     := GetCurrentDir + '\DataBase\Abonents.fdb';
        	Username := 'SYSDBA';
        	Password := 'masterkey'
     	end;

     	//подключение к базе данных
     	try
     	   	DataMod.IB_Connection.Connect;

     	//обработчик исключений
     	except
           	ErrorBox('Не удалось подключиться к базе данных.' + #13 + #13 +
                         'Причины:' + #13 +
                         '1. Не установлен или не запущен Firebird Server.' + #13 +
                         '2. Файл "' + DataMod.IB_Connection.Path + '" не был найден.');
           	exit;
     	end;

        result := true;
end;

//абоненты
procedure TfrmMain.AcAbonentExecute(Sender: TObject);
var
        frm: TfrmAbonent;
begin
  	frm := TfrmAbonent.Create(self);
        frm.Show;
end;

//платежи без лицевых счетов
procedure TfrmMain.AcPaysExecute(Sender: TObject);
var
        frm: TfrmPay;
begin
  	frm := TfrmPay.Create(self);
        frm.Show;
end;

//печать
procedure TfrmMain.AcPrintExecute(Sender: TObject);
var
	frmAbonent: TfrmAbonent;
        frmPay:     TfrmPay;
        frmCity:    TfrmCity;
        frmStreet:  TfrmStreet;
        frmAgent:   TfrmAgent;
        frmService: TfrmService;
begin
	//абоненты
   	if ActiveMDIChild is TfrmAbonent then
	begin
		frmAbonent := TfrmAbonent(ActiveMDIChild);
		if (frmAbonent <> nil) then
			frmAbonent.Print;
        end;

        //платежи без лицевых счетов
        if ActiveMDIChild is TfrmPay then
	begin
		frmPay := TfrmPay(ActiveMDIChild);
		if (frmPay <> nil) then
			frmPay.Print;
        end;

        //города
        if ActiveMDIChild is TfrmCity then
	begin
		frmCity := TfrmCity(ActiveMDIChild);
		if (frmCity <> nil) then
			frmCity.Print;
        end;

        //улицы
        if ActiveMDIChild is TfrmStreet then
	begin
		frmStreet := TfrmStreet(ActiveMDIChild);
		if (frmStreet <> nil) then
			frmStreet.Print;
        end;

        //агенты
        if ActiveMDIChild is TfrmAgent then
	begin
		frmAgent := TfrmAgent(ActiveMDIChild);
		if (frmAgent <> nil) then
			frmAgent.Print;
        end;

        //услуги
        if ActiveMDIChild is TfrmService then
	begin
		frmService := TfrmService(ActiveMDIChild);
		if (frmService <> nil) then
			frmService.Print;
        end;
end;

//справочник городов
procedure TfrmMain.AcCityExecute(Sender: TObject);
var
        frm: TfrmCity;
begin
  	frm := TfrmCity.Create(self);
        frm.Show;
end;

//справочник улиц
procedure TfrmMain.AcStreetExecute(Sender: TObject);
var
        frm: TfrmStreet;
begin
  	frm := TfrmStreet.Create(self);
        frm.Show;
end;

//справочник агентов
procedure TfrmMain.AcAgentExecute(Sender: TObject);
var
        frm: TfrmAgent;
begin
  	frm := TfrmAgent.Create(self);
        frm.Show;
end;

//справочник услуг
procedure TfrmMain.AcServiceExecute(Sender: TObject);
var
        frm: TfrmService;
begin
  	frm := TfrmService.Create(self);
        frm.Show;
end;

//реестр > выгрузить
procedure TfrmMain.AcExportExecute(Sender: TObject);
var
        frm: TfrmExportReestr;
        mr, i: integer;
begin
  	frm := TfrmExportReestr.Create(self);
        mr := frm.ShowModal;

        //если была произведена выгрузка реестров, то закрываем все открытые окна Абонентов
        if (mr = mrOk) then
        	for i := 0 to MDIChildCount - 1 do
                	if MDIChildren[i] is TfrmAbonent then
                         	MDIChildren[i].Close;
end;

//реестр > загрузить
procedure TfrmMain.AcImportExecute(Sender: TObject);
var
        frm: TfrmImportReestr;
        mr, i: integer;
begin
  	frm := TfrmImportReestr.Create(self);
        mr := frm.ShowModal;

        //если была произведена загрузка реестров, то закрываем все открытые окна Абонентов
        if (mr = mrOk) then
        	for i := 0 to MDIChildCount - 1 do
                	if MDIChildren[i] is TfrmAbonent then
                         	MDIChildren[i].Close;
end;

end.
