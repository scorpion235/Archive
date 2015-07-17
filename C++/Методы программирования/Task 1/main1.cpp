//��������� ���������� 10000000 �������� ��� ������ �� ������ ������� � ������
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include "Stack.cpp"

int main()
{
  clock_t start, // ������ ������ ���������                                     /*������*/
          end;   // ���������� ������ ���������
  start=clock();
  printf("Loading...\n");
  int max=10000000,
      pers=0, j=100000, k,
      kol1, kol2, kol3, kol4;
  kol1=kol2=kol3=kol4=0;
  StackArray stack1;
  for(int i=0;i<=max;i++)
  {
    if (i==j)
    {
      j+=100000;
      pers+=1;
      for (k=0;k<12;k++)
        printf("\b");
      printf("%i%% complete", pers);
    }    
    int ran=rand()%4; //"c��������" ����� �� 0 �� 3
    switch(ran)
    {
      case 0:  stack1.Pop();            //������� ������ �� �����
               kol1++;
               break;
      case 1:  stack1.Push(rand()%100); //��������� ������ � ����
               kol2++;
               break;
      case 2:  stack1.IsEmpty();        //�������� �� ������� 
               kol3++;
               break;
      case 3:  stack1.Top();            //������ ������� �����
               kol4++;
               break;
      default: printf("\nerror");
               getch();
               exit(1);
               break;
    } 
  }
  printf("\n%i operations \"Pop()\"", kol1); 
  printf("\n%i operations \"Push(Telement x)\"", kol2); 
  printf("\n%i operations \"IsEmpty()\"", kol3); 
  printf("\n%i operations \"Top()\"", kol4); 
  end=clock();                                             
  //����� ������ ���������
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n10^7 operation with array: %0.5f sec", cpu_time_used);
  
  start=clock();                                                                /*������*/
  printf("\n\nLoading...\n");
  max=10000000,
  pers=0, 
  j=100000;
  kol1=kol2=kol3=kol4=0;
  StackList stack2;
  for(int i=0;i<=max;i++)
  {
    if (i==j)
    {
      j+=100000;
      pers+=1;
      for (k=0;k<12;k++)
        printf("\b");
      printf("%i%% complete", pers);
    }    
    int ran=rand()%4; //"c��������" ����� �� 0 �� 3
    switch(ran)
    {
      case 0:  stack2.Pop();            //������� ������ �� �����
               kol1++;
               break;
      case 1:  stack2.Push(rand()%100); //��������� ������ � ����
               kol2++;
               break;
      case 2:  stack2.IsEmpty();        //�������� �� ������� 
               kol3++;
               break;
      case 3:  stack2.Top();            //������ ������� �����
               kol4++; 
               break;
      default: printf("\nerror");
               getch();
               exit(1);
               break;
    } 
  }
  printf("\n%i operations \"Pop()\"", kol1); 
  printf("\n%i operations \"Push(Telement x)\"", kol2); 
  printf("\n%i operations \"IsEmpty()\"", kol3); 
  printf("\n%i operations \"Top()\"", kol4);
  end=clock();
  //����� ������ ���������
  cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n10^7 operation with list: %0.5f sec", cpu_time_used);
  getch();
  return 0;
}
