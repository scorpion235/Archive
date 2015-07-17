#include <vcl.h>
#pragma hdrstop

#include "tk_.h"

#include "nkedit.cpp"

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;     // форма
TNkEdit *NkEdit;   // компонент программиста

// конструктор формы
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
    // создадим и инициализируем компонент NkEdit
    NkEdit = new TNkEdit(Form1);
    NkEdit->Parent = Form1;
    NkEdit->Text = "0";
    NkEdit->Left = 10;
    NkEdit->Top  = 100;

    // настроим компонент
    // зададим границы диапазона
    NkEdit->Min = -100;
    NkEdit->Max =  100;
    NkEdit->EnableFloat = true;  // разрешен ввод дробных чисел
}


// обработка события Create
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    AnsiString st = "Введите ";

    // информация о компоненте
    if (NkEdit->EnableFloat)
        st = st + "дробное";
    else st = st + "целое";
    st = st + " число от ";
    st = st + FloatToStr(NkEdit->Min);
    st = st + " до ";
    st = st + FloatToStr(NkEdit->Max);

    Label2->Caption = st;
}



