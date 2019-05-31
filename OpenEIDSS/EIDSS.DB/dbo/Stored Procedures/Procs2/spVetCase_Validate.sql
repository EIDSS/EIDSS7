
--##SUMMARY Checks data validation for VetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 27.05.2015

--##RETURNS 0 if all internal validation procedures returns no errors
--##RETURNS 1 if some internal validation procedures returns errors

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = spVetCase_Validate @ID

Print @Result

*/

CREATE PROCEDURE [dbo].[spVetCase_Validate]
	@RootId BIGINT	--##PARAM @RootId - VetCase ID
AS

	DECLARE @VetCaseType BIGINT	SELECT 
		@VetCaseType = idfsCaseType
	FROM tlbVetCase 
	WHERE idfVetCase = @RootId
	
	
	IF @VetCaseType = 10012004 /*Avian*/
	BEGIN
		EXEC spAvianVetCase_ValidateForeignKeys @RootId	
		IF (SELECT @@ROWCOUNT) > 0
			RETURN 1
	END
	ELSE 
		IF @VetCaseType = 10012003 /*Livestock*/
		BEGIN
			EXEC spLivestockVetCase_ValidateForeignKeys @RootId	
			IF (SELECT @@ROWCOUNT) > 0
				RETURN 1
		END

	RETURN 0

