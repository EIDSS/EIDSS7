
--##SUMMARY Checks foreign keys for Person object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spEmployee_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spEmployee_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Person ID
AS
	EXEC spValidateForeignKeys 'tlbPerson', @RootId, 'Employee'

