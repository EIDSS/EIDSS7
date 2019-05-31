
--##SUMMARY Checks foreign keys for Outbreak object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spOutbreak_Validate @ID
*/

CREATE PROCEDURE [dbo].[spOutbreak_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - Outbreak ID
AS
	EXEC spValidateKeys 'tlbOutbreak', @RootId, 'Outbreak'

