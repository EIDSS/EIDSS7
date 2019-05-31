
/*
--*************************************************************
-- Name 				: FN_GBL_USERID_GET
-- Description			: Funtion to return userid 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
--*************************************************************
*/

CREATE function [dbo].[FN_GBL_USERID_GET]()
RETURNS BIGINT
AS
BEGIN

	DECLARE @user BIGINT
	SELECT	@user = idfUserID 
	FROM	tstLocalConnectionContext
	WHERE	strConnectionContext = dbo.FN_GBL_CONTEXT_GET()

	IF  @user is null
		BEGIN
			SELECT	@user = idfUserID from tstUserTable 
			WHERE	strAccountName = SUSER_NAME()
			AND		idfsSite = dbo.FN_GBL_SITEID_GET()
		END

	RETURN @user
END



