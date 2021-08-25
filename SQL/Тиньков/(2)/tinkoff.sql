/*
Дано 3 таблицы:
1) таблица со счетами кредитных карт account:
        account_id (id счета)
2) таблица с выписками по кредитным картам statement:
    statement_id (id выписки),
    account_id (id счета),
    statement_dt (дата выписки),
    due_dt (дата погашения выписки),
    min_amt (мин. сумма погашения)
3) таблица с платежами клиентов payment:
    payment_id (id платежа),
    account_id (id счета),
    payment_dt (дата платежа),
    payment_amt (сумма платежа)

Задание: вывести список недолжников на сегодня.
*/


select s.account_id
  from
(
  select account_id
         max(statement_dt) max_statement_dt
    from statement
   where min_amt = 0
   group by account_id
) s

union all

select s2.account_id
from
(
  select s.account_id,
         st.min_amt
         sum(p.payment_amt) payment_amt
    from
  (
    select account_id
           max(statement_dt) max_statement_dt
      from statement
     where min_amt > 0
       and due_dt < now()
     group by account_id
  ) s
  inner join statement st
          on st.account_id   = s.account_id
         and st.statement_dt = s.max_statement_dt
  inner join payment p
          on p.account_id = s.account_id
         and p.payment_dt between s.max_statement_dt and p.due_dt
  group by s.account_id,
           st.min_amt
) s2
where s2.min_amt <= s2.payment_amt

01.01.2021        40000            25.02.2021        4000
01.02.2021        40000            25.03.2021        4000
01.03.2021        40000            25.04.2021        4000