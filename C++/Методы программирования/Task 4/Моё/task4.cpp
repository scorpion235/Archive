/*******************************************
 * ��������� ����������� � ������� ������- *
 * ����� ��� ����������� ����� � ��������  *
 * ��������, ������� � ���������� �� ����- *
 * ��� ��������� ����� �������� �������    *
 * �����                                   *
 *******************************************
 * �����: ������� ������ MK-301            *
 * ����: 16.02.05                          *
 * ����� ����������: Builder C++ V6.0      *
 *******************************************/

#include <vcl.h>
#pragma hdrstop

#include "task4.h"
#include <stdio.h>
#include <time.h>
#define MAX_SIZE 500
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
//������� ������ "���������"
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Form1->Close();
}
//---------------------------------------------------------------------------
//������� ������ "���������"
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  clock_t start, // ������ ������ ���������
          end;   // ���������� ������ ���������
  start=clock();
  //�������� ������� �� ������
  if (((Edit1->Text).Length()==0) || ((Edit2->Text).Length()==0))
  {
    MessageDlg("���������� ������ ������� � ������ �������",
      mtInformation, TMsgDlgButtons() <<mbOK, 0);
    if ((Edit1->Text).Length()==0)
      Edit1->SetFocus();
    else
      Edit2->SetFocus();
    return;
  }
  //���� ������ ������� ������ �������
  if (StrToFloat(Edit1->Text)>StrToFloat(Edit2->Text))
  {
    MessageDlg("������ ������� �� ����� ���� ������ �������",
      mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit1->SetFocus();
    return;
  }
  FILE *input;
  //������� ���� "input.txt" �� ������
  input=fopen("input.txt","rt");
  if (input==NULL)
  {
    MessageDlg("���� \"input.txt\" �� ������", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }
  long number[MAX_SIZE], //������ ������� ����������
       i=0, j;            //��������
  while(!feof(input))    //���� �� ��������� ����� ����� "input.txt"
  {
    //���������� �� ����� "input.txt" ������� ����������
    fscanf(input, "%i", &number[i]);
    if (number[i]<2)
    {
      MessageDlg("� ����� \"input.txt\" ������ ������� ������� 2", mtInformation, TMsgDlgButtons() <<mbOK, 0);
      return;
    }
    i++;
  }
  fclose(input); //�������� ����� "input.txt"
  if (i<=1)
  {
    MessageDlg("������� ���������� ������ ���� �� ������ ����", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }
  //Label5->Caption="����������, ���������...";
  long kol_num=++i,   //����� ������� ����������
       lim1=StrToFloat(Edit1->Text), //����� ������� ������
       lim2=StrToFloat(Edit2->Text), //������ ������� ������
       list[MAX_SIZE][MAX_SIZE];     //������ �������
  for(i=0;i<kol_num;i++)
    list[i][0]=number[i];
  long count=1,         //����� ��������� � ������ ������
      result[MAX_SIZE], //������ ������� ����������� �����
      min[MAX_SIZE],    //����������� ������� � ������ ������
      minimum;          //����������� ������� ����� ���� �������
  result[0]=1;
  //���� �� ���������� ������ ������� ������
  while(result[count]<lim2)
  {
    for(i=0;i<kol_num;i++)
      min[i]=list[i][count-1];
    //����� ������������ �������� � ������ ������
    for(i=0;i<=kol_num;i++)
      for(j=0;j<count-1;j++)
        if ((list[i][j]<min[i]) & (list[i][j]!=0))
          min[i]=list[i][j];
    minimum=min[0];
    //����� ������������ �������� ����� ���� �������
    for(i=1;i<kol_num;i++)
      if (min[i]<minimum)
        minimum=min[i];
    //������ �� 0 ���� ��������� ������ ������������ ����� ���� �������
    for(i=0;i<=kol_num;i++)
      for(j=0;j<count;j++)
        if (list[i][j]==minimum)
          list[i][j]=0;
    result[count]=minimum; //��������� ������� ����������� �����
    //���������� �� ������ �������� � ������ ������
    for(i=0;i<kol_num;i++)
      list[i][count]=number[i]*minimum;
    count++; //���������� ����� �������
  }
  FILE *output;
  output=fopen("output.txt", "wt");
  /*if (output==NULL)
  {
    MessageDlg("���� \"output.txt\" �� ������", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    return;
  }*/
  fprintf(output, "������� ���������: ");
  for(i=0;i<kol_num-1;i++)
    fprintf(output, "%i ", number[i]);
  fprintf(output, "\n������ �������:  %i\n������� �������: %i\n������� �����:\n", lim1, lim2);
  j=0;
  for(i=0;i<count;i++)
    if ((result[i]>=lim1) & (result[i]<=lim2))
    {
      fprintf(output, "%i\n", result[i]);
      j++;
    }
  if (j==0)
    fprintf(output, "NULL");
  fclose(output);
  end=clock();
  //����� ������ ���������
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  Label5->Caption="������� "+FloatToStrF(j, ffGeneral, 10, 10)+" �����(�)";
  Label6->Caption="����� ������ ���������: "+FloatToStrF(cpu_time_used, ffGeneral, 2, 10)+" sec";
  Label7->Caption="�������� ���� \"output.txt\"";
  Button1->Enabled=false;
  Button3->Enabled=false;
  return;
}
//--------------------------------------------------------------------------
//������� ������ "� ���������"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  MessageDlg("�����: ������� ������ ����������, ������ ��-301\n����� ����������: Borland C++ Builder Versin 6.0\n����: 1 ����� 2005 ����\n\n��������� ����������� � ������� ����������� ��� ����������� ����� � �������� ��������, ������� � ���������� �� ������� ��������� ����� �������� ������� �����",
    mtCustom, TMsgDlgButtons() <<mbOK, 0);
  return;
}
//---------------------------------------------------------------------------
//������� ������� � ���� "������ �������"
void __fastcall TForm1::Edit1KeyPress(TObject *Sender, char &Key)
{
  //���� ����������� ������ ������� ����, � ����������
  //������� ���� ������ � ���� �������������� �� ���������
  //Key-��� ������� �������
  if ((Key>='0') & (Key<='9')) //�����
    return;
  if (Key==VK_BACK) //������� <BackSpase>
    return;
  if (Key==VK_RETURN) // ������� <Enter>
  {
    Edit2->SetFocus();
    return;
  }
  //��������� ������� ���������
  Key=0;
}
//---------------------------------------------------------------------------
//������� ������� � ���� "������� �������"
void __fastcall TForm1::Edit2KeyDown(TObject *Sender, WORD &Key, TShiftState Shift)
{
  if ((Key>='0') & (Key<='9')) //�����
    return;
  if (Key==VK_BACK) //������� <BackSpase>
    return;
  if (Key==VK_RETURN) // ������� <Enter>
  {
    Button1->SetFocus();
    return;
  }
  //��������� ������� ���������
  Key=0;
}
//---------------------------------------------------------------------------
