------------------------------------------------------------------------------------
-- ��������� ���������� ��������, ������� ������� ����������                                                            
------------------------------------------------------------------------------------

select count(st.id) students_count_studying_math
  from students st
 where exists
 (
   select top(1) sc.class_id
     from schedule sc
    inner join teacher2subject ts
       on ts.id = sc.teacher2subject_id
    inner join subjects sb
       on sb.id = ts.subject_id
      and upper(sb.name) = '����������'
    where sc.class_id = st.class_id
 );

------------------------------------------------------------------------------------
-- ��������� ���������� ������� ����� (�� �������������) � ������ 
-- ������������� "������ �.�."
------------------------------------------------------------------------------------

select (cast(count(sc.id)as numeric(10, 5)) * 2 / 3) ivanov_hours
  from schedule sc
 inner join teacher2subject ts
    on ts.id = sc.teacher2subject_id
 inner join teachers tc
    on tc.id = ts.teacher_id
   and upper(tc.fio) = '������ �.�.';

------------------------------------------------------------------------------------
-- ������� ��� 3 ��������������, ��������� ������������ ���������� ��������. 
-- ������� �������� ����������� ����� ���������.
------------------------------------------------------------------------------------

select top(3) tc.fio,
       sum(s.student_count) student_count
  from
  (
    --���������� �������� �� ����������
    select ts.teacher_id,
           count(st.id) student_count
      from schedule sc
     inner join teacher2subject ts
        on ts.id = sc.teacher2subject_id
     inner join students st
        on st.class_id = sc.class_id
     group by ts.teacher_id
    
    union all
    
    --���������� �������� �� �����������
    select cr.teacher_id,
           count(st.id) student_count
      from curators cr
     inner join students st
        on st.class_id = cr.class_id
     group by cr.teacher_id
  ) s
 inner join teachers tc
    on tc.id = s.teacher_id
 group by tc.fio
 order by sum(s.student_count) desc;