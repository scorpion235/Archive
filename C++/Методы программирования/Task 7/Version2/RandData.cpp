//��������� ���������� MAX_NUM ����� ����� � ���������� �� � "input.txt"
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#define MAX_NUM 4000 //������������ ����� ��������� �������

int main()
{
  FILE *input;
  //������� ���� "input.txt" �� ������
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
