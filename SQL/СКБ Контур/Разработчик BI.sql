-- (1)
declare @bdate        [datetime2](3) = '2020-08-02 00:00:00',
        @edata        [datetime2](3) = '2020-09-01 23:00:00',
        @AirCompanyId int            = -1 -- ���

if datediff(d, @bdate, @edata) > 31
    select '������ ������������� ������ �� ����� ��������� 1 �����'
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
     inner join dbo.Airports dep --� �������� ������� ������� ���������� Geography
             on dep.AirportId = f.DepartureAirportId
     inner join dbo.Airports dest --� �������� ������� ������� ���������� Geography
             on dest.AirportId = f.DestinationAirportId
     inner join dbo.Companies c
             on c.AirCompanyId = f.AirCompanyId
     inner join dbo.Plannes p
             on p.PlaneId = f.PlaneId
     where f.DepartureDateTime between @bdate and @edata
       and (@AirCompanyId = -1 or f.AirCompanyId = @AirCompanyId)
      order by f.DepartureDateTime -- ���������� ��� ������� (5), ��������� �������������� ���� ��� ���������� �� ����� ������, ����+����� ����������� ������ ����� ����� ����������

-- (2)
select f.DepartureDateTime,
       f.ArrivalDateTime,
       dep.Name DepartureAirport,
       dest.Name DestinationAirport,
       c.Name AirCompany
  from dbo.Flights f
 inner join dbo.Airports dep --� �������� ������� ������� ���������� Geography
         on dep.AirportId = f.DepartureAirportId
 inner join dbo.Airports dest --� �������� ������� ������� ���������� Geography
         on dest.AirportId = f.DestinationAirportId
 inner join dbo.Companies c
         on c.AirCompanyId = f.AirCompanyId
 outer apply
 (
     -- ��������� ���� ����� ������������ �� ����� ���������
     select min(DepartureDateTime) MinDepartureDateTime
       from dbo.Flights f2
      where f2.DepartureDateTime > f.DepartureDateTime 
        and f2.AirCompanyId = 0
        and f2.DepartureAirportId = f.DepartureAirportId
 ) a
 where f.DepartureDateTime between dateadd(day, -datepart(day, getdate()) + 1, cast(getdate() as date)) and getdate() -- � ������� ����� ������ �� ������� ����� ������������
   and f.AirCompanyId != 0
   and a.MinDepartureDateTime is not null
 order by f.DepartureDateTime -- ���������� ��� ������� (5)

-- (3)
declare @date date = getdate() + 30

select [������������], [������], [�������], [����], [������], [���], [����], [����], [������], [��������], [�������], [������], [�������]
  from
  (
      select f.Passengers,
             c.Name [������������],

             case month(f.DepartureDateTime)
                 when 1 then '������'
                 when 2 then '�������'
                 when 3 then '����'
                 when 4 then '������'
                 when 5 then '���'
                 when 6 then '����'
                 when 7 then '����'
                 when 8 then '������'
                 when 9 then '��������'
                 when 10 then '�������'
                 when 11 then '������'
                 when 12 then '�������'
             end 
             [month]

        from dbo.Flights f
       inner join dbo.Companies c
                  on c.AirCompanyId = f.AirCompanyId
       where f.DepartureDateTime between dateadd(year, -1, dateadd(day, -datepart(day, @date) + 1, cast(@date as date))) and dateadd(day, -1, dateadd(day, -datepart(day, @date) + 1, cast(@date as date)))
  ) s
 pivot (sum(Passengers) for [month] in ([������], [�������], [����], [������], [���], [����], [����], [������], [��������], [�������], [������], [�������])) pvt
 order by [������������] -- ���������� ��� ������� (5)
-- (4)
/*
� ������������ ���������� � ���������� ������ ��� ������ �� ����������� ������� ����� �������� ������ �� ���� ��������.
������ � ������ ������ ������ ����������� �������������� ����� ����, ������� �������� �� ������� ������ �� ���� ����� ���������,
����� � �������� ����� ��������� � ���������� �������. 
*/

-- (5)
/*
���������� ���������� ��������� � ������� ����
�������� �������: ���������� ��� ������� (5)
*/

-- (6)
/*
����:
���� ���������
������������� �����, %
������� ������������� ������, %
*/

-- (8)
/*
PRIMARY KEY CLUSTERED: Flights.RecordId
PRIMARY KEY CLUSTERED: Airports.AirportId --� �������� ������� ������� ���������� Geography
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
��������� ������������ ������
MaxConcurrentExecutables � �������� ������, ������������ ���������� ����������� ��������, ������� ����� ��������� �����������.
�������� �� ��������� �1. ��� ������, ��� �������� ������ ���������� ����������� ���������� ���������� ����������� �� ������� ���� 2.
��������, ���� ����� � ������������� �� ��������� ��������� �������� ����������� �� ��������������� �������, �� ����� �����������
��������� ����� ����������� ��������.
*/

-- (10)
/*
1 �������: ���������� ������ � �������� �������. �������� FlightsArch (����� ������)
2 ������� (����� ����������): �������� ���� ���� bit c ��������� Del (0 - �������� ������, 1 - ���������� ������) ��� StatusId (1 - �������� ������, ���������� ������),
� ������ �������� ������������� �������� Del/StatusId (0 > 1 ��� 1 > 0)
*/

-- (11)
/*
� ����� ����������� ���� ������ ���������

��� ��������:
1. ������� � ��������� ��������� ����� ������� Airports ������ Geography. �� ���� ������ � �������� ������� ��������� Airports ������ Geography
2. ��� ��������� �������������� ����� ������������ �������� 0. ����� �������� ����� ��������, ����� ��� �������� ����� ��������������
3. ��� ������� Flights � �� ������� ���� DateCreate (����� �������� �����) �, ��� �������� � ������ (10), ����� ������� ���� Del/StatusId
*/