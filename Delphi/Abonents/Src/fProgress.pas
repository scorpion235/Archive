//Отображение прогресса создания отчёта
unit fProgress;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, ComCtrls, StdCtrls, xlReport, ExtCtrls;

type

TfrmProgress = class(TForm)
	bar: TProgressBar;
	StaticText1: TStaticText;
	procedure FormCreate(Sender: TObject);
	procedure ReportProgress(Report: TxlReport; const Position, Max: Integer);
end;

//отображает окно с процессом построения отчета и начинает строить отчет
procedure ProgressReport (report: TxlReport);

implementation

{$R *.dfm}

//отображает окно с процессом построения отчета и начинает строить отчет
procedure ProgressReport(report: TxlReport);
var
	frm: TfrmProgress;
begin
	try
		frm := TfrmProgress.Create(nil);
		frm.Show;
		frm.Update;
		report.OnProgress := frm.ReportProgress;
		report.Report;
	finally
		frm.Free;
	end;
end;

//------------------------------------------------------------------------------
//	TfrmProgress
//------------------------------------------------------------------------------


procedure TfrmProgress.FormCreate(Sender: TObject);
begin
	bar.Min  := 0;
	bar.Max  := 100;
	bar.Step := 1;
end;

procedure TfrmProgress.ReportProgress(Report: TxlReport; const Position, Max: Integer);
begin
	bar.Max      := Max;
	bar.Position := Position;
end;

end.
