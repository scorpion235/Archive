/*
    ������ ������ �������.
    �������������:
       - ������������� ������� Line, MoveTo, TextOutA;
       - ��������� ������� OnFormResize
*/

#include <vcl.h>
#pragma hdrstop

#include "grf_.h"


#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::FormPaint(TObject *Sender)
{
    Grafik();
}

// ������������ ������� ������ ����
void __fastcall TForm1::FormResize(TObject *Sender)
{
    TRect rct = Rect(0,0,ClientWidth,ClientHeight);

    Canvas->FillRect(rct);
    Grafik();
}


#include "math.h" // ��� ������� � sin � exp

// �������, ������ ������� ���� ���������
float f( float x)
{
   return 2*sin(x)*exp(x/5);
}

void TForm1::Grafik()
{
 float x1, x2;   // ������� ��������� ��������� �������
 float y1, y2;   // ������� ��������� �������� �������
 float x;        // �������� �������
 float y;        // �������� ������� � ����� x
 float dx;       // ���������� ���������
 int l,b;        // ����� ������ ���� ������� ������ �������
 int w, h;       // ������ � ������ ������� ������ �������
 float mx, my;   // ������� �� ���� X � Y
 int x0, y0;     // ������ ���������

 // ������� ������ �������
 l = 10;                      // X - ���������� ������ �������� ����
 b = Form1->ClientHeight-20;  // Y - ���������� ������ ������� ����
 h = Form1->ClientHeight-40;  // ������
 w = Form1->Width - 20;       // ������


 x1 = 0;     // ������ ������� ��������� ���������
 x2 = 25;    // ������� ������� ��������� ���������
 dx = 0.01;  // ��� ���������

 // ������ ������������ � ����������� ��������
 // ������� �� ������� [x1,x2]
 x = x1;
 y1 = f(x); // �������
 y2 = f(x); // ��������
 do {
   y =  f(x);
   if ( y < y1 ) y1 = y;
   if ( y > y2 ) y2 = y;
   x += dx;
 } while (x <= x2);

 // �������� �������
 my = (float)h/abs(y2-y1);  // ������� �� ��� Y
 mx = w/abs(x2-x1);         // ������� �� ��� X

 // ���
 x0 = l+abs(x1*mx);
 y0 = b-abs(y1*my);
 Canvas->MoveTo(x0,b);Canvas->LineTo(x0,b-h);
 Canvas->MoveTo(l,y0);Canvas->LineTo(l+w,y0);
 Canvas->TextOutA(x0+5,b-h,FloatToStrF(y2,ffGeneral,6,3));
 Canvas->TextOutA(x0+5,b,FloatToStrF(y1,ffGeneral,6,3));

 // ���������� �������
 x = x1;
 do {
     y = f(x);
     Canvas->Pixels[x0+x*mx][y0-y*my] = clRed;
     x += dx;
 } while (x <= x2);
}
