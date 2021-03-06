//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "amper2_.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
int aaa = 100;
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


    if ( ((Edit1->Text).Length() == 0) || ((Edit2->Text).Length() == 0))
    {
        MessageDlg("���� ������ �������� ������",mtInformation, TMsgDlgButtons() << mbOK, 0);
        if ((Edit1->Text).Length() == 0)
            Edit1->SetFocus(); // ������ � ���� Edit1
        else
            Edit2->SetFocus(); // ������ � ���� Edit1
        return;
    };

    // �������� ������ �� ����� �����
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);

    // ��������� ���
    // ����� �������� ������ "������� �� ����"
    // ��. Help:Exception classes
    __try
    {
        i = u/r; // ����������, ��� ���������� ������� �������� ����������
    }
    catch (EZeroDivide  &e) // ����� ���������� EDivByZero �� ���������
    {
       ShowMessage("������� �������������.");
       Edit2->SetFocus();
       return;
    }

    if ( i > 1 )
       Label4->Caption = "��� : " +
                    FloatToStrF(i,ffGeneral,7,2) + " A";
    else {
        i = i * 1000;
        Label4->Caption = "��� : " +
                    FloatToStrF(i,ffGeneral,7,2) + " mA";
    }



    /* ��� ������������ ������ ������ ����� ���������������
       �������� sprintf, ������ �������� ���� ������������� �� � */
/*
    AnsiString st;
    st.sprintf("���: %3.2f �",i);
    Label4->Caption = st;
*/

}

// ���������, �������� ������ ���������� ��� ����� ��������
//  �����. ���� ���, �� �������� ��� ������� �� ����
// st  - ��� ��������� �������
// key - ��������� ������
char __fastcall IsRightF(AnsiString st, char Key)
{
   if ( ( Key >= '0') && ( Key <= '9' ) )
        return Key;

   if (Key == VK_BACK) // ���� ������ ��. Help:Virtual key codes
        return Key;

   if ( ( Key == '.') || ( Key == ',') ) {
        Key = DecimalSeparator;
        if ( st.Pos(DecimalSeparator) != 0 )
        Key = 0;
   }
   else Key =0;
   return Key;
}

// ������� ������� � ���� ����������
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, char &Key)
{
    if ( Key == VK_RETURN) {
       Edit2->SetFocus();
       return;
    };

    // ��������� �������
    Key = IsRightF(Edit1->Text,Key);
}


// ������� ������� � ���� �������������
void __fastcall TForm1::Edit2KeyPress(TObject *Sender, char &Key)
{
    Key = IsRightF(Edit2->Text,Key);

}

// ������ �� ������ ���������
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Form1->Close();
}
