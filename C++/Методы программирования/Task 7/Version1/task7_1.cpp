 /***********************************************
 * � ��������� ����������� ������� ����������.  *
 * �������� ������: ������ ����� ����� � �����  *
 * "input.txt".                                 *
 * �������� ������: ��������������� ������      *
 * ����� ����� � ����� "outout_1.txt".          *
 ************************************************
 * �����: ������� ������ ���������� MK-301      *
 * ����� ����������: Dev-Cpp v. 4.9.9.0         *
 * ����: 18.04.05                               *
 ************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#define MAX_SIZE 100000 //������������ ����� ��������� �������

long compare=0, //����� ��������� 2-� ���������
     swap=0;    //����� ������������ 2-� ���������
//------------------------------------------------------------------------------
//������� ��������� 2-� ���������
//���������� ������� �������
//a, b - ������������ ��������
int Compare(int a, int b)
{
  compare++;
  return(a<b?a:b);
}
//------------------------------------------------------------------------------
//������� ������������ 2-� ���������
//a[l], a[r] - �������������� ��������
int Swap(int a[MAX_SIZE], int l, int r)
{
  int temp;
  temp=a[l];
  a[l]=a[r];
  a[r]=temp;
  swap++;
  return a[MAX_SIZE];
}
//------------------------------------------------------------------------------
//����������� ������� ������� ����������
//a[l], a[r] - ������� ������������ �������
int QuickSort(int a[MAX_SIZE], int l, int r)
{
  if (l>=r)
    return a[MAX_SIZE];
  int pos=(l+r)/2; //������� �������
  int e=a[pos]; //�������
  int i=l;
  while(i<=pos-1)
  {
    //������� a[i] � ����� ���������� ������ �������
    if(Compare(a[i],e)==e) //e<a[i]
    {
      //"������������" ������� a[i] ����� �������
      for(int j=i;j<=pos-1;j++)
        Swap(a, j, j+1); //a[j] <--> a[j+1] 
      pos--; 
      i--; 
    }
    i++;
    if (i==pos)
      break;
  }  
  i=pos+1;
  while(i<=r)
  {
    //������� a[i] � ������ ���������� ������ �������
    if(Compare(a[i],e)==a[i]) //a[i]<e
    {
      //"������������" ������� a[i] ����� �������
      for(int j=i;j>=pos+1;j--)
        Swap(a, j, j-1); //a[j] <--> a[j-1]  
      pos++; 
      i--;  
    }
    i++;
    if (i==pos)
      i++;
  }
  QuickSort(a, l, pos-1); //����������� ����� "QuickSort" ��� ������ ����������
  QuickSort(a, pos+1, r); //����������� ����� "QuickSort" ��� ������� ����������
}
//------------------------------------------------------------------------------
//�������� �������
int main()
{
  clock_t start, // ������ ������ ���������
          end;   // ���������� ������ ���������
  start=clock();
  FILE *input;
  input=fopen("input.txt", "r");
  int a[MAX_SIZE];
  int i=0;
  while (!feof(input))
  {
    fscanf(input, "%i", &a[i]);
    i++;
  }
  fclose(input);
  int kol_num=--i;
  FILE *output;
  output=fopen("output_1.txt", "w");
  if (output==NULL)
  {
    printf("File \"output_1.txt\" not open");
    getch();
    exit(1);
  }  
  printf("Sorting...");
  fprintf(output, "Before sorting: ");
  for(i=0;i<kol_num;i++)
    fprintf(output, "%i ", a[i]);
  QuickSort(a, 0, kol_num-1); //���������� ������� a[MAX_SIZE]
  fprintf(output, "\nAfter sorting:  ");
  for(i=0;i<kol_num;i++)
    fprintf(output, "%i ", a[i]);
  fprintf(output, "\n\nNumber of compares: %i", compare);
  fprintf(output, "\nNumber of swaps: %i", swap);
  fprintf(output, "\nNumber of compares & swaps: %i", compare+swap);
  fclose(output);
  printf("\n\nNumber of compares: %i", compare);
  printf("\nNumber of swaps: %i", swap);
  printf("\nNumber of compares & swaps: %i", compare+swap);
  end=clock();
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n\nThe time of sorting %i numbers: %f sec", kol_num, cpu_time_used); 
  printf("\nOpen file \"output.txt\"");
  getch();
  return 0;
}
