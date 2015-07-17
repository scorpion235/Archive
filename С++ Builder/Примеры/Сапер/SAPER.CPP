//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("saper.res");
USEFORM("saper_.cpp", Form1);
USEFORM("saper_2.cpp", AboutForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TForm1), &Form1);
         Application->CreateForm(__classid(TAboutForm), &AboutForm);
         Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
