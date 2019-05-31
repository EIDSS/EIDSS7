
-- ================================================================================================
-- Name: USP_ADMIN_FF_SectionForAggregateCase_GET
-- Description:	Select actual special section for Aggregate case
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_SectionForAggregateCase_GET] 
(	
	@idfsFormTemplate BIGINT = NULL
	,@idfsFormType BIGINT = NULL	
)
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE
		@idfsCountry BIGINT,
		@idfsActualFormTemplate BIGINT,
		@idfFormType_ BIGINT,
		@idfsSection BIGINT,
		@idfsMatrixType BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
	
		SELECT @idfsSection = NULL, @idfsMatrixType = NULL;
	
		SELECT @idfsCountry = dbo.FN_GBL_CURRENTCOUNTRY_GET()
	
		IF @idfsFormTemplate IS NULL

			Declare @TempTable as Table
			(
				idfsFormTemplate BIGINT,
				isUNITemplate	BIT
			)

			INSERT INTO @TempTable
			EXEC USP_ADMIN_FF_ActualTemplate_GET @idfsCountry, NULL, @idfsFormType, 0

			SET @idfsFormTemplate = (SELECT TOP 1 idfsFormTemplate from @TempTable)
	
		IF (@idfsFormTemplate IS NOT NULL)
			BEGIN
				SELECT @idfFormType_ = idfsFormType
				FROM dbo.ffFormTemplate
				WHERE idfsFormTemplate = @idfsFormTemplate
				
				SELECT TOP 1 @idfsSection = S.idfsSection, @idfsMatrixType = S.idfsMatrixType
				FROM dbo.ffSection S
				INNER JOIN dbo.trtMatrixType MT
				ON S.idfsMatrixType = MT.idfsMatrixType
				   AND MT.idfsFormType = @idfFormType_
				   AND MT.intRowStatus = 0
				INNER JOIN dbo.ffSectionForTemplate ST
				ON S.idfsSection = ST.idfsSection
				   AND ST.idfsFormTemplate = @idfsFormTemplate
				   AND ST.intRowStatus = 0
				WHERE S.idfsParentSection IS NULL

				SELECT @idfsSection as idfsSection, @idfsMatrixType as idfsMatrixType

			END
	END TRY
	BEGIN CATCH

		THROW;
	END CATCH
END


