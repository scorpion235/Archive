/* счета */
create table dbo.Bills
(
    id      int,            /* id счета */
    num     nvarchar(100),  /* № счета */
    bdate   datetime,       /* Дата выставления счета */
    pdate   datetime,       /* Дата оплаты счета */
    cid     int,            /* id клиента */
) ON [PRIMARY]
GO

/* строки счетов */
create table dbo.Bill_content
(
    bcID            int,            /* id строки счета*/
    bID             int,            /* id счета */
    product         nvarchar(100),  /* название продукта */
    tarif_name      nvarchar(100),  /* название тарифа */
    service_name    nvarchar(100),  /* название услуги */
    tip             smallint,       /* 1 - подключение, 2 - продление, 3 - прочие услуги */
    cost            money,          /* стоимость строки счета */
    payed           money,          /* оплата по строке счета */
    cnt             int             /* количество */
) ON [PRIMARY]
GO

/* поставки */
create table retail_packs
(
    rpID int,       /* id поставки */
    bcID int,       /* id строки счета */
    since datetime, /* начало поставки */
    upto datetime   /* конец поставки */
) ON [PRIMARY]
GO

INSERT INTO [dbo].[Bills]
           ([id]
           ,[num]
           ,[bdate]
           ,[pdate]
           ,[cid])
     VALUES
           (1
           ,'111'
           ,getdate()-10
           ,GETDATE()
           ,1),

           (2
           ,'222'
           ,getdate()-10
           ,GETDATE()-5
           ,2),

           (3
           ,'333'
           ,getdate()-100
           ,GETDATE()+20
           ,1),

           (4
           ,'111'
           ,getdate()-100
           ,GETDATE()-90
           ,4),

           (5
           ,'555'
           ,getdate()-10
           ,GETDATE()+1
           ,5),

           (6
           ,'666'
           ,getdate()-10
           ,GETDATE()+1
           ,1),

           (7
           ,'777'
           ,getdate()-10
           ,GETDATE()+10
           ,5),

           (8
           ,'888'
           ,getdate()-10
           ,GETDATE()+10
           ,8)
GO

INSERT INTO [dbo].[Bill_content]
           ([bcID]
           ,[bID]
           ,[product]
           ,[tarif_name]
           ,[service_name]
           ,[tip]
           ,[cost]
           ,[payed]
           ,[cnt])
     VALUES
           (1
           ,1
           ,'Контур-Экстерн'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (2
           ,2
           ,'Контур-Экстерн1'
           ,'тариф1'
           ,'услуга1'
           ,2
           ,55.45
           ,468.45
           ,2),

           (3
           ,3
           ,'Контур-Экстерн2'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (4
           ,4
           ,'Контур-Экстерн'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,77.45
           ,468.45
           ,2),

           (5
           ,5
           ,'Контур-Экстерн1'
           ,'тариф1'
           ,'услуга1'
           ,3
           ,123.45
           ,468.455
           ,2),

           (6
           ,1
           ,'Контур-Экстерн3'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,17723.45
           ,55.45
           ,2),

           (7
           ,6
           ,'Контур-Экстерн'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (8
           ,1
           ,'Контур-Экстерн4'
           ,'тариф1'
           ,'услуга1'
           ,2
           ,45.45
           ,5.45
           ,2),

           (9
           ,6
           ,'Контур-Экстерн4'
           ,'тариф1'
           ,'услуга1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (10
           ,7
           ,'Контур-Экстерн'
           ,'тариф1'
           ,'услуга1'
           ,3
           ,45.45
           ,59.45
           ,2),

           (11
           ,8
           ,'Контур-Экстерн'
           ,'тариф1'
           ,'услуга1'
           ,2
           ,45.45
           ,59.45
           ,2)
GO

INSERT INTO [dbo].[retail_packs]
           ([rpID]
           ,[bcID]
           ,[since]
           ,[upto])
     VALUES
           (1
           ,1
           ,GETDATE()-10
           ,getdate()-9),

           (2
           ,2
           ,GETDATE()-10
           ,getdate()+9),

           (3
           ,3
           ,GETDATE()-100
           ,getdate()-9),

           (4
           ,4
           ,GETDATE()-10
           ,getdate()+1),

           (5
           ,6
           ,GETDATE()-10
           ,getdate()),

           (6
           ,6
           ,GETDATE()
           ,getdate()),

           (7
           ,7
           ,GETDATE()-100
           ,getdate()-90),

           (1
           ,1
           ,GETDATE()
           ,getdate()+3),

           (8
           ,8
           ,GETDATE()+5
           ,getdate()+6),

           (9
           ,1
           ,GETDATE()-10
           ,getdate()-9),

           (10
           ,2
           ,GETDATE()-10
           ,getdate()+9),

           (11
           ,3
           ,GETDATE()-100
           ,getdate()-9),

           (12
           ,4
           ,GETDATE()-10
           ,getdate()+1),

           (13
           ,8
           ,GETDATE()-10
           ,getdate()),

           (14
           ,9
           ,GETDATE()
           ,getdate()),

           (15
           ,7
           ,GETDATE()-100
           ,getdate()-90),

           (16
           ,1
           ,GETDATE()
           ,getdate()+3),

           (17
           ,3
           ,GETDATE()+5
           ,getdate()+6),

           (18
           ,7
           ,GETDATE()-1
           ,getdate()+6),

           (19
           ,9
           ,GETDATE()+5
           ,getdate()+6),

           (20
           ,9
           ,GETDATE()+1
           ,getdate()+6),

           (21
           ,10
           ,GETDATE()-15
           ,getdate()+6),

           (22
           ,10
           ,GETDATE()-10
           ,getdate()+6)
GO