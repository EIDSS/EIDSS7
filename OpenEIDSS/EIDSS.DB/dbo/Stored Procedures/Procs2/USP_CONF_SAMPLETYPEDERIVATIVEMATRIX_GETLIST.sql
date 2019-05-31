--==============================================================================================================================================
-- EXEC USP_CONF_SAMPLETYPEDERIVATIVEMATRIX_GETLIST 'en'
--==============================================================================================================================================
ALTER PROCEDURE USP_CONF_SAMPLETYPEDERIVATIVEMATRIX_GETLIST
(
	@langId NVARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		SELECT idfDerivativeForSampleType, idfsSampleType, sbr.name AS strSampleType, idfsDerivativeType, dbr.name AS strDerivative FROM trtDerivativeForSampleType dst
		JOIN FN_GBL_Reference_GETList(@langId,19000087) sbr ON dst.idfsSampleType = sbr.idfsReference
		JOIN FN_GBL_Reference_GETList('en',19000087) dbr ON dst.idfsDerivativeType = dbr.idfsReference
		WHERE dst.intRowStatus = 0
		ORDER BY sbr.name, dbr.name
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END