#ifndef saper_H
#define saper_H

#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Menus.hpp>

class TForm1 : public TForm
{
__published:
    TMainMenu *MainMenu1;
    // команды главного меню
    TMenuItem *N1; // Новая игра
    TMenuItem *N2; // команда "?"
    // команды меню "?"
    TMenuItem *N3; //  Справка
    TMenuItem *N4; //  О программе

    void __fastcall FormMouseDown(TObject *Sender, TMouseButton Button,
          TShiftState Shift, int X, int Y);
    void __fastcall FormPaint(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);

    // выбор команды в меню
    void __fastcall N1Click(TObject *Sender); // Новая игра
    void __fastcall N3Click(TObject *Sender); // Справка
    void __fastcall N4Click(TObject *Sender); // О программе

private:
    void __fastcall ShowPole(int status); // отображает поле
    void __fastcall Kletka (int row, int col, int status); // отображает содержимое клетки
    void __fastcall Mina (int x, int y);   // рисует мину
    void __fastcall Flag( int x, int y);   // рисует флаг

public:
    __fastcall TForm1(TComponent* Owner);
};

extern PACKAGE TForm1 *Form1;

#endif
