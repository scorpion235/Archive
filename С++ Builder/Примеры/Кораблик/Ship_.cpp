/*
   ������� �������������� ( ����������� �����������
   �� ����������� ����������).
   ������������:
    - ������������� �������, �������������� ������������
      ����������� ����������;
    - ������������� ���������� Timer � ��������� ������� OnTimer.
*/

#include <vcl.h>
#pragma hdrstop

#include "Ship_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;
int x = -68, y = 50; // ��������� ��������� ������� �����

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}


// ������ �� ����������� ����� ��������
void __fastcall TForm1::Ship(int x, int y)
{
  int dx=4,dy=4; // ��� �����
  // ������ � ���������� ����� ��������
  // ��� ������ ������ Polygon
  TPoint p1[7];  // ���������� ����� �������
  TPoint p2[8];  // ���������� ����� ����������

  TColor pc,bc; // ������� ���� ��������� � �����

  // �������� ������� ���� ��������� � �����
  pc = Canvas->Pen->Color;
  bc = Canvas->Brush->Color;

  // ��������� ������ ���� ��������� � �����
  Canvas->Pen->Color = clBlack;
  Canvas->Brush->Color = clWhite;

  // ������ ..
  // ������
  p1[0].x = x;       p1[0].y = y;
  p1[1].x = x;       p1[1].y = y-2*dy;
  p1[2].x = x+10*dx; p1[2].y = y-2*dy;
  p1[3].x = x+11*dx; p1[3].y = y-3*dy;
  p1[4].x = x+17*dx; p1[4].y =y-3*dy;
  p1[5].x = x+14*dx; p1[5].y =y;
  p1[6].x = x;       p1[6].y =y;
  Canvas->Polygon(p1,6);

  // ����������
  p2[0].x = x+3*dx;   p2[0].y = y-2*dy;
  p2[1].x = x+4*dx;   p2[1].y = y-3*dy;
  p2[2].x = x+4*dx;   p2[2].y = y-4*dy;
  p2[3].x = x+13*dx;  p2[3].y = y-4*dy;
  p2[4].x = x+13*dx;  p2[4].y = y-3*dy;
  p2[5].x = x+11*dx;  p2[5].y = y-3*dy;
  p2[6].x = x+10*dx;  p2[6].y = y-2*dy;
  p2[7].x = x+3*dx;   p2[7].y = y-2*dy;
  Canvas->Polygon(p2,7);

  Canvas->MoveTo(x+5*dx,y-3*dy);
  Canvas->LineTo(x+9*dx,y-3*dy);

  // ����������� ������
  Canvas->Rectangle(x+8*dx,y-4*dy,x+11*dx,y-5*dy);

  // �����
  Canvas->Rectangle(x+7*dx,y-4*dy,x+8*dx,y-7*dy);

  // ������������
  Canvas->Ellipse(x+11*dx,y-2*dy,x+12*dx,y-1*dy);
  Canvas->Ellipse(x+13*dx,y-2*dy,x+14*dx,y-1*dy);

  // �����
  Canvas->MoveTo(x+10*dx,y-5*dy);
  Canvas->LineTo(x+10*dx,y-10*dy);

  // ��������
  Canvas->Pen->Color = clWhite;
  Canvas->MoveTo(x+17*dx,y-3*dy);
  Canvas->LineTo(x+10*dx,y-10*dy);
  Canvas->LineTo(x,y-2*dy);


  // ����������� ���� ��������� � �����
  Canvas->Pen->Color = pc;
  Canvas->Brush->Color = bc;
}

// ��������� ������� OnTimer
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    // ������� �������� - ��������� ������, �����������
    // � ������ ���� (�����)
    Canvas->Brush->Color = Form1->Color;
    Canvas->FillRect(Rect(x-1,y+1,x+68,y-40));

    // ��������� ���������� ������� �����
    x+=3;
    if (x > ClientWidth) {
        // �������� ����� �� ������ ������� �����
        x= -70; // ����� �������� "��������" ��-�� ����� ������� �����
        y=random(Form1->ClientHeight);
    }
    // ���������� �������� �� ����� �����
    Ship(x,y);
}


// ��������� ������� OnCreate ��� �����
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    /* ������ ����� ��������� �� ����� ���������� ���������
       (� �������� �������� �����) ��� �� ����� ������ ���������. */

    // ��������� � ������ �������
    Timer1->Interval = 100; // ������ ������������� ������� OnTimer - 0.1 ���.
    Timer1->Enabled = true; // ���� �������
}

