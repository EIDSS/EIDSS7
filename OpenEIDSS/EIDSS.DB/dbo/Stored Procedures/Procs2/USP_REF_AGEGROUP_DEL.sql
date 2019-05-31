-- ============================================================================
-- Name: USP_REF_AGEGROUP_DEL
-- Description:	Removes the Age Group from the active reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/03/2018	Initial release.
-- Ricky Moss		12/12/2018	Removed return codes
-- Ricky Moss		01/02/2019	Added deleteAnyway parameters and added return codes
-- Ricky Moss		01/03/2019	Refactor to determine if record is in use
--
-- exec USP_REF_AGEGROUP_DEL 55615180000031, 0
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_AGEGROUP_DEL]
(
	@idfsAgeGroup BIGINT,
	@deleteAnyway BIT
)
AS
BEGIN
DECLARE @returnCode			INT				= 0 
DECLARE	@returnMsg			NVARCHAR(max)	= 'SUCCESS' 

	BEGIN TRY
		IF (NOT EXISTS(SELECT idfsDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup) AND
			NOT EXISTS(SELECT idfsStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup)) OR @deleteAnyway = 1
			BEGIN
				UPDATE trtDiagnosisAgeGroup SET intRowStatus = 1
					WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup 
					AND intRowStatus = 0

				UPDATE trtBaseReference SET intRowStatus = 1 
					WHERE idfsBaseReference = @idfsAgeGroup
					AND intRowStatus = 0

				UPDATE trtStringNameTranslation SET intRowStatus = 1
					WHERE idfsBaseReference = @idfsAgeGroup
			END
		ELSE IF (EXISTS(SELECT idfsDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup) OR
				EXISTS(SELECT idfsStatisticalAgeGroup FROM trtDiagnosisAgeGroupToStatisticalAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup))
			BEGIN
				SELECT @returnCode = -1
				SELECT @returnMsg = 'IN USE'
			END

			SELECT @returnCode AS ReturnCode, @returnMsg AS ReturnMessage
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END