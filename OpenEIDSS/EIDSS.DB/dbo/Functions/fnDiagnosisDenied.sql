--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by SP ; from table:tstLocalConnectionContext
/*
----testing code:
----related fact data from
select * from fnDiagnosisDenied 
*/
--=====================================================================================================

CREATE FUNCTION [dbo].[fnDiagnosisDenied]()
RETURNS BIT
AS
	BEGIN
		declare @blnDiagnosisDenied bit
		select @blnDiagnosisDenied = blnDiagnosisDenied
		from tstLocalConnectionContext
		where strConnectionContext = dbo.fnGetContext()
	
		RETURN ISNULL(@blnDiagnosisDenied,0)
	END


