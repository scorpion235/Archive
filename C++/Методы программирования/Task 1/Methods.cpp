//«Структуры данных: стек и список»
//Часть 1
//Семенцов Евгений МК-302

#if defined(__BORLANDC__)
  #include <vcl.h>
  #pragma hdrstop
  #pragma argsused
#endif

#include <stdio.h>
#include <windows.h>
#include <math.h>
#include <iostream.h>
#include <fstream.h>
#include <iomanip.h>
#include <stdlib.h>

#define TElement int
#define number 50000 //максимальное количество элементов

char inputname[] = "input.txt"; //имя входного файла
TElement a[number];
char * a_str[2] = {"StackList", "StackArray"};
int Case; //будет отвечать за наименование стека - список или массив

class Stack {
public:
  virtual TElement Pop() = 0; //извлечь x из стека
  virtual TElement Push(TElement x) = 0;  //поместить x в стек
  virtual bool IsEmpty() = 0; //проверка на пустоту стека
  virtual TElement Top() = 0; //прочитать вершину
private:
  virtual void Delete() = 0; //удаляет вершину
};

class StackList : public Stack {
  //Ключевое слово public, указывает, что общие
  //(public) элементы класса-родителя также являются общими и в классе-потомке
public:
  StackList() { //конструктор
    last = NULL; //указатель на вершину
    nCount = 0; //количество элементов
  }
  ~StackList() { //деструктор
     pointer = last; //удаляем выделенную память
     while (pointer != NULL) {
       pointer = last->prev;
       free(last);
       last = pointer;
     }
     nCount = 0;
  }

  bool IsEmpty() { //проверка на пустоту стека
    return (nCount ? false : true);
  }

  TElement Pop() { //извлечение из стека
    if (IsEmpty())
      return (TElement) NULL;
    TElement var = last -> x;
    Delete();
    return (var);
  }

  TElement Push(TElement x) {
    pointer = last;
    last = new StructType;
    last -> x = x;
    last -> prev = pointer;
    nCount++;
    return x;
  }

  TElement Top() {
    if (IsEmpty())
      return (TElement) NULL;
    return (last -> x);
  }

private:
  struct StructType { //основная структура
    TElement x;
    StructType * prev;
  };

  StructType * last;

  int nCount; //количество элементов в стеке

  StructType * pointer;

  void Delete() {
    if (IsEmpty())
      return;
    pointer = last -> prev;
    free(last);
    last = pointer;
    nCount--;
    return;
  }
};
//Окончание класса

class StackArray : public Stack {
public:
  StackArray() {
    nCount = 0;
  }
  ~StackArray() {
    nCount = 0;
  }

  TElement Pop() {
    if (IsEmpty())
      return (TElement) NULL;
    TElement x = array[nCount-1];
    Delete();
    return x;
  }


  TElement Push(TElement x) {
    array[nCount++] = x;
    return x;
  }

  TElement Top() {
    if (IsEmpty())
      return (TElement) NULL;
    return (array[nCount-1]);
  }

  bool IsEmpty() { //проверка на пустоту стека
    return (nCount ? false : true);
  }

  private: //скрыто от пользователя
  TElement array[number];
  int nCount; //количество элементов в стеке

  void Delete() {
    if (!IsEmpty())
      array[--nCount]=0;
    return;
  }
};

void SimpleSort(Stack * varStack) {
  TElement a, b;
  a = varStack -> Pop();
  if (varStack -> IsEmpty()) {
    varStack -> Push(a);
    return;
  }
  else {
    b = varStack -> Pop();
    if (a > b) {
      varStack -> Push(a);
      varStack -> Push(b);
    }
    else {
      varStack -> Push(b);
      varStack -> Push(a);
    }
  }
}

void Sort(Stack * varStack) {
  Stack * Stack1, * Stack2;
  switch (Case) {
     case 1: //для случая списка
       Stack1 = new StackList;
       Stack2 = new StackList;
       break;
     case 2: //для случая массива
       Stack1 = new StackArray;
       Stack2 = new StackArray;
       break;
  }
  TElement var;
  TElement Border;
  int n1 = 0;
  int n2 = 0;
  int last_el;
  if (!(varStack -> IsEmpty())) {
    Border = varStack -> Pop();
    n1++;
    Stack1 -> Push(Border);
    last_el = 1;
  }
  while (!(varStack -> IsEmpty())) {
    var = varStack->Pop();
    if (Border == var) { //если в исходном стеке все элементы равны, то это поможет для распределения
       switch (last_el) {
          case 2: Stack1 -> Push(var); n1++; last_el = 1; break;
          case 1: Stack2 -> Push(var); n2++; last_el = 2; break;
       }
    }
    else {
      if (Border > var) {
        Stack1 -> Push(var);
        last_el = 1;
        n1++;
      }
      else {
        Stack2 -> Push(var);
        last_el = 2;
        n2++;
      }
    }
  }

  if (n1<=2)
    SimpleSort(Stack1);
  else
    Sort(Stack1);

  if (n2<=2)
    SimpleSort(Stack2);
  else
    Sort(Stack2);

  while (!Stack1 -> IsEmpty())
    varStack -> Push(Stack1 -> Pop());
  while (!Stack2 -> IsEmpty())
    varStack -> Push(Stack2 -> Pop());
  delete Stack1;
  delete Stack2;
}

void Loading(Stack * varStack, int num, int Case) {
  DWORD time = GetTickCount();
  TElement j = 0;
  for (int i = 0; i < 2000000; i++) {
    varStack -> Push(abs(i - j));
    varStack -> Push(abs(i + j));
    varStack -> Top();
    varStack -> Pop();
    j = varStack -> Pop();
  }
  cout << "Time for " << a_str[Case-1] << " is: " << GetTickCount() - time << endl;
}

void Sorting(Stack * varStack, int num, int Case) {
  int i;
  char fn[20];
  sprintf(fn,"%s%d.txt", "output", Case);
  
  ofstream output_file(fn);
  output_file << "Before Sorting:" << endl;
  for (i=0; i<num; i++)
    output_file << " #" << setw(5) << i+1 << " : " << setw(5) << varStack -> Push(a[i]) << '\n';
  output_file.flush();
  Sort(varStack);
  output_file << endl << "After Sorting:" << endl;
  i = 0;
  while (!varStack->IsEmpty()) {
    output_file << " #" << setw(5) << i+1 << " : " << setw(5) << varStack -> Pop() << '\n';
    i++;
  }
  output_file.close();
}

int main(int argc, char *argv[]) {
  FILE *fp;
  char* fname;
  if (argc == 1)     // no args
    fname = inputname;
  else               // one arg: file name
    fname = argv[1];
  setbuf(stdout, 0); //Assigns buffering to a stream
                     //With setbuf, if buf is null, I/O will be unbuffered.
  if ((fp = fopen(fname, "r")) == NULL) {
    fprintf(stderr, "  <ProgName> [InputData File]\n");
    fprintf(stderr, "  Default: InputData = input.txt\n");
    fprintf(stderr, "  Can't open file %s\n",fname);
    exit(1);
  }

  int num = 0;
  while (!feof(fp))
    fscanf(fp,"%d\n",&a[(++num)-1]);
  fclose(fp);

  Stack * varStack = new StackList;
  Case = 1;
  Loading(varStack, num, Case);
  Sorting(varStack, num, Case);
  delete varStack;

  varStack = new StackArray;
  Case = 2;
  Loading(varStack, num, Case);
  Sorting(varStack, num, Case);
  delete varStack;
  return 0;
}
