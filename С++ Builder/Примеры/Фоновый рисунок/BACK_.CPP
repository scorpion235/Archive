//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "back_.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}


// обработка события OnCreate
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    back = new Graphics::TBitmap(); // создать объект - битовый образ

     // загрузить картинку
    try // в процессе загрузки картинки возможны ошибки
    {
        Form1->back->LoadFromFile("Legal.bmp");
    }
    catch (EFOpenError &e)
    {
        return;
    }
}


// формирует фоновый рисунок
void __fastcall TForm1::Background()
{
    int x=0,y=0; // координаты левого верхнего угла битового образа

    if ( back->Empty ) // битовый образ не был загружен
        return;

    do {
      do {
        Canvas->Draw(x,y,back);
        x += back->Width;
      }
      while (x < ClientWidth);
      x = 0;
      y += back->Height;
    }
    while (y < ClientHeight);
}

// обработка события OnPaint
void __fastcall TForm1::FormPaint(TObject *Sender)
{
    Background(); // обновить фоновый рисунок
}

// обработка события OnResize
void __fastcall TForm1::FormResize(TObject *Sender)
{
    //Background(); // обновить фоновый рисунок
}
//---------------------------------------------------------------------------
