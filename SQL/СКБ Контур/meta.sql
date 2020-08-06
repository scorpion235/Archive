-- факты
CREATE TABLE [dbo].[Flights](
	[RecordId] [int] NOT NULL IDENTITY(1,1),
	[DepartureDateTime] [datetime2](3) NOT NULL,	
	[ArrivalDateTime] [datetime2](3) NOT NULL,
	[DepartureAirportId] [int] NOT NULL,
	[DestinationAirportId] [int] NOT NULL,
	[AirCompanyId] [int] NOT NULL,
	[PlaneId] [int] NOT NULL,
	[Passengers] [int] NOT NULL,
CONSTRAINT [PK_Flights] PRIMARY KEY CLUSTERED 
(
	[RecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

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

-- аэропорты
CREATE TABLE [dbo].[Airports]( -- в тестовом задании Geography
	[AirportId] [int] NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](128) NOT NULL,
	[City] [nvarchar](128) NOT NULL,
	[Region] [nvarchar](128) NOT NULL,
	[Country] [nvarchar](128) NOT NULL,
	[Continent] [nvarchar](128) NOT NULL,
CONSTRAINT [PK_Airports] PRIMARY KEY CLUSTERED 
(
	[AirportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- авиакомпании
CREATE TABLE [dbo].[Companies](
	[AirCompanyId] [int] NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](128) NOT NULL,
CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[AirCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- самолеты
CREATE TABLE [dbo].[Plannes](
	[PlaneId] [int] NOT NULL IDENTITY(1,1),
	[Name] [nvarchar](128) NOT NULL,
	[Seats] [int] NOT NULL,
CONSTRAINT [PK_Plannes] PRIMARY KEY CLUSTERED 
(
	[PlaneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



INSERT INTO [dbo].[Airports]
           ([Name]
           ,[City]
           ,[Region]
           ,[Country]
           ,[Continent])
     VALUES
           ('Пулково'
           ,'Москва'
           ,''
           ,'РФ'
           ,''),
		   ('Домодедово'
           ,'Москва'
           ,''
           ,'РФ'
           ,''),
		   ('Храброво'
           ,'Калининград'
           ,''
           ,'РФ'
           ,'')

SET IDENTITY_INSERT [dbo].[Companies] on
INSERT INTO [dbo].[Companies]
           ([AirCompanyId], [Name])
     VALUES
           (0, 'Дюгур inc')
SET IDENTITY_INSERT [dbo].[Companies] off
		   
INSERT INTO [dbo].[Companies]
           ([Name])
     VALUES
           ('Аэрофлот'),
		   ('S7'),
		   ('Уральские авиалинии')

INSERT INTO [dbo].[Plannes]
           ([Name]
           ,[Seats])
     VALUES
           ('Ан-2', 10),
		   ('Л-410', 20),
		   ('Боинг', 100)

INSERT INTO [dbo].[Flights]
           ([DepartureDateTime]
           ,[ArrivalDateTime]
           ,[DepartureAirportId]
           ,[DestinationAirportId]
           ,[AirCompanyId]
           ,[PlaneId]
           ,[Passengers])
     VALUES
           (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-0.1
           ,getdate()-0.1
           ,2
           ,3
           ,1
           ,2
           ,10),
		    (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-2.1
           ,getdate()-2.1
           ,1
           ,0
           ,1
           ,1
           ,10),
		   (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-0.1
           ,getdate()-0.1
           ,2
           ,3
           ,1
           ,2
           ,10),
		    (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-2.1
           ,getdate()-2.1
           ,1
           ,0
           ,0
           ,1
           ,10),
		   (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-0.1
           ,getdate()-0.1
           ,2
           ,3
           ,1
           ,2
           ,10),
		    (getdate()-0.01
           ,getdate()-0.01
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-2.11
           ,getdate()-2.1
           ,1
           ,0
           ,1
           ,1
           ,10),
		   (getdate()-0.016
           ,getdate()-0.018
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-0.15
           ,getdate()-0.16
           ,2
           ,3
           ,1
           ,3
           ,10),
		    (getdate()-3.01
           ,getdate()-3.01
           ,3
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-6.1
           ,getdate()-6.1
           ,1
           ,0
           ,0
           ,1
           ,10),
		   (getdate()-6.1
           ,getdate()-6.1
           ,1
           ,0
           ,0
           ,2
           ,35),
		    (getdate()-3
           ,getdate()-3
           ,1
           ,2
           ,0
           ,1
           ,10),
		   (getdate()-2
           ,getdate()-2
           ,2
           ,0
           ,0
           ,1
           ,10),
		   (getdate()-1
           ,getdate()-1
           ,3
           ,0
           ,0
           ,2
           ,35)


select *
  from [dbo].[Airports]

select *
  from [dbo].[Companies]

select *
  from [dbo].[Plannes]

select *
  from [dbo].[Flights]
 order by DepartureDateTime