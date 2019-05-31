


--##SUMMARY This procedure is called when case is posted. It check if case outbreak was changed and clears outbreak idfPrimaryCase field if this case was selected as primary for outbreak.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:


EXECUTE spOutbreak_CheckPrimaryCase
   750650000000
  ,NULL

*/
CREATE PROCEDURE [dbo].[spOutbreak_CheckPrimaryCase]
	@idfCase bigint, --##PARAM @idfCase - case ID that should be checked for primary
	@idfOutbreak bigint --##PARAM @idfOutbreak - new value of outbreak ID
AS
	
	UPDATE tlbOutbreak
	SET 
		idfPrimaryCaseOrSession = NULL
	WHERE 
		(@idfOutbreak IS NULL OR idfOutbreak <> @idfOutbreak)
		AND idfPrimaryCaseOrSession = @idfCase
		AND intRowStatus <> 1


