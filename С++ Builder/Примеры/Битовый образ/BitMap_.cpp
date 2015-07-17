/*
    ��������� �������� �� ������� �������, ����������� �� �����.
    �������������:
    - �������� � ����� ������� �������;
    - ������� �������� Transparent.
*/

#include <vcl.h>
#pragma hdrstop

#include "BitMap_.h"
#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::FormPaint(TObject *Sender)
{
    // ������� ������: ���� � �������
    Graphics::TBitmap *sky = new Graphics::TBitmap();
    Graphics::TBitmap *plane = new Graphics::TBitmap();

    // ��������� ������� ������
    sky->LoadFromFile("sky.bmp");
    plane->LoadFromFile("plane.bmp");

    Canvas->Draw(0,0,sky);     // ��� - ����

    Canvas->Draw(20,20,plane); // ����� �������

    plane->Transparent = true;
    /* ������ �������� �������, ���� ������� ���������
       � ������ ����� ������ ����� �������� ������,
       �� �������������� */
    Canvas->Draw(120,20,plane); // ������ �������

    // ���������� �������
    sky->Graphics::~TBitmap();
    plane->Graphics::~TBitmap();
}


