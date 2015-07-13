//Скорость набора
//2010-11
unit fMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, elTree, ExtCtrls, StdCtrls, Mask, DBCtrlsEh, LMDCustomControl,
  LMDCustomPanel, LMDCustomBevelPanel, LMDBaseEdit, LMDCustomMemo, LMDMemo,
  Buttons, TB97Ctls, TB97, TB97Tlbr;

type
  TfrmMain = class(TForm)
    meText: TLMDLabeledMemo;
    Timer: TTimer;
    Dock: TDock97;
    Toolbar: TToolbar97;
    ToolbarButton971: TToolbarButton97;
    edTypingTime: TDBEditEh;
    edSimbolCount: TDBEditEh;
    edTypingSpeed: TDBEditEh;
    ToolbarButton972: TToolbarButton97;
    procedure TimerTimer(Sender: TObject);
    procedure meTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ToolbarButton972Click(Sender: TObject);
    procedure ToolbarButton971Click(Sender: TObject);
  private
    fStartTime: TTime;
    fSimbolCount: longint;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.TimerTimer(Sender: TObject);
var
        typing_time: double;
begin
        if (fStartTime = 0) then
                exit;

        edTypingTime.Value  := TimeToStr(Now - fStartTime);
        typing_time         := StrToTime(edTypingTime.Value) * MinsPerDay;
        edSimbolCount.Value := fSimbolCount;

        if (typing_time > 0) then 
                edTypingSpeed.Value := round(fSimbolCount / typing_time);
end;

procedure TfrmMain.meTextKeyPress(Sender: TObject; var Key: Char);
begin
        if (fSimbolCount = 0) then
                fStartTime := Now;

        inc(fSimbolCount);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
        fSimbolCount        := 0;
        fStartTime          := 0;
        edTypingTime.Value  := '00:00:00';
        edSimbolCount.Value := 0;
        edTypingSpeed.Value := 0;
end;

procedure TfrmMain.ToolbarButton972Click(Sender: TObject);
begin
        if (Timer.Enabled) then
                Timer.Enabled := false
        else
                Timer.Enabled := true;
end;

procedure TfrmMain.ToolbarButton971Click(Sender: TObject);
begin
        if (Application.MessageBox(PChar('Очистить окно ввода?'), PChar(Application.Title), MB_YESNO) = mrNo) then
                exit;

        meText.Clear;                

        fSimbolCount        := 0;
        fStartTime          := 0;
        edTypingTime.Value  := '00:00:00';
        edSimbolCount.Value := 0;
        edTypingSpeed.Value := 0;
end;

end.
