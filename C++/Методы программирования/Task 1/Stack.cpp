/***************************************
 * ����� ���������������� (������� 1)  *                          
 * � ������ "Stack.cpp" ����������     *
 * ���� �� ������ ������� � ���������� *
 * ������                              *
 ***************************************
 * ��������: ������� ������            *
 * ������ ��-201                       *
 * ����� ����������: Dev-C++ 4.9.8.0   *
 * ����: 10.12.04                      *
 ***************************************/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#define TElement int
#define MAX_SIZE 50000 //������������ ���������� ��������� �������

class Stack
{
  public:
    virtual int Pop()=0;            //������� ������ �� �����
    virtual int Push(TElement d)=0; //��������� ������ � ����
    virtual int IsEmpty()=0;        //�������� ����� �� �������
    virtual TElement Top()=0;       //��������� �������       
};
//------------------------------------------------------------------------------
//� ������ "StackArray" ���������� ���� �� ������ �������                       /*StackArray*/
//����� "StackArray" ������� ������������� ������ "Stack"
class StackArray : public Stack
{
  private:
    int s[MAX_SIZE];
    int top; 
  public:
    StackArray(){top=0;}  // �����������
    ~StackArray(){top=0;} // ����������
    int Pop();            //������� ������ �� �����
    int Push(TElement d); //��������� ������ � ����
    //�������� ����� �� �������
    int IsEmpty(){return(top==0);}        
    TElement Top();       //��������� ������� �����
};
//------------------------------------------------------------------------------
//������� ������ �� �����
int StackArray::Pop() //d-����������� ������
{
  if (StackArray::IsEmpty()) //���� ����
    return -1;
  //printf("\nDelete %i", StackArray::Top());
  return (--top);
}
//------------------------------------------------------------------------------
//��������� ������ � ����
int StackArray::Push(TElement d) //d-���������� ������
{
  if(top==MAX_SIZE-1) //���� ����������
    return -1;
  s[++top]=d;
  //printf("\nAdd %i", s[top]);
  //return 0;
}
//------------------------------------------------------------------------------
//��������� ������� �����
TElement StackArray::Top()
{
  if (StackArray::IsEmpty()) // ���� ����
    return -1;
  //printf("\nTop: %i", s[top]);
  return (s[top]);
}  
//==============================================================================
//� ������ "StackList" ���������� ���� �� ������ ���������� ������              /*StackList*/
//����� "StackList" ������� ������������� ������ "Stack"
class StackList : public Stack 
{
  private:
    struct StructType
    {
      TElement x;
      StructType *prev;
    };
    StructType *last;
    StructType *pointer;
    int nCount; //���������� ��������� � �����
    void Delete() //������� �������
    {
      if (IsEmpty())
        return;
      pointer = last -> prev;
      free(last);
      last = pointer;
      nCount--;
      return;
    }
  public:
    StackList()  //�����������
    {
      last = NULL; //��������� �� �������
      nCount = 0; //���������� ���������
    }
    ~StackList() //����������
    {
      pointer = last; //������� ���������� ������
      while (pointer != NULL) 
      {
        pointer = last->prev;
        free(last);
        last = pointer;
      }
      nCount = 0;
    }
    int Pop();            //������� ������ �� �����
    int Push(TElement d); //��������� ������ � ����
    //�������� ����� �� �������
    int IsEmpty(){return(nCount==0);}        
    TElement Top();       //��������� ������� �����
};
//------------------------------------------------------------------------------
//���������� ������� �� �����
int StackList::Pop() 
{ 
  if (StackList::IsEmpty()) //���� ����
    return -1;
  TElement var = last -> x;
  Delete();
  return (var);
}
//------------------------------------------------------------------------------
//��������� ������ � ����
int StackList::Push(TElement x) 
{
  pointer = last;
  last = new StructType;
  last -> x = x;
  last -> prev = pointer;
  nCount++;
  return x;
}
//------------------------------------------------------------------------------
//��������� ������� �����
TElement StackList::Top() 
{
  if (StackList::IsEmpty()) //���� ����
    return -1;
  return (last -> x);
}
