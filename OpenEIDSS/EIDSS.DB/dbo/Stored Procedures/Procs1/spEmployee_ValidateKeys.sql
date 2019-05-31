
--##SUMMARY Checks foreign keys for Person object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spEmployee_Validate @ID
*/

CREATE PROCEDURE [dbo].[spEmployee_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Person ID
AS
	EXEC spValidateKeys 'tlbPerson', @RootId, 'Employee'

