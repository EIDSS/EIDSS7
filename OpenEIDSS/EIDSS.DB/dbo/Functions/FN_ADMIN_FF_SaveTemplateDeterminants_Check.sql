
-- ================================================================================================
-- Name: [FN_ADMIN_FF_SaveTemplateDeterminants_Check] 
-- Description: Save Template Determinant Check
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE FUNCTION [dbo].[FN_ADMIN_FF_SaveTemplateDeterminants_Check] 
(
	@idfsFormTemplate BIGINT	
	,@determinantList NVARCHAR(600)
)
RETURNS @ResultTable TABLE
(
	[ErrorMessage] NVARCHAR(400)	COLLATE database_default
)
AS
BEGIN
	
	DECLARE 
		@Country BIGINT,
		@idfsFormType BIGINT,
		@ErrorMessage NVARCHAR(400)		
	
	SELECT TOP 1 @Country = CAST([Value] AS BIGINT)
	FROM [dbo].[fnsysSplitList](@determinantList, NULL, NULL)

	SELECT @idfsFormType = [idfsFormType]
	FROM dbo.ffFormTemplate
	WHERE idfsFormTemplate = @idfsFormTemplate
	
	IF EXISTS(SELECT TOP 1 1 
			  FROM dbo.ffDeterminantValue DV
	          WHERE idfsFormTemplate IN (SELECT DISTINCT idfsFormTemplate
										 FROM dbo.ffFormTemplate FT 
										 WHERE idfsFormType = @idfsFormType 
											   AND idfsFormTemplate <> @idfsFormTemplate)
			  AND DV.idfsGISBaseReference = @Country)
		BEGIN
			SET @ErrorMessage = 'Determinant_Save_Has_Not_Unique_UNI';
		END	
	
	INSERT INTO @ResultTable(ErrorMessage)
	VALUES (@ErrorMessage);	
	
	RETURN;
END
