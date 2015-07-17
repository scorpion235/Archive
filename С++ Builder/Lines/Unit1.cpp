//----------------------------------------------------------------------------
//*******************************************************************************
// Игра LINES                                                                   *
//*******************************************************************************
//Выполнил: Воротилкин А.С. группа МК-101                                       *
//Дата:                                                                         *
//Язык:Borland C++Builder6                                                      *
//Copyright (c) 2004, 2003-2006 ЧелГу International Inc. All Rights Reserved.   *
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
   if(X < NumCol*25 && Y < NumRow*25){   //Проверка "Попали ли в поле вообще..."
      if(!Desk[X / 25][Y / 25]){         //Если в этой клетке пусто...
         if(Select){                     //Если был сделан выбор...
            Desk[X/25][Y/25] = Desk[SX][SY];  //Сделать ход...
            Desk[SX][SY] = 0;
            DrawBall(SX, SY, 0);
            DrawBall(X/25, Y/25, Desk[X/25][Y/25]);

            if(!Prowerka()){             //Проверка есть ли совпадения....
               int k=0, h, i, j, NumFree=0; //Если совпадений нет то выполняется...
               for(i=0; i<NumCol; i++)
                  for(j=0; j<NumRow; j++)
                     if(!Desk[i][j]) NumFree++; //Подсчет свободных
               if(NumFree<=NumBegin){           //Если некуда ставить то конец игры
                  for(i=0; i<NumCol; i++)
                     for(j=0; j<NumRow; j++){
                        Desk[i][j] = 0;
                        DrawBall(i, j, 0);
                     }
                  ShowMessage ("Игра окончена!");
               }
               else{
                  while(k!=NumBegin){    //Если есть место расставляем новые шарики...
                     i=random(NumCol); j=random(NumRow);   //naoborot esli chto
                     if(!Desk[i][j]){
                        h=random(4)+1;
                        Desk[i][j] = h;
                        k++;
                        DrawBall(i, j, h);
                     }
                  }
                  Prowerka();  //после того как расставили надо заново проверить....
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
   int i, j, k=0, h;    //Обозначение переменных
   Select = 0;          //Обнуление всего...
   Scores = 0;
   Edit6->Text = "0";
   for(i=0; i<NumCol; i++)
      for(j=0; j<NumRow; j++){
         Desk[i][j]=0;
         DrawBall(i, j, 0);
      }
   while(k!=NumBegin){   //расставление шариков...
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
int TSwatForm::Prowerka(){      //Функция проверки на совпадение.....
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
void TSwatForm::DrawBall(int i, int j, int h){       //Функция рисования...i,j-какая клетка ,h-цвет...
   if (h==0) Canvas->Draw(i*25, j*25, BallWhite);
   if (h==1) Canvas->Draw(i*25, j*25, BallRed);
   if (h==2) Canvas->Draw(i*25, j*25, BallGrin);
   if (h==3) Canvas->Draw(i*25, j*25, BallBlue);
   if (h==4) Canvas->Draw(i*25, j*25, BallBlack);
}

void __fastcall TSwatForm::BeginGame(TObject *Sender)
{
    int i, j;                                 //Начальное обнуление и рисование...
    for(i=0; i<NumCol; i++)
      for(j=0; j<NumRow; j++){
         Desk[i][j] = 0;
         DrawBall(i, j, 0);
   }
}
//---------------------------------------------------------------------------

