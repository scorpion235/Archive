//Слияние списков
#include "task2.cpp"
int main()
{
  clock_t start, // начало работы программы
          end;   // завершение работы программы
  start=clock();
  List list1,list2,list_res;
  for (int i=0;i<10;i++)
    list1.AddAfter(list1.root,rand()%1000);
  for (int i=0;i<10;i++)
    list1.AddBefore(list1.root,rand()%1000);
  list1.AddBefore(list1.root->next,45);
  list1.AddBefore(list1.root->next->next->prev,34);
  list1.Sort();
  cout <<"List1:\n";
  list1.Show();
  cout <<"Count: "<<list1.Count()<<endl;
  for (int i=0;i<10;i++)
    list2.AddAfter(list2.root,rand()%1000);
  for (int i=0;i<10;i++)
    list2.AddBefore(list2.root,rand()%1000);
  list2.Sort();
  cout <<"\nList2:\n";
  list2.Show();
  cout <<"Count: "<<list2.Count()<<endl;
  cout <<"\nConcat list1, list2:\n";
  list_res=Concat(list1,list2);
  list_res.Show();
  cout <<"Count: "<<list1.Count()+list2.Count()<<endl;
  end=clock();
  //время работы программы
  double cpu_time_used=((double)(end-start))/CLOCKS_PER_SEC;
  printf("\nThe time of program work: %0.5f sec", cpu_time_used);
  cin.get();
  return 0;
}
