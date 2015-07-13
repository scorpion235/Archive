select
    c.fio
from
    operations o,
    clients c
where o.client_id = c.id
and ROWNUM <= 3
group by c.fio
having sum(o.amount * o.price_for_one) = 
(
    select
        max(sum(o1.amount * o1.price_for_one))
    from
        operations o1,
        clients c1
    where o1.client_id = c1.id
    group by c1.fio
)