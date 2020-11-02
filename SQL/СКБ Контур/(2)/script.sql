with clients (client_id, cost, payer)
as
(
    select b.cid,
           sum(bc.cost),
           sum(bc.payed)
      from dbo.Bills b
     inner join dbo.Bill_content bc
             on bc.bID = b.id
     group by b.cid
)

select cl.client_id,                                              -- Id клиента
       coalesce(b1.bill_num, b2.bill_num, '-')     as bill_num,   -- № счета
       coalesce(b1.bill_bdate, b2.bill_bdate, '-') as bill_bdate, -- Дата создания счета
       coalesce(b1.bill_pdate, b2.bill_pdate, '-') as bill_pdate, -- Дата оплаты счета
       cl.cost,                                                   -- Сумма счета по всем строкам
       cl.payer                                                   -- Оплата по счету по всем строкам
  from clients cl

  outer apply
  (
      -- № счета, по которому есть открытая поставка (действующая на данный момент) по продукту «Контур-Экстерн».
      -- Если есть несколько счетов, удовлетворяющие данному условию, необходимо вывести счет, по которому создана поставка по «Контур-Экстерну» с максимальной датой окончания.
      select top 1
             b.num   as bill_num,
             b.bdate as bill_bdate,
             b.pdate as bill_pdate
        from dbo.Bills b
       inner join dbo.Bill_content bc
               on bc.bID     = b.id
              and bc.product = 'Контур-Экстерн'
       outer apply
       (
           select top 1 upto
             from dbo.retail_packs
            where bcID  = bc.bcID
              and since <= GETDATE()
              and upto  >= GETDATE()
            order by upto desc
        ) rp
       where b.cid = cl.client_id
         and rp.upto is not null
       order by rp.upto desc
  ) b1

  outer apply
  (
      -- Если нет счетов, удовлетворяющих предыдущему условию поиска, необходимо вывести счет с максимальной датой оплаты, в котором есть строки на «Контур-Экстерн» на подключение или продление.
      select top 1
             b.num   as bill_num,
             b.bdate as bill_bdate,
             b.pdate as bill_pdate
        from dbo.Bills b
       inner join dbo.Bill_content bc
               on bc.bID     = b.id
              and bc.product = 'Контур-Экстерн'
              and bc.tip in (1, 2) -- подключение или продление
       where b.cid = cl.client_id
         and b1.bill_num is null -- если нет счетов, удовлетворяющих предыдущему условию поиска
       order by pdate desc
  ) b2