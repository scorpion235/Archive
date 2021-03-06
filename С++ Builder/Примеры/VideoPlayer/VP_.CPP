/*
   ������� ����������. ������������� �������������:
     - ���������� MediaPlayer ��� ��������������� ���������
       ����� ������� (������ AVI);
     - ���������� SpeedButton.

   ���������. ���� ���� ���������, ����� ��������������� ����� ���������,
   ��������� ������ �����, �� ���� ����� ��������. ����� ����� �� ����,
   ���� �������� ������� ��������� ������� OnPaint ��� ����� ��� ������������
   � �������� ������ �������� Panel ��� Image. � ��������� ������ ����
   ��������������� ������� ���������� �������� �������� MediaPlayer->Display .
*/

#include <vcl.h>
#pragma hdrstop

#include "vp_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;


__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

// ��������� ������� Create
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    MediaPlayer1->Display = Form1; // ����������� ������ �� ����������� �����
}

// ���������� ������ ����� AVI �����
void __fastcall GetFrameSize(AnsiString f, int *w, int *h)
{
    // � ��������� AVI ����� ���� ���������� � ������� �����
    struct  {
        char     RIFF[4]; // ������ RIFF
        long int nu_1[5]; // �� ������������
        char     AVIH[4]; // ������ AVIH
        long int nu_2[9]; // �� ������������
        long int w;       // ������ �����
        long int h;       // ������ �����
    } header;

    TFileStream *fs;   // �����, ��� ������ ��������� �����

    /* ��������� ���������� ������ � ��� ��������
    ����� ����������: TFileStream *fs = new TFileStream(f,fmOpenRead); */

    fs = new TFileStream(f,fmOpenRead);   // ������� ����� ��� ������
    fs->Read(&header, sizeof(header));    // ��������� ��������� �����
    *w = header.w;
    *h = header.h;
    delete fs;
}

// ������ �� ������ Eject (����� ����� �����)
void __fastcall TForm1::SpeedButton1Click(TObject *Sender)
{
    OpenDialog1->Title = "����� �����";
    OpenDialog1->InitialDir = "";
    OpenDialog1->FileName = "*.avi";
    if ( ! OpenDialog1->Execute() )
        return; // ������������ ����� ������ ������

     /* ��� ������� ������� ���� �����, ������� ��� ������,
       ��������� ������. */
    if ( MediaPlayer1->FileName == OpenDialog1->FileName )
        return;

    /* ������������ ������ ����. ������� ������ � ��������� "������",
       �� ������� ����� ������� ����. ��� ����� ���� ����� ������
       ������ �����. */

    int fw, fh;   // ������ ����� �����
    int top,left; // ����� ������� ���� ������
    int sw, sh;   // ������ ������ (������, ������)

    int mw, mh;   // ����������� ��������� ������ ������
                  // (������������ ������� �������� �����)

    float kw, kh; // ����-�� ��������������� ����� �� ������ � ������
    float k;      // ����������� ��������������� �����

    GetFrameSize(OpenDialog1->FileName,&fw, &fh);// �������� ������ �����

    // �������� ����������� ��������� ������ �����
    mw = Form1->ClientWidth;
    mh = Form1->SpeedButton1->Top-10;

    if ( fw < mw)
       kw = 1; // ���� �� ������ ������ ������� ������
    else kw = (float) mw / fw;

    if ( fh < mh)
       kh = 1; // ���� �� ������ ������ ������� ������
    else kh = (float) mh / fh;

    // ��������������� ������ ���� ����������������
    if ( kw < kh)
        k = kw;
    else k = kh;

   // ����� ������� ���������
   sw = fw * k; // ������ ������
   sh = fh * k; // ������ ������

   left = (Form1->ClientWidth - sw) / 2;
   top = (SpeedButton1->Top - sh) / 2;

   MediaPlayer1->FileName = OpenDialog1->FileName;
   MediaPlayer1->Open();
   MediaPlayer1->DisplayRect = Rect(left,top,sw,sh);

   SpeedButton2->Enabled = True; // ������ Play ������ ��������

    /* ���� ������ ����� ���������� ����� ������ �������
       ����� ����������� �����, �� ����� (������� �����)
       ���� �������� */

    Form1->Canvas->FillRect(Rect(0,0,ClientWidth,SpeedButton1->Top));

   // ������������ ������� ���������������
   MediaPlayer1->Play();
   SpeedButton2->Down = True;
   SpeedButton2->Hint = "Stop";
   SpeedButton1->Enabled = False;
}

// ������ �� ������ Play/Stop (���������������/����)
void __fastcall TForm1::SpeedButton2Click(TObject *Sender)
{
    if (SpeedButton2->Down)
    {
        // ������ ������ Play
        MediaPlayer1->Play();
        SpeedButton2->Hint = "Stop";
        SpeedButton1->Enabled = False; // ������ Eject ����������
    }
    else
    {
        // ������ ������ Stop
        MediaPlayer1->Stop();
        SpeedButton2->Hint = "Play";
        SpeedButton1->Enabled = True; // ������ Eject ��������
    }
}

// ������ �� ������
void __fastcall TForm1::MediaPlayer1Notify(TObject *Sender)
{
    if ( ( MediaPlayer1->Mode == mpStopped ) && ( SpeedButton2->Down))
    {
        SpeedButton2->Down = False;   // "������" ������ Play
        SpeedButton2->Hint = "Play";
        SpeedButton1->Enabled = True; // ������� ��������� ������ Eject
    }
}

