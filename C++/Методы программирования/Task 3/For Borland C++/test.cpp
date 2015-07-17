//����� "���஢����" ᨬ�����
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#define MAX_SIZE 100 //���ᨬ��쭮� ������⢮ ����⮢ ���ᨢ�

//------------------------------------------------------------------------------
//�㭪�� "���஢����" ᨬ�����
//sim - ��ப�, ᮤ�ঠ��� ��䨪��� ������ ��ࠦ���� (�᫨ num==1)
                         //��� ��६���� � ���祭��� (�᫨ num==2)
//kol_sim - ������⢮ ᨬ����� � "sim"
int TestSimbols(int num, char sim[MAX_SIZE], int kol_sim)
{
  int i, j, //����稪�
      kol1, //������⢮ ᨬ����� "("
      kol2; //������⢮ ᨬ����� ")"
  j=0;
  switch (num)
  {
    //"���஢����" 1 ��ப� ᨬ����� �� 䠩�� "expression.txt"
    case 1:
      for (i=0;i<kol_sim;i++)
        //�������⨬� ᨬ���
        if (((sim[i]<97) | (sim[i]>122)) & ((sim[i]!='+') & (sim[i]!='-') &
          (sim[i]!='*') & (sim[i]!='/') & (sim[i]!='^') & (sim[i]!='(') &
            (sim[i]!=')') & (sim[i]!='3')))
            {
              printf("\n�������⨬� ᨬ���: \"%c\"(#%i)", sim[i], i);
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
      //������⢮ ᨬ����� "(" ��ࠢ�� �������� ᨬ����� ")"
      if (kol1!=kol2)
      {
        printf("\n������⢮ ᨬ����� \"(\"(%i) ��ࠢ�� �������� ᨬ����� \")\"(%i)", kol1, kol2);
        getch();
        exit(1);
      }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��⨭᪮� �㪢��
        if (((sim[i]>=97) & (sim[i]<=122)) & (((sim[i+1]<97) | (sim[i+1]>122)) &
          (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & (sim[i+1]!='/') &
            (sim[i+1]!='^') & (sim[i+1]!=')') & (sim[i+1]!='(') & (sim[i+1]!='3')))
            {
              printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
              getch();
              exit(1);
            }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��⥬���᪮� ����樥�
        if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') |
          (sim[i]=='^')) & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))
          {
            printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "("
        if ((sim[i]=='(') & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))
        {
          printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� ")"
        if ((sim[i]==')') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') &
          (sim[i+1]!='/') & (sim[i+1]!='^') & (sim[i+1]!=')'))
          {
            printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
            getch();
            exit(1);
          }
    break;
    //==========================================================================
    //"���஢����" ᨬ����� �� 䠩�� "expression.txt" (� 2 ��ப�)
    case 2:
      for (i=0;i<kol_sim;i++)
        //
        if (((sim[i]<97) | (sim[i]>122)) & ((sim[i]<48) | (sim[i]>57)) &
          (sim[i]!='-') & (sim[i]!='=') & (sim[i]!='.') & (sim[i]!=' '))
          {
            printf("\n�������⨬� ᨬ���: \"%c\"(#%i)", sim[i], i);
            j++;
          }
      if (j>0)
      {
        getch();
        exit(1);
      }
      if ((sim[0]<97) | (sim[i]>122))
      {
        printf("\nUnknown first simbol: \"%c\"(#%i) (not a..z)", sim[0], 0);  
        getch();
        exit(1);
      }
      if ((sim[kol_sim-1]<48) | (sim[kol_sim-1]>57))
      {
        printf("\nUnknown last simbol: \"%c\"(#%i) (not 0..9)", sim[kol_sim-1], kol_sim-1);  
        getch();
        exit(1);
      }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��⨭᪮� �㪢��
        if (((sim[i]>=97) & (sim[i]<=122)) & (sim[i+1]!='='))
        {
          printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "="
        if ((sim[i]=='=') & ((sim[i+1]<48) | (sim[i+1]>57)) & (sim[i+1]!='-'))
        {
          printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��ன
        if (((sim[i]>=48) & (sim[i]<=57)) & ((sim[i+1]<48) | (sim[i+1]>57)) &
          (sim[i+1]!='.') & ((sim[i+1]<97) | (sim[i+1]>122)))
          {
            printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
            getch();
            exit(1);
          }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "."
        if ((sim[i]=='.') & ((sim[i+1]<48) | (sim[i+1]>57)))
        {
          printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      for (i=0;i<kol_sim-1;i++)
        //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "-"
        if ((sim[i]=='-') & ((sim[i+1]<48) | (sim[i+1]>57)))
        {
          printf("\n�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)", sim[i], sim[i+1], i, i+1);
          getch();
          exit(1);
        }
      break;
    default:
      printf("\n�訡��: TestSimbols(int num, char sim[MAX_SIZE], int kol_sim)");
  }
  return 0;
}
