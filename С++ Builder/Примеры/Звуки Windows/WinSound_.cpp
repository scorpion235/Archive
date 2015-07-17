/*
   Программа позволяет прослушать звуковые фрагменты,
   находящиеся в wav-файлах каталога Windows.

   Демонстрирует использование:
    - компонента MediaPlayer;
    - функций FindFirst и FindNext
      для формирования списка файлов.

*/

#include <vcl.h>
#pragma hdrstop

#include "WinSound_.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    char *wd; // каталог Windows

    wd = (char*)AllocMem(MAX_PATH);
    GetWindowsDirectory(wd,MAX_PATH);
    SoundPath = wd;

    // звуковые файлы находятся в подкаталоге Media
    SoundPath = SoundPath + "\\Media\\";

    // сформируем список звуковых файлов
    TSearchRec sr;
    if (FindFirst( SoundPath + "*.wav", faAnyFile, sr) == 0 )
    {
        // найден файл с расширением WAV
        ListBox1->Items->Add(sr.Name); // добавим имя файла в список
        // еще есть файлы с расширением WAV ?
        while (FindNext(sr) == 0 )
            ListBox1->Items->Add(sr.Name);
    }

    if (FindFirst( SoundPath + "*.mid", faAnyFile, sr) == 0 )
    {
        // найден файл с расширением MID
        ListBox1->Items->Add(sr.Name); // добавим имя файла в список
        // еще есть файлы с расширением MID ?
        while (FindNext(sr) == 0 )
            ListBox1->Items->Add(sr.Name);
    }

    if (FindFirst( SoundPath + "*.rmi", faAnyFile, sr) == 0 )
    {
        // найден файл с расширением RMI
        ListBox1->Items->Add(sr.Name); // добавим имя файла в список
        // еще есть файлы с расширением RMI ?
        while (FindNext(sr) == 0 )
            ListBox1->Items->Add(sr.Name);
    }

    // воспроизвести первый файл
    if ( ListBox1->Items->Count != 0)
    {
        Label2->Caption = ListBox1->Items->Strings[1];
        MediaPlayer1->FileName = SoundPath + ListBox1->Items->Strings[1];
        MediaPlayer1->Open();
        MediaPlayer1->Play();
    }
}

// щелчок на элементе списка
void __fastcall TForm1::ListBox1Click(TObject *Sender)
{
    Label2->Caption = ListBox1->Items->Strings[ListBox1->ItemIndex];
    MediaPlayer1->FileName = SoundPath + Label2->Caption;
    MediaPlayer1->Open();
    MediaPlayer1->Play();
}




