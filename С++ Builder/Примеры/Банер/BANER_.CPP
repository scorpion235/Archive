/*
    Выводит на поверхность формы простой мультик (банер),
    кадры все которого находятся в одном bmp-файле.
    Демонстрирует использование метода CopyRect.

*/

#include <vcl.h>
#pragma hdrstop

#include "baner_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

#define FBANER "borland.bmp" // банер
#define NKADR  4 // количество кадров в банере


void __fastcall TForm1::FormCreate(TObject *Sender)
{
    baner = new Graphics::TBitmap();
    baner->LoadFromFile(FBANER);     // загрузить банер

    h = baner->Height;
    w = baner->Width / NKADR;

    scr = Rect(10,10,10+w,10+h); // положение и размер области воспроизведения банера
    kadr = Rect(0,0,w,h);        // положение и размер первого кадра в банере
}

// обработка события OnTimer
void __fastcall TForm1::Timer1Timer(TObject *Sender)
{
    // вывести кадр банера
    Canvas->CopyRect(scr,baner->Canvas,kadr);

    // подготовится к воспроизведению следующего кадра
    if (c < NKADR)
    {
        // воспроизводимый в данный момент
        // кадр не последний
        c++;
        kadr.Left += w;
        kadr.Right += w;
    }
    else
    {
        c = 0;
        kadr.Left = 0;
        kadr.Right = w;
    }
}


