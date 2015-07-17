/******************************************
 * В программе реализована процедура      *
 * преобразования префиксной записи числа *
 * в постфиксную и процедура вычисленя    *
 * постфиксного выражения                 *
 ******************************************
 * Автор: Дюгуров Сергей MK-301           *
 * Дата 30.11.04.                         *
 * Среда разработки: Borland C++ 3.1      *
 ******************************************/

#include <time.h>
#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include "test.cpp"
#define TElement float
#define MAX_SIZE 100 //максимальное количество элементов массива
//в классе "Stack" реализован основные действия над стеом
class Stack
{
  //объявление закрытых членов класса
  private:
    TElement s[MAX_SIZE]; //массив элементов стека
    int top; //вершина стека
  //объвление открытых членов класса
  public:
    Stack(){top=0;}  //конструктор
    ~Stack(){top=0;} //деструктор
    int Pop();  //
    int Push(TElement x); //извлечь данное из стека
    int IsEmpty(){return(top==0);} //поместить данное в стек
    TElement Top(); //проверка стека на пустоту
};
//------------------------------------------------------------------------------
//извлечь данное из стека
int Stack::Pop()
{
  if (Stack::IsEmpty()) //стек пуст
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//поместить данное в стек
//x - помещаемое данное
int Stack::Push(TElement x)
{
  if (top==MAX_SIZE-1) //стек переполнен
    return -1;
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//прочитать вершину
TElement Stack::Top()
{
  if (Stack::IsEmpty()) //стек пуст
    return -1;
  return (s[top]);
}
//==============================================================================
//функция вычисления постфиксного выражения
//sim - строка, содержащяя постфиксную запись выражения
//kol_sim - длина строки "sim"
int Calculation(char sim[MAX_SIZE], int kol_sim)
{
  char sim2[MAX_SIZE], //массив символов из "expression.txt" (со 2 строки)
       input[MAX_SIZE], //массив символов из "expression.txt"
       variable[MAX_SIZE], //массив переменных
       value_char[MAX_SIZE][MAX_SIZE]; //массив значений типа "char"
  int i, j, k,  //счётчики
      kol_var,  //количество переменных
      kol_sim2, //количесиво символов в строке "sim2"
      flag;
  float value_float[MAX_SIZE], //массив значений типа "int"
        //элементы стека над которыми производится арифметическое действие
        element1, element2, element;
  double real,    //дробная часть числа
         integer; //целая часть числа
  printf("postfix: ");
  for (i=0;i<kol_sim;i++)
  {
    switch (sim[i])
    {
      case '0':
        printf("sin ");
        break;
      case '1':
        printf("cos ");
        break;
      case '2':
        printf("tan ");
        break;
      case '3':
        printf("cot ");
        break;
      case '4':
        printf("asin ");
        break;
      case '5':
        printf("acos ");
        break;
      case '6':
        printf("atan ");
        break;
      case '7':
        printf("acot ");
        break;
      case '8':
        printf("exp ");
        break;
      case '9':
        printf("ln ");
        break;
      case '#':
        printf("sqrt3 ");
        break;
      case '%':
        printf("sqrt ");
        break;
      case '$':
        printf("abs ");
        break;
      default:
        if ((sim[i]!='|') & (sim[i]!=' '))
        printf("%c ", sim[i]);
        break;
    }
  }
  printf("\n");
  FILE *file;
  //открыть файл "expression.txt" на чтение
  file=fopen("expres~1.txt","r");
  j=flag=0;
  while(!feof(file)) //пока не достигнут конец файла "expression.txt"
  {
    //посимвольное чтение из файла "expression.txt"
    input[i]=fgetc(file);
    if (input[i]=='\n')
      flag=1;
    if ((flag==1) & (input[i]!=' '))
      printf("%c", input[i]);
    //в массив "sim2" будут записаны символы начиная со 2 строки
    if ((flag==1) & (input[i]!='\n') & (input[i]!=' '))
    {
      sim2[j]=input[i];
      j++;
    }
    i++;
  }
  fclose(file); //закрытие файла "exprssion.txt"
  kol_sim2=--j;
  TestSimbols(2, sim2, kol_sim2); //"тестирование" символов "sim2"
  j=-1;
  k=0;
  for (i=0;i<kol_sim2;i++)
  {
    if ((sim2[i]>=97) & (sim2[i]<=122)) //латинская буква
    {
      j++;
      k=0;
      variable[j]=sim2[i];
    }
    //цифра, "." или "-"
    if (((sim2[i]>=48) & (sim2[i]<=57)) | (sim2[i]=='.') | (sim2[i]=='-'))
    {
      value_char[j][k]=sim2[i];
      k++;
    }
  }
  kol_var=++j;
  for (i=0;i<kol_var;i++)
    //перевод строки, содержащей символьное представление целого или
    //вещественного числа в соответствующее вещественное число
    value_float[i]=atof(value_char[i]);
  for (i=0;i<kol_sim;i++)
    if ((sim[i]>=97) & (sim[i]<=122)) //латинсая буква
    {
      flag=0;
      for (j=0;j<kol_var;j++)
        if (sim[i]==variable[j])
        {
          flag=1;
          break;
        }
      if (flag==0)
      {
        printf("\nНеобъявлена переменная: \"%c\"", sim[i]);
        getch();
        exit(1);
      }
    }
  printf("\nПожалуйста, подождите...");
  Stack stack;
  for (i=0;i<kol_sim;i++)
  {
    if ((sim[i]>=97) & (sim[i]<=122)) //латинская буква
      for (j=0;j<kol_var;j++)
        if (sim[i]==variable[j])
          stack.Push(value_float[j]);
    //знак математической операции
    if ((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^'))
    {
      element2=stack.Top(); //в "element2" помещается вершинный элемент
      stack.Pop();          //извлечение вершинного элемента из стека
      element1=stack.Top(); //в "element2" помещается вершинный элемент
      stack.Pop();          //извлечение вершинного элемента из стека
    }
    else if ((sim[i]=='0') | (sim[i]=='1') | (sim[i]=='2') | (sim[i]=='3') | (sim[i]=='4') |
      (sim[i]=='5') | (sim[i]=='6') | (sim[i]=='7') | (sim[i]=='8') | (sim[i]=='9') |
        (sim[i]=='%') | (sim[i]=='#') | (sim[i]=='$'))
        {
          element=stack.Top(); //в "element" помещается вершинный элемент
          stack.Pop();
        }
    //математическая операия
    if ((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^') | (sim[i]=='0') |
      (sim[i]=='1') | (sim[i]=='2') | (sim[i]=='3') | (sim[i]=='4') | (sim[i]=='5') | (sim[i]=='6') |
        (sim[i]=='7') | (sim[i]=='8') | (sim[i]=='9') | (sim[i]=='%') | (sim[i]=='#') | (sim[i]=='$'))
        {
          switch (sim[i])
          {
            case '+':
              stack.Push(element1+element2);
              break;
            case '-':
              stack.Push(element1-element2);
              break;
            case '*':
              stack.Push(element1*element2);
              break;
            case '/':
              if (element2==0)
              {
                printf("\nДеление на 0");
                getch();
                exit(1);
              }
              stack.Push(element1/element2);
              break;
            case '^':
              stack.Push(pow(element1, element2));
              break;
            case '0': //sin
              stack.Push(sin(element));
              break;
            case '1': //cos
              stack.Push(cos(element));
              break;
            case '2': //tan
              stack.Push(tan(element));
               break;
            case '3': //cot
              if (tan(element==0))
              {
                printf("\nДеление на 0");
                getch();
                exit(1);
              }
              stack.Push(1/(tan(element)));
              break;
            case '4': //asin
              stack.Push(asin(element));
              break;
            case '5': //acos
              stack.Push(acos(element));
              break;
            case '6': //atan
              stack.Push(atan(element));
              break;
            case '7': //acot
              stack.Push(atan(1/element));
              break;
            case '8': //exp
              stack.Push(exp(element));
              break;
            case '9': //ln
              stack.Push(log10(element));
              break;
            case '%': //sqrt
              stack.Push(sqrt(element));
              break;
            case '#': //sqrt3
              double p;
              for (p=-1000; p<=1000; p+=0.01)
                if (pow(p,3)==element)
                  stack.Push(p);
                else if ((pow(p,3)<element) & (pow(p+0.01,3)>element))
                  stack.Push(p);
            case '$': //abs
              //stack.Push(abs(element));
              break;
          }
        }
  }
  real=modf(stack.Top(),&integer); //разбиение элемента на елую и дробную часть
  if (real==0)
    printf("\nРезультат: %0.0f", integer);
  else
    printf("\nРезультат: %-0.5f", stack.Top());
  return 0;
}
//==============================================================================
//функйия нахождения последней математической операции
//prior - приоритет операии
//sim - строка, содержащяя запись выражения
//kol_sim - количество символов в "sim"
int LastOperation(int prior, char sim[MAX_SIZE] , int kol_sim)
{
  int kol1, kol2, //количество символов "(" и ")" слева от операии
      kol3, kol4, //количество символов "(" и ")" справа от операии
      pos,        //позиия последней операии
      k, i, j;    //счётчики
  //операции, соответствующие заданному приоритету
  char op1,
       op2;
  switch (prior)
  {
    case 1:
      op1='+';
      op2='-';
      break;
    case 2:
      op1='*';
      op2='/';
      break;
    case 3:
      op1='^';
      op2='^';
      break;
  }
  //----------------------------------------------------------------------------
  if ((prior==1) | (prior==2) | (prior==3))
  {
    pos=0;
    for (j=0;j<kol_sim;j++)
      if ((sim[j]==op1) | (sim[j]==op2))
      {
        kol1=kol2=0;
        for (k=0;k<j;k++)
        {
          if (sim[k]=='(')
            kol1++;
          if (sim[k]==')')
            kol2++;
        }
        kol3=kol4=0;
        for (k=j+1;k<kol_sim;k++)
        {
          if (sim[k]=='(')
            kol3++;
          if (sim[k]==')')
            kol4++;
        }
        if ((kol1==kol2) & (kol3==kol4))
          pos=j;
      }
  }
  //----------------------------------------------------------------------------
  if (prior==4)
  {
    pos=0;
    for (j=0;j<kol_sim;j++)
      if ((sim[j]=='0') | (sim[j]=='1') | (sim[j]=='2') | (sim[j]=='3') |
        (sim[j]=='4') | (sim[j]=='5') | (sim[j]=='6') | (sim[j]=='7') |
          (sim[j]=='8') | (sim[j]=='9') | (sim[j]=='%') | (sim[j]=='#') | (sim[j]=='$'))
          {
            kol1=kol2=0;
            for (k=0;k<j;k++)
            {
              if (sim[k]=='(')
                kol1++;
              if (sim[k]==')')
              kol2++;
            }
            kol3=kol4=0;
            for (k=j+1;k<kol_sim;k++)
            {
              if (sim[k]=='(')
                kol3++;
              if (sim[k]==')')
                kol4++;
            }
            if ((kol1==kol2) & (kol3==kol4))
              pos=j;
          }
  }
  return pos;
}
//==============================================================================
//функия преобразования префиксной записи числа в постфисную
//sim - строка, содержащяя префиксную запись выражения
//kol_sim - количество символов в "sim"
char *postfix(char sim[MAX_SIZE] , int kol_sim)
{
  char segm[MAX_SIZE][MAX_SIZE], //сегменты, на которые разбивается "sim"
       last_operation; //последняя математическая операцмя
  int i, j, k,   // счётчики
      kol_segm,  //количество всех сегментов
      kol_1segm, //количество сегментов длины 1
      kol,       //количество символов "(" и ")"
      kol1,      //количество символов "("
      kol2,      //количество символов ")"
      pos,       //позийия последней матаматической операции
      flag, flag1, flag2, //переменные принимающиие 2 значения:
                          //1 - верно, 2 - неверно
      kol_sim_segm[MAX_SIZE];//количество элементов соответствующего сегмента
  for (i=0;i<kol_sim-4;i++)
  {
    if ((sim[i]=='s') & (sim[i+1]=='i') & (sim[i+2]=='n')) //sin
    {
      sim[i+2]='0';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='c') & (sim[i+1]=='o') & (sim[i+2]=='s')) //cos
    {
      sim[i+2]='1';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='t') & (sim[i+1]=='a') & (sim[i+2]=='n')) //tan
    {
      sim[i+2]='2';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='c') & (sim[i+1]=='o') & (sim[i+2]=='t')) //cot
    {
      sim[i+2]='3';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='s') & (sim[i+2]=='i') & (sim[i+3]=='n')) //asin
    {
      sim[i+3]='4';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='c') & (sim[i+2]=='o') & (sim[i+3]=='s')) //acos
    {
      sim[i+3]='5';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='t') & (sim[i+2]=='a') & (sim[i+3]=='n')) //atan
    {
      sim[i+3]='6';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='c') & (sim[i+2]=='o') & (sim[i+3]=='t')) //acot
    {
      sim[i+3]='7';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='e') & (sim[i+1]=='x') & (sim[i+2]=='p')) //exp
    {
      sim[i+2]='8';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='l') & (sim[i+1]=='n')) //ln
    {
      sim[i+1]='9';
      sim[i]='|';
    }
    if ((sim[i]=='s') & (sim[i+1]=='q') & (sim[i+2]=='r') & (sim[i+3]=='t') & (sim[i+4]=='3')) //sqrt3
    {
      sim[i+4]='#';
      sim[i]=sim[i+1]=sim[i+2]=sim[i+3]='|';
    }
    if ((sim[i]=='s') & (sim[i+1]=='q') & (sim[i+2]=='r') & (sim[i+3]=='t')) //sqrt
    {
      sim[i+3]='%';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='b') & (sim[i+2]=='s')) //abs
    {
      sim[i+2]='$';
      sim[i]=sim[i+1]='|';
    }
  }
  j=k=0;
  kol_sim_segm[0]=0;
  //разбиение "sim" на сегменты (части строки разделённые пробелом)
  for (i=0;i<kol_sim;i++)
  {
    if (sim[i]!=' ')
    {
      segm[j][k]=sim[i];
      kol_sim_segm[j]++;
    }
    else
    {
      if ((sim[i+1]!=' ') & (i!=kol_sim-1))
        kol_sim_segm[++j]=0;
      k=-1;
    }
    k++;
  }
  kol_segm=++j;
  kol_1segm=0;
  for (i=0;i<kol_segm;i++)
  {
    if (kol_sim_segm[i]==1)
      kol_1segm++;
  }
  if (kol_1segm==kol_segm)
  {
    Calculation(sim, kol_sim); //функция вычисления постфиксного выражения
    return (sim);
  }
  //поиск последней математической операции в каждом сегменте
  for (i=0;i<kol_segm;i++)
  {
    pos=LastOperation(1, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(2, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(3, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(4, segm[i], kol_sim_segm[i]);
    //последняя операция не найдена
    if ((pos==0) & (kol_sim_segm[i]>1) & (segm[i][0]!='|'))
    {
      printf("Не найдена последняя операия в segm[%i]: \"", i);
      for (j=0;j<kol_sim_segm[i];j++)
        printf("%c", segm[i][j]);
      printf("\"");
      if ((segm[i][0]=='(') & (segm[i][strlen(segm[i])-1]==')'))
        printf("\nDelete simbols: \"(\"(#%i) & \")\"(#%i)", 0, strlen(segm[i])-1);
      getch();
      exit(1);
    }
    last_operation=segm[i][pos];
    kol1=kol2=0;
    for (j=0;j<kol_sim_segm[i];j++)
    {
      if (segm[i][j]=='(')
        kol1++;
      if (segm[i][j]==')')
        kol2++;
    }
    //в сегменте "segm[i]" нет скобок
    if ((kol1==0) & (kol2==0))
      flag=0;
    //в сегменте "segm[i]" есть скобки
    else
      flag=1;
    //--------------------------------------------------------------------------
    if (flag==0) //в сегменте "segm[i]" нет скобок
    {
      if ((kol_sim_segm[i]>1) & (i!=kol_sim-1))
      {
        kol_sim_segm[i]+=3;
        segm[i][kol_sim_segm[i]-1]=' ';
        segm[i][kol_sim_segm[i]-2]=segm[i][pos];
        segm[i][kol_sim_segm[i]-3]=' ';
        segm[i][pos]=' ';
      }
      if (kol_sim_segm[i]==1)
      {
        kol_sim_segm[i]++;
        segm[i][kol_sim_segm[i]-1]=' ';
      }
    }
    //--------------------------------------------------------------------------
    if (flag==1) //в сегменте "segm[i]" есть скобки
    {
      //( ... ) last_operation ...
      if ((segm[i][0]=='(') & (segm[i][pos-1]==')'))
      {
        flag1=flag2=1;
        kol=0; //количество символов "(" и ")"
        for (j=1;j<pos-1;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0; //количество символов "(" и ")"
        for (j=pos-1;j>1;j--)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]=='(') & (kol==1))
              flag2=0;
          }
        }
        //внешние скобки можно убрать
        if ((flag1==1) & (flag2)==1)
        {
          segm[i][0]=' ';
          segm[i][pos-1]=' ';
        }
      }
      //------------------------------------------------------------------------
      //... last_operation ( ... )
      if ((segm[i][pos+1]=='(') & (segm[i][kol_sim_segm[i]-1]==')'))
      {
        flag1=flag2=1;
        kol=0;
        for (j=pos+2;j<kol_sim_segm[i]-2;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0;
        for (j=kol_sim_segm[i];j>pos+2;j--)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]=='(') & (kol==1))
              flag2=0;
          }
        }
        //внешние скобки можно убрать
        if ((flag1==1) & (flag2)==1)
        {
          segm[i][pos+1]=' ';
          segm[i][kol_sim_segm[i]-1]=' ';
        }
      }
      kol_sim_segm[i]+=3;
      segm[i][pos]=' ';
      segm[i][kol_sim_segm[i]-1]=' ';
      segm[i][kol_sim_segm[i]-2]=last_operation;
      segm[i][kol_sim_segm[i]-3]=' ';
    }
  }
  //----------------------------------------------------------------------------
  //объединение всех преобразованных сегментов
  i=0;
  for(j=0;j<kol_segm;j++)
    for(k=0;k<kol_sim_segm[j];k++)
      sim[i++]=segm[j][k];
  kol_sim=i;
  return (postfix(sim, kol_sim)); //рекурсивный вызов "postfix()"
}
//==============================================================================
//основная функия
int main()
{
  char sim[MAX_SIZE],   //массив символов выражения
       input[MAX_SIZE]; //массив символов "expesion.txt" (1 строка)
  int i,j; //счётчики
  i=j=0;
  FILE *file;
  //открытие файла "expression.txt" на чтение
  file=fopen("expres~1.txt","r");
  if (file==NULL)
  {
    puts("Ошибка открытия файла \"expression.txt\" на чтение");
    getch();
    return -1;
  }
  printf("prefix:  ");
  while(!feof(file)) //пока не достигнт оне фала  файла "expression.txt"
  {
    //посимвольное чтение из файла "expression.txt"
    input[i]=fgetc(file);
    if(input[i]=='\n')
      break;
    if (input[i]!=' ')
    {
      sim[j]=input[i];
      j++;
    }
    i++;
  }
  fclose(file); //закрытие файла "expression.txt"
  int kol_sim=j;
  for (i=0;i<kol_sim;i++)
    printf("%c", sim[i]);
  TestSimbols(1, sim, kol_sim); //"тестирование" символов "sim"
  printf("\n");
  postfix(sim, kol_sim); //преобразование префиксной записи числа в постфиксную
  getch();
  return 0;
}
