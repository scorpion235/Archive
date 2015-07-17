//Сортировка списа
#include "task2.cpp"
int main()
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock();
  List list;
  for (int i=0;i<10000;i++)
    list.AddAfter(list.root,rand()%1000);
  for (int i=0;i<10000;i++)
    list.AddBefore(list.root,rand()%1000);
  list.AddBefore(list.root->next,45);
  list.AddBefore(list.root->next->next->prev,34);
  //cout <<"List:\n";
  //list.Show();
  cout <<"\nSorting list...\n";
  list.Sort();
  //list.Show();
  cout <<"Count: "<<list.Count()<<endl;
  end=clock();
  //время работы программы
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nThe time of program work: %0.5f sec", cpu_time_used);
  cin.get();
  return 0;
}
