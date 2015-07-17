/*********************************************************
 * Методы программирования. Задание 7.                   *
 *-------------------------------------------------------*
 * В программе реализована быстрая сортировка.           *
 *-------------------------------------------------------*
 * Исходные данные: "kol_array" массивов целых чисел c   *
 * "kol_num" элементов в каждом, сгенерированые псевдо   *
 * случайным образом.                                    *
 *-------------------------------------------------------*                               
 * Выходные данные: отсортированные массивы целых чисел  *
 * и число операций сравнений, операций перестановок в   *
 * файле "outout_1.txt"; а так же массивы с максимальным *
 * числом сравнений, максимальным числом перестановок,   *
 * максимальным числом сравнений и перестановок в файле  *
 * "result.txt".                                         *
 *********************************************************
 * Автор: Дюгуров Сергей Михайлович MK-301               *
 * Среда разработки: Dev-Cpp v. 4.9.9.0                  *
 * Дата: 18.04.05                                        *
 *********************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define MAX_SIZE 1000 //максимальное число элементов массива
#define kol_array 100  //число массивов
#define kol_num 10     //число элементов в каждом массиве 

long compare=0, //число сравнений 2-х элементов
     swap=0;    //число перестановок 2-х элементов
//------------------------------------------------------------------------------
//функция сравнения 2-х элементов
//возвращает меньший элемент
//a, b - сравниваемые элементы
int Compare(int a, int b)
{
  compare++;
  return (a<b?a:b);
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
//рекурсивная функция быстрой сортировки
int QuickSort(int a[MAX_SIZE], long N) 
{
  long i=0, 
       j=N;
  int e;
  e=a[N/2];
  do 
  {
    //while (Compare(a[i],e)==a[i])
    while (a[i]<e)
      i++;
    //while (Compare(a[j],e)==e)
    while (a[j]>e) 
      j--;  
    if (i<=j) 
    {
      Swap(a, i, j);
      i++; 
      j--;
    }
  } while (i<=j);
  //рекурсивные вызовы
  if (j>0) 
    QuickSort(a, j);
  if (N>i) 
    QuickSort(a+i, N-i);
}
//-----------------------------------------------------------------------------
//основная функция
int main()
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock(); 
  long i, pers=1000,  //число отсортированных массивов
       kol_compare=0, //число сравнений 2-х элементов
       kol_swap=0,    //число перестановок 2-х элементов
       kol_compare_and_swap=0, //число сравнений и перестановок 2-х элементов
       index1, //индекс массива с наибольшим числом сравнений 2-х элементов
       index2, //индекс массива с наибольшим числом перестановок 2-х элементов
       index3; //индекс массива с наибольшим числом сравнений и перестановок 2-х элементов
  int  mass1[MAX_SIZE], //массив с наибольшим числом сравнений 2-х элементов
       mass2[MAX_SIZE], //массив с наибольшим числом перестановок 2-х элементов
       mass3[MAX_SIZE], //массив с наибольшим числом сравнений и перестановок 2-х элементов
       temp[MAX_SIZE];  //вспомогательный массив для временного хранения данных
  printf("Sorting %i array(s) with %i number(s)...\n", kol_array, kol_num);
  FILE *output;
  output=fopen("output_2.txt", "w");
  if (output==NULL)
  {
    printf("File \"output_2.txt\" not open");
    getch();
    exit(1);
  }  
  for(long mod=1;mod<=kol_array;mod++)
  {
    if (mod==pers)
    {
      for(i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_array);
      pers+=1000;
    }
    compare=swap=0;
    int a[MAX_SIZE];
    for(i=0;i<kol_num;i++)
    {
      a[i]=rand()%(kol_array+2*i);
      temp[i]=a[i];
    }
    fprintf(output, "Array %i\n", mod);
    fprintf(output, "Before sorting: ");
    for(i=0;i<kol_num;i++)
      fprintf(output, "%i ", a[i]);
    QuickSort(a, kol_num-1); //сортировка массива a[MAX_SIZE]
    if (kol_compare<compare) 
    {
      kol_compare=compare;
      index1=mod;
      for(i=0;i<kol_num;i++)
        mass1[i]=temp[i];
    }    
    if (kol_swap<swap) 
    {
      kol_swap=swap;
      index2=mod;
      for(i=0;i<kol_num;i++)
        mass2[i]=temp[i];
    }  
    if (kol_compare_and_swap<compare+swap) 
    {
      kol_compare_and_swap=compare+swap;
      index3=mod;
      for(i=0;i<kol_num;i++)
        mass3[i]=temp[i];
    }   
    fprintf(output, "\nAfter sorting:  ");
    for(i=0;i<kol_num;i++)
      fprintf(output, "%i ", a[i]);
    fprintf(output, "\nNumber of compare: %i", compare);
    fprintf(output, "\nNumber of swap: %i\n", swap);
    fprintf(output, "--------------------------------------------------------------------------------\n");
  }
  fclose(output);
  FILE *result;
  result=fopen("result.txt", "w");
  if (result==NULL)
  {
    printf("\nFile \"result.txt\" not open");
    getch();
    exit(1);
  }  
  fprintf(result, "Array %i have maximum compares (%i):\n", index1, kol_compare); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass1[i]);
  fprintf(result, "\n--------------------------------------------------------------------------------");
  fprintf(result, "\nArray %i have maximum swaps (%i):\n", index2, kol_swap); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass2[i]);
  fprintf(output, "\n--------------------------------------------------------------------------------");
  fprintf(result, "\nArray %i have maximum compares & swaps (%i):\n", index3, kol_compare_and_swap); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass3[i]);
  fprintf(output, "\n--------------------------------------------------------------------------------");
  fclose(result);
  printf("\n\nMaximum number of compares: %i (array %i)", kol_compare, index1);
  printf("\nMaximum number swaps: %i (array %i)", kol_swap, index2);
  printf("\nMaximum number compares & swaps: %i (array %i)", kol_compare_and_swap, index3);
  end=clock();
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\""); 
  printf("\nOpen file \"result.txt\"");
  getch();
  return 0;
}
