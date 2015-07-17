//---------------------------------------------------------------------------

#ifndef saper_2H
#define saper_2H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TAboutForm : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
    TLabel *Label4;
        TButton *Button1;
    TLabel *Label5;
    TLabel *Label3;
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall Label5Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TAboutForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TAboutForm *AboutForm;
//---------------------------------------------------------------------------
#endif
