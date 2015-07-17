 /***********************************************
 * В программе реализована быстрая сортировка.  *
 * Исходные данные: массив целых чисел в файле  *
 * "input.txt".                                 *
 * Выходные данные: отсортированный массив      *
 * целых чисел в файле "outout_1.txt".          *
 ************************************************
 * Автор: Дюгуров Сергей Михайлович MK-301      *
 * Среда разработки: Dev-Cpp v. 4.9.9.0         *
 * Дата: 18.04.05                               *
 ************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#define MAX_SIZE 100000 //максимальное число элементов массива

long compare=0, //число сравнений 2-х элементов
     swap=0;    //число перестановок 2-х элементов
//------------------------------------------------------------------------------
//функция сравнения 2-х элементов
//возвращает меньший элемент
//a, b - сравниваемые элементы
int Compare(int a, int b)
{
  compare++;
  return(a<b?a:b);
}
//------------------------------------------------------------------------------
//функция перестановки 2-х элементов
//a[l], a[r] - переставляемые элементы
int Swap(int a[MAX_SIZE], long l, long r)
{
  int temp;
  temp=a[l];
  a[l]=a[r];
  a[r]=temp;
  swap++;
  return a[MAX_SIZE];
}
//------------------------------------------------------------------------------
//Быстрая сортировка
int QuickSort(int a[MAX_SIZE], long N) 
{
  long i=0, 
       j=N;
  int e;
  e=a[N>>1];
  do 
  {
    while (a[i]<e)
      i++;
    while (a[j]>e) 
      j--;  
    if (i<=j) 
    {
      int tmp=a[i];
      a[i]=a[j];
      a[j]=tmp;
      //Swap(a, i, j);
      i++; 
      j--;
    }
  } while (i<=j);
  // рекурсивные вызовы
  if (j>0) QuickSort(a, j);
  if (N>i) QuickSort(a+i, N-i);
}
//------------------------------------------------------------------------------
//основная функция
int main()
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock();
  FILE *input;
  input=fopen("input.txt", "r");
  int a[MAX_SIZE];
  long i=0;
  while (!feof(input))
  {
    fscanf(input, "%i", &a[i]);
    i++;
  }
  fclose(input);
  long kol_num=--i;
  FILE *output;
  output=fopen("output_1.txt", "w");
  if (output==NULL)
  {
    printf("File \"output_1.txt\" not open");
    getch();
    exit(1);
  }  
  printf("Sorting...");
  fprintf(output, "Before sorting: ");
  for(i=0;i<kol_num;i++)
    fprintf(output, "%i ", a[i]);
  QuickSort(a, kol_num-1); //сортировка массива a[MAX_SIZE]
  fprintf(output, "\nAfter sorting:  ");
  for(i=0;i<kol_num;i++)
    fprintf(output, "%i ", a[i]);
  fprintf(output, "\n\nNumber of compares: %i", compare);
  fprintf(output, "\nNumber of swaps: %i", swap);
  fprintf(output, "\nNumber of compares & swaps: %i", compare+swap);
  fclose(output);
  printf("\n\nNumber of compares: %i", compare);
  printf("\nNumber of swaps: %i", swap);
  printf("\nNumber of compares & swaps: %i", compare+swap);
  end=clock();
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n\nThe time of sorting %i numbers: %f sec", kol_num, cpu_time_used); 
  printf("\nOpen file \"output.txt\"");
  getch();
  return 0;
}
