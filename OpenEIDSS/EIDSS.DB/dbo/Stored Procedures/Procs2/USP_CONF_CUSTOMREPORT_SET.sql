-- =========================================================================================
-- NAME: USP_CONF_CUSTOMREPORT_SET
-- DESCRIPTION: Creates a custom report item

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/21/2019	Initial Release
--
-- exec USP_CONF_CUSTOMREPORT_SET 55540680000323
-- =========================================================================================
ALTER PROCEDURE USP_CONF_CUSTOMREPORT_SET
(
	@idfReportRows BIGINT = NULL,
	@idfsCustomReportType BIGINT,
	@idfsDiagnosisOrReportDiagnosisGroup BIGINT,
	@idfsReportAdditionalText BIGINT,
	@idfsICDReportAdditionalText BIGINT
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
	IF (EXISTS(SELECT idfReportRows FROM trtReportRows WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 0) AND @idfReportRows IS NULL) OR
	   (EXISTS(SELECT idfReportRows FROM trtReportRows WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 0 AND idfReportRows <> @idfReportRows) AND @idfReportRows IS NOT NULL) 
	BEGIN
		SELECT @returnCode = 1
		SELECT @returnMsg = 'DOES EXIST'
		SELECT @idfReportRows = (SELECT idfReportRows FROM trtReportRows WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 0)
	END
	ELSE IF(EXISTS(SELECT idfReportRows FROM trtReportRows WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 1) AND @idfReportRows IS NULL)
	BEGIN
		UPDATE trtReportRows SET intRowStatus = 0 WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 1
		SELECT @idfReportRows = (SELECT idfReportRows FROM trtReportRows WHERE idfsCustomReportType = @idfsCustomReportType AND idfsDiagnosisOrReportDiagnosisGroup = @idfsDiagnosisOrReportDiagnosisGroup AND idfsICDReportAdditionalText = @idfsICDReportAdditionalText AND idfsReportAdditionalText = @idfsReportAdditionalText AND intRowStatus = 0)
	END
	ELSE
	BEGIN
	INSERT INTO @SupressSelect
		EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtReportRows', @idfReportRows OUTPUT;

		INSERT INTO trtReportRows (idfReportRows, idfsCustomReportType, idfsDiagnosisOrReportDiagnosisGroup, idfsReportAdditionalText, idfsICDReportAdditionalText, intRowStatus) VALUES (@idfReportRows, @idfsCustomReportType, @idfsDiagnosisOrReportDiagnosisGroup, @idfsReportAdditionalText, @idfsICDReportAdditionalText, 0)
	END
	SELECT @returnCode 'returnCode', @returnMsg 'returnMsg', @idfReportRows 'idfsReportRows'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END

Select * from trtReportRows