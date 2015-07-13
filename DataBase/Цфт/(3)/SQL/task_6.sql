create or replace type char_table is table of char(1)

create or replace function sort_srt
  (p_str VARCHAR2) 
return varchar2 deterministic as
  n number;
  s varchar2(256);
  st char_table := char_table();
begin
  for n in 1..length(p_str)
  loop
    st.extend;
    st(n) := substr(p_str, n, 1);
  end loop;

  select cast(multiset(select * from table(st) order by 1) as char_table)
    into st
    from dual;

  for n in st.first..st.last
  loop
    s := s || st(n);
  end loop;
  
  return s;
end;
