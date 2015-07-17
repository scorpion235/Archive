unit fUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI, ExtCtrls, StdCtrls, jpeg;

const
  MAX_BUFFER = 6;

type
  TfrmMain = class(TForm)
    CopyPuskBtn: TButton;
    AnimateBtn: TButton;
    Timer1: TTimer;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure CopyPuskBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AnimateBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    HW: HWND;
    DC: HDC;
    R: TRect;
    FNumber: integer;
    Buffer: array [1 .. MAX_BUFFER] of TBitmap;
    TrayIcon: TNotifyIconData;

    procedure CreateFrames;
    procedure DestroyFrames;
    procedure BuildFrames;
    procedure NotifyIcon(var Msg : TMessage); message WM_USER + 100;
    procedure OnMinimizeEvt(Sender : TObject);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Math;


{$R *.dfm}

// Создаём буфер для спрайтов
procedure TfrmMain.CreateFrames;
var
  i: integer;
begin
  for i := 1 to MAX_BUFFER do
  begin
    Buffer[i] := TBitmap.Create;
    with Buffer[i] do
    begin
      Height := R.Bottom - R.Top;
      Width := R.Right - R.Left;
      Canvas.Brush.Color := clBtnFace;
      Canvas.Pen.Color := clBtnFace;
      Canvas.Rectangle(0, 0, Buffer[i].Width, Buffer[i].Height);
    end;
  end;
end;

procedure TfrmMain.DestroyFrames;
var
  i: integer;
begin
  for i := 1 to MAX_BUFFER do
    Buffer[i].Destroy;
end;

// Подготавливает сегменты/спрайты для анимации
procedure TfrmMain.BuildFrames;
var
  i, j, k, H, W: integer;
  Y: double;
begin
  H := R.Bottom - R.Top;
  W := R.Right - R.Left;
  Image1.Width := W;
  Image1.Height := H;
  for i := 1 to MAX_BUFFER-1 do //Буфер [MAX_BUFFER] используется для хранения оригинального битмапа
    for j := 1 to W do
      for k := 1 to H do
      begin
        Y := 2 * Sin((j * 360 / W) * (pi / 180) - 20 * i);
        Buffer[i].Canvas.Pixels[j, k - Round(Y)] := Buffer[6].Canvas.Pixels[j, k];
      end;
end;

procedure TfrmMain.OnMinimizeEvt(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  HW := FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'Button', nil);
  GetWindowRect(HW, R);
  DC := GetWindowDC(HW);
  CreateFrames;
  FNumber := 1;
  TrayIcon.cbSize := SizeOf(TrayIcon);
  TrayIcon.Wnd := frmMain.Handle;
  TrayIcon.uID := 100;
  TrayIcon.uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
  TrayIcon.uCallbackMessage := WM_USER + 100;
  TrayIcon.hIcon := Application.Icon.Handle;
  Shell_NotifyIcon(NIM_ADD, @TrayIcon);
  Application.OnMinimize := OnMinimizeEvt;
end;

procedure TfrmMain.NotifyIcon(var Msg : TMessage);
begin
  case Msg.LParam of
  WM_LBUTTONDBLCLK:
    begin
      ShowWindow(Application.Handle, SW_SHOW);
      Application.Restore;
    end;
  end;
end;

procedure TfrmMain.CopyPuskBtnClick(Sender: TObject);
begin
  //Получаем изображение оригинальной кнопки, чтобы потом использовать его
  //когда анимация завершится
  BitBlt(Buffer[MAX_BUFFER].Canvas.Handle, 0, 0, R.Right - R.Left, R.Bottom - R.Top, DC, 0, 0, SRCCOPY);
  BuildFrames;
  Image1.Canvas.Draw(0, 0, Buffer[MAX_BUFFER]);
  AnimateBtn.Enabled := true;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Timer1.Enabled := false;
  BitBlt(DC, 0, 0, R.Right - R.Left, R.Bottom - R.Top, Buffer[MAX_BUFFER].Canvas.Handle, 0, 0, SRCCOPY);
  ReleaseDC(HW, DC);
  DestroyFrames; // не забудьте сделать это !!!
  Shell_NotifyIcon(NIM_DELETE, @TrayIcon);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  BitBlt(DC, 0, 0, R.Right - R.Left, R.Bottom - R.Top, Buffer[FNumber].Canvas.Handle, 0, 0, SRCCOPY);
  Inc(FNumber);
  if FNumber > MAX_BUFFER - 1 then
    FNumber := 1;
end;

procedure TfrmMain.AnimateBtnClick(Sender: TObject);
begin
  Timer1.Enabled := not Timer1.Enabled;
  if not Timer1.Enabled then
  begin
    BitBlt(DC, 0, 0, R.Right - R.Left, R.Bottom - R.Top, Buffer[MAX_BUFFER].Canvas.Handle, 0, 0, SRCCOPY);
    AnimateBtn.Caption := '&Animate';
    CopyPuskBtn.Enabled := true;
  end
  else
  begin
    AnimateBtn.Caption := '&Stop';
    CopyPuskBtn.Enabled := false;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caNone;
  PostMessage(frmMain.Handle, WM_DESTROY, 0, 0);
  Application.Terminate;
end;

end.
