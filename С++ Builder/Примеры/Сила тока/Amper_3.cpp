//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Amper_3.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
    float u; // ����������
    float r; // �������������
    float i; // ���

    // �������� ������ �� ����� �����
    // �������� ����������
    try
    {
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);
    }
    catch (EConvertError &e)
    {
        ShowMessage("��� ����� ������� ����� ����������� �������.");
        return;
    }

    // ��������� ���
    // �������� ����������
    try
    {
    i = u/r;
    }
    catch (EZeroDivide &e)
    {
        ShowMessage("������������� �� ������ ���� ����� ����");
        Edit1->SetFocus();   // ������ � ���� �������������
        return;
    }

    // ������� ��������� � ���� �����
    Label4->Caption = "��� : " +
         FloatToStrF(i,ffGeneral,7,3);

}
//---------------------------------------------------------------------------






