#include <vcl.h>
#pragma hdrstop

#include "Unit2.h"
//------------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm2 *Form2;
//------------------------------------------------------------------------------
__fastcall TForm2::TForm2(TComponent* Owner)
        : TForm(Owner)
{
}
//------------------------------------------------------------------------------
void __fastcall TForm2::FormCreate(TObject *Sender)
{
  Label1->Caption="Программа потроения графиков функций";
  Label2->Caption="Автор: Дюгуров С.М.\nАдрес: www.scorpion235@mail.ru\nДата: 23.06.2005\nСреда разработки: Borland Builder C++ Version 6.0\n\nДопустимые операции: +, -, *, /, ^, sin, cos, tg, ctg,\narcsin, arccos, arctg, arcctg, exp, ln, mod, (, ).";
  Image1->AutoSize=false;
  Image1->Proportional=true;
  Image1->Visible=true;
}
//------------------------------------------------------------------------------
//нажатие кнопки "OK"
void __fastcall TForm2::Button1Click(TObject *Sender)
{
  Form2->Close();
}

