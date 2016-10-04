


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
        --todo:
        [_название распределения]   as budget.RetrieveTitle([DistributionId]), 
        [_название статьи]          as budget.RetrieveTitle([ExpenditureId]), 
        [Percentage]        NUMERIC(6, 5) NOT NULL, 
        CONSTRAINT [FK_DistributionsDetails_to_Distributions] FOREIGN KEY ([DistributionId]) REFERENCES [budget].[Distributions]([Id]),
        CONSTRAINT [FK_DistributionsDetails_to_Expenditure] FOREIGN KEY ([ExpenditureId]) REFERENCES [budget].[Expenditure]([Id]),
        CONSTRAINT [PK_DistributionsDetails] PRIMARY KEY ([DistributionId], [ExpenditureId]),
        CONSTRAINT [CK_DistributionsDetails_Column] CHECK (Percentage >= 0)
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
    FOR INSERT, UPDATE as begin return; end;');

end;

go

ALTER TRIGGER [budget].[Trigger_DistributionsDetails]
ON [budget].[DistributionsDetails]
FOR INSERT, UPDATE
AS
BEGIN

    set nocount on;

    declare @DistributionId uniqueidentifier;

    select top 1 @DistributionId = DistributionId
    from budget.DistributionsDetails
    group by DistributionId
    having sum(Percentage) > 1.0;

    if @DistributionId is not null
    begin
      rollback;

      return;

    end;

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
	    [Id]                UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(), 
	    [RegisteredAt]      DATETIME2(2) NOT NULL, 
        [Tool]              NCHAR(6) NOT NULL,
        Properties          XML NULL,
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

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--todo: триггер на budget.Budget - не позволяющий уводить суммы по статьям в минус
---------------------------------------------------------------------------------------------------

