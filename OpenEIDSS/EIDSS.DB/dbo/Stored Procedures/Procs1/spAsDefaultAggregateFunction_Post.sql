
CREATE PROCEDURE [dbo].[spAsDefaultAggregateFunction_Post]
	@idfsSearchField bigint,
	@idfsDefaultAggregateFunction bigint
AS
	update tasSearchField 
	set idfsDefaultAggregateFunction = @idfsDefaultAggregateFunction
	where idfsSearchField = @idfsSearchField
RETURN 0

