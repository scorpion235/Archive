--Принятый/отгруженный товар за период в разрезе кладовщиков
select 
    e.fio,
    p.name,
    t.name,
    count(o.id),
    sum(o.amount * o.price_for_one)
from 
    operations o,
    employees e,
    products p,
    oper_types t
where o.employee_id = e.id
and o.product_id = p.id
and o.oper_type_id = t.id
group by
    e.fio,
    p.name,
    t.name