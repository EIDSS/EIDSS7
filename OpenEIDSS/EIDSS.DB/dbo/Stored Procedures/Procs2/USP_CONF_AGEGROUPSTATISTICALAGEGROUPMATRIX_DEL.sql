-- ==========================================================================================
-- Name:		USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_DEL
-- Description:	Deletes an age group to statistical age group matrix
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/03/2019	Initial Release
--
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_DEL 51528390000001, 1
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_DEL
(
	@idfDiagnosisAgeGroupToStatisticalAgeGroup BIGINT,
	@deleteAnyway BIT = 0
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		UPDATE trtDiagnosisAgeGroupToStatisticalAgeGroup SET intRowStatus = 0 WHERE idfDiagnosisAgeGroupToStatisticalAgeGroup = @idfDiagnosisAgeGroupToStatisticalAgeGroup
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END