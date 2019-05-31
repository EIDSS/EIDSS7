
--##SUMMARY Checks foreign keys for Person object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spPerson_ValidateForeignKeys @ID
*/
CREATE PROCEDURE [dbo].[spPerson_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Person ID
AS
	EXEC spValidateForeignKeys 'tlbPerson', @RootId, 'Employee'
