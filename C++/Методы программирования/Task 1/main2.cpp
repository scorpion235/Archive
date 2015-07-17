//Программа сортирует 50000 элементов из "data.txt" стеком на основе массива и списка
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include "Sort.cpp"

int main()
{
  clock_t start, // начало работы программы                                     /*массив*/
          end;   // завершение работы программы
  start=clock();
  printf("Sorting...\n");
  SortStackArray();
  end=clock();
  //время работы программы
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nSort with array: %0.5f sec", cpu_time_used);
  start=clock();                                                                /*список*/
  printf("\n\nSorting...\n");
  SortStackList();
  end=clock();
  //время работы программы
  cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nSort with list: %0.5f sec", cpu_time_used);
  getch();
  return 0;
}
