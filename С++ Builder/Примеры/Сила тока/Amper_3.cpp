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
    float u; // напряжение
    float r; // сопротивление
    float i; // ток

    // получить данные из полей ввода
    // возможно исключение
    try
    {
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);
    }
    catch (EConvertError &e)
    {
        ShowMessage("При вводе дробных чисел используйте запятую.");
        return;
    }

    // вычислить ток
    // возможно исключение
    try
    {
    i = u/r;
    }
    catch (EZeroDivide &e)
    {
        ShowMessage("Сопротивление не должно быть равно нулю");
        Edit1->SetFocus();   // курсор в поле Сопротивление
        return;
    }

    // вывести результат в поле метки
    Label4->Caption = "Ток : " +
         FloatToStrF(i,ffGeneral,7,3);

}
//---------------------------------------------------------------------------






