
-- ================================================================================================
-- Name: USP_ADMIN_FF_HACodeList_GET
-- Description: Returns List of HA Codes
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_HACodeList_GET]
(
	@LangID NVARCHAR(50) = NULL 
	,@intHACode BIGINT = NULL
	,@idfsCodeName BIGINT = NULL	
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
		SELECT HA.[intHACode]
			   ,HA.[idfsCodeName]
			   ,HA.[strNote]
			   ,HA.[rowguid]
			   ,RF.[strDefault] AS [DefaultName]
			   ,RF.[name] AS [CodeName]
			   ,RF.[LongName] AS [NationalLongName]
		FROM [dbo].[trtHACodeList] HA
		INNER JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000040 /*'rftHA_Code_List'*/) RF
		ON HA.idfsCodeName = RF.idfsReference
		WHERE HA.idfsCodeName In (10040005, 10040007, 10040003, 10040011)	
			  AND ((HA.[intHACode] = @intHACode ) OR (@intHACode IS NULL))
			  AND ((HA.[idfsCodeName] = @idfsCodeName) OR (@idfsCodeName  IS NULL))
		ORDER BY [CodeName] 
	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

