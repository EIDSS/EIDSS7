--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 fn_UserGroup_SelectList: wrap up function call
--                          Input: lang id; Output: N/A
--                          05/02/2017: change name to: usp_UserGroup_GetList

-- Testing code:
/*
----testing code:
DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_UserGroup_GetList]
		@LangID = N'en'
*/

--=====================================================================================================

CREATE  PROCEDURE [dbo].[usp_UserGroup_GetList]
(

@LangID as nvarchar(50)
)
as

		declare @l_langid nvarchar(50)
		select @LangID='en'
		IF @LangID is null
			RAISERROR (15600,-1,-1, 'usp_UserGroup_GetList'); 
			--print 'doing nothing with wrong input'
		else if @LangID =''
			RAISERROR (15600,-1,-1, 'usp_UserGroup_GetList'); 
			--print 'doing nothing with wrong input'
		else 
			BEGIN
				select @l_langid =@LangID
				----print 'get list'
				SELECT * FROM fn_UserGroup_SelectList ('@l_langid')
			END



