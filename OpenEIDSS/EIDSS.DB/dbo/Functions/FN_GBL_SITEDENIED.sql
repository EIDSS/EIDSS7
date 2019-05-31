--=====================================================================================================
-- Created by:				Joan Li
-- Created date:			06/20/2017
-- Last modified date:		11/30/2017
-- Last modified by:		Mandar Kulkarni
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by fn_HumanCase_SelectList ; data from tstLocalConnectionContext
--							11/30/2017: Upated to EIDSS7 Standards
/*
----testing code:
----related fact data from
select * from FN_GBL_SITEDENIED
*/
--=====================================================================================================

CREATE FUNCTION [dbo].[FN_GBL_SITEDENIED]()
RETURNS BIT
AS
BEGIN
	DECLARE @blnSiteDenied BIT

	SELECT	@blnSiteDenied = blnSiteDenied
	FROM	tstLocalConnectionContext
	WHERE	strConnectionContext = dbo.fnGetContext()
	
	RETURN ISNULL(@blnSiteDenied,0)
END


