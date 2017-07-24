
if schema_id('budget') is null
  exec('create schema budget;');
go


if object_id('budget.[RetrieveTitle]') is null
	exec ('create function budget.[RetrieveTitle] returns int as return 0;')
go

alter function [budget].[RetrieveTitle]
(
    @Id uniqueidentifier
)
RETURNS NVARCHAR(max)
AS
BEGIN

    declare @Title nvarchar(max);

    select @Title = Title
    from budget.Expenditure
    where Id = @Id;

    if @Title is not null return @Title;


    select @Title = Title
    from budget.Distributions
    where Id = @Id;

    return @Title;

END

go




if object_id('budget.Stats') is null
	exec ('create proc budget.Stats as return;')
go

alter procedure budget.Stats
as
begin

  set nocount off;



---------------------------------------------------
--
---------------------------------------------------

  with AMOUNTS as
  (
    select    B.ExpenditureId,
              RN.Tool,
              Sum(B.Value) Amount
    
    from budget.Budget B
      inner join budget.Earnings RN on RN.Id = B.IncomeId

    group by  RN.Tool,
              B.ExpenditureId
  )
  select X.Title ExpenditureTitle,
         Tool,
         Amount
  from AMOUNTS
    inner join budget.Expenditure X on X.Id = AMOUNTS.ExpenditureId;



---------------------------------------------------
--
---------------------------------------------------

  select RN.Tool,
         Sum(B.Value) Amount

  from budget.Budget B
    inner join budget.Expenditure X on X.Id = B.ExpenditureId
    inner join budget.Earnings RN on RN.Id = B.IncomeId

  group by RN.Tool;





---------------------------------------------------
--
---------------------------------------------------

  with P as
  (
    select DistributionId,
           Sum([Percentage]) [Percentage]
    from budget.DistributionsDetails DD
      --inner join budget.Distributions D on D.Id = DD.DistributionId
    group by DD.DistributionId
  )
  select D.Title DistributionTitle,
         P.[Percentage]
  from P
    inner join budget.Distributions D on D.Id = P.DistributionId;



end;


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
if object_id('budget.DoPayment') is null
	exec ('create proc budget.DoPayment as return;')
go

alter procedure budget.DoPayment
  @Value         decimal(10, 2),
  @Tool          nchar(6),
  @ExpenditureId uniqueidentifier,
  @RegisterOn    datetime2(2) = null
as
begin

  set @RegisterOn = isnull(@RegisterOn, GetDate());

  declare @IncomeId uniqueidentifier = NEWID();


  begin try
    begin tran

    insert into budget.Earnings (Id, Tool, RegisteredAt)
    values (@IncomeId, @Tool, @RegisterOn);


    insert into budget.Budget (IncomeId, ExpenditureId, Value)
    values (@IncomeId, @ExpenditureId, @Value);

    commit;

  end try
  begin catch

    rollback;

  end catch;

  return;

end;


---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
if object_id('budget.DoPaymentWithDistribution') is null
	exec ('create proc [budget].[DoPaymentWithDistribution] as return;')
go

alter procedure [budget].[DoPaymentWithDistribution]
  @Value          decimal(10,2),
  @DistributionId uniqueidentifier
as
begin
  if @Value <= 0
    return;

  --todo:

  return;

end;



---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------
if object_id('budget.CancelPayment') is null
	exec ('create proc budget.CancelPayment as return;')
go

alter procedure budget.CancelPayment
  @IncomeId uniqueidentifier
as
begin

  -- budget.Budget configured with cascaded update
  delete from budget.Earnings
  where Id = @IncomeId;

  return;

end;





