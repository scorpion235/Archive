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
  Label1->Caption="��������� ��������� �������� �������";
  Label2->Caption="�����: ������� �.�.\n�����: www.scorpion235@mail.ru\n����: 23.06.2005\n����� ����������: Borland Builder C++ Version 6.0\n\n���������� ��������: +, -, *, /, ^, sin, cos, tg, ctg,\narcsin, arccos, arctg, arcctg, exp, ln, mod, (, ).";
  Image1->AutoSize=false;
  Image1->Proportional=true;
  Image1->Visible=true;
}
//------------------------------------------------------------------------------
//������� ������ "OK"
void __fastcall TForm2::Button1Click(TObject *Sender)
{
  Form2->Close();
}

