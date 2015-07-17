/*************************************************
 * В программе реализована быстрая сортировка    *
 * с M эталонными элементами                     *
 *************************************************
 * Автор: Дюгуров Сергей Михайлович MK-301       *
 * Среда разработки: Dev-Cpp v. 4.9.9.0          *
 * Дата: 18.04.05                                *
 *************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define MAX_SIZE 100000 //максимальное число элементов массива
#define kol_array 1000 //число массивов
#define M 1  //число эталонных элементов (M=1..N/2)
#define N 1000//число элементов в каждом массиве 
#define out_file "output.txt"
#define res_file "result.txt"

//------------------------------------------------------------------------------
//рекурсивная функция быстрой сортировки
int MQuickSort(long m, int a[MAX_SIZE], long n) 
{
  long i, j, //левая граница 
       N1,   //промежуточная правая граница (N1<=N)
       pos,  //позиция эталонного элнмента
       k=1;  //число, определяющее значение "j" и "N1"
  int e,     //эталонный элемент 
      temp;  //вспомогательная переменная
  //сортировка m отрезков
  for (int p=1;p<=m;p++)
  {
    i=0;
    j=N1=(k+1)*n/(m+1),
    pos=k*n/(m+1);
    e=a[pos];
    do 
    {
      while (a[i]<e)
        i++;
      while (a[j]>e)
        j--;  
      if (i<=j) 
      {
        temp=a[i];
        a[i]=a[j];
        a[j]=temp;
        i++; 
        j--;
      }
    } while (i<=j);
    //рекурсивные вызовы
    if (j>0)
      MQuickSort(m, a, j);
    if (i<N1)
      MQuickSort(m, a+i, N1-i);
    k++;
  }
}
//-----------------------------------------------------------------------------
//основная функция
int main()
{
  clock_t start_prog, // начало работы программы
          end_prog;   // завершение работы программы
  start_prog=clock(); 
  int error=0; //номер ошибки (0 - нет ошибок)
  if (kol_array<1) error=1;
  if (M<1) error=2;
  if (N<2) error=3;
  if (M>N/2) error=4;
  switch (error)
  {
    case 1:
      printf("Fatal error 1: kol_array<1 (kol_array=%i)", kol_array);
      break;
    case 2:
      printf("Fatal error 2: M<1 (M=%i)", M);
      break;
    case 3:
      printf("Fatal error 3: N<2 (N=%i)", N);
      break;
    case 4:
      printf("Fatal error 4: M>N/2 (M=%i, N=%i)", M, N);
      break;
  }
  if (error!=0)
  {
    getch();
    exit(1);
  } 
  FILE *out, *res;
  out=fopen(out_file, "w");
  res=fopen(res_file, "w");
  long i, pers=10;  //число отсортированных массивов
  if (M==1)
    printf("Sorting %i array(s) with %i numbers (M=1)...\n", kol_array, N);
  else
    printf("Sorting %i array(s) with %i numbers (M=1..%i)...\n", kol_array, N, M);
  for (long mod=1;mod<=kol_array;mod++)
  {
    /*if (mod==pers)
    {
      for (i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_array);
      pers+=10;
    }*/
    int a[MAX_SIZE], b[MAX_SIZE];
    for (i=0;i<N;i++)
      a[i]=rand()%(10*kol_array);
    fprintf(out, "Array %i\n", mod);
    fprintf(out, "Before sorting:         ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    clock_t start_sort, // начало работы программы
            end_sort;   // завершение работы программы
    float time_sort, best_time;
    int index=1;
    for (long m=1;m<=M;m++)
    {
      
      for (i=0;i<N;i++)
        b[i]=a[i];
      start_sort=clock(); 
      MQuickSort(m, b, N-1); //сортировка массива a[MAX_SIZE]
      end_sort=clock();
      time_sort=((float)(end_sort-start_sort))/CLOCKS_PER_SEC;
      if (m==1)
        best_time=time_sort;
      else
        if (time_sort<best_time)
        {
          best_time=time_sort;
          index=m;
        }
      fprintf(out, "\nAfter sorting with M=%i: ", m);
      for (i=0;i<N;i++)
        fprintf(out, "%i ", b[i]);
      fprintf(out, "\nThe time of sorting: %0.3f sec", time_sort);
    }
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
    fprintf(res, "Array %i\n", mod);
    fprintf(res, "Best time with M=%i: %0.3f sec", index, best_time);
    fprintf(res, "\n----------------------------------------");
    fprintf(res, "----------------------------------------\n");
  }
  fclose(out);
  fclose(res);
  for (i=0;i<35;i++)
    printf("\b");
  printf("Sorting array: %i (%i)", kol_array, kol_array);
  end_prog=clock();
  float cpu_time_used=((float)(end_prog-start_prog))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %0.3f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\""); 
  printf("\nOpen file \"result.txt\""); 
  getch();
  return 0;
}
