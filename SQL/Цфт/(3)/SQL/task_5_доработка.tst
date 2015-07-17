PL/SQL Developer Test script 3.0
47
declare
  dateb           date;
  datee           date;
  start_weekb     date;
  start_weeke     date;
  holiday_count   integer;
  week_days_count integer;
  days_count      integer;
begin 
  --минимальная дата
  dateb := least(:date1, :date2);
  
  --максимальная дата
  datee := greatest(:date1, :date2);
  
  --число дней между двумя датами
  days_count := trunc(datee - dateb) + 1;
  
  --определяем начало недели для минимальной даты
  start_weekb := trunc(dateb, 'D');
  
  --определяем начало следующей недели для максимальной даты
  start_weeke := trunc(datee, 'D') + 7;

  --число дней между двумя понедельниками (всегда кратно 7)
  week_days_count := trunc(start_weeke - start_weekb);
  
  --количество выходных дней между двумя понедельниками
  holiday_count   := 2 * (week_days_count / 7);
    
  --минимальная дата является воскресеньем
  if (trunc(dateb - start_weekb) = 6) then
    holiday_count := holiday_days - 1;
  end if;
  
  --максимальная дата является субботой
  if (trunc(start_weeke - datee) = 2) then
    holiday_count := holiday_days - 1;  
    
  --максимальная дата не выходной
  elsif (trunc(start_weeke - datee) > 2) then
    holiday_count := holiday_days - 2;
  end if;
   
  --вывод количества рабочих дней
  dbms_output.put_line(days_count - holiday_days);
end;
2
date1
1
16.06.2014
12
date2
1
30.06.2014
12
0
