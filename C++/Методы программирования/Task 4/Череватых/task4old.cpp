//---------------------------------------------------------------------------

#pragma hdrstop


#include "list.cpp"
#include "fifo.cpp"
#include <iostream.h>
#include <stdlib.h>
#include <math.h>

//---------------------------------------------------------------------------

#pragma argsused

//------------------------------------------------------------------------------
/*class BigNumbers {
public:
        int carry;
        List number;
        BigNumbers summa(BigNumbers x1, BigNumbers x2);
};

BigNumbers BigNumbers::summa(BigNumbers x1, BigNumbers x2) {
        BigNumbers result,temp;
        int res;
        if (x1.number.Count()<x2.number.Count()) {
                temp=x1;
                x1=x2;
                x2=temp;
                temp.number.DeleteList();
        }
        TNode *temp_x1=x1.number.last;
        TNode *temp_x2=x2.number.last;
        TNode *temp_result=result.number.root;
        for (int i=0;i<x2.number.Count();i++) {
                temp_x1->data=temp_x1->data+carry;
                carry=0;
                res=temp_x1->data+temp_x2->data;
                result.number.AddBefore(temp_result,(res%1000));
                if (res>=1000)
                        carry=carry+(res/1000);
                temp_x1=temp_x1->prev;
                temp_x2=temp_x2->prev;
                temp_result=temp_result->prev;
        }
        if (x1.number.Count()==x2.number.Count()) {
                result.number.AddBefore(temp_result,carry);
                carry=0;
                return result;
        } else {
                for (int i=x2.number.Count();i<x1.number.Count();i++) {
                        res=temp_x1->data+carry;
                        carry=0;
                        result.number.AddBefore(temp_result,(res%1000));
                        if (res>=1000)
                                carry=res/1000;
                        temp_x1=temp_x1->prev;
                        //temp_result=temp_result->prev;
                }
                if (carry!=0)
                        result.number.AddBefore(temp_result,carry);
                return result;
        }
}
*/

class BigNumber : public List {
        int carry;
        void AddZeroes(int count_zeroes);
        BigNumber mult (int small_number);
public:
        friend BigNumber operator+ (BigNumber x2);
        friend BigNumber operator* (BigNumber x1, BigNumber x2);
        int operator < (BigNumber x2);
        int operator > (BigNumber x2);
        int operator == (BigNumber x2);

};

//------------------------------------------------------------------------------
void BigNumber::AddZeroes (int count_zeroes) {
        for (int i=0;i<count_zeroes;i++)
                AddAfter(last,0);
}

//------------------------------------------------------------------------------
BigNumber BigNumber::mult (int small_number) {
        int carry=0;
        int temp_result;
        BigNumber result;
        TNode *temp;
        temp=last;
        for (int i=0; i<Count(); i++) {
                temp_result=temp->data * small_number + carry;
                carry=(int)(temp_result/1000);
                result.AddBefore(result.root, temp_result%1000);
                temp=temp->prev;
        }
        if (carry)
                result.AddBefore(result.root,carry);
        return result;
}

//------------------------------------------------------------------------------
BigNumber operator+ (BigNumber x1, BigNumber x2) {
        int carry=0;
        int result;
        BigNumber temp;
        FIFO fifo;
        if (x1.Count()<x2.Count()) {
                temp=x1;
                x1=x2;
                x2=temp;
        }
        //temp.DeleteList(); //????????????????????????????????
        TNode *temp_x1=x1.last;
        TNode *temp_x2=x2.last;
        TNode *temp_result=temp.last;//???????????????????????
        for (int i=0;i<x2.Count();i++) { //Блок протестирован
                result=temp_x1->data+temp_x2->data+carry;
                carry=(int)(result/1000);
                fifo.Push(result%1000);
                temp_x1=temp_x1->prev;
                temp_x2=temp_x2->prev;
        }
        if ( (x2.Count()==x1.Count() ) && (carry!=0) )
                fifo.Push(carry);
        else {
                for (int i=x2.Count();i<x1.Count();i++) {
                        result=temp_x1->data+carry;
                        carry=(int)(result/1000);
                        fifo.Push(result%1000);
                        temp_x1=temp_x1->prev;
                }
                if (carry!=0)
                        fifo.Push(carry);
        }

        int count=fifo.Count();
        for (int i=0;i<count;i++) {
                if (!fifo.Pop(result)) {
                        cout <<"Error\n";
                        exit(-1);
                }
                temp.AddBefore(temp.root,result);
        }
        return temp;

}

//------------------------------------------------------------------------------
BigNumber operator * (BigNumber x1, BigNumber x2) {
        BigNumber *array;
        BigNumber temp,summa;
        summa.AddAfter(summa.root,0);
        TNode *temp_x2;
        List list;
        if (x1.Count()<x2.Count()) {
                temp=x1;
                x1=x2;
                x2=temp;
        }
        array=new BigNumber[x2.Count()];
        temp_x2=x2.last;
        for (int i=0;i<x2.Count();i++) {
                array[i]=x1.mult(temp_x2->data);
                array[i].AddZeroes(i);
                temp_x2=temp_x2->prev;
        }
        for (int i=x2.Count()-1;i>=0;i--)
                summa=summa+array[i];
        //delete array;
//        return summa;
        return array[0];
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
        else {
                temp1=root;
                temp2=x2.root;
                for (;;) {
                        if ( (temp1->data) < (temp2->data) ) {
                                status=1;
                                break;
                        }
                        temp1=temp1->next;
                        temp2=temp2->next;
                        if (temp1==NULL || temp2==NULL) {
                                status=0;
                                break;
                        }
                }
        return status;
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
                for (;;) {
                        if (temp1->data > temp2->data)
                                return 1;
                        temp1=temp1->next;
                        temp2=temp2->next;
                        if (temp1==NULL || temp2==NULL)
                                break;
                }
        }
        return 0;
}

//------------------------------------------------------------------------------
int BigNumber::operator ==(BigNumber x2) {
        if (!(*this<x2) && !(*this>x2) )
                return 1;
        else
                return 0;
}






int main() {
        BigNumber x,y,z;
        x.AddAfter(x.last,545);
        x.AddAfter(x.last,635);
        x.AddAfter(x.last,678);
        x.AddAfter(x.last,577);
        //x.AddAfter(x.last,435);
        x.Show();

        y.AddAfter(y.last,256);
        y.AddAfter(y.last,958);
        y.AddAfter(y.last,576);
        y.AddAfter(y.last,576);
        y.Show();

        cout << (x<y) << (x>y) << (x==y) <<"\n";
        z=x+y;
        z.Show();
        z=y*x;
        z.Show();

        cin.get();
}


//---------------------------------------------------------------------------
