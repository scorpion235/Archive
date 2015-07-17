/********************************************
 * Программа находит все корни полиномов    *
 * степени <= "max_power" с коэффициентами  *
 * -2, -1, 1, 2 (с учётом кратности)        *
 ********************************************
 * Автор: Дюгуров Сергей Михайлович MK-301  *
 * Autor: Dyugurov Sergey                   *
 * Среда разработки: Dev-Cpp v. 4.9.9.0     *
 * Дата: 1.05.05                            *
 ********************************************/ 
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define out_file "output.txt"
#define max_power 8  //степень полинома
#define exact 0.001  //точность

int kol_radical; //количество корней в каждом полиноме
//------------------------------------------------------------------------------
class Polinom
{
  public:
    //возведение в степень
    float pow(float a, int b);
    //проверка допустимых значений "max_power" и "exact"
    int Testing();
    //вычисление кратности корня "radical"
    int SearchingOrders(FILE *out, float radical, int k[max_power], int power);
    //поиск корней полинома с точностью "exact"
    int SearchingRadicals(FILE *out, float exactness, float lim1, float lim2, int k[max_power], int power);
    //вывод полинома в текстовый файл
    int PrintPolinom(FILE *out, int k[max_power], int power);
    //функция, использующая все остальные
    int BasicFunction();
};  
//------------------------------------------------------------------------------
//возведение в степень
//a - основание
//b - показатель
float Polinom::pow(float a, int b)
{
  //отрицательная степень
  if (b<0)
  {
    printf("\nFatal error: Power less then 0");
    getch();
    exit(1);
  }
  //возведение в 0 степень
  if (b==0)
    return 1;
  float temp=1;
  for (int i=1;i<=b;i++)
    temp*=a;
  return temp;  
}   
//------------------------------------------------------------------------------ 
//проверка допустимых значений "max_power" и "exact"
int Polinom::Testing()
{
  //степень полинома <1 или >8
  if ((max_power<1) | (max_power>8))
  {
    printf("The power of polynomial less then 1 or more then 8\nPress any key to exit");
    getch();
    exit(1);
  }
  //точность <0.0001 или >0.001
  if ((exact<0.0001) | (exact>0.001))
  {
    printf("The exactness less then 0.0000001 or more then 0.01\nPress any key to exit");
    getch();
    exit(1);
  }
  return 0;
}
//------------------------------------------------------------------------------
//вычисление кратности корня "radical"
//"radical" - корень полинома с точностью "exact"
//"k[mak_power]" - коэффициенты полинома
int Polinom::SearchingOrders(FILE *out, float radical, int k[max_power], int power)
{
  int temp[power+1]; //массив коэффициентов полинома при нахождении проиводных
  for (int i=0;i<=power;i++)
    temp[i]=k[i];   //изначально temp[i]=k[i]
  int derivative=1, //номер производной
      order=1;      //кратность корня
  float sum1=0, //сумма в левой части полинома при нахождении производных,
                //когда корень имеет вид "radical-exact/2"
        sum2=0; //сумма в левой части полинома при нахождении производных,
                //когда корень имеет вид "radical+exact/2"
  //пока имеет смысл извлекать производную
  for (int i=0;i<=power-2;i++)
  { 
    //извлечение производной из каждого слагаемого
    for (int j=0;j<=power-derivative;j++)
    {
      if (power==0)
        temp[j]=power-j-1;
      else
        temp[j]*=power-j-derivative+1;
      if (power-derivative-j==0)
      {
        sum1+=temp[j];
        sum2+=temp[j];
      }
      else
      {
        //производная суммы равна сумме производных
        sum1+=temp[j]*(pow(radical-exact/2, power-j-1));
        sum2+=temp[j]*(pow(radical+exact/2, power-j-1));
      }
    }   
    //производная левой части полинома равна 0 с точностью "exact"
    if ( ((sum1<=0) & (sum2>=0)) | ((sum1>=0) & (sum2<=0)) )
      order++;    //инкриментируем кратность
    else //получили производную неравную 0
      break;
    derivative++; //инкрементируем номер производной
  }
  //выводим кратность в текстовый файл
  fprintf(out, ", кратность: %i", order);
}    
//------------------------------------------------------------------------------
//поиск корней полинома с точностью "exact" (с помощью рекурсии)
//"exactness" - промежуточная точность (exactness<=exact)
//"lim1" и "lim2" - границы поиска корней
//"k[mak_power]" - коэффициенты полинома
//"power" - степень полинома
int Polinom::SearchingRadicals(FILE *out, float exactness, float lim1, float lim2, int k[max_power], int power)
{
  float radical=lim1,
        sum,  //сумма в левой части полинома при нахождении корней,
              //когда корень полинома имеет вид "radical"
        sum1, //            --//--       "radical-exactness/2"
        sum2, //            --//--       "radical+exactness/2"
        right=0; //промежуточное значение правой границы поиска
  for (int i=0;i<=power;i++)
    right+=k[i]*pow(radical-exactness/2, power-i);    
  while (radical<=lim2)
  {
    sum=sum1=sum2=0;
    for (int i=0;i<=power;i++)
    {
      sum+=k[i]*pow(radical, power-i);  
      sum2+=k[i]*pow(radical+exactness/2, power-i);
    } 
    sum1=right;
    right=sum2;
    if (sum==0) 
    {
      if ((exact>=0.01) & (exact<=0.99))
          fprintf(out, "\nКорень: %0.2f", radical);
        else
          if ((exact>=0.001) & (exact<=0.999))
            fprintf(out, "\nКорень: %0.3f", radical);
          else
            if ((exact>=0.0001) & (exact<=0.9999))
              fprintf(out, "\nКорень: %0.4f", radical);
      SearchingOrders(out, radical, k, power);
      kol_radical++;
    }   
    else
      //сумма в левой части полинома равна 0 с точностью "exact"
      if ( ((sum1<0) & (sum2>0) & (exactness<=exact)) | ((sum1>=0) & (sum2<=0) & (exactness<=exact)) )
      { 
        if ((exact>=0.01) & (exact<=0.99))
          fprintf(out, "\nКорень: %0.2f", radical);
        else
          if ((exact>=0.001) & (exact<=0.999))
            fprintf(out, "\nКорень: %0.3f", radical);
          else
            if ((exact>=0.0001) & (exact<=0.9999))
              fprintf(out, "\nКорень: %0.4f", radical); 
        SearchingOrders(out, radical, k, power);
        kol_radical++;
      }  
      else
        if ( ((sum1<0) & (sum2>0)) | ((sum1>0) & (sum2<0)) )  
          //рекурсивный вызов "SearchingRadicals" для уточнения значения корня
          SearchingRadicals(out, 0.1*exactness, radical-exactness/2, radical+exactness/2, k, power);    
    radical+=exactness;
  }    
}
//------------------------------------------------------------------------------
//вывод полинома в текстовый файл
//"k[mak_power]" - коэффициенты полинома
//"power" - степень полинома
int Polinom::PrintPolinom(FILE *out, int k[max_power], int power)
{
  for (int i=0;i<=power;i++)
  switch (k[i])
  {
    case 2:
      if (power-i==0)
        fprintf(out, "+2");
      else
        if ((power-i==1) & (power==1))
          fprintf(out, "2*x");
        else
          if ((power-i==1))
            fprintf(out, "+2*x");
          else //power-i>1
            if (i==0)
              fprintf(out, "2*x^%i", power-i); 
            else
              fprintf(out, "+2*x^%i", power-i);
      break;
    case 1:
      if (power-i==0)
        fprintf(out, "+1");
      else
        if ((power-i==1) & (power==1))
          fprintf(out, "x");
        else
          if (power-i==1)
            fprintf(out, "+x");
          else //power-i>1
            if (i==0)
              fprintf(out, "x^%i", power-i); 
            else
              fprintf(out, "+x^%i", power-i);
      break;
    case -1:
      if (power-i==0)
        fprintf(out, "-1");
      else
        if (power-i==1)
          fprintf(out, "-x");
        else //power-i>1
          fprintf(out, "-x^%i", power-i);
      break;
    case -2:
      if (power-i==0)
        fprintf(out, "-2");
      else
        if (power-i==1)
          fprintf(out, "-2*x");
        else //power-i>1
          fprintf(out, "-2*x^%i", power-i);
      break;
  }
  fprintf(out, "=0");  
  return 0;  
}
//------------------------------------------------------------------------------
//функция, использующая все остальные
int Polinom::BasicFunction()
{
  FILE *out;
  //открытие файла "out_file" на запись
  out=fopen(out_file, "w");
  if (out==NULL)
  {
    printf("File out_file not found\nPress any key");
    getch();
    return -1;
  }
  int i, j; //счётчики
  float pers=1; //количество секунд, через которые выводится
                //число обработанных полиномов
  long kol_polinom=0; //число полиномов
  float kol=0;        //число обработанных полиномов
  for (i=max_power;i>0;i--)
    kol+=pow(4, i+1);
  printf("Number of complete polinomyals <= %i power:\n", max_power);
  float start=clock(), 
    end, time_work;
  //производим поиск корней для полиномов от 8 до 1 степени
  for (int power=max_power;power>=1;power--)
  {
    fprintf(out, "                                             ");
    fprintf(out, "                            power=%i\n", power);
    int k[power+1]; //коэффициенты полиномов
    for (i=0;i<=power;i++)
      k[i]=2;
    //пока не перебраны все комбинации коэффициентов 
    while (k[0]>-3)
    {
      kol_polinom++; //инкрементируем число полиномов
      //вывод числа обработанных полиномов на экран
      end=clock();
      time_work=((float)(end-start))/CLOCKS_PER_SEC; 
      if (time_work>pers)
      {
        for (i=0;i<15;i++)
          printf("\b");
        printf("%i (%0.0f)", kol_polinom, kol);
        start=clock();
      }
      //вывод полинома с полученными коэффициентами в текстовый файл
      PrintPolinom(out, k, power); 
      kol_radical=0;
      //поиск корней
      SearchingRadicals(out, 0.5, -3, 3, k, power); 
      if (kol_radical>power)
      {
        printf("\nFatal error: Number of radicals more than power of polinom");
        getch();
        exit(1);
      }
      //не найдено корней
      if (kol_radical==0)
        fprintf(out, "\nДействительных корней нет");
      fprintf(out, "\n-----------------------------------------");
        fprintf(out, "---------------------------------------\n");
      if (k[power]==-2) //последний коэффициент равен -2
      {
        //поиск коэффициента, который нужно декриментировать
        //(самого правого коэффициента, не равного -2)
        for (i=power-1;i>=0;i--)
          if (k[i]!=-2)
          {
            if (k[i]==1)
              k[i]=-1;
            else //k[i]==2 или k[i]==-1
              k[i]--;
            break;
          }
          else
            if (i!=0)
              k[i]=2;
            else
              if (k[i]==1)
                k[i]=-1;
              else //k[i]==2 или k[i]==-1
                k[i]--;
        k[power]=2;
      }
      else 
        if (k[power]==1)
          k[power]=-1;
        else //k[power]==2 или k[power]==-1       
          k[power]--;
    }
  }
  for (int i=0;i<15;i++)
    printf("\b");
  //вывод на экран окончательного числа обработанных полиномов
  printf("%i (%0.0f)", kol_polinom, kol);
  fclose(out); 
  return 0; 
}    
//------------------------------------------------------------------------------
//основная функция
int main()
{
  float start=clock(); //начало работы программы
  Polinom polinom;
  polinom.Testing(); //"тестирование" "max_power" и "exact"
  polinom.BasicFunction();
  //printf("%f", polinom.pow(2,3));
  float end=clock(); //завершение работы программы
  //время работы программы
  float time_work=((float)(end-start))/CLOCKS_PER_SEC; 
  printf("\n\nThe time of program work: %0.3f sec (%0.5f min)", time_work, time_work/60);
  printf("\nOpen \"output.txt\"");
  getch();
  return 0;
}    
