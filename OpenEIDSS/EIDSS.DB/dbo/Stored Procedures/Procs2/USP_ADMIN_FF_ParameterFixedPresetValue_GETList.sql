
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterFixedPresetValue_GETList
-- Description: Returns all Fixed Preset Values based on the idfsParameterType if not parameter is entered it will return all. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterFixedPresetValue_GETList] 
(	
	@idfsParameterType BIGINT = NULL
	,@LangID NVARCHAR(50) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL) 
		SET @LangID = 'en';	

	DECLARE
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY
	
		SELECT FPV.idfsParameterFixedPresetValue 
			   ,FPV.idfsParameterType
			   ,FR.strDefault AS [DefaultName]
			   ,ISNULL(FR.LongName, FR.strDefault) AS [NationalName]
			   ,@LangID AS [langid]
			   ,FR.intOrder
		FROM dbo.ffParameterFixedPresetValue FPV
		INNER JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000069 /*'rftParametersFixedPresetValue'*/) FR 
		ON FPV.idfsParameterFixedPresetValue = FR.idfsReference
		WHERE (FPV.idfsParameterType = @idfsParameterType
			   OR @idfsParameterType IS NULL) 
			  AND FPV.intRowStatus = 0
		ORDER BY [intOrder],[NationalName]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
