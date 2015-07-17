//Программа создаёт массив из "MAX_NUM" целых чисел, который будет 
//сортироваться дольше всего и записывает его в "input.txt"
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#define MAX_NUM 3000 //максимальное число элементов массива

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
  for(int i=MAX_NUM;i>=1;i-=2)
    fprintf(input, "%i\n", (i-2)/2*2);
  for(int i=1;i<=MAX_NUM;i+=2)
    fprintf(input, "%i\n", i/2*2+1);
  fclose(input);
  printf("Open file \"input.txt\"");
  getch();
  return 0;
}
