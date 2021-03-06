// ������ ����������� ����������

#pragma hdrstop

#include <stdio.h>
#include <conio.h>   // ��� ������� � getch()
#include <stdlib.h>  // ��� ������� � srand(), rand()
#include <time.h>    // ��� ������� � time_t � time()

// #include "rus.h"

char* rus(char* st);

#pragma argsused

int main(int argc, char* argv[])
{
    int comp,   // �����, "����������" �����������
            igrok,  // ������� ������
            n=0;    // ����� �������

        // ��� - ��������� ��������� �����
        time_t t;  // ������� ����� (��� ������������� ���)

        srand( (unsigned)time(&t)); // ������������� ���
        comp = rand() % 10 + 1 ;
        puts( rus("\n��������� \"�������\" ����� �� 1 �� 10."));
        puts( rus("�� ������ ��� ������� �� ��� �������.") );
        do
        {
                printf("->");
                scanf("%i", &igrok);
                n++;
        }
        while ( igrok != comp && n < 3);

        if (igrok == comp)
                printf( rus("�� ��������!") );
        else
                {
                        puts( rus("�� ���������."));
                        printf( rus("��������� \"�������\" ����� %d"), comp);
                }
        printf( rus("\n��� ���������� ������� ����� �������..."));
        getch();

    return 0;
}

/*
    ������� rus ����� ������������ ��� ������ ���������
	�� ������� ����� � ���������� ����������.
	(c) ������� �.�., 2001

	������ �������������:
                printf( rus("��������: %3.2f ��/���"), v);
		printf( rus("� ��������� ��� �������\n") );
*/

char* rus(char* st)
{
        unsigned char* p = st;  // ��� ���������� �������� ��� char ������� �����
                                 // ���������� �������������� �������
	while ( *p )
	{
	    if (*p >= 192) // ����� ������� �����
                 if (*p <= 239)  //  �,�, ... �,�,�, ... �

                       *p -= 64;
                 else // � ...�
                       *p -= 16;

            p++;
        }
	return st;
}

