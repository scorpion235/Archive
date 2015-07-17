/*
   ������������������� ������������� CD ������.
   ������������ ������� ����� � ��������� � ��� ���.
   ������������� ������������� ���������� MediaPlayer.

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

#define Webdings // �� ������� ������ ����������� �������,
                 // ����������� ������� ����� �� ������ Webdings

#ifdef Webdings
// "�����" �� ������� ��� �������������
// ������ Webdings
#define PLAY     "4"
#define STOP     "<"
#define PREVIOUS "9"
#define NEXT     ":"

#else
// ����� �� ������� ��� �������������
// �������� ������, �������� Arial
#define PLAY     "Play"
#define STOP     "Stop"
#define PREVIOUS "Previous"
#define NEXT     "Next"
#endif

// ��� ������� ������������ ������� ��������� �������
// ����������� � ������������� � ������ � �������
#define MINUTE(ms) ((ms/1000)/60)
#define SECOND(ms) ((ms/1000)%60)

// ������� � ���� Label1 ���������� � ������� �����
void __fastcall TForm1::TrackInfo()
{
    int ms; // ����� �������� �����, ����
    AnsiString st;

    Track  =  MCI_TMSF_TRACK(MediaPlayer->Position);

    MediaPlayer->TimeFormat = tfMilliseconds;
    ms = MediaPlayer->TrackLength[Track];
    MediaPlayer->TimeFormat = tfTMSF;

    st = "���� "+ IntToStr(Track);
    st = st +  ". ������������ "+ IntToStr(MINUTE(ms));
    st = st + ":" + IntToStr(SECOND(ms));

    Label1->Caption = st;
}

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    Button1->Caption = PLAY;
    Button2->Caption = PREVIOUS;
    Button3->Caption = NEXT;
    MediaPlayer->Notify = true; // ��������� ������� Notify
}

// ��������� ��������� ������
void __fastcall TForm1::MediaPlayerNotify(TObject *Sender)
{
  switch ( MediaPlayer->Mode )
  {
    case mpOpen: // ������������ ������ ��������
    {
        Button1->Enabled  =  false;
        Button1->Caption  =  PLAY;
        Button1->Tag  =  0;
        Button2->Enabled  =  false;
        Button3->Enabled  =  false;
        Label2->Caption  =  "00:00";

        /* �� ������� �� ������� ����� ���������
           ��������� ��������� */
        Timer->Enabled  =  True;
    }
  }
  MediaPlayer->Notify  =  true;
}

// ������ �� ������ Play/Stop
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  if ( Button1->Tag == 0 ) {
    // ������ �� ������ Play
    MediaPlayer->Play();
    Button1->Caption  =  STOP;
    Button1->Hint = "����";
    Button1->Tag  =  1;
    Button3->Enabled  =  true; // �������� ������ "��������� ����"
    MediaPlayer->Notify  =  true;
    Timer->Enabled  = true;
    TrackInfo();
  }
  else {
    // ������ �� ������ Stop
    Button1->Caption  =  PLAY;
    Button1->Hint = "���������������";
    Button1->Tag  =  0;
    MediaPlayer->Notify  =  true;
    MediaPlayer->Stop();
    Timer->Enabled  =  false;
  }
}

// ������ �� �������: ������� ����� �����
// � ����� ���������������
void __fastcall TForm1::TimerTimer(TObject *Sender)
{
  int trk;          // ����
  int min, sec;     // �����
  AnsiString st;

  if ( MediaPlayer->Mode == mpPlaying ) // ����� ���������������
  {
    // �������� ����� ���������������� ����� �
    trk  =  MCI_TMSF_TRACK(MediaPlayer->Position);

    if ( trk != Track ) // ��������� ����� �����
    {
      TrackInfo();
      Track  =  trk;
      if ( Track == 2 )
          Button2->Enabled  =  true;  // �������� ������ "����.����"
      if ( Track == MediaPlayer->Tracks)
          Button3->Enabled  =  false; // ������ "����.����" ����������
    }

    // ����� ���������� � ��������������� �����
    min  =  MCI_TMSF_MINUTE(MediaPlayer->Position);
    sec  =  MCI_TMSF_SECOND(MediaPlayer->Position);
    st.printf("%d:%.2d",min,sec);
    Label2->Caption = st;
    return;
  }

  // ���� �������� ������ ��� � ��� ���
  // AudioCD, �� Mode == mpOpen.
  // ���� ����, �.�. �� ��� ��� ���� �� ����� Mode == mpStopped + ���-�� ������ > 1
  if ( (MediaPlayer->Mode == mpStopped) &&
     (MediaPlayer->Tracks > 1) )
  {
    // ���� ��������
    Timer->Enabled  =  false;
    Button1->Caption = PLAY;
    Button1->Enabled  =  true;
    Button1->Tag = 0;
    MediaPlayer->Notify  =  true;

    // �������� ���������� � ������� �������� CD
    MediaPlayer->TimeFormat = tfMilliseconds;

    int ms = MediaPlayer->Length;
    AnsiString st = "Audio CD. ����� ��������: ";

    st = st +  IntToStr(MINUTE(ms));
    st = st + ":" + IntToStr(SECOND(ms));
    Label1->Caption  =  st;

    MediaPlayer->TimeFormat = tfTMSF;
    Label1->Visible  =  true;
    Track = 0;
    return;
  }

  // �������� ������ ��� � ��������� �� Audio CD
  if (( MediaPlayer->Mode == mpOpen )||
      (MediaPlayer->Mode == mpStopped) && (MediaPlayer->Tracks == 1))
  {
    Label1->Caption  =  "�������� Audio CD";
    if ( Label1->Visible )
          Label1->Visible  =  false;
    else  Label1->Visible  =  true;
  }
}

// ������ �� ������ "��������� ����"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  MediaPlayer->Next();
  // ���� ������� � ���������� �����, �� ������
  // Next ������� �����������
  if ( MCI_TMSF_TRACK(MediaPlayer->Position) == MediaPlayer->Tracks )
    Button3->Enabled  =  false;
  if (! Button2->Enabled ) Button2->Enabled = true;
  TrackInfo();
  Label2->Caption = "0:00";
}

// ������ �� ������ "���������� ����"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    MediaPlayer->Previous(); // � ������ �������� �����
    MediaPlayer->Previous(); // � ������ ����������� ����
    if ( MCI_TMSF_TRACK(MediaPlayer->Position) == 1 )
      Button2->Enabled  =  false;
    if ( ! Button3->Enabled )
      Button3->Enabled  =  true;
    TrackInfo();
    Label2->Caption = "0:00";
}

// ������������ ������ ���� ���������
void __fastcall TForm1::FormClose(TObject *Sender, TCloseAction &Action)
{
    MediaPlayer->Stop();
    MediaPlayer->Close();
}

