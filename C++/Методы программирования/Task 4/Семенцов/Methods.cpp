//Семенцов Евгений МК-302
//Реализация сверхбольших чисел
//По возможности использованы функции WinAPI работы с памятью и строками, а также счетчик времени
#include <windows.h>
#include <iostream.h> // input output stream
#include <fstream.h> //input output file stream
#include <stdio.h>
#include <conio.h>

#include "Memory.h"

class bigType { //реализация класса
public:
  ~bigType() { //деструктор
    data = (char*) my_realloc(data, 0); //освобождаем память
  };

  bigType(int numberV) { //конструктор с числом
    data = NULL;
    data = (char*) my_realloc(data, 2);
    lstrcpy(data,"0");

    if (numberV == 0)
      return;

    char * destData = NULL;
    char stringV[10];
    sprintf(stringV,"%d",numberV);
    InvertString(stringV);
    AdditionStr(destData,data,stringV);
    SetString(destData);
    destData = (char*) my_realloc(destData, 0);
  }

  bigType(char * stringV = NULL) { //конструктор со строкой, NULL - по дефолту
    data = NULL;
    SetUserString(stringV);
  };


  bigType & operator = (const bigType & classV) { //оператор "присвоить"
    if (this == & classV)
      return * this;
    if (classV.GetString() != NULL) {
      data = (char*) my_realloc(data, lstrlen(classV.GetString()) + 1);
      lstrcpy(data, classV.GetString());
    }
    else {
      data = (char*) my_realloc(data, 2);
      lstrcpy(data,"0");
    }
    return * this;
  };

  bigType & operator += (int numberV) { //оператор "прибавить"
    if (numberV == 0)
      return * this;
    char * destData = NULL;
    char stringV[10];
    sprintf(stringV,"%d",numberV);
    InvertString(stringV);
    AdditionStr(destData,data,stringV);
    SetString(destData);
    destData = (char*) my_realloc(destData, 0);
    return * this;
  };

  int operator == (const bigType & classV) { //оператор "сравнить"
    if (lstrlen(classV.GetString()) == lstrlen(data)) {
      for (int i=lstrlen(data)-1; i>=0; i--) {
        if ((data)[i] > (classV.GetString())[i])
          return 1;
        if ((data)[i] < (classV.GetString())[i])
          return -1;
      }
      return 0;
    }
    else {
      if (lstrlen(data) > lstrlen(classV.GetString()))
        return 1;
      else
        return -1;
    }
  }

  bigType & operator *= (int numberV) { //оператор "домножить"
    if (numberV == 1)
      return * this;
    char * destData = NULL;
    char stringV[10];
    sprintf(stringV,"%d",numberV);
    InvertString(stringV);
    MultiplyStr(destData,data,stringV);
    SetString(destData);
    destData = (char*) my_realloc(destData, 0);
    return * this;
  };

  bigType & operator + (const bigType & classV) { //оператор "сложить"
    bigType * result = new bigType;
    char * destData = NULL;
    AdditionStr(destData,classV.GetString(),data);
    result -> SetString(destData);
    destData = (char*) my_realloc(destData, 0);
    return * result;
  };

  bigType & operator * (const bigType & classV) { //оператор "умножить"
    bigType * result = new bigType;
    char * destData = NULL;
    MultiplyStr(destData,classV.GetString(),data);
    result -> SetString(destData);
    destData = (char*) my_realloc(destData, 0);
    return * result;
  };

  void SetUserString(char * stringV = NULL) { //установить число - преобразование к нужному
    if (stringV != NULL) {                    //формату производит сама функция
      data = (char*) my_realloc(data, lstrlen(stringV) + 1);
      lstrcpy(data,stringV);
      InvertString(data);
      ZeroEraser(data);
    }
    else {
      data = (char*) my_realloc(data, 2);
      lstrcpy(data,"0");
    }
  };

  char * GetUserString(char *& stringV) { //интерфейс для получения строки пользователем
    stringV = (char*) my_realloc(stringV, lstrlen(data) + 1); //потом нужно освободить
    lstrcpy(stringV,data);
    InvertString(stringV);
    return stringV;
  };

  friend ostream & operator << (ostream &, const bigType &); //для вывода в поток cout

private:
  //реализация сложения сверхбольших чисел
  char * AdditionStr(char *& dataStr, char * str1, char * str2) {
    int size = (lstrlen(str1) > lstrlen(str2)) ? lstrlen(str1) : lstrlen(str2);
    dataStr = (char*) my_realloc(dataStr, size + 2); // еще один символ на заверш-й ноль и еще один на возможный новый разряд
    int shift = 0;                                   //память потом нужно освободить
    int sum;
    for (int i=0; i<size; i++) {
      sum = shift;
      if (lstrlen(str1)>i)
        sum += str1[i] - 48; //символ '0' имеет код как раз 48
      if (lstrlen(str2)>i)
        sum += str2[i] - 48;
      dataStr[i] = (sum % 10) + 48;
      shift = sum / 10; //сдвиг
    }
    dataStr[size] = '\0';
    if (shift) {
      dataStr[size] = (shift % 10) + 48;
      dataStr[size + 1] = '\0';
    }
    return dataStr;
  }

  //реализация умножения сверхбольших чисел
  char * MultiplyStr(char *& dataStr, char * str1, char * str2) {
    //каждый разряд умножаем на каждый в другом числе (добавляя необходимое кол-во нулей справа)
    //и затем складываем
    char * tmpStr = NULL;
    char * destStr = NULL; //к этой строке будем добавлять
    int size;
    char smallStr[3]; //дополнительная строка для sprintf
    //99*999 < 100*1000 = 100000 => 99*999 <= 99999
    dataStr = (char*) my_realloc(dataStr, lstrlen(str1) + lstrlen(str2) + 1);
    dataStr[0] = '0';
    dataStr[1] = '\0';

    tmpStr = (char*) my_realloc(tmpStr, lstrlen(str1) + lstrlen(str2) + 1);
    for (int i = 0; i < lstrlen(str1); i++)
      for (int j = 0; j < lstrlen(str2); j++) {
        size = i + j;
        sprintf(smallStr,"%d",(str1[i] - 48) * (str2[j] - 48));
        if (lstrcmp(smallStr,"0") == 0) // а зачем нам ноль складывать?
          continue;

        FillMemory(tmpStr,size,'0'); //заполняем нулями
        if (lstrlen(smallStr) > 1) {
          tmpStr[size] = smallStr[1];
          tmpStr[size + 1] = smallStr[0];
          tmpStr[size + 2] = '\0';
        }
        else {
          tmpStr[size] = smallStr[0];
          tmpStr[size + 1] = '\0';
        }
        AdditionStr(destStr,dataStr,tmpStr);
        lstrcpy(dataStr,destStr);
      }
    tmpStr = (char*) my_realloc(tmpStr, 0);
    destStr = (char*) my_realloc(destStr, 0);
    return dataStr;
  };

  char * InvertString(char *& stringV) { //строка переписывается задом наперед
    char c;
    for (int i=1; i <= lstrlen(stringV)/2; i++) {
      c = stringV[i-1];
      stringV[i-1] = stringV[lstrlen(stringV) - i];
      stringV[lstrlen(stringV) - i] = c;
    }
    return stringV;
  }

  void SetString(char * stringV = NULL) { //устанавливает data из stringV - в нужном формате
    if (stringV) {
      data = (char*) my_realloc(data, lstrlen(stringV) + 1);
      lstrcpy(data,stringV);
    }
    else {
      data = (char*) my_realloc(data, 2);
      lstrcpy(data,"0");
    }
  };

  char * GetString() { //только для системных функций - возвращает указатель на data
    return data;
  };

  void ZeroEraser(char *& stringV) { //удаляет ведущие нули в начале числа
    for (int i = lstrlen(stringV)-1; i>0; i--)
      if (stringV[i] == '0')
        stringV[i] = '\0';
      else
        break;
  }

  char * data;
};

ostream & operator << (ostream & out, const bigType & a) {
  for (int i = lstrlen(a.GetString())-1; i>=0; i--)
    cout << (a.GetString())[i];
  return out;
}

class FIFO { //реализация очереди
  //Ключевое слово public, указывает, что общие
  //(public) элементы класса-родителя также являются общими и в классе-потомке
public:
  FIFO() { //конструктор
    first = NULL; //указатель на начало
    last = NULL; //указатель на конец
    nCount = 0; //количество элементов
  }

  ~FIFO() { //деструктор
     pointer = last; //удаляем выделенную память
     while (last != NULL) {
       pointer = last -> prev;
       delete last;
       last = pointer;
     }
     first = NULL;
     nCount = 0;
  }

  bool IsEmpty() { //проверка на пустоту стека
    return (nCount == 0);
  }

  bigType & Pop() { //извлечение из стека
    bigType * var = NULL;
    if (IsEmpty())
      return (* var); // !!!
    var = new bigType;
    * var = last -> x;
    Delete();
    return * var;
  }

  bigType & Push(const bigType & xSrc) {
    pointer = first;
    first = new StructType;
    first -> x = xSrc;
    first -> prev = NULL;
    nCount++;
    if (pointer != NULL)
      pointer -> prev = first;
    else
      last = first;
    return first -> x;
  }

  bigType & Top() {
    bigType * var = NULL;
    if (IsEmpty())
      return * var; //!!!
    return last -> x;
  }

private:
  struct StructType { //основная структура
    bigType x;
    StructType * prev;
  };

  StructType * last, * first;
  int nCount; //количество элементов в стеке
  StructType * pointer;

  void Delete() {
    if (IsEmpty())
      return; //!!!
    if (nCount > 1) {
      pointer = last -> prev;
      delete last;
      last = pointer;
    }
    else {
      delete last;
      last = NULL;
      first = NULL;
    }
    nCount--;
    return;
  }
};

//Окончание класса очереди

int main() {
  InitHeap();
  FIFO vFIFO;
  char * stringV = NULL;
  bigType a("9455"), b("16"), c(125), d("25"), e;
  cout << "Examples of usage:\n";
  cout << "a = " << a << " b = " << b << " c = " << c << " d = " << d << " e = " << e << endl;
  cout << "a + c * d = " << (a + c * d) << endl;
  cout << "a + 990 = " << (a += 990) << endl;
  cout << "b * 5 = " << (b *= 5) << endl;

  printf("Another method: a = %s\n",a.GetUserString(stringV));
  stringV = (char*) my_realloc(stringV, 0);
  cout << "Compare a and b (1- a>b, 0- a=b, -1- a<b):\n";
  cout << "a = "<< a << ", b = " << b << " a == b: " << (a == b) << endl;

  int nCount = 0;
  char str1[1000], str2[1000], strV[1000];
  FIFO ** pointerV = NULL;
  bigType ** numberV = NULL;
  ifstream in("input.txt");
  in >> str1 >> str2;

  bigType a1(str1), a2(str2); //левая и правая границы

  cout << "Input Numbers:\n";
  while (in.eof() == 0) {
    in >> strV;
    nCount++;

    //вообще говоря, исходные простые множители тоже могут быть сверхбольшими числами (!)
    numberV = (bigType **) my_realloc(numberV, nCount * sizeof(bigType *));
    numberV[nCount-1] = new bigType(strV);

    pointerV = (FIFO **) my_realloc(pointerV, nCount * sizeof(FIFO *));
    pointerV[nCount-1] = new FIFO;
    pointerV[nCount-1] -> Push(* numberV[nCount-1]);
    cout << nCount << " : " << pointerV[nCount-1] -> Top() << endl;
  }
  in.close();
  cout << "Left Border = " << str1 << " Right Border = " << str2 << "\n";
  cout << "Find:\n";

  if (!nCount)
    return -1;

  LARGE_INTEGER StartExec, PerfFreq, EndExec;
  DWORD Time = GetTickCount();

  PerfFreq.QuadPart = 0;
  if (QueryPerformanceFrequency(&PerfFreq))
    QueryPerformanceCounter(&StartExec);

  int tmp;
  int ifPut = 0; //если значение этой переменной равно 0, то есть необходимость запихивать в очередь
  bigType tek, tmpClass;
  for (;;) {
    tmp = 0;
    for (int i=1; i<nCount; i++) { //первый можно не смотреть - поэтому с 1
      if ((pointerV[i] -> Top() == pointerV[tmp] -> Top()) == -1)
        tmp = i;
    }

    //условие выхода из цикла - наименьшая вершина в каждой очереди больше заданного числа
    if ((pointerV[tmp] -> Top() == a2) == 1) //больше правой границы
      break;
    if ((pointerV[tmp] -> Top() == a1) != -1)  //не меньше левой границы
      cout << pointerV[tmp] -> Top() << endl;

    tek = pointerV[tmp] -> Top();

    for (int i=0; i<nCount; i++) {
      if ((pointerV[i] -> Top() == tek) == 0)
        pointerV[i] -> Pop();
    }

    if (!ifPut) {
      ifPut = 1;
      for (int i=0; i<nCount; i++) {
        tmpClass = (* numberV[i]) * tek;
        if ((tmpClass == a2) != 1) { //не больше
          ifPut = 0; //в этом случае снова записывать не будем - т.к. все записываемые числа будут больше порогового
        }
        pointerV[i] -> Push(tmpClass);
      }
    }
  }

  if (PerfFreq.QuadPart > 0) {
    QueryPerformanceCounter(&EndExec);
    printf("Time: %.3f ms \n",((EndExec.QuadPart - StartExec.QuadPart) * 1000.0) / PerfFreq.QuadPart);
  }
  else //если первый способ подсчета времени не поддерживается
    printf("GetTickCount-Time: %d ms \n",GetTickCount() - Time);
  getch();
}
