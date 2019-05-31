
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/19/2017
-- Last modified by:		Joan Li
-- Description:				06/19/2017: Created based on V6 fn_Settlement_SelectList :  V7 USP44
--                          wrap up calling function fn_Settlement_SelectList
----JL:6/14/2017: checking and return data
----code calling: fnGetLanguageCode deployed
----data from tables: gisBaseReference;gisStringNameTranslation;gisSettlement
----select * from fn_Settlement_SelectList ('th') 
/*
----testing code:
execute usp_Settlement_GetList 'en'
execute usp_Settlement_GetList NULL  
----related fact data from
*/

--=====================================================================================================

CREATE  PROCEDURE [dbo].[usp_Settlement_GetList] (
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
as 
BEGIN

			IF @LangID is null
				RAISERROR (15600,-1,-1, 'usp_Settlement_GetList'); 
				--print 'doing nothing with wrong input'
			else if @LangID =''
				RAISERROR (15600,-1,-1, 'usp_Settlement_GetList'); 
				--print 'doing nothing with wrong input'
			else 
				BEGIN
					SELECT * FROM fn_Settlement_SelectList(@LangID)
				END


End
