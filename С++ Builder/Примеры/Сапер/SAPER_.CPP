/*
    Игра "Сапер". Демонстрирует работу с графикой,
    использование рекурсии, доступ к файлу справочной
    информации.
*/
#include <vcl.h>
#include <stdlib.h>  // для доступа к ГСЧ
#include <time.h>
#include <stdio.h>

#pragma hdrstop

#include "saper_.h"
#include "saper_2.cpp"

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1; // главное окно

__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}

#define MR 10 // кол-во клеток по вертикали
#define MC 10 // кол-во клеток по горизонтали
#define NM 10 // кол-во мин

int Pole[MR+2][MC+2]; // минное поле
                      // 0..8 - количество мин в соседних клетках
                      // 9 - в клетке мина
                      // 100..109 - клетка открыта
                      // 200..209 - в клетку поставлен флаг

int nMin;   // кол-во найденных мин
int nFlag;  // кол-во поставленных флагов

int status = 0; // 0 - начало игры; 1- игра; 2 -результат

// смещение игрового поля относительно левого верхнего угла
// поверхности формы
#define LEFT 0   // по X
#define TOP  1   // по Y 

#define W    40  // ширина клетки поля
#define H    40  // высота клетки поля

void __fastcall NewGame(); // новая игра - "разбрасывает" мины
void __fastcall Open(int row, int col); /* открывает текущую и соседние
                                           пустые клетки */

// нажатие кнопки мыши на игровом поле
void __fastcall TForm1::FormMouseDown(TObject *Sender, TMouseButton Button,
      TShiftState Shift, int x, int y)
{
     if ( status == 2 ) return;

     if ( status == 0) status = 1;

     x -= LEFT;
     y -= TOP;
     if (x > 0 && y > 0)
     {
         // преобразуем координаты мыши в индексы
         // клетки поля
         int row = y/H + 1;
         int col = x/W + 1;

         if (Button == mbLeft)
         {
            if ( Pole[row][col] == 9 )
            {
               Pole[row][col] +=100;
               status = 2;  // игра закончена
               ShowPole(status);
            }
            else if  ( Pole[row][col] < 9 )
                 {
                    Open(row,col);
                    ShowPole(status);
                  }
          }
          else if (Button == mbRight)
               {
                 nFlag++;
                 if ( Pole[row][col] == 9 )
                    nMin++;
                 Pole[row][col] += 200;  // поставили флаг
                 if (nMin == NM && nFlag == NM)
                 {
                   status = 2;  // игра закончена
                   ShowPole(status);
                 }
                 else Kletka(row, col, status);
               }
     }
}

// Функция обработки события OnCreate обычно используется
// для инициализации глобальных переменных
void __fastcall TForm1::FormCreate(TObject *Sender)
{
   // В неотображаемые эл-ты массива, которые соответствуют
   // клеткам по границе игрового поля, запишем число -3.
   // Это значение используется функцией Open для завершения
   // рекурсивного процесса открытия соседних пустых клеток.
   for ( int row=0; row <= MR+1; row++)
        for ( int col=0; col <= MC+1; col++)
	   Pole[row][col] = -3;

   NewGame();  // "разбросать" мины
   Form1->ClientWidth = W*MC;
   Form1->ClientHeight = H*MR+TOP+1;
}

// Вывод поля как результат обработки события Paint
// позволяет проводить любые манипуляции с формой во время работы программы
void __fastcall TForm1::FormPaint(TObject *Sender)
{
        ShowPole(status);
}

// Показывает поле
void __fastcall TForm1::ShowPole( int status)
{
    for ( int row = 1; row <= MR; row++ )
         for ( int col = 1; col <= MC; col++ )
              Kletka(row, col, status);
}

// рисует на экране клетку
void __fastcall TForm1::Kletka(int row, int col, int status)
{
     int x = LEFT + (col-1)* W;
     int y = TOP + (row-1)* H;

     if (status == 0) // начало игры
     {
        // клетка - серый квадрат
        Canvas->Brush->Color = clLtGray;
        Canvas->Rectangle(x-1,y-1,x+W,y+H);
        return;
     }

    // во время (status = 1) и в конце (status = 2) игры
    if ( Pole[row][col] < 100 )
    {
         // клетка не открыта
         Canvas->Brush->Color = clLtGray;  // не открытые - серые
         Canvas->Rectangle(x-1,y-1,x+W,y+H);
         if (status == 2 && Pole[row][col] == 9)
             Mina( x, y); // игра закончена, показать мину
         return;
    }

    // клетка открыта
    Canvas->Brush->Color = clWhite;      // открытые белые
    Canvas->Rectangle(x-1,y-1,x+W,y+H);
    if  ( Pole[row][col] == 100 ) // клетка открыта, но она пустая
         return;

    if ( Pole[row][col] >= 101 && Pole[row][col] <= 108 )
    {
             Canvas->Font->Size = 14;
             Canvas->Font->Color = clBlue;
             Canvas->TextOutA(x+3,y+2,IntToStr(Pole[row][col] -100 ));
             return;
    }

    if ( Pole[row][col] >= 200 )
         Flag(x, y);

    if (Pole[row][col] == 109 ) // на этой мине подорвались!
    {
         Canvas->Brush->Color = clRed;
         Canvas->Rectangle(x,y,x+W,y+H);
    }
    if (( Pole[row][col] % 10 == 9)  &&  (status == 2))
               Mina( x, y);
}


// рекурсивная функция открывает текущую и все соседние
// клетки, в которых нет мин
void __fastcall Open(int row, int col)
{
	if (Pole[row][col] == 0)
	{
        Pole[row][col] = 100;
        // открываем клетки слева, справа, снизу и сверху
	    Open(row,col-1);
	    Open(row-1,col);
	    Open(row,col+1);
	    Open(row+1,col);
        // открываем примыкающие диагонально
        Open(row-1,col-1);
        Open(row-1,col+1);
        Open(row+1,col-1);
        Open(row+1,col+1);
	}

	else
          // -3 это граница игрового поля
          if (Pole[row][col] < 100 && Pole[row][col] != -3)
                 Pole[row][col] += 100;
}

// новая игра - генерирует новое поле
void __fastcall NewGame()
{
   // Очистим эл-ты массива, соответствующие отображаемым
   // клеткам, а в неотображаемые (по границе игрового поля)
   // запишем число -3. Уникальное значение клеток границы
   // используется функцией Open для завершения рекурсивного
   // процесса открытия соседних пустых клеток.
   int row,col;
   for (row=0; row <= MR+1; row++)
        for (col=0; col <= MC+1; col++)
	        Pole[row][col] = -3;
   for (row=1; row <= MR; row++)
        for (col=1; col <= MC; col++)
	        Pole[row][col] = 0;

   // расставим мины
   time_t t;    // используется ГСЧ
   srand((unsigned) time(&t)); // инициализация ГСЧ
   int n = 0; // кол-во мин
   do
   {
       row = rand() % MR +1;
       col = rand() % MC +1;
       if ( Pole[row][col] != 9)
       {
           Pole[row][col] = 9;
	   n++;
       }
   }
   while ( n < 10);

   // вычисление кол-ва мин в соседних клетках
   int k;
   for ( row = 1; row <= MR; row++)
   	for ( col = 1; col <= MC; col++)
	   if ( Pole[row][col] != 9 ) {
        k =0;
		if ( Pole[row-1][col-1] == 9 ) k++;
		if ( Pole[row-1][col]   == 9 ) k++;
		if ( Pole[row-1][col+1] == 9 ) k++;
		if ( Pole[row][col-1]   == 9 ) k++;
		if ( Pole[row][col+1]   == 9 ) k++;
		if ( Pole[row+1][col-1] == 9 ) k++;
		if ( Pole[row+1][col]   == 9 ) k++;
		if ( Pole[row+1][col+1] == 9 ) k++;
		Pole[row][col] = k;
	   }
   status = 0; // начало игры
   nMin = 0;   // нет обнаруженных мин
   nFlag = 0;  // нет флагов
}

// рисует мину
void __fastcall TForm1::Mina(int x, int y)
{
    Canvas->Brush->Color = clGreen;
    Canvas->Pen->Color = clBlack;
    Canvas->Rectangle(x+16,y+26,x+24,y+30);

    // корпус
    Canvas->Rectangle(x+8,y+30,x+32,y+34);
    Canvas->Pie(x+6,y+28,x+34,y+44,x+34,y+36,x+6,y+36);

    // полоса на корпусе
    Canvas->MoveTo(x+12,y+32); Canvas->LineTo(x+28,y+32);
    
    // основание
    Canvas->MoveTo(x+8,y+36);  Canvas->LineTo(x+32,y+36);

    // вертикальный "ус"
    Canvas->MoveTo(x+20,y+22); Canvas->LineTo(x+20,y+26);
    
    // боковые "усы"
    Canvas->MoveTo(x+8, y+30); Canvas->LineTo(x+6,y+28);
    Canvas->MoveTo(x+32,y+30); Canvas->LineTo(x+34,y+28);
}

// Рисует флаг
void __fastcall TForm1::Flag( int x, int y)
{
    TPoint p[4]; // координаты флажка и нижней точки древка

    // точки флажка
    p[0].x=x+4;   p[0].y=y+4;
    p[1].x=x+30;  p[1].y=y+12;
    p[2].x=x+4;   p[2].y=y+20;

    // установим цвет кисти и карандаша
    Canvas->Brush->Color = clRed;
    Canvas->Pen->Color = clRed; // чтобы контур флажка был красный

    Canvas->Polygon(p, 2);  // флажок

    // древко
    Canvas->Pen->Color = clBlack;
    Canvas->MoveTo(p[0].x, p[0].y);
    Canvas->LineTo(x+4,y+36);

    TPoint m[5];     // буква М

    m[0].x=x+8; m[0].y=y+14;
    m[1].x=x+8; m[1].y=y+8;
    m[2].x=x+10; m[2].y=y+10;
    m[3].x=x+12; m[3].y=y+8;
    m[4].x=x+12; m[4].y=y+14;
    Canvas->Pen->Color = clWhite;
    Canvas->Polyline(m,4);
    Canvas->Pen->Color = clBlack;
}

// команда главного меню Новая игра
void __fastcall TForm1::N1Click(TObject *Sender)
{
        NewGame();
        ShowPole(status);
}

// выбор в меню "?" команды О программе
void __fastcall TForm1::N4Click(TObject *Sender)
{
    AboutForm->Top = Form1->Top + Form1->Height/2
                           - AboutForm->Height/2;
    AboutForm->Left = Form1->Left + Form1->Width/2
                           - AboutForm->Width/2;
    AboutForm->ShowModal();
}

// выбор в меню "?" команды Справка
void __fastcall TForm1::N3Click(TObject *Sender)
{
    WinHelp(Form1->Handle,"saper.hlp",HELP_CONTEXT,1);
}

