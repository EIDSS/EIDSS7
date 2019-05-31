
--*************************************************************
-- Name 				:USP_VCTS_VECT_GetSampleType
-- Description			: Get Vector Surveillance Vector Sample Type from Vector Type
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
/*
--Example of a call of procedure:

--*************************************************************
*/
CREATE PROCEDURE[dbo].[USP_VCTS_VECT_GetSampleType]
(		
	@idfsVectorType BIGINT,--##PARAM @idfVectorSurveillanceSession - AS session ID
	@idfsSampleType BIGINT OUTPUT,
	@idfsstrSampleType VARCHAR(50) OUTPUT,
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

			SELECT @idfsSampleType = tstfvt.idfsSampletype, @idfsstrSampleType = tbr.strDefault
			FROM trtSampleType tst 
			JOIN trtBaseReference tbr ON
				tbr.idfsBaseReference = tst.idfsSampleType
				AND tbr.intRowStatus = 0
				AND tbr.intHACode = 128
			JOIN trtSampleTypeForVectorType tstfvt ON
				tstfvt.idfsSampleType = tst.idfsSampleType
				AND tstfvt.intRowStatus = 0
				WHERE tstfvt.idfsVectorType = @idfsVectorType
		
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
