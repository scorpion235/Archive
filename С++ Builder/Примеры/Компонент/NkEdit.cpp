#include <vcl.h>

#pragma hdrstop

#include "NkEdit.h"
#pragma package(smart_init)

static inline void ValidCtrCheck(TNkEdit *)
{
    new TNkEdit(NULL);
}

// конструктор
__fastcall TNkEdit::TNkEdit(TComponent* Owner)
    : TEdit(Owner)
{
    // конструктор имеет прямой доступ к полям компонента
    Text = "0";
    FMin = 0;
    FMax = 100;
    FEnableFloat = true;
}

namespace Nkedit
{
    void __fastcall PACKAGE Register()
    {
         TComponentClass classes[1] = {__classid(TNkEdit)};
         RegisterComponents("Standard", classes, 0);
    }
}

void  __fastcall TNkEdit::SetNumb(float n)
{
    Text = FloatToStr(n);
}

// возвращает значение, соответствующее строке,
// которая находится в поле редактирования
float __fastcall TNkEdit::GetNumb(void)
{
    if (Text.Length())
        return StrToFloat(Text);
    else return 0;
}

// функция обработки события KeyPress в поле компонента NkEdit
void __fastcall TNkEdit::KeyPress(char &Key)
{
    // Коды запрещенных клавиш заменим нулем, в результате
    // эти символы в поле редактирования не появятся

    switch (Key) {
        case '0' :
        case '1' :
        case '2' :
        case '3' :
        case '4' :
        case '5' :
        case '6' :
        case '7' :
        case '8' :
        case '9' : break;

        case '.' :
        case ',' :
              Key = DecimalSeparator;
              if (Text.Pos(DecimalSeparator) || (! FEnableFloat))
                   Key = 0;
              break;

        case '-' : // знак "минус"
                   if (Text.Length()||(FMin >= 0))
                      // минус уже введен или FMin >= 0
                     Key = 0;
                   break;

        case VK_BACK:    // клавиша <Backspace>
        case VK_RETURN:  // клавиша <Enter>
                   break;

        default :  // остальные символы запрещены
                   Key = 0;
    }

    if ((Key >='0') && (Key <= '9') ) {
        /* Проверим, не приведет ли ввод очередной цифры
           к выходу числа за границы диапазона. Если да,
           то заменим максимально или минимально возможным. */

       AnsiString st = Text + Key;
       
       if (StrToFloat(st) < FMin) {
            Key = 0;
            Text = FloatToStr(FMin);
       }
       if (StrToFloat(st) > FMax) {
            Key = 0;
            
            Text = FloatToStr(FMax);
       }
    }
    // вызвать функцию обработки события KeyPress базового класса
    TEdit::KeyPress(Key);
}

// устанавливает значение поля FMin
bool __fastcall TNkEdit::SetMin(float min)
{
    if (min > FMax) return false;

    FMin = min;
    return true;
}

// устанавливает значение поля FMin
bool __fastcall TNkEdit::SetMax(float max)
{
    if ( max < FMin ) return false;

    FMax = max;
    return true;
}

