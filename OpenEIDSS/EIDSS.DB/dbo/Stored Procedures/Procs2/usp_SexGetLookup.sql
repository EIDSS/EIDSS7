--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 spSexSelectLookup :  V7 USP69
--                          wrap up a funciton call: fnReference
/*
----testing code:
exec usp_SexGetLookup 'en'
----related fact data from
select * from fnReference(@LangID, 19000043)
*/
--=====================================================================================================
 
CREATE PROCEDURE [dbo].[usp_SexGetLookup]
	@LangID	as nvarchar(50)
AS
	BEGIN
		select * from fnReference(@LangID, 19000043)
	END


