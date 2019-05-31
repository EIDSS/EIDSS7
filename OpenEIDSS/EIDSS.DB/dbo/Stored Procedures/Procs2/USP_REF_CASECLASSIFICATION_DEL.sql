-- ============================================================================
-- Name: USP_REF_CASECLASSIFICATION_DEL
-- Description:	Removes a case classification from the active list.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/03/2018	Initial release.
-- Ricky Moss		12/12/2018	Removed return code
-- Ricky Moss		12/19/2018	Merge CANDEL and DEL stored procedures
-- Ricky Moss		01/02/2019	Added deleteAnyway paramater
--
-- exec USP_REF_CASECLASSIFICATION_DEL 12137920000000, 0
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_CASECLASSIFICATION_DEL]
(
	@idfsCaseClassification BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnCode			INT				= 0 
DECLARE	@returnMsg			NVARCHAR(max)	= 'SUCCESS' 

BEGIN
	 BEGIN TRY
		IF NOT EXISTS(SELECT idfVetCase FROM tlbVetCase WHERE idfsCaseClassification = @idfsCaseClassification) OR @deleteAnyway = 1
		BEGIN
			UPDATE trtCaseClassification SET intRowStatus = 1 
				WHERE idfsCaseClassification = @idfsCaseClassification 
				and intRowStatus = 0

			UPDATE trtBaseReference SET intRowStatus = 1 
				WHERE idfsBaseReference = @idfsCaseClassification 
				AND intRowStatus = 0

			UPDATE trtStringNameTranslation SET intRowStatus = 1
				WHERE idfsBaseReference = @idfsCaseClassification
		END
		ELSE IF EXISTS(SELECT idfVetCase FROM tlbVetCase WHERE idfsCaseClassification = @idfsCaseClassification)
		BEGIN
			SELECT @returnCode = -1
			SELECT @returnMsg = 'IN USE'
		END
		SELECT @returnCode AS ReturnCode, @returnMsg as ReturnMessage
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END