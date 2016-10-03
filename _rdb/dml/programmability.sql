



create function [budget].[RetrieveTitle]
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
	exec ('create proc budget.Stats as begin return end')
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

