
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/21/2017
-- Last modified by:		Joan Li
-- Description:				Created a new SP to wrap a function direct called from EIDSS app in v6
--                          Input: language ID; Output: N/A  
--                          Hard delete records from 4 tables
-- Testing code:
/*
DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_PersonGetList]
		@LangID = 'en' ----'' ----NULL
*/

--=====================================================================================================
--##SUMMARY Selects list of employees for PersonList form
--##REMARKS Author: Zurin M.
--##REMARKS Update date: 19.01.2010
--##RETURNS Doesn't use

CREATE PROCEDURE [dbo].[usp_PersonGetList]

(
	@LangID AS NVARCHAR(50) ---- language ID

)

AS
BEGIN
		declare @l_langid nvarchar(50)
		IF @LangID is null
			RAISERROR (15600,-1,-1, 'usp_PersonGetList'); 
			--print 'doing nothing with wrong input'
		else if @LangID =''
			RAISERROR (15600,-1,-1, 'usp_PersonGetList'); 
			--print 'doing nothing with wrong input'
		else 
			BEGIN
				select @l_langid =@LangID
				SELECT * FROM fn_Person_SelectList('@l_langid')
			END



END
