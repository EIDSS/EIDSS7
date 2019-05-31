
-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select  BaseReferenceCode for languages. BaseReferenceCode can be used in [fnGetLanguageCode]
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.11.2010
--##REMARKS Updated by: Vasilyev I.
--##REMARKS Update date: 25.01.2012

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from fnBaseReferenceCode()

*/

create       function fnBaseReferenceCode()
returns table
as
return(

	select		strBaseReferenceCode
	from		trtBaseReference	
	where		idfsReferenceType = 19000049
	and			intRowStatus = 0	
)




