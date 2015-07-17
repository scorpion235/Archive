//---------------------------------------------------------------------------

#ifndef vp_H
#define vp_H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Dialogs.hpp>
#include <MPlayer.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TOpenDialog *OpenDialog1;
    TSpeedButton *SpeedButton1;
    TSpeedButton *SpeedButton2;
    TMediaPlayer *MediaPlayer1;
    void __fastcall SpeedButton1Click(TObject *Sender);
    void __fastcall SpeedButton2Click(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall MediaPlayer1Notify(TObject *Sender);
    
private:	// User declarations

public:		// User declarations
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
