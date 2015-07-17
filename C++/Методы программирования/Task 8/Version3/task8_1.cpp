//Быстрая сортировка со стеками
//Автор: Дюгуров С. М.
//Дата: 18.05.05.
//Среда разработки: Dev-Cpp 4.9.9.0

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define max_size 4000 
#define kol_stacks 20  //число стеков
#define M 5            //число эталонных элементов
#define N 4000         //длина стека

#define out_file "output.txt"
#define res_file "result.txt"

long pop;
//в классе "Stack" реализованы основные действия над стеком
class Stack
{
  //объявление закрытых членов класса
  private: 
    int s[max_size]; //массив элементов стека
    long top;        //вершина стека
  //объявление открытых членов класса
  public: 
    Stack(){top=0;}  //конструктор
    ~Stack(){top=0;} //деструктор
    int Pop();                //извлечь данное из стека
    int Push(int x);          //поместить данное в стек      
    int Top();                //прочитать вершину
    long Count(){return top;} //число элементов стека
};
//------------------------------------------------------------------------------
//извлечь данное из стека
int Stack::Pop()
{
  if (Stack::Count()==0) //стек пуст
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//поместить данное в стек
//x - помещаемое данное
int Stack::Push(int x)
{
  if (top==max_size-1) //стек переполнен
    return -1; 
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//прочитать вершину
int Stack::Top()
{
  if (Stack::Count()==0) //стек пуст
    return -1; 
  return (s[top]);
}
//------------------------------------------------------------------------------
//М-эталонная быстрая сортировка
int MQuickSort(FILE *out, int m, Stack stack)
{
  long count=stack.Count(),
       k=m,  //число, определяющее значение "pos"
       pos,  //позиция эталонного элнмента
       e[m], //массив эталонных элементов 
       i, j; //счётчики    
  //стек "stack" нельзя разбить на М+1 часть
  if (count<2*m)
  {  
    //стек "stack" состоит из 1 элемента
    if (count==1)
      fprintf(out, "%i ", stack.Top());
    else
    {
      //сортировка стека "stack" простой вставкой
      //результат сортировки: стек "stack1"
      Stack stack1, stack2; //вспомогательные стеки
      while (stack.Count()!=0)
      {    
        if ((stack1.Count()==0) | (stack1.Top()>stack.Top()))
        {
          stack1.Push(stack.Top());
          stack.Pop();
          pop++;
        }
        else
        {
          //"перекидываем" элементы из "steck1" в "steck2", пока 
          //вершинный элемент <stack.Top()
          while ((stack1.Top()<stack.Top()) & (stack1.Count()!=0))
          {
            stack2.Push(stack1.Top());
            stack1.Pop(); 
            pop++;
          }
          //вставляем в "steck1" эдемент stack.Top()
          stack1.Push(stack.Top());
          stack.Pop();
          pop++;
          //"перекидываем" все элементы из "steck2" в "steck1"
          while (stack2.Count()!=0)
          {
            stack1.Push(stack2.Top());
            stack2.Pop();
            pop++;
          }
        }
      }
      //вывод отсортированного стека в текстовый файл
      while (stack1.Count()!=0)
      {
        fprintf(out, "%i ", stack1.Top());
        stack1.Pop();
        pop++;
      }
    }
    return 0;
  }      
  Stack s[m+1], //массив стеков
        tmp;    //вспомогательный стек ("stack" без эталонных элементов)
  //разбитие стека "steck" на стек "tmp" и эталонные элементы "e[i]"
  for (i=0;i<=m;i++)
  {
    pos=k*(count+1)/(m+1); //позиция очередного эталонного элемента
    while (stack.Count()!=pos)
    {
      tmp.Push(stack.Top());
      stack.Pop();
      pop++;
    }
    if (k!=0)
      e[k-1]=stack.Top(); 
    stack.Pop();
    pop++;
    k--;
  }
  //сортировка пузырьком эталонных элементов "e[i]"
  if (m!=1)
    for (i=0;i<m;i++)
      for (j=i+1;j<m;j++)
        if (e[i]>e[j])
        {
          long temp=e[i];
          e[i]=e[j];
          e[j]=temp;
        }
  //разбиение стека "steck" без эталонных элементов (стек "tmp") на M+1 стек "s[i]"
  //в 1 стек попадут элементы <e[0], во 2 - <e[1], но >=a[0] и т.д.
  while (tmp.Count()!=0)
  {
    j=0;
    while (j<m)
    {
      if (tmp.Top()<e[j])
      {
        s[j].Push(tmp.Top());
        tmp.Pop(); 
        pop++;     
        if (tmp.Count()==0)
          break;  
        j=0;
      }
      else 
        j++;
    }
    if (tmp.Count()==0)
      break;
    //элемент попал в последний стек "s[m]"
    s[m].Push(tmp.Top());
    tmp.Pop(); 
    pop++;
  }  
  for (i=0;i<=m;i++)
  {
    //рекурсивный вызов быстрой сортировки для каждого стека "s[i]"
    MQuickSort(out, m, s[i]);
    if (i!=m)
    {
      //вывод эталонного элемента в текстовый файл
      fprintf(out, "%i ", e[i]);
    }  
  }  
}  
//------------------------------------------------------------------------------
//сортировка "kol_stacks" стеков с "N" элементами 
//(число эталонных элементов: 1..M)
int SortStecks()
{
  int error=0; //код ошибки (0 - нет ошибок)
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
  long i, pers=1;  //число отсортированных стеков
  if (M==1)
    printf("Sorting %i stack(s) with %i numbers (M=1)...\n", kol_stacks, N);
  else
    printf("Sorting %i stack(s) with %i numbers (M=1..%i)...\n", kol_stacks, N, M);
  for (long mod=1;mod<=kol_stacks;mod++)
  {
    if (mod==pers)
    {
      for (i=0;i<35;i++)
        printf("\b");
      printf("Sorting array: %i (%i)", mod, kol_stacks);
      pers+=1;
    }
    int a[max_size];
    Stack stack;
    for (i=0;i<N;i++)
    {
      a[i]=rand()%(10*kol_stacks+i);
      stack.Push(a[i]);
    } 
    fprintf(out, "Array %i\n", mod);
    fprintf(out, "Before sorting:         ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    fprintf(out, "\n");
    clock_t start_sort, //начало сортировки
            end_sort;   //завершение сортировки
    float time_sort, best_time;
    long min_pop,
         index1=1, index2=1;
    for (int m=1;m<=M;m++)
    {
      fprintf(out, "\nAfter sorting with M=%i: ", m);
      start_sort=clock();
      pop=0;
      MQuickSort(out, m, stack); //сортировка стека "stack"
      end_sort=clock();
      time_sort=((float)(end_sort-start_sort))/CLOCKS_PER_SEC;
      if (m==1)
      {
        best_time=time_sort;
        min_pop=pop;
      }  
      else
      {
        if (time_sort<best_time)
        {
          best_time=time_sort;
          index1=m;
        }
        if (pop<min_pop)
        {
          if (time_sort==best_time)
            index1=m;
          min_pop=pop;
          index2=m;
        }   
      }  
      fprintf(out, "\nThe time of sorting: %0.3f sec", time_sort);
      fprintf(out, "\nNumber of operation Pop(): %i", pop);
    }
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
    fprintf(res, "Array %i\n", mod);
    fprintf(res, "Best time with M=%i: %0.3f sec\n", index1, best_time);
    fprintf(res, "Minimaze number of operation Pop() with M=%i: %i", index2, min_pop);
    fprintf(res, "\n----------------------------------------");
    fprintf(res, "----------------------------------------\n");
  }
  fclose(out);
  fclose(res);
  for (i=0;i<35;i++)
    printf("\b");
  printf("Sorting array: %i (%i)", kol_stacks, kol_stacks);
}
//------------------------------------------------------------------------------  
int main()
{
  clock_t start_prog, // начало работы программы
          end_prog;   // завершение работы программы
  start_prog=clock();
  SortStecks();
  end_prog=clock();
  float cpu_time_used=((float)(end_prog-start_prog))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %0.3f sec", cpu_time_used);
  printf("\nOpen file \"output.txt\""); 
  printf("\nOpen file \"result.txt\"");
  getch();
  return 0;
}
