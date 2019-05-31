

--##SUMMARY This procedure 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spCaseTypeSelectLookup 'en'

*/ 
 
create PROCEDURE [dbo].[spCaseTypeSelectLookup]
	@LangID			as varchar(36)
AS
BEGIN
	select distinct
		r.idfsReference, 
		r.[name],
		r.intOrder  
		from		fnReferenceRepair(@LangID, 19000012) r
		where		r.idfsReference in
					(	
						10012001,	-- Human
						10012003,	-- Livestock
						10012004,	-- Avian
						10012005,	-- Veterinary
						10012006	-- Vector
					)
		order by	r.intOrder, r.[name], r.idfsReference

END

