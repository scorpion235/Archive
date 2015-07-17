//------------------------------------------------------------------------------

#ifndef _BIG_NUMBERS
#define _BIG_NUMBERS DEFINED


//------------------------------------------------------------------------------

#include "list.cpp"
#include <iostream.h>

//------------------------------------------------------------------------------

class BigNumber : public List {
        void AddZeroes(int count_zeroes);
public:
        BigNumber();
        //~BigNumber();
        friend BigNumber operator + (BigNumber x2);
        friend BigNumber operator * (BigNumber x1, BigNumber x2);
        BigNumber operator * (int small_number);
        int operator < (BigNumber x2);
        int operator > (BigNumber x2);
        int operator == (BigNumber x2);
    //    void operator delete (void *p);
        BigNumber operator = (int small_int);
        BigNumber operator = (BigNumber x2);
        friend ostream& operator << (ostream &stream, BigNumber obj);
        friend istream& operator >> (istream &stream, BigNumber& obj);

};




//------------------------------------------------------------------------------
BigNumber::BigNumber() {
        root=NULL;
        last=NULL;
        count=0;
}

/*BigNumber::~BigNumber() {
        DeleteList();
} */

//------------------------------------------------------------------------------
void BigNumber::AddZeroes (int count_zeroes) {
        for (int i=0;i<count_zeroes;i++)
                AddAfter(last,0);
}


//------------------------------------------------------------------------------
BigNumber BigNumber::operator * (int small_number) {
        int carry=0;
        int temp_result;
        BigNumber result;
        TNode *temp;
        temp=last;
        for (int i=0; i<Count(); i++) {
                temp_result=temp->data * small_number + carry;
                carry=temp_result/1000;
                result.AddBefore(result.root, temp_result%1000);
                temp=temp->prev;
        }
        if (carry)
                result.AddBefore(result.root,carry);
        return result;
}

//------------------------------------------------------------------------------
BigNumber operator + (BigNumber x1, BigNumber x2) {
        int carry=0;
        int result;
        BigNumber temp,res;
        if (x1.Count()<x2.Count()) {
                temp=x1;
                x1=x2;
                x2=temp;
        }
        TNode *temp_x1=x1.last;
        TNode *temp_x2=x2.last;
        for (int i=0;i<x2.Count();i++) {
                result=temp_x1->data+temp_x2->data+carry;
                carry=result/1000;
                res.AddBefore(res.root, result%1000);
                temp_x1=temp_x1->prev;
                temp_x2=temp_x2->prev;
        }
        if ( (x2.Count()==x1.Count() ) && (carry!=0) )
                res.AddBefore(res.root, carry);
        else {
                for (int i=x2.Count();i<x1.Count();i++) {
                        result=temp_x1->data+carry;
                        carry=(int)(result/1000);
                        res.AddBefore(res.root,result%1000);
                        temp_x1=temp_x1->prev;
                }
                if (carry!=0)
                        res.AddBefore(res.root,carry);
        }
        return res;


}

//------------------------------------------------------------------------------
BigNumber operator * (BigNumber x1, BigNumber x2) {
        BigNumber *array;
        BigNumber temp,summa;
        summa.AddAfter(summa.root,0);
        TNode *temp_x2;
        List list;
        if (x1.Count()<=x2.Count()) {
                temp=x1;
                x1=x2;
                x2=temp;
        }
        array=new BigNumber[x2.Count()];
        temp_x2=x2.last;
        for (int i=0;i<x2.Count();i++) {
                array[i]=x1*temp_x2->data;
                array[i].AddZeroes(i);
                temp_x2=temp_x2->prev;
        }
        for (int i=x2.Count()-1;i>=0;i--) {
                summa=summa+array[i];
        }
        for (int i=0;i<x2.Count();i++)
                array[i].DeleteList();
        delete array;
        return summa;
}

//------------------------------------------------------------------------------
int BigNumber::operator < (BigNumber x2) {
        TNode *temp1;
        TNode *temp2;
        int status;
        if (Count()<x2.Count())
                return 1;
        else if (Count()>x2.Count())
                return 0;
        else  {
                temp1=root;
                temp2=x2.root;
                while (temp1!=NULL) {
                        if ( (temp1->data) > (temp2->data) )
                                return 0;
                        if (temp1->data < temp2->data)
                                return 1;
                        if (temp1->data==temp2->data) {
                                temp1=temp1->next;
                                temp2=temp2->next;
                        }

                }
                return 0;
        }
}

//------------------------------------------------------------------------------
int BigNumber::operator > (BigNumber x2) {
        TNode *temp1;
        TNode *temp2;
        if (Count()>x2.Count())
                return 1;
        else if (Count()<x2.Count())
                return 0;
        else {
                temp1=root;
                temp2=x2.root;
                while (temp1!=NULL) {
                        if ( (temp1->data) > (temp2->data) )
                                return 1;
                        if (temp1->data < temp2->data)
                                return 0;
                        if (temp1->data==temp2->data) {
                                temp1=temp1->next;
                                temp2=temp2->next;
                        }
                }
                return 0;
        }
}

//------------------------------------------------------------------------------
int BigNumber::operator ==(BigNumber x2) {
        if (!(*this<x2) && !(*this>x2) )
                return 1;
        else
                return 0;
}

//------------------------------------------------------------------------------
BigNumber BigNumber::operator = (int small_number) {
       if (root!=NULL) DeleteList();
        if (small_number==0)
                AddBefore(root,0);
        else  while (small_number) {
                AddBefore (root,small_number%1000);
                small_number=small_number/1000;
              }
        return *this;
}

//------------------------------------------------------------------------------
/*void BigNumber:: operator delete (void *p) {
        cout <<"del used\n";
        delete p;
  //      while (root!=NULL){
   //             root=root->next;
     //           delete root->prev;
       // }
} */

//------------------------------------------------------------------------------
BigNumber BigNumber::operator = (BigNumber x2) {

        root=x2.root;
        last=x2.last;
        count=x2.count;
        return *this;
}

//------------------------------------------------------------------------------
/*Перегрузка оператора вставки (инсертера) для работы с классом BigNumber*/
ostream& operator << (ostream &stream, BigNumber obj) {
        if (obj.root==NULL) {
                cout <<"list.cpp::ostream& operator <<(ostream, BigNumber) error. List is empty.\n";
                cin.get();
                exit (-1);
        }
        TNode *temp;
        temp=obj.root;
        stream <<obj.root->data <<" ";
        temp=temp->next;
        while (temp!=NULL) {
                //if (temp->data==NULL) cout <<"ERROR\n";
                if (temp->data < 10)
                        stream <<"00";
                else if (temp->data < 100)
                        stream <<"0";
                stream <<temp->data <<" ";
                temp=temp->next;
        }
        return stream;
};

//------------------------------------------------------------------------------
/*Перегрузка экстрактора (оператора извлечения) из потока*/
istream& operator >> (istream &stream, BigNumber& obj) {
        char number_char[10000];
        char ch_number_small[4];
        int digits_acount;
        stream >> number_char;
        digits_acount=strlen(number_char);
        cin.get();
        switch (digits_acount%3) {
                case 0:
                        for (int i=0;i<digits_acount;i=i+3) {
                                for (int j=0;j<3;j++)
                                        ch_number_small[j]=number_char[i+j];
                                ch_number_small[7]='\0';
                                obj.AddAfter(obj.last,atoi(ch_number_small));
                        }
                        break;
                case 1:
                        ch_number_small[0]=number_char[0];
                        obj.AddBefore(obj.last, atoi(ch_number_small));
                        for (int i=1;i<digits_acount;i=i+3) {
                                for (int j=0;j<3;j++)
                                        ch_number_small[j]=number_char[i+j];
                                ch_number_small[7]='\0';
                                obj.AddAfter(obj.last,atoi(ch_number_small));
                        }
                        break;
                case 2:
                        ch_number_small[0]=number_char[0];
                        ch_number_small[1]=number_char[1];
                        obj.AddAfter(obj.last,atoi(ch_number_small));
                        for (int i=2;i<digits_acount;i=i+3) {
                                for (int j=0;j<3;j++)
                                        ch_number_small[j]=number_char[i+j];
                                ch_number_small[7]='\0';
                                obj.AddAfter(obj.last,atoi(ch_number_small));
                        }
                        break;

        }
        return stream;
}


#endif

