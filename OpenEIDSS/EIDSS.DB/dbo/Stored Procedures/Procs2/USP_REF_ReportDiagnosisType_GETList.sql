-- ============================================================================
-- Name: USP_REF_ReportDiagnosisType_GETList
-- Description:	Get the report diagnosis types for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss     09/25/2018 Initial release.

-- exec USP_REF_ReportDiagnosisType_GETList 'en'
-- ============================================================================

CREATE PROCEDURE [dbo].[USP_REF_ReportDiagnosisType_GETList]
(
	@LangID Nvarchar(50) = Null
)
AS
Begin

SET NOCOUNT ON;

DECLARE
@returnMsg			NVARCHAR(max) = N'Success',
@returnCode			BIGINT = 0;

BEGIN TRY
	Select
		BR.idfsReference as [idfsReportDiagnosisGroup]
		,BR.strDefault as [strDefault] 
		,BR.name as [strName] 
		,DG.strCode as [strCode]		
	From [dbo].[fnReference] (@LangID, 19000130) BR
	Inner Join [dbo].[trtReportDiagnosisGroup] DG On DG.idfsReportDiagnosisGroup = BR.idfsReference and DG.intRowStatus = 0
	Order by BR.intOrder asc

			SELECT @returnCode, @returnMsg;
END TRY
BEGIN CATCH
		BEGIN
			SET					@returnCode = ERROR_NUMBER();
			SET					@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT				@returnCode, @returnMsg;
		END
END CATCH
End
