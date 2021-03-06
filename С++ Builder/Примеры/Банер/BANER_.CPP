/*
    ������� �� ����������� ����� ������� ������� (�����),
    ����� ��� �������� ��������� � ����� bmp-�����.
    ������������� ������������� ������ CopyRect.

*/

#include <vcl.h>
#pragma hdrstop

#include "baner_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

#define FBANER "borland.bmp" // �����
#define NKADR  4 // ���������� ������ � ������


void __fastcall TForm1::FormCreate(TObject *Sender)
{
    baner = new Graphics::TBitmap();
    baner->LoadFromFile(FBANER);     // ��������� �����

    h = baner->Height;
    w = baner->Width / NKADR;

    scr = Rect(10,10,10+w,10+h); // ��������� � ������ ������� ��������������� ������
    kadr = Rect(0,0,w,h);        // ��������� � ������ ������� ����� � ������
}

// ��������� ������� OnTimer
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    // ������� ���� ������
    Canvas->CopyRect(scr,baner->Canvas,kadr);

    // ������������ � ��������������� ���������� �����
    if (c < NKADR)
    {
        // ��������������� � ������ ������
        // ���� �� ���������
        c++;
        kadr.Left += w;
        kadr.Right += w;
    }
    else
    {
        c = 0;
        kadr.Left = 0;
        kadr.Right = w;
    }
}


