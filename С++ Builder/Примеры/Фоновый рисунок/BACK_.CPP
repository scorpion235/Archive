//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "back_.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}


// ��������� ������� OnCreate
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    back = new Graphics::TBitmap(); // ������� ������ - ������� �����

     // ��������� ��������
    try // � �������� �������� �������� �������� ������
    {
        Form1->back->LoadFromFile("Legal.bmp");
    }
    catch (EFOpenError &e)
    {
        return;
    }
}


// ��������� ������� �������
void __fastcall TForm1::Background()
{
    int x=0,y=0; // ���������� ������ �������� ���� �������� ������

    if ( back->Empty ) // ������� ����� �� ��� ��������
        return;

    do {
      do {
        Canvas->Draw(x,y,back);
        x += back->Width;
      }
      while (x < ClientWidth);
      x = 0;
      y += back->Height;
    }
    while (y < ClientHeight);
}

// ��������� ������� OnPaint
void __fastcall TForm1::FormPaint(TObject *Sender)
{
    Background(); // �������� ������� �������
}

// ��������� ������� OnResize
void __fastcall TForm1::FormResize(TObject *Sender)
{
    //Background(); // �������� ������� �������
}
//---------------------------------------------------------------------------
