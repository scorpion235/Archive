//---------------------------------------------------------------------------

#ifndef flight_1_H
#define flight_1_H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:
    TTimer *Timer1;
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall FormPaint(TObject *Sender);
    void __fastcall Timer1Timer(TObject *Sender);
private:
     Graphics::TBitmap *back;   // фон
     Graphics::TBitmap *sprite; // картинка - самолет
     int x,y; // положение объекта - левый верхний угол картинки
public:
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
