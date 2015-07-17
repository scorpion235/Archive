PL/SQL Developer Test script 3.0
18
declare
  min_date Date; 
  max_date Date;
begin
  min_date := least(:d1, :d2);
  max_date := greatest(:d1, :d2);

  select nvl(
           sum( 
             case when to_char(trunc(min_date) - rownum, 'd') in (6,7) 
                       then 0 
                       else 1 
                  end),
            0)
    into :days_count 
    from all_objects 
   where rownum <= trunc(max_date) - trunc(min_date) - 1; 
end;
3
d1
1
01.06.2014
12
d2
1
30.06.2014
12
days_count
1
20
3
0
