/*Файл fifo.cpp содержит интерфейс и реализацмю класса FIFO (очередь)
Автор: Череватых Николай Николаевич
Среда разработки: Borland C++ Builder 6.
Дата: 26 ноября 2004г*/

#ifndef _FIFO
#define _FIFO

#include <stddef.h>
#include <iostream.h>
#include <stdlib.h>
#include "bignumbers.cpp"

#define _TElement BigNumber

struct FIFONode {
        _TElement data;
        FIFONode *next;
        FIFONode *prev;
};

//------------------------------------------------------------------------------
class FIFO {
        int count;
        FIFONode *first;
        FIFONode *last;
public:
        FIFO();
        //~FIFO();
        int Pop(_TElement& data);
        int Push(_TElement data);
        int Top(_TElement& top);
        int IsEmpty();
        _TElement Top1();
        int Count();
        void Show();
};

//------------------------------------------------------------------------------
FIFO::FIFO() {
        count=0;
        first=last=NULL;
}

//------------------------------------------------------------------------------
int FIFO::Push(_TElement data) {
        FIFONode *newNode;
        if (last==NULL) {
                last=new FIFONode;
                if (last==NULL) {
                        cout <<"FIFO::Push: Error. Not enought memory.\n";
                        cin.get();
                        exit (-1);
                }
                last->next=NULL;
                last->prev=NULL;
                last->data=data;
                first=last;
                count++;
                return 1;
        } else {
                newNode=new FIFONode;
                if (newNode==NULL) {
                        cout <<"FIFO::Push: Error. Not enought memory.\n";
                        cin.get();
                        exit (-1);
                }
                newNode->data=data;
                newNode->next=last;
                last->prev=newNode;
                last=newNode;
                count++;
                return 1;
        }
}

//------------------------------------------------------------------------------
int FIFO::Pop (_TElement& data) {
        if (first==NULL)
                return 0;
        else if (first==last) {
                data=first->data;
                delete first;
                first=NULL;
                last=NULL;
                count--;
                return 1;
             }
        else {
                data=first->data;
                first=first->prev;
                delete first->next;
                first->next=NULL;
                count--;
                return 1;
        }
};

//------------------------------------------------------------------------------
int FIFO::Top (_TElement& data) {
        if (first==NULL)
                return 0;
        else {
                data=first->data;
                return 1;
              }
}

//------------------------------------------------------------------------------
int FIFO::Count () {
        return count;
}

//------------------------------------------------------------------------------
void FIFO::Show() {
        FIFONode *temp;
        cout <<"last <-> ";
        temp=last;
        for (int i=0;i<count;i++) {
                cout <<temp->data <<" <-> ";
                temp=temp->next;
        }
        cout <<"first\n";
};

_TElement FIFO::Top1() {
        return first->data;
}

int FIFO::IsEmpty() {
        if (first==NULL)
                return 1;
        else
                return 0;
}

#endif _FIFO

