/*
    Формирует картинку из битовых образов, загруженных из файла.
    Демонстрирует:
    - загрузку и вывод битовых образов;
    - влияние свойства Transparent.
*/

#include <vcl.h>
#pragma hdrstop

#include "BitMap_.h"
#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::FormPaint(TObject *Sender)
{
    // битовые образы: небо и самолет
    Graphics::TBitmap *sky = new Graphics::TBitmap();
    Graphics::TBitmap *plane = new Graphics::TBitmap();

    // загрузить битовые образы
    sky->LoadFromFile("sky.bmp");
    plane->LoadFromFile("plane.bmp");

    Canvas->Draw(0,0,sky);     // фон - небо

    Canvas->Draw(20,20,plane); // левый самолет

    plane->Transparent = true;
    /* теперь элементы рисунка, цвет которых совпадает
       с цветом левой нижней точки битового образа,
       не отрисовываются */
    Canvas->Draw(120,20,plane); // правый самолет

    // уничтожить объекты
    sky->Graphics::~TBitmap();
    plane->Graphics::~TBitmap();
}


