//---------------------------------------------------------------------------

#ifndef UnitH
#define UnitH
#define MAX_SIZE 100000
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TEdit *Edit1;
        TLabel *Label1;
        TEdit *Edit2;
        TLabel *Label2;
        TEdit *Edit3;
        TLabel *Label3;
        TButton *Button1;
        TButton *Button2;
        TLabel *Label4;
        TLabel *Label5;
        void __fastcall Pain(TObject *Sender);
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
        MQuickSort(long m, int a[MAX_SIZE], long n);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
