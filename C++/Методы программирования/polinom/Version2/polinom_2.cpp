/********************************************
 * ��������� ������� ��� ����� ���������    *
 * ������� <= "max_power" � ��������������  *
 * -2, -1, 1, 2 (� ������ ���������)        *
 ********************************************
 * �����: ������� ������ ���������� MK-301  *
 * Autor: Dyugurov Sergey                   *
 * ����� ����������: Dev-Cpp v. 4.9.9.0     *
 * ����: 1.05.05                            *
 ********************************************/ 
 
#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <time.h>

#define out_file "output.txt"
#define max_power 8  //������� ��������
#define exact 0.001  //��������

int kol_radical; //���������� ������ � ������ ��������
//------------------------------------------------------------------------------
class Polinom
{
  public:
    //���������� � �������
    float pow(float a, int b);
    //�������� ���������� �������� "max_power" � "exact"
    int Testing();
    //���������� ��������� ����� "radical"
    int SearchingOrders(FILE *out, float radical, int k[max_power], int power);
    //����� ������ �������� � ��������� "exact"
    int SearchingRadicals(FILE *out, float exactness, float lim1, float lim2, int k[max_power], int power);
    //����� �������� � ��������� ����
    int PrintPolinom(FILE *out, int k[max_power], int power);
    //�������, ������������ ��� ���������
    int BasicFunction();
};  
//------------------------------------------------------------------------------
//���������� � �������
//a - ���������
//b - ����������
float Polinom::pow(float a, int b)
{
  //������������� �������
  if (b<0)
  {
    printf("\nFatal error: Power less then 0");
    getch();
    exit(1);
  }
  //���������� � 0 �������
  if (b==0)
    return 1;
  float temp=1;
  for (int i=1;i<=b;i++)
    temp*=a;
  return temp;  
}   
//------------------------------------------------------------------------------ 
//�������� ���������� �������� "max_power" � "exact"
int Polinom::Testing()
{
  //������� �������� <1 ��� >8
  if ((max_power<1) | (max_power>8))
  {
    printf("The power of polynomial less then 1 or more then 8\nPress any key to exit");
    getch();
    exit(1);
  }
  //�������� <0.0001 ��� >0.001
  if ((exact<0.0001) | (exact>0.001))
  {
    printf("The exactness less then 0.0000001 or more then 0.01\nPress any key to exit");
    getch();
    exit(1);
  }
  return 0;
}
//------------------------------------------------------------------------------
//���������� ��������� ����� "radical"
//"radical" - ������ �������� � ��������� "exact"
//"k[mak_power]" - ������������ ��������
int Polinom::SearchingOrders(FILE *out, float radical, int k[max_power], int power)
{
  int temp[power+1]; //������ ������������� �������� ��� ���������� ����������
  for (int i=0;i<=power;i++)
    temp[i]=k[i];   //���������� temp[i]=k[i]
  int derivative=1, //����� �����������
      order=1;      //��������� �����
  float sum1=0, //����� � ����� ����� �������� ��� ���������� �����������,
                //����� ������ ����� ��� "radical-exact/2"
        sum2=0; //����� � ����� ����� �������� ��� ���������� �����������,
                //����� ������ ����� ��� "radical+exact/2"
  //���� ����� ����� ��������� �����������
  for (int i=0;i<=power-2;i++)
  { 
    //���������� ����������� �� ������� ����������
    for (int j=0;j<=power-derivative;j++)
    {
      if (power==0)
        temp[j]=power-j-1;
      else
        temp[j]*=power-j-derivative+1;
      if (power-derivative-j==0)
      {
        sum1+=temp[j];
        sum2+=temp[j];
      }
      else
      {
        //����������� ����� ����� ����� �����������
        sum1+=temp[j]*(pow(radical-exact/2, power-j-1));
        sum2+=temp[j]*(pow(radical+exact/2, power-j-1));
      }
    }   
    //����������� ����� ����� �������� ����� 0 � ��������� "exact"
    if ( ((sum1<=0) & (sum2>=0)) | ((sum1>=0) & (sum2<=0)) )
      order++;    //�������������� ���������
    else //�������� ����������� �������� 0
      break;
    derivative++; //�������������� ����� �����������
  }
  //������� ��������� � ��������� ����
  fprintf(out, ", ���������: %i", order);
}    
//------------------------------------------------------------------------------
//����� ������ �������� � ��������� "exact" (� ������� ��������)
//"exactness" - ������������� �������� (exactness<=exact)
//"lim1" � "lim2" - ������� ������ ������
//"k[mak_power]" - ������������ ��������
//"power" - ������� ��������
int Polinom::SearchingRadicals(FILE *out, float exactness, float lim1, float lim2, int k[max_power], int power)
{
  float radical=lim1,
        sum,  //����� � ����� ����� �������� ��� ���������� ������,
              //����� ������ �������� ����� ��� "radical"
        sum1, //            --//--       "radical-exactness/2"
        sum2, //            --//--       "radical+exactness/2"
        right=0; //������������� �������� ������ ������� ������
  for (int i=0;i<=power;i++)
    right+=k[i]*pow(radical-exactness/2, power-i);    
  while (radical<=lim2)
  {
    sum=sum1=sum2=0;
    for (int i=0;i<=power;i++)
    {
      sum+=k[i]*pow(radical, power-i);  
      sum2+=k[i]*pow(radical+exactness/2, power-i);
    } 
    sum1=right;
    right=sum2;
    if (sum==0) 
    {
      if ((exact>=0.01) & (exact<=0.99))
          fprintf(out, "\n������: %0.2f", radical);
        else
          if ((exact>=0.001) & (exact<=0.999))
            fprintf(out, "\n������: %0.3f", radical);
          else
            if ((exact>=0.0001) & (exact<=0.9999))
              fprintf(out, "\n������: %0.4f", radical);
      SearchingOrders(out, radical, k, power);
      kol_radical++;
    }   
    else
      //����� � ����� ����� �������� ����� 0 � ��������� "exact"
      if ( ((sum1<0) & (sum2>0) & (exactness<=exact)) | ((sum1>=0) & (sum2<=0) & (exactness<=exact)) )
      { 
        if ((exact>=0.01) & (exact<=0.99))
          fprintf(out, "\n������: %0.2f", radical);
        else
          if ((exact>=0.001) & (exact<=0.999))
            fprintf(out, "\n������: %0.3f", radical);
          else
            if ((exact>=0.0001) & (exact<=0.9999))
              fprintf(out, "\n������: %0.4f", radical); 
        SearchingOrders(out, radical, k, power);
        kol_radical++;
      }  
      else
        if ( ((sum1<0) & (sum2>0)) | ((sum1>0) & (sum2<0)) )  
          //����������� ����� "SearchingRadicals" ��� ��������� �������� �����
          SearchingRadicals(out, 0.1*exactness, radical-exactness/2, radical+exactness/2, k, power);    
    radical+=exactness;
  }    
}
//------------------------------------------------------------------------------
//����� �������� � ��������� ����
//"k[mak_power]" - ������������ ��������
//"power" - ������� ��������
int Polinom::PrintPolinom(FILE *out, int k[max_power], int power)
{
  for (int i=0;i<=power;i++)
  switch (k[i])
  {
    case 2:
      if (power-i==0)
        fprintf(out, "+2");
      else
        if ((power-i==1) & (power==1))
          fprintf(out, "2*x");
        else
          if ((power-i==1))
            fprintf(out, "+2*x");
          else //power-i>1
            if (i==0)
              fprintf(out, "2*x^%i", power-i); 
            else
              fprintf(out, "+2*x^%i", power-i);
      break;
    case 1:
      if (power-i==0)
        fprintf(out, "+1");
      else
        if ((power-i==1) & (power==1))
          fprintf(out, "x");
        else
          if (power-i==1)
            fprintf(out, "+x");
          else //power-i>1
            if (i==0)
              fprintf(out, "x^%i", power-i); 
            else
              fprintf(out, "+x^%i", power-i);
      break;
    case -1:
      if (power-i==0)
        fprintf(out, "-1");
      else
        if (power-i==1)
          fprintf(out, "-x");
        else //power-i>1
          fprintf(out, "-x^%i", power-i);
      break;
    case -2:
      if (power-i==0)
        fprintf(out, "-2");
      else
        if (power-i==1)
          fprintf(out, "-2*x");
        else //power-i>1
          fprintf(out, "-2*x^%i", power-i);
      break;
  }
  fprintf(out, "=0");  
  return 0;  
}
//------------------------------------------------------------------------------
//�������, ������������ ��� ���������
int Polinom::BasicFunction()
{
  FILE *out;
  //�������� ����� "out_file" �� ������
  out=fopen(out_file, "w");
  if (out==NULL)
  {
    printf("File out_file not found\nPress any key");
    getch();
    return -1;
  }
  int i, j; //��������
  float pers=1; //���������� ������, ����� ������� ���������
                //����� ������������ ���������
  long kol_polinom=0; //����� ���������
  float kol=0;        //����� ������������ ���������
  for (i=max_power;i>0;i--)
    kol+=pow(4, i+1);
  printf("Number of complete polinomyals <= %i power:\n", max_power);
  float start=clock(), 
    end, time_work;
  //���������� ����� ������ ��� ��������� �� 8 �� 1 �������
  for (int power=max_power;power>=1;power--)
  {
    fprintf(out, "                                             ");
    fprintf(out, "                            power=%i\n", power);
    int k[power+1]; //������������ ���������
    for (i=0;i<=power;i++)
      k[i]=2;
    //���� �� ��������� ��� ���������� ������������� 
    while (k[0]>-3)
    {
      kol_polinom++; //�������������� ����� ���������
      //����� ����� ������������ ��������� �� �����
      end=clock();
      time_work=((float)(end-start))/CLOCKS_PER_SEC; 
      if (time_work>pers)
      {
        for (i=0;i<15;i++)
          printf("\b");
        printf("%i (%0.0f)", kol_polinom, kol);
        start=clock();
      }
      //����� �������� � ����������� �������������� � ��������� ����
      PrintPolinom(out, k, power); 
      kol_radical=0;
      //����� ������
      SearchingRadicals(out, 0.5, -3, 3, k, power); 
      if (kol_radical>power)
      {
        printf("\nFatal error: Number of radicals more than power of polinom");
        getch();
        exit(1);
      }
      //�� ������� ������
      if (kol_radical==0)
        fprintf(out, "\n�������������� ������ ���");
      fprintf(out, "\n-----------------------------------------");
        fprintf(out, "---------------------------------------\n");
      if (k[power]==-2) //��������� ����������� ����� -2
      {
        //����� ������������, ������� ����� ����������������
        //(������ ������� ������������, �� ������� -2)
        for (i=power-1;i>=0;i--)
          if (k[i]!=-2)
          {
            if (k[i]==1)
              k[i]=-1;
            else //k[i]==2 ��� k[i]==-1
              k[i]--;
            break;
          }
          else
            if (i!=0)
              k[i]=2;
            else
              if (k[i]==1)
                k[i]=-1;
              else //k[i]==2 ��� k[i]==-1
                k[i]--;
        k[power]=2;
      }
      else 
        if (k[power]==1)
          k[power]=-1;
        else //k[power]==2 ��� k[power]==-1       
          k[power]--;
    }
  }
  for (int i=0;i<15;i++)
    printf("\b");
  //����� �� ����� �������������� ����� ������������ ���������
  printf("%i (%0.0f)", kol_polinom, kol);
  fclose(out); 
  return 0; 
}    
//------------------------------------------------------------------------------
//�������� �������
int main()
{
  float start=clock(); //������ ������ ���������
  Polinom polinom;
  polinom.Testing(); //"������������" "max_power" � "exact"
  polinom.BasicFunction();
  //printf("%f", polinom.pow(2,3));
  float end=clock(); //���������� ������ ���������
  //����� ������ ���������
  float time_work=((float)(end-start))/CLOCKS_PER_SEC; 
  printf("\n\nThe time of program work: %0.3f sec (%0.5f min)", time_work, time_work/60);
  printf("\nOpen \"output.txt\"");
  getch();
  return 0;
}    
