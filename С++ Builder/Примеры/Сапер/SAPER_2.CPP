#include <vcl.h>
#pragma hdrstop

#include "saper_2.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TAboutForm *AboutForm;

__fastcall TAboutForm::TAboutForm(TComponent* Owner)
        : TForm(Owner)
{
}

// Выбор URL адреса
void __fastcall TAboutForm::Label5Click(TObject *Sender)
{
  /* наиболее просто передать в функцию ShellExecute 
     строку-константу (URL адрес), так как показано ниже
    ShellExecute(AboutForm->Handle,
                "open",
                "http:\\\\www.bhv.ru",
                NULL,NULL)

    Лучше URL адрес брать из поля метки.
    В функцию ShellExute надо передать указатель (char*) на
    null terminated строку, но свойство Caption - это AnsiString.
    Преобразование Ansi строки в (char*) строку выполняет метод c_str()
*/

    // открыть файл, имя которого находится в поле Label5
    ShellExecute(AboutForm->Handle,"open",Label5->Caption.c_str(),
                 NULL,NULL,SW_RESTORE);
}

// щелчок на кнопке OK
void __fastcall TAboutForm::Button1Click(TObject *Sender)
{
    ModalResult = mrOk;
}

