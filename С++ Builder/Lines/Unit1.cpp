//----------------------------------------------------------------------------
//*******************************************************************************
// ���� LINES                                                                   *
//*******************************************************************************
//��������: ���������� �.�. ������ ��-101                                       *
//����:                                                                         *
//����:Borland C++Builder6                                                      *
//Copyright (c) 2004, 2003-2006 ����� International Inc. All Rights Reserved.   *
//*******************************************************************************
//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include <stdlib.h>
#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
#pragma resource "Project1.RES"
TSwatForm *SwatForm;
//---------------------------------------------------------------------------
__fastcall TSwatForm::TSwatForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSwatForm::FormCreate(TObject *Sender)
{
    randomize();

    BallRed = new Graphics::TBitmap;
    BallGrin = new Graphics::TBitmap;
    BallBlue = new Graphics::TBitmap;
    BallBlack = new Graphics::TBitmap;
    BallWhite = new Graphics::TBitmap;

    BallRed->LoadFromResourceName((int)HInstance, "RED");
    BallGrin->LoadFromResourceName((int)HInstance, "GRIN");
    BallBlue->LoadFromResourceName((int)HInstance, "BLUE");
    BallBlack->LoadFromResourceName((int)HInstance, "BLACK");
    BallWhite->LoadFromResourceName((int)HInstance, "WHITE");
}
//---------------------------------------------------------------------
void __fastcall TSwatForm::FormMouseDown(TObject *Sender, TMouseButton Button,
   TShiftState Shift, int X, int Y){
   if(X < NumCol*25 && Y < NumRow*25){   //�������� "������ �� � ���� ������..."
      if(!Desk[X / 25][Y / 25]){         //���� � ���� ������ �����...
         if(Select){                     //���� ��� ������ �����...
            Desk[X/25][Y/25] = Desk[SX][SY];  //������� ���...
            Desk[SX][SY] = 0;
            DrawBall(SX, SY, 0);
            DrawBall(X/25, Y/25, Desk[X/25][Y/25]);

            if(!Prowerka()){             //�������� ���� �� ����������....
               int k=0, h, i, j, NumFree=0; //���� ���������� ��� �� �����������...
               for(i=0; i<NumCol; i++)
                  for(j=0; j<NumRow; j++)
                     if(!Desk[i][j]) NumFree++; //������� ���������
               if(NumFree<=NumBegin){           //���� ������ ������� �� ����� ����
                  for(i=0; i<NumCol; i++)
                     for(j=0; j<NumRow; j++){
                        Desk[i][j] = 0;
                        DrawBall(i, j, 0);
                     }
                  ShowMessage ("���� ��������!");
               }
               else{
                  while(k!=NumBegin){    //���� ���� ����� ����������� ����� ������...
                     i=random(NumCol); j=random(NumRow);   //naoborot esli chto
                     if(!Desk[i][j]){
                        h=random(4)+1;
                        Desk[i][j] = h;
                        k++;
                        DrawBall(i, j, h);
                     }
                  }
                  Prowerka();  //����� ���� ��� ���������� ���� ������ ���������....
               }
            }
         }
         Select = 0;
      }else{
         Select = 1;
         SX = X/25;
         SY = Y/25;
      }
     Edit6->Text = Scores;
   }
}
//---------------------------------------------------------------------------

void __fastcall TSwatForm::Exit(TObject *Sender){
   exit(1);   
}
//---------------------------------------------------------------------------
void __fastcall TSwatForm::NewGame(TObject *Sender){
   int i, j, k=0, h;    //����������� ����������
   Select = 0;          //��������� �����...
   Scores = 0;
   Edit6->Text = "0";
   for(i=0; i<NumCol; i++)
      for(j=0; j<NumRow; j++){
         Desk[i][j]=0;
         DrawBall(i, j, 0);
      }
   while(k!=NumBegin){   //������������ �������...
      i=random(NumCol);   //naoborot
      j=random(NumRow);   //     esli chto
      if(!Desk[i][j]){
          h=random(4)+1;
          Desk[i][j] = h;
          k++;
          DrawBall(i, j, h);
      }
   }
}
//---------------------------------------------------------------------------
int TSwatForm::Prowerka(){      //������� �������� �� ����������.....
   int i, j;
   for(i=0; i<NumCol; i++)
      for(j=0; j<NumRow; j++){      //9-str
         if(i<=NumCol-9 && Desk[i][j] && Desk[i][j]==Desk[i+1][j] &&            Desk[i+1][j]==Desk[i+2][j] && Desk[i+2][j]==Desk[i+3][j] &&            Desk[i+3][j]==Desk[i+4][j] && Desk[i+4][j]==Desk[i+5][j] &&                           Desk[i+5][j]==Desk[i+6][j] && Desk[i+6][j]==Desk[i+7][j] && Desk[i+7][j]==Desk[i+8][j]){
            Scores += 1280;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j] = 0; DrawBall(i+1, j, 0);            Desk[i+2][j] = 0; DrawBall(i+2, j, 0);            Desk[i+3][j] = 0; DrawBall(i+3, j, 0);            Desk[i+4][j] = 0; DrawBall(i+4, j, 0);            Desk[i+5][j] = 0; DrawBall(i+5, j, 0);            Desk[i+6][j] = 0; DrawBall(i+6, j, 0);            Desk[i+7][j] = 0; DrawBall(i+7, j, 0);            Desk[i+8][j] = 0; DrawBall(i+8, j, 0);
            return 1;
         }else      //8-str
         if(i<=NumCol-8 && Desk[i][j] && Desk[i][j]==Desk[i+1][j] &&            Desk[i+1][j]==Desk[i+2][j] && Desk[i+2][j]==Desk[i+3][j] &&            Desk[i+3][j]==Desk[i+4][j] && Desk[i+4][j]==Desk[i+5][j] &&                           Desk[i+5][j]==Desk[i+6][j] && Desk[i+6][j]==Desk[i+7][j]){
            Scores += 640;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j] = 0; DrawBall(i+1, j, 0);            Desk[i+2][j] = 0; DrawBall(i+2, j, 0);            Desk[i+3][j] = 0; DrawBall(i+3, j, 0);            Desk[i+4][j] = 0; DrawBall(i+4, j, 0);            Desk[i+5][j] = 0; DrawBall(i+5, j, 0);            Desk[i+6][j] = 0; DrawBall(i+6, j, 0);            Desk[i+7][j] = 0; DrawBall(i+7, j, 0);
            return 1;
         }else        //7-str
         if(i<=NumCol-7 && Desk[i][j] && Desk[i][j]==Desk[i+1][j] &&            Desk[i+1][j]==Desk[i+2][j] && Desk[i+2][j]==Desk[i+3][j] &&            Desk[i+3][j]==Desk[i+4][j] && Desk[i+4][j]==Desk[i+5][j] &&                                          Desk[i+5][j]==Desk[i+6][j]){
            Scores += 320;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j] = 0; DrawBall(i+1, j, 0);            Desk[i+2][j] = 0; DrawBall(i+2, j, 0);            Desk[i+3][j] = 0; DrawBall(i+3, j, 0);            Desk[i+4][j] = 0; DrawBall(i+4, j, 0);            Desk[i+5][j] = 0; DrawBall(i+5, j, 0);            Desk[i+6][j] = 0; DrawBall(i+6, j, 0);
            return 1;
         }else        //6-str
         if(i<=NumCol-6 && Desk[i][j] && Desk[i][j]==Desk[i+1][j] &&            Desk[i+1][j]==Desk[i+2][j] && Desk[i+2][j]==Desk[i+3][j] &&            Desk[i+3][j]==Desk[i+4][j] && Desk[i+4][j]==Desk[i+5][j]){
            Scores += 160;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j] = 0; DrawBall(i+1, j, 0);            Desk[i+2][j] = 0; DrawBall(i+2, j, 0);            Desk[i+3][j] = 0; DrawBall(i+3, j, 0);            Desk[i+4][j] = 0; DrawBall(i+4, j, 0);            Desk[i+5][j] = 0; DrawBall(i+5, j, 0);
            return 1;
         }else           //5-str
         if(i<=NumCol-5 && Desk[i][j] && Desk[i][j]==Desk[i+1][j] &&            Desk[i+1][j]==Desk[i+2][j] && Desk[i+2][j]==Desk[i+3][j] &&                                          Desk[i+3][j]==Desk[i+4][j]){
            Scores += 80;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j] = 0; DrawBall(i+1, j, 0);            Desk[i+2][j] = 0; DrawBall(i+2, j, 0);            Desk[i+3][j] = 0; DrawBall(i+3, j, 0);            Desk[i+4][j] = 0; DrawBall(i+4, j, 0);
            return 1;
         }         //9-stol
         if(j<=NumRow-9 && Desk[i][j] && Desk[i][j]==Desk[i][j+1] &&            Desk[i][j+1]==Desk[i][j+2] && Desk[i][j+2]==Desk[i][j+3] &&            Desk[i][j+3]==Desk[i][j+4] && Desk[i][j+4]==Desk[i][j+5] &&                                          Desk[i][j+5]==Desk[i][j+6] && Desk[i][j+6]==Desk[i][j+7] && Desk[i][j+7]==Desk[i][j+8]){
            Scores += 1280;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i][j+1] = 0; DrawBall(i, j+1, 0);            Desk[i][j+2] = 0; DrawBall(i, j+2, 0);            Desk[i][j+3] = 0; DrawBall(i, j+3, 0);            Desk[i][j+4] = 0; DrawBall(i, j+4, 0);            Desk[i][j+5] = 0; DrawBall(i, j+5, 0);            Desk[i][j+6] = 0; DrawBall(i, j+6, 0);            Desk[i][j+7] = 0; DrawBall(i, j+7, 0);            Desk[i][j+8] = 0; DrawBall(i, j+8, 0);
            return 1;
         }else         //8-stol
         if(j<=NumRow-8 && Desk[i][j] && Desk[i][j]==Desk[i][j+1] &&            Desk[i][j+1]==Desk[i][j+2] && Desk[i][j+2]==Desk[i][j+3] &&            Desk[i][j+3]==Desk[i][j+4] && Desk[i][j+4]==Desk[i][j+5] &&                                          Desk[i][j+5]==Desk[i][j+6] && Desk[i][j+6]==Desk[i][j+7]){
            Scores += 640;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i][j+1] = 0; DrawBall(i, j+1, 0);            Desk[i][j+2] = 0; DrawBall(i, j+2, 0);            Desk[i][j+3] = 0; DrawBall(i, j+3, 0);            Desk[i][j+4] = 0; DrawBall(i, j+4, 0);            Desk[i][j+5] = 0; DrawBall(i, j+5, 0);            Desk[i][j+6] = 0; DrawBall(i, j+6, 0);            Desk[i][j+7] = 0; DrawBall(i, j+7, 0);
            return 1;
         }else         //7-stol
         if(j<=NumRow-7 && Desk[i][j] && Desk[i][j]==Desk[i][j+1] &&            Desk[i][j+1]==Desk[i][j+2] && Desk[i][j+2]==Desk[i][j+3] &&            Desk[i][j+3]==Desk[i][j+4] && Desk[i][j+4]==Desk[i][j+5] &&                                          Desk[i][j+5]==Desk[i][j+6]){
            Scores += 320;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i][j+1] = 0; DrawBall(i, j+1, 0);            Desk[i][j+2] = 0; DrawBall(i, j+2, 0);            Desk[i][j+3] = 0; DrawBall(i, j+3, 0);            Desk[i][j+4] = 0; DrawBall(i, j+4, 0);            Desk[i][j+5] = 0; DrawBall(i, j+5, 0);            Desk[i][j+6] = 0; DrawBall(i, j+6, 0);
            return 1;
         }else        //6-stol
         if(j<=NumRow-6 && Desk[i][j] && Desk[i][j]==Desk[i][j+1] &&            Desk[i][j+1]==Desk[i][j+2] && Desk[i][j+2]==Desk[i][j+3] &&            Desk[i][j+3]==Desk[i][j+4] && Desk[i][j+4]==Desk[i][j+5]){
            Scores += 160;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i][j+1] = 0; DrawBall(i, j+1, 0);            Desk[i][j+2] = 0; DrawBall(i, j+2, 0);            Desk[i][j+3] = 0; DrawBall(i, j+3, 0);            Desk[i][j+4] = 0; DrawBall(i, j+4, 0);            Desk[i][j+5] = 0; DrawBall(i, j+5, 0);
            return 1;
         }else          //5-stol
         if(j<=NumRow-5 && Desk[i][j] && Desk[i][j]==Desk[i][j+1] &&            Desk[i][j+1]==Desk[i][j+2] && Desk[i][j+2]==Desk[i][j+3] &&                                          Desk[i][j+3]==Desk[i][j+4]){
            Scores += 80;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i][j+1] = 0; DrawBall(i, j+1, 0);            Desk[i][j+2] = 0; DrawBall(i, j+2, 0);            Desk[i][j+3] = 0; DrawBall(i, j+3, 0);            Desk[i][j+4] = 0; DrawBall(i, j+4, 0);
            return 1;
         }             //9-str \ stol
         if(i<=NumCol-9 && j<=NumRow-9 && Desk[i][j] && Desk[i][j]==Desk[i+1][j+1] &&            Desk[i+1][j+1]==Desk[i+2][j+2] && Desk[i+2][j+2]==Desk[i+3][j+3] &&            Desk[i+3][j+3]==Desk[i+4][j+4] && Desk[i+4][j+4]==Desk[i+5][j+5] &&                                              Desk[i+5][j+5]==Desk[i+6][j+6] && Desk[i+6][j+6]==Desk[i+7][j+7] && Desk[i+7][j+7]==Desk[i+8][j+8]){
            Scores += 1280;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j+1] = 0; DrawBall(i+1, j+1, 0);            Desk[i+2][j+2] = 0; DrawBall(i+2, j+2, 0);            Desk[i+3][j+3] = 0; DrawBall(i+3, j+3, 0);            Desk[i+4][j+4] = 0; DrawBall(i+4, j+4, 0);            Desk[i+5][j+5] = 0; DrawBall(i+5, j+5, 0);            Desk[i+6][j+6] = 0; DrawBall(i+6, j+6, 0);            Desk[i+7][j+7] = 0; DrawBall(i+7, j+7, 0);            Desk[i+8][j+8] = 0; DrawBall(i+8, j+8, 0);
            return 1;
         }else         //8-str \ stol
         if(i<=NumCol-8 && j<=NumRow-8 && Desk[i][j] && Desk[i][j]==Desk[i+1][j+1] &&            Desk[i+1][j+1]==Desk[i+2][j+2] && Desk[i+2][j+2]==Desk[i+3][j+3] &&            Desk[i+3][j+3]==Desk[i+4][j+4] && Desk[i+4][j+4]==Desk[i+5][j+5] &&                                              Desk[i+5][j+5]==Desk[i+6][j+6] && Desk[i+6][j+6]==Desk[i+7][j+7]){
            Scores += 640;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j+1] = 0; DrawBall(i+1, j+1, 0);            Desk[i+2][j+2] = 0; DrawBall(i+2, j+2, 0);            Desk[i+3][j+3] = 0; DrawBall(i+3, j+3, 0);            Desk[i+4][j+4] = 0; DrawBall(i+4, j+4, 0);            Desk[i+5][j+5] = 0; DrawBall(i+5, j+5, 0);            Desk[i+6][j+6] = 0; DrawBall(i+6, j+6, 0);            Desk[i+7][j+7] = 0; DrawBall(i+7, j+7, 0);
            return 1;
         }else        //7-str \ stol
         if(i<=NumCol-7 && j<=NumRow-7 && Desk[i][j] && Desk[i][j]==Desk[i+1][j+1] &&            Desk[i+1][j+1]==Desk[i+2][j+2] && Desk[i+2][j+2]==Desk[i+3][j+3] &&            Desk[i+3][j+3]==Desk[i+4][j+4] && Desk[i+4][j+4]==Desk[i+5][j+5] &&                                              Desk[i+5][j+5]==Desk[i+6][j+6]){
            Scores += 320;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j+1] = 0; DrawBall(i+1, j+1, 0);            Desk[i+2][j+2] = 0; DrawBall(i+2, j+2, 0);            Desk[i+3][j+3] = 0; DrawBall(i+3, j+3, 0);            Desk[i+4][j+4] = 0; DrawBall(i+4, j+4, 0);            Desk[i+5][j+5] = 0; DrawBall(i+5, j+5, 0);            Desk[i+6][j+6] = 0; DrawBall(i+6, j+6, 0);
            return 1;
         }else       //6-str \ stol
         if(i<=NumCol-6 && j<=NumRow-6 && Desk[i][j] && Desk[i][j]==Desk[i+1][j+1] &&            Desk[i+1][j+1]==Desk[i+2][j+2] && Desk[i+2][j+2]==Desk[i+3][j+3]&&            Desk[i+3][j+3]==Desk[i+4][j+4] && Desk[i+4][j+4]==Desk[i+5][j+5]){
            Scores += 160;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j+1] = 0; DrawBall(i+1, j+1, 0);            Desk[i+2][j+2] = 0; DrawBall(i+2, j+2, 0);            Desk[i+3][j+3] = 0; DrawBall(i+3, j+3, 0);            Desk[i+4][j+4] = 0; DrawBall(i+4, j+4, 0);            Desk[i+5][j+5] = 0; DrawBall(i+5, j+5, 0);
            return 1;
         }else          //5-str \ stol
         if(i<=NumCol-5 && j<=NumRow-5 && Desk[i][j] && Desk[i][j]==Desk[i+1][j+1] &&            Desk[i+1][j+1]==Desk[i+2][j+2] && Desk[i+2][j+2]==Desk[i+3][j+3]&&                                              Desk[i+3][j+3]==Desk[i+4][j+4]){
            Scores += 80;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j+1] = 0; DrawBall(i+1, j+1, 0);            Desk[i+2][j+2] = 0; DrawBall(i+2, j+2, 0);            Desk[i+3][j+3] = 0; DrawBall(i+3, j+3, 0);            Desk[i+4][j+4] = 0; DrawBall(i+4, j+4, 0);
            return 1;
         }       //9-str /stol
         if(i<=NumCol-9 && j>=8 && Desk[i][j] && Desk[i][j]==Desk[i+1][j-1] &&            Desk[i+1][j-1]==Desk[i+2][j-2] && Desk[i+2][j-2]==Desk[i+3][j-3] &&            Desk[i+3][j-3]==Desk[i+4][j-4] && Desk[i+4][j-4]==Desk[i+5][j-5] &&                                              Desk[i+5][j-5]==Desk[i+6][j-6] && Desk[i+6][j-6]==Desk[i+7][j-7] && Desk[i+7][j-7]==Desk[i+8][j-8]){
            Scores += 1280;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j-1] = 0; DrawBall(i+1, j-1, 0);            Desk[i+2][j-2] = 0; DrawBall(i+2, j-2, 0);            Desk[i+3][j-3] = 0; DrawBall(i+3, j-3, 0);            Desk[i+4][j-4] = 0; DrawBall(i+4, j-4, 0);            Desk[i+5][j-5] = 0; DrawBall(i+5, j-5, 0);            Desk[i+6][j-6] = 0; DrawBall(i+6, j-6, 0);            Desk[i+7][j-7] = 0; DrawBall(i+7, j-7, 0);            Desk[i+8][j-8] = 0; DrawBall(i+8, j-8, 0);
            return 1;
         }else         //8-str /stol
         if(i<=NumCol-8 && j>=7 && Desk[i][j] && Desk[i][j]==Desk[i+1][j-1] &&            Desk[i+1][j-1]==Desk[i+2][j-2] && Desk[i+2][j-2]==Desk[i+3][j-3] &&            Desk[i+3][j-3]==Desk[i+4][j-4] && Desk[i+4][j-4]==Desk[i+5][j-5] &&                                              Desk[i+5][j-5]==Desk[i+6][j-6] && Desk[i+6][j-6]==Desk[i+7][j-7]){
            Scores += 640;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j-1] = 0; DrawBall(i+1, j-1, 0);            Desk[i+2][j-2] = 0; DrawBall(i+2, j-2, 0);            Desk[i+3][j-3] = 0; DrawBall(i+3, j-3, 0);            Desk[i+4][j-4] = 0; DrawBall(i+4, j-4, 0);            Desk[i+5][j-5] = 0; DrawBall(i+5, j-5, 0);            Desk[i+6][j-6] = 0; DrawBall(i+6, j-6, 0);            Desk[i+7][j-7] = 0; DrawBall(i+7, j-7, 0);
            return 1;
         }else         //7-str /stol
         if(i<=NumCol-7 && j>=6 && Desk[i][j] && Desk[i][j]==Desk[i+1][j-1] &&            Desk[i+1][j-1]==Desk[i+2][j-2] && Desk[i+2][j-2]==Desk[i+3][j-3] &&            Desk[i+3][j-3]==Desk[i+4][j-4] && Desk[i+4][j-4]==Desk[i+5][j-5] &&                                              Desk[i+5][j-5]==Desk[i+6][j-6]){
            Scores += 320;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j-1] = 0; DrawBall(i+1, j-1, 0);            Desk[i+2][j-2] = 0; DrawBall(i+2, j-2, 0);            Desk[i+3][j-3] = 0; DrawBall(i+3, j-3, 0);            Desk[i+4][j-4] = 0; DrawBall(i+4, j-4, 0);            Desk[i+5][j-5] = 0; DrawBall(i+5, j-5, 0);            Desk[i+6][j-6] = 0; DrawBall(i+6, j-6, 0);
            return 1;
         }else       //6-str /stol
         if(i<=NumCol-6 && j>=5 && Desk[i][j] && Desk[i][j]==Desk[i+1][j-1] &&            Desk[i+1][j-1]==Desk[i+2][j-2] && Desk[i+2][j-2]==Desk[i+3][j-3] &&            Desk[i+3][j-3]==Desk[i+4][j-4] && Desk[i+4][j-4]==Desk[i+5][j-5]){
            Scores += 160;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j-1] = 0; DrawBall(i+1, j-1, 0);            Desk[i+2][j-2] = 0; DrawBall(i+2, j-2, 0);            Desk[i+3][j-3] = 0; DrawBall(i+3, j-3, 0);            Desk[i+4][j-4] = 0; DrawBall(i+4, j-4, 0);            Desk[i+5][j-5] = 0; DrawBall(i+5, j-5, 0);
            return 1;
         }else      //5-str /stol
         if(i<=NumCol-5 && j>=4 && Desk[i][j] && Desk[i][j]==Desk[i+1][j-1] &&            Desk[i+1][j-1]==Desk[i+2][j-2] && Desk[i+2][j-2]==Desk[i+3][j-3] &&                                              Desk[i+3][j-3]==Desk[i+4][j-4]){
            Scores += 80;            Desk[i]  [j] = 0; DrawBall(i, j, 0);            Desk[i+1][j-1] = 0; DrawBall(i+1, j-1, 0);            Desk[i+2][j-2] = 0; DrawBall(i+2, j-2, 0);            Desk[i+3][j-3] = 0; DrawBall(i+3, j-3, 0);            Desk[i+4][j-4] = 0; DrawBall(i+4, j-4, 0);
            return 1;
         }
      }
return 0;
}
//---------------------------------------------------------------------------
void TSwatForm::DrawBall(int i, int j, int h){       //������� ���������...i,j-����� ������ ,h-����...
   if (h==0) Canvas->Draw(i*25, j*25, BallWhite);
   if (h==1) Canvas->Draw(i*25, j*25, BallRed);
   if (h==2) Canvas->Draw(i*25, j*25, BallGrin);
   if (h==3) Canvas->Draw(i*25, j*25, BallBlue);
   if (h==4) Canvas->Draw(i*25, j*25, BallBlack);
}

void __fastcall TSwatForm::BeginGame(TObject *Sender)
{
    int i, j;                                 //��������� ��������� � ���������...
    for(i=0; i<NumCol; i++)
      for(j=0; j<NumRow; j++){
         Desk[i][j] = 0;
         DrawBall(i, j, 0);
   }
}
//---------------------------------------------------------------------------

