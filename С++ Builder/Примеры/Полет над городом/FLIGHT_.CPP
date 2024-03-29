/*
   ��������������, �������� ������� �����������
   �� bmp-�����.

   �������������:
     - ����� �� ����������� ����� �����������,
       ����������� �� �����.
*/

#include <vcl.h>
#pragma hdrstop

#include "flight_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    // ��������� ������� ������� �� bmp �����
    back = new Graphics::TBitmap();
    back->LoadFromFile("factory.bmp");

    // ���������� ������ ���������� (�������) ������� �����
    // � ������������ � �������� �������� �������
    ClientWidth = back->Width;
    ClientHeight = back->Height;

    // ��������� ��������
    sprite =  new Graphics::TBitmap();
    sprite->LoadFromFile("aplane.bmp");
    sprite->Transparent = true;


    // �������� ��������� ��������
    x=-20; // ����� ������� "�������" ��-�� ����� ������� ����
    y=20;
}

void __fastcall TForm1::FormPaint(TObject *Sender)
{
    Canvas->Draw(0,0,back);    // ���
    Canvas->Draw(x,y,sprite);  // �������
}

void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    TRect badRect; // ��������� � ������ ������� ����,
                   // ������� ���� ������������

    badRect = Rect(x,y,x+sprite->Width,y+sprite->Height);

    // ������� ������� (������������ "�����������" ���)
    Canvas->CopyRect(badRect,back->Canvas,badRect);

    // �������� ����� ���������� �������
    x +=2;
    if (x > ClientWidth)
    {
        // ������� ������ �� ������ ������� �����
        // ������� ������ � �������� ������
        x = -20;
        y = random(ClientHeight - 30);  // ������ ������
        // �������� ������ ������������ �������� �������������
        // ������� OnTimer, �������, � ���� �������, �������
        // �� �������� �������� Interval
        Timer1->Interval = random(20) + 10; // �������� "������" �� 10 �� 29
    }
    Canvas->Draw(x,y,sprite);

}

