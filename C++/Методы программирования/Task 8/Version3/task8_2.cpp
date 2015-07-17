//������� ���������� �� �������
//�����: ������� �. �.
//����: 17.05.05.
//����� ����������: Dev-Cpp 4.9.9.0

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define max_size 4000 
#define kol_stacks 10000  //����� ������
#define M 2          //����� ��������� ���������
#define N 10         //����� �����

#define out_file "output.txt"
#define res_file "result.txt"

long pop;
//� ������ "Stack" ����������� �������� �������� ��� ������
class Stack
{
  //���������� �������� ������ ������
  private: 
    int s[max_size]; //������ ��������� �����
    long top;        //������� �����
  //���������� �������� ������ ������
  public: 
    Stack(){top=0;}  //�����������
    ~Stack(){top=0;} //����������
    int Pop();                //������� ������ �� �����
    int Push(int x);          //��������� ������ � ����      
    int Top();                //��������� �������
    long Count(){return top;} //����� ��������� �����
};
//------------------------------------------------------------------------------
//������� ������ �� �����
int Stack::Pop()
{
  if (Stack::Count()==0) //���� ����
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//��������� ������ � ����
//x - ���������� ������
int Stack::Push(int x)
{
  if (top==max_size-1) //���� ����������
    return -1; 
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//��������� �������
int Stack::Top()
{
  if (Stack::Count()==0) //���� ����
    return -1; 
  return (s[top]);
}
//------------------------------------------------------------------------------
//�-��������� ������� ����������
int MQuickSort(FILE *out, int m, Stack stack)
{
  long count=stack.Count(),
       k=m,  //�����, ������������ �������� "pos"
       pos,  //������� ���������� ��������
       e[m], //������ ��������� ��������� 
       i, j; //��������    
  //���� "stack" ������ ������� �� �+1 �����
  if (count<2*m)
  {  
    //���� "stack" ������� �� 1 ��������
    if (count==1)
      fprintf(out, "%i ", stack.Top());
    else
    {
      //���������� ����� "stack" ������� ��������
      //��������� ����������: ���� "stack1"
      Stack stack1, stack2; //��������������� �����
      while (stack.Count()!=0)
      {    
        if ((stack1.Count()==0) | (stack1.Top()>stack.Top()))
        {
          stack1.Push(stack.Top());
          pop++;
          stack.Pop();
        }
        else
        {
          //"������������" �������� �� "steck1" � "steck2", ���� 
          //��������� ������� <stack.Top()
          while ((stack1.Top()<stack.Top()) & (stack1.Count()!=0))
          {
            stack2.Push(stack1.Top());
            pop++;
            stack1.Pop(); 
          }
          //��������� � "steck1" ������� stack.Top()
          stack1.Push(stack.Top());
          pop++;
          stack.Pop();
          //"������������" ��� �������� �� "steck2" � "steck1"
          while (stack2.Count()!=0)
          {
            stack1.Push(stack2.Top());
            pop++;
            stack2.Pop();
          }
        }
      }
      //����� ���������������� ����� � ��������� ����
      while (stack1.Count()!=0)
      {
        fprintf(out, "%i ", stack1.Top());
        pop++;
        stack1.Pop();
      }
    }
    return 0;
  }      
  Stack s[m+1], //������ ������
        tmp;    //��������������� ���� ("stack" ��� ��������� ���������)
  //�������� ����� "steck" �� ���� "tmp" � ��������� �������� "e[i]"
  for (i=0;i<=m;i++)
  {
    pos=k*(count+1)/(m+1); //������� ���������� ���������� ��������
    while (stack.Count()!=pos)
    {
      tmp.Push(stack.Top());
      pop++;
      stack.Pop();
    }
    if (k!=0)
      e[k-1]=stack.Top(); 
    pop++;
    stack.Pop();
    k--;
  }
  //���������� ��������� ��������� ��������� "e[i]"
  if (m!=1)
    for (i=0;i<m;i++)
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
        pop++;
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
    pop++;
    tmp.Pop(); 
  }  
  for (i=0;i<=m;i++)
  {
    //����������� ����� ������� ���������� ��� ������� ����� "s[i]"
    MQuickSort(out, m, s[i]);
    if (i!=m)
      //����� ���������� �������� � ��������� ����
      fprintf(out, "%i ", e[i]);
  }  
}  
//------------------------------------------------------------------------------
//���������� "kol_stacks" ������ � "N" ���������� 
//(����� ��������� ���������: 1..M)
int SortStecks()
{
  int error=0; //��� ������ (0 - ��� ������)
  if (kol_stacks<1) error=1;
  if (M<1) error=2;
  if (N<2) error=3;
  if (M>N/2) error=4;
  switch (error)
  {
    case 1:
      printf("Fatal error 1: kol_stacks<1 (kol_stacks=%i)", kol_stacks);
      break;
    case 2:
      printf("Fatal error 2: M<1 (M=%i)", M);
      break;
    case 3:
      printf("Fatal error 3: N<2 (N=%i)", N);
      break;
    case 4:
      printf("Fatal error 4: M>N/2 (M=%i, N=%i)", M, N);
      break;
  }
  if (error!=0)
  {
    getch();
    exit(1);
  } 
  FILE *out, *res;
  out=fopen(out_file, "w");
  res=fopen(res_file, "w");
  long i, pers=1000;  //����� ��������������� ������
  printf("Sorting %i stack(s) with %i numbers (M=%i)...\n", kol_stacks, N, M);
  long min_pop, index;
  for (long mod=1;mod<=kol_stacks;mod++)
  {
    if (mod==pers)
    {
      for (i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_stacks);
      pers+=1000;
    }
    int a[max_size];
    Stack stack;
    for (i=0;i<N;i++)
    {
      a[i]=rand()%(20);
      stack.Push(a[i]);
    } 
    fprintf(out, "Array %i\n", mod);
    fprintf(out, "Before sorting:         ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    fprintf(out, "\nAfter sorting with M=%i: ", M); 
    pop=0;
    MQuickSort(out, M, stack); //���������� ����� "stack"
    fprintf(out, "\nNumber of operation Pop(): %i", pop);
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
    if (mod==1)
    {
      min_pop=pop;
      index=1;
    }
    else
      if (pop<min_pop)
      {
        min_pop=pop;
        index=mod;
      }   
  }
  fprintf(res, "Minimaze number of operation Pop(): %i in array %i", min_pop, index);
  fclose(out);
  fclose(res);
  for (i=0;i<35;i++)
    printf("\b");
  printf("Sorting array: %i (%i)", kol_stacks, kol_stacks);
  printf("\n\nMinimaze number of operation Pop(): %i in array %i", min_pop, index);
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
  printf("\nThe time of program work: %0.3f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\""); 
  printf("\nOpen file \"result.txt\"");
  getch();
  return 0;
}
