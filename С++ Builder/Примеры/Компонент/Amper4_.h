//---------------------------------------------------------------------------

#ifndef Amper4_H
#define Amper4_H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "NkEdit.h"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TLabel *Label1;
    TLabel *Label2;
    TLabel *Label3;
    TButton *Button1;
    TButton *Button2;
    TLabel *Label4;
        TLabel *Label5;
        TNkEdit *NkEdit1;
        TNkEdit *NkEdit2;
    void __fastcall Button1Click(TObject *Sender);
        void __fastcall NkEdit1KeyPress(TObject *Sender, char &Key);
        void __fastcall NkEdit2KeyPress(TObject *Sender, char &Key);
        void __fastcall Button2Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
