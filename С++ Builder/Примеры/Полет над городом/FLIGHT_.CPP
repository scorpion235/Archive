/*
   Мультипликация, элементы которой загружаются
   из bmp-файла.

   Демонстрирует:
     - вывод на поверхность формы иллюстраций,
       загруженных из файла.
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
    // загрузить фоновый рисунок из bmp файла
    back = new Graphics::TBitmap();
    back->LoadFromFile("factory.bmp");

    // установить размер клиентской (рабочей) области формы
    // в соответствии с размером фонового рисунка
    ClientWidth = back->Width;
    ClientHeight = back->Height;

    // загрузить картинку
    sprite =  new Graphics::TBitmap();
    sprite->LoadFromFile("aplane.bmp");
    sprite->Transparent = true;


    // исходное положение самолета
    x=-20; // чтобы самолет "вылетал" из-за левой границы окна
    y=20;
}

void __fastcall TForm1::FormPaint(TObject *Sender)
{
    Canvas->Draw(0,0,back);    // фон
    Canvas->Draw(x,y,sprite);  // рисунок
}

void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    TRect badRect; // положение и размер области фона,
                   // которую надо восстановить

    badRect = Rect(x,y,x+sprite->Width,y+sprite->Height);

    // стереть самолет (восстановить "испорченный" фон)
    Canvas->CopyRect(badRect,back->Canvas,badRect);

    // вычислим новые координаты спрайта
    x +=2;
    if (x > ClientWidth)
    {
        // самолет улетел за правую границу формы
        // изменим высоту и скорость полета
        x = -20;
        y = random(ClientHeight - 30);  // высота полета
        // скорость полета определяется периодом возникновения
        // события OnTimer, который, в свою очередь, зависит
        // от значения свойства Interval
        Timer1->Interval = random(20) + 10; // скорость "полета" от 10 до 29
    }
    Canvas->Draw(x,y,sprite);

}

