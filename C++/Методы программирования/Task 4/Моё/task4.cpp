/*******************************************
 * Программа перечисляет в порядке возрас- *
 * тания все натуральные числа в заданных  *
 * пределах, которые в разложении на прос- *
 * тые множители имеют заданные простые    *
 * числа                                   *
 *******************************************
 * Автор: Дюгуров Сергей MK-301            *
 * Дата: 16.02.05                          *
 * Среда разработки: Builder C++ V6.0      *
 *******************************************/

#include <vcl.h>
#pragma hdrstop

#include "task4.h"
#include <stdio.h>
#include <time.h>
#define MAX_SIZE 500
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
//нажатие кнопки "Завершить"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Form1->Close();
}
//---------------------------------------------------------------------------
//нажатие кнопки "Вычислить"
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock();
  //проверим введены ли данные
  if (((Edit1->Text).Length()==0) || ((Edit2->Text).Length()==0))
  {
    MessageDlg("Необходимо ввести верхнюю и нижнюю границы",
      mtInformation, TMsgDlgButtons() <<mbOK, 0);
    if ((Edit1->Text).Length()==0)
      Edit1->SetFocus();
    else
      Edit2->SetFocus();
    return;
  }
  //если нижняя граница больше верхней
  if (StrToFloat(Edit1->Text)>StrToFloat(Edit2->Text))
  {
    MessageDlg("Нижняя граница не может быть больше верхней",
      mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit1->SetFocus();
    return;
  }
  FILE *input;
  //открыть файл "input.txt" на чтение
  input=fopen("input.txt","rt");
  if (input==NULL)
  {
    MessageDlg("Файл \"input.txt\" не найден", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }
  long number[MAX_SIZE], //массив простых множителей
       i=0, j;            //счётчики
  while(!feof(input))    //пока не достигнут конец файла "input.txt"
  {
    //считывание из файла "input.txt" простых множителей
    fscanf(input, "%i", &number[i]);
    if (number[i]<2)
    {
      MessageDlg("В файле \"input.txt\" найден элемент меньший 2", mtInformation, TMsgDlgButtons() <<mbOK, 0);
      return;
    }
    i++;
  }
  fclose(input); //закрытие файла "input.txt"
  if (i<=1)
  {
    MessageDlg("Простых множителей должно быть не меньше двух", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }
  //Label5->Caption="Пожалуйста, подождите...";
  long kol_num=++i,   //число простых множителей
       lim1=StrToFloat(Edit1->Text), //левая граница поиска
       lim2=StrToFloat(Edit2->Text), //правая граница поиска
       list[MAX_SIZE][MAX_SIZE];     //массив списков
  for(i=0;i<kol_num;i++)
    list[i][0]=number[i];
  long count=1,         //число элементов в каждом списке
      result[MAX_SIZE], //массив искомых натуральных чисел
      min[MAX_SIZE],    //минимальный элемент в каждом списке
      minimum;          //минимальный элемент среди всех списков
  result[0]=1;
  //пока не достигнута правая граница поиска
  while(result[count]<lim2)
  {
    for(i=0;i<kol_num;i++)
      min[i]=list[i][count-1];
    //поиск минимального элемента в каждом списке
    for(i=0;i<=kol_num;i++)
      for(j=0;j<count-1;j++)
        if ((list[i][j]<min[i]) & (list[i][j]!=0))
          min[i]=list[i][j];
    minimum=min[0];
    //поиск минимального элемента среди всех списков
    for(i=1;i<kol_num;i++)
      if (min[i]<minimum)
        minimum=min[i];
    //замена на 0 всех элементов равных минимальному среди всех списков
    for(i=0;i<=kol_num;i++)
      for(j=0;j<count;j++)
        if (list[i][j]==minimum)
          list[i][j]=0;
    result[count]=minimum; //очередное искомое натуральное число
    //добавление по одному элементу в каждый список
    for(i=0;i<kol_num;i++)
      list[i][count]=number[i]*minimum;
    count++; //увеличение числа списков
  }
  FILE *output;
  output=fopen("output.txt", "wt");
  /*if (output==NULL)
  {
    MessageDlg("Файл \"output.txt\" не найден", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }*/
  fprintf(output, "Простые множители: ");
  for(i=0;i<kol_num-1;i++)
    fprintf(output, "%i ", number[i]);
  fprintf(output, "\nНижняя граница:  %i\nВерхняя граница: %i\nИскомые числа:\n", lim1, lim2);
  j=0;
  for(i=0;i<count;i++)
    if ((result[i]>=lim1) & (result[i]<=lim2))
    {
      fprintf(output, "%i\n", result[i]);
      j++;
    }
  if (j==0)
    fprintf(output, "NULL");
  fclose(output);
  end=clock();
  //время работы программы
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  Label5->Caption="Найдено "+FloatToStrF(j, ffGeneral, 10, 10)+" чисел(а)";
  Label6->Caption="Время работы программы: "+FloatToStrF(cpu_time_used, ffGeneral, 2, 10)+" sec";
  Label7->Caption="Откройте файл \"output.txt\"";
  Button1->Enabled=false;
  Button3->Enabled=false;
  return;
}
//--------------------------------------------------------------------------
//нажатие кнопки "О программе"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  MessageDlg("Автор: Дюгуров Сергей Михайлович, группа МК-301\nСреда разработки: Borland C++ Builder Versin 6.0\nДата: 1 марта 2005 года\n\nПрограмма перечисляет в порядке возрастания все натуральные числа в заданных пределах, которые в разложении на простые множители имеют заданные простые числа",
    mtCustom, TMsgDlgButtons() <<mbOK, 0);
  return;
}
//---------------------------------------------------------------------------
//нажатие клавиши в поле "нижняя граница"
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, char &Key)
{
  //коды запрещённых клавиш заменим нулём, в результате
  //символы этих клавиш в поле редактирования не появяться
  //Key-код нажатой клавиши
  if ((Key>='0') & (Key<='9')) //цифра
    return;
  if (Key==VK_BACK) //клавиша <BackSpase>
    return;
  if (Key==VK_RETURN) // клавиша <Enter>
  {
    Edit2->SetFocus();
    return;
  }
  //остальные клавиши запрешены
  Key=0;
}
//---------------------------------------------------------------------------
//нажатие клавиши в поле "верхняя граница"
void __fastcall TForm1::Edit2KeyDown(TObject *Sender, WORD &Key, TShiftState Shift)
{
  if ((Key>='0') & (Key<='9')) //цифра
    return;
  if (Key==VK_BACK) //клавиша <BackSpase>
    return;
  if (Key==VK_RETURN) // клавиша <Enter>
  {
    Button1->SetFocus();
    return;
  }
  //остальные клавиши запрешены
  Key=0;
}
//---------------------------------------------------------------------------
