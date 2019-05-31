

-- ================================================================================================
-- Name: USP_ADMIN_FF_CurrentMatrixVersion_GET
-- Description: ----Current matrix version
----We select latest matrix version as default current versione. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    1/2/2019 Initial release for new API.
-- ================================================================================================
-- Human Case Matrxi : use : 71190000000

CREATE PROCEDURE [dbo].[USP_ADMIN_FF_CurrentMatrixVersion_GET]
(
		@idfsMatrixType BIGINT
)
AS
BEGIN
	BEGIN TRY 
		SELECT TOP 1
				idfVersion
			  ,idfsMatrixType as idfsAggrCaseSection
			  ,MatrixName
			  ,datStartDate 
			  ,blnIsActive
			  ,blnIsDefault
		FROM tlbAggrMatrixVersionHeader
		WHERE idfsMatrixType = @idfsMatrixType -- 71190000000 /*Human case matrix*/
		AND intRowStatus = 0
		ORDER BY cast(isnull(blnIsDefault,0) as int)+cast(isnull(blnIsActive,0) as int) desc, datStartDate desc

	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END






