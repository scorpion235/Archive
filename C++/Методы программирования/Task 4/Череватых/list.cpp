/*���� list.cpp �������� ��������� � ���������� ������ List(������)
�����: ��������� ������� ����������.
����� ����������: Borland C++ Builder 6.
����: 26 ������ 2004�*/


#ifndef _LIST
#define _LIST
#define TElement int

#include <stddef.h>
#include <iostream.h>


//��������� ������� ������
struct TNode {
  TElement data;
  TNode* prev;
  TNode* next;
};



//------------------------------------------------------------------------------
//����� ������
class List {
private:
  TElement *array;
public:
  unsigned int count;
  TNode* root;
  TNode* last;
  void DeleteList();
  List();
  int AddBefore(TNode* x, TElement key);
  int AddAfter(TNode* x, TElement key);
  int Delete(TNode* x);
  int Count();
};




//------------------------------------------------------------------------------
//���������� ������ List
List::List() {
  root=NULL;
  last=NULL;
  count=0;
};


//------------------------------------------------------------------------------
void List::DeleteList() {
        if (root==NULL)
                return;
	while (root->next!=NULL) {
	        root=root->next;
	        delete root->prev;
    }
    delete root;
    root=NULL;
    count=0;
};


//--------------------------------------------------------------------
//��������� ������� key ����� ��������� TNode *x.
//���������� 1, ���� ������� ��������� �������.
//���������� 0, ���� ������� ��������� ��������.
inline int List::AddBefore (TNode *x,TElement key) {
  TNode *tmp;
  if (x==NULL) {
	x=new TNode;
	if (x==NULL) return 0;
	x->data=key;
	x->next=NULL;
	x->prev=NULL;
	root=x;
	last=x;
	count++;
	return 1;
  } else {
	tmp=new TNode;
	if (tmp==NULL) return 0;
	tmp->data=key;
	if (x==root) {
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
//��������� ������� key ����� �������� TNode *x
//���������� 1, ���� ������� ��������� �������.
//���������� 0, ���� ������� ��������� ��������.
inline int List::AddAfter (TNode* x,TElement key) {
  TNode *tmp;
  if (x==NULL) {
	x=new TNode;
	if (x==NULL) return 0;
	x->data=key;
 	x->next=NULL;
	x->prev=NULL;
	root=x;
	last=x;
	count++;
	return 1;
  } else {
	tmp=new TNode;
	if (tmp==NULL) return 0;
	tmp->data=key;
	if (x->next==NULL) {
	  x->next=tmp;
	  tmp->prev=x;
	  tmp->next=NULL;
	  last=tmp;
	  count++;
	  return 1;
	} else {
	tmp->prev=x;
	tmp->next=x->next;
	x->next->prev=tmp;
	x->next=tmp;
	count++;
	return 1;
  }
  }
};

//------------------------------------------------------------------------------
//������� ������ �� ������� ��������� TNode *x
//���������� 1, ���� �������� ��������� �������.
//���������� 0, ���� �������� ��������� ��������.
int List::Delete (TNode* x) {
  TNode *temp1,*temp2;
  if (x==NULL)
	return 0;
  if (x->next==NULL) {
	root=root->next;
	delete root->prev;
        root->prev=NULL;
	count--;
	return 1;
  }
  if (x->next==NULL) {
	x->prev->next=NULL;
	delete x;
	count--;
	return 1;
  }
  x->prev->next=x->next;
  x->next->prev=x->prev;
  count--;
  delete x;
  x=NULL;
  return 1;
};


//------------------------------------------------------------------------------
//���������� ���������� ��������� � ������
int List::Count() {
  return count;
};

#endif
