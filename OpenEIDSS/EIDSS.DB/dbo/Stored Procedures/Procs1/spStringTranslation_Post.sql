


--##SUMMARY Posts base reference transalation to database.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @ReferenceID bigint
DECLARE @LangID nvarchar(50)
DECLARE @DefaultName varchar(200)
DECLARE @NationalName nvarchar(200)

EXECUTE spStringTranslation_Post
   @ReferenceID
  ,@LangID
  ,@DefaultName
  ,@NationalName
*/

CREATE   PROCEDURE dbo.spStringTranslation_Post 
	@ReferenceID bigint, --##PARAM @ReferenceID - ID of base reference record
	@LangID  nvarchar(50), --##PARAM @LangID - language of translation
	@DefaultName varchar(200), --##PARAM @DefaultName - translation in English
	@NationalName  nvarchar(200) --##PARAM @NationalName - translation in language defined by @LangID
as
if exists(
		select	idfsBaseReference 
		from	trtStringNameTranslation 
		where	idfsBaseReference = @ReferenceID and idfsLanguage = dbo.fnGetLanguageCode(@LangID))
begin
	update	trtStringNameTranslation
	set		strTextString = @NationalName
	where 	
			idfsBaseReference = @ReferenceID 
			and idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			and IsNull(@NationalName, N'') <> IsNull(strTextString, N'') COLLATE SQL_Latin1_General_CP1_CS_AS
end
else if ISNULL(@NationalName,N'')<>N''
begin
	insert into trtStringNameTranslation(
		strTextString, 
		idfsLanguage, 
		idfsBaseReference
		)
	values(
		@NationalName, 
		dbo.fnGetLanguageCode(@LangID),
		@ReferenceID
		)
end
if @LangID <> 'en' and IsNull(@DefaultName, N'') <> N''
	if exists(
			select	idfsBaseReference 
			from	trtStringNameTranslation 
			where idfsBaseReference = @ReferenceID and idfsLanguage = 10049003) --en
	begin
		update	trtStringNameTranslation
		set		strTextString = @DefaultName
		where 	
				idfsBaseReference = @ReferenceID 
				and idfsLanguage = 10049003 --en
				and IsNull(@DefaultName, N'') <> IsNull(strTextString, N'')	 COLLATE SQL_Latin1_General_CP1_CS_AS
	end
	else
	begin
		insert into trtStringNameTranslation(
			strTextString, 
			idfsLanguage, 
			idfsBaseReference
			)
		values(
			@DefaultName, 
			10049003, --'en',
			@ReferenceID
			)
	end




