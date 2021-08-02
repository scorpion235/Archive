/*
SQL

������� ��� ����� prediction_1.tsv � prediction_2.tsv � ������� ���������� ���������� �� �������� ���������� �� �����.

�������� ���� ��������� �� ������ � 25 �� 31 �������.

������ ������:
start_of_hour - ��� � ����;
prediction - ��������� ���������� ���������;
queueId - id �����.

����������� �������� �������� �� ��� �����, ������� ����������� � �� ������, ���� � ����� fact_incoming.tsv � ��������:
queueId - id �����;
timestamp - ����� ��������� ��������� ���������;
new_t - id ��������� ���������.

����� �� ��������� �������� ����� ������ � ������? ������� ������� � ���������� �� ������� � ������� SQL.
*/


/*
��������� �� sql server 2016

��� �������� �������� �������� ������ �������:
���������� ������� = 0
����� ����� �������� ����������� � ���� � ����������� �������� �������� �� ��� ����� � � ��������
���� ������� ��� ������ ����� �� ������ ������ ����������, �� ���������� -10

������:
����        �������        �������        ������� (����������� ����)
2            10            -8             -8
3            -             -10            -18
4            1             -3             -21
5            5             0              -21
1            2             -1             -22

����� �������, ��� ����� ������� � 0, ��� ����� �������


������� �������� �1: -632
������� �������� �2: -725
������� �1 ����� ������
*/

declare
    @req_date     date,
    @req_hour     int,
    @req_queueid  int,
    @req_numbers  int,

    @res_predication_1 int = 0,
    @res_predication_2 int = 0

declare cur_fact cursor local fast_forward
for
select cast([timestamp] as date),
       datepart(hour, [timestamp]),
       [queueid],
       count(new_t)
  from dbo.fact_incoming
 group by cast([timestamp] as date),
          datepart(hour, [timestamp]),
          [queueid]

open cur_fact

fetch cur_fact
into @req_date,
     @req_hour,
     @req_queueid,
     @req_numbers

while @@fetch_status = 0
begin
    -- ������� �1
    if exists (
        select isnull([prediction], 0)
          from dbo.prediction_1
         where cast([start_of_hour] as date)   = @req_date
           and datepart(hour, [start_of_hour]) = @req_hour
           and [queueid]                       = @req_queueid)
    begin
        select @res_predication_1 = @res_predication_1 - abs(isnull([prediction], 0) - @req_numbers)
            from dbo.prediction_1
            where cast([start_of_hour] as date)   = @req_date
            and datepart(hour, [start_of_hour]) = @req_hour
            and [queueid]                       = @req_queueid
    end
    else
        -- ������� ��� ������ ����� �� ������ ������ ����������
        select @res_predication_1 = @res_predication_1 - 10


    -- ������� �2
    if exists (
        select isnull([prediction], 0)
          from dbo.prediction_2
         where cast([start_of_hour] as date)   = @req_date
           and datepart(hour, [start_of_hour]) = @req_hour
           and [queueid]                       = @req_queueid)
    begin
        select @res_predication_2 = @res_predication_2 - abs(isnull([prediction], 0) - @req_numbers)
            from dbo.prediction_2
            where cast([start_of_hour] as date) = @req_date
            and datepart(hour, [start_of_hour]) = @req_hour
            and [queueid]                       = @req_queueid
    end
    else
        -- ������� ��� ������ ����� �� ������ ������ ����������
        select @res_predication_2 = @res_predication_2 - 10


    fetch cur_fact
    into @req_date,
         @req_hour,
         @req_queueid,
         @req_numbers
end

close cur_fact 
deallocate cur_fact

print '������� �������� �1: ' + cast(@res_predication_1 as varchar(100))
print '������� �������� �2: ' + cast(@res_predication_2 as varchar(100))

if abs(@res_predication_1) < abs(@res_predication_2)
    print '������� �1 ����� ������'
else
    print '������� �2 ����� ������'