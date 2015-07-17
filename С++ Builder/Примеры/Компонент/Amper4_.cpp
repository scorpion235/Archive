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



// нажатие клавиши в поле Напряжение
void __fastcall TForm1::NkEdit1KeyPress(TObject *Sender, char &Key)
{
        if ( Key == VK_RETURN)
                NkEdit2->SetFocus();
}

// нажатие клавиши в поле Сопротивление
void __fastcall TForm1::NkEdit2KeyPress(TObject *Sender, char &Key)
{
        if ( Key == VK_RETURN)
                Button1->SetFocus();
}

// нажатие кнопке Вычислить
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    float u; // напряжение
    float r; // сопротивление
    float i; // ток

    // получить исходные данные из полей ввода
    u = NkEdit1->Numb;
    r = NkEdit2->Numb;

    if ( r == 0 )  {
        ShowMessage("Сопротивление не должно быть равно нулю");
        return;
    }

    // вычислить ток
    i = u/r;

    // вывести результат
    Label4->Caption = "Ток : " +
         FloatToStrF(i,ffGeneral,7,3) + "A";

}

// щелчок на кнопке Завершить
void __fastcall TForm1::Button2Click(TObject *Sender)
{
        Form1->Close();
}

