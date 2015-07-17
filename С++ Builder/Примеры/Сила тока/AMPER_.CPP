/*
   Программа вычисляет силу тока в электрической цепи.
   Демонстрирует обработку события Click,
   ввод из поля редактирования, вывод в поле метки,
   использование StrToFloat и FloatToStrF
*/
#include <vcl.h>
#pragma hdrstop

#include "amper_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::Button1Click(TObject *Sender)
{
    float u; // напряжение
    float r; // сопротивление
    float i; // ток

    // получить данные из полей ввода
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);

    // вычислить ток
    i = u/r;

    // вывести результат в поле метки
    Label4->Caption = "Ток : " +
         FloatToStrF(i,ffGeneral,7,3);

}






