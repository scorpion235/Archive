create or replace type char_table is table of char(1)

create or replace function sort_srt
  (p_str varchar2)
return varchar2 deterministic as
  n number;
  cnt_eng number := 0;
  cnt_rus number := 0;
  cnt_dig number := 0;
  
  s varchar2(256) := '';
  st_eng char_table := char_table();
  st_rus char_table := char_table();
  st_dig char_table := char_table();
begin
  for n in 1..length(p_str)
  loop
    if (regexp_like(substr(p_str, n, 1), '^[A-z]+$')) then
      st_eng.extend;
      cnt_eng := cnt_eng + 1;
      st_eng(cnt_eng) := substr(p_str, n, 1);

    elsif (regexp_like(substr(p_str, n, 1), '^[À-ÿ]+$')) then
      st_rus.extend;
      cnt_rus := cnt_rus + 1;
      st_rus(cnt_rus) := substr(p_str, n, 1);

    elsif (regexp_like(substr(p_str, n, 1), '^[0-9]+$')) then
      st_dig.extend;
      cnt_dig := cnt_dig + 1;
      st_dig(cnt_dig) := substr(p_str, n, 1);

    end if;
  end loop;

  select cast(multiset(select * from table(st_eng) order by 1) as char_table)
    into st_eng
    from dual;
    
  select cast(multiset(select * from table(st_rus) order by 1) as char_table)
    into st_rus
    from dual;
    
  select cast(multiset(select * from table(st_dig) order by 1) as char_table)
    into st_dig
    from dual;

  for n in st_eng.first..st_eng.last
  loop
    s := s || st_eng(n);
  end loop;
  
  for n in st_rus.first..st_rus.last
  loop
    s := s || st_rus(n);
  end loop;
  
  for n in st_dig.first..st_dig.last
  loop
    s := s || st_dig(n);
  end loop;

  return s;
end;
