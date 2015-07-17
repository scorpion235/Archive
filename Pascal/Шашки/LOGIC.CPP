#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <graphics.h>
#include "struct.h"
#include "logic.h"
#include "screen.h"

void start(){
	int x,y;
	char c;
	A = new int *[8];for (int i = 0; i<8; i++) A[i] = new int [8];
		for (i = 0; i<8; i++)
			for (int j = 0; j<8; j++)A[i][j] = 1;
	outtextxy(50,425,"Welcom! White - 1 Black - 2 ?(ESC to exit)");
	c = getch();
	if( ESC == c ){
		closegraph();
		exit( 1 );
	}
	gcolor = (c == '1') ? 15: 2;
	ccolor = (c == '1') ? 2 :15;
	cleardevice();
	rastanovka(ccolor,gcolor,A);
	x = schet(A,ccolor);
	y = schet(A,gcolor);
	do {
		if (gcolor == 15) {hodgamer(A,gcolor);hodcomp(A,ccolor);}
		else {hodcomp(A,ccolor);hodgamer(A,gcolor);}
		x = schet(A,ccolor);
		y = schet(A,gcolor);
	}
	while (x != 0 && y != 0);
	return;
}
void end(){
   if (schet(A,ccolor) == 0) {
	desk(A);
	setcolor(15);
	settextstyle(15,HORIZ_DIR,2);
	outtextxy(50,180,"Oops,I Win...");
	getch();
	}
   if (schet(A,gcolor) == 0) {
	desk(A);
	setcolor(15);
	settextstyle(15,HORIZ_DIR,2);
	outtextxy(50,180,"Congratulation You WIN !!!");
	getch();
	}
   closegraph();
}
void rastanovka(int ccolor,int gcolor,int **A){
   int x = 1,y = 7,i,j;
   for (i = 0; i<=12; i++){
	j = i % 4;
	if (i == 5) { --y;x = 0;}
	if (i == 9) { --y;x = 1;}
	A[y][x+j*2] = gcolor;
	}
   x = 0;y = 0;
   for (i = 0; i<=12; i++){
	j = i % 4;
	if (i == 5) { ++y;x = 1;}
	if (i == 9) { ++y;x = 0;}
	A[y][x+j*2] = ccolor;
	}
}
int schet(int **A,int color){
	int rez = 0;
	for (int i = 0; i<8; i++)
	    for (int j = 0; j<8; j++)
		if (A[i][j]==color || A[i][j] == - color) rez++;
	return (rez);
}
void hodgamer(int **A,int color){
	int i,j,c = (color == 15) ? 2: 15;
	if (schet(A,color) == 0) return;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if ((A[i][j] == color || A[i][j] == - color) &&
			(((A[i-1][j+1] == c || A[i-1][j+1] == -c) && A[i-2][j+2] == 1)  ||
			 ((A[i+1][j+1] == c || A[i+1][j+1] == -c) && A[i+2][j+2] == 1)  ||
			 ((A[i-1][j-1] == c || A[i-1][j-1] == -c) && A[i-2][j-2] == 1)  ||
			 ((A[i+1][j-1] == c || A[i+1][j-1] == -c) && A[i+2][j-2] == 1)))
				if (srub(A,color)) return;
	if (hod(A,color)) return;
}
void oprXY(char X,char Y,int **j,int **i){
   switch (X){
	case 'a': **j=0;break;
	case 'b': **j=1;break;
	case 'c': **j=2;break;
	case 'd': **j=3;break;
	case 'e': **j=4;break;
	case 'f': **j=5;break;
	case 'g': **j=6;break;
	case 'h': **j=7;break;
   }
   switch (Y){
	case '1': **i=7;break;
	case '2': **i=6;break;
	case '3': **i=5;break;
	case '4': **i=4;break;
	case '5': **i=3;break;
	case '6': **i=2;break;
	case '7': **i=1;break;
	case '8': **i=0;break;
   }

}
int  hod(int **A,int color){
	int t,str,stl,i,j;
	desk(A);
	setcolor(15);
	settextstyle(15,HORIZ_DIR,1);
	outtextxy(50,425,"Vash hod (Example a3 b4 (Smol leter)):");
	outtextxy(50,150,"Gamer:");
	input(&str,&stl,&i,&j,A,color);
	if  (A[str][stl] > 0 && ((j == stl-1&&i == str-1) ||
	     (j == stl+1 && i == str-1) && A[i][j] == 1)) {
		t = A[str][stl];
		A[str][stl] = 1;
		A[i][j] = t;
		if (i == 0) A[i][j] = - color;
		return 1;
		}
	if  (A[str][stl] < 0 && (A[i][j] == 1 &&
	    (j == stl-1&&i == str-1) ||
	    (j == stl+1 && i == str-1) ||
	    (j == stl-1 && i == str+1) ||
	    (j == stl+1 && i == str+1))) {
		t = A[str][stl];
		A[str][stl] = 1;
		A[i][j] = t;
		return 1;
		}
	else {outtextxy(50,200,"An correct way!");getche();hod(A,color);}
	return 1;
}
int  srub(int**A,int color){
	int t,c = (color == 15) ? 2 : 15,str,stl,i,j;
	desk(A);
	setcolor(15);
	settextstyle(15,HORIZ_DIR,1);
	outtextxy(50,425,"Vash hod (Example a3 b4 (Smol leter)):");
	outtextxy(50,150,"Gamer:");
	input(&str,&stl,&i,&j,A,color);
	if (((A[str-1][stl+1] == c || A[str-1][stl+1] == -c) &&
		 A[str-2][stl+2] == 1 && i == str-2 && j == stl+2) ||
	    ((A[str+1][stl+1] == c || A[str+1][stl+1] == -c) &&
	      A[str+2][stl+2] == 1 && i == str+2 && j == stl+2) ||
	    ((A[str-1][stl-1] == c || A[str-1][stl-1] == -c) &&
	      A[str-2][stl-2] == 1 && i == str-2 && j == stl-2) ||
	    ((A[str+1][stl-1] == c || A[str+1][stl-1] == -c) &&
	      A[str+2][stl-2] == 1 && i == str+2 && j == stl-2))
		{
		t = A[str][stl];
		A[str][stl] = 1;
		A[i][j] = t;
		if ((A[str-1][stl-1] == c || A[str-1][stl-1] == -c) &&
		    (i == str-2 && j == stl-2))  A[str-1][stl-1] = 1;
		if ((A[str-1][stl+1] == c || A[str-1][stl+1] == -c) &&
		    (i == str-2 && j == stl+2))  A[str-1][stl+1] = 1;
		if ((A[str+1][stl-1] == c || A[str+1][stl-1] == -c) &&
		    (i == str+2 && j == stl-2))  A[str+1][stl-1] = 1;
		if ((A[str+1][stl+1] == c || A[str+1][stl+1] == -c) &&
		    (i == str+2 && j == stl+2))  A[str+1][stl+1] = 1;
		if (i == 0 && A[i][j] > 0) A[i][j] = - color;
		if (((A[i-1][j+1] == c || A[i-1][j+1] == -c) && A[i-2][j+2] == 1) ||
		    ((A[i+1][j+1] == c || A[i+1][j+1] == -c) && A[i+2][j+2] == 1) ||
		    ((A[i-1][j-1] == c || A[i-1][j-1] == -c) && A[i-2][j-2] == 1) ||
		    ((A[i+1][j-1] == c || A[i+1][j-1] == -c) && A[i+2][j-2] == 1))
				srub(A,color);
		    else return 1;
		}
	else {outtextxy(50,200,"An correct way!");getche();srub(A,color);}
	return 1;
}
void hodcomp(int **A,int color){
	int i,j;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if (A[i][j] == color || A[i][j] == -color)if (var1(i,j,A,color)) return;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if (A[i][j] == color)if (var2(i,j,A,color)) return;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if (A[i][j] == -color)if (var3(i,j,A,color)) return;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if (A[i][j] == -color)if (def1(i,j,A,color)) return;
	for (i = 0; i<8; i++)
		for (j = 0; j<8; j++)
			if (A[i][j] == color)if ( def(i,j,A,color)) return;
	outtextxy(50,180,"Ok, You Win!");
     getch();
     closegraph();
	exit(1);
}
int  var1(int i,int j,int **A,int color){
	int gc = (color == 15) ? 2:15,hod = 0;
	if (color == 0) color = 2;
	if ((A[i+1][j-1] == gc || A[i+1][j-1] == -gc) && A[i+2][j-2] == 1){
		if ((i+2 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j-1] = 1;
		A[i+2][j-2] = color;
		hod = 1;
          if (color < 0) color = -color;
		var1(i+2,j-2,A,color);
          return hod;
		}
	if ((A[i+1][j+1] == gc || A[i+1][j+1] == -gc) && A[i+2][j+2] == 1){
		if ((i+2 == 7 && A[i][j] > 0) || A[i][j] <0) color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = 1;
		A[i+2][j+2] = color;
		hod = 1;
          if (color < 0) color = -color;
		var1(i+2,j+2,A,color);
          return hod;
		}
	if ((A[i-1][j-1] == gc || A[i-1][j-1] == -gc) &&  A[i-2][j-2] == 1){
		if (A[i][j] < 0) color = -color;
		A[i][j] = 1;
		A[i-1][j-1] = 1;
		A[i-2][j-2] = color;
		hod = 1;
          if (color < 0) color = -color;
		var1(i-2,j-2,A,color);
          return hod;
		}
	if ((A[i-1][j+1] == gc || A[i-1][j+1] == -gc) && A[i-2][j+2] == 1){
		if (A[i][j] < 0) color = -color;
		A[i][j] = 1;
		A[i-1][j+1] = 1;
		A[i-2][j+2] = color;
		hod = 1;
		if (color < 0) color = -color;
		var1(i-2,j+2,A,color);
          return hod;
		}
	return hod;
}
int  var2(int i,int j,int **A,int color){
	int gc = (color == 15) ? 2:15;
	if (A[i+1][j-1] == 1 && (A[i+2][j-2] == gc || A[i+2][j-2] == -gc)){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i+2][j+2] == gc || A[i+2][j+2] == -gc)){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i+1][j-1] == 1 && (A[i+2][j] == gc ||
	    A[i+2][j] == -gc) && A[i][j-2] == 1){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i+2][j] == gc ||
	    A[i+2][j] == -gc) && A[i][j+2] == 1){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i][j+2] == gc ||
	    A[i][j+2] == -gc)){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i+1][j-1] == 1 && (A[i][j-2] == gc ||
	    A[i][j-2] == -gc)){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] <0)  color = -color;
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	return 0;
}
int   def(int i,int j,int **A,int color){
	if (A[i+1][j-1] == 1 && A[i+1][j+1] != 1){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] < 0)  color = -color;
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && A[i+1][j-1] != 1){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] < 0)  color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}

	if (A[i+1][j-1] == 1 && A[i+1][j+1] == 1){
		if ((i+1 == 7 && A[i][j] > 0) || A[i][j] < 0)  color = -color;
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	return 0;
}
int  var3(int i,int j,int **A,int color){
	int gc = (color == 15) ? 2:15;
	color = - color;
	if (A[i+1][j-1] == 1 && (A[i+2][j-2] == gc || A[i+2][j-2] == -gc)){
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i+2][j+2] == gc || A[i+2][j+2] == -gc)){
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i+1][j-1] == 1 && (A[i+2][j] == gc ||
	    A[i+2][j] == -gc) && A[i][j-2] == 1){
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i+2][j] == gc ||
	    A[i+2][j] == -gc) && A[i][j+2] == 1){
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i-1][j-1] == 1 && (A[i-2][j-2] == gc || A[i-2][j-2] == -gc)){
		A[i][j] = 1;
		A[i-1][j-1] = color;
		return 1;
		}
	if (A[i-1][j+1] == 1 && (A[i-2][j+2] == gc || A[i-2][j+2] == -gc)){
		A[i][j] = 1;
		A[i-1][j+1] = color;
		return 1;
		}
	if (A[i-1][j-1] == 1 && (A[i-2][j] == gc ||
	    A[i-2][j] == -gc) && A[i][j-2] == 1){
		A[i][j] = 1;
		A[i-1][j-1] = color;
		return 1;
		}
	if (A[i-1][j+1] == 1 && (A[i-2][j] == gc ||
	    A[i-2][j] == -gc) && A[i][j+2] == 1){
		A[i][j] = 1;
		A[i-1][j+1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && (A[i][j+2] == gc ||
	    A[i][j+2] == -gc)){
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	if (A[i+1][j-1] == 1 && (A[i][j-2] == gc ||
	    A[i][j-2] == -gc)){
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i-1][j+1] == 1 && (A[i][j+2] == gc ||
	    A[i][j+2] == -gc)){
		A[i][j] = 1;
		A[i-1][j+1] = color;
		return 1;
		}
	if (A[i-1][j-1] == 1 && (A[i][j-2] == gc ||
	    A[i][j-2] == -gc)){
		A[i][j] = 1;
		A[i-1][j-1] = color;
		return 1;
		}
	return 0;
}
int   def1(int i,int j,int **A,int color){
     if (color == 15) color = -15;
	if (color == 2) color = -2;
	if (A[i-1][j-1] == 1 && A[i-1][j+1] != 1){
		A[i][j] = 1;
		A[i-1][j-1] = color;
		return 1;
		}
	if (A[i-1][j+1] == 1 && A[i-1][j-1] != 1){
		A[i][j] = 1;
		A[i-1][j+1] = color;
		return 1;
		}
	if (A[i-1][j-1] == 1 && A[i-1][j+1] == 1){
		A[i][j] = 1;
		A[i-1][j-1] = color;
		return 1;
		}
	if (A[i+1][j-1] == 1 && A[i+1][j+1] != 1){
		A[i][j] = 1;
		A[i+1][j-1] = color;
		return 1;
		}
	if (A[i+1][j+1] == 1 && A[i+1][j-1] != 1){
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}

	if (A[i+1][j-1] == 1 && A[i+1][j+1] == 1){
		A[i][j] = 1;
		A[i+1][j+1] = color;
		return 1;
		}
	return 0;
}
