#include "stdio.h"
#include <conio.h>
#include <string.h>
#define MAX_SIZE 100 //максимальное количество элементов массива

struct Node
{
  char d;
  Node *left;
  Node *right;
};
//------------------------------------------------------------------------------
Node *First(char d);
Node *SearchInsert(Node *root, char d);
int PrintTree(Node *root, int level);
//------------------------------------------------------------------------------
//int tree(char sim[MAX_SIZE])
int main()
{
  char sim[]="ab+cd-*";
  int i, j=0;
  char b[MAX_SIZE];
  for (i=0;i<strlen(sim);i++)
    if ((sim[i]!=' ') & (sim[i]!='|') & (sim[i]!='\n'))
    {
      b[j]=sim[i];
      printf("%c", b[j]);
      j++;
    }
  j--;
  printf("\nroot: %c\n", b[j]);    
  Node *root=First(b[j]); 
  for (int i=j;i>=0;i--)
    SearchInsert(root, b[i]);
  PrintTree(root, 0);
  getch();
  return 0;
}
//------------------------------------------------------------------------------
//формирование первого элемента дерева
Node *First(char d)
{
  Node *pv=new Node;
  pv->d=d;
  pv->left=0;
  pv->right=0;
  return pv;
}
//------------------------------------------------------------------------------
//поиск с включениями
//a + b * c
//a b c * +
Node *SearchInsert(Node *root, char d)
{
  printf("data %c\n", d);
  Node *pv=root, *prev;
  bool found=false;
  while ((pv) && (!found))
  {
    printf("pv->%c = %c\n", d, pv->d);
    prev=pv;
    if (d==pv->d)
      found=true;
    else if (d<pv->d)
      pv=pv->left;    
    else
      pv=pv->right;
  }
  if (found) 
    return pv;
  //создание нового узла
  Node *pnew=new Node;
  pnew->d=d; 
  pnew->left=0;
  pnew->right=0;
  if (d<prev->d)
    //присоединение к левому поддерев предка
    prev->left=pnew;
  else
    //присоединение к правому поддерев предка 
    prev->right=pnew;
  return pnew;
}
//------------------------------------------------------------------------------
//обход дерева
int PrintTree(Node *p, int level)
{
  if (p)
  {
    PrintTree(p->left, level+1); //вывод левого поддерева
    for (int i=0;i<level;i++)
      printf("  ");
    printf("%c\n", p->d); //вывод корня поддерева
    PrintTree(p->right, level+1); //вывод правого поддерева
    return 0;
  }  
}
