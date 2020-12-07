--Выбрать логин (Login) и дату-время (Moment) последнего входа тех, кто заходил больше пяти раз за один день в текущем месяце.

--создание таблицы ()
CREATE TABLE [dbo].[LoginLog](
    [Login] [VARCHAR](32) NOT NULL,
    [Moment] [DATETIME2](7) NOT NULL,
 CONSTRAINT [PK_LoginLog] PRIMARY KEY CLUSTERED 
(
    [Login] ASC,
    [Moment] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--тестовые данные
INSERT INTO dbo.LoginLog(Login, Moment)
SELECT 'USER_' + CAST(ABS(CHECKSUM(NEWID())) % 50 AS NVARCHAR(10)),
       GETDATE() - ABS(CHECKSUM(NEWID())) % 20
GO 1000

--решение
WITH Logins
AS
(
    SELECT DISTINCT [Login]
      FROM dbo.LoginLog
     WHERE MONTH(Moment) = MONTH(GETDATE())
       AND YEAR(Moment)  = YEAR(GETDATE())
     GROUP BY DAY(Moment),
              Login
    HAVING COUNT(*) > 5
)
SELECT ll.[Login]  [Login],
       MAX(Moment) LastLogin
  FROM dbo.LoginLog ll
 INNER JOIN Logins l
         ON l.[Login] = ll.[Login]
 GROUP BY ll.[Login]