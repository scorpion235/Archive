//---------------------------------------------------------------------------

#ifndef ShowAVI_1H
#define ShowAVI_1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <Dialogs.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:
        // компоненты
        TAnimate *Animate1;          // обеспечивает отображение анимации
        TRadioButton *RadioButton1;  // просмотр всей анимации
        TRadioButton *RadioButton2;  // покадровый просмотр
        TButton *Button1;            // кнопка Пуск/Стоп
        TButton *Button2;            // кнопка Следующий кадр
        TButton *Button3;            // кнопка Предыдущий кадр
        TLabel *Label1;
        TEdit *Edit1;                // имя AVI-файл
        TButton *Button4;            //кнопка Выбор (открывает диалог Open File)
        TOpenDialog *OpenDialog1;    //диалог Open File

    void __fastcall Button4Click(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall RadioButton1Click(TObject *Sender);
    void __fastcall RadioButton2Click(TObject *Sender);
    void __fastcall Button2Click(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
    void __fastcall Button3Click(TObject *Sender);
private:
        int CFrame; // номер кадра, отображаемого в режиме
                    // покадрового просмотра 
public:
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
