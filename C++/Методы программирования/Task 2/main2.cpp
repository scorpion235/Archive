//�������������� ������
#include "task2.cpp"
int main()
{
  clock_t start, // ������ ������ ���������
          end;   // ���������� ������ ���������
  start=clock();
  List pec;
  for (int i=0;i<1000;i++)
	pec.AddAfter(pec.last,i);
  cout <<"Before pecar:\n";
  pec.Show();
  cout <<"\nAfter pecar:\n";
  pec.Pecar();
  pec.Show();
  cout <<"Count: "<<pec.Count()<<endl;
  end=clock();
  //����� ������ ���������
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nThe time of program work: %0.5f sec", cpu_time_used);
  cin.get();
  return 0;
}
