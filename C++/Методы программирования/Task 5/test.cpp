//������ ������������ ��������
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#define MAX_SIZE 100 //������������ ���������� ��������� �������

//------------------------------------------------------------------------------
//������� "������������" ��������
//sim - ������ � ������� ���������� ���������� ������ ��������� (���� num==1)
                                  //��� ���������� �� ��������� (���� num==2)
//kol_sim - ����� ������ "sim"
int TestSimbols(char sim[MAX_SIZE], int kol_sim)
{
  int i, j, //��������
      kol1, //���������� �������� "("
      kol2; //���������� �������� ")"
  j=0;
    //"������������" 1 ������ �������� �� "expression.txt"
      for (i=0;i<kol_sim;i++)
        //������������ ������
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
      //�������� ���������� �������� ��� ������� �������
      if (((sim[0]<97) | (sim[0]>122)) & (sim[0]!='('))
      {
        printf("\nUnknown first simbol: \"%c\"(#%i) (not \"a\"..\"z\" or \"(\")", sim[0], 0);  
        getch();
        exit(1);
      }
      //�������� ���������� �������� ��� ���������� �������
      if (((sim[kol_sim-1]<97) | (sim[kol_sim-1]>122)) & (sim[kol_sim-1]!=')'))
      {
        printf("\nUnknown last simbol: \"%c\"(#%i) (not \"a\"..\"z\" or \")\")", sim[kol_sim-1], kol_sim-1);
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
      //���������� �������� "(" �� ����� ���������� �������� ")"
      if (kol1!=kol2)
      {
        printf("\nNumber of simbol(s): \"(\"(%i) is not equal number of simbol(s) \")\"(%i)", kol1, kol2);
        getch();
        exit(1);
      }
      for (i=0;i<kol_sim-1;i++)
        //�������� ���������� �������� ��� ��������, ��������� �� ��������� ������
        if (((sim[i]>=97) & (sim[i]<=122)) & (((sim[i+1]<97) | (sim[i+1]>122)) &
          (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & (sim[i+1]!='/') & 
            (sim[i+1]!='^') & (sim[i+1]!='(') & (sim[i+1]!=')') & (sim[i+1]!='3')))
            {
              printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
              getch();
              exit(1);
            }
      for (i=0;i<kol_sim-1;i++)
        //�������� ���������� �������� ��� ��������, ��������� �� �������������� ���������
        if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | 
          (sim[i]=='^')) & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))  
          {          
            printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //�������� ���������� �������� ��� ��������, ��������� �� �������� "("
        if ((sim[i]=='(') & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))  
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //�������� ���������� �������� ��� ��������, ��������� �� �������� ")"
        if ((sim[i]==')') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & 
          (sim[i+1]!='/') & (sim[i+1]!='^') & (sim[i+1]!=')'))  
          {
            printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //�������� ���������� �������� ��� ��������, ��������� �� �������� ")"
        if ((sim[i]=='3') & (sim[i+1]!='('))
        {
          printf("\nUnknown simbols: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);  
          getch();
          exit(1);
        }  
  return 0;   
}
