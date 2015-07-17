#ifndef NkEditH
#define NkEditH

#include <SysUtils.hpp>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>

class PACKAGE TNkEdit : public TEdit
{
private:
   bool  FEnableFloat; // разрешен ввод дробного числа
   // диапазон
   float FMin; // нижн€€ граница
   float FMax; // верхн€€ граница

    /* функци€ SetNumb используетс€ дл€ изменени€ содержимого
       пол€ редактировани€ */
    void  __fastcall SetNumb(float n);


    /* ‘ункци€ GetNumb используетс€ дл€ доступа к полю редактировани€ */
    float __fastcall GetNumb(void);

    /* эти функции обеспечивают изменение границ диапазона
 	допустимых значений */
    bool __fastcall SetMin(float min);
    bool __fastcall SetMax(float max);

protected:

public:
    __fastcall TNkEdit(TComponent* Owner);   // конструктор

    /* —войство Numb должно быть доступно только во врем€
       работы программы. ѕоэтому оно объ€влено в секции public.
       ≈сли надо чтобы свойство было доступно во врем€ разработки формы и
       его значение можно было задать в окне Object Inspector, то
       его объ€вление надо поместить в секцию published.
    */
    __property float Numb = {read = GetNumb }; //, write = SetNumb};

    // ‘ункци€ обработки событи€ KeyPress
    DYNAMIC void __fastcall KeyPress(char &key);

__published:
      // объ€вленные здесь свойства доступны в Object Inspector

    __property bool EnableFloat = { read    = FEnableFloat,
                                    write   = FEnableFloat };

    __property float Min = {read  = FMin,
                            write = SetMin };

   __property float Max = {read  = FMax,
                            write = SetMax };

};

#endif

