//Программа генерирует 50000 целых чисел и записывает их в "data.txt"
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>

int main()
{
  FILE *data;
  //открыть файл "input.txt" на запись
  data=fopen("data.txt","wt");
  if(data==NULL)
  {
    puts("Error: the file \"data.txt\" is not opened ");
    getch();
    return -1;
  }
  int max=50000;
  for(int i=1;i<=max;i++)
    fprintf(data, "%i\n", rand()%1000);
  printf("Open file \"data.txt\"");
  getch();
  return 0;
}
