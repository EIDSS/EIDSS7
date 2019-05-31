

--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/26/2017
-- Last modified by:		Joan Li
-- Description:				4/18/2017:Created based on V6 spBaseReference_SysPost: V7 USP 38
-- Revision History
--		Name       Date       Change Detail
--      JL         4/26/2017  insert data (only 6 from 11) into table: trtBaseReference
--      JL         06/16/2017 there is no action and only insert and update functional code:may need to revisit.
--                            this SP call: usp_sysBaseReferenceToCP_Set;usp_StringTranslation_Set 
--                            table does have triggers handle delete,insert and update; add data modify date and user info
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--


/*
----testing code:
exec usp_BaseReference_SysSet 55459240000000,19000063,'en',NULL,NULL,NULL,NULL,NULL,NULL
exec usp_BaseReference_SysSet 55459240000000,19000063,'en',NULL,NULL,NULL,NULL,NULL,'Lij'
select * from trtBaseReference where idfsbasereference=55459240000000
select * from trtBaseReference where idfsreferencetype in (19000046,19000045)
*/

--=====================================================================================================
--##SUMMARY Allows to create new reference or change the parameters of the existing one
--##SUMMARY If NULL is passed as @DefaultName, @NationalName,  @HACode or @Order parameter, the corresponded field value in 
--##SUMMARY trtBaseReference table is not changed.


CREATE PROCEDURE [dbo].[usp_BaseReference_SysSet] 

	@ReferenceID BIGINT, --##PARAM @ReferenceID - reference ID
	@ReferenceType BIGINT, --##PARAM @ReferenceType - reference Type ID
	@LangID  NVARCHAR(50), --##PARAM @LangID - language ID
	@DefaultName VARCHAR(200), --##PARAM @DefaultName - default reference name, used if there is no refernece translation
	@NationalName  NVARCHAR(200), --##PARAM @NationalName - reference name in the language defined by @LangID
	@HACode INT = NULL, --##PARAM @HACode - bit mask for reference using
	@Order INT = NULL, --##PARAM @Order - reference record order for sorting
	@System BIT = 0 --##PARAM @System
	,@User VARCHAR(100)=NULL  --who required data change

AS

BEGIN
	----get data change date and user info: before app send final user 
	DECLARE @DataChageInfo as nvarchar(max)
	select @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)
	----update
	IF EXISTS (SELECT idfsBaseReference FROM trtBaseReference WHERE idfsBaseReference = @ReferenceID )
		BEGIN
			UPDATE trtBaseReference
			SET
				idfsReferenceType = @ReferenceType, 
				strDefault = ISNULL(@DefaultName,strDefault),
				intHACode = ISNULL(@HACode,intHACode),
				intOrder = ISNULL(@Order,intOrder),
				blnSystem = ISNULL(@System,blnSystem)
				,strReservedAttribute= @DataChageInfo  --who and when update data
			WHERE 
				idfsBaseReference = @ReferenceID
 				--AND ISNULL(strDefault,N'')<>ISNULL(@DefaultName,N'')	
		END

	ELSE
		----insert
		BEGIN
			INSERT INTO trtBaseReference(
				idfsBaseReference, 
				idfsReferenceType, 
				intHACode, 
				strDefault,
				intOrder,
				blnSystem
				,strReservedAttribute
				)
			VALUES(
				@ReferenceID, --idfsBaseReference
				@ReferenceType, --idfsReferenceType
				@HACode, --intHACode
				@DefaultName, --strDefault
				@Order,
				@System
				,@DataChageInfo  --who and when insert data
			)

			DECLARE @idfCustomizationPackage BIGINT

			SELECT @idfCustomizationPackage = dbo.fnCustomizationPackage()

			IF @idfCustomizationPackage IS NOT NULL AND @idfCustomizationPackage <> 51577300000000 --The USA

			BEGIN

				EXEC usp_sysBaseReferenceToCP_Set @ReferenceID, @idfCustomizationPackage, @User

			END

		END

	IF (@LangID=N'en')

		BEGIN
			IF EXISTS(SELECT idfsBaseReference FROM trtStringNameTranslation WHERE idfsBaseReference=@ReferenceID AND idfsLanguage=dbo.fnGetLanguageCode(N'en'))
			EXEC usp_StringTranslation_Set @ReferenceID, @LangID, @DefaultName, @DefaultName
		END

	ELSE
		BEGIN
			EXEC usp_StringTranslation_Set @ReferenceID, @LangID, @DefaultName, @NationalName
		END

END












