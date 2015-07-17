//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "UnitSharik.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
int x,y;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::FormCreate(TObject *Sender)
{
  Timer1->Interval=10;
  Timer1->Enabled=true;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  Form1->Color=clBlack;
  Canvas->Pen->Color=Form1->Color;
  Canvas->Brush->Color=Form1->Color;
  Canvas->Ellipse(x-10,y-10,x+10,y+10);
  x+=5;
  y+=5;
  if (x>ClientWidth)
    x=0;
  if (y>ClientHeight)
    y=0;
  Direction1(x, y);
}
//---------------------------------------------------------------------------
//движеник шарика сверху направо
TForm1::Direction1(int x, int y)
{

  Canvas->Pen->Color=clBlue;
  Canvas->Brush->Color=clBlue;
  Canvas->Ellipse(x-10,y-10,x+10,y+10);
}
