/*
Дюгуров Сергей
Реализация на Oracle
*/

--1
select merchant_region,
       transaction_sum
from
(
  select merchant_region,
         transaction_sum,
         dense_rank() over (order by transaction_sum desc) rn
  from
  (
    select m."merchant_region"      merchant_region,
           sum(t."transaction_sum") transaction_sum
      from "Transactions" t
     inner join "Customers" c
             on c.customer_id = t.customer_id
     inner join "Merchants" m
             on m."merchant_id" = t."merchant_id"
     where extract(year from t."transaction_dttm") = extract(year from sysdate)
     group by m."merchant_region"
  )
)
where rn = 1;

--2
select merchant_type_id,
       avg_transaction_sum
from
(
  select merchant_type_id,
         avg_transaction_sum,
         dense_rank() over (order by avg_transaction_sum desc) rn
  from
  (
    select m."merchant_type_id"     merchant_type_id,
           avg(t."transaction_sum") avg_transaction_sum
      from "Transactions" t
     inner join "Customers" c
             on c.customer_id = t.customer_id
     inner join "Merchants" m
             on m."merchant_id" = t."merchant_id"
     group by m."merchant_type_id"
  )
)
where rn = 1;

--3
select c."customer_age",
       m."merchant_type_id",
       count(t."transaction_id") transaction_count,
       sum(t."transaction_sum")  transaction_sum,
       avg(t."transaction_sum")  avg_transaction_sum
  from "Transactions" t
 inner join "Customers" c
         on c.customer_id = t.customer_id
 inner join "Merchants" m
         on m."merchant_id" = t."merchant_id"
 group by c."customer_age",
        m."merchant_type_id"
 order by c."customer_age";

--4
--доходность по типу магазина за текущий год
--плюс смотри диаграмму в excel
select m."merchant_type_id",
       100 * sum(t."transaction_sum") / (select sum("transaction_sum") from "Transactions" where extract(year from "transaction_dttm") = extract(year from sysdate)) transaction_sum
  from "Transactions" t
 inner join "Customers" c
         on c.customer_id = t.customer_id
 inner join "Merchants" m
         on m."merchant_id" = t."merchant_id"
 where extract(year from t."transaction_dttm") = extract(year from sysdate)
 group by m."merchant_type_id"
 order by m."merchant_type_id";

--5
select '[' || substr(str, 1, length(str) - 2 ) || ']'
from
(
  select listagg('{"key":"' || "key" || '", "assignee":"' || "assignee" || '"}, ') within group (order by "key") str
    from st_tasks
   where "status" in ('Open', 'On support side', 'Verifying')
);

select '[' || substr(str, 1, length(str) - 2 ) || ']'
from
(
  select listagg('{"assignee":"' || "assignee" || '", "needTasks":"' || task || '"}, ') within group (order by "assignee") str
    from
  (
    select "assignee",
           count("key") task
      from st_tasks
     group by "assignee"
     order by "assignee"
  )
);

/*
Алгоритм такой:
1. Находим все задачи (key) и всех исполнителей (assignee), у которых есть задачи в статусах 'Open', 'On support side', 'Verifying' дольше $days
2. Обходим полученный массив в цикле. Для каждого полученного значения key-assignee1 находим исполнителя assignee2 с минимальным количеством задач в статусах 'Open', 'On support side', 'Verifying' (assignee2 не из массива из пункта 1)
3. Меняем исполнителя по данной задаче (key): assignee1 > assignee2

За счёт того, что в каждой итерации мы находим исполнителя с минимальным количеством задач в статусах 'Open', 'On support side', 'Verifying', нагрузка будет одинаковой (или примерно одинаковой с минимальной разницей)
*/