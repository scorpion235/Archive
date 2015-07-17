#ifndef NkEditH
#define NkEditH

#include <SysUtils.hpp>
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>

class PACKAGE TNkEdit : public TEdit
{
private:
   bool  FEnableFloat; // �������� ���� �������� �����
   // ��������
   float FMin; // ������ �������
   float FMax; // ������� �������

    /* ������� SetNumb ������������ ��� ��������� �����������
       ���� �������������� */
    void  __fastcall SetNumb(float n);


    /* ������� GetNumb ������������ ��� ������� � ���� �������������� */
    float __fastcall GetNumb(void);

    /* ��� ������� ������������ ��������� ������ ���������
 	���������� �������� */
    bool __fastcall SetMin(float min);
    bool __fastcall SetMax(float max);

protected:

public:
    __fastcall TNkEdit(TComponent* Owner);   // �����������

    /* �������� Numb ������ ���� �������� ������ �� �����
       ������ ���������. ������� ��� ��������� � ������ public.
       ���� ���� ����� �������� ���� �������� �� ����� ���������� ����� �
       ��� �������� ����� ���� ������ � ���� Object Inspector, ��
       ��� ���������� ���� ��������� � ������ published.
    */
    __property float Numb = {read = GetNumb }; //, write = SetNumb};

    // ������� ��������� ������� KeyPress
    DYNAMIC void __fastcall KeyPress(char &key);

__published:
      // ����������� ����� �������� �������� � Object Inspector

    __property bool EnableFloat = { read    = FEnableFloat,
                                    write   = FEnableFloat };

    __property float Min = {read  = FMin,
                            write = SetMin };

   __property float Max = {read  = FMax,
                            write = SetMax };

};

#endif

