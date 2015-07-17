/*
   Полнофункциональный проигрыватель CD дисков.
   Контролирует наличие диска в дисководе и его тип.
   Демонстрирует использование компонента MediaPlayer.

*/

#include <vcl.h>
#pragma hdrstop

#include "CDPlayer_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

#define Webdings // на кнопках плеера стандартные символы,
                 // изображение которых взято из шрифта Webdings

#ifdef Webdings
// "текст" на кнопках при использовании
// шрифта Webdings
#define PLAY     "4"
#define STOP     "<"
#define PREVIOUS "9"
#define NEXT     ":"

#else
// текст на кнопках при использовании
// обычного шрифта, например Arial
#define PLAY     "Play"
#define STOP     "Stop"
#define PREVIOUS "Previous"
#define NEXT     "Next"
#endif

// эти макросы обеспечивают перевод интервала времени
// выраженного в миллисекундах в минуты и секунды
#define MINUTE(ms) ((ms/1000)/60)
#define SECOND(ms) ((ms/1000)%60)

// выводит в поле Label1 информацию о текущем треке
void __fastcall TForm1::TrackInfo()
{
    int ms; // время звучания трека, мсек
    AnsiString st;

    Track  =  MCI_TMSF_TRACK(MediaPlayer->Position);

    MediaPlayer->TimeFormat = tfMilliseconds;
    ms = MediaPlayer->TrackLength[Track];
    MediaPlayer->TimeFormat = tfTMSF;

    st = "Трек "+ IntToStr(Track);
    st = st +  ". Длительность "+ IntToStr(MINUTE(ms));
    st = st + ":" + IntToStr(SECOND(ms));

    Label1->Caption = st;
}

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    Button1->Caption = PLAY;
    Button2->Caption = PREVIOUS;
    Button3->Caption = NEXT;
    MediaPlayer->Notify = true; // разрешить событие Notify
}

// изменение состояния плеера
void __fastcall TForm1::MediaPlayerNotify(TObject *Sender)
{
  switch ( MediaPlayer->Mode )
  {
    case mpOpen: // пользователь открыл дисковод
    {
        Button1->Enabled  =  false;
        Button1->Caption  =  PLAY;
        Button1->Tag  =  0;
        Button2->Enabled  =  false;
        Button3->Enabled  =  false;
        Label2->Caption  =  "00:00";

        /* по сигналу от таймера будем проверять
           состояние дисковода */
        Timer->Enabled  =  True;
    }
  }
  MediaPlayer->Notify  =  true;
}

// щелчок на кнопке Play/Stop
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  if ( Button1->Tag == 0 ) {
    // щелчок на кнопке Play
    MediaPlayer->Play();
    Button1->Caption  =  STOP;
    Button1->Hint = "Стоп";
    Button1->Tag  =  1;
    Button3->Enabled  =  true; // доступна кнопка "следующий трек"
    MediaPlayer->Notify  =  true;
    Timer->Enabled  = true;
    TrackInfo();
  }
  else {
    // щелчок на кнопке Stop
    Button1->Caption  =  PLAY;
    Button1->Hint = "Воспроизведение";
    Button1->Tag  =  0;
    MediaPlayer->Notify  =  true;
    MediaPlayer->Stop();
    Timer->Enabled  =  false;
  }
}

// сигнал от таймера: вывести номер трека
// и время воспроизведения
void __fastcall TForm1::TimerTimer(TObject *Sender)
{
  int trk;          // трек
  int min, sec;     // время
  AnsiString st;

  if ( MediaPlayer->Mode == mpPlaying ) // режим воспроизведения
  {
    // получить номер воспроизводимого трека и
    trk  =  MCI_TMSF_TRACK(MediaPlayer->Position);

    if ( trk != Track ) // произошла смена трека
    {
      TrackInfo();
      Track  =  trk;
      if ( Track == 2 )
          Button2->Enabled  =  true;  // доступна кнопка "пред.трек"
      if ( Track == MediaPlayer->Tracks)
          Button3->Enabled  =  false; // кнопка "след.трек" недоступна
    }

    // вывод информации о воспроизводимом треке
    min  =  MCI_TMSF_MINUTE(MediaPlayer->Position);
    sec  =  MCI_TMSF_SECOND(MediaPlayer->Position);
    st.printf("%d:%.2d",min,sec);
    Label2->Caption = st;
    return;
  }

  // Если дисковод открыт или в нем нет
  // AudioCD, то Mode == mpOpen.
  // Ждем диск, т.е. до тех пор пока не будет Mode == mpStopped + кол-во треков > 1
  if ( (MediaPlayer->Mode == mpStopped) &&
     (MediaPlayer->Tracks > 1) )
  {
    // диск вставлен
    Timer->Enabled  =  false;
    Button1->Caption = PLAY;
    Button1->Enabled  =  true;
    Button1->Tag = 0;
    MediaPlayer->Notify  =  true;

    // получить информацию о времени звучания CD
    MediaPlayer->TimeFormat = tfMilliseconds;

    int ms = MediaPlayer->Length;
    AnsiString st = "Audio CD. Время звучания: ";

    st = st +  IntToStr(MINUTE(ms));
    st = st + ":" + IntToStr(SECOND(ms));
    Label1->Caption  =  st;

    MediaPlayer->TimeFormat = tfTMSF;
    Label1->Visible  =  true;
    Track = 0;
    return;
  }

  // дисковод открыт или в дисководе не Audio CD
  if (( MediaPlayer->Mode == mpOpen )||
      (MediaPlayer->Mode == mpStopped) && (MediaPlayer->Tracks == 1))
  {
    Label1->Caption  =  "Вставьте Audio CD";
    if ( Label1->Visible )
          Label1->Visible  =  false;
    else  Label1->Visible  =  true;
  }
}

// щелчок на кнопке "следующий трек"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  MediaPlayer->Next();
  // если перешли к последнему треку, то кнопку
  // Next сделать недоступной
  if ( MCI_TMSF_TRACK(MediaPlayer->Position) == MediaPlayer->Tracks )
    Button3->Enabled  =  false;
  if (! Button2->Enabled ) Button2->Enabled = true;
  TrackInfo();
  Label2->Caption = "0:00";
}

// щелчок на кнопке "предыдущий трек"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    MediaPlayer->Previous(); // в начало текущего трека
    MediaPlayer->Previous(); // в начало предыдущего трек
    if ( MCI_TMSF_TRACK(MediaPlayer->Position) == 1 )
      Button2->Enabled  =  false;
    if ( ! Button3->Enabled )
      Button3->Enabled  =  true;
    TrackInfo();
    Label2->Caption = "0:00";
}

// пользователь закрыл окно программы
void __fastcall TForm1::FormClose(TObject *Sender, TCloseAction &Action)
{
    MediaPlayer->Stop();
    MediaPlayer->Close();
}

