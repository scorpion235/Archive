//Программа генерирует MAX_NUM целых чисел и записывает их в "input.txt"
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#define MAX_NUM 4000 //максимальное число элементов массива

int main()
{
  FILE *input;
  //открыть файл "input.txt" на запись
  input=fopen("input.txt","w");
  if(input==NULL)
  {
    puts("Error: the file \"input.txt\" is not open");
    getch();
    return -1;
  }
  for(long i=1;i<=MAX_NUM;i++)
    fprintf(input, "%i\n", rand()%MAX_NUM);
  fclose(input);
  printf("Open file \"input.txt\"");
  getch();
  return 0;
}
