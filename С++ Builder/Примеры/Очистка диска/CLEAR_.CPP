#include <vcl.h>
#pragma hdrstop

#include "clear_.h"

#include <FileCtrl.hpp> // ��� ������� � SelectDirectory

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

AnsiString Directory; // �������, � ������� ��������� ������� C++Builder
AnsiString cDir;      // ������� �������
AnsiString FileExt;   // ���������� �����

int n = 0;            // ���������� ��������� ������


// ������ �� ������ �������
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    AnsiString dir;  // �������, ������� ������ ������������
    if ( SelectDirectory("�������� �������","", dir))
    {
        // ������ ����� ����� �������� ������� �� OK
        Edit1->Text = dir;
        Button2->Enabled = true; // ������ ������ ��������� ��������
    };
}

// ������� �������� ����� �� �������� �������� � ��� ������������
void __fastcall Clear(void)
{

   TSearchRec SearchRec; // ���������� � ����� ��� ��������

   cDir = GetCurrentDir()+"\\";

   if ( FindFirst("*.*", faArchive,SearchRec) == 0)
       do {
            // �������� ���������� �����
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

       // ��������� ������������ �������� ��������
       if ( FindFirst("*", faDirectory, SearchRec) == 0)
          do
              if ((SearchRec.Attr & faDirectory) == SearchRec.Attr )
              {
                    // �������� ".." � "." ���� ��������,
                    // �� � ��� ������� �� ���� !!!
                    if (( SearchRec.Name != "." ) && (SearchRec.Name != ".."))
                    {
                         ChDir(SearchRec.Name); // ����� � ����������
                         Clear();               // �������� �������
                         ChDir("..");           // ����� �� ��������

                    };
               }
          while ( FindNext(SearchRec) == 0 );
}

// ������ �� ������ ���������
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Memo1->Clear();          // �������� ���� Memo1
    Directory = Edit1->Text; // �������, � ������� ��������� ������� C++Builder
    ChDir(Directory);        // ����� � ������� �������� C++Builder

    Clear();                 // �������� ������� ������� � ��� �����������

    Memo1->Lines->Add("");
    if (n)
        Memo1->Lines->Add("������� ������: " + IntToStr(n));
     else
        Memo1->Lines->Add("� ��������� �������� ��� ������, ������� ���� �������.");
}

