
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTypes_GETList
-- Description: Lists all Parameter Types.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTypes_GETList] 
(
	@LangID NVARCHAR(50) = NULL
	,@idfsParameterType BIGINT = NULL
	,@OnlyLists BIT = NULL	
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
		SELECT idfsParameterType	
			   ,RT.strDefault AS [DefaultName]
			   ,ISNULL(RT.name, RT.strDefault) AS [NationalName]
			   ,PT.idfsReferenceType
			   ,CASE ISNULL(PT.idfsReferenceType, -1) WHEN -1 
													  THEN '2'
													  WHEN 19000069 /*'rftParametersFixedPresetValue'*/
													  THEN '0'
													  ELSE '1'
			    END AS [System]
			   ,@LangID AS [LangID]
		FROM dbo.ffParameterType AS PT
		LEFT JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000071 /*'rftParameterType'*/) AS RT
		ON RT.idfsReference = PT.idfsParameterType
		WHERE (PT.idfsParameterType = @idfsParameterType OR @idfsParameterType IS NULL)
			  AND (PT.intRowStatus = 0)
			  AND (@OnlyLists IS NULL OR (@OnlyLists IS NOT NULL AND PT.idfsReferenceType IS NOT NULL))
		ORDER BY [NationalName]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
