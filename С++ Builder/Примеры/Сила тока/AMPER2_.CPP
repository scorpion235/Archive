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
    float u; // напряжение
    float r; // сопротивление
    float i; // ток


    if ( ((Edit1->Text).Length() == 0) || ((Edit2->Text).Length() == 0))
    {
        MessageDlg("Надо ввести исходные данные",mtInformation, TMsgDlgButtons() << mbOK, 0);
        if ((Edit1->Text).Length() == 0)
            Edit1->SetFocus(); // курсор в поле Edit1
        else
            Edit2->SetFocus(); // курсор в поле Edit1
        return;
    };

    // получить данные из полей ввода
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);

    // вычислить ток
    // здесь возможна ошибка "Деление на ноль"
    // см. Help:Exception classes
    __try
    {
        i = u/r; // инструкция, при выполнении которой возможно исключение
    }
    catch (EZeroDivide  &e) // Здесь исключение EDivByZero не возникает
    {
       ShowMessage("Введите сопротивление.");
       Edit2->SetFocus();
       return;
    }

    if ( i > 1 )
       Label4->Caption = "Ток : " +
                    FloatToStrF(i,ffGeneral,7,2) + " A";
    else {
        i = i * 1000;
        Label4->Caption = "Ток : " +
                    FloatToStrF(i,ffGeneral,7,2) + " mA";
    }



    /* Для формирования строки вывода можно воспользоваться
       функцией sprintf, хорошо знакомой всем программистам на С */
/*
    AnsiString st;
    st.sprintf("Ток: %3.2f А",i);
    Label4->Caption = st;
*/

}

// Проверяет, является символ допустимым при вводе дробного
//  числа. Если нет, то заменяет код символа на ноль
// st  - уже введенные символы
// key - очередной символ
char __fastcall IsRightF(AnsiString st, char Key)
{
   if ( ( Key >= '0') && ( Key <= '9' ) )
        return Key;

   if (Key == VK_BACK) // коды клавиш см. Help:Virtual key codes
        return Key;

   if ( ( Key == '.') || ( Key == ',') ) {
        Key = DecimalSeparator;
        if ( st.Pos(DecimalSeparator) != 0 )
        Key = 0;
   }
   else Key =0;
   return Key;
}

// Нажатие клавиши в поле Напряжение
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, char &Key)
{
    if ( Key == VK_RETURN) {
       Edit2->SetFocus();
       return;
    };

    // остальные клавиши
    Key = IsRightF(Edit1->Text,Key);
}


// Нажатие клавиши в поле Сопротивление
void __fastcall TForm1::Edit2KeyPress(TObject *Sender, char &Key)
{
    Key = IsRightF(Edit2->Text,Key);

}

// щелчок на кнопке Завершить
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Form1->Close();
}
