/*
    Программа вычисляет силу тока в электрической цепи.
    Демонстрирует обработку:
        - события KeyPress;
        - исключения EZerroDevide (деление на ноль)
          при помощи инструкции try … catch.
*/
#include <vcl.h>
#pragma hdrstop

#include "amper1_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}

// щелчок на кнопке Вычислить
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    float u; // напряжение
    float r; // сопротивление
    float i; // ток

    // проверим, введены ли данные в поля Напряжение и Сопротивление
    if ( ((Edit1->Text).Length() == 0) || ((Edit2->Text).Length() == 0))
    {
        MessageDlg("Надо ввести напряжение и сопротивление",
                    mtInformation, TMsgDlgButtons() << mbOK, 0);
        if ((Edit1->Text).Length() == 0)
            Edit1->SetFocus(); // курсор в поле Напряжение
        else
            Edit2->SetFocus(); // курсор в поле Сопротивление
        return;
    };

    // получить данные из полей ввода
    u = StrToFloat(Edit1->Text);
    r = StrToFloat(Edit2->Text);

    // вычислить ток
    try
    {
    i = u/r;
    }
    catch (EZeroDivide &e)
    {
        ShowMessage("Величина опротивления не должна быть равна нулю");
        Edit2->SetFocus();   // курсор в поле Сопротивление
        return;
    }


    // вывести результат в поле Label4
   Label4->Caption = "Ток : " +
                     FloatToStrF(i,ffGeneral,7,2) + " A";
}

// нажатие клавиши в поле Напряжение
// коды запрещенных клавиш заменим нулем, в результате
// символы этих клавиш в поле редактирования не появятся
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, char &Key)
{
    // Key - код нажатой клавиши
    // проверим, является ли символ допустимым

    if ( ( Key >= '0') && ( Key <= '9' ) ) // цифра
        return;

    // Глобальная переменная Decimalseparator
    // содержит символ, используемый в качестве разделителя
    // при записи дробных чисел
    if ( Key == DecimalSeparator)
    {
       if ( (Edit1->Text).Pos(DecimalSeparator) != 0 )
           Key = 0; // разделитель уже введен
    return;
    }

    if (Key == VK_BACK) // клавиша <Backspace>
        return;

    if ( Key == VK_RETURN) // клавиша <Enter>
    {
       Edit2->SetFocus();
       return;
    };

    // остальные клавиши запрещены
    Key = 0; // не отображать символ
}

// нажатие клавиши в поле Сопротивление
void __fastcall TForm1::Edit2KeyDown(TObject *Sender, WORD &Key,
      TShiftState Shift)
{
    if ( ( Key >= '0') && ( Key <= '9' ) ) // цифра
        return;

    if ( Key == DecimalSeparator) {
       if ( (Edit2->Text).Pos(DecimalSeparator) != 0 )
           Key = 0; // разделитель уже введен
       return;
    }

    if (Key == VK_BACK) // клавиша <Backspace>
        return;

    if ( Key == VK_RETURN) // клавиша <Enter>
    {
       Button1->SetFocus(); // переход к кнопке Вычислить
                            // повторное нажатие клавиши <Enter>
                            // активизирует процесс вычисления тока
                            // см. Button1Click
       return;
    };

    // остальные клавиши запрещены
    Key = 0; // не отображать символ
}

// щелчок на кнопке Завершить
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Form1->Close(); // закрыть форму приложения
}

