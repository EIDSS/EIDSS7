

--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/19/2017
-- Last modified by:		Joan Li
-- Description:				06/19/2017: Created based on V6 fn_Settlement_SelectList :  V7 USP50
--                          wrap up calling function fn_Statistic_SelectList
----JL:6/13/2017: checking and return data
----SELECT * FROM fn_Statistic_SelectList('ru')
/*
----testing code:
execute usp_Statistic_GetList 'en'
execute usp_Statistic_GetList NULL  ----invalid call

*/

--=====================================================================================================

CREATE  PROCEDURE	[dbo].[usp_Statistic_GetList](
		@LangID AS NVARCHAR(50)--##PARAM @LangID - language ID
)

AS
	BEGIN
				IF @LangID IS NULL
					RAISERROR (15600,-1,-1, 'usp_Statistic_GetListt'); 
					--print 'doing nothing with wrong input'
				ELSE IF @LangID =''
					RAISERROR (15600,-1,-1, 'usp_Statistic_GetListt'); 
					--print 'doing nothing with wrong input'
				ELSE 
					BEGIN
						SELECT * FROM fn_Statistic_SelectList(@LangID)
					END
	END

