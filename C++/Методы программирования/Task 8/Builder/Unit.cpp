//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit.h"
#include <time.h>
#include <stdio.h>

#define out_file "output.txt"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Pain(TObject *Sender)
{
  Edit1->SetFocus();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Form1->Close();
}
//----------------------------------------------------------------------------

TForm1::MQuickSort(long m, int a[MAX_SIZE], long n)
{
  long i, j, //����� �������
       N1,   //������������� ������ ������� (N1<=N)
       pos,  //������� ���������� ��������
       k=1;  //�����, ������������ �������� "j" � "N1"
  int e,     //��������� �������
      temp;  //��������������� ����������
  //���������� m ��������
  for (int p=1;p<=m;p++)
  {
    i=0;
    j=N1=(k+1)*n/(m+1),
    pos=k*n/(m+1);
    e=a[pos];
    do
    {
      while (a[i]<e)
        i++;
      while (a[j]>e)
        j--;
      if (i<=j)
      {
        temp=a[i];
        a[i]=a[j];
        a[j]=temp;
        i++;
        j--;
      }
    } while (i<=j);
    //����������� ������
    if (j>0)
      MQuickSort(m, a, j);
    if (i<N1)
      MQuickSort(m, a+i, N1-i);
    k++;
  }
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button1Click(TObject *Sender)
{
  clock_t start_prog, // ������ ������ ���������
          end_prog;   // ���������� ������ ���������
  start_prog=clock();
  if ((Edit1->Text).Length()==0)
  {
    MessageDlg("���������� ������ ����� ��������� ���������", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit1->SetFocus();
    return;
  }
  if ((Edit2->Text).Length()==0)
  {
    MessageDlg("���������� ������ ����� ��������", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit2->SetFocus();
    return;
  }
  if ((Edit3->Text).Length()==0)
  {
    MessageDlg("���������� ������ ����� ��������� � ������ �������", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit3->SetFocus();
    return;
  }
  long M=StrToFloat(Edit1->Text),
       kol_array=StrToFloat(Edit2->Text),
       N=StrToFloat(Edit3->Text);
  int error=0; //����� ������ (0 - ��� ������)
  if (kol_array<1) error=1;
  if (M<1) error=2;
  if (N<2) error=3;
  if (M>N/2) error=4;
  switch (error)
  {
    case 1:
      MessageDlg("����� �������� ����� 1", mtInformation, TMsgDlgButtons() <<mbOK, 0);
      Edit2->SetFocus();
      return;
    case 2:
      MessageDlg("����� ��������� ��������� ������ 1", mtInformation, TMsgDlgButtons() <<mbOK, 0);
      Edit1->SetFocus();
      return;
    case 3:
      MessageDlg("����� ��������� � �������� ������ 2", mtInformation, TMsgDlgButtons() <<mbOK, 0);
      Edit3->SetFocus();
      return;
    case 4:
      ShowMessage("����� ��������� ��������� ������, ��� \n�������� ����� ��������� � ������ �������");
      Edit1->SetFocus();
      return;
  }
  FILE *out, *res;
  out=fopen(out_file, "w");
  long i, pers=1000;
  for (long mod=1;mod<=kol_array;mod++)
  {
    if (pers==mod)
    {
      Refresh();
      Label4->Caption="����� ��������������� ��������:" + FloatToStrF(pers, ffGeneral, 7, 2);
      pers+=1000;
    }
    int a[MAX_SIZE], b[MAX_SIZE];
    for (i=0;i<N;i++)
      a[i]=rand()%(10*kol_array);
    fprintf(out, "������ %i\n", mod);
    fprintf(out, "�� ����������:    ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    MQuickSort(M, a, N-1); //���������� ������� a[MAX_SIZE]
    fprintf(out, "\n����� ����������: ");
    for (i=0;i<N;i++)
      fprintf(out, "%i ", a[i]);
    fprintf(out, "\n----------------------------------------");
    fprintf(out, "----------------------------------------\n");
  }
  fclose(out);
  end_prog=clock();
  float cpu_time_used=((float)(end_prog-start_prog))/CLOCKS_PER_SEC;
  //printf("\n\nThe time of program work: %0.3f sec", cpu_time_used);
  //printf("\nOpen file \"output.txt\"");
  //printf("\nOpen file \"result.txt\"");
  //Label4->Caption="����� ������ ���������: "+ FloatToStrF(cpu_time_used, ffGeneral, 7, 2)+" sec.";
  //Label5->Caption="Open files \"output.txt\" � \"result.txt\"";
  //ShowMessage("����� ������ ���������: "+ FloatToStrF(cpu_time_used, ffGeneral, 7, 2)+" sec."+"\n�������� ����� \"output.txt\" � \"result.txt\"");
  Refresh();
  Label4->Caption="����� ��������������� ��������:" + FloatToStrF(kol_array, ffGeneral, 7, 2);
  Label5->Caption="����� ������ ���������: "+ FloatToStrF(cpu_time_used, ffGeneral, 7, 2)+" sec";
  Edit1->SetFocus();
}
//---------------------------------------------------------------------------
