//������ ������
unit dmLibU;

interface

uses
  SysUtils, Classes, DB, DBTables;

type
  TdmLib = class(TDataModule)
    dsFind: TDataSource;
    quFind: TQuery;
    quUpDat: TQuery;
    taBook: TTable;
    taLocality: TTable;
    dsBook: TDataSource;
    dsLocality: TDataSource;
    quInputImg: TQuery;
    procedure taBookBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmLib: TdmLib;

implementation

{$R *.dfm}

//����� ��������� ������ � ������� "Book.db"
procedure TdmLib.taBookBeforeDelete(DataSet: TDataSet);
begin
	taLocality.Delete;
end;

end.
