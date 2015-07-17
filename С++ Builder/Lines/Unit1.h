//----------------------------------------------------------------------------
//Borland C++Builder
//Copyright (c) 1987, 1998-2002 Borland International Inc. All Rights Reserved.
//----------------------------------------------------------------------------
//---------------------------------------------------------------------------
#ifndef swatH
#define swatH
//---------------------------------------------------------------------------
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Controls.hpp>
#include <Classes.hpp>
#include <StdCtrls.hpp>
#include <Graphics.hpp>

const int NumCol = 10, NumRow = 10, NumBegin = 3;   //����� �����,�������� � ������� �� ����...
//---------------------------------------------------------------------------
class TSwatForm : public TForm
{
__published:
   TButton *Button1;
   TButton *Button2;
   TEdit *Edit6;
   TLabel *Label1;
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall FormMouseDown(TObject *Sender, TMouseButton Button,
    TShiftState Shift, int X, int Y);
   void __fastcall Exit(TObject *Sender);
   void __fastcall NewGame(TObject *Sender);
   void __fastcall BeginGame(TObject *Sender);
private:        // private user declarations
    Graphics::TBitmap*    BallRed;
    Graphics::TBitmap*    BallGrin;
    Graphics::TBitmap*    BallBlue;
    Graphics::TBitmap*    BallBlack;
    Graphics::TBitmap*    BallWhite;
    int Desk[NumCol][NumRow]; //������ ��� �������� ������
    bool Select;              //���������� ������
    int SX, SY;               //���������� ���������� ������
    int Scores;               //����
public:         // public user declarations
   int Prowerka(void);         //�������� ������� ��������
   void DrawBall (int i, int j, int h); //�������� ������� ��������� �������
    virtual __fastcall TSwatForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TSwatForm *SwatForm;
//---------------------------------------------------------------------------
#endif
