--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Get list of human case from function call: tlbHumanCase;tlbHuman;tlbGeoLocation;tstUserTable;tstSite;tstObjectAccess;tlbEmployeeGroupMember
--                          fn_HumanCase_SelectList;fnReferenceRepair;fnGeoLocationTranslation;fnDiagnosisDenied;fnSiteDenied
/*
----testing code:
execute usp_HumanCase_GetList 'en'
execute usp_HumanCase_GetList NULL  ----invalid call
----related fact data from
select * from fn_HumanCase_SelectList ('en')
*/
--=====================================================================================================

create	PROCEDURE	[dbo].[usp_HumanCase_GetList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)

as 
	BEGIN

				IF @LangID is null
					RAISERROR (15600,-1,-1, 'usp_HumanCase_GetList'); 
					--print 'doing nothing with wrong input'
				else if @LangID =''
					RAISERROR (15600,-1,-1, 'usp_HumanCase_GetList'); 
					--print 'doing nothing with wrong input'
				else 
					BEGIN
						SELECT * FROM fn_HumanCase_SelectList(@LangID)
					END


	End
