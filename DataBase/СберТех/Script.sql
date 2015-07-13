/* 1 */

select s.employee_name
  from
  (
    select e1.name employee_name,
           e1.salary employee_salary,
           e2.salary chief_salary
      from employee e1
     inner join employee e2
        on e1.chief_id = e2.id
  ) s
  where s.employee_salary > s.chief_salary

/* 2 */

select e.name,
       d.name
  from employee e
 inner join department d
    on d.id = e.department_id
 where e.salary =
 (
   select max(e2.salary)
     from employee e2
    where e2.department_id = e.department_id
 )

/* 3 */

select d.id,
       count(e.id)
  from department d
 inner join employee e
         on e.department_id = d.id
 group by d.id
having count(e.id) < 4

/* 4 */

select e1.name
  from employee e1
 inner join department d1
    on d1.id = e1.department_id
 where not exists
(
  select e2.id
    from employee e2
   where e2.id = e1.chief_id
     and e2.department_id = e1.department_id
)
