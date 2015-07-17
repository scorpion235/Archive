/***************************************************
 * В программе реализована быстрая сортировка.     *
 ***************************************************
 * Автор: Дюгуров Сергей Михайлович MK-301         *
 * Среда разработки: Dev-Cpp v. 4.9.9.0            *
 * Дата: 18.04.05                                  *
 ***************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define MAX_SIZE 100000 //максимальное число элементов массива
#define kol_array 10  //число массивов
#define N 10    //число элементов в каждом массиве 
#define M 1

//------------------------------------------------------------------------------
//функция сравнения 2-х элементов
//возвращает меньший элемент
//a, b - сравниваемые элементы
int Compare(int a, int b)
{ 
  return(a<b?a:b); 
}
//------------------------------------------------------------------------------
//функция перестановки 2-х элементов
//a[l], a[r] - переставляемые элементы
int Swap(int a[MAX_SIZE], int l, int r)
{
  int temp;
  temp=a[l];
  a[l]=a[r];
  a[r]=temp;
  return a[MAX_SIZE];
}
//------------------------------------------------------------------------------
//рекурсивная функция быстрой сортировки
//a[l], a[r] - границы сортируемого массива
//m - количество эталонных элементов
int MQuickSort(long m, int a[MAX_SIZE], int l, int r)
{
  if (r-l<2*m) //если массив нельзя разбить на (m+1) часть
    return a[MAX_SIZE];
  long k=1, i,
       n=(k+1)*(r-l)/(m+1),
       pos=k*(r-l)/(m+1);   //позиция медианы
  int e;
  for (int p=1;p<=m;p++)
  {
    e=a[pos]; //медиана
    i=l;
    while (i<=pos-1)
    {
      //элемент a[i] в левом подмассиве больше медианы
      if(Compare(a[i],e)==e) //e<a[i]
      {
        //"перекидываем" элемент a[i] через медиану
        for (int j=i;j<=pos-1;j++)
          Swap(a, j, j+1); //a[j] <--> a[j+1] 
        pos--; 
        i--; 
      }
      i++;
      if (i==pos)
        break;
    }  
    i=pos+1;
    while(i<=n)
    {
      //элемент a[i] в правом подмассиве меньше медианы
      if(Compare(a[i],e)==a[i]) //a[i]<e
      {
        //"перекидываем" элемент a[i] через медиану
        for(int j=i;j>=pos+1;j--)
          Swap(a, j, j-1); //a[j] <--> a[j-1]  
        pos++; 
        i--;  
      }
      i++;
      if (i==pos)
        i++;
    }
    MQuickSort(m, a, l, pos-1); //рекурсивный вызов "QuickSort" для левого подмассива
    MQuickSort(m, a, pos+1, n); //рекурсивный вызов "QuickSort" для правого подмассива
    k++;
    n=(k+1)*(r-l)/(m+1);
    pos=k*(r-l)/(m+1);
  }
}
//-----------------------------------------------------------------------------
//основная функция
int main()
{
  clock_t start_program, // начало работы программы
          end_program;   // завершение работы программы
  start_program=clock(); 
  if (M<1)
  {
    printf("Fatal error 1: M<1 (M=%i)", M);
    getch();
    exit(1);        
  }        
  if (M>N/2)
  {
    printf("Fatal error 2: M>N/2 (M=%i, N=%i)", M, N);
    getch();
    exit(1);
  }
  long i, pers=100;  //число отсортированных массивов
  printf("Sorting %i array(s) with %i number(s) (M=%i)...\n", kol_array, N, M);
  FILE *out, *res;
  out=fopen("output.txt", "w");
  res=fopen("result.txt", "w");  
  for (long mod=1;mod<=kol_array;mod++)
  {
    if (mod==pers)
    {
      for (i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_array);
      pers+=100;
    }
    int a[MAX_SIZE];
    for (i=0;i<N;i++)
      a[i]=rand()%(10*kol_array);
    fprintf(out, "Array %i\n", mod);
    fprintf(out, "Before sorting: ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    clock_t start_sort,
            end_sort;
    double min_time,
           time_work[M];
    int m;
    fprintf(res, "Array %i\n", mod);
    for (i=1;i<=M;i++)
    { 
      start_sort=clock(); 
      //for (int r=0;r<N;r++)
      //  printf("%i ", a[r]);
      //printf("\n");
      MQuickSort(i, a, 0, N-1); //сортировка массива a[MAX_SIZE]
      end_sort=clock();
      time_work[i]=((double)(end_sort-start_sort))/CLOCKS_PER_SEC;
      fprintf(res, "M=%i: time_work=%f\n", i, time_work[i]);
      if (i==1)
      {
        min_time=time_work[1];
        m=i;
      }
      else
      {
        if (time_work[i]<min_time)
        {
          min_time=time_work[i];
          m=i;
        }
      } 
    }  
    fprintf(res, "Array %i have minimaze time: %f with M=%i", mod, min_time, m);
    fprintf(res, "\n----------------------------------------");
    fprintf(res, "----------------------------------------\n");
    fprintf(out, "\nAfter sorting:  ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
  }
  fclose(out);
  fclose(res);
  for (i=0;i<35;i++)
    printf("\b");
  printf("Sorting array: %i (%i)", kol_array, kol_array);
  end_program=clock();
  double cpu_time_used=((double)(end_program-start_program))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\"\nOpen file \"result.txt\""); 
  getch();
  return 0;
}
