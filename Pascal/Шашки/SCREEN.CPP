#include <stdarg.h>
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <graphics.h>
#include "screen.h"
#include "logic.h"

int    GraphDriver;		/* The Graphics device driver		     */
int    GraphMode;		/* The Graphics mode value	     	*/
double AspectRatio;		/* Aspect ratio of a pixel on the screen*/
int    MaxX, MaxY;		/* The maximum resolution of the screen */
int    MaxColors;		/* The maximum # of colors available	*/
int    ErrorCode;		/* Reports any graphics errors		*/
struct palettetype palette;		/* Used to read palette info	*/

void Initialize(void){
  int xasp, yasp;			/* Used to read the aspect ratio*/

  GraphDriver = DETECT; 		/* Request auto-detection	*/
  initgraph( &GraphDriver, &GraphMode, "" );
  ErrorCode = graphresult();		/* Read result of initialization*/
  if( ErrorCode != grOk ){		/* Error occured during init	*/
    printf(" Graphics System Error: %s\n", grapherrormsg( ErrorCode ) );
    exit( 1 );
  }

  getpalette( &palette );		/* Read the palette from board	*/
  MaxColors = getmaxcolor() + 1;	/* Read maximum number of colors*/

  MaxX = getmaxx();
  MaxY = getmaxy();			/* Read size of screen		*/

  getaspectratio( &xasp, &yasp );	/* read the hardware aspect	*/
  AspectRatio = (double)xasp / (double)yasp; /* Get correction factor	*/
}
void podpis (void){
   int i=405,j=70,t=280,k=625;
   outtextxy(315,i,"A");outtextxy(t,95 ,"8");
   outtextxy(315,j,"A");outtextxy(k,95 ,"8");
   outtextxy(355,i,"B");outtextxy(t,135,"7");
   outtextxy(355,j,"B");outtextxy(k,135,"7");
   outtextxy(395,i,"C");outtextxy(t,175,"6");
   outtextxy(395,j,"C");outtextxy(k,175,"6");
   outtextxy(435,i,"D");outtextxy(t,215,"5");
   outtextxy(435,j,"D");outtextxy(k,215,"5");
   outtextxy(475,i,"E");outtextxy(t,255,"4");
   outtextxy(475,j,"E");outtextxy(k,255,"4");
   outtextxy(515,i,"F");outtextxy(t,295,"3");
   outtextxy(515,j,"F");outtextxy(k,295,"3");
   outtextxy(555,i,"G");outtextxy(t,335,"2");
   outtextxy(555,j,"G");outtextxy(k,335,"2");
   outtextxy(595,i,"H");outtextxy(t,375,"1");
   outtextxy(595,j,"H");outtextxy(k,375,"1");
}
void desk (int **A){
   int i,j,k,t;
   cleardevice();
   setfillstyle(SOLID_FILL,6);
   for (i=0;i<64;i++){
	t=i;
	j=(i/8);
	k=i%8;
	if ((j+1)%2==1) t++;
	if ((t+1)%2==0) setfillstyle(SOLID_FILL,14);
		   else setfillstyle(SOLID_FILL, 6);
	bar((300+k*40),(400-(j+1)*40),(300+(k+1)*40),(400-j*40));
   }
   rectangle(300,80,620,400);
   podpis();
   for (i = 0; i<8;i++)
	  for (j = 0; j<8; j++){
	  if (A[i][j] != 1) unit(320+j*40,100+i*40,A[i][j]);
	  if (A[i][j] < 0) unit1(320+j*40,100+i*40,A[i][j]);
	  }
}
void unit1(int x,int y,int color){
   if (color == -2) color = 0;
   setfillstyle(SOLID_FILL,-color);
   fillellipse(x,y,15,15);
   if (color==0) setcolor(15);
	  else setcolor( 0);
   circle(x,y,15);
   circle(x,y,10);
   if (color == 0) setfillstyle(SOLID_FILL,15);
	else setfillstyle(SOLID_FILL,0);
   fillellipse(x,y,7,7);
}
void unit(int x,int y,int color){
   if (color == 2) color = 0;
   setfillstyle(SOLID_FILL,color);
   fillellipse(x,y,15,15);
   if (color==0) setcolor(15);
	  else setcolor( 0);
   circle(x,y,15);
   circle(x,y,10);
   circle(x,y,7);
}
void input(int *str,int *stl,int *i,int *j,int **A,int color){
	int x = 98,y = 150;
	char x1,y1,x2,y2;
	desk(A);
	setcolor(15);
	settextstyle(15,HORIZ_DIR,1);
	outtextxy(50,425,"Vash hod (Example a3 b4 (Smol leter)):");
	outtextxy(50,150,"Gamer:");
	x1 = getch();
     if (x1 == 0x1b) exit(0);
	gprintf(&x,&y,"%c",x1);
	y1 = getch();
     if (y1 == 0x1b) exit(0);
	gprintf(&x,&y,"%c",y1);
	gprintf(&x,&y,"-");
	x2 = getch();
     if (x2 == 0x1b) exit(0);
	gprintf(&x,&y,"%c",x2);
	y2 = getch();
     if (y2 == 0x1b) exit(0);
	gprintf(&x,&y,"%c",y2);
	oprXY(x1,y1,&stl,&str);
	oprXY(x2,y2,&j,&i);
	if ( A[*str][*stl] != color && A[*str][*stl] != -color)
		{outtextxy(50,200,"No figer!");getch();
		input(str,stl,i,j,A,color);}
}
int gprintf( int *xloc, int *yloc, char *fmt, ... ){
  va_list  argptr;			/* Argument list pointer	*/
  char str[140];			/* Buffer to build sting into	*/
  int cnt;				/* Result of SPRINTF for return */

  va_start( argptr, fmt );		/* Initialize va_ functions	*/

  cnt = vsprintf( str, fmt, argptr );	/* prints string to buffer	*/
  outtextxy( *xloc, *yloc, str );	/* Send string in graphics mode */
  *xloc += textheight( "H" ) + 2;       /* Advance to next line         */

  va_end( argptr );			/* Close va_ functions		*/

  return( cnt );			/* Return the conversion count	*/

}

