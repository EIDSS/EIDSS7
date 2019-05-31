
CREATE FUNCTION [dbo].[fn_VetAggregateCaseDeduplication_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
RETURNS TABLE
AS
RETURN 
	SELECT * FROM fnAggregate_FindDuplicates(@LangID, 10102002)


