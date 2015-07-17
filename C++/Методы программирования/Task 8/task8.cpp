//������� ���������� �� �������
//�����: ������� �. �.
//����: 30.05.05.
//����� ����������: Dev-Cpp 4.9.9.0

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>
#include <math.h>

#define capacity 5   //����������� ������������ ��������
#define kol_stacks 1 //����� ������
#define Mmin 1     //��������� ����� ��������� ���������
#define Mmax 10     //�������� ����� ��������� ���������
#define step 1      //����������
#define N 100    //����� �����

#define out_file "output.txt"

class Stack
{
  private:
    struct StructType
    {
      int x;
      StructType *prev;
    };
    StructType *last;
    StructType *pointer;
    long top; //���������� ��������� � �����
    void Delete() //������� �������
    {
      if (Count()==0)
        return;
      pointer=last->prev;
      free(last);
      last=pointer;
      top--;
      return;
    }
  public:
    Stack(){top=0;}
    ~Stack(){top=0;}
    int Pop();       //������� ������ �� �����
    int Push(int d); //��������� ������ � ����    
    int Top();       //��������� ������� �����
    long Count(){return (top);}
};
//------------------------------------------------------------------------------
//������� ������ �� �����
int Stack::Pop()
{
  if (Stack::Count()==0) //���� ����
    return -1;
  int var=last->x;
  Delete();
  return (var);
}
//------------------------------------------------------------------------------
//��������� ������ � ����
int Stack::Push(int x) 
{
  pointer=last;
  last=new StructType;
  last->x=x;
  last->prev=pointer;
  top++;
  return x;
}
//------------------------------------------------------------------------------
//��������� ������� �����
int Stack::Top() 
{
  if (Count()==0)
    return -1;
  return (last->x);
}
Stack sort_stack;
//------------------------------------------------------------------------------
//�-��������� ������� ����������
void MQuickSort(int m, Stack stack)
{
  
  long count=stack.Count(),
       i, j; //��������
  //���� "stack" ������ ������� �� �+1 �����
  if (count<=2*m)
  {    
    Stack s[10];
    for (i=0;i<capacity;i++)
    {
      int p=pow(10,i);
      while (stack.Count()!=0)
      {
        for (j=0;j<=9;j++)
          if (stack.Top()/p%10==j)
          {
            s[j].Push(stack.Top());
            stack.Pop();
          }
      }
      for (j=9;j>=0;j--)
        while (s[j].Count()!=0)
        {
          stack.Push(s[j].Top());
          s[j].Pop();
        }
    }
    while (stack.Count()!=0)
    {
      sort_stack.Push(stack.Top());
      stack.Pop();
    }   
    return;
  }
  long k=m,  //�����, ������������ �������� "pos"
       pos;  //������� ���������� ��������
  int e[m];  //������ ��������� ��������� 
  Stack s[m+1], //������ ������
        tmp;    //��������������� ���� ("stack" ��� ��������� ���������)
  //�������� ����� "steck" �� ���� "tmp" � ��������� �������� "e[i]"
  for (i=0;i<=m;i++)
  {
    pos=k*(count+1)/(m+1); //������� ���������� ���������� ��������
    while (stack.Count()!=pos)
    {
      tmp.Push(stack.Top());
      stack.Pop();
    }
    if (k!=0)
      e[k-1]=stack.Top(); 
    stack.Pop();
    k--;
  }
  //���������� ��������� ��������� ��������� "e[i]"
  if (m!=1)
    for (i=0;i<m-1;i++)
      for (j=i+1;j<m;j++)
        if (e[i]>e[j])
        {
          long temp=e[i];
          e[i]=e[j];
          e[j]=temp;
        }
  //��������� ����� "steck" ��� ��������� ��������� (���� "tmp") �� M+1 ���� "s[i]"
  //� 1 ���� ������� �������� <e[0], �� 2 - <e[1], �� >=a[0] � �.�.
  while (tmp.Count()!=0)
  {
    j=0;
    while (j<m)
    {
      if (tmp.Top()<e[j])
      {
        s[j].Push(tmp.Top());
        tmp.Pop();    
        if (tmp.Count()==0)
          break;  
        j=0;
      }
      else 
        j++;
    }
    if (tmp.Count()==0)
      break;
    //������� ����� � ��������� ���� "s[m]"
    s[m].Push(tmp.Top());
    tmp.Pop(); 
  }  
  for (i=0;i<=m;i++)
  {
    //����������� ����� ������� ���������� ��� ������� ����� "s[i]" 
    if (s[i].Count()!=0)
      if (s[i].Count()==1)
        sort_stack.Push(s[i].Top());
      else
        MQuickSort(m, s[i]);
    if (i!=m)
      sort_stack.Push(e[i]);
  }
  return;
}
//------------------------------------------------------------------------------
//���������� "kol_stacks" ������ � "N" ���������� 
//(����� ��������� ���������: 1..M)
int SortStecks()
{
  int error=0; //��� ������ (0 - ��� ������)
  if (kol_stacks<1) error=1;
  if ((Mmin<1) | (Mmax<1)) error=2;
  if (N<2) error=3;
  if ((Mmin>N/2) | (Mmax>N/2)) error=4;
  if (Mmin>Mmax) error=5;
  if (step<1) error=6;
  switch (error)
  {
    case 1:
      printf("Fatal error 1: kol_stacks<1 (kol_stacks=%i)", kol_stacks);
      break;
    case 2:
      printf("Fatal error 2: Mmin<1 or Mmax<1 (Mmin=%i, Mmax=%i), step=%i", Mmin, Mmax);
      break;
    case 3:
      printf("Fatal error 3: N<2 (N=%i)", N);
      break;
    case 4:
      printf("Fatal error 4: Mmin>N/2 or Mmax>N/2 (Mmin=%i, Mmax=%i, N=%i)", Mmin, Mmax, N);
      break;
    case 5:
      printf("Fatal error 6: Mmin>Mmax (Mmin=%i, Mmax=%i)", Mmin, Mmax);
      break;
    case 6:
      printf("Fatal error 7: step<1 (step=%i)", step);
      break;
  }
  if (error!=0)
  {
    getch();
    exit(1);
  }
  if (capacity>5)
  {
    printf("Maxsimaze capacity = 5\nPress any key to continue with capacity = 5\n");

    getch();
  }
  long i, j;
  if (Mmin==Mmax)
    printf("Sorting %i stack(s) with %i numbers (M=%i)...", kol_stacks, N, Mmin);
  else
    printf("Sorting %i stack(s) with %i numbers (M=%i..%i), step=%i...", kol_stacks, N, Mmin, Mmax, step);
  FILE *out;
  out=fopen(out_file, "w");
  for (long mod=1;mod<=kol_stacks;mod++)
  {
    printf("\n\n-------Stack %i-------", mod);
    fprintf(out, "Stack %i", mod);
    clock_t start_sort, //������ ����������
            end_sort;   //���������� ����������
    float time_sort, best_time;
    long index=1;
    for (int m=Mmin;m<=Mmax;m+=step)
    {
      Stack stack;
      int p=pow(10, capacity);
      fprintf(out, "\n\nBefore sorting:         "); 
      for (i=0;i<N;i++)
      {
        stack.Push(rand()%p);
        fprintf(out, "%i ", stack.Top());
      }
      start_sort=clock();
      MQuickSort(m, stack); //���������� ����� "stack"
      end_sort=clock();
      fprintf(out, "\nAfter sorting with M=%i: ", m);
      while (sort_stack.Count()!=0)
      {
        fprintf(out, "%i ", sort_stack.Top());
        sort_stack.Pop();
      }
      time_sort=((float)(end_sort-start_sort))/CLOCKS_PER_SEC;
      if (m==Mmin)
        best_time=time_sort; 
      else
        if (time_sort<best_time)
        {
          best_time=time_sort;
          index=m;
        }    
      printf("\nM=%i: time=%0.3f sec", m, time_sort);
      fprintf(out, "\nThe time of sorting: %0.3f sec", time_sort);
    }
    printf("\nBest time with M=%i: %0.3f sec", index, best_time);
    fprintf(out, "\n\nBest time with M=%i: %0.3f sec", index, best_time);
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
  }
  fclose(out);
}
//------------------------------------------------------------------------------  
int main()
{
  clock_t start_prog, // ������ ������ ���������
          end_prog;   // ���������� ������ ���������
  start_prog=clock();
  SortStecks();
  end_prog=clock();
  float cpu_time_used=((float)(end_prog-start_prog))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %0.3f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\"");
  getch();
  return 0;
}
