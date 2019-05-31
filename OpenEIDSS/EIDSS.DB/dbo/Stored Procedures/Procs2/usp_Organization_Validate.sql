


--##SUMMARY Checks data validation for Organization object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS 0 if all internal validation procedures returns no errors
--##RETURNS 1 if some internal validation procedures returns errors

-- renamed to usp_ from sp by MCW

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = spOrganization_Validate @ID

Print @Result

*/

CREATE PROCEDURE [dbo].[usp_Organization_Validate]
	@RootId BIGINT	--##PARAM @RootId - Organization ID
AS
    -- renamed sp to usp_
	EXEC usp_Organization_ValidateForeignKeys @RootId
	
	IF (SELECT @@ROWCOUNT) > 0
		RETURN 1

	RETURN 0


