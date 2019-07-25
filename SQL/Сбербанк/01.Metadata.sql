-- (1) клиенты
CREATE TABLE [dbo].[Client]
(
    [ID]        [BIGINT]        NOT NULL IDENTITY(1, 1),
    [FIO]       [NVARCHAR](256) NOT NULL,
    [Created]   [DATETIME]      NOT NULL CONSTRAINT [DF_Client] DEFAULT (GETDATE()),
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Client] ADD CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

-- (2) ценные бумаги
CREATE TABLE [dbo].[SecurityPaper]
(
    [ID]    [BIGINT]        NOT NULL IDENTITY(1, 1),
    [Name]  [NVARCHAR](256) NOT NULL,
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SecurityPaper] ADD CONSTRAINT [PK_SecurityPaper] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO

-- (3) сделки
CREATE TABLE [dbo].[Deal]
(
    [ID]                [BIGINT]            NOT NULL IDENTITY(1, 1),
    [Type]              [NVARCHAR](4)       NOT NULL CHECK ([Type] IN ('BUY', 'SELL')),
    [DealDate]          [DATETIME]          NOT NULL CONSTRAINT [DF_Deal] DEFAULT (GETDATE()),
    [ClientID]          [BIGINT]            NOT NULL,
    [SecurityPaperID]   [BIGINT]            NOT NULL,
    [Count]             [BIGINT]            NOT NULL,
    [Summ]              [DECIMAL](18, 2)    NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Deal] ADD CONSTRAINT [PK_Deal] PRIMARY KEY CLUSTERED ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Deal] ADD CONSTRAINT [FK_Deal_ClientID] FOREIGN KEY ([ClientID]) REFERENCES [dbo].[Client] ([ID])
GO
ALTER TABLE [dbo].[Deal] ADD CONSTRAINT [FK_Deal_SecurityPaperID] FOREIGN KEY ([SecurityPaperID]) REFERENCES [dbo].[SecurityPaper] ([ID])
GO