--Количество товаров проданных клиентам за период с … по…
select 
    sum(o.amount)
from 
    operations o,
    oper_types t
where o.oper_type_id = t.id
and t.code = 'Buy'
and o.doc_date between :date_begin and :date_end