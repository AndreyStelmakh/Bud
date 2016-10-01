
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_CATALOG = 'Distributions')
begin

	CREATE TABLE [budget].[Distributions]
	(
        [Id]        UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
        [Title]     NCHAR(24) NOT NULL
	);

end;


---------------------------------------------------------------
-- DistributionDetails //
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_CATALOG = 'DistributionsDetails')
begin

    CREATE TABLE [budget].[DistributionsDetails]
    (
        [DistributionId]    UNIQUEIDENTIFIER NOT NULL,
        [ExpenditureId]     UNIQUEIDENTIFIER NOT NULL, 
        [Percentage]        NUMERIC(5, 2) NOT NULL, 
        CONSTRAINT [FK_DistributionsDetails_to_Expenditure] FOREIGN KEY ([ExpenditureId]) REFERENCES [budget].[Expenditure]([Id]),
        PRIMARY KEY ([DistributionId], [ExpenditureId]),
        CONSTRAINT [CK_DistributionsDetails_Column] CHECK (1 = 1)
        --todo: проверка функцией
    );

end;


---------------------------------------------------------------
-- Earnings /регистрация доходов/
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_CATALOG = 'Earnings')
begin

    CREATE TABLE [budget].[Earnings]
    (
	    [Id] UNIQUEIDENTIFIER NOT NULL , 
	    [RegisteredAt] DATETIME2(2) NOT NULL, 
        [Tool] CHAR(3) NOT NULL, 
        PRIMARY KEY ([Id])
    );

end;


---------------------------------------------------------------
-- Expenditure /статьи бюджета/
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_CATALOG = 'Expenditure')
begin

    CREATE TABLE [dbo].[Expenditure]
    (
	    [Id]                    UNIQUEIDENTIFIER NOT NULL DEFAULT newid(), 
	    [Title]                 VARCHAR(100) NOT NULL, 
        [TargetValue]           decimal(10,4) NULL DEFAULT 0, 
        PRIMARY KEY ([Id]), 
    );

end;


---------------------------------------------------------------
-- Budget
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_CATALOG = 'Budget')
begin

    CREATE TABLE [budget].[Budget]
    (
	    [Id]                UNIQUEIDENTIFIER NOT NULL, 
	    [IncomeId]          UNIQUEIDENTIFIER NOT NULL, 
	    [ExpenditureId]     UNIQUEIDENTIFIER NOT NULL, 
        [Value]             decimal(10,4) NOT NULL, 
        PRIMARY KEY ([Id]), 
        CONSTRAINT [FK_Budget_to_Earnings] FOREIGN KEY ([IncomeId]) REFERENCES [budget].[Earnings]([Id]),
        CONSTRAINT [FK_Budget_to_Expenditure] FOREIGN KEY ([ExpenditureId]) REFERENCES [budget].[Expenditure]([Id])
    );

end;

