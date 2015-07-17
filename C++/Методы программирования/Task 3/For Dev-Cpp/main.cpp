/******************************************
 * В программе реализована процедура      *
 * преобразования префиксной записи числа *
 * в постфиксную и процедура вычисления   *
 * постфиксного выражения                 *
 ******************************************
 * Автор: Дюгуров Сергей MK-301           *
 * Дата: 25.11.04                         *
 * Среда разработки: Dev-Cpp 4.9.9.0.     *
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

//в классе "Stack" реализованы основные действия над стеком
class Stack
{
  //объявление закрытых членов класса
  private: 
    TElement s[MAX_SIZE]; //массив элементов стека
    int top; //вершина стека
  //объявление открытых членов класса
  public: 
    Stack(){top=0;}  //конструктор
    ~Stack(){top=0;} //деструктор
    int Pop();  //извлечь данное из стека
    int Push(TElement x); //поместить данное в стек
    int IsEmpty(){return(top==0);} //проверка стека на пустоту       
    TElement Top(); //прочитать вершину
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
//sim - строка в которой содержится постфиксная запись выражения
//kol_sim - длина строки "sim"
int Calculation(char sim[MAX_SIZE], int kol_sim)
{
  char sim2[MAX_SIZE], //массив символов из "expression.txt" (со 2 строки)
       input[MAX_SIZE], //массив символов из "expression.txt"
       variable[MAX_SIZE], //массив переменных
       value_char[MAX_SIZE][MAX_SIZE]; //массив значений типа "char"
  int i, j, k,  //счётчики
      kol_var,  //количество переменных
      kol_sim2, //количество символов в строке "sim2"
      flag;     
  float value_float[MAX_SIZE], //массив значений типа "int"
        //элементы стека, над которыми производится арифметическое действие
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
      case'2':
        printf("tan ");
        break;
      case'3':
        printf("cot ");
        break;
      case'4':
        printf("asin ");
        break;
      case'5':
        printf("acos ");
        break;
      case'6':
        printf("atan ");
        break;
      case'7':
        printf("acot ");
        break;
      case'8':
        printf("exp ");
        break;
      case'9':
        printf("ln ");  
        break;
      case'#':
        printf("sqrt3 ");
        break;
      case'%':
        printf("sqrt ");
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
    if ((flag==1) & (input[i]!=' ') & (input[i]!='\n'))
    {
      sim2[j]=input[i];
      j++;
    }
    i++;    
  }   
  fclose(file); //закрытие файла "expression.txt"
  kol_sim2=--j;
  TestSimbols(2, sim2, kol_sim2);
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
    if ((sim[i]>=97) & (sim[i]<=122)) //латинская буква
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
        printf("\nNot declaration simbol \"%c\"", sim[i]);
        getch();
        exit(1);
      }
    }
  printf("\nLoading...");
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
      stack.Pop();          //извлечь вершинный элемент из стека
      element1=stack.Top(); //в "element1" помещается вершинный элемент
      stack.Pop();          //извлечь вершинный элемент из стека
    }    
    else if ((sim[i]=='0') | (sim[i]=='1') | (sim[i]=='2') | (sim[i]=='3') | (sim[i]=='4') | 
      (sim[i]=='5') | (sim[i]=='6') | (sim[i]=='7') | (sim[i]=='8') | (sim[i]=='9') |
        (sim[i]=='%') | (sim[i]=='#'))
        {
          element=stack.Top(); //в "element" помещается вершинный элемент
          stack.Pop(); 
        }    
    //математическая операция
    if ((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^') | (sim[i]=='0') | 
      (sim[i]=='1') | (sim[i]=='2') | (sim[i]=='3') | (sim[i]=='4') | (sim[i]=='5') | (sim[i]=='6') | 
        (sim[i]=='7') | (sim[i]=='8') | (sim[i]=='9') | (sim[i]=='%') | (sim[i]=='#'))
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
                printf("\nDivision by zero");
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
                printf("\nDivision by zero");
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
              stack.Push(pow(element,0.3333333333));
          }
        }    
  }
  real=modf(stack.Top(),&integer); //разбиение элемента на дробную и целую части
  if (real==0)
    printf("\nResult: %0.0f", integer);
  else
    printf("\nResult: %-0.8f", stack.Top());
  return 0;
}
//==============================================================================
int LastOperation(int prior, char sim[MAX_SIZE] , int kol_sim)
{
  int kol1, kol2, //количество "(" и ")" слева от операции
      kol3, kol4, //количество "(" и ")" справа от операции
      pos,     //позиция последней операции
      k, i, j; //счётчики
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
          (sim[j]=='8') | (sim[j]=='9') | (sim[j]=='%') | (sim[j]=='#'))
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
//функция преобразования префиксной записи числа в постфиксную
//sim - строка в которой содержится префиксная запись выражения
//kol_sim - длина строки "sim"
char *postfix(char sim[MAX_SIZE] , int kol_sim)
{
  char segm[MAX_SIZE][MAX_SIZE], //сегменты, на которые разбивается "sim"
       last_operation;
  int i, j, k,   //счётчики
      kol_segm,  //количество всех сегментов
      kol_1segm, //количество сегментов длины 1
      kol,       //количество символов "(" или ")"
      kol1,      //количество символов "("
      kol2,      //количество символов ")"
      pos,       //позиция последней операции
      flag, flag1, flag2; //переменные, принимающая 2 значения (1 - верно, 0 - неверно)
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
  }
  j=k=0;
  //разбиение "sim" на сегменты (части строки, разделённые пробелом)
  for (i=0;i<kol_sim;i++)
  {
    if (sim[i]!=' ')
      segm[j][k]=sim[i];
    else
    {
      k=-1;
      if (sim[i+1]!=' ')
        if (i!=kol_sim-1)
          j++;
    }
    k++;
  }
  kol_segm=++j;
  kol_1segm=0;
  for (i=0;i<kol_sim;i++)
  {  
    if (strlen(segm[i])==1)
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
    pos=LastOperation(1, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(2, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(3, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(4, segm[i], strlen(segm[i]));
    if ((pos==0) & (strlen(segm[i])>1) & (segm[i][0]!='|') ) //не найдена поледняя операция
    {
      printf("Unknown simbols: \"", i);
      for (j=0;j<strlen(segm[i]);j++)
        printf("%c", segm[i][j]);
      printf("\"");
      if ((segm[i][0]=='(') & (segm[i][strlen(segm[i])-1]==')'))
        printf("\nDelete simbols: \"(\"(#%i) & \")\"(#%i)", 0, strlen(segm[i])-1);
      getch();
      exit(1);
    }
    last_operation=segm[i][pos];
    kol1=kol2=0;
    for (j=0;j<strlen(segm[i]);j++)
    {
      if (segm[i][j]=='(')
        kol1++;
      if (segm[i][j]==')')
        kol2++;
    }
    //в сегменте segm[i] нет скобок
    if ((kol1==0) & (kol2==0))
      flag=0;
    //в сегменте segm[i] есть скобоки  
    else 
      flag=1;
    //--------------------------------------------------------------------------  
    if (flag==0) //в сегменте segm[i] нет скобок
    {
      if ((strlen(segm[i])>1) & (i!=kol_sim-1))
      {
        char s[]="   ";
        strcat(segm[i], s); //добавление строки "segm[i]" к "s"
        segm[i][strlen(segm[i])-2]=segm[i][pos];
        segm[i][pos]=' ';
      }
      if (strlen(segm[i])==1)
      {
        char s[]=" ";
        strcat(segm[i], s); //добавление строки "segm[i]" к "s"
      }
    }
    //--------------------------------------------------------------------------
    if (flag==1) //в сегменте segm[i] есть скобоки
    {
      //( ... ) last_operation ...
      if ((segm[i][0]=='(') & (segm[i][pos-1]==')'))
      {
        flag1=flag2=1;
        kol=0; //количество символов "(" или ")"
        for (j=1;j<pos-1;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0; //количество символов "(" или ")"
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
      if ((segm[i][pos+1]=='(') & (segm[i][strlen(segm[i])-1]==')')) 
      {
        flag1=flag2=1;
        kol=0;
        for (j=pos+2;j<strlen(segm[i])-2;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0;
        for (j=strlen(segm[i]);j>pos+2;j--)
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
          segm[i][strlen(segm[i])-1]=' ';
        }    
      }          
      char s[]="   ";
      strcat(segm[i], s); //добавление строки "segm[i]" к "s"
      segm[i][pos]=' ';
      segm[i][strlen(segm[i])-2]=last_operation;
    }     
  }
  //----------------------------------------------------------------------------
  //соединение всех сегментов в один
  for (i=kol_segm;i>0;i--)
    strcat(segm[i-1],segm[i]); //добавление строки "segm[i-1]" к "segm[i]"
  kol_sim=strlen(segm[0]);
  return (postfix(segm[0], kol_sim)); //рекурсивный вызов функции "postfix()"
}
//==============================================================================
//основная функция
int main()
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock();
  char sim[MAX_SIZE],   //массив символов выражения
       input[MAX_SIZE]; //массив символов "expression.txt" (1 строка)
  int i,j; //счётчики
  i=j=0;
  FILE *file;
  //открыть файл "expression.txt" на чтение
  file=fopen("expres~1.txt","r");
  if (file==NULL)
  {
    puts("Error: the file \"expression.txt\" is not opened ");
    getch();
    return -1;
  }
  printf("prefix:  ");
  while(!feof(file)) //пока не достигнут конец файла "expression.txt"
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
  TestSimbols(1, sim, kol_sim); //"тестирование" символов
  printf("\n");
  postfix(sim, kol_sim); //преобразования префиксной записи числа в постфиксную
  end=clock();
  //время работы программы
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\n\nThe time of program work: %0.5f sec", cpu_time_used);
  getch();
  return 0;
}



int len=Edit1->Text.Length();
  char* sim=new char[len];
  strcpy(sim, Edit1->Text.c_str());
  Stack stack;
  FILE *out;
  out=fopen("out.txt", "w");
  int i;
  for (i=0;i<len;i++)
    fprintf(out, "%c", sim[i]);
  fprintf(out, "\n");
  for (i=0;i<len;i++)
  {
    if (sim[i]=='x')
      fprintf(out, "%c", sim[i]);
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^')) & (stack.Count()==0))
      stack.Push(sim[i]);
    if (sim[i]=='(')
      stack.Push(sim[i]);
    if (sim[i]==')')
      while (stack.Top()!='(')
      {
        fprintf(out, "%c", stack.Top());
        stack.Pop();
      }
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^')) & (stack.Count()!=0))
      while (stack.Count()!=0)
      {
        fprintf(out, "%c", stack.Top());
        stack.Pop();
      }
  }
  fclose(out);
  Form1->Close();
