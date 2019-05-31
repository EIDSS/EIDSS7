
--*************************************************************
-- Name 				: USP_ADMIN_STLE_Set
-- Description			: Insert/Update Settlement data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USP_ADMIN_STLE_Set]
(
	@idfsSettlementID					BIGINT			= NULL	OUTPUT--##PARAM @idfsSettlement - settlement ID
	,@strSettlementCode					NVARCHAR(200)	= NULL
	,@strEnglishName					NVARCHAR(200)	= NULL	--##PARAM @strEnglishName - settlement name in English
	,@idfsSettlementType				BIGINT			= NULL	--##PARAM @idfsSettlementType - settlement Type, reference to rftSettlementType (19000083)
	,@LocationUserControlidfsCountry	BIGINT			= NULL	--##PARAM @idfsCountry -  settlement country
	,@LocationUserControlidfsRegion		BIGINT			= NULL	--##PARAM @idfsRegion - settlement region
	,@LocationUserControlidfsRayon		BIGINT			= NULL	--##PARAM @idfsRayon - settlement rayon
	,@LocationUserControlstrLatitude	FLOAT			= NULL	--##PARAM @dblLatitude - settlement latitude
	,@LocationUserControlstrLongitude	FLOAT			= NULL	--##PARAM @dblLongitude - settlement longitude
	,@LocationUserControlstrElevation	INT				= NULL
	,@LangID							VARCHAR(50)		= NULL	--##PARAM @LangID - language ID
	,@strNationalName					NVARCHAR(200)	= NULL	--##PARAM @strNationalName - settlement name in language defined by @LangID
)
AS 
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0
BEGIN

	BEGIN TRY  	

		BEGIN TRANSACTION

		IF NOT EXISTS(SELECT idfsGISBaseReference FROM dbo.gisBaseReference WHERE idfsGISBaseReference = @idfsSettlementID)
			BEGIN
			  
				BEGIN
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'gisBaseReference', @idfsSettlementID OUTPUT
				END

					  
				BEGIN
  					INSERT 
					INTO dbo.gisBaseReference
						(
							idfsGISBaseReference
							,idfsGISReferenceType
							,strDefault
						)
					VALUES
						(
							@idfsSettlementID
							,19000004
							,@strEnglishName
						)
				END

				IF NOT EXISTS(SELECT idfsSettlement FROM dbo.gisSettlement WHERE idfsSettlement = @idfsSettlementID)

					BEGIN
						INSERT 
						INTO dbo.gisSettlement
							(
								idfsSettlement
								,strSettlementCode
								,idfsSettlementType 
								,idfsCountry
								,idfsRegion
								,idfsRayon 
								,dblLongitude
								,dblLatitude 
								,intElevation
							)
						VALUES 
							(
								@idfsSettlementID
								,@strSettlementCode
								,@idfsSettlementType
								,@LocationUserControlidfsCountry
								,@LocationUserControlidfsRegion
								,@LocationUserControlidfsRayon 
								,@LocationUserControlstrLongitude
								,@LocationUserControlstrLatitude 
								,@LocationUserControlstrElevation
							)
					END

			END
		ELSE
			BEGIN
				BEGIN
					UPDATE	dbo.gisBaseReference
					SET		strDefault = @strEnglishName
					WHERE	idfsGISBaseReference = @idfsSettlementID
					AND		ISNULL(@strEnglishName,N'') <> ISNULL(strDefault,N'')
				END

				BEGIN
					UPDATE	dbo.gisSettlement
					SET		strSettlementCode = @strSettlementCode
							,idfsSettlementType = @idfsSettlementType
							,idfsCountry = @LocationUserControlidfsCountry
							,idfsRegion = @LocationUserControlidfsRegion
							,idfsRayon = @LocationUserControlidfsRayon
							,dblLongitude = @LocationUserControlstrLongitude
							,dblLatitude = @LocationUserControlstrLatitude
							,intElevation = @LocationUserControlstrElevation
					WHERE	idfsSettlement = @idfsSettlementID
				END
			END

			-- Insert/Updated gisStringNamme Translation for english name
			IF @strEnglishName IS NOT NULL AND NOT EXISTS(SELECT idfsGISBaseReference from dbo.gisStringNameTranslation WHERE idfsGISBaseReference = @idfsSettlementID AND idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET('en'))
				BEGIN
					INSERT 
					INTO dbo.gisStringNameTranslation
						(
							idfsGISBaseReference
							,idfsLanguage
							,strTextString
						)
					VALUES 
						(
							@idfsSettlementID
							,dbo.FN_GBL_LANGUAGECODE_GET('en')
							,@strEnglishName
						)
				END
			ELSE
				BEGIN
					UPDATE	dbo.gisStringNameTranslation
					SET		strTextString = @strEnglishName
					WHERE	idfsGISBaseReference = @idfsSettlementID 
					AND 	idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET('en')
					AND 	ISNULL(@strEnglishName,N'') <> ISNULL(strTextString,N'')
				END

			-- Insert/Updated gisStringNamme Translation for national name
			IF @strNationalName IS NOT NULL AND NOT EXISTS(SELECT idfsGISBaseReference from dbo.gisStringNameTranslation WHERE idfsGISBaseReference = @idfsSettlementID AND idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET(@LangID))
				BEGIN
					INSERT 
					INTO dbo.gisStringNameTranslation
						(
							idfsGISBaseReference
							,idfsLanguage
							,strTextString
						)
					VALUES 
						(
							@idfsSettlementID
							,dbo.FN_GBL_LANGUAGECODE_GET(@LangID)
							,@strNationalName
						)	
				END
			ELSE
				BEGIN
					UPDATE	dbo.gisStringNameTranslation
					SET		strTextString = @strNationalName
					WHERE	idfsGISBaseReference = @idfsSettlementID 
					AND 	idfsLanguage = dbo.FN_GBL_LANGUAGECODE_GET(@LangID)
					AND 	ISNULL(@strNationalName,N'') <> ISNULL(strTextString,N'')
				END


		IF @@TRANCOUNT > 0 		
			COMMIT  

		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH  

		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK

				SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
				SELECT @returnCode, @returnMsg
			END

	END CATCH; 
END



