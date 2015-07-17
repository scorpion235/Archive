#include <iostream.h>
#include <fstream.h>
#include <stddef.h>
#include <time.h>
#include <stdlib.h>
#define TElement int

//Структура элемент списка
struct TNode
{
  TElement data;
  TNode* prev;
  TNode* next;
};
//------------------------------------------------------------------------------
//Класс Список
class List
{
  private:
    void DeleteList();
    unsigned short int count;
    TElement *array;
    List(int array_size);
  public:
    TNode* root;
    TNode* last;
    List();
    int AddBefore(TNode* x, TElement key);
    int AddAfter(TNode* x, TElement key);
    int Delete(TNode* x);
    TNode *FindKey(TElement key);
    TNode *Item(int index);
    int Count();
    List Concat(List list1,List list2);
    void Pecar(void);
    void Sort();
    void Show();
};
TNode *tmp;
//------------------------------------------------------------------------------
//Конструтор класса List
List::List()
{
  root=NULL;
  last=NULL;
  count=0;
};
//------------------------------------------------------------------------------
List::List(int array_size)
{
  root=NULL;
  last=NULL;
  count=0;
  array=new TElement[array_size+1];
  if (array==NULL) 
	cout <<"No free memory\n";
}
//------------------------------------------------------------------------------
void List::DeleteList()
{
  while (root->next!=NULL)
  {
	root=root->next;
	delete root->prev;
  }
  delete root;
  count=0;
}
//------------------------------------------------------------------------------
//Вставляет элемент key перед элементом TNode *x.
//Возвращает 1, если вставка произошла успешно.
//Возвращает 0, если вставка произошла неудачно.
inline int List::AddBefore (TNode *x,TElement key)
{
  if (x==NULL)
  {
	x=new TNode;
	if (x==NULL) return 0;
	x->data=key;
	x->next=NULL;
	x->prev=NULL;
	root=x;
	last=x;
	count++;
	return 1;
  }
  else
  {
	tmp=new TNode;
	if (tmp==NULL) return 0;
	tmp->data=key;
	if (x==root)
    {
	  tmp->next=root;
	  tmp->prev=NULL;
	  root->prev=tmp;
	  root=tmp;
	  count++;
	  return 1;
	}
    tmp->prev=x->prev;
    x->prev->next=tmp;
    tmp->next=x;
    x->prev=tmp;
    count++;
    return 1;
  }
};
//------------------------------------------------------------------------------
//Вставляет элемент key после элемента TNode *x
//Возвращает 1, если вставка произошла успешно.
//Возвращает 0, если вставка произошла неудачно.
inline int List::AddAfter (TNode* x,TElement key)
{
  if (x==NULL)
  {
	x=new TNode;
	if (x==NULL) return 0;
	x->data=key;
 	x->next=NULL;
	x->prev=NULL;
	root=x;
	last=x;
	count++;
	return 1;
  }
  else
  { 
	tmp=new TNode;
	if (tmp==NULL) return 0;
	tmp->data=key;
	if (x->next==NULL)
    {
	  x->next=tmp;
	  tmp->prev=x;
	  tmp->next=NULL;
	  last=tmp;
	  count++;
	  return 1;
	}
    else
    {
	  tmp->prev=x;
	  tmp->next=x->next;
	  x->next->prev=tmp;
	  x->next=tmp;
	  count++;
	  return 1;
    }
  }
}
//------------------------------------------------------------------------------
//Удаляет элемент на который указывает TNode *x
//Возвращает 1, если удаление произошло успешно.
//Возвращает 0, если удаление произошло неудачно. 
int List::Delete (TNode* x)
{
  TNode *temp1,*temp2;
  if (x==NULL)
	return 0;
  if (x==root)
  {
	root=root->next;
	delete root->prev;
	count--;
	return 1;
  }
  if (x->next==NULL)
  {
	x->prev->next=NULL;
	delete x;
	count--;
	return 1;
  }
  x->prev->next=x->next;
  x->next->prev=x->prev;
  count--;
  delete x;
}
//------------------------------------------------------------------------------
//Возвращает указатель на элемент со значением TElement key
//или NULL, если элемент не найден
TNode* List::FindKey (TElement key)
{
  TNode *temp;
  temp=root;
  while (temp!=NULL)
  {
	if (temp->data==key)
	  return temp;
	temp=temp->next;
  }
  return NULL;
}
//------------------------------------------------------------------------------
//Возвращает указатель на элемент отстоящий на int index позиций от начала
//списка.
//Возвращает NULL, если такого элемента не существует
TNode* List::Item (int index)
{
  TNode *temp;
  temp=root;
  if ( (index<0) || (index>=Count()) )
    return NULL;
  for (int i=0;i<index;i++) 
	temp=temp->next;
  return temp;
}
//------------------------------------------------------------------------------
//Возвращает количество элементов в списке
int List::Count()
{
  return count;
};
//------------------------------------------------------------------------------
//Выполняет сортировку списка
void List::Sort()
{
  int count_t=Count();
  List list_sorted;
  register TNode *temp, *temp_sorted;
  temp=root;
  list_sorted.AddAfter(list_sorted.root,temp->data);
  temp=temp->next;
  Delete(root);
  temp_sorted=list_sorted.last;
  while (temp!=NULL)
  {
	for (;;)
    {
	  if ( ((temp_sorted->data) < (temp->data)) || (temp_sorted->prev==NULL) )
        break;
	  temp_sorted=temp_sorted->prev;
	}
	if ( (temp_sorted==list_sorted.root) && (temp_sorted->data > temp->data) ) 
	  list_sorted.AddBefore(temp_sorted,temp->data);
	else 
	  list_sorted.AddAfter(temp_sorted, temp->data);
	temp_sorted=list_sorted.last;
	if (temp->next==NULL) break;
	temp=temp->next;
	Delete(root);
  }
  root=list_sorted.root;
  count=count_t;
}
//------------------------------------------------------------------------------
//Функция объединения двух упорядоченных списков с сохранением порядка
List Concat(List list1,List list2)
{
  if (list1.root==NULL || list2.root==NULL)
  {
	cout <<"Concat2:error: one or more lists is empty\n";
  }
  TNode *temp1,*temp2;
  temp1=list1.last;
  temp2=list2.root;
  while (temp2!=NULL)
  {
	for (;;)
    {
	  if ( (temp1->data < temp2->data) || (temp1->prev==NULL) ) break;
	  temp1=temp1->prev;
	}
	if ( (temp1==list1.root) && (temp1->data > temp2->data) )
	  list1.AddBefore(temp1,temp2->data);
	else
	  list1.AddAfter(temp1,temp2->data);
	temp1=list1.last;
	if (temp2->next==NULL) break;
	temp2=temp2->next;
	list2.Delete(list2.root);
  }
  return list1;
}
//------------------------------------------------------------------------------
//Функция Преобразование пекаря
void List::Pecar()
{
  TNode *temp, *temp1;
  int count1;
  if (root==last)
    return;
  if (count%2)
    count1=count+1;
  else
    count1=count;
  temp1=root->next;
  root->next->prev=NULL;
  last->next=root;
  root->prev=last;
  root->next=NULL;
  last=root;
  root=temp1;
  temp=root->next;
  for (int i=0;i<((count1-2)/2);i++)
  {
    temp1=temp->next;
    temp->next->prev=temp->prev;
    temp->prev->next=temp->next;
    last->next=temp;
    temp->next=NULL;
    temp->prev=last;
    last=temp;
    temp=temp1->next;
  }
}    
//------------------------------------------------------------------------------	  
//Функция вывода списка на экран
void List::Show ()
{
  TNode *temp=root;
  while (temp!=NULL)
  {
  cout <<temp->data <<" -> ";
    temp=temp->next;
  };
  cout <<endl;
}
