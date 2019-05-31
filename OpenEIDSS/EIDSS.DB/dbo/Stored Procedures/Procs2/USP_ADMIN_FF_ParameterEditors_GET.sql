
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterEditors_GET
-- Description: Returns the List of Parameter Editors
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterEditors_GET]
(
	@LangID NVARCHAR(50) = NULL	
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

		SELECT idfsReference AS [idfsEditor]
			   ,ISNULL(FR.[name], FR.[strDefault]) AS [name]
			   ,CASE idfsReference WHEN 10067008/*'editText'*/ 
								   THEN 0
								   WHEN 10067002/*'editCombo'*/
								   THEN 1
								   WHEN 10067001/*'editCheck'*/
								   THEN 2
								   WHEN 10067003/*'editDate'*/
								   THEN 3
								   WHEN 10067004/*'editDateTime'*/
								   THEN 4
								   WHEN 10067006/*'editMemo'*/
								   THEN 5
								   WHEN 10067009/*'editUpDown'*/
								   THEN 6
				END AS [intEditor]
		FROM FN_GBL_Reference_List_GET(@LangID, 19000067 /*'rftParameterEditorType'*/) AS FR	
		--WHERE
		--idfsEditorID In ('editText', 'editCombo',	'editCheck', 'editDate', 'editDateTime','editMemo','editTextIntOnly')


		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END


