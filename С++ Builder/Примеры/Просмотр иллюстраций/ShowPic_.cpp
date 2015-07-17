/*
    Программа позволяет просматривать иллюстрации.
    Демонстрирует:
       - использование компонента Image для просмотра
         jpg и bmp иллюстраций;
       - использование функций FindFirst и FindNext;
       - доступ к стандартному окну Обзор папок.
*/

#include <vcl.h>
#pragma hdrstop

#include "ShowPic_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

#include <FileCtrl.hpp>  // для доступа к SelectDirectory
#include <jpeg.hpp>      // обеспечивает работу с иллюстрациями в формате JPEG

AnsiString aPath;      // каталог, в котором находится иллюстрация
TSearchRec aSearchRec; // рез-т поиска файла

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    aPath = ""; // текущий каталог - каталог, из которого запущена программа
    FirstPicture(); // показать картинку, которая есть в каталоге программы
}

// щелчок на кнопке Каталог
void __fastcall TForm1::Button1Click(TObject *Sender)
{

/*
    AnsiString dir;  // каталог, который выбрал пользователь
    if ( SelectDirectory("Выберите каталог","", dir))
    {
        // диалог Выбор файла завершен щелчком на OK
        Edit1->Text = dir;
        Button2->Enabled = true; // теперь кнопка Выполнить доступна
    };

*/
     if (SelectDirectory("Выберикте каталог, в котором находятся иллюстрации",
                     "",aPath) )
     {
        // пользователь выбрал каталог и щелкнул на OK
        aPath = aPath + "\\";
        FirstPicture();      // вывести иллюстрацию
     }
}

// найти и вывести первую картинку
void TForm1::FirstPicture()
{
    Image1->Visible = false;   // скрыть компонент Image1
    Button2->Enabled = false;  // кнопка Дальше недоступна
    Label1->Caption = "";
    if ( FindFirst(aPath+ "*.jpg", faAnyFile, aSearchRec) == 0)
    {
        Image1->Picture->LoadFromFile(aPath+aSearchRec.Name);
        Image1->Visible = true;
        Label1->Caption = aSearchRec.Name;
        if ( FindNext(aSearchRec) == 0 )  // найти след. иллюстрацию
        {
            // иллюстрация есть
            Button2->Enabled = true; // теперь кнопка Дальше доступна
        }
    }
}

// щелчок на кнопке Дальше
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Image1->Picture->LoadFromFile(aPath+aSearchRec.Name);
    Label1->Caption = aSearchRec.Name;
    if ( FindNext(aSearchRec) != 0 )  // найти след. иллюстрацию
    {
        // иллюстраций больше нет
        Button2->Enabled = false; // теперь кнопка Дальше недоступна
    }
}



