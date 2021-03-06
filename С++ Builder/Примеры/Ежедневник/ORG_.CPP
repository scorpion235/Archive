/*

    ���� ������ "����������". ����������� ������.
    ������������� ������������� ����������� Table,
    DataSource, Query, DBGrid � DBNavigator.
    
*/


#define DIN_ALIAS // ��������� ������� � �� ��������� �����������
                 // ���� ��������� ������ ��� ������ Database Desktop
                 // ��� BDE Administrator, ��������� #define DIN_ALIAS ����
                 // ������� (���������������)

#include <vcl.h>
#pragma hdrstop

#include "org_.h"
#include <DateUtils.hpp>

#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;

__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
}

// ������ �� ������ �������
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    AnsiString today = FormatDateTime("dd/mm/yyyy",Now());

    Form1->Label2->Caption = "�������";

    // �������� �������� �������
    Query1->SQL->Strings[3] = "(Date_F = '" + today + "')";

    // ��������� ������
    Form1->Query1->Open();
    Form1->DataSource1->DataSet = Form1->Query1;

    if ( ! Form1->Query1->RecordCount )
    {
        ShowMessage("�� ������� �� ����� ��� �� �������������!");
    }
}

// ������ �� ������ ������
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    AnsiString tomorrow = FormatDateTime("dd/mm/yyyy", Now() +1 );

    Form1->Label2->Caption = "������";

    // �������� �������� �������
    Query1->SQL->Strings[3] = "(Date_F = '" + tomorrow + "')";

    // ��������� ������
    Form1->Query1->Open();

    Form1->DataSource1->DataSet = Form1->Query1;

    if ( ! Form1->Query1->RecordCount )
    {
        ShowMessage("�� ������ �� ����� ��� �� �������������!");
    }
}

// ������ �� ������ �� ���� ������
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  // �� �������� ��� �� ����� ������ (�� �����������)
  TDateTime Present,
            EndOfWeek;

  Label2->Caption = "�� ���� ������";
  Present= Now(); // Now - ���������� ������� ����

  // **************************
  //  ��� ������� � StartOfWeek, EndOfWeek, YearOf � WeekOf
  //  ���� ���������� DateUtils.hpp (��. ��������� #include )
  // **************************
  EndOfWeek = StartOfAWeek(YearOf(Present),WeekOf(Present)+1);

  Query1->SQL->Strings[3] =
         "(Date_F >= '"+ FormatDateTime("dd/mm/yyyy",Present)+"') AND " +
         "(Date_F <  '"+ FormatDateTime("dd/mm/yyyy",EndOfWeek)+"')";
  Query1->Open();
  if ( Query1->RecordCount )
  {
        DataSource1->DataSet = Form1->Query1;
  }
  else
        ShowMessage("�� ��� ������ �� ����� ��� �� �������������.");
}

//  ������ �� ������ ���
void __fastcall TForm1::Button4Click(TObject *Sender)
{
    Table1->Open();

    // ����������: �������� ������ - �������,
    // ����� �������, ����������� ��� ��
    Form1->DataSource1->DataSet = Form1->Table1;

    Label2->Caption = "���, ��� �������� �������";
}

AnsiString stDay[7] = {"�����������","�����������","�������", "�����",
                           "�������","�������","�������"};
AnsiString stMonth[12] = {"������","�������","�����",
                          "������","���","����","����",
                          "�������","��������","�������",
                          "������","�������"};

// ����������� �����
void __fastcall TForm1::FormActivate(TObject *Sender)
{
    TDateTime Today,    // �������
              NextDay;  // ��������� ���� (�� ����������� ������)

    Word  Year, Month, Day; // ���, �����, ����

    Today = Now ();

    DecodeDate(Today, Year, Month, Day);

    Label1->Caption = "������� " + IntToStr(Day) + " " +
                       stMonth[Month-1] + " " +
                       IntToStr(Year) + " ����, " +
                       stDay[DayOfWeek(Today) -1];

    Label2->Caption = "������� � ��������� ���";

    // �������� ��������� ����
    // ���� ������� �������, ��, ����� �� ������
    // ��� ������������� �� �����������, �������, ��� ���������
    // ���� - �����������
    switch ( DayOfWeek(Today) ) {
        case 6  : NextDay = Today + 3; break; // ������� �������
        case 7  : NextDay = Today + 2; break; // ������� ������
        default : NextDay = Today + 1; break;
    }


#ifdef DIN_ALIAS // ��������� ��������� �����������

    // �������� ��������� ��� ������� � ��
    Session->ConfigMode = cmSession;
    Session->AddStandardAlias("organizer",
                    ExtractFilePath(ParamStr(0)),
                    "PARADOX"); // ���� ������ ���������� - � ������� PARADOX
#endif



    // ������ � ���� ������: ���� �� ����, ���������������
    // �� ������� ��������� ����

    Query1->SQL->Strings[3] =
         "(Date_F >= '"+ FormatDateTime("dd/mm/yyyy",Today)+"') AND " +
         "(Date_F <= '"+ FormatDateTime("dd/mm/yyyy",NextDay)+"')";

    Query1->Open();
    DataSource1->DataSet = Form1->Query1;
    if ( ! Query1->RecordCount )
    {
        ShowMessage("�� ������� � ��������� ��� �� ����� ��� �� �������������.");
    }
}

