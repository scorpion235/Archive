//Модуль данных
unit dmCityNavigator;

interface

uses
  SysUtils, Classes, DB, OracleData, Oracle, IB_Components, Graphics, jpeg;

type
  TDataMod = class(TDataModule)
    OracleSession: TOracleSession;
    OracleDataSet: TOracleDataSet;
    OraclePackage: TOraclePackage;
    IB_Connection: TIB_Connection;
    IB_Transaction: TIB_Transaction;
    IB_Cursor: TIB_Cursor;
    OracleLogon: TOracleLogon;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataMod: TDataMod;

implementation

{$R *.dfm}

end.
