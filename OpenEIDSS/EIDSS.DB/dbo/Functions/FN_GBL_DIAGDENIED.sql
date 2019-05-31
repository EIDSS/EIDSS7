--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		11/30/2017
-- Last modified by:		Mandar Kulkarni
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by SP ; from table:tstLocalConnectionContext
--							11/30/2017: Upated to EIDSS7 Standards
/*
----testing code:
----related fact data from
select * from FN_GBL_DIAGDENIED 
*/
--=====================================================================================================

CREATE FUNCTION [dbo].[FN_GBL_DIAGDENIED]()
RETURNS BIT
AS
BEGIN
	
	DECLARE @blnDiagnosisDenied BIT

	SELECT	@blnDiagnosisDenied = blnDiagnosisDenied
	FROM	tstLocalConnectionContext
	WHERE	strConnectionContext = dbo.fnGetContext()
	
	RETURN ISNULL(@blnDiagnosisDenied,0)

END


