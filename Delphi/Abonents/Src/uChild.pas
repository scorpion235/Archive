//Модуль для создания записей о дочерних окнах
unit uChild;

interface

uses
	Classes, Forms;

type

TChildActions = (
        childFilterPanel,
	childAdd,
        childEdit,
        childDelete,
        childRefresh,
        childToExcel
);

//описание для всех MDI Child программы
PChildInfo = ^TChildInfo;
TChildInfo = record
	//Bof: boolean;       //признак что текущая запись - первая
	//Eof: boolean;       //признак что текущая запись - последняя
        abFilterPanelOn: boolean; //отображение панели быстрого фильтра
        abAdd: boolean;           //признак возможности дабавлять записи
        abEdit: boolean;          //признак возможности редактировать записи
        abDelete: boolean;        //признак возможности удалять записи
        abRefresh: boolean;       //признак возможности обновлять записи
	Actions: array[TChildActions] of TNotifyEvent;
end;

//создает запись для хранения свойств дочернего окна
procedure NewChildInfo(var p: PChildInfo); overload;
procedure NewChildInfo(var p: PChildInfo; frm: TForm); overload;

implementation

procedure NewChildInfo(var p: PChildInfo);
var
	i: TChildActions;
begin
	new(p);
	for i := low(TChildActions) to high(TChildActions) do
		p.Actions[i] := nil;
end;

procedure NewChildInfo(var p: PChildInfo; frm: TForm);
begin
	NewChildInfo(p);
	frm.Tag := integer(p);
end;

end.
