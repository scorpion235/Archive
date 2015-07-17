/*

    База данных "Ежедневник". Комплексный пример.
    Демонстрирует использование компонентов Table,
    DataSource, Query, DBGrid и DBNavigator.
    
*/


#define DIN_ALIAS // псевдоним доступа к БД создается динамически
                 // если псевдоним создан при помощи Database Desktop
                 // или BDE Administrator, директиву #define DIN_ALIAS надо
                 // удалить (закоментировать)

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

// Щелчок на кнопке Сегодня
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    AnsiString today = FormatDateTime("dd/mm/yyyy",Now());

    Form1->Label2->Caption = "Сегодня";

    // изменить критерий запроса
    Query1->SQL->Strings[3] = "(Date_F = '" + today + "')";

    // выполнить запрос
    Form1->Query1->Open();
    Form1->DataSource1->DataSet = Form1->Query1;

    if ( ! Form1->Query1->RecordCount )
    {
        ShowMessage("На сегодня ни каких дел не запланировано!");
    }
}

// щелчок на кнопке Завтра
void __fastcall TForm1::Button2Click(TObject *Sender)
{
    AnsiString tomorrow = FormatDateTime("dd/mm/yyyy", Now() +1 );

    Form1->Label2->Caption = "Завтра";

    // изменить критерий запроса
    Query1->SQL->Strings[3] = "(Date_F = '" + tomorrow + "')";

    // выполнить запрос
    Form1->Query1->Open();

    Form1->DataSource1->DataSet = Form1->Query1;

    if ( ! Form1->Query1->RecordCount )
    {
        ShowMessage("На завтра ни каких дел не запланировано!");
    }
}

// щелчок на кнопке На этой неделе
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  // от текущего дня до конца недели (до воскресенья)
  TDateTime Present,
            EndOfWeek;

  Label2->Caption = "На этой неделе";
  Present= Now(); // Now - возвращает текущую дату

  // **************************
  //  для доступа к StartOfWeek, EndOfWeek, YearOf и WeekOf
  //  надо полключить DateUtils.hpp (см. директивы #include )
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
        ShowMessage("На эту неделю ни каких дел не запланировано.");
}

//  Щелчок на кнопке Все
void __fastcall TForm1::Button4Click(TObject *Sender)
{
    Table1->Open();

    // установить: источник данных - таблица,
    // таким образом, отобажается вся БД
    Form1->DataSource1->DataSet = Form1->Table1;

    Label2->Caption = "Все, что намечено сделать";
}

AnsiString stDay[7] = {"воскресенье","понедельник","вторник", "среда",
                           "четверг","пятница","суббота"};
AnsiString stMonth[12] = {"января","февраля","марта",
                          "апреля","мая","июня","июля",
                          "августа","сентября","октября",
                          "ноября","декабря"};

// активизация формы
void __fastcall TForm1::FormActivate(TObject *Sender)
{
    TDateTime Today,    // сегодня
              NextDay;  // следующий день (не обязательно завтра)

    Word  Year, Month, Day; // год, месяц, день

    Today = Now ();

    DecodeDate(Today, Year, Month, Day);

    Label1->Caption = "Сегодня " + IntToStr(Day) + " " +
                       stMonth[Month-1] + " " +
                       IntToStr(Year) + " года, " +
                       stDay[DayOfWeek(Today) -1];

    Label2->Caption = "Сегодня и ближайшие дни";

    // вычислим следующий день
    // если сегодня пятница, то, чтобы не забыть
    // что запланировано на понедельник, считаем, что следующий
    // день - понедельник
    switch ( DayOfWeek(Today) ) {
        case 6  : NextDay = Today + 3; break; // сегодня пятница
        case 7  : NextDay = Today + 2; break; // сегодня суббта
        default : NextDay = Today + 1; break;
    }


#ifdef DIN_ALIAS // псевдоним создается динамически

    // создадим псевдоним для доступа к БД
    Session->ConfigMode = cmSession;
    Session->AddStandardAlias("organizer",
                    ExtractFilePath(ParamStr(0)),
                    "PARADOX"); // база данных Ежедневник - в формате PARADOX
#endif



    // запрос к базе данных: есть ли дела, запланированные
    // на сегодня следующий день

    Query1->SQL->Strings[3] =
         "(Date_F >= '"+ FormatDateTime("dd/mm/yyyy",Today)+"') AND " +
         "(Date_F <= '"+ FormatDateTime("dd/mm/yyyy",NextDay)+"')";

    Query1->Open();
    DataSource1->DataSet = Form1->Query1;
    if ( ! Query1->RecordCount )
    {
        ShowMessage("На сегодня и ближайшие дни ни каких дел не запланировано.");
    }
}

