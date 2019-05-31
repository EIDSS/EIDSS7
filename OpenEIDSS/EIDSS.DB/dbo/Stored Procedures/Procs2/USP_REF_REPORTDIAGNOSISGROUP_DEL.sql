-- ============================================================================
-- Name: USP_REF_CaseClassification_DEL
-- Description:	Get the Case Classification for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/25/2018	Initial release.
-- Ricky Moss		01/16/2019	Merged with USP_REF_REPORTDIAGNOSISGROUP_CANDEL stored procedure

-- exec USP_REF_REPORTDIAGNOSISGROUP_DEL 55615180000016
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_REPORTDIAGNOSISGROUP_DEL]
(
	@idfsReportDiagnosisGroup BIGINT,
	@deleteAnyway BIT = 0
)as

Begin
 BEGIN TRY
 	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	IF NOT EXISTS(SELECT idfDiagnosisToGroupForReportType FROM trtDiagnosisToGroupForReportType where idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup) OR @deleteAnyway = 1
	BEGIN
	UPDATE trtReportDiagnosisGroup SET intRowStatus = 1
		WHERE idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
		and intRowStatus = 0

	UPDATE trtBaseReference SET intRowStatus = 1 
		WHERE idfsBaseReference = @idfsReportDiagnosisGroup
		AND intRowStatus = 0

	UPDATE trtStringNameTranslation SET intRowStatus = 1
		WHERE idfsBaseReference = @idfsReportDiagnosisGroup
	END
	ELSE IF EXISTS(SELECT idfDiagnosisToGroupForReportType FROM trtDiagnosisToGroupForReportType where idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup)
	BEGIN
		SELECT @returnMsg = 'IN USE'
		SELECT @returnCode = -1
	END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
END TRY
BEGIN CATCH
	THROW;
END CATCH
end
