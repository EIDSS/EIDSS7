
--##SUMMARY Checks foreign keys for Query object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAVRQuery_Validate @ID
*/

CREATE PROCEDURE [dbo].[spAVRQuery_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Query ID
AS
	EXEC spValidateKeys 'tasQuery', @RootId, 'AVR Query'

