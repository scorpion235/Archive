//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Amper4_.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "NkEdit"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}



// ������� ������� � ���� ����������
void __fastcall TForm1::NkEdit1KeyPress(TObject *Sender, char &Key)
{
        if ( Key == VK_RETURN)
                NkEdit2->SetFocus();
}

// ������� ������� � ���� �������������
void __fastcall TForm1::NkEdit2KeyPress(TObject *Sender, char &Key)
{
        if ( Key == VK_RETURN)
                Button1->SetFocus();
}

// ������� ������ ���������
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    float u; // ����������
    float r; // �������������
    float i; // ���

    // �������� �������� ������ �� ����� �����
    u = NkEdit1->Numb;
    r = NkEdit2->Numb;

    if ( r == 0 )  {
        ShowMessage("������������� �� ������ ���� ����� ����");
        return;
    }

    // ��������� ���
    i = u/r;

    // ������� ���������
    Label4->Caption = "��� : " +
         FloatToStrF(i,ffGeneral,7,3) + "A";

}

// ������ �� ������ ���������
void __fastcall TForm1::Button2Click(TObject *Sender)
{
        Form1->Close();
}

