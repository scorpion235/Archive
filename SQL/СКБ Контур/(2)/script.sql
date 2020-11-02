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

select cl.client_id,                                              -- Id �������
       coalesce(b1.bill_num, b2.bill_num, '-')     as bill_num,   -- � �����
       coalesce(b1.bill_bdate, b2.bill_bdate, '-') as bill_bdate, -- ���� �������� �����
       coalesce(b1.bill_pdate, b2.bill_pdate, '-') as bill_pdate, -- ���� ������ �����
       cl.cost,                                                   -- ����� ����� �� ���� �������
       cl.payer                                                   -- ������ �� ����� �� ���� �������
  from clients cl

  outer apply
  (
      -- � �����, �� �������� ���� �������� �������� (����������� �� ������ ������) �� �������� �������-�������.
      -- ���� ���� ��������� ������, ��������������� ������� �������, ���������� ������� ����, �� �������� ������� �������� �� �������-�������� � ������������ ����� ���������.
      select top 1
             b.num   as bill_num,
             b.bdate as bill_bdate,
             b.pdate as bill_pdate
        from dbo.Bills b
       inner join dbo.Bill_content bc
               on bc.bID     = b.id
              and bc.product = '������-�������'
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
      -- ���� ��� ������, ��������������� ����������� ������� ������, ���������� ������� ���� � ������������ ����� ������, � ������� ���� ������ �� �������-������� �� ����������� ��� ���������.
      select top 1
             b.num   as bill_num,
             b.bdate as bill_bdate,
             b.pdate as bill_pdate
        from dbo.Bills b
       inner join dbo.Bill_content bc
               on bc.bID     = b.id
              and bc.product = '������-�������'
              and bc.tip in (1, 2) -- ����������� ��� ���������
       where b.cid = cl.client_id
         and b1.bill_num is null -- ���� ��� ������, ��������������� ����������� ������� ������
       order by pdate desc
  ) b2