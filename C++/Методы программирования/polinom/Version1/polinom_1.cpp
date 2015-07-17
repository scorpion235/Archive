/********************************************
 * Программа находит все корни полиномов    *
 * степени <= "power_of_polinom" с коэффи-  *
 * циентами -2, -1, 0, 1, 2                 *
 ********************************************
 * Автор: Дюгуров Сергей Михайлович MK-301  *
 * Autor: Duygurov Sergey                   *
 * Среда разработки: Dev-Cpp v. 4.9.9.0     *
 * Дата: 25.04.05                           *
 ********************************************/ 
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include <math.h>

#define power_of_polinom 6 //степень полинома

//в функции "Polinom()" осуществляется поиск корней полиномов
int Polinom()
{
  FILE *output;
  output=fopen("output.txt", "w");
  long kol_polinom=0;        //число полиномов
  int k[power_of_polinom+1], //массив коэффициентов полинома
      pers=1000,             //число обработанных полиномов
      i, j;                  //счётчики
  //изначально все коэффициенты равны 2
  for (i=0;i<=power_of_polinom;i++)
    k[i]=2;
  printf("Polinomyal of the %i power:\n", power_of_polinom);
  while (k[0]!=-3)
  {
    kol_polinom++;
    if (kol_polinom==pers)
    {
      for (i=0;i<17;i++)
        printf("\b");
      printf("%i (%0.0f)", kol_polinom, pow(5,power_of_polinom+1));
      pers+=1000;
    }
    int pos; //индекс первого ненулевого коэффициента
    //поиск первого ненулевого коэффициента (k[pos])
    for (i=0;i<=power_of_polinom;i++)
      if (k[i]!=0)
      {
        pos=i;
        break;
      }
    if ((power_of_polinom-pos!=0) & (power_of_polinom-pos!=1))
      if ((k[pos]!=-1) & (k[pos]!=1))
        fprintf(output, "%i*x^%i", k[pos], power_of_polinom-pos);
      else
        if (k[pos]==1)
          fprintf(output, "x^%i", power_of_polinom-pos);
        else //k[pos]==-1
          fprintf(output, "-x^%i", power_of_polinom-pos);
    else 
      if (power_of_polinom-pos==1)
        if ((k[pos]!=-1) & (k[pos]!=1))
          fprintf(output, "%i*x", k[pos]);
        else
          if (k[pos]==1)
            fprintf(output, "x");
         else //k[pos]==-1
            fprintf(output, "-x");
    for (i=pos+1;i<=power_of_polinom;i++)
      if (k[i]!=0)
        if ((k[i]>0))
          if (i<power_of_polinom-1)
            if (k[i]==1)
                fprintf(output, "+x^%i", power_of_polinom-i);
              else //k[i]==2
                fprintf(output, "+2*x^%i", power_of_polinom-i);
          else 
            if (i==power_of_polinom-1)
              if (k[i]==1)
                fprintf(output, "+x");
              else //k[i]==2
                fprintf(output, "+2*x");
            else //i==power_of_polinom
              fprintf(output, "+%i", k[i]);   
        else //k[i]<0
          if (i<power_of_polinom-1)
            if (k[i]==-1)
                fprintf(output, "-x^%i", power_of_polinom-i);
              else //k[i]==-2
                fprintf(output, "-2*x^%i", power_of_polinom-i);
          else 
            if (i==power_of_polinom-1)
              if (k[i]==-1)
                fprintf(output, "-x");
              else //k[i]==-2
                fprintf(output, "-2*x");
            else //i==power_of_polinom
              fprintf(output, "%i", k[i]);
    if (power_of_polinom-pos!=0)
    {
      fprintf(output, "=0\n");
      int kol_radical=0; //количество корней уравнения
      //всевозможные корни полиномов: -2, -1, -0.5, 0.5, 1, 2 
      for (float radical=-2;radical<=2;radical+=0.5)
      {
        //-1.5 и 1,5 не могут быть корнями полинома
        if ((radical==-1.5) | (radical==1.5))
          continue;
        double sum1=0; //сумма в левой части полинома при переборе корней
        for (i=0;i<=power_of_polinom;i++)
          sum1+=k[i]*pow(radical, power_of_polinom-i);
        //найден корень
        if (sum1==0)
        {
          if ((radical==-0.5) | (radical==0.5))
            fprintf(output, "Корень: %0.1f", radical);
          else
            fprintf(output, "Корень: %0.0f", radical);
          //массив коэффициентов полинома при нахождении проиводных
          int temp[power_of_polinom+1]; 
          for (i=0;i<=power_of_polinom;i++)
            temp[i]=k[i]; //изначально temp[i]=k[i]
          int derivative=1, //номер производной
              order=1; //кратность корня
          //сумма в левой части полинома при нахождении производных
          double sum2=0; 
          for (i=0;i<=power_of_polinom-2;i++)
          { 
            for (j=0;j<=power_of_polinom-derivative;j++)
            {
              if (power_of_polinom==0)
                temp[j]=power_of_polinom-j-1;
              else
                temp[j]*=power_of_polinom-j-derivative+1;
              if (power_of_polinom-derivative-j==0)
                sum2+=temp[j];
              else
                sum2+=temp[j]*(pow(radical, power_of_polinom-j-1));
            }   
            //производная левой части полинома равна 0
            if (sum2==0)
              order++; //декриментируем кратность
            derivative++;
          }
          fprintf(output, ", кратность: %i\n", order);
          kol_radical++;
        }
      }
      //не найдено корней
      if (kol_radical==0)
        fprintf(output, "Рациональных корней нет\n");
      fprintf(output, "--------------------------------------------------------------------------------\n");
    }
    //коэффициент при свободном члене полинома равен -2
    if (k[power_of_polinom]==-2)
    {
      //поиск коэффициента, который нужно декриментировать
      //(самого правого коэффициента, не равного -2)
      for (i=power_of_polinom-1;i>=0;i--)
        if (k[i]!=-2)
        {
          k[i]--;
          break;
        }
        else
          if (i!=0)
            k[i]=2;
          else
            k[i]--;
      k[power_of_polinom]=3;
    }    
    k[power_of_polinom]--;
  }
  fclose(output);
  for (i=0;i<17;i++)
    printf("\b");
  //вывод на экран числа обработанных полиномов
  printf("%i (%0.0f)", kol_polinom, pow(5, power_of_polinom+1)); 
}
//------------------------------------------------------------------------------
//основная функция
int main()
{
  double start=clock(); //начало работы программы
  //степень полинома <1 или >8
  if ((power_of_polinom<1) | (power_of_polinom>8))
  {
    printf("The power of polynomial less then 1 or more then 8\nPress any key");
    getch();
    return -1;
  }
  Polinom();
  double end=clock(); //завершение работы программы
  //время работы программы
  double time_work=((double)(end-start))/CLOCKS_PER_SEC; 
  printf("\n\nThe time of program work: %0.5f sec", time_work);
  printf("\nOpen \"output.txt\"");
  getch();
  return 0;
}    
