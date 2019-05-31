-- =================================================================================================================
-- Name:		USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_GETLIST
-- Description:	Returns a list of vector type to field test matrices given a language and age group id
-- Author:		Ricky Moss
--
-- Revision History:
-- Name:			Date:		Revision:
-- --------------- -----------  ---------------------------------------------
-- Ricky Moss		04/03/2019	Initial Release
--
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_GETLIST 'en', 15300001100
-- EXEC USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_GETLIST 'en', 51529290000000
-- =================================================================================================================
CREATE PROCEDURE USP_CONF_AGEGROUPSTATISTICALAGEGROUPMATRIX_GETLIST
(
	@langId NVARCHAR(10),
	@idfsDiagnosisAgeGroup BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT idfDiagnosisAgeGroupToStatisticalAgeGroup, idfsDiagnosisAgeGroup, dagbr.name as strDiagnosisAgeGroupName, idfsStatisticalAgeGroup, sagbr.name as strStatisticalAgeGroupName FROM trtDiagnosisAgeGroupToStatisticalAgeGroup dagsag
		JOIN FN_GBL_Reference_GETList(@langId, 19000146) dagbr
		ON dagsag.idfsDiagnosisAgeGroup = dagbr.idfsReference
		JOIN FN_GBL_Reference_GETList(@langId, 19000145) sagbr
		ON dagsag.idfsStatisticalAgeGroup = sagbr.idfsReference
		WHERE dagsag.intRowStatus = 0 AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END