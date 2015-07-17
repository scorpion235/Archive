/*
    ��������� ��������� ������������� �����������.
    �������������:
       - ������������� ���������� Image ��� ���������
         jpg � bmp �����������;
       - ������������� ������� FindFirst � FindNext;
       - ������ � ������������ ���� ����� �����.
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

#include <FileCtrl.hpp>  // ��� ������� � SelectDirectory
#include <jpeg.hpp>      // ������������ ������ � ������������� � ������� JPEG

AnsiString aPath;      // �������, � ������� ��������� �����������
TSearchRec aSearchRec; // ���-� ������ �����

void __fastcall TForm1::FormCreate(TObject *Sender)
{
    aPath = ""; // ������� ������� - �������, �� �������� �������� ���������
    FirstPicture(); // �������� ��������, ������� ���� � �������� ���������
}

// ������ �� ������ �������
void __fastcall TForm1::Button1Click(TObject *Sender)
{

/*
    AnsiString dir;  // �������, ������� ������ ������������
    if ( SelectDirectory("�������� �������","", dir))
    {
        // ������ ����� ����� �������� ������� �� OK
        Edit1->Text = dir;
        Button2->Enabled = true; // ������ ������ ��������� ��������
    };

*/
     if (SelectDirectory("��������� �������, � ������� ��������� �����������",
                     "",aPath) )
     {
        // ������������ ������ ������� � ������� �� OK
        aPath = aPath + "\\";
        FirstPicture();      // ������� �����������
     }
}

// ����� � ������� ������ ��������
void TForm1::FirstPicture()
{
    Image1->Visible = false;   // ������ ��������� Image1
    Button2->Enabled = false;  // ������ ������ ����������
    Label1->Caption = "";
    if ( FindFirst(aPath+ "*.jpg", faAnyFile, aSearchRec) == 0)
    {
        Image1->Picture->LoadFromFile(aPath+aSearchRec.Name);
        Image1->Visible = true;
        Label1->Caption = aSearchRec.Name;
        if ( FindNext(aSearchRec) == 0 )  // ����� ����. �����������
        {
            // ����������� ����
            Button2->Enabled = true; // ������ ������ ������ ��������
        }
    }
}

// ������ �� ������ ������
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    Image1->Picture->LoadFromFile(aPath+aSearchRec.Name);
    Label1->Caption = aSearchRec.Name;
    if ( FindNext(aSearchRec) != 0 )  // ����� ����. �����������
    {
        // ����������� ������ ���
        Button2->Enabled = false; // ������ ������ ������ ����������
    }
}



