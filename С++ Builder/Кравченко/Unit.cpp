//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Unit.h"
#include <stdio.h>
#include <time.h>

#define MAX_SIZE 1000
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
//������ "Start"
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  clock_t start, // ������ ������ ���������
          end;   // ���������� ������ ���������
  start=clock();
  if(Edit1->Text.Length()==0)
  {
    MessageDlg("������� ������ ��� �����", mtInformation, TMsgDlgButtons() <<mbOK, 0);
    Edit1->SetFocus();
    return;
  }
  char* cp = new char[ Edit1->Text.Length() + 1 ];
  strcpy(cp, Edit1->Text.c_str());
  FILE *input;
  input=fopen(cp, "r");
  int i, j;
  char sim[MAX_SIZE],
       str[MAX_SIZE][MAX_SIZE];
  FILE *output1, *output2;
  output1=fopen("output1.txt", "w");
  output2=fopen("output2.txt", "w");
  i=j=0;
  fprintf(output2, "#0: ");
  while(!feof(input))
  {
    sim[i]=fgetc(input);
    if(sim[i]=='\n')
    {
      if(i==1000)
      {
        MessageDlg("������� ����� ����� � �����\n(������ 1000)", mtInformation, TMsgDlgButtons() <<mbOK, 0);
        Edit1->SetFocus();
        return;
      }
      i++;
      j=0;
      fprintf(output2, "\n#%i: ", i);
    }
    else
    {
      str[i][j]=sim[i];
      fprintf(output2, "%c", str[i][j]);
      j++;
    }
  }
  fclose(input);
  fprintf(output2, "\n--------------------------------------------------------------------------------");
  fprintf(output2, "\n--------------------------------------------------------------------------------");
  fprintf(output2, "\n���������� ������:");
  long kol_str=i,
       kol=0, k;
  int flag;
  for(i=0;i<kol_str;i++)
  {
    flag=0;
    for(j=i+1;j<kol_str;j++)
      if (strcmp(str[i],str[j])==0)
      {
        fprintf(output2, "\n������ %i, ������ %i", i, j);
        flag=1;
        kol++;
      }
     if(flag==0)
     {
       for(k=0;k<strlen(str[i]);k++)
         fprintf(output1, "%c", str[i][k]);
       fprintf(output1, "\n");
     }
  }
  fprintf(output2, "\n\n����� ���������� �����: %i", kol);
  fclose(output1);
  fclose(output2);
  end=clock();
  //����� ������ ���������
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  Label2->Caption="������� "+FloatToStrF(kol, ffGeneral, 10, 10)+" ���������� �����(�)";
  Label3->Caption="����� ������ ���������: "+FloatToStrF(cpu_time_used, ffGeneral, 2, 10)+" sec";
  Label4->Caption="�������� ����� \"output1.txt\" � \"output2.txt\"";
  Button1->Enabled=false;
  Button2->Enabled=false;
  Button4->Enabled=false;
}
//---------------------------------------------------------------------------
//������ "�������..."
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  OpenDialog1->InitialDir = "";     // ������� �������, �� �������� �������� ���������
  OpenDialog1->FileName = "*.txt";  // ������� ������ AVI-������
  if ( OpenDialog1->Execute())
  {
    // ������������ ������ ���� � ����� ������ �������
    Edit1->Text = OpenDialog1->FileName; // ���������� ��� �����
  }
}
//---------------------------------------------------------------------------
//������ "Exit"
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  Form1->Close();
}
//---------------------------------------------------------------------------
//������ "� ���������"
void __fastcall TForm1::Button4Click(TObject *Sender)
{
  MessageDlg("�����: ������� �. �.\n����� ����������: Borland C++ Builder v6\n����: 14.03.2005.\n\n��������� ������������ ����� ����������\n������ ��������� ����� (*.txt) � ������� ��", mtInformation, TMsgDlgButtons() <<mbOK, 0);
}
//---------------------------------------------------------------------------
