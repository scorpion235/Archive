-- (1)
declare @bdate        [datetime2](3) = '2020-08-02 00:00:00',
        @edata        [datetime2](3) = '2020-09-01 23:00:00',
        @AirCompanyId int            = -1 -- все

if datediff(d, @bdate, @edata) > 31
    select 'Период запрашиваемых данных не может превышать 1 месяц'
else
    select f.DepartureDateTime,
           f.ArrivalDateTime,
           dep.Name DepartureAirport,
           dest.Name DestinationAirport,
           c.Name AirCompany,
           p.Name Plane,
           f.Passengers,
           cast(f.Passengers as numeric(10,2)) / p.Seats * 100 FlightLoad
      from dbo.Flights f
     inner join dbo.Airports dep --в тестовом задании таблица называется Geography
             on dep.AirportId = f.DepartureAirportId
     inner join dbo.Airports dest --в тестовом задании таблица называется Geography
             on dest.AirportId = f.DestinationAirportId
     inner join dbo.Companies c
             on c.AirCompanyId = f.AirCompanyId
     inner join dbo.Plannes p
             on p.PlaneId = f.PlaneId
     where f.DepartureDateTime between @bdate and @edata
       and (@AirCompanyId = -1 or f.AirCompanyId = @AirCompanyId)
      order by f.DepartureDateTime -- сотритовка для задания (5), добавлять дополнительные поля для сортировки не имеет смысла, дата+время отправления скорее всего будет уникальной

-- (2)
select f.DepartureDateTime,
       f.ArrivalDateTime,
       dep.Name DepartureAirport,
       dest.Name DestinationAirport,
       c.Name AirCompany
  from dbo.Flights f
 inner join dbo.Airports dep --в тестовом задании таблица называется Geography
         on dep.AirportId = f.DepartureAirportId
 inner join dbo.Airports dest --в тестовом задании таблица называется Geography
         on dest.AirportId = f.DestinationAirportId
 inner join dbo.Companies c
         on c.AirCompanyId = f.AirCompanyId
 outer apply
 (
     -- следующий рейс нашей авиакомпании из этого аэропорта
     select min(DepartureDateTime) MinDepartureDateTime
       from dbo.Flights f2
      where f2.DepartureDateTime > f.DepartureDateTime 
        and f2.AirCompanyId = 0
        and f2.DepartureAirportId = f.DepartureAirportId
 ) a
 where f.DepartureDateTime between dateadd(day, -datepart(day, getdate()) + 1, cast(getdate() as date)) and getdate() -- с первого числа месяца по текущее число включительно
   and f.AirCompanyId != 0
   and a.MinDepartureDateTime is not null
 order by f.DepartureDateTime -- сотритовка для задания (5)

-- (3)
declare @date date = getdate() + 30

select [авиакомпания], [январь], [февраль], [март], [апрель], [май], [июнь], [июль], [август], [сентябрь], [октябрь], [ноябрь], [декабрь]
  from
  (
      select f.Passengers,
             c.Name [авиакомпания],

             case month(f.DepartureDateTime)
                 when 1 then 'январь'
                 when 2 then 'февраль'
                 when 3 then 'март'
                 when 4 then 'апрель'
                 when 5 then 'май'
                 when 6 then 'июнь'
                 when 7 then 'июль'
                 when 8 then 'август'
                 when 9 then 'сентябрь'
                 when 10 then 'октябрь'
                 when 11 then 'ноябрь'
                 when 12 then 'декабрь'
             end 
             [month]

        from dbo.Flights f
       inner join dbo.Companies c
                  on c.AirCompanyId = f.AirCompanyId
       where f.DepartureDateTime between dateadd(year, -1, dateadd(day, -datepart(day, @date) + 1, cast(@date as date))) and dateadd(day, -1, dateadd(day, -datepart(day, @date) + 1, cast(@date as date)))
  ) s
 pivot (sum(Passengers) for [month] in ([январь], [февраль], [март], [апрель], [май], [июнь], [июль], [август], [сентябрь], [октябрь], [ноябрь], [декабрь])) pvt
 order by [авиакомпания] -- сотритовка для задания (5)
-- (4)
/*
В существующие требования к фильтрации данных для отчета по детализации трафика можно добавить фильтр по типу самолета.
Причем в начале списка должен обязательно присутствовать пункт «Все», который позволил бы выбрать данные по всем типам самолетов,
далее – перечень типов самолетов в алфавитном порядке. 
*/

-- (5)
/*
Реализация сортировки добавлена в запросы выше
Смотреть пометку: сотритовка для задания (5)
*/

-- (6)
/*
Меры:
Типы самолетов
Загруженность рейса, %
Средняя загруженность рейсов, %
*/

-- (8)
/*
PRIMARY KEY CLUSTERED: Flights.RecordId
PRIMARY KEY CLUSTERED: Airports.AirportId --в тестовом задании таблица называется Geography
PRIMARY KEY CLUSTERED: Companies.AirCompanyId
PRIMARY KEY CLUSTERED: Plannes.PlaneId

CREATE NONCLUSTERED INDEX [IX_Flights] ON [dbo].[Flights]
(
    [DepartureDateTime] ASC,
    [AirCompanyId] ASC,
    [DepartureAirportId] ASC,
    [DestinationAirportId] ASC,
    [PlaneId] ASC
)
INCLUDE ([Passengers]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
*/

-- (9)
/*
Настроить параллельный запуск
MaxConcurrentExecutables — свойство пакета, определяющее количество исполняемых объектов, которые можно запускать параллельно.
Значение по умолчанию –1. Это значит, что механизм потока управления задействует количество логических процессоров на сервере плюс 2.
Например, если пакет с установленным по умолчанию значением свойства исполняется на четырехъядерном сервере, то можно параллельно
запускать шесть исполняемых объектов.
*/

-- (10)
/*
1 вариант: перемещать данные в архивную таблицу. Например FlightsArch (архив фактов)
2 вариант (более корректный): добавить поля типа bit c названием Del (0 - активная запись, 1 - неактивная запись) или StatusId (1 - активная запись, неактивная запись),
а вместо удаления инвертировать значение Del/StatusId (0 > 1 или 1 > 0)
*/

-- (11)
/*
В целом архитектура базы данных корректна

Что изменить:
1. Таблицу с названием аэропотов лучше назвать Airports вместо Geography. Во всех местах в тестовом задании использую Airports вместо Geography
2. Для числового идентификатора редко используются значения 0. Лучше избегать таких ситуаций, пусть все значения будут положительными
3. Для таблицы Flights я бы добавил поле DateCreate (время создания факта) и, как написано в пункте (10), лучше создать поле Del/StatusId
*/