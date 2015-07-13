--Общая сумма товаров на складе
select 
    sum(o.amount * t.sign)
from 
    operations o,
    oper_types t
where o.oper_type_id = t.id
