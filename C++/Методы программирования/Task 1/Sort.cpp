#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include "Stack.cpp"
//------------------------------------------------------------------------------
//сортировка элементов из "data.txt" на основе массива
int SortStackArray()
{
  int i, mass[MAX_SIZE],
      pers=0, j=500, k;
  FILE *data;
  StackArray stack1;
  StackArray stack2;
  //открыть файл "input.txt" на запись
  data=fopen("data.txt","rt");
  if(data==NULL)
  {
    puts("Error: the file \"data.txt\" is not opened ");
    getch();
    return -1;
  }
  i=0;
  while (!feof(data))
  {
    fscanf(data, "%i", &mass[i]);
    if ((stack1.Top()==-1) | (stack1.Top()>mass[i]))
      stack1.Push(mass[i]);
    else
    {
      while ((stack1.Top()<mass[i]) & (stack1.Top()!=-1))
      {
        stack2.Push(stack1.Top());
        stack1.Pop(); 
      }
      stack1.Push(mass[i]);
      while (stack2.Top()!=-1)
      {
        stack1.Push(stack2.Top());
        stack2.Pop();
      }
    }
    if (i==j)
    {
      j+=500;
      pers+=1;
      for (k=0;k<12;k++)
        printf("\b");
      printf("%i%% complete", pers);
    }  
    i++;
  }
  fclose(data);
  FILE *output1;
  output1=fopen("output1.txt","wt");
  if(output1==NULL)
  {
    puts("Error: the file \"output1.txt\" is not opened ");
    return -1;
  }
  for (j=0;j<i;j++)
  {
    fprintf(output1, "#%i: %i\n", j, stack1.Top());
    stack1.Pop();
  }  
  printf("\nOpen file \"output1.txt\"");
  fclose(output1);
}
//------------------------------------------------------------------------------
//сортировка элементов из "data.txt" на основе ссылочного списка
int SortStackList()
{
  int i, mass[MAX_SIZE],
      pers=0, j=500, k;
  FILE *data;
  StackArray stack1;
  StackArray stack2;
  //открыть файл "input.txt" на запись
  data=fopen("data.txt","rt");
  if(data==NULL)
  {
    puts("Error: the file \"data.txt\" is not opened ");
    getch();
    return -1;
  }
  i=0;
  while (!feof(data))
  {
    fscanf(data, "%i", &mass[i]);
    if ((stack1.Top()==-1) | (stack1.Top()>mass[i]))
      stack1.Push(mass[i]);
    else
    {
      while ((stack1.Top()<mass[i]) & (stack1.Top()!=-1))
      {
        stack2.Push(stack1.Top());
        stack1.Pop(); 
      }
      stack1.Push(mass[i]);
      while (stack2.Top()!=-1)
      {
        stack1.Push(stack2.Top());
        stack2.Pop();
      }
    }
    if (i==j)
    {
      j+=500;
      pers+=1;
      for (k=0;k<12;k++)
        printf("\b");
      printf("%i%% complete", pers);
    }  
    i++;
  }
  fclose(data);
  FILE *output2;
  output2=fopen("output2.txt","wt");
  if(output2==NULL)
  {
    puts("Error: the file \"output1.txt\" is not opened ");
    return -1;
  }
  for (j=0;j<i;j++)
  {
    fprintf(output2, "#%i: %i\n", j, stack1.Top());
    stack1.Pop();
  }  
  printf("\nOpen file \"output2.txt\"");
  fclose(output2);
}
