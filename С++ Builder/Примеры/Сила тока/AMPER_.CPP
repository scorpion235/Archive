/*
   ��������� ��������� ���� ���� � ������������� ����.
   ������������� ��������� ������� Click,
   ���� �� ���� ��������������, ����� � ���� �����,
   ������������� StrToFloat � FloatToStrF
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
    float u; // ����������
    float r; // �������������
    float i; // ���

    // �������� ������ �� ����� �����
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);

    // ��������� ���
    i = u/r;

    // ������� ��������� � ���� �����
    Label4->Caption = "��� : " +
         FloatToStrF(i,ffGeneral,7,3);

}






