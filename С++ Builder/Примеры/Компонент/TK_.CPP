#include <vcl.h>
#pragma hdrstop

#include "tk_.h"

#include "nkedit.cpp"

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;     // �����
TNkEdit *NkEdit;   // ��������� ������������

// ����������� �����
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
    // �������� � �������������� ��������� NkEdit
    NkEdit = new TNkEdit(Form1);
    NkEdit->Parent = Form1;
    NkEdit->Text = "0";
    NkEdit->Left = 10;
    NkEdit->Top  = 100;

    // �������� ���������
    // ������� ������� ���������
    NkEdit->Min = -100;
    NkEdit->Max =  100;
    NkEdit->EnableFloat = true;  // �������� ���� ������� �����
}


// ��������� ������� Create
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    AnsiString st = "������� ";

    // ���������� � ����������
    if (NkEdit->EnableFloat)
        st = st + "�������";
    else st = st + "�����";
    st = st + " ����� �� ";
    st = st + FloatToStr(NkEdit->Min);
    st = st + " �� ";
    st = st + FloatToStr(NkEdit->Max);

    Label2->Caption = st;
}



