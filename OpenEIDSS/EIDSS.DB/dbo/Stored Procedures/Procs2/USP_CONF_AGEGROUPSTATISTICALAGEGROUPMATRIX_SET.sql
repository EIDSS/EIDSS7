-- ==========================================================================================
-- Name:		USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_SET
-- Description:	Creates/updates an age group to statistical age group matrix
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/03/2019	Initial Release
--
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_SET NULL, 15300001100, 51529190000000
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_SET NULL, 15300001100, 51529060000000
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_SET 51528390000001, 15300001100, 51529190000000
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_SET
(
	@idfDiagnosisAgeGroupToStatisticalAgeGroup BIGINT = NULL,
	@idfsDiagnosisAgeGroup BIGINT,
	@idfsStatisticalAgeGroup BIGINT
)
AS
	DECLARE @returnCode	   INT = 0  
	DECLARE	@returnMsg	   NVARCHAR(max) = 'SUCCESS' 
	DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup AND intRowStatus = 0) AND @idfDiagnosisAgeGroupToStatisticalAgeGroup IS NULL) OR (EXISTS(SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup AND idfDiagnosisAgeGroupToStatisticalAgeGroup <> @idfDiagnosisAgeGroupToStatisticalAgeGroup AND intRowStatus = 0) AND @idfDiagnosisAgeGroupToStatisticalAgeGroup IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @idfDiagnosisAgeGroupToStatisticalAgeGroup = (SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup AND intRowStatus = 0)
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS(SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup AND intRowStatus = 1) AND @idfDiagnosisAgeGroupToStatisticalAgeGroup IS NULL
			UPDATE trtDiagnosisAgeGroupToStatisticalAgeGroup SET intRowStatus = 0 WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup
		ELSE IF EXISTS(SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup AND intRowStatus = 0) AND @idfDiagnosisAgeGroupToStatisticalAgeGroup IS NOT NULL
			UPDATE trtDiagnosisAgeGroupToStatisticalAgeGroup SET idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtDiagnosisAgeGroupToStatisticalAgeGroup', @idfDiagnosisAgeGroupToStatisticalAgeGroup OUTPUT

			INSERT INTO trtDiagnosisAgeGroupToStatisticalAgeGroup (idfDiagnosisAgeGroupToStatisticalAgeGroup, idfsDiagnosisAgeGroup, idfsStatisticalAgeGroup, intRowStatus) VALUES (@idfDiagnosisAgeGroupToStatisticalAgeGroup, @idfsDiagnosisAgeGroup, @idfsStatisticalAgeGroup, 0)
			INSERT INTO trtDiagnosisAgeGroupToStatisticalAgeGroupToCP (idfDiagnosisAgeGroupToStatisticalAgeGroup, idfCustomizationPackage) VALUES (@idfDiagnosisAgeGroupToStatisticalAgeGroup, dbo.FN_GBL_CustomizationPackage_GET())
		END

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfDiagnosisAgeGroupToStatisticalAgeGroup 'idfDiagnosisAgeGroupToStatisticalAgeGroup'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END