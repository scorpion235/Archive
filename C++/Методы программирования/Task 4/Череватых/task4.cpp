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
        BigNumber curent_element;//Текущий элемент
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
/*Вывод содержимо всех очередей на экран*/
void Algoritm::ShowFIFOs () {
        for (int i=0;i<count;i++) {
                cout <<"FIFO[ "<<i <<"]: ";
                fifo[i].Show();
                cout  <<"\n";
        }
}

//------------------------------------------------------------------------------
/*Находит минимальный элемент из всех очередей и присваивает его значение
полю curent_element. Также этот метод находит номера очередей в которых
этот элемент минимальный и помещает эти номера в массив fme[MAX] (FIFO's with
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
        cout <<"‚ў®¤ Ёбе®¤­ле ¤ ­­ле.\n"
             <<"‚ўҐ¤ЁвҐ Їа®бвлҐ зЁб« . (0 - ‚ле®¤).\n";
        for (int i=0; i<MAX; i++) {
                cin >>array[i];
                count++;
                if (array[i]==ZERO) {
                        count--;
                        break;
                }
        }
        cout <<"‚ўҐ¤ЁвҐ ўҐае­Ё© ЇаҐ¤Ґ« (ўл ¬®¦ҐвҐ ўўҐбвЁ ®зҐ­м Ў®«ми®Ґ зЁб«®): ";
        cin >>lim;
        out <<"В данном файле хранятся все числа от 0 до " <<lim <<",\n"
            <<"которые раскладываются на следующие простые сомножители:\n\n";
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
        cout <<"Џ®¤бзсв зЁбҐ«... ќв® ¬®¦Ґв § ­пвм ¬­®Ј® ўаҐ¬Ґ­Ё........................";
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
        cout <<"OK\nЏа®Ја ¬¬  гбЇҐи­® § Є®­зЁ«  бў®с ўлЇ®«­Ґ­ЁҐ.\n"
             <<"‚аҐ¬п а Ў®вл Їа®Ја ¬¬л : "<<(double)(stop-start)/CLOCKS_PER_SEC <<" c.\n"
             <<"Љ®«ЁзҐбвў® ­ ©¤Ґ­­ле зЁбҐ«: " <<number <<"\n"
             <<"‚л ¬®¦ҐвҐ Ї®б¬®ваҐвм аҐ§г«мв вл ў д ©«Ґ out.txt\n"
             <<"Ќ ¦¬ЁвҐ <ENTER> ¤«п ўле®¤ ";
        out <<"\n\n\n\nПрограмма нашла "<<number <<" чисел, которые раскладываются на "
            <<"вышеуказанные сомножители\n"
            <<"Время работы программы: "<<(double)(stop-start)/CLOCKS_PER_SEC <<" c.\n"
            <<"Разрядность наибольшего числа "<<(curent_element.Count()*3) <<"(+/- 1 десятичный разряд)\n";
        return;


}

int main() {
        try {
        BigNumber x,y,t;
        int z;
        cout <<"‚ўҐ¤ЁвҐ бўҐаеЎ®«ми®Ґ зЁб«® x: \n ";
        cin >>x;
        cout <<"x = " <<x <<"\n";

        cout <<"‚ўҐ¤ЁвҐ бўҐаеЎ®«ми®Ґ зЁб«® y:\n ";
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
        cout <<"‚ўҐ¤ЁвҐ зЁб«® (integer): ";
        cin >>z;
        x=z;
        cout <<"‚ўҐ¤ЁвҐ int: ";
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
                cout <<"ЋиЁЎЄ  ўл¤Ґ«Ґ­Ёп Ї ¬пвЁ\n";
                return 1;
        }
        cin.get();
}


//---------------------------------------------------------------------------
