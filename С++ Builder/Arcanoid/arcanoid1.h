//---------------------------------------------------------------------------

#ifndef arcanoid1H
#define arcanoid1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TButton *Button1;
        TTimer *Timer1;
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall Timer1Timer(TObject *Sender);
        void __fastcall qwer(TObject *Sender, WORD &Key,
          TShiftState Shift);
private:    int x,y ;	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
        kar(int q1);
        left();
        right();
        krug(int col);
        cherbar(int w1, int w2);
        sdvig();
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif

