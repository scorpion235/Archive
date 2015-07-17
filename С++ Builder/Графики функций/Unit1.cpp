/**********************************************************
 * ��������� ��������� �������� �������                   *
 * �����: ������� �.�.                                    *
 * ����: 22.06.2005                                       *
 * ����� ����������: Borland Builder C++ Version 6.0      *
 **********************************************************
 * ���������� ��������: +, -, *, /, ^, sin, cos, tg, ctg, *
 * arcsin, arccos, arctg, arcctg, exp, ln, mod, (, )      *
 **********************************************************/

#include <vcl.h>
#include <math.h>
#include <stdio.h>

#include "Unit1.h"
#include "Unit2.h"
#include "Unit3.h"
#include "Unit4.h"

#pragma package(smart_init)
#pragma resource "*.dfm"
#pragma hdrstop

#define MAX_SIZE 100
#define out_file "out.txt"

TForm1 *Form1;

//����� "Stack" ��� ��������� ���� "float"
class StackFloat
{
  private:
    float s[MAX_SIZE];
    int top;
  public:
    StackFloat(){top=0;}      //�����������
    ~StackFloat(){top=0;}     //����������
    int Pop();                //�������� �������� �� �����
    int Push(float x);        //������� �������� � ����
    int Count(){return(top);} //���������� ��������� � �����
    float Top();              //�������� �������
};
//------------------------------------------------------------------------------
//�������� �������� �� �����
int StackFloat::Pop()
{
  if (StackFloat::Count()==0)
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//������� �������� � ����
int StackFloat::Push(float x)
{
  if (top==MAX_SIZE-1)
    return -1;
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//�������� �������
float StackFloat::Top()
{
  if (StackFloat::Count()==0)
    return -1;
  return (s[top]);
}
//==============================================================================
//����� "Stack" ��� ��������� ���� "char"
class StackChar
{
  private:
    float s[MAX_SIZE];
    int top;
  public:
    StackChar(){top=0;}       //�����������
    ~StackChar(){top=0;}      //����������
    int Pop();                //�������� �������� �� �����
    int Push(char x);         //������� �������� � ����
    int Count(){return(top);} //���������� ��������� � �����
    char Top();               //�������� �������
};
//------------------------------------------------------------------------------
//�������� �������� �� �����
int StackChar::Pop()
{
  if (StackChar::Count()==0)
    return -1;
  return (--top);
}
//------------------------------------------------------------------------------
//������� �������� � ����
int StackChar::Push(char x)
{
  if (top==MAX_SIZE-1)
    return -1;
  s[++top]=x;
  return 0;
}
//------------------------------------------------------------------------------
//�������� �������
char StackChar::Top()
{
  if (StackChar::Count()==0)
    return -1;
  return (s[top]);
}
//------------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//------------------------------------------------------------------------------
//������� ������ "�������"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Form2->Show();
}
//------------------------------------------------------------------------------
//������� ������ "�����"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  Form1->Close();
}
//------------------------------------------------------------------------------
//������� ����������� ����������
int Prioritet(char x)
{
  if ((x=='+') | (x=='-'))
    return 1;
  if ((x=='*') | (x=='/'))
    return 2;
  if ((x=='^') | ((x>='A') & (x<='K')))
    return 3;
  return -1;
}
//------------------------------------------------------------------------------
void PrintFunction(FILE *out, char x)
{
  switch(x)
  {
    //sin, cos, tg, ctg, arcsin, arccos, arctg, arcctg, exp, ln, mod
    //A    B    C   D    E       F       G      H       I    J   K
    case 'A':
      fprintf(out, "sin");
      break;
    case 'B':
      fprintf(out, "cos");
      break;
    case 'C':
      fprintf(out, "tg");
      break;
    case 'D':
      fprintf(out, "ctg");
      break;
    case 'E':
      fprintf(out, "arcsin");
      break;
    case 'F':
      fprintf(out, "arccos");
      break;
    case 'G':
      fprintf(out, "arctg");
      break;
    case 'H':
      fprintf(out, "arcctg");
      break;
    case 'I':
      fprintf(out, "exp");
      break;
    case 'J':
      fprintf(out, "ln");
      break;
    case 'K':
      fprintf(out, "mod");
      break;
    default:
      if (x=='!')
        fprintf(out, " ");
      else
        if (x!=' ')
          fprintf(out, "%c", x);
      break;
  }
}
//------------------------------------------------------------------------------
//���������� �������
void TForm1::PrintGraph(FILE *out, char postfix[MAX_SIZE])
{
  Form2->Close();
  Form3->Close();
  float diapazon=StrToFloat(Form1->Edit2->Text);
  if (diapazon<=0)
  {
    Form3->Show();
    Form3->Label1->Caption="�������� ������ ���� �������������";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  int kol=Edit2->Text.Length()-1;
  char* sim=new char[Edit2->Text.Length()];
  strcpy(sim, Edit2->Text.c_str());
  if ((sim[kol]!='0') & (sim[kol]!='2') & (sim[kol]!='4') & (sim[kol]!='6') & (sim[kol]!='8'))
  {
    Form3->Show();
    Form3->Label1->Caption="�������� ������ ���� ������ ������";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  if ((diapazon<2) | (diapazon>100))
  {
    Form3->Show();
    Form3->Label1->Caption="�������� ������ ���� �������� 2 � �������� 100";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  //������� ��������� ���������� x
  float x1=-diapazon/2,
        x2=diapazon/2;
  Form4->Show();
  Form4->Canvas->Pen->Color=clWhite;
  Form4->Canvas->Pen->Style=psSolid;
  Form4->Canvas->Brush->Color=clWhite;
  //������� ������ �������
  int X1=20,                     //X - ���������� ������ �������� ����
      Y1=50,                     //Y - ���������� ������ ������� ����
      X2=Form4->ClientWidth-20,  //������
      Y2=Form4->ClientHeight-40; //������
  float dx, dy; //�������
  dx=(X2-X1)/(x2-x1);
  dy=(Y2-Y1)/(x2-x1);
  Form4->Canvas->Rectangle((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2-x1*dy+Y1, (X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2-x2*dy+Y1);
  float x;
  //-------------------------------
  //���������� �����
  long step1;
  if (x2>5)
    step1=x2/5;
  else
    step1=1;
  //������������ ���
  Form4->Canvas->Pen->Color=clBlack;
  Form4->Canvas->Pen->Width=1;
  for (x=x1;x<=x2;x+=step1)
  {
    Form4->Canvas->Brush->Color=clWhite;
    if (x==x2)
      Form4->Canvas->Brush->Color=Form4->Color;
    Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2-x*dy+Y1);
    Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2-x*dy+Y1);

    Form4->Canvas->TextOutA((X2-X1)*abs(x1)/(abs(x1)+abs(x2))+3, (Y2-Y1)/2-x*dy+Y1-13, FloatToStrF(x, ffGeneral, 0, 0));
  }
  //�������������� ���
  for (x=x1;x<=x2;x+=step1)
  {
    Form4->Canvas->Brush->Color=clWhite;
    if (x==x1)
      Form4->Canvas->Brush->Color=Form4->Color;
    Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x*dx+X1, (Y2-Y1)/2-x1*dy+Y1);
    Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x*dx+X1, (Y2-Y1)/2-x2*dy+Y1);
    if (x!=0)
      Form4->Canvas->TextOutA((X2-X1)*abs(x1)/(x2-x1)+x*dx+X1-16, (Y2-Y1)/2+Y1-13, FloatToStrF(x, ffGeneral, 0, 0));
  }
  //-------------------------------
  //���������� ����
  Form4->Canvas->Pen->Width=2;
  //Ox
  Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2+Y1);
  Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2+Y1);
  //Oy
  Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(abs(x1)+abs(x2))+X1, (Y2-Y1)/2-x1*dy+Y1);
  Form4->Canvas->LineTo((X2-X1)*abs(x1)/(abs(x1)+abs(x2))+X1, (Y2-Y1)/2-x2*dy+Y1);
  float min, max,    //����������� � ������������ ��������
        y,           //���������� y
        step2=0.001; //���������� ���������
  //���������� x ���������� �� x1 �� x2
  for (x=x1;x<=x2;x+=step2)
  {
    StackFloat stack;
    int i=0;
    while (i<strlen(postfix))
    {
      char char_num[MAX_SIZE];
      if (postfix[i]=='x')
        stack.Push(x);
      int j=0;
      if ((postfix[i]>=48) & (postfix[i]<=57))
      {
        while (((postfix[i]>=48) & (postfix[i]<=57)) | (postfix[i]=='.'))
        {
          char_num[j]=postfix[i];
          i++;
          j++;
        }
        stack.Push(atof(char_num));
      }
      if ((postfix[i]>='A') & (postfix[i]<='K'))
      {
        if (stack.Count()==0)
        {
          Form3->Show();
          Form3->Label1->Caption="������ ��� ���������� �������";
          Form3->Label2->Caption="���� ���� (������� ��������)";
          Form3->Label3->Caption="";
          Form4->Close();
          return;
        }
        float num=stack.Top();
        stack.Pop();
        switch(postfix[i])
        {
          //sin
          case 'A':
            stack.Push(sin(num));
            break;
          //cos
          case 'B':
            stack.Push(cos(num));
            break;
          //tg
          case 'C':
            stack.Push(tan(num));
            break;
          //ctg
          case 'D':
            if (tan(num)!=0)
              stack.Push(1/tan(num));
            else
              stack.Push(0);
            break;
          //arcsin
          case 'E':
            if ((num>=-1) & (num<=1))
              stack.Push(asin(num));
            else
              stack.Push(0);
            break;
          //arccos
          case 'F':
            if ((num>=-1) & (num<=1))
              stack.Push(acos(num));
            else
              stack.Push(0);
            break;
          //arctg
          case 'G':
            stack.Push(atan(num));
            break;
          //arcctg
          case 'H':
            stack.Push(1/atan(num));                                            // ?????
            break;
          //exp
          case 'I':
            stack.Push(exp(num));
            break;
          case 'J':
            if (num>0)
              stack.Push(log10(num));
            else
              stack.Push(0);
            break;
          //mod
          case 'K':
            if (num>=0)
              stack.Push(num);
            else
              stack.Push(-num);
            break;
        }
      }
      if ((postfix[i]=='+') | (postfix[i]=='-') | (postfix[i]=='*') | (postfix[i]=='/') | (postfix[i]=='^'))
      {
        if (stack.Count()<2)
        {
          Form3->Show();
          Form3->Label1->Caption="������ ��� ���������� �������";
          Form3->Label2->Caption="���� ���� (�������� ��������)";
          Form3->Label3->Caption="";
          Form4->Close();
          return;
        }
        float num2=stack.Top();
        stack.Pop();
        float num1=stack.Top();
        stack.Pop();
        switch(postfix[i])
        {
          case '+':
            stack.Push(num1+num2);
            break;
          case '-':
            stack.Push(num1-num2);
            break;
          case '*':
            stack.Push(num1*num2);
            break;
          case '/':
            if (num2!=0)
              stack.Push(num1/num2);
            else
              stack.Push(0);
            break;
          case '^':
            if (num1!=0)
              stack.Push(pow(num1,num2));
            else
              stack.Push(0);
            break;
        }
      }
      i++;
    }
    y=stack.Top();
    stack.Pop();
    fprintf(out, "\nx=%f, y=%f", x, y);
    //����� �������� � ���������
    if (x==x1)
    {
      if ((y>=x1) & (y<=x2))
        min=max=y;
      else
      {
        if (y<x1)
          min=x1;
        if (y>x2)
          max=x2;
      }
    }
    else
    {
      if ((y<min) & (y>=x1))
        min=y;
      if ((y>max) & (y<=x2))
        max=y;
    }
    //���������� ���������� �������
    float x0, y0; //���������� ��������� ����� ������
    if ((x1<=0) & (x2>=0))
      x0=(X2-X1)*abs(x1)/(x2-x1)+x*dx+X1;
    else
      x0=x*dx+X1;
    y0=(Y2-Y1)/2-y*dy+Y1;
    if ((y0<(Y2-Y1)/2-x1*dy+Y1) & (y0>(Y2-Y1)/2-x2*dy+Y1))
      if ((x0>=X1) & (x0<=X2) & (y0>Y1) & (y0<Y2))
        Form4->Canvas->Pixels[x0][y0]=clRed;
  }
  if (min-0.1<x1)
    min=x1;
  if (max+0.1>x2)
    max=x2;
  //-------------------------------
  //������� ��m Ox ��� ��� (��� x ���������� � ��� ��������� ����� (0,y))
  Form4->Canvas->Pen->Color=clBlack;
  Form4->Canvas->Pen->Width=2;
  Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2+Y1);
  Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2+Y1);
  //-------------------------------
  //����������
  Form4->Canvas->Pen->Color=clGreen;
  Form4->Canvas->Pen->Style=psDash;
  Form4->Canvas->Pen->Width=1;
  if (min!=x1)
  {
    Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2-min*dy+Y1);
    Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2-min*dy+Y1);
  }
  if (max!=x2)
  {
    Form4->Canvas->MoveTo((X2-X1)*abs(x1)/(x2-x1)+x1*dx+X1, (Y2-Y1)/2-max*dy+Y1);
    Form4->Canvas->LineTo((X2-X1)*abs(x1)/(x2-x1)+x2*dx+X1, (Y2-Y1)/2-max*dy+Y1);
  }
  //-------------------------------
  //����� �������� � ���������
  Form4->Canvas->Brush->Color=Form1->Color;
  Form4->Canvas->TextOutA(14,15,"�������:  "+FloatToStrF(min,ffFixed,6,3));
  Form4->Canvas->TextOutA(14,30,"��������: "+FloatToStrF(max,ffFixed,6,3));
  //Form4->Canvas->TextOutA(150,15,"����������� ����������: 0.01");
  fclose(out);
}
//------------------------------------------------------------------------------
//������� �������������� ����������� ��������� � �����������
//void postfix(char sim[MAX_SIZE], int kol_sim)
void TForm1::postfix(char sim[100], int kol_sim)
{
  FILE *out;
  //� ���� "out_file" ����� �������� ����������, ����������� ������ ���������,
  //� ��� �� ���������� (x,y) ��� ���������� �������
  out=fopen(out_file, "w");
  fprintf(out, "Prefix:  ");
  for (int i=0;i<kol_sim;i++)
    PrintFunction(out, sim[i]);
  fprintf(out, "\nPostfix: ");
  //������, � ������� ������� ����������� ������ ���������
  char postfix[MAX_SIZE];
  for (int i=0;i<MAX_SIZE;i++)
    postfix[i]=' ';
  int pos=0,
      i=0;
  StackChar stack;
  //���������� ����������� ������ ��������� � ������� �����
  while (i<kol_sim)
  {
    if (sim[i]=='x')
    {
      postfix[pos]='x';
      pos++;
      postfix[pos]='!';
      pos++;
    }
    if ((sim[i]>=48) & (sim[i]<=57))
    {
      postfix[pos]=sim[i];
      pos++;
      i++;
      while (((sim[i]>=48) & (sim[i]<=57)) | (sim[i]=='.'))
      {
        postfix[pos]=sim[i];
        pos++;
        i++;
      }
      postfix[pos]='!';
      pos++;
    }
    if (sim[i]=='(')
      stack.Push(sim[i]);
    if (sim[i]==')')
    {
      while (stack.Top()!='(')
      {
        postfix[pos]=stack.Top();
        pos++;
        postfix[pos]='!';
        pos++;
        stack.Pop();
      }
      stack.Pop();
    }
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^') | ((sim[i]>='A') & (sim[i]<='K'))) & (stack.Count()==0))
      stack.Push(sim[i]);
    else
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') | (sim[i]=='^') | ((sim[i]>='A') & (sim[i]<='K'))) & (stack.Count()!=0))
    {
      StackChar tmp;
      while (stack.Count()!=0)
      {
        if (stack.Top()=='(')
          break;
        if (Prioritet(stack.Top())<Prioritet(sim[i]))
        {
          tmp.Push(stack.Top());
          stack.Pop();
        }
        else
          if (Prioritet(stack.Top())>=Prioritet(sim[i]))
          {
            postfix[pos]=stack.Top();
            pos++;
            postfix[pos]='!';
            pos++;
            stack.Pop();
          }
      }
      if (tmp.Count()==0)
        stack.Push(sim[i]);
      else
      {
        while (tmp.Count()!=0)
        {
          stack.Push(tmp.Top());
          tmp.Pop();
        }
        stack.Push(sim[i]);
      }
    }
    i++;
  }
  if (stack.Count()!=0)
    while (stack.Count()!=0)
    {
      postfix[pos]=stack.Top();
      pos++;
      postfix[pos]='!';
      pos++;
      stack.Pop();
    }
    for (i=0;i<strlen(postfix)-1;i++)
      PrintFunction(out, postfix[i]);
  //���������� �������
  PrintGraph(out, postfix);
}
//------------------------------------------------------------------------------
//������� ������ "������"
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  Form4->Close();
  Grafik();
}
//------------------------------------------------------------------------------
//���������� ������� "OnPain"
void __fastcall TForm1::FormPaint(TObject *Sender)
{
  Edit1->SetFocus();
  float diapazon=StrToFloat(Form1->Edit2->Text);
  if (((diapazon<2) | (diapazon>100)))
  Edit2->SetFocus();
}
//------------------------------------------------------------------------------
//���������� �������
void TForm1::Grafik()
{
  char* sim=new char[Edit1->Text.Length()];
  strcpy(sim, Edit1->Text.c_str());
  Form4->Label1->Caption="y =";
  Form4->Label2->Caption=sim;
  int kol_sim=Edit1->Text.Length();
  //��������� ������
  if (kol_sim==0)
  {
    Edit1->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="������� ������ �������";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  if (Edit2->Text.Length()==0)
  {
    Edit2->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="������� ������ ��������";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  int i;
  //�������� ���������� �������� ��� ��������
  for (i=0;i<kol_sim;i++)
    if (((sim[i]<97) | (sim[i]>122)) &  ((sim[i]<48) | (sim[i]>57)) & (sim[i]!='.') &
      (sim[i]!='+') & (sim[i]!='-') & (sim[i]!='*') & (sim[i]!='/') & (sim[i]!='^') &
        (sim[i]!='(') & (sim[i]!=')'))
        {
          Edit1->SetFocus();
          Form3->Show();
          Form3->Label1->Caption="����������� ������ (�������: "+ FloatToStrF(i, ffGeneral, 0, 0) +")";
          if (sim[i]==' ')
            Form3->Label2->Caption="������";
          else
            Form3->Label2->Caption=sim[i];
          Form3->Label3->Caption="";
          return;
        }
  int kol=0;
  for (i=0;i<kol_sim;i++)
    if (sim[i]=='x')
      kol++;
  if (kol==0)
  {
    Edit1->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="���������� \"x\" �����������";
    Form3->Label2->Caption="";
    Form3->Label3->Caption="";
    return;
  }
  //�������� ���������� ��������  ��� ���������� �������
  if (((sim[0]<97) | (sim[0]>122)) & ((sim[0]<48) | (sim[0]>57)) & (sim[0]!='('))
  {
    Edit1->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="������������ �������� ���������� �������";
    Form3->Label2->Caption=sim[0];
    Form3->Label3->Caption="";
    return;
  }
  //�������� ���������� �������� ��� ��������� �������
  if ((sim[kol_sim-1]!='x') & ((sim[kol_sim-1]<48) | (sim[kol_sim-1]>57)) & (sim[kol_sim-1]!=')'))
  {
    Edit1->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="������������ �������� ��������� �������";
    Form3->Label2->Caption=sim[kol_sim-1];
    Form3->Label3->Caption="";
    return;
  }
  int kol1=0,
      kol2=0;
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
    Edit1->SetFocus();
    Form3->Show();
    Form3->Label1->Caption="���������� �������� \"(\" ("+FloatToStrF(kol1, ffGeneral, 0, 0) +") �� ����� ����������";
    Form3->Label2->Caption="�������� \")\" ("+FloatToStrF(kol2, ffGeneral, 0, 0) +")";
    Form3->Label3->Caption="";
    return;
  }
  //�������� ���������� �������� ��� ��������, ��������� �� ��������� ������ (����� "x")
  for (i=0;i<kol_sim-1;i++)
    if (((sim[i]>=97) & (sim[i]<=122)) & (sim[i]!='x') & ((sim[i+1]<97) | (sim[i+1]>122)) & (sim[i+1]!='('))
    {
      Edit1->SetFocus();
      Form3->Show();
      Form3->Label1->Caption="(1) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
      Form3->Label2->Caption=sim[i];
      Form3->Label3->Caption=sim[i+1];
      return;
    }
  //�������� ���������� �������� ��� ��������, ��������� �� �������� "x"
  for (i=0;i<kol_sim-1;i++)
    if ((sim[i]=='x') & (sim[i+1]!='p') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') &
      (sim[i+1]!='/') & (sim[i+1]!='^')  & (sim[i+1]!=')'))
      {
        Edit1->SetFocus();
        Form3->Show();
        Form3->Label1->Caption="(2) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
        Form3->Label2->Caption=sim[i];
        Form3->Label3->Caption=sim[i+1];
        return;
      }
  //�������� ���������� �������� ��� ��������, ��������� �� ������
  for (i=0;i<kol_sim-1;i++)
    if (((sim[i]>=48) & (sim[i]<=57)) & ((sim[i+1]<48) | (sim[i+1]>57)) & (sim[i+1]!='+') &
      (sim[i+1]!='-') & (sim[i+1]!='*') & (sim[i+1]!='/') & (sim[i+1]!='^') &  (sim[i+1]!='.') &
        (sim[i+1]!='(') & (sim[i+1]!=')'))
        {
          Edit1->SetFocus();
          Form3->Show();
          Form3->Label1->Caption="(3) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
          Form3->Label2->Caption=sim[i];
          Form3->Label3->Caption=sim[i+1];
          return;
        }
  //�������� ���������� �������� ��� ��������, ��������� �� �������������� ���������
  for (i=0;i<kol_sim-1;i++)
    if (((sim[i]=='+') | (sim[i]=='-') | (sim[i]=='*') | (sim[i]=='/') |(sim[i]=='^')) &
      ((sim[i+1]<97) | (sim[i+1]>122)) & ((sim[i+1]<48) | (sim[i+1]>57)) & (sim[i+1]!='('))
      {
        Edit1->SetFocus();
        Form3->Show();
        Form3->Label1->Caption="(4) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
        Form3->Label2->Caption=sim[i];
        Form3->Label3->Caption=sim[i+1];
        return;
      }
  //�������� ���������� �������� ��� ��������, ��������� �� �������� "("
  for (i=0;i<kol_sim-1;i++)
    if ((sim[i]=='(') & ((sim[i+1]<97) | (sim[i+1]>122)) & ((sim[i+1]<48) | (sim[i+1]>57)) & (sim[i+1]!='('))
    {
      Edit1->SetFocus();
      Form3->Show();
      Form3->Label1->Caption="(5) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
      Form3->Label2->Caption=sim[i];
      Form3->Label3->Caption=sim[i+1];
      return;
    }
  //�������� ���������� �������� ��� ��������, ��������� �� �������� ")"
  for (i=0;i<kol_sim-1;i++)
    if ((sim[i]==')') & (sim[i+1]!='+') & (sim[i+1]!='-') & (sim[i+1]!='*') &
      (sim[i+1]!='/') & (sim[i+1]!='^') & (sim[i+1]!=')'))
      {
        Edit1->SetFocus();
        Form3->Show();
        Form3->Label1->Caption="(6) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
        Form3->Label2->Caption=sim[i];
        Form3->Label3->Caption=sim[i+1];
        return;
      }
  //�������� ���������� �������� ��� ��������, ��������� �� �������� "."
  for (i=0;i<kol_sim-1;i++)
    if ((sim[i]=='.') & ((sim[i+1]<48) | (sim[i+1]>57)))
      {
        Edit1->SetFocus();
        Form3->Show();
        Form3->Label1->Caption="(7) ������������ ��������� �������� (�������: "+FloatToStrF(i, ffGeneral, 0, 0) +", "+FloatToStrF(i+1, ffGeneral, 0, 0)+")";
        Form3->Label2->Caption=sim[i];
        Form3->Label3->Caption=sim[i+1];
        return;
      }
  //������ ������� �������� ��� �������� 1 ��������
  //sin, cos, tg, ctg, arcsin, arccos, arctg, arcctg, exp, ln, mod
  //A    B    C   D    E       F       G      H       I    J   K
  //����� "arcsin", "arccos", "arctg"
  for (i=0;i<kol_sim-5;i++)
  {
    if ((sim[i]=='a') & (sim[i+1]=='r') & (sim[i+2]=='c') & (sim[i+3]=='s') & (sim[i+4]=='i') & (sim[i+5]=='n'))
    {
      sim[i]='E';
      sim[i+1]=sim[i+2]=sim[i+3]=sim[i+4]=sim[i+5]=' ';
    }
    if ((sim[i]=='a') & (sim[i+1]=='r') & (sim[i+2]=='c') & (sim[i+3]=='c') & (sim[i+4]=='o') & (sim[i+5]=='s'))
    {
      sim[i]='F';
      sim[i+1]=sim[i+2]=sim[i+3]=sim[i+4]=sim[i+5]=' ';
    }
    if ((sim[i]=='a') & (sim[i+1]=='r') & (sim[i+2]=='c') & (sim[i+3]=='c') & (sim[i+4]=='t') & (sim[i+5]=='g'))
    {
      sim[i]='H';
      sim[i+1]=sim[i+2]=sim[i+3]=sim[i+4]=sim[i+5]=' ';
    }
  }
  //����� ""arcctg
  for (i=0;i<kol_sim-4;i++)
    if ((sim[i]=='a') & (sim[i+1]=='r') & (sim[i+2]=='c') & (sim[i+3]=='t') & (sim[i+4]=='g'))
    {
      sim[i]='G';
      sim[i+1]=sim[i+2]=sim[i+3]=sim[i+4]=' ';
    }
  //����� "sin", "cos", "tg", "exp", "mod"
  for (i=0;i<kol_sim-2;i++)
  {
    if ((sim[i]=='s') & (sim[i+1]=='i') & (sim[i+2]=='n'))
    {
      sim[i]='A';
      sim[i+1]=sim[i+2]=' ';
    }
    if ((sim[i]=='c') & (sim[i+1]=='o') & (sim[i+2]=='s'))
    {
      sim[i]='B';
      sim[i+1]=sim[i+2]=' ';
    }
    if ((sim[i]=='c') & (sim[i+1]=='t') & (sim[i+2]=='g'))
    {
      sim[i]='D';
      sim[i+1]=sim[i+2]=' ';
    }
    if ((sim[i]=='e') & (sim[i+1]=='x') & (sim[i+2]=='p'))
    {
      sim[i]='I';
      sim[i+1]=sim[i+2]=' ';
    }
    if ((sim[i]=='m') & (sim[i+1]=='o') & (sim[i+2]=='d'))
    {
      sim[i]='K';
      sim[i+1]=sim[i+2]=' ';
    }
  }
  //����� "tg", "ln"
  for (i=0;i<kol_sim-1;i++)
  {
    if ((sim[i]=='t') & (sim[i+1]=='g'))
    {
      sim[i]='C';
      sim[i+1]=' ';
    }
    if ((sim[i]=='l') & (sim[i+1]=='n'))
    {
      sim[i]='J';
      sim[i+1]=' ';
    }
  }
  //����� ������ ������� �������� ������������� ������� ���
  //�������� ���������� ��������
  for (i=0;i<kol_sim;i++)
    if ((sim[i]>=97) & (sim[i]<=122) & (sim[i]!='x'))
    {
      char error_sim[MAX_SIZE];
      for (int j=0;j<=MAX_SIZE;j++)
        error_sim[j]=' ';
      int pos1=i, pos2=i;
      error_sim[0]=sim[i];
      int j=i+1;
      while (j<kol_sim)
      {
        if ((sim[j]>=97) & (sim[j]<=122))
          error_sim[j-i]=sim[j];
        else
          break;
        j++;
      }
      pos2=j-1;
      Edit1->SetFocus();
      Form3->Show();
      if (pos1==pos2)
        Form3->Label1->Caption="�������� ������������� ������� (�������: "+FloatToStrF(pos1, ffGeneral, 0, 0) +")";
      else
        Form3->Label1->Caption="�������� ���������� �������� (�������: "+FloatToStrF(pos1, ffGeneral, 0, 0) +" - "+FloatToStrF(pos2, ffGeneral, 0, 0) +")";
      Form3->Label2->Caption=error_sim;
      Form3->Label3->Caption="";
      return;
    }
  //���������� ����������� ������ �����
  postfix(sim, kol_sim);
}
