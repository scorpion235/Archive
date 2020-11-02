/* ����� */
create table dbo.Bills
(
    id      int,            /* id ����� */
    num     nvarchar(100),  /* � ����� */
    bdate   datetime,       /* ���� ����������� ����� */
    pdate   datetime,       /* ���� ������ ����� */
    cid     int,            /* id ������� */
) ON [PRIMARY]
GO

/* ������ ������ */
create table dbo.Bill_content
(
    bcID            int,            /* id ������ �����*/
    bID             int,            /* id ����� */
    product         nvarchar(100),  /* �������� �������� */
    tarif_name      nvarchar(100),  /* �������� ������ */
    service_name    nvarchar(100),  /* �������� ������ */
    tip             smallint,       /* 1 - �����������, 2 - ���������, 3 - ������ ������ */
    cost            money,          /* ��������� ������ ����� */
    payed           money,          /* ������ �� ������ ����� */
    cnt             int             /* ���������� */
) ON [PRIMARY]
GO

/* �������� */
create table retail_packs
(
    rpID int,       /* id �������� */
    bcID int,       /* id ������ ����� */
    since datetime, /* ������ �������� */
    upto datetime   /* ����� �������� */
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
           ,'������-�������'
           ,'�����1'
           ,'������1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (2
           ,2
           ,'������-�������1'
           ,'�����1'
           ,'������1'
           ,2
           ,55.45
           ,468.45
           ,2),

           (3
           ,3
           ,'������-�������2'
           ,'�����1'
           ,'������1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (4
           ,4
           ,'������-�������'
           ,'�����1'
           ,'������1'
           ,1
           ,77.45
           ,468.45
           ,2),

           (5
           ,5
           ,'������-�������1'
           ,'�����1'
           ,'������1'
           ,3
           ,123.45
           ,468.455
           ,2),

           (6
           ,1
           ,'������-�������3'
           ,'�����1'
           ,'������1'
           ,1
           ,17723.45
           ,55.45
           ,2),

           (7
           ,6
           ,'������-�������'
           ,'�����1'
           ,'������1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (8
           ,1
           ,'������-�������4'
           ,'�����1'
           ,'������1'
           ,2
           ,45.45
           ,5.45
           ,2),

           (9
           ,6
           ,'������-�������4'
           ,'�����1'
           ,'������1'
           ,1
           ,123.45
           ,468.45
           ,2),

           (10
           ,7
           ,'������-�������'
           ,'�����1'
           ,'������1'
           ,3
           ,45.45
           ,59.45
           ,2),

           (11
           ,8
           ,'������-�������'
           ,'�����1'
           ,'������1'
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