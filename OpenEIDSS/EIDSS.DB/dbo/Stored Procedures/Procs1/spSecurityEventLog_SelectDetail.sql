

--##SUMMARY Selects data for DerivativeForSampleType form

--##REMARKS Author: Ivan Vasilyev.
--##REMARKS Create date: 16.09.2011

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spSecurityEventLog_SelectDetail

*/

CREATE  PROCEDURE dbo.spSecurityEventLog_SelectDetail
		@idfSecurityAudit as bigint,
		@LangID as nvarchar(50)
AS
 
	 SELECT * FROM [dbo].[fn_SecurityEventLog_SelectList] (@LangID)
	 









