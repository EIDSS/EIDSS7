





--##SUMMARY Returns record with Site ID of site that is parent of passed site .

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.02.2010

--##RETURNS doesn't use



/*
--Example of procedure call:

DECLARE @SiteID bigint
SET @SiteID = 2
EXECUTE spSite_GetParentSite
   @SiteID


*/


CREATE          PROCEDURE dbo.spSite_GetParentSite (
	@SiteID AS BIGINT--##PARAM @SiteID  - site ID
)

AS

SELECT TOP 1
		idfsParentSite
FROM	tstSite
WHERE
	idfsSite = @SiteID
	and intRowStatus = 0






