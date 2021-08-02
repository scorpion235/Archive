/*
SQL

Имеется два файла prediction_1.tsv и prediction_2.tsv с разными почасовыми прогнозами по входящим обращениям на линии.

Прогнозы были построены на неделю с 25 по 31 декабря.

Формат файлов:
start_of_hour - час и дата;
prediction - суммарное количество обращений;
queueId - id линии.

Фактическая входящая нагрузка на эти линии, которая наблюдалась в ту неделю, дана в файле fact_incoming.tsv с форматом:
queueId - id линии;
timestamp - время появления входящего обращения;
new_t - id входящего обращения.

Какой из прогнозов оказался более точным и почему? Введите метрики и реализуйте их подсчет с помощью SQL.
*/


/*
реализаци на sql server 2016

для подсчета точности прогноза введем метрику:
изначально метрика = 0
далее будем вычитать расхождение в днях в фактической входящей нагрузки на эти линии и в прогнозе
если прогноз для данной линии за данный период отсутстует, то выставляем -10

пример:
факт        прогноз        метрика        метрика (нарастающий итог)
2            10            -8             -8
3            -             -10            -18
4            1             -3             -21
5            5             0              -21
1            2             -1             -22

таким образом, чем ближе метрика к 0, тем лучше прогноз


метрика прогноза №1: -632
метрика прогноза №2: -725
прогноз №1 более точный
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
    -- прогноз №1
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
        -- прогноз для данной линии за данный период отсутстует
        select @res_predication_1 = @res_predication_1 - 10


    -- прогноз №2
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
        -- прогноз для данной линии за данный период отсутстует
        select @res_predication_2 = @res_predication_2 - 10


    fetch cur_fact
    into @req_date,
         @req_hour,
         @req_queueid,
         @req_numbers
end

close cur_fact 
deallocate cur_fact

print 'метрика прогноза №1: ' + cast(@res_predication_1 as varchar(100))
print 'метрика прогноза №2: ' + cast(@res_predication_2 as varchar(100))

if abs(@res_predication_1) < abs(@res_predication_2)
    print 'прогноз №1 более точный'
else
    print 'прогноз №2 более точный'