//��������� �������
//������� ������

//����� ����������: Borland Delphi 7.0
//�������������� ����������: EhLib
//�����: ������� ������ ����������
//����: 16.10.2006

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
  UnitAbout; //� ���������

{$R *.dfm}

//------------------------------------------------------------------------------
//����������� �������
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
//�������� �����
procedure TFormMain.FormShow(Sender: TObject);
begin
  //������������ �������� ���������� ��� ������� "sobutiya.db"
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

  //������� �������������� �����������
  Navigator.Left:=0;
  Navigator.Top:=0;

  Grid.Left:=0;
  Grid.Top:=25;
  Grid.Width:=Width-10;
  Grid.Height:=Height-80;

  TodayEvents;
  //��� �������
  if (Query.RecordCount=0) then
    begin
      if (MessageDlg('�� ������� ��� �������.', mtInformation, [mbOK, mbAbort], 0) = mrOK) then
        Close;
      //�������� ���� ������
      Query.Close;
      DataSource.DataSet:=Table;
    end;
end;
//------------------------------------------------------------------------------
//��������� �������� �����
procedure TFormMain.FormResize(Sender: TObject);
begin
  //������� �������������� �����������
  Navigator.Left:=0;
  Navigator.Top:=0;

  Grid.Left:=0;
  Grid.Top:=25;
  Grid.Width:=Width-10;
  Grid.Height:=Height-80;
end;
//------------------------------------------------------------------------------
//������� -> �� �������
procedure TFormMain.events1Click(Sender: TObject);
begin
  TodayEvents;
end;
//------------------------------------------------------------------------------
//������� -> �� ������
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
//������� -> �� �����
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
//������� -> ���
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
//������� -> ��������
procedure TFormMain.add_eventClick(Sender: TObject);
begin
  Query.Close;
  DataSource.DataSet:=Table;
end;
//------------------------------------------------------------------------------
//����� ������� �������
procedure TFormMain.QueryAfterOpen(DataSet: TDataSet);
begin
  Hint:='������� � ������ ������';
end;
//------------------------------------------------------------------------------
//����� �������� �������
procedure TFormMain.QueryAfterClose(DataSet: TDataSet);
begin
  Hint:='������� � ������ ������';
end;
//------------------------------------------------------------------------------
//�������� �����
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DataBase.Close;
end;
//------------------------------------------------------------------------------
//������� -> � ���������
procedure TFormMain.aboutClick(Sender: TObject);
begin
  Application.CreateForm(TFormAbout, FormAbout);
  FormAbout.ShowModal;
end;

end.
