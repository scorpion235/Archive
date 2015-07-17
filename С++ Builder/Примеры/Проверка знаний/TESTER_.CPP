/* Универсальная программа тестирования. Тест загружается
   из файла, имя которого должно быть указано в командной
   строке.
   Программа демонстрирует создание и настройку компонентов
   во время работы программы.
*/

#include <vcl.h>
#pragma hdrstop

#include "tester_.h"
#include <stdio.h>     // для доступа к функции sscanf

#pragma package(smart_init)
#pragma resource "*.dfm"

TForm1  *Form1;   // форма

int f;            // дискриптор файла теста
                  // имя файла теста берем из командной строки

int level[4];     // кол-во правильных ответов, необходимое для достижения уровня
AnsiString mes[4];// сообщение о достижении уровня

TVopros Vopros;   // вопрос
int otv;          // номер выбранного ответа

int right = 0;    // кол-во правильных ответов

// функции, обеспечивающие чтение вопроса из файла теста
int GetInt(int f);                     // читает целое
int GetString(int f, AnsiString *st);  // читает строку


// конструктор
__fastcall TForm1::TForm1(TComponent* Owner)
    : TForm(Owner)
{
    int i;
    int left = 10;

    // создадим радиокнопки для выбора
    // правильного ответа, но сделаем их невидимыми
    for (i = 0; i < 4; i++ )
    {
        // создадим радиокнопку
        RadioButton[i] = new TRadioButton(Form1);
        // установим значения свойств
        RadioButton[i]->Parent = Form1;
        RadioButton[i]->Left = left;
        RadioButton[i]->Width = Form1->ClientWidth - left - 20;
        RadioButton[i]->Visible = false;
        RadioButton[i]->Checked = false;

        // зададим функцию обработки события Click
        RadioButton[i]->OnClick = RadioButtonClick;
    }
}

void __fastcall TForm1::FormActivate(TObject *Sender)
{
    AnsiString st;

    // имя файла теста должно быть указано в командной строке
    int n = ParamCount();
    if (  n < 1 )
    {
        Label1->Font->Style = TFontStyles()<< fsBold;
        Label1->Caption = "В командной строке запуска программы надо задать имя файла теста";
        Button1->Tag = 2;
        return;
    }

    // открыть файл теста
    f = FileOpen(ParamStr(1), fmOpenRead);
    if ( f == -1 )
    {
            Label1->Font->Style = TFontStyles()<< fsBold;
            Label1->Caption =
               "Ошибка доступа к файлу теста " + ParamStr(1);
            Button1->Tag = 2;
            return;
    }

    //  вывести информацию о тесте
    GetString(f, &st); // прочитать название теста
    Form1->Caption = st;

    GetString(f, &st); // прочитать вводную информацию
    Label1->Width = Form1->ClientWidth - Label1->Left -20;
    Label1->Caption = st;
    Label1->AutoSize = true;

    // прочитать информацию об уровнях оценки
    for (int i=0; i<4; i++)
    {
        level[i] = GetInt(f);
        GetString(f, &mes[i]);
    }
}

// читает из файла очередной ворос
bool GetVopros(TVopros *v)
{
    AnsiString st;
    int p;   // если p=1, то к вопросу есть иллюстрация

    if ( GetString(f, &(v->Vopr)) != 0 )
    {
        // прочитать кол-во вариантов ответа, номер правильного ответа
        // и признак наличия иллюстрации
        v->nOtv = GetInt(f);
        v->rOtv = GetInt(f);
        p       = GetInt(f);

        if (p) // к вопросу есть иллюстрация
            GetString(f,&(v->Img) );
        else v->Img = "";

        // читаем варианты ответа
        for (int i = 0; i < v->nOtv; i++)
        {
            GetString(f,&(v->Otv[i]));
        }
        return true;
    }
    else return false;
}

// выводит вопрос
void __fastcall TForm1::ShowVopros(TVopros v)
{
    int top;
    int i;

    // вопрос
    Label1->Width = ClientWidth - Label1->Left -20;
    Label1->Caption = v.Vopr;
    Label1->AutoSize = true;

    if (v.Img != "") // к вопросу есть иллюстрация
    {
       /* определим высоту области, которую можно
          использовать для вывода иллюстрации */
       int RegHeight =  Button1->Top
           - (Label1->Top + Label1->Height +10) // область вывода вопроса
           - (RadioButton[1]->Height + 10) * v.nOtv;

        Image1->Top = Label1->Top + Label1->Height + 10;
        // загрузим картинку и определим ее размер
        Image1->Visible = false;
        Image1->AutoSize = true;
        Image1->Picture->LoadFromFile(v.Img);
        if (Image1->Height > RegHeight) // картинка не помещается
        {
            Image1->AutoSize = false;
            Image1->Height = RegHeight;
            Image1->Proportional = true;
        }
        Image1->Visible = true;
        // положение полей отсчитываем от иллюстрации
         top = Image1->Top + Image1->Height + 10;
    }
    else // положение полей отсчитываем от вопроса
         top = Label1->Top + Label1->Height + 10;

    // варианты ответа
    for (i = 0; i < v.nOtv; i++)
    {
        RadioButton[i]->Top = top;
        RadioButton[i]->Caption = v.Otv[i];
        RadioButton[i]->Visible = true;
        RadioButton[i]->Checked = false;
        top += 20;
    }
}

// щелчок на радиокнопоке выбора ответа
void __fastcall TForm1::RadioButtonClick(TObject *Sender)
{
    int i =0;
    while (  ! RadioButton[i]->Checked )
        i++;

    otv = i+1;
    // ответ выбран, сделаем доступной кнопку Дальше
    Button1->Enabled = true;
}

// удаляет вопрос с экрана
void __fastcall TForm1::EraseVopros(void)
{
    Image1->Visible = false; // скрыть поле вывода иллюстрации

    // скрыть поля выбора ответа
    for (int i = 0; i <4; i++)
    {
        RadioButton[i]->Visible = false;
        RadioButton[i]->Checked = false;
    }
    Button1->Enabled = false; // сделать недоступной кнопку Дальше
}

// щелчок на кнопке OK/Дальше/OK
void __fastcall TForm1::Button1Click(TObject *Sender)
{
    bool ok; // рез-т чтения из файла очередного вопроса

    switch (Button1->Tag) {
        case 0: // щелчок на кнопке OK в начале работы программы

                // прочитать и вывести первый вопрос
                GetVopros(&Vopros);
                ShowVopros(Vopros);

                Button1->Caption = "Дальше";
                Button1->Enabled = false;
                Button1->Tag = 1;
                break;

        case 1: // щелчок на кнопке Дальше
                if (otv == Vopros.rOtv) // выбран правильный ответ
                    right++;
                EraseVopros();
                ok = GetVopros(&Vopros);
                if ( ok )
                    ShowVopros(Vopros);
                else
                // вопросов больше нет
                {
                    FileClose(f);
                    // вывести результат
                    AnsiString st; // сообщение
                    int i; // номер достигнутого уровня

                    Form1->Caption = "Результат тестирования";
                    st.printf("Правильных ответов: %i\n",right);

                    // определим оценку
                    i = 0; // предположим, что испытуемый ответил на все опросы
                    while (( right < level[i]) && (i < 3))
                        i++;

                    st = st + mes[i];
                    Label1->Caption = st;

                    Button1->Caption = "OK";
                    Button1->Enabled = true;
                    Button1->Tag = 2;
                }
                break;

        case 2: // щелчок на кнопке OK в конце работы программы
                Form1->Close(); // завершить работу программы
    }
}

// Функция GetString читает строку из файла
// значение функции - кол-во прочитанных символов
int GetString(int f, AnsiString *st)
{
    unsigned char buf[300]; // строка (буфер)
    unsigned char *p = buf;  // указатель на строку

    int n;       // кол-во прочитанных байт (значение ф-и FileRead)
    int len = 0; // длина строки

    n = FileRead(f, p, 1);
    while ( n != 0 )
    {
        if ( *p == '\r')
        {
            n = FileRead(f, p, 1); // прочитать '\n'
            break;
        }
        len++;
        p++;
        n = FileRead(f, p, 1);
    }

    *p = '\0';
    if ( len !=0)
        st->printf("%s", buf);
    return len;
}

// читает из файла целое число
int GetInt(int f)
{
    char buf[20];   // строка (буфер)
    char *p = buf;  // указатель на строку

    int n;       // кол-во прочитанных байт (значение ф-и FileRead)
    int a;       // число, прочитанное из файла

    n = FileRead(f, p, 1) ;
    while ( (*p >= '0') && (*p <= '9') && (n > 0) )
    {
        p++;
        n = FileRead(f, p, 1) ;
    }

    if ( *p == '\r')
        n = FileRead(f, p, 1); // прочитать '\n'

    *p = '\0';

    // изображение числа в буфере, преобразуем строку в целое
    sscanf(buf,"%i", &a);
    return a;
}

