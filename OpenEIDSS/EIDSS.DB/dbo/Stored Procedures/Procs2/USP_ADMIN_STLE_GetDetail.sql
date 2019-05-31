
--*************************************************************
-- Name 				: USP_ADMIN_STLE_GetDetail
-- Description			: Get Settlement details
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_ADMIN_STLE_GetDetail 222060000000,'en'
--*************************************************************

CREATE PROCEDURE [dbo].[USP_ADMIN_STLE_GetDetail]
(
 @idfsSettlementID	AS VARCHAR(36), --##PARAM @idfsSettlement - settlement ID
 @LangID				AS NVARCHAR(50) --##PARAM @LangID - language ID
)

AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

		SELECT  
			idfsSettlement As idfsSettlementID
			,strSettlementCode
			,enSettlement.[name] as strEnglishName
			,natSettlement.[name] AS strNationalName
			,idfsSettlementType
			,idfsCountry
			,idfsRegion
			,idfsRayon
			,dblLongitude As strLongitude
			,dblLatitude As strLatitude
			,intElevation As strElevation
		FROM gisSettlement
		LEFT JOIN dbo.FN_GBL_LKUP_GISBaseReference_GetList(@LangID,19000004) AS natSettlement ON
				natSettlement.idfsReference = idfsSettlement
		LEFT JOIN dbo.FN_GBL_LKUP_GISBaseReference_GetList('en',19000004) AS enSettlement ON
				enSettlement.idfsReference = idfsSettlement
		WHERE	idfsSettlement = @idfsSettlementID 

		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
END

