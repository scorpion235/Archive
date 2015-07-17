//---------------------------------------------------------------------------

#ifndef amper2_H
#define amper2_H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------

class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TEdit *Edit1;
        TEdit *Edit2;
        TButton *Button1;
        TButton *Button2;
        TLabel *Label4;
        void __fastcall Button1Click(TObject *Sender);
    void __fastcall Edit1KeyPress(TObject *Sender, char &Key);
    void __fastcall Button2Click(TObject *Sender);
    void __fastcall Edit2KeyPress(TObject *Sender, char &Key);
   
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
