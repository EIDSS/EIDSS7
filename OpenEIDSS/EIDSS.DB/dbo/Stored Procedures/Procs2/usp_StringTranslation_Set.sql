

--=====================================================================================================
-- Created by:				Joan Li
-- Description:				
-- Revision History
--		Name       Date       Change Detail
--	    JL		   04/18/2017 Created based on V6 spStringTranslation_Post :  V7 USP 30
--		JL         04/26/2017 insert , update data in table:trtStringNameTranslation
--      JL         06/16/2017 only insert and update; no delete; no action input parameter 
--		JL         06/21/2017 table does have triggers handle delete,insert and update; add data modify date and user info
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO

-- Testing code:
/*
----testing code:
execute usp_StringTranslation_Set 51526770000000,'en','whatever','Halitosis',NULL   ----Halitosis

SELECT * from trtStringNameTranslation where idfsBaseReference =51526770000000
*/

--=====================================================================================================

CREATE   PROCEDURE [dbo].[usp_StringTranslation_Set] 

	@ReferenceID BIGINT, --##PARAM @ReferenceID - ID of base reference record
	@LangID  NVARCHAR(50), --##PARAM @LangID - language of translation
	@DefaultName VARCHAR(200), --##PARAM @DefaultName - translation in English
	@NationalName  NVARCHAR(200) --##PARAM @NationalName - translation in language defined by @LangID
	,@User VARCHAR(100)=NULL  --who required data change
AS

	----update  no matter which language? or just for en ?JL
	----get data change date and user info: before app send final user 
	DECLARE @DataChageInfo as nvarchar(max)
	select @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)
IF EXISTS(

		SELECT	idfsBaseReference 
		FROM	trtStringNameTranslation 
		WHERE	idfsBaseReference = @ReferenceID AND idfsLanguage = dbo.fnGetLanguageCode(@LangID))

	begin

		update	trtStringNameTranslation
		set		strTextString = @NationalName
				, strReservedAttribute = @DataChageInfo
		where 	
				idfsBaseReference = @ReferenceID 
				and idfsLanguage = dbo.fnGetLanguageCode(@LangID)
				and IsNull(@NationalName, N'') <> IsNull(strTextString, N'') COLLATE SQL_Latin1_General_CP1_CS_AS
	end
----insert
ELSE IF ISNULL(@NationalName,N'')<>N''

	BEGIN

		INSERT INTO trtStringNameTranslation(
			strTextString, 
			idfsLanguage, 
			idfsBaseReference
			, strReservedAttribute
			)
		VALUES(
			@NationalName, 
			dbo.fnGetLanguageCode(@LangID),
			@ReferenceID
			,@DataChageInfo
			)

	END

IF @LangID <> 'en' AND ISNULL(@DefaultName, N'') <> N''

	BEGIN ----startbnot english language and no defaultname
		----update
		IF EXISTS(
				SELECT	idfsBaseReference 
				FROM	trtStringNameTranslation 
				WHERE idfsBaseReference = @ReferenceID AND idfsLanguage = 10049003) --en
			BEGIN
				UPDATE	trtStringNameTranslation
				SET		strTextString = @DefaultName
						, strReservedAttribute = @DataChageInfo
				WHERE 	
						idfsBaseReference = @ReferenceID 
						AND idfsLanguage = 10049003 --en
						AND ISNULL(@DefaultName, N'') <> ISNULL(strTextString, N'')	 COLLATE SQL_Latin1_General_CP1_CS_AS
			END
		ELSE
			----insert 
			BEGIN
				INSERT INTO trtStringNameTranslation(
					strTextString, 
					idfsLanguage, 
					idfsBaseReference
					, strReservedAttribute
					)
				VALUES(
					@DefaultName, 
					10049003, --'en',
					@ReferenceID
					,@DataChageInfo
					)
			END
	END---- end not english language and no defaultname








