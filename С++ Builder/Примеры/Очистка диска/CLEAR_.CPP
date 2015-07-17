#include <vcl.h>
#pragma hdrstop

#include "clear_.h"

#include <FileCtrl.hpp> // для доступа к SelectDirectory

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

AnsiString Directory; // каталог, в котором находятся проекты C++Builder
AnsiString cDir;      // текущий каталог
AnsiString FileExt;   // расширение файла

int n = 0;            // количество удаленных файлов


// Щелчок на кнопке Каталог
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    AnsiString dir;  // каталог, который выбрал пользователь
    if ( SelectDirectory("Выберите каталог","", dir))
    {
        // диалог Выбор файла завершен щелчком на OK
        Edit1->Text = dir;
        Button2->Enabled = true; // теперь кнопка Выполнить доступна
    };
}

// удаляет ненужные файлы из текущего каталога и его подкаталогов
void __fastcall Clear(void)
{

   TSearchRec SearchRec; // информация о файле или каталоге

   cDir = GetCurrentDir()+"\\";

   if ( FindFirst("*.*", faArchive,SearchRec) == 0)
       do {
            // проверим расширение файла
            int p = SearchRec.Name.Pos(".");
            FileExt = SearchRec.Name.SubString(p+1,MAX_PATH);
            if ( ( FileExt[1] == '~') || ( FileExt == "obj" ) ||
                 ( FileExt == "tds" ) )
            {
                  Form1->Memo1->Lines->Add(cDir+SearchRec.Name);
                  DeleteFile(SearchRec.Name);
                  n++;
            }
        }
        while ( FindNext(SearchRec) == 0);

       // обработка подкаталогов текущего каталога
       if ( FindFirst("*", faDirectory, SearchRec) == 0)
          do
              if ((SearchRec.Attr & faDirectory) == SearchRec.Attr )
              {
                    // каталоги ".." и "." тоже каталоги,
                    // но в них входить не надо !!!
                    if (( SearchRec.Name != "." ) && (SearchRec.Name != ".."))
                    {
                         ChDir(SearchRec.Name); // войти в подкаталог
                         Clear();               // очистить каталог
                         ChDir("..");           // выйти из каталога

                    };
               }
          while ( FindNext(SearchRec) == 0 );
}

// щелчок на кнопке Выполнить
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Memo1->Clear();          // очистить поле Memo1
    Directory = Edit1->Text; // каталог, в котором находятся проекты C++Builder
    ChDir(Directory);        // войти в каталог проектов C++Builder

    Clear();                 // очистить текущий каталог и его подкаталоги

    Memo1->Lines->Add("");
    if (n)
        Memo1->Lines->Add("Удалено файлов: " + IntToStr(n));
     else
        Memo1->Lines->Add("В указанном каталоге нет файлов, которые надо удалить.");
}

