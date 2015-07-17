/******************************************
 * � ��������� ����������� ���������      *
 * �������������� ���������� ������ ����� *
 * � ����������� � ��������� ����������   *
 * ������������ ���������                 *
 ******************************************
 * �����: ������� ������ MK-301           *
 * ����: 25.11.04                         *
 * ����� ����������: Dev-Cpp 4.9.9.0.     *
 ******************************************/
 
#include "test.cpp"
#include <time.h>
#include <math.h>
#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>
#define TElement float
#define MAX_SIZE 100 //������������ ���������� ��������� �������

struct Node
{
  char d;
  Node *left;
  Node *right;
};
//------------------------------------------------------------------------------
//������������ ������� �������� ������
/*Node *First(char d)
{
  Node *pv=new Node;
  pv->d=d;
  pv->left=0;
  pv->right=0;
  return pv;
}
//------------------------------------------------------------------------------
//����� � �����������
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
  //�������� ������ ����
  Node *pnew=new Node;
  pnew->d=d;
  pnew->left=0;
  pnew->right=0;
  if (d<prev->d)
    //������������� � ������ �������� ������
    prev->left=pnew;
  else
    //������������� � ������� �������� ������
    prev->right=pnew;
  return pnew;
}*/
//------------------------------------------------------------------------------
//����� ������
int PrintTree(Node *p, int level)
{
  if (p)
  {
    PrintTree(p->left, level+1); //����� ������ ���������
    for (int i=0;i<level;i++)
      printf("  ");
    printf("%c\n", p->d); //����� ����� ���������
    PrintTree(p->right, level+1); //����� ������� ���������
    return 0;
  }
}
//------------------------------------------------------------------------------
int LastOperation(int prior, char sim[MAX_SIZE] , int kol_sim)
{
  int kol1, kol2, //���������� "(" � ")" ����� �� ��������
      kol3, kol4, //���������� "(" � ")" ������ �� ��������
      pos,     //������� ��������� ��������
      k, i, j; //��������
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
//������� �������������� ���������� ������ ����� � �����������
//sim - ������ � ������� ���������� ���������� ������ ���������
//kol_sim - ����� ������ "sim"
char *postfix(char sim[MAX_SIZE] , int kol_sim)
{
  char segm[MAX_SIZE][MAX_SIZE], //��������, �� ������� ����������� "sim"
       last_operation;
  int i, j, k,   //��������
      kol_segm,  //���������� ���� ���������
      kol_1segm, //���������� ��������� ����� 1
      kol,       //���������� �������� "(" ��� ")"
      kol1,      //���������� �������� "("
      kol2,      //���������� �������� ")"
      pos,       //������� ��������� ��������
      flag, flag1, flag2; //����������, ����������� 2 �������� (1 - �����, 0 - �������)
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
  //��������� "sim" �� �������� (����� ������, ���������� ��������)
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
  //����� ��������� �������������� �������� � ������ ��������
  for (i=0;i<kol_segm;i++)
  {
    pos=LastOperation(1, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(2, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(3, segm[i], strlen(segm[i]));
    if (pos==0)
      pos=LastOperation(4, segm[i], strlen(segm[i]));
    if ((pos==0) & (strlen(segm[i])>1) & (segm[i][0]!='|') ) //�� ������� �������� ��������
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
    //� �������� segm[i] ��� ������
    if ((kol1==0) & (kol2==0))
      flag=0;
    //� �������� segm[i] ���� �������  
    else 
      flag=1;
    //--------------------------------------------------------------------------  
    if (flag==0) //� �������� segm[i] ��� ������
    {
      if ((strlen(segm[i])>1) & (i!=kol_sim-1))
      {
        char s[]="   ";
        strcat(segm[i], s); //���������� ������ "segm[i]" � "s"
        segm[i][strlen(segm[i])-2]=segm[i][pos];
        segm[i][pos]=' ';
      }
      if (strlen(segm[i])==1)
      {
        char s[]=" ";
        strcat(segm[i], s); //���������� ������ "segm[i]" � "s"
      }
    }
    //--------------------------------------------------------------------------
    if (flag==1) //� �������� segm[i] ���� �������
    {
      //( ... ) last_operation ...
      if ((segm[i][0]=='(') & (segm[i][pos-1]==')'))
      {
        flag1=flag2=1;
        kol=0; //���������� �������� "(" ��� ")"
        for (j=1;j<pos-1;j++)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]==')') & (kol==1))
              flag1=0;
          }
        }
        kol=0; //���������� �������� "(" ��� ")"
        for (j=pos-1;j>1;j--)
        {
          if ((segm[i][j]=='(') | (segm[i][j]==')'))
          {
            kol++;
            if ((segm[i][j]=='(') & (kol==1))
              flag2=0;
          }
        }
        //������� ������ ����� ������
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
        //������� ������ ����� ������
        if ((flag1==1) & (flag2)==1)
        {
          segm[i][pos+1]=' ';
          segm[i][strlen(segm[i])-1]=' ';
        }    
      }          
      char s[]="   ";
      strcat(segm[i], s); //���������� ������ "segm[i]" � "s"
      segm[i][pos]=' ';
      segm[i][strlen(segm[i])-2]=last_operation;
    }     
  }
  //----------------------------------------------------------------------------
  //���������� ���� ��������� � ����
  for (i=kol_segm;i>0;i--)
    strcat(segm[i-1],segm[i]); //���������� ������ "segm[i-1]" � "segm[i]"
  kol_sim=strlen(segm[0]);
  return (postfix(segm[0], kol_sim)); //����������� ����� ������� "postfix()"
}
//------------------------------------------------------------------------------
//�������� �������
int main()
{
  char sim[MAX_SIZE],   //������ �������� ���������
       input[MAX_SIZE]; //������ �������� "expression.txt" (1 ������)
  int i,j; //��������
  i=j=0;
  FILE *file;
  //������� ���� "expression.txt" �� ������
  file=fopen("expres~1.txt","r");
  if (file==NULL)
  {
    puts("Error: the file \"expression.txt\" is not opened ");
    getch();
    return -1;
  }
  printf("prefix:  ");
  while(!feof(file)) //���� �� ��������� ����� ����� "expression.txt"
  {
    //������������ ������ �� ����� "expression.txt"
    input[i]=fgetc(file);
    if ((input[i]!=' ') & (input[i]!='\n'))
    {
      sim[j]=input[i];
      j++;
    }
    i++;
  }
  fclose(file); //�������� ����� "expression.txt"
  int kol_sim=--j;
  for (i=0;i<kol_sim;i++)
    printf("%c", sim[i]);
  TestSimbols(sim, kol_sim); //"������������" ��������
  printf("\n");
  postfix(sim, kol_sim); //�������������� ���������� ������ ����� � �����������
  getch();
  return 0;
}
