INSERT INTO dbo.Client ( Fio , Created)
VALUES
( N'������1' , GETDATE()-15),
( N'������2' , GETDATE()-3),
( N'������3' , GETDATE()),
( N'������4' , GETDATE()),
( N'������5' , GETDATE())
GO

INSERT INTO dbo.SecurityPaper ( Name )
VALUES
( N'��1'),
( N'��2'),
( N'��3'),
( N'��4'),
( N'��5')
GO

INSERT INTO dbo.Deal
        ( Type ,
          DealDate ,
          ClientID ,
          SecurityPaperID ,
          Count ,
          Summ
        )
VALUES  ( N'SELL' ,
          GETDATE() ,
          1 ,
          5 ,
          10 ,
          77.88
        ),
        ( N'SELL' ,
          GETDATE()-15 ,
          2 ,
          4 ,
          5 ,
          45.98
        ),
        ( N'BUY' ,
          GETDATE()-3 ,
          2 ,
          3 ,
          6 ,
          45
        ),
        ( N'SELL' ,
          GETDATE()-4 ,
          5 ,
          2 ,
          7 ,
          1000000
        ),
        ( N'BUY' ,
          GETDATE()-30 ,
          3 ,
          1 ,
          3 ,
          77
        ),
        ( N'BUY' ,
          GETDATE() ,
          1 ,
          5 ,
          76789 ,
          55.66
        ),
        ( N'SELL' ,
          GETDATE()-20 ,
          4 ,
          1 ,
          7 ,
          100
        ),
        ( N'SELL' ,
          GETDATE()-2 ,
          1 ,
          2 ,
          8 ,
          1000
        ),
        ( N'BUY' ,
          GETDATE()-7 ,
          1 ,
          3 ,
          3 ,
          10
        ),
        ( N'SELL' ,
          GETDATE()-18 ,
          4 ,
          5 ,
          7000 ,
          200.5
        ),
        ( N'SELL' ,
          GETDATE()-17 ,
          4 ,
          5 ,
          700 ,
          200.5
        ),
        ( N'SELL' ,
          GETDATE()-10 ,
          4 ,
          5 ,
          700 ,
          20.5
        ),
        ( N'SELL' ,
          GETDATE()-1 ,
          4 ,
          5 ,
          70 ,
          20.5
        )