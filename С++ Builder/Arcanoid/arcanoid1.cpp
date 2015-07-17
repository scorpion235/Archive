/***********************************
* arcanoid1.cpp                    *
* Игра арканоид                    *
************************************
* Насыпов А.А. MK-101              *
* 9.07.2004                        *
* C++Builder version 6.0           *
***********************************/
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include <stdio.h>

#include "arcanoid1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
int a,n,m,d,f,gameover;
struct koor
{
 int e;
 int r;
} mas[12][7];
//---------------------------------------------------------------------------
//Старт игры и отрисовка начального положения кубиков, каретки, шарика
void __fastcall TForm1::Button1Click(TObject *Sender)
{
 gameover = 84 ;
 x = 80 ;
 Canvas->Pen->Color = clRed;
 Canvas->Brush->Color = clBlack;
 Canvas->Rectangle(0,0,635,480);
 Canvas->Brush->Color = clYellow;
 Canvas->Pen->Color = clBlack;
 for (int i = 0; i < 12 ; i++)
 {
  y=40;
  for (int j = 0; j < 7 ; j++)
  {
   Canvas->Rectangle(x,y,x+35,y+15);
   mas[i][j].e = x;
   mas[i][j].r = y;
   y = y+20;
  }
  x = x+40;
 }
 int k;
 Canvas->Brush->Color = clBlue ;
 kar(300);
 randomize;
 n = random(5)*10+300;
 m = 400;
 switch (random(2))
 {
  case(0) : f=-1; d=1; break;
  case(1) : f=-1; d=-1; break;
 }
 krug(1);
 Button1 -> Enabled = false;
}
//---------------------------------------------------------------------------
//Рисует каретку
TForm1::kar(int q1)
{
 Canvas->Rectangle(q1,460,q1+40,470);
 a = q1;
}
//---------------------------------------------------------------------------
//Движение каретки влево
TForm1::left()
{
 if(a > 0)
  {
   Canvas->Brush->Color = clBlack ;
   kar(a);
   Canvas->Brush->Color = clBlue ;
   kar(a-20);
  }
}
//---------------------------------------------------------------------------
//Движение каретки вправо
TForm1::right()
{
 if(a < 600)
  {
   Canvas->Brush->Color = clBlack ;
   kar(a);
   Canvas->Brush->Color = clBlue ;
   kar(a+20);
  }
}
//---------------------------------------------------------------------------
//Рисует шарик
TForm1::krug(int col)
{
 switch (col)
  {
    case 0: Canvas->Brush->Color = clBlack; // выбрать цвет заливки
            Canvas->Ellipse(n, m, n+9 ,m+9);// нарисовать эллипс
            break;
    case 1: Canvas->Brush->Color = clGreen; // выбрать цвет заливки
            Canvas->Ellipse(n, m, n+9 ,m+9); // нарисовать эллипс
            break;
  }
}
//--------------------------------------------------------------------------
//Рисует черный прямоугольник
TForm1::cherbar(int w1, int w2)
{
 Canvas->Brush->Color = clBlack ;
 Canvas->Rectangle(w1,w2,w1+35,w2+15);
 gameover = gameover--;
}
//--------------------------------------------------------------------------
//Движение шарика и проверка условий на отражение
TForm1::sdvig()
{
 krug(0);
 n=n+d;
 m=m+f;
 if((n+9>=634)||(n <= 0)) d = -d;
 if(m <= 0) f = -f;
 if((m+9 >= 460)&&(n+4 >= a)&&(n+4 <= a+40)&&(m+9 < 470)) f = -f;
 for(int i=0;i<12;i++)
 {
  for(int j=0;j<7;j++)
  {
   if((m+9>=mas[i][j].r)&&(m+9<mas[i][j].r+15)&&(n+4<=mas[i][j].e+35)&&(n+4>=mas[i][j].e))
   {
    f = -f;
    cherbar(mas[i][j].e,mas[i][j].r);
    mas[i][j].e = 850;
    mas[i][j].r = 700;
   }
   if( (m<=mas[i][j].r+15)&&(m>mas[i][j].r)&&(n+4<=mas[i][j].e+35)&&(n+4>=mas[i][j].e))
   {
    f = -f;
    cherbar(mas[i][j].e,mas[i][j].r);
    mas[i][j].e = 850;
    mas[i][j].r = 700;
   }
   if( (n+9>=mas[i][j].e)&&(n+9<mas[i][j].e+35)&&(m+4<=mas[i][j].r+15)&&(m+4>=mas[i][j].r))
   {
    d = -d;
    cherbar(mas[i][j].e,mas[i][j].r);
    mas[i][j].e = 850;
    mas[i][j].r = 700;
   }
   if( (n>mas[i][j].e)&&(n<=mas[i][j].e+35)&&(m+4<=mas[i][j].r+15)&&(m+4>=mas[i][j].r))
   {
    d = -d;
    cherbar(mas[i][j].e,mas[i][j].r);
    mas[i][j].e = 850;
    mas[i][j].r = 700;
   }
  }
 }
 krug(1);
 if(m+9>479) gameover = 0 ;
}
//--------------------------------------------------------------------------

void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
  sdvig();
  if(gameover == 0 )
  {
   Close();
  }
}
//---------------------------------------------------------------------------
//Считывает клавишу и двигает каретку
void __fastcall TForm1::qwer(TObject *Sender, WORD &Key, TShiftState Shift)
{
 if (Key==VK_RIGHT)
  {
    right();
  }
  if (Key==VK_LEFT)
  {
    left();
  }
}
//---------------------------------------------------------------------------

