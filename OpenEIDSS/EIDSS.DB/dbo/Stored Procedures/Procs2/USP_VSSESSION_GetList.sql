
--*************************************************************
-- Name 				: USP_VSSESSION_GetList
-- Description			: List All Vector Surveillance Session data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- EXEC USP_VSSESSION_GetList('en')
--*************************************************************

CREATE PROCEDURE [dbo].[USP_VSSESSION_GetList]
(
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @ReturnMsg VARCHAR(MAX)
	SELECT	@ReturnMsg = ''
	DECLARE @ReturnCode BIGINT

	BEGIN TRY  	

	SELECT		idfVectorSurveillanceSession,
				strSessionID,
				strVectors,  
				strVectorTypeIds,
				strDiagnoses,
				--vss.strDescription,
				strFieldSessionID,
				strVSStatus,
				idfsVectorSurveillanceStatus,  
				strCountry,
				idfsCountry,
				strRegion,
				idfsRegion,
				strRayon,
				idfsSettlement,
				strSettlement,  
				idfsRayon,
				dblLatitude,
				dblLongitude,
				datStartDate,
				datCloseDate,  
				idfOutbreak,
				idfLocation,
				idfsSite
		FROM	dbo.FN_VSSESSION_GetList(@LangID) 

		SELECT 0, 'Success'

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @ReturnCode = ERROR_NUMBER()
			SET @ReturnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @ReturnMsg
		END

	END CATCH;
END
