/*
   Программа позволяет просмотреть, в том числе и по кадрам,
   простую (не сопровождаемую звуком) анимацию (содержимое avi-файла).
   Демонстрирует использование компонентов:
     - Animate;
     - FileOpen;
     - CheckBox.

*/

#include <vcl.h>
#pragma hdrstop

#include "ShowAVI_1.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}

// обработка события OnCreate
void __fastcall TForm1::FormCreate(TObject *Sender)
{
    TSearchRec sr;  // содержит информацию
                    // о файле, найденном функцией FindFirst

    //  найдем AVI-файл в текущем каталоге
    if (FindFirst("*.avi",faAnyFile,sr) == 0 )
    {
        Edit1->Text = sr.Name;

        /* если анимация содержит звук, то при
           выполнении следующего оператора произойдет
           ошибка, т.к. компонент Animate обеспечивает
           воспроизведение только простой, не
           содержащей звука анимации
        */

        try
        {
            Animate1->FileName = sr.Name;
        }
        catch (Exception &e)
        {
            return;
        }

        RadioButton1->Enabled = true;
        RadioButton2->Enabled = true;
        Button1->Enabled = true;
    }
}

// щелчок на кнопке Выбрать
void __fastcall TForm1::Button4Click(TObject *Sender)
{
    OpenDialog1->InitialDir = "";     // открыть каталог, из которого
                                      // запущена программа
    OpenDialog1->FileName = "*.avi";  // вывести список AVI-файлов

    if ( OpenDialog1->Execute())
    {
        // пользователь выбрал файл и нажал кнопку Открыть

        // Компонент Animate может отображать только простую,
        // не сопровождаемую звуком анимацию. Поэтому,
        // при выполнении следующей инструкции возможна ошибка.
        try
        {
            Animate1->FileName = OpenDialog1->FileName;
        }
        catch (Exception &e)
        {
            Edit1->Text = "";
            // сделаем недоступными кнопки управления
            RadioButton1->Enabled = false;
            RadioButton2->Enabled = false;
            Button1->Enabled = false;
            Button2->Enabled = false;
            Button3->Enabled = false;

            AnsiString msg =
                "Ошибка открытия файла " +
                OpenDialog1->FileName +
                "\nВознможно анимация сопровождается звуком.";
            ShowMessage(msg);
            return;
        }
        Edit1->Text = OpenDialog1->FileName; // отобразить имя файла


        RadioButton1->Checked = true;// режим просмотра - непрерывно
        Button1->Enabled = true;     // кнопка Пуск доступна
        Button2->Enabled = false;    // кнопка Предыдущий кадр недоступна
        Button3->Enabled = false;     // кнопка Следующий кадр недоступны

        RadioButton1->Enabled = true;
        RadioButton2->Enabled = true;
    }
}

// щелчок на кнопке Пуск/Стоп
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    if (Animate1->Active)
    {
        // анимация отображается, щелчок на кнопке Стоп
        Animate1->Active = false;
        Button1->Caption = "Пуск";
        RadioButton2->Enabled = true;
    }
    else  // щелчок на кнопке Пуск
    {
        // активизировать отображение анимации
        Animate1->StartFrame = 1;                   // с первого кадра
        Animate1->StopFrame = Animate1->FrameCount; // по последний кадр
        Animate1->Active = true;
        Button1->Caption = "Стоп";
        RadioButton2->Enabled = false;
    }
}

// выбор режима просмотра всей анимации
void __fastcall TForm1::RadioButton1Click(TObject *Sender)
{
    Button1->Enabled = true; // кнопка Пуск/Стоп доступна
    // сделать недоступными кнопки режима просмотра по кадрам
    Button2->Enabled = false;
    Button3->Enabled = false;

    Animate1->Active = false;
}

// выбор режима просмотра по кадрам
void __fastcall TForm1::RadioButton2Click(TObject *Sender)
{
    Button1->Enabled = false; // кнопка Пуск/Стоп недоступна

    Button2->Enabled = true;   // кнопка Следующий кадр доступна
    Button3->Enabled = false;  // кнопка Предыдущий кадр недоступна
    // отобразить первый кадр
    Animate1->StartFrame =1;
    Animate1->StopFrame = 1;
    Animate1->Active = true;
    CFrame = 1; // запомним номер отображаемого кадра
}

// щелчок на кнопке Следующий кадр
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    CFrame++;
    // отобразить кадр
    Animate1->StartFrame = CFrame;
    Animate1->StopFrame = CFrame;
    Animate1->Active = true;

    if (CFrame > 1)
        Button3->Enabled = true;

    if (CFrame == Animate1->FrameCount) // отобразили последний кадр
        Button2->Enabled = false;      // теперь кнопка Следующий кадр недоступна
}

// щелчок на кнопке Предыдущий кадр
void __fastcall TForm1::Button3Click(TObject *Sender)
{
    if (CFrame == Animate1->FrameCount) // последний кадр
        Button2->Enabled = true;

    CFrame--;

    // отобразить кадр
    Animate1->StartFrame = CFrame;
    Animate1->StopFrame = CFrame;
    Animate1->Active = true;

    if (CFrame == 1)
        Button3->Enabled = false;  // кнопка Следующий кадр недоступна
}

