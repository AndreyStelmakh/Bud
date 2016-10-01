


---------------------------------------------------------------
-- Expenditure /статьи бюджета/
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_NAME = 'Expenditure')
begin

    CREATE TABLE [budget].[Expenditure]
    (
	    [Id]                    UNIQUEIDENTIFIER NOT NULL DEFAULT newid(), 
	    [Title]                 NVARCHAR(100) NOT NULL, 
        [Properties]            xml NULL, 
        PRIMARY KEY ([Id]), 
    );

end;



---------------------------------------------------------------
-- Distributions /распределение дохода по статьям/
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_NAME = 'Distributions')
begin

	CREATE TABLE [budget].[Distributions]
	(
        [Id]        UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() PRIMARY KEY, 
        [Title]     NVARCHAR(24) NOT NULL
	);

end;


---------------------------------------------------------------
-- DistributionDetails //
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_NAME = 'DistributionsDetails')
begin

    CREATE TABLE [budget].[DistributionsDetails]
    (
        [DistributionId]    UNIQUEIDENTIFIER NOT NULL,
        [ExpenditureId]     UNIQUEIDENTIFIER NOT NULL, 
        [Percentage]        NUMERIC(5, 5) NOT NULL, 
        CONSTRAINT [FK_DistributionsDetails_to_Expenditure] FOREIGN KEY ([ExpenditureId]) REFERENCES [budget].[Expenditure]([Id]),
        PRIMARY KEY ([DistributionId], [ExpenditureId]),
    );


end;


---------------------------------------------------------------
-- Суммарный перцентаж не более 1 (100%)
---------------------------------------------------------------
if not exists(
        select 1
        from sys.objects
        where name = 'Trigger_DistributionsDetails' )
begin

    exec ('create trigger [budget].[Trigger_DistributionsDetails]
    ON [budget].[DistributionsDetails]
    INSTEAD OF INSERT, UPDATE as begin return; end;');

end;

go

ALTER TRIGGER [budget].[Trigger_DistributionsDetails]
ON [budget].[DistributionsDetails]
INSTEAD OF INSERT, UPDATE
AS
BEGIN

    set nocount on;

    select distinct inserted.DistributionId
    from inserted;
    --todo:

    if 1 = 0 throw 5234224, 'Distribution percentage overflow', 0;


    insert into budget.DistributionsDetails
    select *
    from inserted;

    update budget.DistributionsDetails
    set [Percentage] = inserted.[Percentage]
    from budget.DistributionsDetails D
    inner join inserted on inserted.DistributionId = D.DistributionId
                        and inserted.ExpenditureId = D.ExpenditureId;

END

go

---------------------------------------------------------------
-- Earnings /регистрация доходов/
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_NAME = 'Earnings')
begin

    CREATE TABLE [budget].[Earnings]
    (
	    [Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(), 
	    [RegisteredAt] DATETIME2(2) NOT NULL, 
        [Tool] NCHAR(6) NOT NULL, 
        PRIMARY KEY ([Id])
    );

end;



---------------------------------------------------------------
-- Budget
---------------------------------------------------------------
if not exists(
        select 1
        from INFORMATION_SCHEMA.TABLES
        where TABLE_SCHEMA = 'budget'
          and TABLE_NAME = 'Budget')
begin

    CREATE TABLE [budget].[Budget]
    (
	    [IncomeId]          UNIQUEIDENTIFIER NOT NULL, 
	    [ExpenditureId]     UNIQUEIDENTIFIER NOT NULL, 
        [Value]             decimal(10,4) NOT NULL, 
        PRIMARY KEY ([IncomeId], [ExpenditureId]), 
        CONSTRAINT [FK_Budget_to_Earnings] FOREIGN KEY ([IncomeId]) REFERENCES [budget].[Earnings]([Id]),
        CONSTRAINT [FK_Budget_to_Expenditure] FOREIGN KEY ([ExpenditureId]) REFERENCES [budget].[Expenditure]([Id])
    );

end;

