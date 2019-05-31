
-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select Local reference with translations on corresponding language.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.03.2010

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from fnLocalReference('ru')

*/

CREATE       function [dbo].[fnLocalReference](@LangID nvarchar(50))
returns table
as
return(

select
			tReference.idflBaseReference,
			IsNull(tCurrentTranslation.strTextString, tEnglishTranslation.strTextString) as strName,
			tEnglishTranslation.strTextString as strEnglishName

	  from	dbo.locBaseReference		 as tReference 
	  
 left join	dbo.locStringNameTranslation as tEnglishTranslation 
		on	tReference.idflBaseReference = tEnglishTranslation.idflBaseReference 
	   and	tEnglishTranslation.idfsLanguage = dbo.fnGetLanguageCode('en')
	   
 left join	dbo.locStringNameTranslation as tCurrentTranslation 
		on	tReference.idflBaseReference = tCurrentTranslation.idflBaseReference 
	   and	tCurrentTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
)




