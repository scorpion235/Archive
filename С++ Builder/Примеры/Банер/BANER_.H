//---------------------------------------------------------------------------

#ifndef baner_H
#define baner_H
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
    TTimer *Timer1;
   
    void __fastcall Timer1Timer(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
private:
     Graphics::TBitmap *baner; // банер
     TRect kadr;               // кадр банера
     TRect scr;                // область воспроизведения банера
     int w, h;                 // размер кадра
     int c;                    // номер воспроизводимого кадра

public:
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
