//Календарь событий
//Главный модуль

//Среда разработки: Borland Delphi 7.0
//Дополнительные библиотеки: EhLib
//Автор: Дюгурос Сергей Мтхайлович
//Дата: 16.10.2006

unit UnitMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, DBTables, Grids, DBGridEh, ExtCtrls, DBCtrls,
  ComCtrls, XPMan, StdCtrls;

type
  TFormMain = class(TForm)
    Navigator: TDBNavigator;
    Database: TDatabase;
    DataSource: TDataSource;
    MainMenu: TMainMenu;
    spravra: TMenuItem;
    about: TMenuItem;
    Grid: TDBGridEh;
    events: TMenuItem;
    events1: TMenuItem;
    events2: TMenuItem;
    events3: TMenuItem;
    all_events: TMenuItem;
    XPManifest1: TXPManifest;
    Table: TTable;
    Query: TQuery;
    N1: TMenuItem;
    add_event: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure events1Click(Sender: TObject);
    procedure all_eventsClick(Sender: TObject);
    procedure events3Click(Sender: TObject);
    procedure add_eventClick(Sender: TObject);
    procedure QueryAfterOpen(DataSet: TDataSet);
    procedure QueryAfterClose(DataSet: TDataSet);
    procedure events2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aboutClick(Sender: TObject);
  private
    procedure TodayEvents();
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  UnitAbout; //О программе

{$R *.dfm}

//------------------------------------------------------------------------------
//Сегодняшние события
procedure TFormMain.TodayEvents();
begin
  DataSource.Enabled:=false;
  Query.SQL.clear;
  Query.SQL.add('select * from "sobutiya.db" where (Data="'+DateToStr(Now())+'") order by Vremya');
  Query.Open;
  DataSource.DataSet:=Query;
  DataSource.Enabled:=true;
end;
//------------------------------------------------------------------------------
//Открытие формы
procedure TFormMain.FormShow(Sender: TObject);
begin
  //динамическое создание псевдонима для таблицы "sobutiya.db"
  Database.DatabaseName:='Alias1';
  Database.DriverName:='STANDARD';
  Database.Params.Clear;
  Database.Params.Add(ExtractFilePath(ParamStr(0)));
  Table.DatabaseName:='Alias1';
  Table.TableName:='sobutiya';
  Table.Active:=true;

  DataSource.DataSet:=Table;
  Grid.DataSource:=DataSource;
  Navigator.DataSource:=DataSource;

  //задание местоположения компонентов
  Navigator.Left:=0;
  Navigator.Top:=0;

  Grid.Left:=0;
  Grid.Top:=25;
  Grid.Width:=Width-10;
  Grid.Height:=Height-80;

  TodayEvents;
  //нет событий
  if (Query.RecordCount=0) then
    begin
      if (MessageDlg('На сегодня нет событий.', mtInformation, [mbOK, mbAbort], 0) = mrOK) then
        Close;
      //показать базу данных
      Query.Close;
      DataSource.DataSet:=Table;
    end;
end;
//------------------------------------------------------------------------------
//Изменение размеров формы
procedure TFormMain.FormResize(Sender: TObject);
begin
  //задание местоположения компонентов
  Navigator.Left:=0;
  Navigator.Top:=0;

  Grid.Left:=0;
  Grid.Top:=25;
  Grid.Width:=Width-10;
  Grid.Height:=Height-80;
end;
//------------------------------------------------------------------------------
//Событие -> на сегодня
procedure TFormMain.events1Click(Sender: TObject);
begin
  TodayEvents;
end;
//------------------------------------------------------------------------------
//Событие -> на неделю
procedure TFormMain.events2Click(Sender: TObject);
begin
  DataSource.Enabled:=false;
  Query.SQL.clear;
  Query.SQL.add('select * from "sobutiya.db" where (WeekOf(StrToDate(Data))=WeekOf(Now())) and (YearOf(Data)=YearOf(DateToStr(Now())))) order by data');
  Query.Open;
  DataSource.DataSet:=Query;
  DataSource.Enabled:=true;
end;
//------------------------------------------------------------------------------
//Событие -> на месяц
procedure TFormMain.events3Click(Sender: TObject);
begin
  DataSource.Enabled:=false;
  Query.SQL.clear;
  Query.SQL.add('select * from "sobutiya.db" where (MonthOf(StrToDate(Data))=MonthOf(Now())) and (YearOf(Data)=YearOf(DateToStr(Now())))) order by Data');
  Query.Open;
  DataSource.DataSet:=Query;
  DataSource.Enabled:=true;
end;
//------------------------------------------------------------------------------
//Событие -> все
procedure TFormMain.all_eventsClick(Sender: TObject);
begin
  DataSource.Enabled:=false;
  Query.SQL.clear;
  Query.SQL.add('select * from "sobutiya.db" where (Data<>"01.01.9999") order by Data');
  Query.Open;
  DataSource.DataSet:=Query;
  DataSource.Enabled:=true;
end;
//------------------------------------------------------------------------------
//Событие -> добавить
procedure TFormMain.add_eventClick(Sender: TObject);
begin
  Query.Close;
  DataSource.DataSet:=Table;
end;
//------------------------------------------------------------------------------
//После запуска запроса
procedure TFormMain.QueryAfterOpen(DataSet: TDataSet);
begin
  Hint:='Таблица в режиме чтения';
end;
//------------------------------------------------------------------------------
//После закрытия запроса
procedure TFormMain.QueryAfterClose(DataSet: TDataSet);
begin
  Hint:='Таблица в режиме записи';
end;
//------------------------------------------------------------------------------
//Закрытие формы
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataBase.Close;
end;
//------------------------------------------------------------------------------
//Справка -> О программе
procedure TFormMain.aboutClick(Sender: TObject);
begin
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.ShowModal;
end;

end.
