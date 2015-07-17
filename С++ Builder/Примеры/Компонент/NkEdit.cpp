#include <vcl.h>

#pragma hdrstop

#include "NkEdit.h"
#pragma package(smart_init)

static inline void ValidCtrCheck(TNkEdit *)
{
    new TNkEdit(NULL);
}

// �����������
__fastcall TNkEdit::TNkEdit(TComponent* Owner)
    : TEdit(Owner)
{
    // ����������� ����� ������ ������ � ����� ����������
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

// ���������� ��������, ��������������� ������,
// ������� ��������� � ���� ��������������
float __fastcall TNkEdit::GetNumb(void)
{
    if (Text.Length())
        return StrToFloat(Text);
    else return 0;
}

// ������� ��������� ������� KeyPress � ���� ���������� NkEdit
void __fastcall TNkEdit::KeyPress(char &Key)
{
    // ���� ����������� ������ ������� �����, � ����������
    // ��� ������� � ���� �������������� �� ��������

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

        case '-' : // ���� "�����"
                   if (Text.Length()||(FMin >= 0))
                      // ����� ��� ������ ��� FMin >= 0
                     Key = 0;
                   break;

        case VK_BACK:    // ������� <Backspace>
        case VK_RETURN:  // ������� <Enter>
                   break;

        default :  // ��������� ������� ���������
                   Key = 0;
    }

    if ((Key >='0') && (Key <= '9') ) {
        /* ��������, �� �������� �� ���� ��������� �����
           � ������ ����� �� ������� ���������. ���� ��,
           �� ������� ����������� ��� ���������� ���������. */

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
    // ������� ������� ��������� ������� KeyPress �������� ������
    TEdit::KeyPress(Key);
}

// ������������� �������� ���� FMin
bool __fastcall TNkEdit::SetMin(float min)
{
    if (min > FMax) return false;

    FMin = min;
    return true;
}

// ������������� �������� ���� FMin
bool __fastcall TNkEdit::SetMax(float max)
{
    if ( max < FMin ) return false;

    FMax = max;
    return true;
}

