//Модуль данных
unit dmAbonents;

interface

uses
  SysUtils, Classes, IB_Components;

type
  TDataMod = class(TDataModule)
    IB_Connection: TIB_Connection;
    IB_Transaction: TIB_Transaction;
    IB_Cursor: TIB_Cursor;
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
