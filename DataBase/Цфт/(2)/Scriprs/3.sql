--Сумма заказов клиента за период
select 
    sum(o.amount * o.price_for_one)
from 
    operations o,
    oper_types t
where o.oper_type_id = t.id
and o.doc_date between :date_begin and :date_end