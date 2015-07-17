/*********************************************************
 * ������ ����������������. ������� 7.                   *
 *-------------------------------------------------------*
 * � ��������� ����������� ������� ����������.           *
 *-------------------------------------------------------*
 * �������� ������: "kol_array" �������� ����� ����� c   *
 * "kol_num" ��������� � ������, �������������� ������   *
 * ��������� �������.                                    *
 *-------------------------------------------------------*                               
 * �������� ������: ��������������� ������� ����� �����  *
 * � ����� �������� ���������, �������� ������������ �   *
 * ����� "outout_1.txt"; � ��� �� ������� � ������������ *
 * ������ ���������, ������������ ������ ������������,   *
 * ������������ ������ ��������� � ������������ � �����  *
 * "result.txt".                                         *
 *********************************************************
 * �����: ������� ������ ���������� MK-301               *
 * ����� ����������: Dev-Cpp v. 4.9.9.0                  *
 * ����: 18.04.05                                        *
 *********************************************************/
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#define MAX_SIZE 100000 //������������ ����� ��������� �������
#define kol_array 100  //����� ��������
#define kol_num 100      //����� ��������� � ������ ������� 

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
//-----------------------------------------------------------------------------
//�������� �������
int main()
{
  clock_t start, // ������ ������ ���������
          end;   // ���������� ������ ���������
  start=clock(); 
  int i, pers=100, //����� ��������������� ��������
      kol_compare=0,  //����� ��������� 2-� ���������
      kol_swap=0,     //����� ������������ 2-� ���������
      kol_compare_and_swap=0, //����� ��������� � ������������ 2-� ���������
      index1, //������ ������� � ���������� ������ ��������� 2-� ���������
      index2, //������ ������� � ���������� ������ ������������ 2-� ���������
      index3, //������ ������� � ���������� ������ ��������� � ������������ 2-� ���������
      mass1[MAX_SIZE], //������ � ���������� ������ ��������� 2-� ���������
      mass2[MAX_SIZE], //������ � ���������� ������ ������������ 2-� ���������
      mass3[MAX_SIZE], //������ � ���������� ������ ��������� � ������������ 2-� ���������
      temp[MAX_SIZE];  //��������������� ������ ��� ���������� �������� ������
  printf("Sorting %i array(s) with %i number(s)...\n", kol_array, kol_num);
  FILE *output;
  output=fopen("output_2.txt", "w");
  if (output==NULL)
  {
    printf("File \"output_2.txt\" not open");
    getch();
    exit(1);
  }  
  for(int mod=1;mod<=kol_array;mod++)
  {
    if (mod==pers)
    {
      for(i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_array);
      pers+=100;
    }
    compare=swap=0;
    int a[MAX_SIZE];
    for(i=0;i<kol_num;i++)
    {
      a[i]=rand()%(kol_array+i);
      temp[i]=a[i];
    }
    fprintf(output, "Array %i\n", mod);
    fprintf(output, "Before sorting: ");
    for(i=0;i<kol_num;i++)
      fprintf(output, "%i ", a[i]);
    QuickSort(a, 0, kol_num-1); //���������� ������� a[MAX_SIZE]
    if (kol_compare<compare) 
    {
      kol_compare=compare;
      index1=mod;
      for(i=0;i<kol_num;i++)
        mass1[i]=temp[i];
    }    
    if (kol_swap<swap) 
    {
      kol_swap=swap;
      index2=mod;
      for(i=0;i<kol_num;i++)
        mass2[i]=temp[i];
    }  
    if (kol_compare_and_swap<compare+swap) 
    {
      kol_compare_and_swap=compare+swap;
      index3=mod;
      for(i=0;i<kol_num;i++)
        mass3[i]=temp[i];
    }   
    fprintf(output, "\nAfter sorting:  ");
    for(i=0;i<kol_num;i++)
      fprintf(output, "%i ", a[i]);
    fprintf(output, "\nNumber of compare: %i", compare);
    fprintf(output, "\nNumber of swap: %i\n", swap);
    fprintf(output, "--------------------------------------------------------------------------------\n");
  }
  fclose(output);
  FILE *result;
  result=fopen("result.txt", "w");
  if (result==NULL)
  {
    printf("\nFile \"result.txt\" not open");
    getch();
    exit(1);
  }  
  fprintf(result, "Array %i have maximum compares (%i):\n", index1, kol_compare); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass1[i]);
  fprintf(result, "\n--------------------------------------------------------------------------------");
  fprintf(result, "\nArray %i have maximum swaps (%i):\n", index2, kol_swap); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass2[i]);
  fprintf(output, "\n--------------------------------------------------------------------------------");
  fprintf(result, "\nArray %i have maximum compares & swaps (%i):\n", index3, kol_compare_and_swap); 
  for(i=0;i<kol_num;i++)
    fprintf(result, "%i ", mass3[i]);
  fprintf(output, "\n--------------------------------------------------------------------------------");
  fclose(result);
  printf("\n\nMaximum number of compares: %i (array %i)", kol_compare, index1);
  printf("\nMaximum number swaps: %i (array %i)", kol_swap, index2);
  printf("\nMaximum number compares & swaps: %i (array %i)", kol_compare_and_swap, index3);
  end=clock();
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\""); 
  printf("\nOpen file \"result.txt\"");
  getch();
  return 0;
}
