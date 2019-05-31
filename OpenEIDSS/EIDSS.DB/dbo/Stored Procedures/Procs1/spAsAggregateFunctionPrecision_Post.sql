
CREATE PROCEDURE [dbo].[spAsAggregateFunctionPrecision_Post]
	@idfsAggregateFunction bigint,
	@intDefaultPrecision int
AS

update tasAggregateFunction
set
	intDefaultPrecision = @intDefaultPrecision
where idfsAggregateFunction = @idfsAggregateFunction

RETURN 0

