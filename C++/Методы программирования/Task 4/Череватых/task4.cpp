//---------------------------------------------------------------------------

#pragma hdrstop

#include "fifo.cpp"
#include "bignumbers.cpp"
#include <iostream.h>
#include <stdlib.h>
#include <math.h>
#include <fstream.h>
#include <except.h>
#include <time.h>

//------------------------------------------------------------------------------

#pragma argsused

//------------------------------------------------------------------------------
#define MAX 10
#define file_name "out.txt"

//------------------------------------------------------------------------------
class Algoritm  {
        BigNumber array[MAX];
        int count;
        BigNumber lim;
        BigNumber curent_element;//������� �������
        FIFO *fifo;
        int fme[MAX];//FIFO's with Minimal Element
        int afme;//Acount of FIFO's with Minimal Element
        ofstream out;
        void Step();
        void FFsME();
        void DlME();
        void Push2x();

public:
        Algoritm();
        ~Algoritm();
        void Start();
        void ShowFIFOs ();
};

//------------------------------------------------------------------------------
/*����� ��������� ���� �������� �� �����*/
void Algoritm::ShowFIFOs () {
        for (int i=0;i<count;i++) {
                cout <<"FIFO[ "<<i <<"]: ";
                fifo[i].Show();
                cout  <<"\n";
        }
}

//------------------------------------------------------------------------------
/*������� ����������� ������� �� ���� �������� � ����������� ��� ��������
���� curent_element. ����� ���� ����� ������� ������ �������� � �������
���� ������� ����������� � �������� ��� ������ � ������ fme[MAX] (FIFO's with
Minimal Element)*/
void Algoritm::FFsME () {
        BigNumber min;
        BigNumber temp;
        afme=0;
        fifo[0].Top(curent_element);
        for (int i=0;i<count;i++) {
                fifo[i].Top(temp);
                if ( temp<curent_element )
                        curent_element=temp;

        }
        for (int i=0;i<count;i++) {
                fifo[i].Top(temp);
                if (temp==curent_element) {
                        fme[afme]=i;
                        afme++;
                }
        }
        if (min.root!=NULL)//???
                min.DeleteList();
}

//------------------------------------------------------------------------------
void Algoritm::DlME() {
        BigNumber temp;
        for (int i=0;i<afme;i++) {
                fifo[fme[i]].Pop(temp);
                //temp.DeleteList();
        }



}

//------------------------------------------------------------------------------
void Algoritm::Push2x () {
        for (int i=0;i<count;i++)
                        fifo[i].Push(array[i]*curent_element);
}

//------------------------------------------------------------------------------
Algoritm::Algoritm() {
        count=0;
        afme=0;
        fifo=new FIFO[MAX];
        out.open(file_name);
}

//------------------------------------------------------------------------------
Algoritm::~Algoritm() {
        out.close();
}

//------------------------------------------------------------------------------
void Algoritm::Start () {
        BigNumber ZERO;
        ZERO=0;
        cout <<"���� ��室��� ������.\n"
             <<"������ ����� �᫠. (0 - ��室).\n";
        for (int i=0; i<MAX; i++) {
                cin >>array[i];
                count++;
                if (array[i]==ZERO) {
                        count--;
                        break;
                }
        }
        cout <<"������ ���孨� �।�� (�� ����� ����� �祭� ����讥 �᫮): ";
        cin >>lim;
        out <<"� ������ ����� �������� ��� ����� �� 0 �� " <<lim <<",\n"
            <<"������� �������������� �� ��������� ������� �����������:\n\n";
        for (int i=0;i<count;i++)
                out <<(i+1) <<" -- " <<array[i] <<"\n";
        out <<"\n\n\n";
        Step();
}

//------------------------------------------------------------------------------
void Algoritm::Step() {
        clock_t start, stop;
        int number=1;
        BigNumber temp;
        for (int j=0;j<count;j++) {
                fifo[j].Push(array[j]);
        }
        cout <<"������� �ᥫ... �� ����� ������ ����� �६���........................";
        start=clock();
        out <<"1\n";
        number++;
        for (;;) {
                FFsME();
                if (curent_element > lim) break;
                out <<curent_element <<"\n";
                number++;
                DlME();
                Push2x();
        }
        stop=clock();
        cout <<"OK\n�ணࠬ�� �ᯥ譮 �����稫� ᢮� �믮������.\n"
             <<"�६� ࠡ��� �ணࠬ�� : "<<(double)(stop-start)/CLOCKS_PER_SEC <<" c.\n"
             <<"������⢮ ��������� �ᥫ: " <<number <<"\n"
             <<"�� ����� ��ᬮ���� १����� � 䠩�� out.txt\n"
             <<"������ <ENTER> ��� ��室�";
        out <<"\n\n\n\n��������� ����� "<<number <<" �����, ������� �������������� �� "
            <<"������������� �����������\n"
            <<"����� ������ ���������: "<<(double)(stop-start)/CLOCKS_PER_SEC <<" c.\n"
            <<"����������� ����������� ����� "<<(curent_element.Count()*3) <<"(+/- 1 ���������� ������)\n";
        return;


}

int main() {
        try {
        BigNumber x,y,t;
        int z;
        cout <<"������ ᢥ�塮��讥 �᫮ x: \n ";
        cin >>x;
        cout <<"x = " <<x <<"\n";

        cout <<"������ ᢥ�塮��讥 �᫮ y:\n ";
        cin >>y;
        cout <<"y = " <<y <<"\n";

        cout <<"x < y - " <<(x<y) <<"\n";
        cout <<"x > y - " <<(x>y) <<"\n";
        cout <<"x == y - " <<(x==y) <<"\n";
        cout <<"x + y = " <<(x+y) <<"\n";
        cout <<"y + x = " <<(y+x) <<"\n";
        cout <<"y * x = " <<(y*x) <<"\n";
        cout <<"x * y = " <<(x*y) <<"\n";

        cout <<"\n\nTest operator BigNumber = int\n";
        cout <<"������ �᫮ (integer): ";
        cin >>z;
        x=z;
        cout <<"������ int: ";
        cin >>z;
        y=z;
        cout <<"x = " <<x <<"\n";
        cout <<"y = " <<y <<"\n";
        cout <<"x + y = " <<(x+y) <<"\n";
        cout <<"y + x = " <<(y+x) <<"\n";
        cout <<"x * y = " <<(x*y) <<"\n";
        cout <<"y * x = " <<(y*x) <<"\n";
        cin.get();
        //x=564;*/

        


        Algoritm a;
        a.Start();
        } catch (xalloc xa) {
                cout <<"�訡�� �뤥����� �����\n";
                return 1;
        }
        cin.get();
}


//---------------------------------------------------------------------------
