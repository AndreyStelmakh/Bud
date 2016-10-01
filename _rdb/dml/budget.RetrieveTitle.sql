



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
