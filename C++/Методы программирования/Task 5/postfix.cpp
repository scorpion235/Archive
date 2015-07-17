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
 
#include "test.cpp"
#include <time.h>
#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#define TElement float
#define MAX_SIZE 100 //максимальное количество элементов массива

struct Node
{
  char d;
  Node *left;
  Node *right;
};
//------------------------------------------------------------------------------
//формирование первого элемента дерева
/*Node *First(char d)
{
  Node *pv=new Node;
  pv->d=d;
  pv->left=0;
  pv->right=0;
  return pv;
}
//------------------------------------------------------------------------------
//поиск с включениями
//a + b * c
//a b c * +
Node *SearchInsert(Node *root, char d)
{
  printf("data %c\n", d);
  Node *pv=root, *prev;
  bool found=false;
  while ((pv) && (!found))
  {
    printf("pv->%c = %c\n", d, pv->d);
    prev=pv;
    if (d==pv->d)
      found=true;
    else if (d<pv->d)
      pv=pv->left;
    else
      pv=pv->right;
  }
  if (found)
    return pv;
  //создание нового узла
  Node *pnew=new Node;
  pnew->d=d;
  pnew->left=0;
  pnew->right=0;
  if (d<prev->d)
    //присоединение к левому поддерев предка
    prev->left=pnew;
  else
    //присоединение к правому поддерев предка
    prev->right=pnew;
  return pnew;
}*/
//------------------------------------------------------------------------------
//обход дерева
int PrintTree(Node *p, int level)
{
  if (p)
  {
    PrintTree(p->left, level+1); //вывод левого поддерева
    for (int i=0;i<level;i++)
      printf("  ");
    printf("%c\n", p->d); //вывод корня поддерева
    PrintTree(p->right, level+1); //вывод правого поддерева
    return 0;
  }
}
//------------------------------------------------------------------------------
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
    printf("postfix: ");
    for (i=0;i<kol_sim;i++)
      printf("%c", sim[i]);
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
//------------------------------------------------------------------------------
//основная функция
int main()
{
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
    if ((input[i]!=' ') & (input[i]!='\n'))
    {
      sim[j]=input[i];
      j++;
    }
    i++;
  }
  fclose(file); //закрытие файла "expression.txt"
  int kol_sim=--j;
  for (i=0;i<kol_sim;i++)
    printf("%c", sim[i]);
  TestSimbols(sim, kol_sim); //"тестирование" символов
  printf("\n");
  postfix(sim, kol_sim); //преобразования префиксной записи числа в постфиксную
  getch();
  return 0;
}
