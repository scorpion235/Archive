/*
    —троит график функции.
    ƒемонстрирует:
       - использование методов Line, MoveTo, TextOutA;
       - обработку событи€ OnFormResize
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

// пользователь изменил размер окна
void __fastcall TForm1::FormResize(TObject *Sender)
{
    TRect rct = Rect(0,0,ClientWidth,ClientHeight);

    Canvas->FillRect(rct);
    Grafik();
}


#include "math.h" // дл€ доступа к sin и exp

// функци€, график которой надо построить
float f( float x)
{
   return 2*sin(x)*exp(x/5);
}

void TForm1::Grafik()
{
 float x1, x2;   // границы изменени€ аргумента функции
 float y1, y2;   // границы изменени€ значени€ функции
 float x;        // аргумент функции
 float y;        // значение функции в точке x
 float dx;       // приращение аргумента
 int l,b;        // левый нижний угол области вывода графика
 int w, h;       // ширина и высота области вывода графика
 float mx, my;   // масштаб по ос€м X и Y
 int x0, y0;     // начало координат

 // область вывода графика
 l = 10;                      // X - координата левого верхнего угла
 b = Form1->ClientHeight-20;  // Y - координата левого нижнего угла
 h = Form1->ClientHeight-40;  // высота
 w = Form1->Width - 20;       // ширина


 x1 = 0;     // нижн€€ граница диапазона аргумента
 x2 = 25;    // верхн€€ граница диапазона аргумента
 dx = 0.01;  // шаг аргумента

 // найдем максимальное и минимальное значение
 // функции на отрезке [x1,x2]
 x = x1;
 y1 = f(x); // минимум
 y2 = f(x); // максимум
 do {
   y =  f(x);
   if ( y < y1 ) y1 = y;
   if ( y > y2 ) y2 = y;
   x += dx;
 } while (x <= x2);

 // вычислим масштаб
 my = (float)h/abs(y2-y1);  // масштаб по оси Y
 mx = w/abs(x2-x1);         // масштаб по оси X

 // оси
 x0 = l+abs(x1*mx);
 y0 = b-abs(y1*my);
 Canvas->MoveTo(x0,b);Canvas->LineTo(x0,b-h);
 Canvas->MoveTo(l,y0);Canvas->LineTo(l+w,y0);
 Canvas->TextOutA(x0+5,b-h,FloatToStrF(y2,ffGeneral,6,3));
 Canvas->TextOutA(x0+5,b,FloatToStrF(y1,ffGeneral,6,3));

 // построение графика
 x = x1;
 do {
     y = f(x);
     Canvas->Pixels[x0+x*mx][y0-y*my] = clRed;
     x += dx;
 } while (x <= x2);
}
