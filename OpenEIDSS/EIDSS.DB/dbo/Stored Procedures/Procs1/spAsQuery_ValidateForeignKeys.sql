
--##SUMMARY Checks foreign keys for AsQuery object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAsQuery_ValidateForeignKeys @ID
*/
CREATE PROCEDURE [dbo].[spAsQuery_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AsQuery ID
AS
	EXEC spValidateForeignKeys 'tasQuery', @RootId, 'AVR Query'


