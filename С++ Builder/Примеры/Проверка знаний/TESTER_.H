#ifndef tester_H
#define tester_H

#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Dialogs.hpp>
#include <Graphics.hpp>

// вопрос
struct TVopros {
    AnsiString Vopr;   // вопрос
    AnsiString Img;    // иллюстраци€ (им€ BMP-файла)
    AnsiString Otv[4]; // варианты ответа
    int        nOtv;   // кол-во вариантов ответа
    int        rOtv;   // номер правильного ответа
};

// форма
class TForm1 : public TForm
{
__published:  // IDE-managed Components
    TLabel *Label1;   // информационное сообщение, вопрос
    TImage *Image1;   // иллюстраци€ к вопросу
    TButton *Button1; // кнопка OK / ƒальше
    void __fastcall FormActivate(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);

private:
    TRadioButton *RadioButton[4];  // варианты ответа - радиокнопки выбора
    void __fastcall RadioButtonClick(TObject *Sender); // щелчок кнопке выбора ответа
    void __fastcall ShowVopros(TVopros v);  // выводит вопрос
    void __fastcall EraseVopros(void);      // удал€ет вопрос

public:
    __fastcall TForm1(TComponent* Owner);
};

extern PACKAGE TForm1 *Form1;



#endif
