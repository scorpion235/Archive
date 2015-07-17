/******************************************
 * � �ணࠬ�� ॠ�������� ��楤��      *
 * �८�ࠧ������ ��䨪᭮� ����� �᫠ *
 * � ����䨪��� � ��楤�� ���᫥��    *
 * ����䨪᭮�� ��ࠦ����                 *
 ******************************************
 * ����: ���஢ ��ࣥ� MK-301           *
 * ��� 30.11.04.                         *
 * �।� ࠧࠡ�⪨: Borland C++ 3.1      *
 ******************************************/

#include <time.h>
#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#include "test.cpp"
#define TElement float
#define MAX_SIZE 100 //���ᨬ��쭮� ������⢮ ����⮢ ���ᨢ�
//� ����� "Stack" ॠ������� �᭮��� ����⢨� ��� �⥮�
class Stack
{
  //������� �������� 童��� �����
  private:
    TElement s[MAX_SIZE]; //���ᨢ ����⮢ �⥪�
    int top; //���設� �⥪�
  //��ꢫ���� ������� 童��� �����
  public:
    Stack(){top=0;}  //���������
    ~Stack(){top=0;} //��������
    int Pop();  //
    int Push(TElement x); //������� ������ �� �⥪�
    int IsEmpty(){return(top==0);} //�������� ������ � �⥪
    TElement Top(); //�஢�ઠ �⥪� �� ������
};
//------------------------------------------------------------------------------
//������� ������ �� �⥪�
int Stack::Pop()
{
  if (Stack::IsEmpty()) //�⥪ ����
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//�������� ������ � �⥪
//x - ����頥��� ������
int Stack::Push(TElement x)
{
  if (top==MAX_SIZE-1) //�⥪ ��९�����
    return -1;
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//������ ���設�
TElement Stack::Top()
{
  if (Stack::IsEmpty()) //�⥪ ����
    return -1;
  return (s[top]);
}
//==============================================================================
//�㭪�� ���᫥��� ����䨪᭮�� ��ࠦ����
//sim - ��ப�, ᮤ�ঠ��� ����䨪��� ������ ��ࠦ����
//kol_sim - ����� ��ப� "sim"
int Calculation(char sim[MAX_SIZE], int kol_sim)
{
  char sim2[MAX_SIZE], //���ᨢ ᨬ����� �� "expression.txt" (� 2 ��ப�)
       input[MAX_SIZE], //���ᨢ ᨬ����� �� "expression.txt"
       variable[MAX_SIZE], //���ᨢ ��६�����
       value_char[MAX_SIZE][MAX_SIZE]; //���ᨢ ���祭�� ⨯� "char"
  int i, j, k,  //����稪�
      kol_var,  //������⢮ ��६�����
      kol_sim2, //�����ᨢ� ᨬ����� � ��ப� "sim2"
      flag;
  float value_float[MAX_SIZE], //���ᨢ ���祭�� ⨯� "int"
        //������ �⥪� ��� ����묨 �ந�������� ��䬥��᪮� ����⢨�
        element1, element2, element;
  double real,    //�஡��� ���� �᫠
         integer; //楫�� ���� �᫠
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
  //������ 䠩� "expression.txt" �� �⥭��
  file=fopen("expres~1.txt","r");
  j=flag=0;
  while(!feof(file)) //���� �� ���⨣��� ����� 䠩�� "expression.txt"
  {
    //��ᨬ���쭮� �⥭�� �� 䠩�� "expression.txt"
    input[i]=fgetc(file);
    if (input[i]=='\n')
      flag=1;
    if ((flag==1) & (input[i]!=' '))
      printf("%c", input[i]);
    //� ���ᨢ "sim2" ���� ����ᠭ� ᨬ���� ��稭�� � 2 ��ப�
    if ((flag==1) & (input[i]!='\n') & (input[i]!=' '))
    {
      sim2[j]=input[i];
      j++;
    }
    i++;
  }
  fclose(file); //�����⨥ 䠩�� "exprssion.txt"
  kol_sim2=--j;
  TestSimbols(2, sim2, kol_sim2); //"���஢����" ᨬ����� "sim2"
  j=-1;
  k=0;
  for (i=0;i<kol_sim2;i++)
  {
    if ((sim2[i]>=97) & (sim2[i]<=122)) //��⨭᪠� �㪢�
    {
      j++;
      k=0;
      variable[j]=sim2[i];
    }
    //���, "." ��� "-"
    if (((sim2[i]>=48) & (sim2[i]<=57)) | (sim2[i]=='.') | (sim2[i]=='-'))
    {
      value_char[j][k]=sim2[i];
      k++;
    }
  }
  kol_var=++j;
  for (i=0;i<kol_var;i++)
    //��ॢ�� ��ப�, ᮤ�ঠ饩 ᨬ���쭮� �।�⠢����� 楫��� ���
    //����⢥����� �᫠ � ᮮ⢥�����饥 ����⢥���� �᫮
    value_float[i]=atof(value_char[i]);
  for (i=0;i<kol_sim;i++)
    if ((sim[i]>=97) & (sim[i]<=122)) //��⨭�� �㪢�
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
        printf("\n�������� ��६�����: \"%c\"", sim[i]);
        getch();
        exit(1);
      }
    }
  printf("\n��������, ��������...");
  Stack stack;
  for (i=0;i<kol_sim;i++)
  {
    if ((sim[i]>=97) & (sim[i]<=122)) //��⨭᪠� �㪢�
      for (j=0;j<kol_var;j++)
        if (sim[i]==variable[j])
          stack.Push(value_float[j]);
    //���� ��⥬���᪮� ����樨
    if ((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^'))
    {
      element2=stack.Top(); //� "element2" ����頥��� ���設�� �����
      stack.Pop();          //�����祭�� ���設���� ����� �� �⥪�
      element1=stack.Top(); //� "element2" ����頥��� ���設�� �����
      stack.Pop();          //�����祭�� ���設���� ����� �� �⥪�
    }
    else if ((sim[i]=='0') | (sim[i]=='1') | (sim[i]=='2') | (sim[i]=='3') | (sim[i]=='4') |
      (sim[i]=='5') | (sim[i]=='6') | (sim[i]=='7') | (sim[i]=='8') | (sim[i]=='9') |
        (sim[i]=='%') | (sim[i]=='#') | (sim[i]=='$'))
        {
          element=stack.Top(); //� "element" ����頥��� ���設�� �����
          stack.Pop();
        }
    //��⥬���᪠� ���ࠨ�
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
                printf("\n������� �� 0");
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
                printf("\n������� �� 0");
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
  real=modf(stack.Top(),&integer); //ࠧ������ ����� �� ���� � �஡��� ����
  if (real==0)
    printf("\n�������: %0.0f", integer);
  else
    printf("\n�������: %-0.5f", stack.Top());
  return 0;
}
//==============================================================================
//�㭪��� ��宦����� ��᫥���� ��⥬���᪮� ����樨
//prior - �ਮ��� ���ࠨ�
//sim - ��ப�, ᮤ�ঠ��� ������ ��ࠦ����
//kol_sim - ������⢮ ᨬ����� � "sim"
int LastOperation(int prior, char sim[MAX_SIZE] , int kol_sim)
{
  int kol1, kol2, //������⢮ ᨬ����� "(" � ")" ᫥�� �� ���ࠨ�
      kol3, kol4, //������⢮ ᨬ����� "(" � ")" �ࠢ� �� ���ࠨ�
      pos,        //������ ��᫥���� ���ࠨ�
      k, i, j;    //����稪�
  //����樨, ᮮ⢥�����騥 ��������� �ਮ����
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
//�㭪�� �८�ࠧ������ ��䨪᭮� ����� �᫠ � ��������
//sim - ��ப�, ᮤ�ঠ��� ��䨪��� ������ ��ࠦ����
//kol_sim - ������⢮ ᨬ����� � "sim"
char *postfix(char sim[MAX_SIZE] , int kol_sim)
{
  char segm[MAX_SIZE][MAX_SIZE], //ᥣ�����, �� ����� ࠧ�������� "sim"
       last_operation; //��᫥���� ��⥬���᪠� ������
  int i, j, k,   // ����稪�
      kol_segm,  //������⢮ ��� ᥣ���⮢
      kol_1segm, //������⢮ ᥣ���⮢ ����� 1
      kol,       //������⢮ ᨬ����� "(" � ")"
      kol1,      //������⢮ ᨬ����� "("
      kol2,      //������⢮ ᨬ����� ")"
      pos,       //������� ��᫥���� ��⠬���᪮� ����樨
      flag, flag1, flag2, //��६���� �ਭ����騨� 2 ���祭��:
                          //1 - ��୮, 2 - ����୮
      kol_sim_segm[MAX_SIZE];//������⢮ ����⮢ ᮮ⢥�����饣� ᥣ����
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
  //ࠧ������ "sim" �� ᥣ����� (��� ��ப� ࠧ����� �஡����)
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
    Calculation(sim, kol_sim); //�㭪�� ���᫥��� ����䨪᭮�� ��ࠦ����
    return (sim);
  }
  //���� ��᫥���� ��⥬���᪮� ����樨 � ������ ᥣ����
  for (i=0;i<kol_segm;i++)
  {
    pos=LastOperation(1, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(2, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(3, segm[i], kol_sim_segm[i]);
    if (pos==0)
      pos=LastOperation(4, segm[i], kol_sim_segm[i]);
    //��᫥���� ������ �� �������
    if ((pos==0) & (kol_sim_segm[i]>1) & (segm[i][0]!='|'))
    {
      printf("�� ������� ��᫥���� ���ࠨ� � segm[%i]: \"", i);
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
    //� ᥣ���� "segm[i]" ��� ᪮���
    if ((kol1==0) & (kol2==0))
      flag=0;
    //� ᥣ���� "segm[i]" ���� ᪮���
    else
      flag=1;
    //--------------------------------------------------------------------------
    if (flag==0) //� ᥣ���� "segm[i]" ��� ᪮���
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
    if (flag==1) //� ᥣ���� "segm[i]" ���� ᪮���
    {
      //( ... ) last_operation ...
      if ((segm[i][0]=='(') & (segm[i][pos-1]==')'))
      {
        flag1=flag2=1;
        kol=0; //������⢮ ᨬ����� "(" � ")"
        for (j=1;j<pos-1;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0; //������⢮ ᨬ����� "(" � ")"
        for (j=pos-1;j>1;j--)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]=='(') & (kol==1))
              flag2=0;
          }
        }
        //���譨� ᪮��� ����� ����
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
        //���譨� ᪮��� ����� ����
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
  //��ꥤ������ ��� �८�ࠧ������� ᥣ���⮢
  i=0;
  for(j=0;j<kol_segm;j++)
    for(k=0;k<kol_sim_segm[j];k++)
      sim[i++]=segm[j][k];
  kol_sim=i;
  return (postfix(sim, kol_sim)); //४��ᨢ�� �맮� "postfix()"
}
//==============================================================================
//�᭮���� �㭪��
int main()
{
  char sim[MAX_SIZE],   //���ᨢ ᨬ����� ��ࠦ����
       input[MAX_SIZE]; //���ᨢ ᨬ����� "expesion.txt" (1 ��ப�)
  int i,j; //����稪�
  i=j=0;
  FILE *file;
  //����⨥ 䠩�� "expression.txt" �� �⥭��
  file=fopen("expres~1.txt","r");
  if (file==NULL)
  {
    puts("�訡�� ������ 䠩�� \"expression.txt\" �� �⥭��");
    getch();
    return -1;
  }
  printf("prefix:  ");
  while(!feof(file)) //���� �� ���⨣�� ��� 䠫�  䠩�� "expression.txt"
  {
    //��ᨬ���쭮� �⥭�� �� 䠩�� "expression.txt"
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
  fclose(file); //�����⨥ 䠩�� "expression.txt"
  int kol_sim=j;
  for (i=0;i<kol_sim;i++)
    printf("%c", sim[i]);
  TestSimbols(1, sim, kol_sim); //"���஢����" ᨬ����� "sim"
  printf("\n");
  postfix(sim, kol_sim); //�८�ࠧ������ ��䨪᭮� ����� �᫠ � ����䨪���
  getch();
  return 0;
}
