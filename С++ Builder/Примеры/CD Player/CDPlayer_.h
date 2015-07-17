//---------------------------------------------------------------------------

#ifndef CDPlayer_H
#define CDPlayer_H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Graphics.hpp>
#include <MPlayer.hpp>
#include <ComCtrls.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
    TTimer *Timer;
    TButton *Button1;
    TButton *Button2;
    TButton *Button3;
    TLabel *Label1;
    TLabel *Label2;
    TMediaPlayer *MediaPlayer;
    TShape *Shape1;
   
    void __fastcall MediaPlayerNotify(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall TimerTimer(TObject *Sender);
    void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
    void __fastcall Button3Click(TObject *Sender);
    void __fastcall Button2Click(TObject *Sender);
  
private:
    int Track; // номер воспроизводимого трека
    void __fastcall TrackInfo();
public:
    __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
