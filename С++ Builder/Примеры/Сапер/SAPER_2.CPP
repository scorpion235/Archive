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

// ����� URL ������
void __fastcall TAboutForm::Label5Click(TObject *Sender)
{
  /* �������� ������ �������� � ������� ShellExecute 
     ������-��������� (URL �����), ��� ��� �������� ����
    ShellExecute(AboutForm->Handle,
                "open",
                "http:\\\\www.bhv.ru",
                NULL,NULL)

    ����� URL ����� ����� �� ���� �����.
    � ������� ShellExute ���� �������� ��������� (char*) ��
    null terminated ������, �� �������� Caption - ��� AnsiString.
    �������������� Ansi ������ � (char*) ������ ��������� ����� c_str()
*/

    // ������� ����, ��� �������� ��������� � ���� Label5
    ShellExecute(AboutForm->Handle,"open",Label5->Caption.c_str(),
                 NULL,NULL,SW_RESTORE);
}

// ������ �� ������ OK
void __fastcall TAboutForm::Button1Click(TObject *Sender)
{
    ModalResult = mrOk;
}

