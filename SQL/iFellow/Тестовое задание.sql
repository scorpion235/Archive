/* ������� ������ */

-- a. ����� ������� ������� ��������, �������� ��������� ����� (������������ ������������ ������ PRODUCT.NAME) � 2018 ����?
select avg(cu.age)
  from purchase pu
 inner join product pr
         on pr.product_key = pu.product_key
        and pr.name        = '�������� �����'
 inner join customer cu
         on cu.customer_key = pu.customer_key
 where extract(year from pu.date_) = 2018
 
 
 -- b. ����� ���-3 ����� ����������� ������ � ��������� �������� (������������ ������������ ��������� PRODUCT_CATEGORY.CATEGORY) �� 2018 ��� � �������� �� �������?  
with cte as
(
    select extract(month from pu.date_) month_no,
           pr.name product_name,
           count(pu.purchase_key),
           dense_rank() over(partition by extract(month from pu.date_) order by pr.name) dr
      from purchase pu
     inner join product pr
             on pr.product_key = pu.product_key
     inner join product_category pc
             on pc.category_key = pr.category_key
            and pc.category     = '�������'
     where extract(year from pu.date_) = 2018
     group by pr.name,
              extract(month from pu.date_)
)
select distinct
       month_no,
       decode(month_no, 1, '������', 2, '�������', 3, '����', 4, '������', 5, '���', 6, '����', 7, '����', 8, '������', 9, '��������', 10, '�������', 11, '������', 12, '�������', '����������� �����') || ' 2018' month_name,
       listagg(product_name, ', ') within group(order by product_name) over(partition by month_no) top3
  from cte
 where dr <= 3
 order by month_no


-- c. ������� ��� ��������, � ������� ����� ������� �� ������� ��������� (����� ����� ���������������� ���������) ��������� 30000 ������.
select cu.fio
  from purchase pu
 inner join product pr
         on pr.product_key = pu.product_key
 inner join customer cu
         on cu.customer_key = pu.customer_key
 where (pu.date_ between to_date('01.05.2022', 'dd.mm.yyyy') and to_date('04.05.2022', 'dd.mm.yyyy')) or (pu.date_ between to_date('07.05.2022', 'dd.mm.yyyy') and to_date('10.05.2022', 'dd.mm.yyyy'))
 group by cu.fio
having sum(pu.qty * pr.price) > 30000