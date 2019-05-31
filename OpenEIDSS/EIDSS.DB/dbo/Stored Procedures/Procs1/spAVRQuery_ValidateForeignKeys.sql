
--##SUMMARY Checks foreign keys for Query object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRQuery_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spAVRQuery_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Query ID
AS
	EXEC spValidateForeignKeys 'tasQuery', @RootId, 'AVR Query'

