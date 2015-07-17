/***************************************
 * Метод программирования (Задание 1)  *                          
 * В модуле "Stack.cpp" реализован     *
 * стек на основе массива и ссылочного *
 * списка                              *
 ***************************************
 * Выполнил: Дюгуров Сергей            *
 * Группа МК-201                       *
 * Среда разработки: Dev-C++ 4.9.8.0   *
 * Дата: 10.12.04                      *
 ***************************************/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#define TElement int
#define MAX_SIZE 50000 //максимальное количество элементов мвссива

class Stack
{
  public:
    virtual int Pop()=0;            //извлечь данное из стека
    virtual int Push(TElement d)=0; //поместить данное в стек
    virtual int IsEmpty()=0;        //проверка стека на пустоту
    virtual TElement Top()=0;       //прочитать вершину       
};
//------------------------------------------------------------------------------
//в классе "StackArray" реализован стек на основе массива                       /*StackArray*/
//класс "StackArray" получен наследованием класса "Stack"
class StackArray : public Stack
{
  private:
    int s[MAX_SIZE];
    int top; 
  public:
    StackArray(){top=0;}  // конструктор
    ~StackArray(){top=0;} // деструктор
    int Pop();            //извлечь данное из стека
    int Push(TElement d); //поместить данное в стек
    //проверка стека на пустоту
    int IsEmpty(){return(top==0);}        
    TElement Top();       //прочитать вершину стека
};
//------------------------------------------------------------------------------
//извлечь данное из стека
int StackArray::Pop() //d-извлекаемое данное
{
  if (StackArray::IsEmpty()) //стек пуст
    return -1;
  //printf("\nDelete %i", StackArray::Top());
  return (--top);
}
//------------------------------------------------------------------------------
//поместить данное в стек
int StackArray::Push(TElement d) //d-помещаемое данное
{
  if(top==MAX_SIZE-1) //стек переполнен
    return -1;
  s[++top]=d;
  //printf("\nAdd %i", s[top]);
  //return 0;
}
//------------------------------------------------------------------------------
//прочитать вершину стека
TElement StackArray::Top()
{
  if (StackArray::IsEmpty()) // стек пуст
    return -1;
  //printf("\nTop: %i", s[top]);
  return (s[top]);
}  
//==============================================================================
//в классе "StackList" реализован стек на основе ссылочного списка              /*StackList*/
//класс "StackList" получен наследованием класса "Stack"
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
    int nCount; //количество элементов в стеке
    void Delete() //удаляет вершину
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
    StackList()  //конструктор
    {
      last = NULL; //указатель на вершину
      nCount = 0; //количество элементов
    }
    ~StackList() //деструктор
    {
      pointer = last; //удаляем выделенную память
      while (pointer != NULL) 
      {
        pointer = last->prev;
        free(last);
        last = pointer;
      }
      nCount = 0;
    }
    int Pop();            //извлечь данное из стека
    int Push(TElement d); //поместить данное в стек
    //проверка стека на пустоту
    int IsEmpty(){return(nCount==0);}        
    TElement Top();       //прочитать вершину стека
};
//------------------------------------------------------------------------------
//извлечение данного из стека
int StackList::Pop() 
{ 
  if (StackList::IsEmpty()) //стек пуст
    return -1;
  TElement var = last -> x;
  Delete();
  return (var);
}
//------------------------------------------------------------------------------
//поместить данное в стек
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
//прочитать вершину стека
TElement StackList::Top() 
{
  if (StackList::IsEmpty()) //стек пуст
    return -1;
  return (last -> x);
}
