
--##SUMMARY Checks data validation for AVRLayout object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS 0 if all internal validation procedures returns no errors
--##RETURNS 1 if some internal validation procedures returns errors

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT
EXEC @Result = spAVRLayout_Validate @ID

Print @Result

*/

CREATE PROCEDURE [dbo].[spAVRLayout_Validate]
	@RootId BIGINT	--##PARAM @RootId - AVRLayout ID
AS
	EXEC spAVRLayout_ValidateForeignKeys @RootId
	
	IF (SELECT @@ROWCOUNT) > 0
		RETURN 1

	RETURN 0

