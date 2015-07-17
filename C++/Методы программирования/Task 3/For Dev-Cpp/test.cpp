//модуль тестирования символов
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#define MAX_SIZE 100 //максимальное количество элементов массива

//------------------------------------------------------------------------------
//функция "тестирования" символов
//sim - строка в которой содержится префиксная запись выражения (если num==1)
                                  //или переменные со значением (если num==2)
//kol_sim - длина строки "sim"
int TestSimbols(int num, char sim[MAX_SIZE], int kol_sim)
{
  int i, j, //счётчики
      kol1, //количество символов "("
      kol2; //количество символов ")"
  j=0;
  switch (num)
  {
    //"тестирование" 1 строки символов из "expression.txt"
    case 1: 
      for (i=0;i<kol_sim;i++)
        //недопустимый символ
        if (((sim[i]<97) | (sim[i]>122)) & ((sim[i]!='+') & (sim[i]!='-') &
          (sim[i]!='*') & (sim[i]!='/') & (sim[i]!='^') & (sim[i]!='(') & 
            (sim[i]!=')') & (sim[i]!='3')))
            {
              printf("\nUnknown simbol: \"%c\"(%i)", sim[i], i);
              j++;
            }
      if (j>0)
      {
        getch();
        exit(1);
      }
      kol1=kol2=0;
      for (i=0;i<kol_sim;i++)
      {
        if (sim[i]=='(')
          kol1++;
        if (sim[i]==')')
          kol2++;
      }
      //количество символов "(" не равно количеству символов ")"
      if (kol1!=kol2)
      {
        printf("\nNumber of simbol(s): \"(\"(%i) is not equal number of simbol(s) \")\"(%i)", kol1, kol2);
        getch();
        exit(1);
      }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за латинской буквой
        if (((sim[i]>=97) & (sim[i]<=122)) & (((sim[i+1]<97) | (sim[i+1]>122)) &
          (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & (sim[i+1]!='/') & 
            (sim[i+1]!='^') & (sim[i+1]!='(') & (sim[i+1]!=')') & (sim[i+1]!='3')))
            {
              printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
              getch();
              exit(1);
            }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за математической операцией
        if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | 
          (sim[i]=='^')) & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))  
          {          
            printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом "("
        if ((sim[i]=='(') & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))  
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом ")"
        if ((sim[i]==')') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & 
          (sim[i+1]!='/') & (sim[i+1]!='^') & (sim[i+1]!=')'))  
          {
            printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом ")"
        if ((sim[i]=='3') & (sim[i+1]!='('))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
          getch();
          exit(1);
        }
    break;
    //==========================================================================
    //"тестирование" символов из "expression.txt", начиная со 2 строчки
    case 2:
      for (i=0;i<kol_sim;i++)
        //недопустимый символ
        if (((sim[i]<97) | (sim[i]>122)) & ((sim[i]<48) | (sim[i]>57)) & 
          (sim[i]!='-') & (sim[i]!='=') & (sim[i]!='.') & sim[i]!=' ')
          {
            printf("\nUnknown simbol: \"%c\"(#%i)", sim[i], i);  
            j++;
          }
      if (j>0)
      {
        getch();
        exit(1);
      }    
      //проверка допустимых значений для первого символа
      if ((sim[0]<97) | (sim[i]>122))
      {
        printf("\nUnknown first simbol: \"%c\"(#%i) (not \"a\"..\"z\")", sim[0], 0);  
        getch();
        exit(1);
      }
      //проверка допустимых значений для последнего символа
      if ((sim[kol_sim-1]<48) | (sim[kol_sim-1]>57))
      {
        printf("\nUnknown last simbol: \"%c\"(#%i) (not \"0\"..\"9\")", sim[kol_sim-1], kol_sim-1);  
        getch();
        exit(1);
      }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за латинской буквой
        if (((sim[i]>=97) & (sim[i]<=122)) & (sim[i+1]!='='))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за цифрой
        if (((sim[i]>=48) & (sim[i]<=57)) & ((sim[i+1]<48) | (sim[i+1]>57)) &
          (sim[i+1]!='.') & ((sim[i+1]<97) | (sim[i+1]>122)))
          {
            printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом "="
        if ((sim[i]=='=') & ((sim[i+1]<48) | (sim[i+1]>57)) & (sim[i+1]!='-'))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом "."
        if ((sim[i]=='.') & ((sim[i+1]<48) | (sim[i+1]>57)))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //проверка допустимых значений для символов, следующих за символом "-"
        if ((sim[i]=='-') & ((sim[i+1]<48) | (sim[i+1]>57)))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }      
      break;
    default:
      printf("\nError: TestSimbols(int num, char sim[MAX_SIZE], int kol_sim)");
  }  
  return 0;   
}
