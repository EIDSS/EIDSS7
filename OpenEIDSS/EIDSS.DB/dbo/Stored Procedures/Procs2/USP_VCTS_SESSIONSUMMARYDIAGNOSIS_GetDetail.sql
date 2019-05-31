--*************************************************************
-- Name 				: USP_VCTS_SESSIONSUMMARYDIAGNOSIS_GetDetail
-- Description			: Get Vector Surveillance Session Summary Diagnosis Details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_VCTS_SESSIONSUMMARYDIAGNOSIS_GetDetail @idfsVSSessionSummary,'en'
--*************************************************************
CREATE  PROCEDURE [dbo].[USP_VCTS_SESSIONSUMMARYDIAGNOSIS_GetDetail]
(
	@idfsVSSessionSummary	BIGINT,--##PARAM @idfVectorSurveillanceSession - session ID
	@LangID					NVARCHAR(50)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

		SELECT		Vssd.[idfsVSSessionSummaryDiagnosis]
					,Vssd.[idfsVSSessionSummary]
					,Vssd.[idfsDiagnosis]     
					,D.name AS [strDiagnosis]
					,Vssd.[intPositiveQuantity]
					,Vssd.[intRowStatus]
		FROM		dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd
		INNER JOIN	dbo.FN_GBL_Reference_GETList(@LangID, 19000019) D ON Vssd.[idfsDiagnosis] = D.idfsReference 
		WHERE		Vssd.idfsVSSessionSummary  = @idfsVSSessionSummary And Vssd.intRowStatus = 0	  	
	
		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 

			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
	END CATCH
END

