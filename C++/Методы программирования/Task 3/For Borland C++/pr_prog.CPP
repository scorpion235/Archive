/******************************************
 * � �ணࠬ�� ॠ�������� ��楤��      *
 * �८�ࠧ������ ��䨪᭮� ����� �᫠ *
 * � ����䨪���, ��楤�� ���᫥���    *
 * ����䨪᭮�� ��ࠦ����                 *
 * � ����஥��� ��䨪�� �㭪権          *
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
#include <graphics.h>
#define TElement float
#define MAX_SIZE 100 //���ᨬ��쭮� ������⢮ ������⮢ ���ᨢ�

char *PrintFunction();
//� ����� "Stack" ॠ������� �᭮��� ����⢨� ��� �⥮�
class Stack
{
  //������� �������� 童��� �����
  private:
    TElement s[MAX_SIZE]; //���ᨢ ������⮢ �⥪�
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
int PrintGraph(char sim[MAX_SIZE], int kol_sim)
{
  char sim2[MAX_SIZE], //���ᨢ ᨬ����� �� "expression.txt" (� 2 ��ப�)
       input[MAX_SIZE], //���ᨢ ᨬ����� �� "expression.txt"
       variable[MAX_SIZE], //���ᨢ ��६�����
       value_char[MAX_SIZE][MAX_SIZE]; //���ᨢ ���祭�� ⨯� "char"
  int i, j, k,  //����稪�
      kol_val,  //������⢮ ��६�����
      kol_sim2, //�����ᨢ� ᨬ����� � ��ப� "sim2"
      flag,
      graphdriver,
      graphmode,errorcode;
  float value_float[MAX_SIZE], //���ᨢ ���祭�� ⨯� "int"
        //�������� �⥪� ��� ����묨 �ந�������� ��䬥��᪮� ����⢨�
        element1, element2, element,
        x, y, min, max;
  double real,    //�஡��� ���� �᫠
         integer; //楫�� ���� �᫠
  printf("postfix: ");
  for (i=0;i<kol_sim;i++)
  {
    switch (sim[i])
    {
      case 'A':
        printf("sin ");
        break;
      case 'B':
        printf("cos ");
        break;
      case 'C':
        printf("tan ");
        break;
      case 'D':
        printf("cot ");
        break;
      case 'E':
        printf("asin ");
        break;
      case 'F':
        printf("acos ");
        break;
      case 'G':
        printf("atan ");
        break;
      case 'H':
        printf("acot ");
        break;
      case 'I':
        printf("exp ");
        break;
      case 'J':
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
        if ((sim[i]!='|')) //& (sim[i]!=' '))
          if ((sim[i]==' ') & (sim[i+1]!=' '))
            printf("%c ", sim[i]);
          else
            printf("%c", sim[i]);
        break;
    }
  }
  j=k=0;
  printf("\n");
  for (i=0;i<kol_sim;i++)
  {
    if (sim[i]!=' ')
    {
      value_char[j][k]=sim[i];
      k++;
    }
    else
    {
      j++;
      k=0;
    }
  }
  kol_val=j;
  //639 x 479
  graphdriver=DETECT;
  initgraph(&graphdriver, &graphmode, "a:");
  errorcode=graphresult();
  if (errorcode!=grOk)
  {
    printf("�訡�� ���樠����樨 ����᪮�� ०���");
    getch();
    exit(1);
  }
  Stack stack;
  min=20;
	max=-20;
  x=-15;
  while (x<=15.001)
  {
  for (i=0;i<kol_val;i++)
    //��ॢ�� ��ப�, ᮤ�ঠ饩 ᨬ���쭮� �।�⠢����� 楫��� ���
    //����⢥����� �᫠ � ᮮ⢥�����饥 ����⢥���� �᫮
    value_float[i]=atof(value_char[i]);
  for (i=0;i<kol_val;i++)
  {
    if (value_char[i][0]=='x')
      stack.Push(x);
    //���
    else if ((value_char[i][0]>=48) & (value_char[i][0]<=57))
      stack.Push(value_float[i]);
    //���� ��⥬���᪮� ����樨
    else if ((value_char[i][0]=='+') | (value_char[i][0]=='-') |
      (value_char[i][0]=='*') | (value_char[i][0]=='/') | (value_char[i][0]=='^'))
      {
        element2=stack.Top(); //� "element2" ����頥��� ���設�� �������
        stack.Pop();          //�����祭�� ���設���� ������� �� �⥪�
        element1=stack.Top(); //� "element2" ����頥��� ���設�� �������
        stack.Pop();          //�����祭�� ���設���� ������� �� �⥪�
      }
    else if ((value_char[i][0]=='A') | (value_char[i][0]=='B') |
      (value_char[i][0]=='C') | (value_char[i][0]=='D') | (value_char[i][0]=='E') |
        (value_char[i][0]=='F') | (value_char[i][0]=='G') | (value_char[i][0]=='H') |
          (value_char[i][0]=='I') | (value_char[i][0]=='J') | (value_char[i][0]=='%') |
            (value_char[i][0]=='#') | (value_char[i][0]=='$'))
            {
              element=stack.Top(); //� "element" ����頥��� ���設�� �������
              stack.Pop();
            }
    //��⥬���᪠� ������
    if ((value_char[i][0]=='+') | (value_char[i][0]=='-') | (value_char[i][0]=='*') |
      (value_char[i][0]=='/') | (value_char[i][0]=='^') | (value_char[i][0]=='A') |
        (value_char[i][0]=='B') | (value_char[i][0]=='C') | (value_char[i][0]=='D') |
          (value_char[i][0]=='E') | (value_char[i][0]=='F') | (value_char[i][0]=='G') |
            (value_char[i][0]=='H') | (value_char[i][0]=='I') | (value_char[i][0]=='J') |
              (value_char[i][0]=='%') | (value_char[i][0]=='#') | (value_char[i][0]=='$'))
              {
                switch (value_char[i][0])
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
                    if (element2!=0)
                      stack.Push(element1/element2);
                    else
										  stack.Push(asin(0));
                    break;
                  case '^':
                    stack.Push(pow(element1, element2));
                    break;
                  case 'A': //sin
                    stack.Push(sin(element));
                    break;
                  case 'B': //cos
                    stack.Push(cos(element));
                    break;
                  case 'C': //tan
                    stack.Push(tan(element));
                    break;
                  case 'D': //cot
                    if (tan(element!=0))
                      stack.Push(1/(tan(element)));
                    else
										  stack.Push(asin(0));
                    break;
                  case 'E': //asin
                    if ((element>=-1) & (element<=1))
                      stack.Push(asin(element));
                    else
										  stack.Push(asin(0));
                    break;
                  case 'F': //acos
                    if ((element>=-1) & (element<=1))
                      stack.Push(acos(element));
                    else
										  stack.Push(asin(0));
                    break;
                  case 'G': //atan
                    if ((element>=-1) & (element<=1))
                      stack.Push(atan(element));
                    else
										  stack.Push(asin(0));
                    break;
                  case 'H': //acot
                    if (element!=0)
                      stack.Push(atan(1/element));
                    else
										  stack.Push(asin(0));
                    break;
                  case 'I': //exp
                    stack.Push(exp(element));
                    break;
                  case 'J': //ln
                    if (element>0)
                      stack.Push(log10(element));
                    else
										  stack.Push(asin(0));
                    break;
                  case '%': //sqrt
                    if (element>=0)
                      stack.Push(sqrt(element));
                    else
										  stack.Push(asin(0));
                    break;
                  case '#': //sqrt3
                    double p;
                    for (p=-1000; p<=1000; p+=0.01)
                    if (pow(p,3)==element)
                      stack.Push(p);
                    else if ((pow(p,3)<element) & (pow(p+0.01,3)>element))
                    stack.Push(p);
                  case '$': //abs
                    stack.Push(abs(element));
                    break;
                }
              }
  }
  y=stack.Top();
  stack.Pop();
  if (y<min)
    min=y;
  if (y>max)
    max=y;
  if ((20*x+320<640) & (20*x+320>=0) & (-20*y+230<460) & (-20*y+230>=20))
    putpixel(20*x+320,-20*y+230,9);
  x+=0.001;
  }
  line(20,230,620,230);
  line(320,20,320,460);
  line(600,227,620,230);
  line(600,233,620,230);
  line(317,40,320,20);
  line(323,40,320,20);
  setcolor(5);
  /*if (max<15)
  {
    printf("max=%f\n", max);
    line(20,-20*max+230,620,-20*max+230);
  }
  if (min>-15)
  {
    printf("min=%f\n", min);
    line(20,-20*min+230,620,-20*min+230);
  }*/
  setcolor(7);
  outtextxy(325,10,"y");
  outtextxy(625,220, "x");
  outtextxy(325,220, "0");
  getch();
  closegraph();
  exit(1);
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
      if ((sim[j]=='A') | (sim[j]=='B') | (sim[j]=='C') | (sim[j]=='D') |
        (sim[j]=='E') | (sim[j]=='F') | (sim[j]=='G') | (sim[j]=='H') |
          (sim[j]=='I') | (sim[j]=='J') | (sim[j]=='%') | (sim[j]=='#') | (sim[j]=='$'))
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
      kol_sim_segm[MAX_SIZE];//������⢮ ������⮢ ᮮ⢥�����饣� ᥣ����
  kol1=kol2=0;
  for (i=0;i<kol_sim-1;i++)
    if (((sim[i]>=65) & (sim[i]<=74)) | (sim[i]=='+') | (sim[i]=='-') |
      (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^') | (sim[i]=='x'))
      {
        kol1++;
        if (sim[i+1]==' ')
          kol2++;
      }
  if ((kol1==kol2) & (kol1!=0))
  {
    PrintGraph(sim, kol_sim); //�㭪�� ���᫥��� ����䨪᭮�� ��ࠦ����
    return (sim);
  }
  for (i=0;i<kol_sim-4;i++)
  {
    if ((sim[i]=='s') & (sim[i+1]=='i') & (sim[i+2]=='n')) //sin
    {
      sim[i+2]='A';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='c') & (sim[i+1]=='o') & (sim[i+2]=='s')) //cos
    {
      sim[i+2]='B';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='t') & (sim[i+1]=='a') & (sim[i+2]=='n')) //tan
    {
      sim[i+2]='C';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='c') & (sim[i+1]=='o') & (sim[i+2]=='t')) //cot
    {
      sim[i+2]='D';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='s') & (sim[i+2]=='i') & (sim[i+3]=='n')) //asin
    {
      sim[i+3]='E';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='c') & (sim[i+2]=='o') & (sim[i+3]=='s')) //acos
    {
      sim[i+3]='F';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='t') & (sim[i+2]=='a') & (sim[i+3]=='n')) //atan
    {
      sim[i+3]='G';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='a') & (sim[i+1]=='c') & (sim[i+2]=='o') & (sim[i+3]=='t')) //acot
    {
      sim[i+3]='H';
      sim[i]=sim[i+1]=sim[i+2]='|';
    }
    if ((sim[i]=='e') & (sim[i+1]=='x') & (sim[i+2]=='p')) //exp
    {
      sim[i+2]='I';
      sim[i]=sim[i+1]='|';
    }
    if ((sim[i]=='l') & (sim[i+1]=='n')) //ln
    {
      sim[i+1]='J';
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
    if ((pos==0) & (kol_sim_segm[i]>1) & (segm[i][0]!='|') & ((segm[i][0]<48) |
      (segm[i][0]>57)))
      {
        if ((segm[i][0]=='(') & (segm[i][kol_sim_segm[i]-1]==')'))
          printf("������ ���譨� ᪮���\n");
        else
          printf("�������⨬�� ��⠭�� ᨬ�����\n");
        //PrintFunction();
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
        kol=0;
        for (j=0;j<kol_sim_segm[i];j++)
          if ((segm[i][j]>=48) & (segm[i][j]<=57))
            kol++;
        if (kol!=kol_sim_segm[i])
        {
          kol_sim_segm[i]+=3;
          segm[i][kol_sim_segm[i]-1]=' ';
          segm[i][kol_sim_segm[i]-2]=segm[i][pos];
          segm[i][kol_sim_segm[i]-3]=' ';
          segm[i][pos]=' ';
        }
        else
        {
          kol_sim_segm[i]++;
          segm[i][kol_sim_segm[i]-1]=' ';
        }
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
//====================================================================================
char *PrintFunction()
{
  char sim[MAX_SIZE],   //���ᨢ ᨬ����� ��ࠦ����
       input[MAX_SIZE]; //���ᨢ ᨬ����� "expesion.txt" (1 ��ப�)
  int i,j, //����稪�
      kol1, kol2,
      kol_sim;
  printf("������ �㭪�� y=f(x)\ny=");
  gets(sim);
  kol_sim=strlen(sim);
  j=0;
  for (i=0;i<kol_sim;i++)
    //�������⨬� ᨬ���
    if (((sim[i]<97) | (sim[i]>122)) & (sim[i]!='+') & (sim[i]!='-') &
      (sim[i]!='*') & (sim[i]!='/') & (sim[i]!='^') & (sim[i]!='(') &
        (sim[i]!=')') & (sim[i]!='.') & ((sim[i]<48) | (sim[i]>57)))
        {
          printf("�������⨬� ᨬ���: \"%c\"(#%i)\n", sim[i], i);
          j++;
        }
  if (j>0)
  {
    getch();
    PrintFunction();
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
    printf("������⢮ ᨬ����� \"(\"(%i) ��ࠢ�� �������� ᨬ����� \")\"(%i)\n", kol1, kol2);
    PrintFunction();
  }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��⨭᪮� �㪢��
    if (((sim[i]>=97) & (sim[i]<=122)) & (((sim[i+1]<97) | (sim[i+1]>122)) &
      (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') & (sim[i+1]!='/') &
        (sim[i+1]!='^') & (sim[i+1]!=')') & (sim[i+1]!='(') & (sim[i+1]!='3')))
        {
          printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
          PrintFunction();
        }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ��⥬���᪮� ����樥�
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') |
      (sim[i]=='^')) & ((sim[i+1]<97) | (sim[i+1]>122)) & ((sim[i+1]<48) |
        (sim[i+1]>57)) & (sim[i+1]!='('))
        {
          printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
          PrintFunction();
        }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "("
    if ((sim[i]=='(') & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='(') &
      ((sim[i+1]<48) | (sim[i+1]>57)))
    {
      printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
      PrintFunction();
    }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� ")"
    if ((sim[i]==')') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') &
      (sim[i+1]!='/') & (sim[i+1]!='^') & (sim[i+1]!=')'))
      {
        printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
        PrintFunction();
      }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "x"
    if ((sim[i]=='x') & (sim[i+1]!='+') & (sim[i+1]!='-') &
      (sim[i+1]!='*') & (sim[i+1]!='/') & (sim[i+1]!='^') &
        (sim[i+1]!='(') & (sim[i+1]!=')') & (sim[i+1]!='p'))
        {
          printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
          PrintFunction();
        }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ᨬ�����, ᫥����� �� ᨬ����� "."
    if ((sim[i]=='.') & ((sim[i+1]<48) | (sim[i+1]>57)))
    {
      printf("�������⨬�� ��⠭�� ᨬ�����: \"%c%c\"(#%i, #%i)\n", sim[i], sim[i+1], i, i+1);
      PrintFunction();
    }
  j=0;
  for (i=0;i<kol_sim;i++)
    if (sim[i]=='x')
      j++;
  if (j==0)
  {
    printf("��६����� \"x\" �� ������\n");
    PrintFunction();
  }
  for (i=0;i<kol_sim-1;i++)
    //�஢�ઠ ����⨬�� ���祭�� ��� ��ࢮ�� ᨬ����
    if (((sim[0]<97) | (sim[0]>122)) & ((sim[0]<48) | (sim[0]>57)) &
		  (sim[0]!='(') & (sim[0]!='-'))
      {
        printf("�������⨬�� ���祭�� ��ࢮ�� ᨬ����: \"%c\"\n", sim[0]);
        PrintFunction();
      }
    if (((sim[kol_sim-1]<97) | (sim[kol_sim-1]>122)) & ((sim[kol_sim-1]<48) |
		  (sim[kol_sim-1]>57)) & (sim[kol_sim-1]!=')'))
      {
        printf("�������⨬�� ���祭�� ��᫥����� ᨬ����: \"%c\"\n", sim[kol_sim-1]);
        PrintFunction();
      }
  postfix(sim, kol_sim); //�८�ࠧ������ ��䨪᭮� ����� �᫠ � ����䨪���
  return(sim);
}
//==============================================================================
//�᭮���� �㭪��
int main()
{
  PrintFunction();
  return 0;
}