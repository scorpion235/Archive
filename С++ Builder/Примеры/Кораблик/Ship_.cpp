/*
   Простая мультипликация ( изображение формируется
   из графических примитивов).
   Демонстрируе:
    - использование методов, обеспечивающих вычерчивание
      графических примитивов;
    - использование компонента Timer и обработку события OnTimer.
*/

#include <vcl.h>
#pragma hdrstop

#include "Ship_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;
int x = -68, y = 50; // начальное положение базовой точки

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}


// рисует на поверхности формы кораблик
void __fastcall TForm1::Ship(int x, int y)
{
  int dx=4,dy=4; // шаг сетки
  // корпус и надстройку будем рисовать
  // при помощи метода Polygon
  TPoint p1[7];  // координаты точек корпуса
  TPoint p2[8];  // координаты точек надстройки

  TColor pc,bc; // текущий цвет карандаша и кисти

  // сохраним текущий цвет карандаша и кисти
  pc = Canvas->Pen->Color;
  bc = Canvas->Brush->Color;

  // установим нужный цвет карандаша и кисти
  Canvas->Pen->Color = clBlack;
  Canvas->Brush->Color = clWhite;

  // рисуем ..
  // корпус
  p1[0].x = x;       p1[0].y = y;
  p1[1].x = x;       p1[1].y = y-2*dy;
  p1[2].x = x+10*dx; p1[2].y = y-2*dy;
  p1[3].x = x+11*dx; p1[3].y = y-3*dy;
  p1[4].x = x+17*dx; p1[4].y =y-3*dy;
  p1[5].x = x+14*dx; p1[5].y =y;
  p1[6].x = x;       p1[6].y =y;
  Canvas->Polygon(p1,6);

  // надстройка
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

  // капитанский мостик
  Canvas->Rectangle(x+8*dx,y-4*dy,x+11*dx,y-5*dy);

  // труба
  Canvas->Rectangle(x+7*dx,y-4*dy,x+8*dx,y-7*dy);

  // иллюминаторы
  Canvas->Ellipse(x+11*dx,y-2*dy,x+12*dx,y-1*dy);
  Canvas->Ellipse(x+13*dx,y-2*dy,x+14*dx,y-1*dy);

  // мачта
  Canvas->MoveTo(x+10*dx,y-5*dy);
  Canvas->LineTo(x+10*dx,y-10*dy);

  // оснастка
  Canvas->Pen->Color = clWhite;
  Canvas->MoveTo(x+17*dx,y-3*dy);
  Canvas->LineTo(x+10*dx,y-10*dy);
  Canvas->LineTo(x,y-2*dy);


  // восстановим цвет карандаша и кисти
  Canvas->Pen->Color = pc;
  Canvas->Brush->Color = bc;
}

// обработка события OnTimer
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    // стереть кораблик - закрасить цветом, совпадающим
    // с цветом фона (формы)
    Canvas->Brush->Color = Form1->Color;
    Canvas->FillRect(Rect(x-1,y+1,x+68,y-40));

    // вычислить координаты базовой точки
    x+=3;
    if (x > ClientWidth) {
        // кораблик уплыл за правую границу формы
        x= -70; // чтобы кораблик "выплывал" из-за левой границы формы
        y=random(Form1->ClientHeight);
    }
    // нарисовать кораблик на новом месте
    Ship(x,y);
}


// обработка события OnCreate для формы
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    /* Таймер можно настроить во время разработки программы
       (в процессе создания формы) или во время работы программы. */

    // настройка и запуск таймера
    Timer1->Interval = 100; // период возникновения события OnTimer - 0.1 сек.
    Timer1->Enabled = true; // пуск таймера
}

