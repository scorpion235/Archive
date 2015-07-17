// пример консольного приложения

#pragma hdrstop

#include <stdio.h>
#include <conio.h>   // для доступа к getch()
#include <stdlib.h>  // для доступа к srand(), rand()
#include <time.h>    // для доступа к time_t и time()

// #include "rus.h"

char* rus(char* st);

#pragma argsused

int main(int argc, char* argv[])
{
    int comp,   // число, "задуманное" компьютером
            igrok,  // вариант игрока
            n=0;    // число попыток

        // ГСЧ - генератор случайных чисел
        time_t t;  // текущее время (для инициализации ГСЧ)

        srand( (unsigned)time(&t)); // инициализация ГСЧ
        comp = rand() % 10 + 1 ;
        puts( rus("\nКомпьютер \"задумал\" число от 1 до 10."));
        puts( rus("Вы должны его угадать за три попытки.") );
        do
        {
                printf("->");
                scanf("%i", &igrok);
                n++;
        }
        while ( igrok != comp && n < 3);

        if (igrok == comp)
                printf( rus("ВЫ ВЫИГРАЛИ!") );
        else
                {
                        puts( rus("Вы проиграли."));
                        printf( rus("Компьютер \"задумал\" число %d"), comp);
                }
        printf( rus("\nДля завершения нажмите любую клавишу..."));
        getch();

    return 0;
}

/*
    Функция rus может используется для вывода сообщений
	на русском языке в консольных программах.
	(c) Культин Н.Б., 2001

	Пример использования:
                printf( rus("Скорость: %3.2f км/час"), v);
		printf( rus("У лукоморья дуб зеленый\n") );
*/

char* rus(char* st)
{
        unsigned char* p = st;  // при объявлении символов как char русские буквы
                                 // кодируются отрицательными числами
	while ( *p )
	{
	    if (*p >= 192) // здесь русская буква
                 if (*p <= 239)  //  А,Б, ... Я,а,б, ... п

                       *p -= 64;
                 else // р ...я
                       *p -= 16;

            p++;
        }
	return st;
}

