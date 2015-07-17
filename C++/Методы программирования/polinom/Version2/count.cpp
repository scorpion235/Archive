#include <stdio.h>
#include <conio.h>
#include <stdlib.h>
#include <math.h>

#define in_file "count.txt"

int main()
{
  FILE *in;
  in=fopen(in_file, "r");
  if (in==NULL)
  {
    printf("Input file not found");
    getch();
    exit(1);
  }
  int i=0;
  float k[10];
  while (!feof(in))
  {
    fscanf(in, "%f", &k[i]);
    i++;
  }
  fclose(in);
  int kol_num=i-3;
  if (kol_num>8)
  {
    printf("Number of elements morre than 8");
    getch();
    exit(1);
  }
  for (i=0;i<=kol_num;i++)
    printf("%0.0f ", k[i]);
  float x=k[kol_num+1];
  printf("\n%f", x);
  float sum=0;
  for (i=0;i<=kol_num;i++)
    sum+=k[i]*pow(x, kol_num-i);
  printf("\n\nResult: %0.10f", sum);
  getch();
}
