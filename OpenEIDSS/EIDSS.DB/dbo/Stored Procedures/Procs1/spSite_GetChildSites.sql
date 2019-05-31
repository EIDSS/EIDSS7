





--##SUMMARY Returns record sites that are children of passed site.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.02.2010

--##RETURNS doesn't use



/*
--Example of procedure call:

DECLARE @SiteID bigint
SET @SiteID = 1101
EXECUTE spSite_GetChildSites
   @SiteID


*/


CREATE          PROCEDURE dbo.spSite_GetChildSites (
	@SiteID AS BIGINT--##PARAM @SiteID  - site ID
)

AS

SELECT TOP 1
		s.idfsSite
FROM	tstSite s
inner join tstSite parent on
	s.idfsParentSite = parent.idfsSite
	and parent.intRowStatus = 0
WHERE
	s.idfsParentSite = @SiteID
	and parent.blnIsWEB <> 1
	and s.intRowStatus = 0




