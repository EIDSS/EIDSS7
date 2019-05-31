
--##SUMMARY Checks foreign keys for Vector object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spVector_Validate @ID
*/

CREATE PROCEDURE [dbo].[spVector_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Vector ID
AS
	EXEC spValidateKeys 'tlbVector', @RootId, NULL

