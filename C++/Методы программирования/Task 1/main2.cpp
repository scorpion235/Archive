//��������� ��������� 50000 ��������� �� "data.txt" ������ �� ������ ������� � ������
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include "Sort.cpp"

int main()
{
  clock_t start, // ������ ������ ���������                                     /*������*/
          end;   // ���������� ������ ���������
  start=clock();
  printf("Sorting...\n");
  SortStackArray();
  end=clock();
  //����� ������ ���������
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nSort with array: %0.5f sec", cpu_time_used);
  start=clock();                                                                /*������*/
  printf("\n\nSorting...\n");
  SortStackList();
  end=clock();
  //����� ������ ���������
  cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nSort with list: %0.5f sec", cpu_time_used);
  getch();
  return 0;
}
