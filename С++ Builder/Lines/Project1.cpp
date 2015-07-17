//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//---------------------------------------------------------------------------
USEFORM("Unit1.cpp", SwatForm);
USERES("Project1.res");
//---------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	try
	{
    Application->Initialize();
    Application->Title = "Lines";
    Application->CreateForm(__classid(TSwatForm), &SwatForm);
    Application->Run();
   }
   catch (Exception &exception)
   {
      Application->ShowException(&exception);
   }

   return 0;
}
//---------------------------------------------------------------------------
