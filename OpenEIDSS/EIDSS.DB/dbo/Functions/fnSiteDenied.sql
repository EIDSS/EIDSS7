--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by fn_HumanCase_SelectList ; data from tstLocalConnectionContext
/*
----testing code:
----related fact data from
select * from fnSiteDenied
*/
--=====================================================================================================

CREATE FUNCTION [dbo].[fnSiteDenied]()
RETURNS BIT
AS
	BEGIN
		declare @blnSiteDenied bit
		select @blnSiteDenied = blnSiteDenied
		from tstLocalConnectionContext
		where strConnectionContext = dbo.fnGetContext()
	
		RETURN ISNULL(@blnSiteDenied,0)
	END


