

--*************************************************************
-- Name 				: usp_Organization_Set
-- Description			: ISatistical Data List
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--      JL         05/16/2018 change to valide function FN_GBL_DATACHANGE_INFO
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[usp_Organization_Set] 

	@idfOffice					BIGINT
	,@EnglishName				NVARCHAR(200)
	,@name						NVARCHAR(200)
	,@EnglishFullName			NVARCHAR(200)
	,@FullName					NVARCHAR(200)
	,@idfLocation				BIGINT
	,@strContactPhone			NVARCHAR(200)
	,@idfsCurrentCustomization	BIGINT			= NULL
	,@intHACode					INT
	,@strOrganizationID			NVARCHAR(100)
	,@LangID					NVARCHAR(50)
	,@intOrder					INT
	,@User						VARCHAR(100)	= NULL  --who required data change
	,@idfOfficeNewID			BIGINT OUTPUT			--return id

AS

	DECLARE @LogErrMsg VARCHAR(MAX)
	SELECT @LogErrMsg = ''

	BEGIN TRY  	

		/*
		MD: Should we be using XACT_STATE() 
			We can check this in the CATCH block
		*/
		BEGIN TRANSACTION

		----get data change date and user info: before app send final user 
		DECLARE @DataChageInfo AS NVARCHAR(MAX)
		
		--MD: Redundant check as the function fnzDBdatachageDatePerson will return SYSTEM_USER, is @user is NULL
		--IF @user =0 SELECT  @user=NULL
		/*
		MD: fnzDBdatachageDatePerson uses date format for US
			Do we need to localize it for country?
		*/
		SELECT @DataChageInfo = dbo.FN_GBL_DATACHANGE_INFO (@User)
		
		IF ISNULL(@strOrganizationID, N'') <> N''

			BEGIN
				IF EXISTS (SELECT * FROM tlbOffice WHERE strOrganizationID = @strOrganizationID AND idfOffice <> @idfOffice AND intRowStatus = 0)
					RAISERROR ('errNonUniqueOrganizationID', 16, 1)
			END

			DECLARE @idfsOfficeName			BIGINT
			DECLARE @idfsOfficeAbbreviation BIGINT
			DECLARE @NewRecord				BIT

			SELECT 
				@idfsOfficeName = idfsOfficeName
				,@idfsOfficeAbbreviation = idfsOfficeAbbreviation
			FROM 
				tlbOffice 
			WHERE 
				idfOffice = @idfOffice

			IF @@ROWCOUNT=0

				BEGIN
					exec usp_sysGetNewID @idfsOfficeName OUTPUT
					exec usp_sysGetNewID @idfsOfficeAbbreviation OUTPUT
					SET @NewRecord = 1
				END
	
			--MD: Validate the customization package before saving
			BEGIN
				SELECT		
					*
				FROM 
					tstGlobalSiteOptions
				WHERE 
					strName = 'CustomizationPackage'
					And
					strValue = ISNULL(@idfsCurrentCustomization, 0)

				IF @@ROWCOUNT = 0
					BEGIN
						SET @idfsCurrentCustomization = dbo.fnCustomizationPackage()
					END
			END

			--MD: Although the EIDSS SQL is not case sensitive, as best practices, compare string with proper case
			IF UPPER(@LangID) = 'EN'
				BEGIN
					SET @EnglishName = @name
					SET @EnglishFullName = @FullName 
				END

			EXEC usp_BaseReference_SysSet @idfsOfficeName, 19000046, @LangID, @EnglishFullName, @FullName, 0, NULL, NULL, @User			--'rftInstitutionName'
			EXEC usp_BaseReference_SysSet @idfsOfficeAbbreviation, 19000045, @LangID, @EnglishName, @name, 0, @intOrder, NULL, @User	--'rftInstitutionAbbr'

			IF (@NewRecord = 1)

				BEGIN
					IF (@idfOffice IS NULL)
						exec usp_sysGetNewID @idfOffice OUTPUT	

					INSERT INTO tlbOffice
						(
						idfOffice
						,idfsOfficeName
						,idfsOfficeAbbreviation
						,idfCustomizationPackage
						,idfLocation
						,idfsSite
						,strContactPhone
						,intHACode
						,strOrganizationID
						,strReservedAttribute
						)
					VALUES
						(
						@idfOffice
						,@idfsOfficeName
						,@idfsOfficeAbbreviation
						,@idfsCurrentCustomization
						,@idfLocation
						,dbo.fnSiteID()
						,@strContactPhone
						,@intHACode
						,@strOrganizationID
						,@DataChageInfo
						)
				END

			ELSE

				BEGIN
					UPDATE 
						tlbOffice
					SET 
						strContactPhone = @strContactPhone,
						idfLocation = @idfLocation,
						intHACode = @intHACode,
						strOrganizationID = @strOrganizationID
						,strReservedAttribute = @DataChageInfo
					WHERE
						idfOffice = @idfOffice

				END

		COMMIT  

		--MD: Return new office ID		
		SELECT @idfOfficeNewID = @idfOffice

		SET @LogErrMsg='Success' 
		SELECT @idfOfficeNewID, @LogErrMsg 

	END TRY  

	BEGIN CATCH  

		-- Execute error retrieval routine. 
		IF @@TRANCOUNT = 0
			--MD: Not sure what to return. But we need a result set to be returned
			BEGIN
				
				SELECT @idfOfficeNewID = -1
				SET @LogErrMsg = '' 
				SELECT @idfOfficeNewID, @LogErrMsg 
				
				RETURN
			END

		IF @@TRANCOUNT > 0

			BEGIN
				ROLLBACK

				SELECT @idfOfficeNewID = -1
				SET @LogErrMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
				SELECT @idfOfficeNewID, @LogErrMsg
			END

	END CATCH; 


